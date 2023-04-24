import 'package:flutter/foundation.dart';

class Contact {
  final String? id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String avt;
  final ValueNotifier<bool> _isFavorite;

  Contact({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.avt,
    isFavorite = false,
  }) : _isFavorite = ValueNotifier(isFavorite);
  set isFavorite(bool newValue) {
    _isFavorite.value = newValue;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "address": address,
      "phone": phone,
      "email": email,
      "avt": avt,
    };
  }

  static Contact fromJson(Map<String, dynamic> json) {
    return Contact(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        phone: json['phone'],
        email: json['email'],
        avt: json['avt']);
  }

  bool get isFavorite {
    return _isFavorite.value;
  }

  ValueNotifier<bool> get isFavoriteListenable {
    return _isFavorite;
  }

  Contact copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? avt,
    bool? isFavorite,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avt: avt ?? this.avt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
