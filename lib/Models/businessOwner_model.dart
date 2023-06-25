import 'package:cloud_firestore/cloud_firestore.dart';
class BusinessOwnerModel {
  late String id;
  late String email;
  late String name;
  late String password;
  late String phone;
  late String? type;
  bool verified;
  List<String> brands;
  bool rejected;
  late num rate;
  late num latitude;
  late num longitude;
  late String address;
  late bool isLoggedIn;
  late bool isSignedOut;
  late String documentURL;
  late String imageURL;

  BusinessOwnerModel({
    required this.id,
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
    required this.isLoggedIn,
    required this.isSignedOut,
    required this.documentURL,
    required this.imageURL,
  });

  Map<String, dynamic> toJson() {
    return {
      'ownerId': id,

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
      'isLoggedIn':isLoggedIn,
      'isSignedOut':isSignedOut,
      'downloadURL':documentURL,
      'imageURL':imageURL,
    };
  }

  factory BusinessOwnerModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BusinessOwnerModel(
      id: document.id,
      email: data["email"] as String,
      name: data["name"] as String,
      password: data["password"] as String,
      phone: data["phone"] as String,
      verified: data["verified"] as bool? ?? false,
      rejected: data["rejected"] as bool? ?? false,
      brands: List<String>.from(data["brands"] ?? []),
      type: data["type"] as String?,
      rate: (data["rate"] as num?) ?? 0,
      latitude: data["latitude"] as num,
      longitude: data["longitude"] as num,
      address: data["address"] as String,
      isLoggedIn: data["isLoggedIn"] as bool? ?? false,
      isSignedOut: data["isSignedOut"] as bool? ?? false,
      documentURL: data["documentURL"] as String, // Use the provided documentURL parameter
      imageURL: data["imageURL"] as String, // Use the provided imageURL parameter
    );
  }

  void setRejected(bool value) {
    rejected = value;
  }

  void setVerified(bool value) {
    verified = value;
  }

}
