import 'bank_parser.dart';
import 'banks/vcb_parser.dart';
import 'banks/mbb_parser.dart';
import 'banks/momo_parser.dart';
import 'dynamic_bank_parser.dart';
import '../database/isar_database.dart';
import '../database/custom_bank_rule.dart';
import '../database/bank_status.dart';
import 'package:isar/isar.dart';

class BankParserRegistry {
  static final Map<String, BankParser> _staticParsers = {
    'com.VCB': VCBParser(),
    'com.mb.mbmobile': MBBParser(),
    'vn.momo': MomoParser(),
  };

  static Future<BankParser?> getParser(String packageName) async {
    final isar = IsarDatabase.instance;
    
    // Check if disabled by user
    final status = await isar.bankStatus.where().packageNameEqualTo(packageName).findFirst();
    if (status != null && !status.isEnabled) {
      return null;
    }

    // 1. Check static
    if (_staticParsers.containsKey(packageName)) {
      return _staticParsers[packageName];
    }

    // 2. Check dynamic from Isar
    final customRule = await isar.customBankRules.where().packageNameEqualTo(packageName).findFirst();
    if (customRule != null) {
      return DynamicBankParser(customRule);
    }

    return null;
  }

  static List<String> get staticSupportedPackages => _staticParsers.keys.toList();
  
  static String getBankName(String packageName) {
    if (_staticParsers.containsKey(packageName)) {
      return _staticParsers[packageName]!.bankName;
    }
    return 'Unknown Bank';
  }
}
