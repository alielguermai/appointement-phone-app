import 'package:appointement_phone_app/features/category/category_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final CategoryService _categoryService = CategoryService();
  final TextEditingController _controller = TextEditingController();

  void _addCategory() async {
    if (_controller.text.isNotEmpty) {
      await _categoryService.createCategory(_controller.text);
      _controller.clear();
    }
  }

  void _updateCategory(String categoryId, String newName) async {
    await _categoryService.updateCategory(categoryId, newName);
  }

  void _deleteCategory(String categoryId) async {
    await _categoryService.deleteCategory(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Enter category",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCategory,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _categoryService.getCategories(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No categories found"));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    String categoryId = doc.id;
                    String name = doc['name'];

                    return ListTile(
                      title: Text(name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _updateCategory(categoryId, "Updated Name");
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteCategory(categoryId);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
