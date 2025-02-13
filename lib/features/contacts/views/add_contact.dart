import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  DocumentSnapshot? searchedUser;

  /// Search for user by phone number
  Future<void> searchUserByPhoneNumber() async {
    String phoneNumber = phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a phone number")),
      );
      return;
    }

    final usersRef = FirebaseFirestore.instance.collection('users');
    final querySnapshot = await usersRef.where('phoneNumber', isEqualTo: phoneNumber).get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        searchedUser = querySnapshot.docs.first;
      });
    } else {
      setState(() {
        searchedUser = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not found")),
      );
    }
  }


  /// Search for ser by email
  Future<void> searchUserByEmail() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a email address")),
      );
      return;
    }

    final usersRef = FirebaseFirestore.instance.collection('users');
    final querySnapshot = await usersRef.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        searchedUser = querySnapshot.docs.first;
      });
    } else {
      setState(() {
        searchedUser = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not found")),
      );
    }
  }

  /// Send friend request
  Future<void> sendFriendRequest(String receiverId) async {
    final senderId = FirebaseAuth.instance.currentUser?.uid;

    if (senderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must be logged in to send a friend request")),
      );
      return;
    }

    final receiverRef = FirebaseFirestore.instance.collection('users').doc(receiverId);

    // Add the sender's ID to the receiver's friend requests
    await receiverRef.update({
      'friendRequests': FieldValue.arrayUnion([senderId])
    });

    // Add a notification in the 'notifications' collection
    await FirebaseFirestore.instance.collection('notifications').add({
      'receiverId': receiverId,
      'senderId': senderId,
      'type': 'friend_request',
      'message': 'You have a new friend request!',
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false, // You can use this to track unread notifications
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Friend request sent!")),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Enter phone number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Entre  address mail",
                border: OutlineInputBorder()
              ),
            ),
            ElevatedButton(
              onPressed: searchUserByPhoneNumber,
              child: Text("Search"),
            ),
            ElevatedButton(
              onPressed: searchUserByEmail,
              child: Text("Search"),
            ),

            SizedBox(height: 20),

            if (searchedUser != null) ...[
              Text("User Found: ${searchedUser!['name']}"),
              Text("User ID: ${searchedUser!.id}"),
              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {

                  sendFriendRequest(searchedUser!.id);
                },
                child: Text("Send Friend Request"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
