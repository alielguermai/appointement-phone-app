import 'package:appointement_phone_app/features/appointments/views/calendar_view.dart';
import 'package:appointement_phone_app/features/auth/views/profile_view.dart';
import 'package:appointement_phone_app/features/contacts/views/contact_view.dart';
import 'package:appointement_phone_app/features/contacts/widgets/favorite_contacts.dart';
import 'package:appointement_phone_app/features/notifications/views/notification_view.dart';
import 'package:appointement_phone_app/theme/theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const List<Widget> _pages =[
    FavoriteContacts(),
    CalendarView(),
    ContactView(),
    NotificationView(),
    ProfileView(),
  ];

  final List<BottomNavigationBarItem> _navBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.star),
      label: 'Favorite',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month),
      label: 'Calendar',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.people_rounded),
      label: 'Contacts',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.notification_important_rounded),
      label: 'Notification',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    )
  ];

  void _onItemTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: _navBarItems,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedIconTheme: IconThemeData(size: 26),
        unselectedIconTheme: IconThemeData(size: 26),
        backgroundColor: TAppTheme.lightTheme.scaffoldBackgroundColor,
      ),
    );
  }
}
