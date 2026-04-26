import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'transaction.dart';
import 'category_rule.dart';
import 'raw_notification.dart';
import 'category.dart';
import 'custom_bank_rule.dart';
import 'bank_status.dart';

class IsarDatabase {
  static Isar get instance {
    final isar = Isar.getInstance();
    if (isar == null) {
      throw Exception("Isar not initialized. Call init() first.");
    }
    return isar;
  }

  static Future<void> init({String? path}) async {
    final existing = Isar.getInstance();
    if (existing != null && existing.isOpen) return;
    
    final String dbPath;
    if (path != null) {
      dbPath = path;
    } else {
      final dir = await getApplicationDocumentsDirectory();
      dbPath = dir.path;
    }

    try {
      await Isar.open(
        [
          TransactionSchema, 
          CategoryRuleSchema, 
          RawNotificationSchema, 
          CategorySchema,
          CustomBankRuleSchema,
          BankStatusSchema,
        ],
        directory: dbPath,
      );
    } catch (e) {
      if (e.toString().contains('already open')) return;
      final recovery = Isar.getInstance();
      if (recovery != null) return;
      rethrow;
    }
  }
}
