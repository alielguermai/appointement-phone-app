import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/features/landingPage/landing_page.dart';
import 'package:appointement_phone_app/index.dart';
import 'package:flutter/cupertino.dart';

Route<dynamic> onGenerate(RouteSettings settings){
  switch(settings.name){
    case AppRoutes.homePageRoute:
      return CupertinoPageRoute(builder: (_) => const HomePage());
    case AppRoutes.landingPageRoute:
      return CupertinoPageRoute(builder: (_) => const LandingPage());
    default:
      return CupertinoPageRoute(builder: (_) => const LandingPage());
  }
}