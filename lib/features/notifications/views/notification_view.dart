import 'package:appointement_phone_app/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  // Get the current user ID
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Map<String, dynamic>>> fetchNotifications() {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  return FirebaseFirestore.instance
      .collection('notifications')
      .where('receiverId', isEqualTo: currentUserId)
      .orderBy('timestamp', descending: true) // Order by timestamp to get the most recent first
      .snapshots()
      .asyncMap((snapshot) async {
    List<Map<String, dynamic>> notifications = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> notification = doc.data() as Map<String, dynamic>;
      notification['id'] = doc.id; // Add the document ID to the notification map
      String senderId = notification['senderId'];

      // Fetch sender details from the users collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        notification['senderName'] = userData['name'] ?? 'Unknown';
        notification['senderProfilePic'] = userData['profilePic'] ?? '';
      } else {
        notification['senderName'] = 'Unknown';
        notification['senderProfilePic'] = '';
      }

      notifications.add(notification);
    }

    // Sort notifications: isRead = false first, then isRead = true, both sorted by timestamp
    notifications.sort((a, b) {
      if (a['isRead'] == b['isRead']) {
        // If both have the same isRead status, sort by timestamp (most recent first)
        return b['timestamp'].compareTo(a['timestamp']);
      } else {
        // isRead = false comes before isRead = true
        return a['isRead'] ? 1 : -1;
      }
    });

    return notifications;
  });
}

  void markNotificationAsRead(String notificationId) {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true})
        .then((_) {
      print('Notification marked as read');
    }).catchError((error) {
      print('Failed to mark notification as read: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: TAppTheme.lightTheme.scaffoldBackgroundColor,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: fetchNotifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No notifications found.'));
              } else {
                final notifications = snapshot.data!;
                return Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: notification['senderProfilePic'] != null &&
                                    notification['senderProfilePic'].isNotEmpty
                                ? NetworkImage(notification['senderProfilePic'])
                                : null,
                            child: notification['senderProfilePic'] == null ||
                                    notification['senderProfilePic'].isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(notification['message']),
                          subtitle: Text(
                            'From: ${notification['senderName']}\n'
                            'Type: ${notification['type']}\n'
                          ),
                          trailing: IconButton(
                            icon: notification['isRead'] == false
                                ? const Icon(Icons.mark_as_unread, color: Colors.red)
                                : const Icon(Icons.mark_email_read, color: Colors.green),
                            onPressed: () {
                              if (notification['isRead'] == false) {
                                markNotificationAsRead(notification['id']);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}