import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/features/appointments/views/next_day_appointments.dart';
import 'package:appointement_phone_app/features/appointments/views/today_appointements.dart';
import 'package:appointement_phone_app/features/appointments/widgets/test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final List<String> titles = ['All', 'Personal', 'Business'];
  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  DateTime selectedDate = DateTime.now();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? UserName;

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
    User? user = _auth.currentUser;
    Map<String, dynamic>? userData = await getUserData();
    if (userData != null) {
      setState(() {
        UserName = userData['name'] ?? '';
      });
    } else {
      print("User data not found");
    }
  }

  void onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    // Calculate the index of the selected date
    int daysDifference = date.difference(DateTime.now()).inDays;
    if (daysDifference > 0) {
      // Calculate approximate scroll position (adjust these values based on your layout)
      double approximateItemHeight = 150.0; // Height of each day's appointments section
      double scrollPosition = (daysDifference - 1) * approximateItemHeight;
      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              "${UserName}",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.newAppointment);
            },
            style: ButtonStyle(
                backgroundColor: WidgetStateColor.transparent
            ),
            child: Text(
              'Add',
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.notificationPage);
              },
              icon: Icon(Icons.notification_important_sharp, color: Colors.grey.shade600)
          )
        ],
      ),
      body: Column(
        children: [
          WeekCalendarPage(
            selectedDate: selectedDate,
            onDateSelected: onDateSelected,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TodayAppointments(),
                  NextDaysAppointments(
                    numberOfDays: 7,
                    scrollController: _scrollController,
                    onDayVisible: (DateTime date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}