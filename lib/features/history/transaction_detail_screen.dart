import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/database/transaction.dart' as db;
import '../../core/database/isar_database.dart';
import '../../core/services/category_service.dart';

class TransactionDetailScreen extends StatefulWidget {
  final db.Transaction transaction;
  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final _categoryService = CategoryService();
  late String _category;
  late TextEditingController _noteController;
  final _isar = IsarDatabase.instance;
  List<String> _categories = ['Uncategorized'];

  @override
  void initState() {
    super.initState();
    _category = widget.transaction.category;
    _noteController = TextEditingController(text: widget.transaction.customNote);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final names = await _categoryService.getCategoryNames();
    if (!names.contains(_category)) names.add(_category);
    names.sort();
    if (mounted) setState(() => _categories = names);
  }

  Future<void> _save() async {
    final tx = widget.transaction;
    tx.category = _category;
    tx.customNote = _noteController.text.trim();
    tx.updatedAt = DateTime.now();

    await _isar.writeTxn(() => _isar.transactions.put(tx));
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    await _isar.writeTxn(() => _isar.transactions.delete(widget.transaction.id));
    if (mounted) Navigator.pop(context);
  }

  void _showDeleteConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to remove this record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _delete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final tx = widget.transaction;
    final isIncome = tx.type == 'income';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'), 
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red), 
            onPressed: _showDeleteConfirm,
          ),
          IconButton(icon: const Icon(Icons.check), onPressed: _save),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}${currencyFormat.format(tx.amount)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy HH:mm').format(tx.timestamp),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 48),
            _buildInfoRow('Bank', tx.bankName),
            _buildInfoRow('Description', tx.description),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              initialValue: _categories.contains(_category) ? _category : 'Uncategorized',
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            const Text('RAW CONTENT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Text(tx.rawContent, style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
