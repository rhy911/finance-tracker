import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/database/transaction.dart' as db;
import '../../core/database/transaction_repository.dart';
import 'widgets/statistic_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final TransactionRepository _repository = TransactionRepository();
  String _selectedPeriod = 'Month';
  String _selectedType = 'expense'; // Added _selectedType
  List<db.Transaction> _transactions = [];
  List<MapEntry<String, double>> _sortedCategories = [];
  bool _isLoading = true;

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _loadData();
    _listenToChanges();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _listenToChanges() {
    _subscription = _repository.isar.transactions.watchLazy().listen((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final now = DateTime.now();
    DateTime start;
    DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    switch (_selectedPeriod) {
      case 'Day':
        start = DateTime(now.year, now.month, now.day);
        break;
      case 'Week':
        start = now.subtract(Duration(days: now.weekday - 1));
        start = DateTime(start.year, start.month, start.day);
        break;
      case 'Month':
        start = DateTime(now.year, now.month, 1);
        break;
      case 'Year':
        start = DateTime(now.year, 1, 1);
        break;
      default:
        start = DateTime(now.year, now.month, 1);
    }

    final categoryMap = await _repository.getCategoryStatsInRange(start, end, _selectedType);
    final sorted = categoryMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final txs = await _repository.getTransactionsInRange(start, end);
    final filtered = txs.where((t) => t.type == _selectedType).toList();

    if (mounted) {
      setState(() {
        _transactions = filtered;
        _sortedCategories = sorted;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F8F8),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Statistics',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tabButton('Day'),
                  _tabButton('Week'),
                  _tabButton('Month'),
                  _tabButton('Year'),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedType,
                      items: const [
                        DropdownMenuItem(value: 'expense', child: Text('Expense')),
                        DropdownMenuItem(value: 'income', child: Text('Income')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedType = val);
                          _loadData();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 3,
                child: _isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.only(right: 16, top: 10), // Add padding for chart labels
                        child: RepaintBoundary(
                          child: StatisticChart(
                            transactions: _transactions, 
                            period: _selectedPeriod,
                            isIncome: _selectedType == 'income',
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Top Spending', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Icon(Icons.sort),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                flex: 4,
                child: _sortedCategories.isEmpty
                    ? const Center(child: Text('No data'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: _sortedCategories.length,
                        itemBuilder: (context, index) {
                          final entry = _sortedCategories[index];
                          return _buildCategoryItem(
                            entry.key,
                            entry.value,
                            _getCategoryIcon(entry.key),
                            isHighlighted: index == 0,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String title) {
    bool active = _selectedPeriod == title;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedPeriod = title);
        _loadData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF4B9A95) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(color: active ? Colors.white : Colors.grey, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name, double amount, IconData icon, {bool isHighlighted = false}) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFF2E8C87) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isHighlighted ? Colors.white.withValues(alpha: 0.2) : Colors.grey.shade200,
            child: Icon(icon, color: isHighlighted ? Colors.white : Colors.black54),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: isHighlighted ? Colors.white : Colors.black),
            ),
          ),
          Text(
            '${_selectedType == 'income' ? '+' : '-'}${currencyFormat.format(amount)}',
            style: TextStyle(
              color: isHighlighted 
                ? Colors.white 
                : (_selectedType == 'income' ? Colors.green : Colors.redAccent), 
              fontWeight: FontWeight.bold, 
              fontSize: 16
            ),
          )
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food': return Icons.local_cafe;
      case 'shopping': return Icons.shopping_bag;
      case 'transport': return Icons.directions_car;
      case 'entertainment': return Icons.play_arrow;
      case 'transfer': return Icons.swap_horiz;
      default: return Icons.category;
    }
  }
}
