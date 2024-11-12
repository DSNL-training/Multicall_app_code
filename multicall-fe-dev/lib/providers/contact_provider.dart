import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:multicall_mobile/utils/ensure_permission.dart';

class ContactMember {
  String? phoneNumber;
  String? name;
  String? email;

  ContactMember({this.phoneNumber, this.name, this.email});
}

class ContactProvider with ChangeNotifier {
  final Map<String, ContactMember> _contactsCache = {};
  List<Contact>? _allContacts;
  Map<String, List<Contact>>? _groupedContacts;
  String _searchQuery = '';

  ContactProvider() {
    fetchContacts();
  }

  List<Contact>? get allContacts => _allContacts;

  set allContacts(List<Contact>? contacts) {
    _allContacts = contacts;
    notifyListeners();
  }

  Map<String, List<Contact>>? get groupedContacts => _groupedContacts;

  set searchQuery(String query) {
    _searchQuery = query;
    groupContacts();
  }

  fetchContacts() async {
    await checkPermission();
    allContacts = await ContactsService.getContacts(withThumbnails: false);

    /// Remove contacts without phone numbers
    allContacts = allContacts
        ?.where((contact) => contact.phones?.isNotEmpty == true)
        .toList();
    groupContacts();
  }

  Future<void> checkPermission() async {
    bool hasPermission = await ensureContactPermission();
    if (!hasPermission) {
      debugPrint("Permission denied for contacts.");
      return;
    }
  }

  /// Fetch contact details manually by filtering contacts
  Future<ContactMember?> getMappedMember(String phoneNumber) async {
    if (_contactsCache.containsKey(phoneNumber)) {
      return _contactsCache[phoneNumber];
    }
    await checkPermission();
    Iterable<Contact> contacts =
        await ContactsService.getContactsForPhone(phoneNumber);
    String normalizedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    for (var contact in contacts) {
      for (var item in contact.phones ?? <Item>[]) {
        String normalizedContactPhone =
            item.value?.replaceAll(RegExp(r'\D'), '') ?? '';
        if (normalizedContactPhone == normalizedPhoneNumber) {
          ContactMember contactMember = ContactMember(
            phoneNumber: phoneNumber,
            name: contact.displayName,
          );

          if (contact.emails != null && contact.emails!.isNotEmpty) {
            contactMember.email = contact.emails!.first.value;
          }

          _contactsCache[phoneNumber] = contactMember;
          notifyListeners();
          return contactMember;
        }
      }
    }

    return null; // No match found
  }

  // Fetch and return member names for a list of phone numbers
  Future<List<String>> fetchMemberNames(List<String> phoneNumbers) async {
    List<String> names = [];
    for (var phoneNumber in phoneNumbers) {
      final contactMember = await getMappedMember(phoneNumber);
      if (contactMember != null && contactMember.name != null) {
        names.add(contactMember.name!);
      } else {
        names.add(phoneNumber); // fallback to phone number if no name is found
      }
    }
    return names;
  }

  void groupContacts() {
    // Made public
    if (_allContacts == null) return;

    var filteredContacts = (_allContacts!.where((contact) =>
        sanitizeContactName(contact.displayName ?? '')
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))).toList();

    filteredContacts
        .sort((a, b) => (a.displayName ?? '').compareTo(b.displayName ?? ''));
    Map<String, List<Contact>> groupedContacts = {};

    for (var contact in filteredContacts) {
      String displayName = contact.displayName ?? '';
      if (displayName.isNotEmpty) {
        String initial = displayName[0].toUpperCase();
        if (!RegExp(r'^[A-Z]$').hasMatch(initial)) {
          initial = '#';
        }
        if (!groupedContacts.containsKey(initial)) {
          groupedContacts[initial] = [];
        }
        groupedContacts[initial]!.add(contact);
      }
    }

    _groupedContacts = groupedContacts;
    notifyListeners();
  }

  String sanitizeContactName(String name) {
    // Made public
    return name.replaceAll(RegExp(r'[^\x00-\x7F]'), '');
  }
}
