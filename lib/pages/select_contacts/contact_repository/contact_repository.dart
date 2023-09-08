import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Common/utils.dart';
import '../../../models/user_model.dart';
import '../../../screens/mobile_chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
    (ref) => SelectedContactRepository(firestore: FirebaseFirestore.instance));

class SelectedContactRepository {
  final FirebaseFirestore firestore;

  SelectedContactRepository({required this.firestore});

  Future<List<Contact>> getContact() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);
      }
    } catch (e) {
      print(e.toString());
    }
    return contacts;
  }
  void selectContact(Contact selectContact, BuildContext context, String name) async {
    var userCollection = await firestore.collection('Users').get();
    bool isFound = false;
    try{
      for(var document in userCollection.docs) {
        var userData = UserModel.fromJson(document.data());
        String phoneNumber = selectContact.phones[0].number.replaceAll(' ', '');
        // print(phoneNumber);
        if(phoneNumber == userData.phoneNumber) {
          showSnackbar(context, 'Chatting with $name');
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            'name' : userData.name,
            'uid' : userData.uid,
          });
        }
      }
      if(!isFound) {
        showSnackbar(context, 'This number does not exist');
      }
    }catch(e) {
      // ignore: use_build_context_synchronously
      showSnackbar(context, e.toString());
    }
  }
}
