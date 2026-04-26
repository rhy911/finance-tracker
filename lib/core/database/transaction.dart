import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  // --- Core fields ---
  late double amount;
  late String type;              // 'income' | 'expense'
  @Index()
  late DateTime timestamp;
  late String description;

  // --- Source info ---
  late String bankName;
  late String sourcePackageName; // com.vcb, com.momo, ...

  // --- Category ---
  late String category;          // Default: 'Uncategorized'
  String? customNote;            // Ghi chú của người dùng

  // --- Balance ---
  double? balanceAfter;          // Số dư sau giao dịch (nếu có)

  // --- Audit & Maintenance ---
  late String rawContent;        // Nội dung notification gốc — KHÔNG BAO GIỜ XÓA
  @Index()
  late String contentHash;       // SHA-256(rawContent + timestamp) — dùng để dedup
  late int parserVersion;        // Version của parser đã tạo record này
  late bool isParsedSuccessfully;
  String? parseWarning;          // Cảnh báo nếu parse có vẻ bất thường
  late DateTime createdAt;
  DateTime? updatedAt;           // Null nếu chưa từng sửa
}
