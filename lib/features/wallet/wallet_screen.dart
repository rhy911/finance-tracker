import 'package:flutter/material.dart';
import '../../core/database/isar_database.dart';
import '../../core/database/custom_bank_rule.dart';
import '../../core/database/bank_status.dart';
import '../../core/parsers/bank_parser_registry.dart';
import 'package:isar/isar.dart';
import '../../main.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _isar = IsarDatabase.instance;
  List<CustomBankRule> _customRules = [];
  Map<String, bool> _bankEnabledStates = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final rules = await _isar.customBankRules.where().findAll();
    final statuses = await _isar.bankStatus.where().findAll();
    
    final Map<String, bool> states = {};
    for (var s in statuses) {
      states[s.packageName] = s.isEnabled;
    }

    setState(() {
      _customRules = rules;
      _bankEnabledStates = states;
    });
  }

  bool _isEnabled(String pkg) => _bankEnabledStates[pkg] ?? true;

  Future<void> _toggleBank(String pkg, bool enabled) async {
    await _isar.writeTxn(() async {
      var status = await _isar.bankStatus.where().packageNameEqualTo(pkg).findFirst();
      if (status == null) {
        status = BankStatus()..packageName = pkg..isEnabled = enabled;
      } else {
        status.isEnabled = enabled;
      }
      await _isar.bankStatus.put(status);
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPackages = BankParserRegistry.staticSupportedPackages;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallets & Banks'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuideSection(context),
            const SizedBox(height: 30),
            const Text(
              'Default Bank Parsers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...defaultPackages.map((pkg) => _buildDefaultBankTile(pkg)),
            const SizedBox(height: 30),
            const Text(
              'Custom Bank Parsers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (_customRules.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('No custom parsers yet.', style: TextStyle(color: Colors.grey)),
              )
            else
              ..._customRules.map((rule) => _buildRuleTile(rule)),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showAddRuleDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Create New Bank Parser'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3AA39F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultBankTile(String pkg) {
    final name = BankParserRegistry.getBankName(pkg);
    final enabled = _isEnabled(pkg);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: enabled ? Colors.blue.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
          child: Icon(Icons.account_balance, color: enabled ? Colors.blue : Colors.grey),
        ),
        title: Text(name),
        subtitle: Text(pkg, style: const TextStyle(fontSize: 11)),
        trailing: Switch(
          value: enabled,
          onChanged: (v) => _toggleBank(pkg, v),
          activeThumbColor: const Color(0xFF3AA39F),
        ),
      ),
    );
  }

  Widget _buildRuleTile(CustomBankRule rule) {
    final enabled = _isEnabled(rule.packageName);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: enabled ? Colors.purple.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
          child: Icon(Icons.terminal, color: enabled ? Colors.purple : Colors.grey),
        ),
        title: Text(rule.bankName),
        subtitle: Text(rule.packageName, style: const TextStyle(fontSize: 11)),
        onTap: () => _showAddRuleDialog(context, rule),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: enabled,
              onChanged: (v) => _toggleBank(rule.packageName, v),
              activeThumbColor: const Color(0xFF3AA39F),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await _isar.writeTxn(() => _isar.customBankRules.delete(rule.id));
                _loadData();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3AA39F).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3AA39F).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.terminal, color: Color(0xFF3AA39F)),
              SizedBox(width: 8),
              Text(
                'How to create a parser?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF3AA39F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _guideStep('1', 'Find the Package Name of your bank app (use Logs to see it).'),
          _guideStep('2', 'Identify keywords for Income/Expense (e.g. "+", "nhan tien").'),
          _guideStep('3', 'Use Regex for Amount. Example: ([0-9,.]+) VND.'),
          _guideStep('4', 'Save and test with a new notification.'),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'Missed a notification?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF3AA39F)),
          ),
          const Text(
            'If the notification is still in your status bar, you can sync it manually.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _showSyncDialog(context),
              icon: const Icon(Icons.sync),
              label: const Text('Sync Notifications'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3AA39F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSyncDialog(BuildContext context) {
    final controller = TextEditingController(text: '60');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter time window (minutes) to look back for active notifications in your status bar.'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minutes',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final mins = int.tryParse(controller.text) ?? 60;
              final success = await NativeService.reReadNotifications(mins);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'Syncing notifications...' : 'Service not active. Grant permission first.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3AA39F), foregroundColor: Colors.white),
            child: const Text('Sync Now'),
          ),
        ],
      ),
    );
  }

  Widget _guideStep(String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row( crossAxisAlignment: CrossAxisAlignment.start, children: [ Text('$num. ', style: const TextStyle(fontWeight: FontWeight.bold)), Expanded(child: Text(text, style: const TextStyle(fontSize: 13))), ], ),
    );
  }

  void _showAddRuleDialog(BuildContext context, [CustomBankRule? existing]) {
    final isEditing = existing != null;
    final nameController = TextEditingController(text: existing?.bankName ?? '');
    final pkgController = TextEditingController(text: existing?.packageName ?? '');
    
    // Advanced fields
    final amountRegexController = TextEditingController(text: existing?.amountRegex ?? r'([0-9,.]+)');
    final balanceRegexController = TextEditingController(text: existing?.balanceRegex ?? '');
    
    // Simple fields
    final amountKeywordController = TextEditingController(text: existing?.amountKeyword ?? '');
    final balanceKeywordController = TextEditingController(text: existing?.balanceKeyword ?? '');
    
    // Common fields
    final incomeController = TextEditingController(text: existing?.incomeKeyword ?? '+');
    final expenseController = TextEditingController(text: existing?.expenseKeyword ?? '-');
    
    bool useRegex = existing?.useRegex ?? false; // Default to false for new ones (User friendly!)

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Parser' : 'Create Parser'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Bank Name', hintText: 'e.g. My Bank')),
                TextField(controller: pkgController, decoration: const InputDecoration(labelText: 'Package Name', hintText: 'e.g. com.mybank.app')),
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Advanced (Regex)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Switch(
                      value: useRegex,
                      onChanged: (v) => setDialogState(() => useRegex = v),
                      activeThumbColor: const Color(0xFF3AA39F),
                    ),
                  ],
                ),
                
                if (useRegex) ...[
                  TextField(controller: amountRegexController, decoration: const InputDecoration(labelText: 'Amount Regex', hintText: r'([0-9,.]+)')),
                  TextField(controller: balanceRegexController, decoration: const InputDecoration(labelText: 'Balance Regex (Optional)')),
                ] else ...[
                  TextField(
                    controller: amountKeywordController, 
                    decoration: const InputDecoration(
                      labelText: 'Word before amount', 
                      hintText: 'e.g. "So tien:", "SD:", "GD:"',
                      helperText: 'Program will find numbers after this word.',
                      helperStyle: TextStyle(fontSize: 10),
                    ),
                  ),
                  TextField(
                    controller: balanceKeywordController, 
                    decoration: const InputDecoration(
                      labelText: 'Word before balance (Optional)', 
                      hintText: 'e.g. "So du:"',
                    ),
                  ),
                ],
                
                const SizedBox(height: 24),
                const Text('Transaction Type Keywords', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const Text('What word identifies Income vs Expense?', style: TextStyle(fontSize: 10, color: Colors.grey)),
                Row(
                  children: [
                    Expanded(child: TextField(controller: incomeController, decoration: const InputDecoration(labelText: 'Income (e.g. +)'))),
                    const SizedBox(width: 16),
                    Expanded(child: TextField(controller: expenseController, decoration: const InputDecoration(labelText: 'Expense (e.g. -)'))),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final rule = existing ?? CustomBankRule();
                rule
                  ..bankName = nameController.text.trim()
                  ..packageName = pkgController.text.trim()
                  ..useRegex = useRegex
                  ..amountRegex = amountRegexController.text.trim()
                  ..balanceRegex = balanceRegexController.text.trim()
                  ..amountKeyword = amountKeywordController.text.trim()
                  ..balanceKeyword = balanceKeywordController.text.trim()
                  ..incomeKeyword = incomeController.text.trim()
                  ..expenseKeyword = expenseController.text.trim();
                
                await _isar.writeTxn(() => _isar.customBankRules.put(rule));
                if (context.mounted) Navigator.pop(context);
                _loadData();
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3AA39F), foregroundColor: Colors.white),
              child: Text(isEditing ? 'Save' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }
}
