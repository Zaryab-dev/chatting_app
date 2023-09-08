import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.authRepository, required this.ref});

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, userOTP) {
    authRepository.verifyOTP(
        verificationId: verificationId, context: context, userOTP: userOTP);
  }

  void saveUserDataToFirestore(
      BuildContext context, File? profilePic, String name) {
    authRepository.saveUserToFirestore(
        context: context, profilePic: profilePic, ref: ref, name: name);
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void updateOnlineStatus(bool isOnline) {
    authRepository.updateOnlineStatus(isOnline);
  }
}
