import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RecentContacts extends StatefulWidget {
  const RecentContacts({super.key});

  @override
  State<RecentContacts> createState() => _RecentContactsState();
}

class _RecentContactsState extends State<RecentContacts> {
  List<CallLogEntry> recentCalls = []; // Holds recent call log entries

  @override
  void initState() {
    super.initState();
    fetchRecentCalls(); // Fetch call logs when the widget is initialized
  }

  Future<void> fetchRecentCalls() async {
    // Request permission to access call logs
    var status = await Permission.phone.request();

    if (status.isGranted) {
      // Fetch call logs
      Iterable<CallLogEntry> entries = await CallLog.get();

      setState(() {
        recentCalls = entries.toList(); // Store call logs in the state
      });
    } else if (status.isDenied) {
      print("Call log permission denied");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

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
              children: recentCalls.map((call) {
                // Map each call log entry to a UI element
                String nameOrNumber = call.name ?? call.number ?? "Unknown";
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.primaries[
                        recentCalls.indexOf(call) % Colors.primaries.length],
                      ),
                      child: Center(
                        child: Text(
                          nameOrNumber.isNotEmpty
                              ? nameOrNumber[0].toUpperCase() // First letter
                              : '?',
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
                      nameOrNumber,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
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
