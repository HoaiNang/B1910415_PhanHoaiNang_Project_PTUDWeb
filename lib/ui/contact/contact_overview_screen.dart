import 'package:contact_book/ui/contact/search.dart';
import 'package:flutter/material.dart';
import '../shared/app_drawer.dart';
import 'package:provider/provider.dart';

import 'contact_gird.dart';
import 'contact_manager.dart';

enum FilterOptions { favorites, all }

class ContactsOverviewScreen extends StatefulWidget {
  const ContactsOverviewScreen({super.key});
  @override
  State<ContactsOverviewScreen> createState() => _ContactsOverviewScreenState();
}

class _ContactsOverviewScreenState extends State<ContactsOverviewScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  late Future<void> _fetchContacts;

  @override
  void initState() {
    super.initState();
    _fetchContacts = context.read<ContactManager>().fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact'), actions: 
      <Widget>[
        buildProductFilterMenu(),
      ]),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: _fetchContacts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ValueListenableBuilder<bool>(
                  valueListenable: _showOnlyFavorites,
                  builder: (context, onlyFavorites, child) {
                    return ContactGrid(onlyFavorites);
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget buildProductFilterMenu() {
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        if (selectedValue == FilterOptions.favorites) {
          _showOnlyFavorites.value = true;
        } else {
          _showOnlyFavorites.value = false;
        }
      },
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Only Favorites'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show All'),
        )
      ],
    );
  }
}
