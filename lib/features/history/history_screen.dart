import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/database/transaction_repository.dart';
import '../../core/database/transaction.dart' as db;
import 'transaction_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _repository = TransactionRepository();
  List<db.Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final list = await _repository.getAllTransactions();
    if (mounted) {
      setState(() {
        _transactions = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _transactions.isEmpty
          ? const Center(child: Text('No transactions found'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                final isIncome = tx.type == 'income';
                final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(tx.timestamp);
                
                return ListTile(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetailScreen(transaction: tx))),
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
                  subtitle: Text(tx.category),
                  trailing: Text(
                    '${isIncome ? '+' : '-'}${currencyFormat.format(tx.amount)}',
                    style: TextStyle(
                      color: isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
