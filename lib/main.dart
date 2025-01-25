import 'package:appointement_phone_app/config/routes/router.dart';
import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/features/landingPage/landing_page.dart';
import 'package:appointement_phone_app/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment demo',
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: LandingPage(),
      onGenerateRoute: onGenerate,
      initialRoute: AppRoutes.homePageRoute,
    );
  }
}
