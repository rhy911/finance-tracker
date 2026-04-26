import 'package:isar/isar.dart';

part 'category_rule.g.dart';

@collection
class CategoryRule {
  Id id = Isar.autoIncrement;
  late String keyword;       // Từ khóa trong description (lowercase)
  late String category;      // Danh mục ánh xạ
  late int priority;         // Rule ưu tiên cao hơn sẽ được áp dụng trước
}
