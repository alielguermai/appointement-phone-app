import 'package:flutter/material.dart';

class RecentContacts extends StatefulWidget {
  const RecentContacts({super.key});

  @override
  State<RecentContacts> createState() => _RecentContactsState();
}

class _RecentContactsState extends State<RecentContacts> {
  final List<Map<String, String>> contacts = [
    {"name": "Ahmed", "initials": "AH"},
    {"name": "Fatima", "initials": "FA"},
    {"name": "Youssef", "initials": "YO"},
    {"name": "Sara", "initials": "SA"},
    {"name": "Khadija", "initials": "KH"},
    {"name": "Mohammed", "initials": "MO"},
    {"name": "Rachid", "initials": "RA"},
    {"name": "Amina", "initials": "AM"},
    {"name": "Omar", "initials": "OM"},
    {"name": "Zineb", "initials": "ZI"},
  ];


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Contacts',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: contacts.map((contact) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors
                            .primaries[contacts.indexOf(contact) %
                            Colors.primaries.length], // Random color
                      ),
                      child: Center(
                        child: Text(
                          contact["initials"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      contact["name"]!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
