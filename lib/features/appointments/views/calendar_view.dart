import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/core/widgets/table_calendar.dart';
import 'package:appointement_phone_app/features/appointments/views/next_day_appointments.dart';
import 'package:appointement_phone_app/features/appointments/views/today_appointements.dart';
import 'package:appointement_phone_app/features/appointments/views/tomorrow_appointements.dart';
import 'package:appointement_phone_app/features/appointments/widgets/day_appointments.dart';
import 'package:appointement_phone_app/features/appointments/widgets/test.dart';
import 'package:appointement_phone_app/theme/theme.dart';
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
    Map<String, dynamic> ? userData = await getUserData();
    if (userData != null){
      setState(() {
        UserName = userData['name'] ?? '';
      });
    } else {
      print("User data not found");
    }
  }

  void getUser() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50)
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text("User Name"),
          ],
        ),
        backgroundColor: TAppTheme.lightTheme.scaffoldBackgroundColor,
        actions: [
          TextButton(
            onPressed:(){
              Navigator.of(context).pushNamed(AppRoutes.newAppointment);
            }
            ,
            style: ButtonStyle(
              backgroundColor: WidgetStateColor.transparent
            ),
            child: Text('Add', style: TextStyle(color: Colors.grey),),
          ),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, AppRoutes.notificationPage);
            },
            icon: Icon(Icons.notifications)
          )
        ],
      ),
      body: Column(
        children: [
          WeekCalendarPage(), // This will stay fixed
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TodayAppointments(),
                  //NextDaysAppointments(numberOfDays: 7)
                  NextDaysAppointments()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


