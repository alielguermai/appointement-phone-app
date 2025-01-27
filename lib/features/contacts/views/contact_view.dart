import 'package:appointement_phone_app/core/widgets/search_button.dart';
import 'package:appointement_phone_app/features/contacts/widgets/all_contacts.dart';
import 'package:appointement_phone_app/theme/theme.dart';
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
      appBar: AppBar(
        title: Text('Contact'),
        backgroundColor: TAppTheme.lightTheme.scaffoldBackgroundColor,
      ),
      backgroundColor: TAppTheme.lightTheme.scaffoldBackgroundColor,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: TAppTheme.lightBoxShadow,
              child: SearchButton(),
            ),
            Expanded(
              child: AllContacts(),
            )
          ],
        ),
      ),
    );
  }
}
