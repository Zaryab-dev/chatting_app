import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../contact_repository/contact_repository.dart';

final getContactProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactRepository.getContact();
});

final selectContactControllerProvider = Provider((ref) {
  final selectedContactRepository = ref.watch(selectContactsRepositoryProvider);
  return SelectContactController(
      ref: ref, selectedContactRepository: selectedContactRepository);
});

class SelectContactController {
  final ProviderRef ref;
  final SelectedContactRepository selectedContactRepository;

  SelectContactController(
      {required this.ref, required this.selectedContactRepository});

  void selectContact(Contact selectContact, BuildContext context, String name) {
    selectedContactRepository.selectContact(selectContact, context, name);
  }
}
