import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../core/database/isar_database.dart';
import '../../core/database/category_rule.dart';
import '../../core/database/category.dart' as db;
import '../../core/services/category_service.dart';

class CategoryManagerScreen extends StatefulWidget {
  const CategoryManagerScreen({super.key});

  @override
  State<CategoryManagerScreen> createState() => _CategoryManagerScreenState();
}

class _CategoryManagerScreenState extends State<CategoryManagerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _isar = IsarDatabase.instance;
  final _categoryService = CategoryService();
  
  List<CategoryRule> _rules = [];
  List<db.Category> _categories = [];

  final Map<String, IconData> _iconMap = {
    'restaurant': Icons.restaurant,
    'directions_car': Icons.directions_car,
    'shopping_bag': Icons.shopping_bag,
    'receipt_long': Icons.receipt_long,
    'payments': Icons.payments,
    'category': Icons.category,
    'medical_services': Icons.medical_services,
    'school': Icons.school,
    'home': Icons.home,
    'movie': Icons.movie,
    'fitness_center': Icons.fitness_center,
    'flight': Icons.flight,
    'pets': Icons.pets,
    'redeem': Icons.redeem,
    'build': Icons.build,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final rules = await _isar.categoryRules.where().sortByPriorityDesc().findAll();
    final cats = await _categoryService.getCategories();
    setState(() {
      _rules = rules;
      _categories = cats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories & Rules'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Keywords'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRulesList(),
          _buildCategoriesList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            _showRuleDialog();
          } else {
            _showCategoryDialog();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRulesList() {
    return _rules.isEmpty
        ? const Center(child: Text('No keywords yet.'))
        : ListView.builder(
            itemCount: _rules.length,
            itemBuilder: (context, index) {
              final rule = _rules[index];
              return ListTile(
                title: Text(rule.keyword, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Category: ${rule.category} • Priority: ${rule.priority}'),
                onTap: () => _showRuleDialog(rule),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _isar.writeTxn(() => _isar.categoryRules.delete(rule.id));
                    _loadData();
                  },
                ),
              );
            },
          );
  }

  Widget _buildCategoriesList() {
    return _categories.isEmpty
        ? const Center(child: Text('No categories yet.'))
        : ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: Icon(_iconMap[cat.icon] ?? Icons.category, color: Theme.of(context).primaryColor),
                ),
                title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () => _showCategoryDialog(cat),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _categoryService.deleteCategory(cat.id);
                    _loadData();
                  },
                ),
              );
            },
          );
  }

  void _showRuleDialog([CategoryRule? existingRule]) async {
    final isEditing = existingRule != null;
    final keywordController = TextEditingController(text: existingRule?.keyword ?? '');
    String selectedCategory = existingRule?.category ?? 'Other';
    final priorityController = TextEditingController(text: (existingRule?.priority ?? 1).toString());

    final availableCats = await _categoryService.getCategoryNames();
    if (!availableCats.contains(selectedCategory)) {
      selectedCategory = availableCats.isNotEmpty ? availableCats.first : 'Other';
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Keyword Rule' : 'Add Keyword Rule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: keywordController, decoration: const InputDecoration(labelText: 'Keyword (in description)')),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(labelText: 'Maps to Category'),
                items: availableCats.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setDialogState(() => selectedCategory = v!),
              ),
              TextField(controller: priorityController, decoration: const InputDecoration(labelText: 'Priority (higher = first)'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final rule = isEditing ? existingRule : CategoryRule();
                rule
                  ..keyword = keywordController.text.trim().toLowerCase()
                  ..category = selectedCategory
                  ..priority = int.tryParse(priorityController.text) ?? 1;
                
                await _isar.writeTxn(() => _isar.categoryRules.put(rule));
                if (context.mounted) Navigator.pop(context);
                _loadData();
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryDialog([db.Category? existing]) {
    final isEditing = existing != null;
    final nameController = TextEditingController(text: existing?.name ?? '');
    String selectedIcon = existing?.icon ?? 'category';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Category' : 'Add New Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Category Name')),
                const SizedBox(height: 20),
                const Text('Select Icon', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _iconMap.entries.map((e) {
                    final isSelected = selectedIcon == e.key;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedIcon = e.key),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(e.value, color: isSelected ? Colors.white : Colors.black54, size: 24),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final cat = existing ?? db.Category();
                  cat.name = nameController.text.trim();
                  cat.icon = selectedIcon;
                  await _categoryService.saveCategory(cat);
                  if (context.mounted) Navigator.pop(context);
                  _loadData();
                }
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}
