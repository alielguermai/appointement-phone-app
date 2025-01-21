import 'package:appointement_phone_app/core/widgets/search_button.dart';
import 'package:appointement_phone_app/features/contacts/widgets/recent_contacts.dart';
import 'package:flutter/material.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact'),),
      backgroundColor: Colors.black54,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SearchButton(),
            RecentContacts(),
          ],
        ),
      ),
    );
  }
}
