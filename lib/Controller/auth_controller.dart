import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:myapp/homepage.dart';
import 'package:myapp/Screens/login_page.dart';
import 'package:myapp/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/Screens/user_profile_screen.dart';


import '../Screens/BottomNavigationBarExample.dart';
import '../Screens/admin-homepage.dart';
import '../Screens/email_verification_screen.dart';

//import 'admin_home_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  String? get currentUserUid => auth.currentUser?.uid;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print("login page");
      Get.offAll(() => LoginPage());
    } else if (!user.emailVerified) {
      print("email verification page");
      Get.offAll(() => EmailVerificationPage());
    } else {
      print("main app screen");
      Get.offAll(() => BottomNavigationBarExample());
    }
  }


  Future<void> register(String fullName, String email, String password, String phoneNumber) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        isEmailVerified: false,
        isLoggedIn: false,
        isSignedOut: false,
      );

      await FirebaseFirestore.instance.collection('users').doc(userModel.uid).set(userModel.toMap());

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        Get.snackbar(
          "Verify Email",
          "A verification email has been sent to $email",
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            "Registration successful",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      } else {
        Get.snackbar(
          "Verify Email",
          "Please verify your email address to complete registration",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            "Registration successful",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }

      if (user != null) {
        await user.updateDisplayName(fullName);
        await user.updatePhoneNumber(PhoneAuthProvider.credential(verificationId: phoneNumber, smsCode: ""));
      }
    } catch (e) {
      Get.snackbar(
        "Failed to register",
        "User message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Failed to register",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          e.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  Future<void> login(String email, String password) async {
    try {
      if (email == "admin@email.com" && password == "123") {
        // Successful login as admin
        Get.offAll(() => AdminHomepage()); // Replace AdminHomePage with your admin homepage screen
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        User user = userCredential.user!;
        bool isEmailVerified = user.emailVerified;
        bool isLoggedIn = true;
        bool isSignedOut = false;

        String uid = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'isEmailVerified': isEmailVerified,
          'isLoggedIn': isLoggedIn,
          'isSignedOut': isSignedOut,
        }, SetOptions(merge: true));

        if (isEmailVerified) {
          //Get.offAll(() => HomePageScreen());
        } else {
          Get.snackbar(
            "Email Verification",
            "Please verify your email address to log in",
            backgroundColor: Colors.redAccent,
            snackPosition: SnackPosition.BOTTOM,
            titleText: Text(
              "Login failed",
              style: TextStyle(color: Colors.white),
            ),
          );
          FirebaseAuth.instance.signOut();
        }
      } else {
        Get.snackbar(
          "Login Failed",
          "Failed to login. Please check your credentials.",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            "Login failed",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    } catch (e) {
      String errorMessage = "Failed to login. Please check your credentials.";

      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = "Invalid email. Please try again.";
        } else if (e.code == 'wrong-password') {
          errorMessage = "Invalid password. Please try again.";
        }
      }

      Get.snackbar(
        "Login Failed",
        errorMessage,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Login failed",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      String uid = auth.currentUser?.uid ?? '';
      if (uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'isLoggedIn': false,
          'isSignedOut': true,
        }, SetOptions(merge: true));
      }

      await auth.signOut();
      Get.offAll(() => LoginPage());
    } catch (e) {
      print("Error logging out: $e");
    }
  }


  Future<void> forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Reset Password",
        "A password reset email has been sent to $email",
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Reset Password",
          style: TextStyle(color: Colors.white),
        ),
      );
    } catch (error) {
      Get.snackbar(
        "Reset Password Failed",
        "Failed to send password reset email",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Reset Password Failed",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);

      // Retrieve the user document from Firestore
      String uid = auth.currentUser?.uid ?? '';
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      DocumentSnapshot userSnapshot = await userRef.get();

      // Update the password field in Firestore
      if (userSnapshot.exists) {
        await userRef.update({
          'password': '<new_password>', // Replace <new_password> with the actual new password value
        });
      }

      Get.snackbar(
        "Reset Password",
        "A password reset email has been sent to $email",
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Reset Password",
          style: TextStyle(color: Colors.white),
        ),
      );
    } catch (error) {
      Get.snackbar(
        "Reset Password Failed",
        "Failed to send password reset email",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Reset Password Failed",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }



}