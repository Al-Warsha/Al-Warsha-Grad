import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessOwnerModel {
  final String? id;
  final String email;
  final String name;
  final String password;
  final String phone;
  final String type;
  bool verified;
  List<String> brands;
  bool rejected;
  final num rate;
  final num latitude;
  final num longitude;
  final String address;

  BusinessOwnerModel({
    this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
    required this.verified,
    required this.brands,
    required this.type,
    required this.rate,
    required this.rejected,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'phone': phone,
      'verified': verified,
      'brands': brands,
      'type': type,
      'rate': rate,
      'rejected': rejected,
      'latitude':latitude,
      'longitude':longitude,
      'address':address,
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
      verified: data["verified"] as bool,
      rejected: data["rejected"] as bool,
      brands: List<String>.from(data["brands"] ?? []),
      type: data["type"],
      rate: (data["rate"] as num?) ?? 0,
      latitude: data["latitude"] as num,
      longitude: data["longitude"] as num,
      address: data["address"] as String

    );
  }

  void setRejected(bool value) {
    rejected = value;
  }
  void setVerified(bool value) {
    verified = value;
  }
}
