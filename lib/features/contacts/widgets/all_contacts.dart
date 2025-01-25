import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class AllContacts extends StatefulWidget {
  const AllContacts({super.key});

  @override
  State<AllContacts> createState() => _AllContactsState();
}

List<Contact> contacts = [];

class _AllContactsState extends State<AllContacts> {

  Future<void> getPermissionAndFetchContacts() async {
    var result = await Permission.contacts.request();

    if (result.isGranted) {
      fetchContacts();
    } else if (result.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contacts permission is required to proceed.')),
      );
    } else if (result.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> fetchedContacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
      setState(() {
        contacts = fetchedContacts;
      });
    } else {
      print('Permission Denied For FlutterContacts');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contacts permission denied. Please enable it in settings.')),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    getPermissionAndFetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      alignment: Alignment.topLeft,
      child: contacts.isEmpty
          ? Center(
        child: Text(
          'No contacts found or permission denied.',
          style: TextStyle(color: Colors.white),
        ),
      )
          : Expanded( // Use Expanded to avoid overflow
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contacts.map((contact) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    contact.photo != null
                        ? CircleAvatar(
                      backgroundImage: MemoryImage(contact.photo!),
                      radius: 24,
                    )
                        : CircleAvatar(
                      radius: 24,
                      child: Text(
                        contact.displayName.isNotEmpty
                            ? contact.displayName[0].toUpperCase()
                            : '',
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.displayName,
                          style: Theme.of(context).textTheme.bodyMedium
                        ),
                        Text(
                          contact.phones.isNotEmpty
                              ? contact.phones.first.number
                              : 'No phone number',
                          style: Theme.of(context).textTheme.bodySmall
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}



// A class for favorit contact
class FavoriteContact extends StatefulWidget {
  const FavoriteContact({super.key});

  @override
  State<FavoriteContact> createState() => _FavoriteContactState();
}

class _FavoriteContactState extends State<FavoriteContact> {
  List<Contact> favoriteContacts = [];
  // i want a function that show all the

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
