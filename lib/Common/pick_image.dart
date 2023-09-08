import 'dart:io';

import 'package:chatting_app/Common/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;

  final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    image = File(pickedImage.path);
  } else {
    showSnackbar(context, 'No Image selected!');
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;

  final pickedVideo =
      await ImagePicker().pickVideo(source: ImageSource.gallery);
  if (pickedVideo != null) {
    video = File(pickedVideo.path);
  } else {
    showSnackbar(context, 'No Video selected!');
  }
  return video;
}
