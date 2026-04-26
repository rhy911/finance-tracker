import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/database/transaction_repository.dart';
import '../../core/database/transaction.dart' as db;
import '../../core/database/isar_database.dart';
import '../../core/services/notification_sync_service.dart';
import '../history/transaction_detail_screen.dart';
import '../history/history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = TransactionRepository();
  final _syncService = NotificationSyncService();
  StreamSubscription? _txnSubscription;
  Timer? _debounceTimer;
  List<db.Transaction> _transactions = [];
  double _totalIncome = 0;
  double _totalExpense = 0;
  double _calculatedBalance = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _listenToChanges();
    _syncService.startSync();
  }

  @override
  void dispose() {
    _txnSubscription?.cancel();
    _debounceTimer?.cancel();
    _syncService.stopSync();
    super.dispose();
  }

  void _listenToChanges() {
    _txnSubscription = IsarDatabase.instance.transactions.watchLazy().listen((_) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _loadData();
        _repository.saveToLocal();
      });
    });
  }

  Future<void> _loadData() async {
    final income = await _repository.getTotalIncome();
    final expense = await _repository.getTotalExpense();
    final latestBalance = await _repository.getLatestBalance();
    final list = await _repository.getRecentTransactions(limit: 20); 
    
    final balance = latestBalance ?? (income - expense);

    if (mounted) {
      setState(() { 
        _transactions = list; 
        _totalIncome = income; 
        _totalExpense = expense; 
        _calculatedBalance = balance;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Material(
      color: const Color(0xFFF7F7F7),
      child: Stack(
        children: [
          Container(
            height: 260,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3AA39F), Color(0xFF2E8C87)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(60, 30),
                bottomRight: Radius.elliptical(60, 30),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: RepaintBoundary(child: _HeaderSection()),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      RepaintBoundary(
                        child: _BalanceCard(
                          format: currencyFormat,
                          balance: _calculatedBalance,
                          income: _totalIncome,
                          expense: _totalExpense,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _SectionHeader(
                    title: 'Recent Transactions',
                    onSeeAll: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _transactions.isEmpty 
                      ? const Center(child: Text('No transactions yet'))
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: _transactions.length,
                          itemBuilder: (context, index) {
                            final tx = _transactions[index];
                            return _TransactionItem(transaction: tx, format: currencyFormat);
                          },
                        ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Good Afternoon';
    } else if (hour >= 18 && hour < 22) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getGreeting()}, User!',
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Icon(Icons.notifications, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final NumberFormat format;
  final double balance;
  final double income;
  final double expense;

  const _BalanceCard({
    required this.format,
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2E8C87),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
              Icon(Icons.more_horiz, color: Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            format.format(balance),
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BalanceItem(title: 'Income', amount: format.format(income), icon: Icons.arrow_downward),
              _BalanceItem(title: 'Expenses', amount: format.format(expense), icon: Icons.arrow_upward),
            ],
          )
        ],
      ),
    );
  }
}

class _BalanceItem extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;

  const _BalanceItem({required this.title, required this.amount, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 12, backgroundColor: Colors.white24, child: Icon(icon, color: Colors.white, size: 14)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        )
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final db.Transaction transaction;
  final NumberFormat format;

  const _TransactionItem({required this.transaction, required this.format});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(transaction.timestamp);
    
    return ListTile(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetailScreen(transaction: transaction))),
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isIncome ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: isIncome ? Colors.green : Colors.red,
        ),
      ),
      title: Text(
        dateStr,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(transaction.category),
      trailing: Text(
        '${isIncome ? '+' : '-'}${format.format(transaction.amount)}',
        style: TextStyle(
          color: isIncome ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text('See all', style: TextStyle(color: Colors.grey)),
          ),
      ],
    );
  }
}
