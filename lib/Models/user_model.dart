class UserModel {
  late String uid;
  late String fullName;
  late String email;
  late String password;
  late String phoneNumber;
  late bool isEmailVerified;
  late bool isLoggedIn;
  late bool isSignedOut;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.isEmailVerified,
    required this.isLoggedIn,
    required this.isSignedOut,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
      'isLoggedIn': isLoggedIn,
      'isSignedOut': isSignedOut,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      fullName: map['fullName'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phoneNumber'],
      isEmailVerified: map['isEmailVerified'],
      isLoggedIn: map['isLoggedIn'],
      isSignedOut: map['isSignedOut'],
    );
  }
}
