import 'package:contact_book/models/contact.dart';
import 'package:contact_book/ui/contact/contact_detail_screen.dart';
import 'package:contact_book/ui/contact/contact_manager.dart';
import 'package:contact_book/ui/contact/contact_overview_screen.dart';
import 'package:contact_book/ui/contact/edit_contact_screen.dart';
import 'package:contact_book/ui/contact/search.dart';
import 'package:contact_book/ui/contact/user_contact_screen.dart';
import 'package:contact_book/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './ui/auth/auth_manager.dart';
import './ui/auth/auth_screen.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, ContactManager>(
          create: (ctx) => ContactManager(),
          update: (ctx, authManager, contactsManager) {
            contactsManager!.authToken = authManager.authToken;
            return contactsManager;
          },
        ),
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child) {
          return MaterialApp(
              title: 'Contact Book',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  fontFamily: 'Lato',
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.blue,
                  ).copyWith(
                    secondary: Colors.deepOrange,
                  )),
              home: authManager.isAuth
                  ? const ContactsOverviewScreen()
                  : FutureBuilder(
                      future: authManager.tryAutoLogin(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen();
                      },
                    ),
              routes: {
                UserContactScreen.routeName: (ctx) => const UserContactScreen(),
              },
              onGenerateRoute: (settings) {
                if (settings.name == ContactDetailScreen.routeName) {
                  final contactId = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return ContactDetailScreen(
                        ctx.read<ContactManager>().findById(contactId)!,
                      );
                    },
                  );
                }
                if (settings.name == EditContactScreen.routeName) {
                  final contactId = settings.arguments as String?;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return EditContactScreen(
                        contactId != null
                            ? ctx.read<ContactManager>().findById(contactId)
                            : null,
                      );
                    },
                  );
                }
                return null;
              });
        },
      ),
    );
  }
}
