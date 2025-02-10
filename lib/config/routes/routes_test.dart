import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/features/appointments/views/appointments.dart';
import 'package:appointement_phone_app/features/appointments/views/edit_appointments.dart';
import 'package:appointement_phone_app/features/auth/views/edit_profile.dart';
import 'package:appointement_phone_app/features/contacts/views/add_contact.dart';
import 'package:appointement_phone_app/features/landingPage/landing_page.dart';
import 'package:appointement_phone_app/features/notifications/views/notification_view.dart';
import 'package:appointement_phone_app/features/settings/views/settings_view.dart';
import 'package:appointement_phone_app/index.dart';
import 'package:flutter/cupertino.dart';


Route<dynamic> onGenerate(RouteSettings settings) {

  switch (settings.name){
    case AppRoutes.homePageRoute:
      return CupertinoPageRoute(
        builder: (_) => HomePage()
      );
    case AppRoutes.newAppointment:
      return CupertinoPageRoute(
        builder: (_) => const Appointments()
      );

    case AppRoutes.editAppointment:
      return CupertinoPageRoute(
        builder: (_) =>  EditAppointments(),
        settings: settings,
      );
    
    case AppRoutes.settings:
      return CupertinoPageRoute(
        builder: (_) =>  SettingsView(),
      );
    case AppRoutes.notificationPage:
      return CupertinoPageRoute(
        builder: (_) =>  NotificationView(),
      );

    case AppRoutes.editProfilePage:
      return CupertinoPageRoute(
        builder: (_) => EditProfile(),
      );
    
    case AppRoutes.AddContactPage:
      return CupertinoPageRoute(
        builder: (_) => AddContact(),
      );
    default:
      return CupertinoPageRoute(
        builder: (_) => LandingPage()
      );
  }
}

