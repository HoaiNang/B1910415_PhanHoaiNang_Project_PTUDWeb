import 'package:flutter/material.dart';
import '../../models/contact.dart';
import 'package:provider/provider.dart';

import 'contact_detail_screen.dart';
import 'contact_manager.dart';

class ContactGridTile extends StatelessWidget {
  const ContactGridTile(
    this.contact, {
    super.key,
  });

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: buildGridFooterBar(context),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ContactDetailScreen.routeName,
              arguments: contact.id,
            );
          },
          child: Image.network(
            contact.avt,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildGridFooterBar(BuildContext context) {
    return GridTileBar(
      backgroundColor: Colors.black87,
      leading: ValueListenableBuilder<bool>(
        valueListenable: contact.isFavoriteListenable,
        builder: (ctx, isFavorite, child) {
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              ctx.read<ContactManager>().toggleFavoriteStatus(contact);
            },
          );
        },
      ),
    );
  }
}
