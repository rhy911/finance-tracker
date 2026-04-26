enum TransactionType {
  income,
  expense,
}

class ParseResult {
  final double amount;
  final TransactionType type;
  final double? balanceAfter;
  final String description;
  final String? title;
  final String? content;
  final bool isConfident;
  final String? warning;

  ParseResult({
    required this.amount,
    required this.type,
    this.balanceAfter,
    required this.description,
    this.title,
    this.content,
    this.isConfident = true,
    this.warning,
  });

  @override
  String toString() {
    return 'ParseResult(amount: $amount, type: $type, balance: $balanceAfter, desc: $description, title: $title, content: $content)';
  }
}

abstract class BankParser {
  /// Package name of the bank application on Android
  String get packageName;

  /// Display name of the bank
  String get bankName;

  /// Current version of the parser
  int get parserVersion;

  /// Parse notification text into ParseResult
  /// Returns null if format is not recognized
  ParseResult? parse(String notificationText);
}
