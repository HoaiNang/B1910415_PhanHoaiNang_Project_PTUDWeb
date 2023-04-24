import 'package:flutter/material.dart';
import '../../models/contact.dart';
import 'package:provider/provider.dart';
import 'contact_gird_tile.dart';
import 'contact_manager.dart';

class ContactGrid extends StatelessWidget {
  final bool showFavorites;

  const ContactGrid(this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = context.select<ContactManager, List<Contact>>(
        (contactsManager) => showFavorites
            ? contactsManager.favoriteItems
            : contactsManager.items);
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: contacts.length,
      itemBuilder: (ctx, i) => ContactGridTile(contacts[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
