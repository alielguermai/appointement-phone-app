import 'package:appointement_phone_app/core/widgets/search_button.dart';
import 'package:flutter/material.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Search by Phone number', style: TextStyle(
                  color: Colors.black
                ),),
                TextField(
                  decoration: InputDecoration(
                    label: Text("Phone number")
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
