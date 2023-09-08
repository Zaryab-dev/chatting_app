import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Common/utils.dart';
import '../controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const routeName = '/otp-screen';
  final String verificationId;

  const OTPScreen({super.key, required this.verificationId});

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.06,
            ),
            const Text('We have sent an SMS with code'),
            SizedBox(
              width: size.width * 0.6,
              child: TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 35, letterSpacing: 2,wordSpacing: 2),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none
                  )
                ),
                onChanged: (value) {
                  if(value.length == 6) {
                    verifyOTP(ref, context, value.trim());
                  }else if(value.length > 6) {
                    showSnackbar(context, 'OTP contain only 6 letters');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
