import 'dart:io';

import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  String username = '';
  String phone_number = '';
  String? imageUrl;
  File? _image;

  Future<void> saveUserData(String name, String? imageUrl) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': user.email,
        'imageUrl': imageUrl,
        'phoneNumber': user.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
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
    Map<String, dynamic>? userData = await getUserData();
    if (userData != null) {
      setState(() {
        username = userData['name'] ?? '';
        imageUrl = userData['imageUrl'];
        phone_number = userData['phoneNumber'] ?? '';
      });
    }
  }


  Future<void> pickImage() async {
     
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await uploadImage();
      }
  }

  Future<void> uploadImage() async {
    if (_image == null) return;
    User? user = _auth.currentUser;
    if (user != null) {
      String filePath = 'profile_images/${user.uid}.jpg';
      UploadTask uploadTask = _storage.ref(filePath).putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
      await saveUserData(username, imageUrl);
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
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
                child: imageUrl == null ? Icon(Icons.camera_alt, size: 40) : null,
              ),
            ),
            SizedBox(height: 20),
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

            TextField(
              decoration: InputDecoration(
                label: Text('User Phone number'),
                hintText: phone_number.isNotEmpty ? phone_number : "Please Enter you  phone number",
              ),
              onChanged: (value){
                setState(() {
                  phone_number = value;
                });
              },
            ),
            SizedBox(height: 20),

            TextButton(
              onPressed: () async {
                if (username.isNotEmpty) {
                  await saveUserData(username, imageUrl);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile Updated Successfully!')),
                  );
                    Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.editProfilePage,
                    (Route<dynamic> route) => false,
                  );
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