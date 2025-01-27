import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/features/appointments/views/appointments.dart';
import 'package:appointement_phone_app/features/auth/views/login_view.dart';
import 'package:appointement_phone_app/features/auth/views/verification_view.dart';
import 'package:appointement_phone_app/features/landingPage/landing_page.dart';
import 'package:appointement_phone_app/index.dart';
import 'package:flutter/cupertino.dart';

Route<dynamic> onGenerate(RouteSettings settings){
  switch(settings.name){
    case AppRoutes.newAppointment:
      return CupertinoPageRoute(builder: (_) => const Appointments());
    case AppRoutes.otpPageRoute:
      return CupertinoPageRoute(builder: (_) => const OTPVerificationPage());
    case AppRoutes.loginPageRoute:
      return CupertinoPageRoute(builder: (_) => const LoginView());
    case AppRoutes.homePageRoute:
      return CupertinoPageRoute(builder: (_) => const HomePage());
    case AppRoutes.landingPageRoute:
      return CupertinoPageRoute(builder: (_) => const LandingPage());
    default:
      return CupertinoPageRoute(builder: (_) => const LandingPage());
  }
}