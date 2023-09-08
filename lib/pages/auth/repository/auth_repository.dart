import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Common/firebase_storage_repository.dart';
import '../../../Common/utils.dart';
import '../../../models/user_model.dart';
import '../../../screens/mobile_layout_screen.dart';
import '../login_page/otp_screen.dart';
import '../user_information_page/user_information_page.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) async {
            showSnackbar(context, 'verification failed ${e.message}');
          },
          codeSent: (String verificationId, int? resendToken) async {
            Navigator.of(context)
                .pushNamed(OTPScreen.routeName, arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) async {});
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, ' failed ${e.message}');
    }
  }

  void verifyOTP(
      {required String verificationId,
      required BuildContext context,
      required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.of(context).pushNamedAndRemoveUntil(
          UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, ' failed ${e.message}');
    }
  }

  void saveUserToFirestore({
    required BuildContext context,
    required File? profilePic,
    required ProviderRef ref,
    required String name,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = '';
      if (profilePic != null) {
        photoUrl = await ref
            .read(firebaseStorageRepositoryProvider)
            .saveFileToFirestore('profilePic/$uid', profilePic);
      }
      var user = UserModel(
          uid: uid,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          name: name,
          profilePic: photoUrl);
      await firestore.collection('Users').doc(uid).set(user.toJson());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
          (route) => false);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('Users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromJson(userData.data()!);
    }
    return user;
  }

  Stream<UserModel> userData(String userId) {
    return firestore
        .collection('Users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()!));
  }

  void updateOnlineStatus(bool isOnline) async {
    await firestore.collection("Users").doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
