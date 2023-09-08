import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Common/button.dart';
import '../../../Common/utils.dart';
import '../../../colors.dart';
import '../controller/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  Country? country;
  final controller = TextEditingController();

  pickCountry() {
    showCountryPicker(context: context, onSelect: (Country _country) {
      country = _country;
      setState(() {

      });
    });
  }
  void sendPhoneNumber() {
    try{
      String phoneText = controller.text.trim();

      if(country != null && phoneText.isNotEmpty) {
        ref.read(authControllerProvider)
            .signInWithPhone(context, '+${country!.phoneCode}$phoneText');

      }else{
        showSnackbar(context, 'Fill all the fields');
      }
    }catch(e) {
      showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
    appBar: AppBar(
        title: const Text('Enter your phone number'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('WhatsApp will need to verify your phone number',),
            TextButton(onPressed: pickCountry, child: const Text('Pick Country')),
            Container(
              width: size.width * 1,
              child: Row(
                children: [
                  if(country!=null)
                  Text('+${country!.phoneCode}'),
                  SizedBox(width: size.width * 0.02,),
                  Container(
                      width: size.width * 0.7,
                      child: TextFormField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter phone number',
                        ),
                      )),
                ],
              ),
            ),
            Spacer(),
            SafeArea(child: Container(
                width: size.width * 0.25,
                child: CommonButton('Next', tabColor, Colors.white,  sendPhoneNumber )))
          ],
        ),
      ),
    );
  }
}
