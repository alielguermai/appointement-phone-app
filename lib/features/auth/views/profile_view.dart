import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/features/auth/views/logout.dart';
import 'package:appointement_phone_app/theme/theme.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: TAppTheme.lightTheme.scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          )
        ],
      ),
      body: Logout(),
    );
  }
}
