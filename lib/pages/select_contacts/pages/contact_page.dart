import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Common/error.dart';
import '../controller/contact_repository_controller.dart';

class ContactPage extends ConsumerWidget {
  static const routeName = '/contact-screen';
  const ContactPage({super.key});
  
  void selectContact(BuildContext context, Contact selectContact, WidgetRef ref, String name) {
    ref.read(selectContactControllerProvider).selectContact(selectContact, context, name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contact'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: ref.watch(getContactProvider).when(
          data: (contactList) => ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return ListTile(
                    onTap: () => selectContact(context, contact, ref, contact.name.first),
                    title: Text(contact.displayName),
                    leading: CircleAvatar(
                      backgroundColor: CupertinoColors.systemGrey,
                      backgroundImage: contact.photo == null ? null : MemoryImage(contact.photo!),
                    ),
                  );
                },
              ),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}
