import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/core/parsers/bank_parser.dart';
import 'package:finance_app/core/parsers/banks/vcb_parser.dart';

void main() {
  group('VCBParser Tests (New Format)', () {
    final parser = VCBParser();

    test('parse expense notification', () {
      const text = 'Số dư TK VCB 1036902212 -50,000 VND lúc 23-04-2026 10:05:00. Số dư 4,950,000 VND. Ref Thanh toan hoa don';
      final result = parser.parse(text);

      expect(result, isNotNull);
      expect(result!.amount, 50000.0);
      expect(result.type, TransactionType.expense);
      expect(result.balanceAfter, 4950000.0);
      expect(result.description, 'Thanh toan hoa don');
    });

    test('parse income notification', () {
      const text = 'Số dư TK VCB 1036902212 +100,000 VND lúc 23-04-2026 10:00:00. Số dư 5,100,000 VND. Ref Chuyen khoan tu ban';
      final result = parser.parse(text);

      expect(result, isNotNull);
      expect(result!.amount, 100000.0);
      expect(result.type, TransactionType.income);
      expect(result.balanceAfter, 5100000.0);
      expect(result.description, 'Chuyen khoan tu ban');
    });

    test('parse with dot separators', () {
      const text = 'Số dư TK VCB 1036902212 -50.000 VND lúc 23-04-2026 10:05:00. Số dư 4.950.000 VND. Ref Test dot';
      final result = parser.parse(text);

      expect(result, isNotNull);
      expect(result!.amount, 50000.0);
      expect(result.balanceAfter, 4950000.0);
    });

    test('parse user provided example with codes', () {
      const text = 'Số dư TK VCB 1036902212 +5,000 VND lúc 23-04-2026 16:17:15. Số dư 268,732 VND. Ref MBVCB.1234567.DO THANH NAM Chuyen tien...';
      final result = parser.parse(text);

      expect(result, isNotNull);
      expect(result!.description, 'DO THANH NAM Chuyen tien...');
    });

    test('return null for unrelated notification', () {
      const text = 'Welcome to Vietcombank mobile app';
      final result = parser.parse(text);

      expect(result, isNull);
    });
  });
}
