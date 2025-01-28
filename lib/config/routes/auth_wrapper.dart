import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:appointement_phone_app/features/auth/views/login_view.dart';
import 'package:appointement_phone_app/features/landingPage/landing_page.dart';
import 'package:appointement_phone_app/index.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // Check if the user is logged in
          final User? user = snapshot.data;
          if (user != null) {
            // User is logged in, redirect to the home page
            return const HomePage();
          } else {
            // User is not logged in, redirect to the landing page
            return const LandingPage();
          }
        }
        // Show a loading indicator while checking the auth state
        return const CupertinoPageScaffold(
          child: Center(child: CupertinoActivityIndicator()),
        );
      },
    );
  }
}