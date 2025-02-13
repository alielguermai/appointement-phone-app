import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:flutter/material.dart';


class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Column(
        children: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pushNamed(AppRoutes.LoginEmailPage);
            },
            child: Text('Login with an email'),
          ),

          TextButton(
            onPressed: (){
              Navigator.of(context).pushNamed(AppRoutes.loginPageRoute);
            },
            child: Text('Login with a phone number'),
          )
        ],
      ),
      ),
    );
  }
}
