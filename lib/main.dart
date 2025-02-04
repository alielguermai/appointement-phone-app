import 'package:appointement_phone_app/config/routes/auth_wrapper.dart';
import 'package:appointement_phone_app/config/routes/router.dart';
import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/features/landingPage/landing_page.dart';
import 'package:appointement_phone_app/features/reminder/widgets/noti_service.dart';
import 'package:appointement_phone_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // This is where you handle the background task
    final notiService = NotiService();
    await notiService.initNotification();

    // Construct a DateTime object from the input data
    final reminderTime = DateTime.now().add(Duration(
      hours: inputData!['hour'],
      minutes: inputData['minute'],
    ));

    await notiService.scheduleNotification(
      title: inputData['title'],
      body: inputData['body'],
      reminderTime: reminderTime, // Pass the DateTime object here
    );
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotiService().initNotification();
  final notiService = NotiService();
  await notiService.initNotification();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase connection successful');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  // Initialize Workmanager
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

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
      home: AuthWrapper(),
      onGenerateRoute: onGenerate,
      initialRoute: AppRoutes.loginPageRoute,
    );
  }
}