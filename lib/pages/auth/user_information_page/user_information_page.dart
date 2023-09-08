import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Common/pick_image.dart';
import '../../../Common/utils.dart';
import '../controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const routeName = '/user-information-screen';

  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  File? image;
  final nameController = TextEditingController();

  void selectImage() async{
    image = await pickImageFromGallery(context);
    setState(() {

    });
  }
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void saveUser() {
    String name = nameController.text.trim();
    if(name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirestore(context, image, name);
    }else{
      showSnackbar(context, 'Please enter your name');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height *0.03,),
            Center(
              child: Stack(
                // alignment: Alignment.center,
                children: [
                  image == null ? const CircleAvatar(
                    radius: 64,
                    backgroundColor: CupertinoColors.systemGrey2,
                  ) : CircleAvatar(
                    radius: 64,
                    backgroundImage: FileImage(image!),
                  ),
                  Positioned(
                      bottom: -10,
                      right: 1,
                      child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo_outlined)))
                ],
              ),
            ),
            SizedBox(height: size.height *0.03,),
            SizedBox(width: size.width * 0.87,
            child: Row(
              children: [
                Container(
                  width: size.width * 0.70,
                  // height: size.height * 0.05,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(50)
                      )
                    ),
                  ),
                ),
                IconButton(onPressed: saveUser, icon: const Icon(Icons.done))
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}
