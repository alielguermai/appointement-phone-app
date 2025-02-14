import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/core/widgets/search_button.dart';
import 'package:appointement_phone_app/features/contacts/views/friends.dart';
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Contact'),
            Row(
              children: [
                 IconButton(
              onPressed: (){
                Navigator.of(context).pushNamed(AppRoutes.AddContactPage);
              },
              icon: Icon(Icons.add),
            ),
            IconButton(
              onPressed: (){
                Navigator.pushNamed(context, AppRoutes.FriendsRequestPgae);
              },
              icon: Icon(Icons.person_add_outlined),
            )
              ],
            )
          ],
        ),
        backgroundColor: TAppTheme.lightTheme.scaffoldBackgroundColor,
      ),
      backgroundColor: TAppTheme.lightTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Accout Contacts'),
            Friends(),
            Text('Phone Contacts'),
            //AllContacts(),
          ],
        ),
      ),
    );
  }
}


/*

Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: TAppTheme.lightBoxShadow,
              child: SearchButton(),
            ),
            TextButton(
              onPressed: (){
                Navigator.pushNamed(context, AppRoutes.FriendsRequestPgae);
              },
              child: Icon(Icons.contacts),
            ),
            Friends(),
            Expanded(
              child: AllContacts(),
            )
          ],
        ),
      ),



      */