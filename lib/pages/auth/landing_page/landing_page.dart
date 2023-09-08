import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Common/button.dart';
import '../../../colors.dart';
import '../login_page/login_page.dart';
class LandingPage extends StatelessWidget {
  static const routeName = '/';
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.02,),
          Center(child: Text('Welcome to WhatsApp',textAlign: TextAlign.center, style: TextStyle(fontSize: size.height * 0.03, fontWeight: FontWeight.bold,),)),
          SizedBox(height: size.height * 0.05,),
          Image.asset('assets/img.png', width: size.width * 0.75,height: size.height * 0.45,),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text('Please read our privacy policy. "Tap Agree & Continue" to accept the terms of service',
              style: TextStyle(color: CupertinoColors.systemGrey2,fontSize: size.height * 0.016),textAlign: TextAlign.center,),
          ),
          SizedBox(height: size.height * 0.01,),
          CommonButton('Agree and Continue', tabColor, Colors.white,
                () => Navigator.pushNamed(context, LoginPage.routeName),)
        ],
      )),
    );
  }
}
