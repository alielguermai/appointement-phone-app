import 'dart:ffi';

import 'package:appointement_phone_app/core/widgets/search_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  String _phoneNumber = '';
  late Future<List<Map<String, dynamic>>> users;
  bool sat = false;

  
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final firestore = FirebaseFirestore.instance;
      
      final QuerySnapshot = await firestore.collection("users").get();

      return QuerySnapshot.docs.map((doc) {
        return {
          "docId": doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }


  @override
  void initState() {
    super.initState();
    users = fetchUsers();
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Add Contact'),
      backgroundColor: Colors.white,
    ),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: users,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final usersList = snapshot.data!;
          return TextButton(
            onPressed: () {
              // Access usersList here
              if (usersList.isNotEmpty) {
                print(usersList[0]["name"]); // For example, print the name of the first user
              }
            },
            child: Text("search"),
          );
        } else {
          return Center(child: Text("No users found"));
        }
      },
    ),
  );
}

}
