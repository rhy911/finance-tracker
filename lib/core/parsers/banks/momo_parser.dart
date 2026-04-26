import 'package:flutter/foundation.dart';

import '../bank_parser.dart';

class MomoParser implements BankParser {
  @override
  String get packageName => 'vn.momo';

  @override
  String get bankName => 'Momo';

  @override
  int get parserVersion => 1;

  // Momo formats:
  // Income: "Bạn vừa nhận được 50.000đ từ NGUYEN VAN A. Lời nhắn: ..."
  // Expense: "Thanh toán 15.000đ cho Circle K..."
  // Expense: "Bạn đã chuyển 20.000đ cho NGUYEN VAN B..."
  // Expense: "Giao dịch thành công 100.000đ..."

  static final _incomePattern = RegExp(
    r'nhận được\s*([\d,.]+)\s*đ',
    caseSensitive: false,
  );

  static final _expensePattern = RegExp(
    r'(?:Thanh toán|chuyển|Giao dịch thành công)\s*([\d,.]+)\s*đ',
    caseSensitive: false,
  );

  static final _descriptionPattern = RegExp(
    r'(?:từ|cho|ND:)\s*(.*?)(?:\.|$)',
    caseSensitive: false,
  );

  @override
  ParseResult? parse(String text) {
    if (kDebugMode) {
      print("MomoParser: Attempting to parse: $text");
    }
    
    TransactionType? type;
    String? rawAmountText;

    final incomeMatch = _incomePattern.firstMatch(text);
    if (incomeMatch != null) {
      type = TransactionType.income;
      rawAmountText = incomeMatch.group(1);
    } else {
      final expenseMatch = _expensePattern.firstMatch(text);
      if (expenseMatch != null) {
        type = TransactionType.expense;
        rawAmountText = expenseMatch.group(1);
      }
    }

    if (type == null || rawAmountText == null) {
      if (kDebugMode) {
        print("MomoParser: Pattern match failed.");
      }
      return null;
    }

    final amountStr = rawAmountText.replaceAll(RegExp(r'[.,]'), '');
    final amount = double.tryParse(amountStr) ?? 0.0;
    if (kDebugMode) {
      print("MomoParser: Found Amount: $amount, Type: $type");
    }

    final descMatch = _descriptionPattern.firstMatch(text);
    String description = descMatch?.group(1)?.trim() ?? 'No description';
    if (kDebugMode) {
      print("MomoParser: Found Description: $description");
    }

    return ParseResult(
      amount: amount,
      type: type,
      description: description,
      isConfident: true,
    );
  }
}
