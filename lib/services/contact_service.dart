import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';
import '../models/auth_token.dart';
import 'firebase_service.dart';

class ContactsService extends FirebaseService {
  ContactsService([AuthToken? authToken]) : super(authToken);

  Future<List<Contact>> fetchContacts([bool filterByUser = false]) async {
    final List<Contact> contacts = [];

    try {
      final filters =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final contactsUrl =
          Uri.parse('$databaseUrl/contacts.json?auth=$token&$filters');
      final response = await http.get(contactsUrl);
      final contactsMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print(contactsMap['error']);
        return contacts;
      }

      final userFavoriteUrl =
          Uri.parse('$databaseUrl/userFavorites/$userId.json?auth=$token');
      final userFavoritesResponse = await http.get(userFavoriteUrl);
      final userFavoritesMap = json.decode(userFavoritesResponse.body);

      contactsMap.forEach((contactId, contact) {
        final isFavorite = (userFavoritesMap == null)
            ? false
            : (userFavoritesMap[contactId] ?? false);

        contacts.add(
          Contact.fromJson({
            'id': contactId,
            ...contact,
          }).copyWith(isFavorite: isFavorite),
        );
      });
      return contacts;
    } catch (error) {
      print(error);
      return contacts;
    }
  }

  Future<Contact?> addContact(Contact contact) async {
    try {
      final url = Uri.parse('$databaseUrl/contacts.json?auth=$token');
      final response = await http.post(
        url,
        body: json.encode(
          contact.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return contact.copyWith(
        id: json.decode(response.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateContact(Contact contact) async {
    try {
      final url =
          Uri.parse('$databaseUrl/contacts/${contact.id}.json?auth=$token');
      final response = await http.patch(
        url,
        body: json.encode(contact.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deleteContact(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/contacts/$id.json?auth=$token');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> saveFavoriteStatus(Contact contact) async {
    try {
      final url = Uri.parse(
          '$databaseUrl/userFavorites/$userId/${contact.id}.json?auth=$token');
      final response = await http.put(
        url,
        body: json.encode(contact.isFavorite),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
