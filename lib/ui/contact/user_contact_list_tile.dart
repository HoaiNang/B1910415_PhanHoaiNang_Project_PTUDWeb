import 'package:flutter/material.dart';
import '../../models/contact.dart';
import 'package:provider/provider.dart';

import 'contact_manager.dart';
import 'edit_contact_screen.dart';

class UserContactListTile extends StatelessWidget {
  final Contact contact;

  const UserContactListTile(
    this.contact, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.name),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(contact.avt),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(children: <Widget>[
          buildEditButton(context),
          buildDeleteButton(context),
        ]),
      ),
    );
  }

  Widget buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.delete,
      ),
      onPressed: () {
        context.read<ContactManager>().deleteContact(contact.id!);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'Contact deleted',
                textAlign: TextAlign.center,
              ),
            ),
          );
      },
      color: Theme.of(context).colorScheme.error,
    );
  }

  Widget buildEditButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditContactScreen.routeName,
          arguments: contact.id,
        );
      },
      color: Theme.of(context).primaryColor,
    );
  }
}
