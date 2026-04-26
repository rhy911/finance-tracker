import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../../core/database/isar_database.dart';
import '../../core/database/raw_notification.dart';

class NotificationLogScreen extends StatefulWidget {
  const NotificationLogScreen({super.key});

  @override
  State<NotificationLogScreen> createState() => _NotificationLogScreenState();
}

class _NotificationLogScreenState extends State<NotificationLogScreen> {
  final _isar = IsarDatabase.instance;
  List<RawNotification> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await _isar.rawNotifications.where().idNotEqualTo(-1).sortByTimestampDesc().findAll();
    if (mounted) {
      setState(() {
        _logs = logs;
      });
    }
  }

  Future<void> _clearLogs() async {
    await _isar.writeTxn(() async {
      await _isar.rawNotifications.clear();
    });
    _loadLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raw Notification Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearLogs,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLogs,
          ),
        ],
      ),
      body: _logs.isEmpty
          ? const Center(child: Text('No notifications captured yet.', textAlign: TextAlign.center))
          : ListView.separated(
              itemCount: _logs.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final log = _logs[index];
                return ListTile(
                  title: Text(
                    log.packageName,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(log.text),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm:ss').format(log.timestamp),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
