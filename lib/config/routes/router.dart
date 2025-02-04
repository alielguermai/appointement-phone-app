import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/features/appointments/views/appointments.dart';
import 'package:appointement_phone_app/features/appointments/views/edit_appointments.dart';
import 'package:appointement_phone_app/features/auth/views/edit_profile.dart';
import 'package:appointement_phone_app/features/auth/views/login_view.dart';
import 'package:appointement_phone_app/features/auth/views/verification_view.dart';
import 'package:appointement_phone_app/features/landingPage/landing_page.dart';
import 'package:appointement_phone_app/features/notifications/views/notification_view.dart';
import 'package:appointement_phone_app/features/settings/views/settings_view.dart';
import 'package:appointement_phone_app/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

Route<dynamic> onGenerate(RouteSettings settings) {
  final User? user = FirebaseAuth.instance.currentUser;

  switch (settings.name) {
  // Public routes (accessible only if the user is not logged in)
    case AppRoutes.landingPageRoute:
      return CupertinoPageRoute(
        builder: (_) => user == null ? const LandingPage() : const HomePage(),
      );
    case AppRoutes.loginPageRoute:
      return CupertinoPageRoute(
        builder: (_) => user == null ? LoginView() : const HomePage(),
      );
    case AppRoutes.otpPageRoute:
      return CupertinoPageRoute(
        builder: (_) => user == null ? const OTPVerificationPage() : const HomePage(),
      );

  // Private routes (accessible only if the user is logged in)
    case AppRoutes.homePageRoute:
      return CupertinoPageRoute(
        builder: (_) => user != null ? const HomePage() : const LandingPage(),
      );

    case AppRoutes.newAppointment:
      return CupertinoPageRoute(
        builder: (_) => user != null ? const Appointments() : const LandingPage(),
      );

    case AppRoutes.editAppointment:
      return CupertinoPageRoute(
        builder: (_) => user != null
            ? EditAppointments()
            : const LandingPage(),
        settings: settings,
      );
    
    case AppRoutes.settings:
      return CupertinoPageRoute(
        builder: (_) => user != null ? const SettingsView() : const LandingPage(),
      );
    case AppRoutes.notificationPage:
      return CupertinoPageRoute(
        builder: (_) => user != null ? NotificationView() : const LandingPage(),
      );

    case AppRoutes.editProfilePage:
      return CupertinoPageRoute(
        builder: (_) => user != null ? const EditProfile() : const LandingPage(),
      );

  // Default route (landing page)
    default:
      return CupertinoPageRoute(
        builder: (_) => const LandingPage(),
      );
  }
}