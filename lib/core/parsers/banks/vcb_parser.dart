import 'package:flutter/foundation.dart';

import '../bank_parser.dart';

class VCBParser implements BankParser {
  @override
  String get packageName => 'com.VCB';

  @override
  String get bankName => 'Vietcombank';

  @override
  int get parserVersion => 2;

  // New VCB Notification Format:
  // Title: Thông báo VCB
  // Content: "Số dư TK VCB 1036902212 +5,000 VND lúc 23-04-2026 16:17:15. Số dư 268,732 VND. Ref DO THANH NAM Chuyen tien..."

  // Robust pattern: Look for VCB, card number, then +/- amount and VND
  static final _transactionPattern = RegExp(
    r'VCB\s+\d+\s+([+-])\s*([\d,.]+)\s*VND',
    caseSensitive: false,
  );

  // Pattern for balance — simple as it can be to handle encoding variants
  static final _balancePattern = RegExp(
    r'dư\s+([\d,.]+)\s*VND',
    caseSensitive: false,
  );

  static final _descriptionPattern = RegExp(
    r'Ref\s*(.*)$',
    caseSensitive: false,
  );

  @override
  ParseResult? parse(String text) {
    if (kDebugMode) {
      print("VCBParser: Attempting to parse: $text");
    }
    final transMatch = _transactionPattern.firstMatch(text);
    if (transMatch == null) {
      if (kDebugMode) {
        print("VCBParser: Transaction pattern match failed.");
      }
      return null;
    }

    final typeChar = transMatch.group(1)!;
    final rawAmountText = transMatch.group(2)!;
    final amountStr = rawAmountText.replaceAll(RegExp(r'[.,]'), '');
    final amount = double.tryParse(amountStr) ?? 0.0;
    
    final type = typeChar == '+' ? TransactionType.income : TransactionType.expense;
    if (kDebugMode) {
      print("VCBParser: Found Amount: $amount, Type: $type");
    }

    // Find all "Số dư" matches and take the LAST one
    final balanceMatches = _balancePattern.allMatches(text);
    double? balanceAfter;
    if (balanceMatches.isNotEmpty) {
      final lastMatch = balanceMatches.last;
      final balanceStr = lastMatch.group(1)!.replaceAll(RegExp(r'[.,]'), '');
      balanceAfter = double.tryParse(balanceStr);
      if (kDebugMode) {
        print("VCBParser: Found Balance from last match: $balanceAfter");
      }
    }

    final descMatch = _descriptionPattern.firstMatch(text);
    String description = descMatch?.group(1)?.trim() ?? 'No description';
    
    // Clean up random codes
    description = description
        .replaceAll(RegExp(r'MBVCB\.\d+\.\d+\.', caseSensitive: false), '')
        .replaceAll(RegExp(r'MBVCB\.\d+\.', caseSensitive: false), '')
        .replaceAll(RegExp(r'FT\d+', caseSensitive: false), '')
        .replaceAll(RegExp(r'VCB\.\d+', caseSensitive: false), '')
        .replaceAll(RegExp(r'CT từ|Tới', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s{2,}', caseSensitive: false), ' ')
        .trim();

    if (kDebugMode) {
      print("VCBParser: Found Description: $description");
    }

    return ParseResult(
      amount: amount,
      type: type,
      balanceAfter: balanceAfter,
      description: description,
      isConfident: true,
    );
  }
}
