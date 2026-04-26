import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackgroundLogScreen extends StatefulWidget {
  const BackgroundLogScreen({super.key});

  @override
  State<BackgroundLogScreen> createState() => _BackgroundLogScreenState();
}

class _BackgroundLogScreenState extends State<BackgroundLogScreen> {
  String _logs = "No logs yet.";
  static const _channel = MethodChannel('com.example.finance_app/service');

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    try {
      final String? result = await _channel.invokeMethod('getBackgroundLogs');
      if (mounted) {
        setState(() {
          _logs = (result == null || result.isEmpty) ? "No logs yet." : result;
        });
      }
    } catch (e) {
      debugPrint("Error loading background logs: $e");
    }
  }

  Future<void> _clearLogs() async {
    try {
      await _channel.invokeMethod('clearBackgroundLogs');
      _loadLogs();
    } catch (e) {
      debugPrint("Error clearing logs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Background Logs'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          _logs,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
      ),
    );
  }
}
