import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../database/transaction_repository.dart';

class NotificationSyncService {
  static const _channel = MethodChannel('com.example.finance_app/service');
  final _repository = TransactionRepository();
  String? _lastText;
  DateTime? _lastTime;

  void startSync() {
    // 1. Initial sync to catch up on what happened while app was closed
    sync();

    // 2. Set up listener for real-time push from Native
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onNotificationReceived') {
        final data = call.arguments as Map;
        await _processIncoming(
          data['package'] as String,
          data['text'] as String,
          data['timestamp'] as String,
        );
      }
    });
  }

  void stopSync() {
    _channel.setMethodCallHandler(null);
  }

  Future<void> sync() async {
    try {
      final String? rawLogs = await _channel.invokeMethod('getBackgroundLogs');
      if (rawLogs == null || rawLogs.isEmpty) return;

      final lines = rawLogs.split('\n');
      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        await _processLogLine(line);
      }
      // Clear logs after successful processing
      await _channel.invokeMethod('clearBackgroundLogs');
    } catch (e) {
      if (kDebugMode) {
        print("NotificationSyncService: Error during sync: $e");
      }
    }
  }

  Future<void> _processIncoming(String pkg, String text, String ts) async {
    try {
      final timestamp = DateTime.parse(ts);
      
      // Simple de-duplication
      if (_lastText == text && _lastTime != null && 
          timestamp.difference(_lastTime!).inSeconds.abs() < 10) {
        return;
      }
      _lastText = text;
      _lastTime = timestamp;

      await _repository.processNotification(
        packageName: pkg,
        text: text,
        timestamp: timestamp,
      );
    } catch (e) {
      if (kDebugMode) {
        print("NotificationSyncService: Push process error: $e");
      }
    }
  }

  Future<void> _processLogLine(String line) async {
    final regExp = RegExp(r'^\[(.*?)\] (.*?): (.*)$');
    final match = regExp.firstMatch(line);
    if (match == null) return;

    final timestampStr = match.group(1)!;
    final packageName = match.group(2)!;
    final content = match.group(3)!;

    try {
      final timestamp = DateTime.parse(timestampStr);

      // De-duplicate log lines too
      if (_lastText == content && _lastTime != null && 
          timestamp.difference(_lastTime!).inSeconds.abs() < 10) {
        return;
      }
      _lastText = content;
      _lastTime = timestamp;

      await _repository.processNotification(
        packageName: packageName,
        text: content,
        timestamp: timestamp,
      );
    } catch (e) {
      if (kDebugMode) {
        print("NotificationSyncService: Log parse error: $e");
      }
    }
  }
}
