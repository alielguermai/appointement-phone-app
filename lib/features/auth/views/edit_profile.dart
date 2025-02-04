import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/features/appointments/widgets/custom_text_field.dart';
import 'package:appointement_phone_app/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String username = '';
  String phoneNumber = '';

  Future<void> saveUserData(String name, String phoneNumber) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Use merge to update existing fields
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    }
    return null;
  }

  void loadUserData() async {
    User? user = _auth.currentUser;
    Map<String, dynamic>? userData = await getUserData();
    if (userData != null) {
      setState(() {
        username = userData['name'] ?? '';
      });
    } else {
      print("User data not found");
    }
  }


  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: TAppTheme.lightTheme.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            TextField(
              decoration: InputDecoration(
                label: Text('Username'),
                hintText: username.isNotEmpty ? username : "Please enter your name",
              ),
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            SizedBox(height: 20),
            
            SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                if (username.isNotEmpty) {
                  await saveUserData(username, phoneNumber);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile Updated Successfully!')),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}