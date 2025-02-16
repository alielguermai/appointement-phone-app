import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get current user id
  String get _userId {
    final user = _auth.currentUser;
    if (user==null) throw Exception("User not logged in");
    return user.uid;
  }

  // create a new category
  Future<void> createCategory(String name) async {
    await _firestore.collection('categories').doc(_userId).collection('userCategories').add({
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get all categories for the current user
  Stream<QuerySnapshot> getCategories() {
    return _firestore.collection('categories').doc(_userId).collection('userCategories').snapshots();
  }

  // Update a category
  Future<void> updateCategory(String categoryId, String newName) async {
    await _firestore
        .collection('categories')
        .doc(_userId)
        .collection('userCategories')
        .doc(categoryId)
        .update({'name': newName});
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    await _firestore
        .collection('categories')
        .doc(_userId)
        .collection('userCategories')
        .doc(categoryId)
        .delete();
  }

}