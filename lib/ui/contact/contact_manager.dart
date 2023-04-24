import 'package:contact_book/models/auth_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../models/contact.dart';
import '../../services/contact_service.dart';

class ContactManager with ChangeNotifier {
  List<Contact> _items = [];

  final ContactsService _contactsService;

  ContactManager([AuthToken? authToken])
      : _contactsService = ContactsService(authToken);

  set authToken(AuthToken? authToken) {
    _contactsService.authToken = authToken;
  }

  Future<void> fetchContacts([bool filterByUser = false]) async {
    _items = await _contactsService.fetchContacts(filterByUser);
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    final newContact = await _contactsService.addContact(contact);
    if (newContact != null) {
      _items.add(newContact);
      notifyListeners();
    }
  }

  Future<void> updateContact(Contact contact) async {
    final index = _items.indexWhere((item) => item.id == contact.id);
    if (index >= 0) {
      if (await _contactsService.updateContact(contact)) {
        _items[index] = contact;
        notifyListeners();
      }
    }
  }

  Future<void> deleteContact(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    Contact? existingContact = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _contactsService.deleteContact(id)) {
      _items.insert(index, existingContact);
      notifyListeners();
    }
  }

  int get itemCount {
    return _items.length;
  }

  List<Contact> get items {
    return [..._items];
  }

  List<Contact> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Contact? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> toggleFavoriteStatus(Contact contact) async {
    final savedStatus = contact.isFavorite;
    contact.isFavorite = !savedStatus;

    if (!await _contactsService.saveFavoriteStatus(contact)) {
      contact.isFavorite = savedStatus;
    }
  }

}
