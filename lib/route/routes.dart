import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Common/error.dart';
import '../pages/auth/landing_page/landing_page.dart';
import '../pages/auth/login_page/login_page.dart';
import '../pages/auth/login_page/otp_screen.dart';
import '../pages/auth/user_information_page/user_information_page.dart';
import '../pages/select_contacts/pages/contact_page.dart';
import '../screens/mobile_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LandingPage.routeName:
      return MaterialPageRoute(builder: (context) => LandingPage());
      case LoginPage.routeName:
      return MaterialPageRoute(builder: (context) => LoginPage());
      case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context) => UserInformationScreen());
      case ContactPage.routeName:
      return MaterialPageRoute(builder: (context) => ContactPage());
      case MobileChatScreen.routeName:
        final arguments = settings.arguments as Map<String, dynamic>;
        final name = arguments['name'];
        final uid = arguments['uid'];
      return MaterialPageRoute(builder: (context) => MobileChatScreen(
        name: name,
        uid: uid,
      ));
      case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: verificationId,
              ));
    default:
      return MaterialPageRoute(
          builder: (context) => Scaffold(
                body: ErrorScreen(
                  error: "This page doesn't exist",
                ),
              ));
  }
}
