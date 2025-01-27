import 'package:appointement_phone_app/features/notifications/widgets/notification_widget.dart';
import 'package:appointement_phone_app/theme/theme.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification'),
        backgroundColor: TAppTheme.lightTheme.scaffoldBackgroundColor,
      ),
      body: Container(
        child: SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                decoration: TAppTheme.lightBoxShadow,
                child: NotificationWidget(),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: TAppTheme.lightBoxShadow,
                child: NotificationWidget(),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: TAppTheme.lightBoxShadow,
                child: NotificationWidget(),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: TAppTheme.lightBoxShadow,
                child: NotificationWidget(),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: TAppTheme.lightBoxShadow,
                child: NotificationWidget(),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: TAppTheme.lightBoxShadow,
                child: NotificationWidget(),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: TAppTheme.lightBoxShadow,
                child: NotificationWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
