import '../database/custom_bank_rule.dart';
import 'bank_parser.dart';

class DynamicBankParser implements BankParser {
  final CustomBankRule rule;

  DynamicBankParser(this.rule);

  @override
  String get bankName => rule.bankName;

  @override
  String get packageName => rule.packageName;

  @override
  int get parserVersion => 1;

  @override
  ParseResult? parse(String text) {
    try {
      double amount = 0;
      double? balance;

      if (rule.useRegex) {
        // Advanced: Regex
        final amountMatch = RegExp(rule.amountRegex).firstMatch(text);
        if (amountMatch != null) {
          final amountStr = amountMatch.group(1)?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0';
          amount = double.tryParse(amountStr) ?? 0;
        }

        if (rule.balanceRegex.isNotEmpty) {
          final balanceMatch = RegExp(rule.balanceRegex).firstMatch(text);
          if (balanceMatch != null) {
            final balanceStr = balanceMatch.group(1)?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0';
            balance = double.tryParse(balanceStr);
          }
        }
      } else {
        // Simple: Keyword based
        if (rule.amountKeyword != null && rule.amountKeyword!.isNotEmpty) {
          amount = _extractValueAfterKeyword(text, rule.amountKeyword!);
        }
        if (rule.balanceKeyword != null && rule.balanceKeyword!.isNotEmpty) {
          balance = _extractValueAfterKeyword(text, rule.balanceKeyword!);
        }
      }

      if (amount <= 0 && rule.useRegex) return null; // Only fail if regex fails

      // 2. Type
      TransactionType type = TransactionType.expense;
      if (text.contains(rule.incomeKeyword)) {
        type = TransactionType.income;
      }

      return ParseResult(
        amount: amount,
        type: type,
        balanceAfter: balance,
        description: text.length > 50 ? "${text.substring(0, 50)}..." : text,
        isConfident: amount > 0,
      );
    } catch (e) {
      return null;
    }
  }

  double _extractValueAfterKeyword(String text, String keyword) {
    try {
      final index = text.indexOf(keyword);
      if (index == -1) return 0;

      // Get substring after keyword
      String after = text.substring(index + keyword.length).trim();
      
      // Take first contiguous digits/separators
      final match = RegExp(r'([0-9,.]+)').firstMatch(after);
      if (match == null) return 0;

      final valStr = match.group(1)!.replaceAll(RegExp(r'[^0-9]'), '');
      return double.tryParse(valStr) ?? 0;
    } catch (_) {
      return 0;
    }
  }
}
