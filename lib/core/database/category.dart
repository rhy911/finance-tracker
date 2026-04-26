import 'package:isar/isar.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String name;

  String? icon; // Icon name or code
  
  DateTime createdAt = DateTime.now();
}
