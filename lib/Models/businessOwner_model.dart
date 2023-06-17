import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessOwnerModel {
  final String? id;
  final String email;
  final String name;
  final String password;
  final String phone;
  final String username;
  final String type;
  bool verified;
  List<String> brands;
  bool rejected;
  final num rate;

  BusinessOwnerModel({
    this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
    required this.username,
    required this.verified,
    required this.brands,
    required this.type,
    required this.rate,
    required this.rejected,
  });

  toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'phone': phone,
      'username': username,
      'verified': verified,
      'brands': brands,
      'type': type,
      'rate': rate,
      'rejected': rejected,
    };
  }

  factory BusinessOwnerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BusinessOwnerModel(
      id: document.id,
      email: data["email"] as String,
      name: data["name"] as String,
      password: data["password"] as String,
      phone: data["phone"] as String,
      username: data["username"] as String,
      verified: data["verified"] as bool,
      rejected: data["rejected"] as bool,
      brands: List<String>.from(data["brands"] ?? []),
      type: data["type"],
      rate: (data["rate"] as num?) ?? 0,
    );
  }

  void setRejected(bool value) {
    rejected = value;
  }
  void setVerified(bool value) {
    verified = value;
  }
}
