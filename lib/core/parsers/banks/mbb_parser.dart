import '../bank_parser.dart';

class MBBParser implements BankParser {
  @override
  String get packageName => 'com.mb.mbmobile';

  @override
  String get bankName => 'MB Bank';

  @override
  int get parserVersion => 1;

  // Example MB Bank Notification:
  // "MB: TK 1234567890 +500,000VND vao 23/04/26 10:00. SD: 1,500,000VND. ND: Luong thang 4"
  // "MB: TK 1234567890 -20,000VND vao 23/04/26 11:00. SD: 1,480,000VND. ND: Chuyen khoan"

  static final _transactionPattern = RegExp(
    r'([+-])([\d,.]+)\s*VND',
    caseSensitive: false,
  );

  static final _balancePattern = RegExp(
    r'SD:\s*([\d,.]+)\s*VND',
    caseSensitive: false,
  );

  static final _descriptionPattern = RegExp(
    r'ND:\s*(.*)$',
    caseSensitive: false,
  );

  @override
  ParseResult? parse(String text) {
    final transMatch = _transactionPattern.firstMatch(text);
    if (transMatch == null) return null;

    final typeChar = transMatch.group(1);
    final amountStr = transMatch.group(2)!.replaceAll(',', '').replaceAll('.', '');
    final amount = double.tryParse(amountStr) ?? 0.0;
    
    final type = typeChar == '+' ? TransactionType.income : TransactionType.expense;

    final balanceMatch = _balancePattern.firstMatch(text);
    double? balanceAfter;
    if (balanceMatch != null) {
      final balanceStr = balanceMatch.group(1)!.replaceAll(',', '').replaceAll('.', '');
      balanceAfter = double.tryParse(balanceStr);
    }

    final descMatch = _descriptionPattern.firstMatch(text);
    String description = descMatch?.group(1)?.trim() ?? 'No description';

    return ParseResult(
      amount: amount,
      type: type,
      balanceAfter: balanceAfter,
      description: description,
      isConfident: true,
    );
  }
}
