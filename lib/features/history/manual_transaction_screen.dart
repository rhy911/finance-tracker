import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/database/transaction.dart' as db;
import '../../core/database/category.dart' as cat;
import '../../core/database/transaction_repository.dart';
import '../../core/services/category_service.dart';

class ManualTransactionScreen extends StatefulWidget {
  const ManualTransactionScreen({super.key});

  @override
  State<ManualTransactionScreen> createState() => _ManualTransactionScreenState();
}

class _ManualTransactionScreenState extends State<ManualTransactionScreen> {
  final _repository = TransactionRepository();
  final _categoryService = CategoryService();
  
  String _amountStr = '0';
  String _type = 'expense';
  final DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Other';
  final TextEditingController _noteController = TextEditingController();
  List<cat.Category> _categories = [];

  final Map<String, IconData> _iconMap = {
    'restaurant': Icons.restaurant,
    'directions_car': Icons.directions_car,
    'shopping_bag': Icons.shopping_bag,
    'receipt_long': Icons.receipt_long,
    'payments': Icons.payments,
    'category': Icons.category,
    'medical_services': Icons.medical_services,
    'school': Icons.school,
    'home': Icons.home,
    'movie': Icons.movie,
    'fitness_center': Icons.fitness_center,
    'flight': Icons.flight,
    'pets': Icons.pets,
    'redeem': Icons.redeem,
    'build': Icons.build,
  };

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await _categoryService.getCategories();
    if (mounted && cats.isNotEmpty) {
      setState(() {
        _categories = cats;
        if (_categories.any((c) => c.name == _selectedCategory)) {
          // Keep current
        } else {
          _selectedCategory = _categories.first.name;
        }
      });
    }
  }

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'back') {
        if (_amountStr.length > 1) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
        } else {
          _amountStr = '0';
        }
      } else if (key == '.') {
        if (!_amountStr.contains('.')) _amountStr += '.';
      } else {
        if (_amountStr == '0') {
          _amountStr = key;
        } else if (_amountStr.length < 12) {
          _amountStr += key;
        }
      }
    });
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountStr) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter an amount')));
      return;
    }

    final tx = db.Transaction()
      ..amount = amount
      ..type = _type
      ..timestamp = _selectedDate
      ..description = _noteController.text.isEmpty ? _selectedCategory : _noteController.text
      ..bankName = 'Manual'
      ..sourcePackageName = 'manual'
      ..category = _selectedCategory
      ..rawContent = 'Manual entry'
      ..contentHash = 'manual_${DateTime.now().millisecondsSinceEpoch}'
      ..parserVersion = 0
      ..isParsedSuccessfully = true
      ..createdAt = DateTime.now();

    await _repository.saveTransaction(tx);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.decimalPattern('vi_VN');
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      resizeToAvoidBottomInset: false, 
      appBar: AppBar(
        backgroundColor: const Color(0xFF3AA39F),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Add Transaction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildDisplaySection(currencyFormat),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildTypeToggle(),
                          const SizedBox(height: 20),
                          _buildCategoryList(),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Divider(),
                          ),
                          _buildNoteField(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  _buildNumberPad(),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplaySection(NumberFormat format) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 40),
      color: const Color(0xFF3AA39F),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('AMOUNT', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              '${format.format(double.tryParse(_amountStr) ?? 0)} ₫',
              style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: _toggleItem('expense', 'Expense', Icons.arrow_upward, Colors.red),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _toggleItem('income', 'Income', Icons.arrow_downward, Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _toggleItem(String type, String label, IconData icon, Color color) {
    final isSelected = _type == type;
    return GestureDetector(
      onTap: () => setState(() => _type = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? color : Colors.transparent, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? color : Colors.grey),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isSelected ? color : Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text('CATEGORY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final catItem = _categories[index];
              final isSelected = _selectedCategory == catItem.name;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = catItem.name),
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF3AA39F) : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _iconMap[catItem.icon] ?? Icons.category,
                          size: 24,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        catItem.name, 
                        style: TextStyle(fontSize: 11, color: isSelected ? Colors.black : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoteField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextField(
        controller: _noteController,
        decoration: const InputDecoration(
          hintText: 'Add a note...',
          border: InputBorder.none,
          icon: Icon(Icons.notes, size: 20),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          _padRow(['1', '2', '3']),
          _padRow(['4', '5', '6']),
          _padRow(['7', '8', '9']),
          _padRow(['.', '0', 'back']),
        ],
      ),
    );
  }

  Widget _padRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _padButton(key)).toList(),
    );
  }

  Widget _padButton(String key) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onKeyPress(key),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 80,
          height: 60,
          alignment: Alignment.center,
          child: key == 'back' 
            ? const Icon(Icons.backspace_outlined, color: Colors.black87)
            : Text(key, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black87)),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey.shade50,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3AA39F),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
          ),
          child: const Text('Save Transaction', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
