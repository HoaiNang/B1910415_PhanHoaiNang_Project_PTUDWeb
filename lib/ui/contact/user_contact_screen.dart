import 'package:contact_book/ui/contact/user_contact_list_tile.dart';
import 'package:flutter/material.dart';
import 'contact_manager.dart';
import '../shared/app_drawer.dart';
import 'package:provider/provider.dart';

import 'edit_contact_screen.dart';

class UserContactScreen extends StatelessWidget {
  static const routeName = '/user-contacts';
  const UserContactScreen({super.key});
  Future<void> _refreshContacts(BuildContext context) async {
    await context.read<ContactManager>().fetchContacts(true);
  }

  @override
  @override
  Widget build(BuildContext context) {
    final contactsManager = ContactManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Contacts'),
        actions: <Widget>[
          buildAddButton(context),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshContacts(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            child: buildUserContactListView(contactsManager),
            onRefresh: () => _refreshContacts(context),
          );
        },
      ),
    );
  }

  Widget buildUserContactListView(ContactManager contactsManager) {
    return Consumer<ContactManager>(
      builder: (ctx, contactsManager, child) {
        return ListView.builder(
          itemCount: contactsManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              UserContactListTile(
                contactsManager.items[i],
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  Widget buildAddButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditContactScreen.routeName,
        );
      },
    );
  }
}
