import 'package:flutter/material.dart';
import '../../models/contact.dart';

class ContactDetailScreen extends StatelessWidget {
  static const routeName = '/contact-detail';
  const ContactDetailScreen(
    this.contact, {
    super.key,
  });

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              contact.avt,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Phone: ${contact.phone}",
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Email: ${contact.email}",
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              "Address: ${contact.address}",
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ]),
      ),
    );
  }
}
