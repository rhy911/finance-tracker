import 'dart:convert';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'transaction.dart';
import 'isar_database.dart';
import 'raw_notification.dart';
import '../parsers/bank_parser_registry.dart';
import '../parsers/bank_parser.dart';
import '../services/category_service.dart';

class TransactionRepository {
  final Isar isar = IsarDatabase.instance;
  final _categoryService = CategoryService();

  Future<File> saveToLocal() async {
    final json = await exportData();
    final directory = await getExternalStorageDirectory(); // App private external
    // For public Downloads, need complex permission or SAF. 
    // We use app-specific external first. It stays on some devices.
    // Better: return string and let UI handle sharing.
    final file = File('${directory!.path}/backup.json');
    return await file.writeAsString(json);
  }

  Future<void> saveTransaction(Transaction transaction) async {
    await isar.writeTxn(() async {
      await isar.transactions.put(transaction);
    });
  }

  Future<void> deleteTransaction(int id) async {
    await isar.writeTxn(() async {
      await isar.transactions.delete(id);
    });
  }

  Future<String> exportData() async {
    final txs = await getAllTransactions();
    final List<Map<String, dynamic>> data = txs.map((t) => {
      'amount': t.amount,
      'type': t.type,
      'timestamp': t.timestamp.toIso8601String(),
      'description': t.description,
      'category': t.category,
      'bankName': t.bankName,
      'sourcePackageName': t.sourcePackageName,
      'rawContent': t.rawContent,
      'contentHash': t.contentHash,
      'parserVersion': t.parserVersion,
      'isParsedSuccessfully': t.isParsedSuccessfully,
      'balanceAfter': t.balanceAfter,
      'createdAt': t.createdAt.toIso8601String(),
    }).toList();
    return jsonEncode(data);
  }

  Future<void> _importCore(List<dynamic> data) async {
    await isar.writeTxn(() async {
      for (var item in data) {
        final hash = item['contentHash'] as String;
        final exists = await existsByHash(hash);
        if (exists) continue;

        final tx = Transaction()
          ..amount = (item['amount'] as num).toDouble()
          ..type = item['type']
          ..timestamp = DateTime.parse(item['timestamp'])
          ..description = item['description']
          ..category = item['category']
          ..bankName = item['bankName']
          ..sourcePackageName = item['sourcePackageName'] ?? 'imported'
          ..rawContent = item['rawContent'] ?? 'Imported transaction'
          ..contentHash = hash
          ..parserVersion = item['parserVersion'] ?? 0
          ..isParsedSuccessfully = item['isParsedSuccessfully'] ?? true
          ..balanceAfter = item['balanceAfter'] != null ? (item['balanceAfter'] as num).toDouble() : null
          ..createdAt = item['createdAt'] != null ? DateTime.parse(item['createdAt']) : DateTime.now();

        await isar.transactions.put(tx);
      }
    });
  }

  Future<void> importData(String jsonString) async {
    final dynamic decoded = jsonDecode(jsonString);
    if (decoded is List) {
      await _importCore(decoded);
    } else {
      throw const FormatException('Invalid backup format');
    }
  }

  Future<void> deleteOldTransactions(DateTime before) async {
    await isar.writeTxn(() async {
      await isar.transactions.filter().timestampLessThan(before).deleteAll();
    });
  }

  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.transactions.clear();
      await isar.rawNotifications.clear();
    });
  }

  Future<bool> existsByHash(String hash) async {
    final count = await isar.transactions.where().contentHashEqualTo(hash).count();
    return count > 0;
  }

  Future<double> getTotalIncome() async {
    return await isar.transactions.filter().typeEqualTo('income').amountProperty().sum();
  }

  Future<double> getTotalExpense() async {
    return await isar.transactions.filter().typeEqualTo('expense').amountProperty().sum();
  }

  Future<double?> getLatestBalance() async {
    final last = await isar.transactions.where().filter().balanceAfterIsNotNull().sortByTimestampDesc().findFirst();
    return last?.balanceAfter;
  }

  Future<List<Transaction>> getRecentTransactions({int limit = 20, int offset = 0}) async {
    return await isar.transactions.where().sortByTimestampDesc().offset(offset).limit(limit).findAll();
  }

  Future<Map<String, double>> getCategoryStatsInRange(DateTime start, DateTime end, String type) async {
    final txs = await isar.transactions
        .filter()
        .timestampBetween(start, end)
        .and()
        .typeEqualTo(type)
        .findAll();
    
    final Map<String, double> stats = {};
    for (var tx in txs) {
      final cat = tx.category;
      stats[cat] = (stats[cat] ?? 0) + tx.amount;
    }
    return stats;
  }

  Future<List<Transaction>> getAllTransactions() async {
    return await isar.transactions.where().sortByTimestampDesc().findAll();
  }

  Future<List<Transaction>> getTransactionsInRange(DateTime start, DateTime end) async {
    return await isar.transactions
        .filter()
        .timestampBetween(start, end)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<Map<String, Map<String, double>>> getMonthlyStats() async {
    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 5, 1);
    
    final transactions = await isar.transactions
        .filter()
        .timestampGreaterThan(sixMonthsAgo)
        .findAll();

    final Map<String, Map<String, double>> stats = {};

    for (var tx in transactions) {
      final monthKey = DateFormat('yyyy-MM').format(tx.timestamp);
      stats.putIfAbsent(monthKey, () => {'income': 0, 'expense': 0});
      
      if (tx.type == 'income') {
        stats[monthKey]!['income'] = stats[monthKey]!['income']! + tx.amount;
      } else {
        stats[monthKey]!['expense'] = stats[monthKey]!['expense']! + tx.amount;
      }
    }
    return stats;
  }

  String generateHash(String rawContent, int timestamp) {
    final input = '$rawContent$timestamp';
    return sha256.convert(utf8.encode(input)).toString();
  }

  Future<void> processNotification({
    required String packageName,
    required String text,
    required DateTime timestamp,
  }) async {
    final hash = generateHash(text, timestamp.millisecondsSinceEpoch);
    
    // Dedup
    if (await existsByHash(hash)) return;

    // Save to RawNotification for status check
    await isar.writeTxn(() async {
      final raw = RawNotification()
        ..packageName = packageName
        ..text = text
        ..timestamp = timestamp;
      await isar.rawNotifications.put(raw);
    });

    final parser = await BankParserRegistry.getParser(packageName);
    if (parser == null) return;

    final result = parser.parse(text);
    if (result == null) return;

    final category = await _categoryService.categorize(result.description);

    final transaction = Transaction()
      ..amount = result.amount
      ..type = result.type == TransactionType.income ? 'income' : 'expense'
      ..timestamp = timestamp
      ..description = result.description
      ..bankName = parser.bankName
      ..sourcePackageName = packageName
      ..category = category
      ..balanceAfter = result.balanceAfter
      ..rawContent = text
      ..contentHash = hash
      ..parserVersion = parser.parserVersion
      ..isParsedSuccessfully = result.isConfident
      ..parseWarning = result.warning
      ..createdAt = DateTime.now();

    await saveTransaction(transaction);
  }
}
