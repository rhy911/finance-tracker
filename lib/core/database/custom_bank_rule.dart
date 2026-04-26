import 'package:isar/isar.dart';

part 'custom_bank_rule.g.dart';

@collection
class CustomBankRule {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String packageName;
  
  late String bankName;

  // Regex patterns or keywords
  late String amountRegex; 
  late String balanceRegex;
  
  late String incomeKeyword;
  late String expenseKeyword;

  bool useRegex = true;
  String? amountKeyword; // e.g. "SD:" or "Sotien:"
  String? balanceKeyword;

  DateTime createdAt = DateTime.now();
}
