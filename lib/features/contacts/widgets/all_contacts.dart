import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AllContacts extends StatefulWidget {
  const AllContacts({super.key});

  @override
  State<AllContacts> createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  Future<void> getAllContacts() async {
    // Request permission to access contacts
    PermissionStatus permissionStatus = await Permission.contacts.request();

    if (permissionStatus.isGranted) {
      try {
        List<Contact> _contacts =
        await ContactsService.getContacts(withThumbnails: false);

        // Print all contacts in the console
        for (var contact in _contacts) {
          print('Name: ${contact.displayName}');
          print('Phone: ${contact.phones?.map((e) => e.value).join(', ')}');
          print('Email: ${contact.emails?.map((e) => e.value).join(', ')}');
          print('---');
        }

        // Update state to store the contacts
        setState(() {
          contacts = _contacts;
        });
      } catch (e) {
        print('Error fetching contacts: $e');
      }
    } else {
      print('Permission to access contacts was denied.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Contacts')),
      body: contacts.isEmpty
          ? const Center(child: Text('No contacts found or permission denied.'))
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.displayName ?? 'No Name'),
            subtitle: Text(
              contact.phones?.map((e) => e.value).join(', ') ?? 'No Phone',
            ),
          );
        },
      ),
    );
  }
}
