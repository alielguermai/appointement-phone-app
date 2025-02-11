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


  Future<DocumentSnapshot?> searchUserByPhoneNumber(String phoneNumber) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final querySnapshot = await usersRef.where('phoneNumber', isEqualTo: phoneNumber).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    }
    return null;
  }

  void searchForFriend() async {
    String phoneNumber = "+212612345678";
    var userDoc = await searchUserByPhoneNumber(phoneNumber);
    if (userDoc != null) {
      print("User Found: ${userDoc.data()}");
    } else {
      print("User Not Found");
    }
  }


  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    final receiverRef = FirebaseFirestore.instance.collection('users').doc(receiverId);

    await receiverRef.update({
      'friendRequests': FieldValue.arrayUnion([senderId])
    });

    print("Friend request sent!");
  }

  void sendRequest(String senderId, String receiverId) async {
    await sendFriendRequest(senderId, receiverId);
  }


  @override
  void initState() {
    super.initState();
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
              searchForFriend();
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
