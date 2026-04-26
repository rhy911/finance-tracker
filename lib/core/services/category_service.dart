import 'package:isar/isar.dart';
import '../database/isar_database.dart';
import '../database/category_rule.dart';
import '../database/category.dart' as db;

class CategoryService {
  final Isar isar = IsarDatabase.instance;

  Future<String> categorize(String description) async {
    final lower = description.toLowerCase();
    
    final rules = await isar.categoryRules
        .where()
        .sortByPriorityDesc()
        .findAll();

    for (final rule in rules) {
      if (lower.contains(rule.keyword.toLowerCase())) {
        return rule.category;
      }
    }
    
    return 'Other';
  }

  Future<void> addDefaultRules() async {
    final ruleCount = await isar.categoryRules.count();
    if (ruleCount == 0) {
      final defaultRules = [
        CategoryRule()..keyword = 'an sang'..category = 'Food'..priority = 1,
        CategoryRule()..keyword = 'coffee'..category = 'Food'..priority = 1,
        CategoryRule()..keyword = 'grab'..category = 'Transport'..priority = 2,
        CategoryRule()..keyword = 'shopee'..category = 'Shopping'..priority = 1,
        CategoryRule()..keyword = 'tien dien'..category = 'Bills'..priority = 10,
      ];
      await isar.writeTxn(() => isar.categoryRules.putAll(defaultRules));
    }

    final catCount = await isar.categorys.count();
    if (catCount == 0) {
      final defaultCats = [
        {'name': 'Food', 'icon': 'restaurant'},
        {'name': 'Transport', 'icon': 'directions_car'},
        {'name': 'Shopping', 'icon': 'shopping_bag'},
        {'name': 'Bills', 'icon': 'receipt_long'},
        {'name': 'Income', 'icon': 'payments'},
        {'name': 'Other', 'icon': 'category'},
      ];
      
      final cats = defaultCats.map((data) => db.Category()
        ..name = data['name']!
        ..icon = data['icon']!
      ).toList();
      
      await isar.writeTxn(() => isar.categorys.putAll(cats));
    }
  }

  Future<List<db.Category>> getCategories() async {
    final cats = await isar.categorys.where().findAll();
    return cats..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<List<String>> getCategoryNames() async {
    final cats = await getCategories();
    return cats.map((c) => c.name).toList();
  }

  Future<void> saveCategory(db.Category category) async {
    await isar.writeTxn(() => isar.categorys.put(category));
  }

  Future<void> deleteCategory(int id) async {
    await isar.writeTxn(() => isar.categorys.delete(id));
  }
}
