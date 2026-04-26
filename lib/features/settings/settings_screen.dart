import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../debug/background_log_screen.dart';
import '../categories/category_manager_screen.dart';
import '../../core/database/transaction_repository.dart';
import '../../core/database/isar_database.dart';
import '../../core/database/raw_notification.dart';
import '../../main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:isar/isar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isServiceRunning = false;
  bool _hasPermission = false;
  DateTime? _lastCaptureTime;
  StreamSubscription? _rawSubscription;

  @override
  void initState() {
    super.initState();
    _checkServiceStatus();
    _rawSubscription = IsarDatabase.instance.rawNotifications.watchLazy().listen((_) => _updateLastCapture());
  }

  @override
  void dispose() {
    _rawSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkServiceStatus() async {
    bool running = false;
    bool permission = false;
    try {
      const channel = MethodChannel('com.example.finance_app/service');
      running = await channel.invokeMethod('isServiceRunning') ?? false;
      permission = await channel.invokeMethod('checkListenerPermission') ?? false;
    } catch (e) {
      debugPrint("Settings: Status check failed: $e");
    }
    await _updateLastCapture();
    if (mounted) setState(() { _isServiceRunning = running; _hasPermission = permission; });
  }

  Future<void> _updateLastCapture() async {
    final last = await IsarDatabase.instance.rawNotifications.where().sortByTimestampDesc().findFirst();
    if (mounted) setState(() => _lastCaptureTime = last?.timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildTrackerStatus(context),
          _buildSection(context, 'General', [
            _buildTile(
              context, 
              'Categories', 
              Icons.category_outlined, 
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryManagerScreen()))
            ),
            _buildTile(
              context, 
              'Notification Logs', 
              Icons.history_edu_outlined, 
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BackgroundLogScreen()))
            ),
          ]),
          _buildSection(context, 'Data Management', [
            _buildTile(
              context, 
              'Export Backup', 
              Icons.download_outlined, 
              () => _handleExport(context)
            ),
            _buildTile(
              context, 
              'Import Backup (Clipboard)', 
              Icons.upload_outlined, 
              () => _handleImport(context)
            ),
            _buildTile(
              context, 
              'Cleanup Data', 
              Icons.delete_sweep_outlined, 
              () => _showCleanupDialog(context),
              isDestructive: true,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildTrackerStatus(BuildContext context) {
    final isActive = _isServiceRunning && _hasPermission;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isActive ? Colors.green.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(isActive ? Icons.check_circle : Icons.warning, color: isActive ? Colors.green : Colors.orange),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isActive ? 'Tracker Active' : 'Tracker Stopped',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (_lastCaptureTime != null)
                  Text(
                    'Last capture: ${DateFormat('HH:mm, dd/MM').format(_lastCaptureTime!)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                if (!_hasPermission)
                  const Text(
                    'Permission needed!',
                    style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          Switch(
            value: _isServiceRunning,
            onChanged: (v) async {
              if (!_hasPermission) {
                Navigator.pushNamed(context, '/onboarding');
                return;
              }
              if (v) {
                await NativeService.startService();
              } else {
                await NativeService.stopService();
              }
              _checkServiceStatus();
            },
            activeThumbColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : null),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : null)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  Future<void> _handleExport(BuildContext context) async {
    final repo = TransactionRepository();
    try {
      final file = await repo.saveToLocal();
      await Share.shareXFiles([XFile(file.path)], text: 'Finance App Backup');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  Future<void> _handleImport(BuildContext context) async {
    final repo = TransactionRepository();
    final data = await Clipboard.getData('text/plain');
    if (data?.text == null) return;
    try {
      await repo.importData(data!.text!);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data imported!')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Import failed. Invalid data.')));
    }
  }

  void _showCleanupDialog(BuildContext context) {
    final repo = TransactionRepository();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cleanup Data'),
        content: const Text('Choose how to clean your cave:'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
              await repo.deleteOldTransactions(threeMonthsAgo);
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Old bones removed!')));
            },
            child: const Text('Older than 3 months'),
          ),
          TextButton(
            onPressed: () async {
              await repo.clearAll();
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cave is empty!')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear ALL'),
          ),
        ],
      ),
    );
  }
}
