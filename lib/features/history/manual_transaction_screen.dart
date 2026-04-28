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
  final _currencyFormat = NumberFormat.decimalPattern('vi_VN');
  
  String _amountStr = '0';
  String _balanceStr = '0';
  String _activeField = 'amount'; // 'amount' or 'balance'
  bool _isBankTransaction = false;
  String _type = 'expense';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedCategory = 'Other';
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController(text: 'Manual Bank');
  final FocusNode _noteFocus = FocusNode();
  final FocusNode _bankFocus = FocusNode();
  bool _keyboardVisible = false;
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
    _noteFocus.addListener(_onFocusChange);
    _bankFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _noteFocus.removeListener(_onFocusChange);
    _bankFocus.removeListener(_onFocusChange);
    _noteFocus.dispose();
    _bankFocus.dispose();
    _noteController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    final hasFocus = _noteFocus.hasFocus || _bankFocus.hasFocus;
    if (hasFocus != _keyboardVisible) {
      setState(() => _keyboardVisible = hasFocus);
    }
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _onKeyPress(String key) {
    setState(() {
      String current = _activeField == 'amount' ? _amountStr : _balanceStr;
      
      if (key == 'back') {
        if (current.length > 1) {
          current = current.substring(0, current.length - 1);
        } else {
          current = '0';
        }
      } else if (key == '.') {
        if (!current.contains('.')) current += '.';
      } else {
        if (current == '0') {
          current = key;
        } else if (current.length < 12) {
          current += key;
        }
      }

      if (_activeField == 'amount') {
        _amountStr = current;
      } else {
        _balanceStr = current;
      }
    });
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountStr) ?? 0.0;
    final balance = _isBankTransaction ? (double.tryParse(_balanceStr) ?? 0.0) : null;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter an amount')));
      return;
    }

    final fullDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final tx = db.Transaction()
      ..amount = amount
      ..type = _type
      ..timestamp = fullDateTime
      ..description = _noteController.text.isEmpty ? _selectedCategory : _noteController.text
      ..bankName = _isBankTransaction ? _bankNameController.text.trim() : 'Manual'
      ..sourcePackageName = 'manual'
      ..category = _selectedCategory
      ..balanceAfter = balance
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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      resizeToAvoidBottomInset: true, 
      appBar: AppBar(
        backgroundColor: const Color(0xFF3AA39F),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Add Transaction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildDisplaySection(_currencyFormat),
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
                            const SizedBox(height: 16),
                            _buildDateTimeSection(),
                            const SizedBox(height: 16),
                            _buildBankToggle(),
                            if (_isBankTransaction) ...[
                              _buildBankFields(),
                            ],
                            const SizedBox(height: 16),
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
                    if (!_keyboardVisible) ...[
                      _buildNumberPad(),
                      _buildSaveButton(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplaySection(NumberFormat format) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
      color: const Color(0xFF3AA39F),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  _activeField = 'amount';
                  _keyboardVisible = false;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AMOUNT', style: TextStyle(color: _activeField == 'amount' ? Colors.white : Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
                  FittedBox(
                    child: Text(
                      format.format(double.tryParse(_amountStr) ?? 0),
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: _activeField == 'amount' ? FontWeight.bold : FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isBankTransaction) ...[
            const SizedBox(width: 20),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _activeField = 'balance';
                    _keyboardVisible = false;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('BALANCE LEFT', style: TextStyle(color: _activeField == 'balance' ? Colors.white : Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
                    FittedBox(
                      child: Text(
                        format.format(double.tryParse(_balanceStr) ?? 0),
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: _activeField == 'balance' ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  Widget _buildDateTimeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Color(0xFF3AA39F)),
                    const SizedBox(width: 8),
                    Text(DateFormat('dd/MM/yyyy').format(_selectedDate), style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Color(0xFF3AA39F)),
                    const SizedBox(width: 8),
                    Text(_selectedTime.format(context), style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SwitchListTile(
        title: const Text('Bank Transaction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: const Text('Includes balance update', style: TextStyle(fontSize: 12)),
        value: _isBankTransaction,
        activeThumbColor: const Color(0xFF3AA39F),
        onChanged: (v) => setState(() {
          _isBankTransaction = v;
          if (!v) _activeField = 'amount';
        }),
      ),
    );
  }

  Widget _buildBankFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: _bankNameController,
        focusNode: _bankFocus,
        decoration: const InputDecoration(
          labelText: 'Bank Name',
          hintText: 'e.g. VCB, MoMo...',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
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
        focusNode: _noteFocus,
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
