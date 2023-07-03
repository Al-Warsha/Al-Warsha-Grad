import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Repositories/notification_service.dart';
import 'package:myapp/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Repositories/notification_service2.dart';
import '../Screens/Business Owner Screens/BottomNavigationBar-BusinessOwner.dart';
import '../Screens/Client Screens/BottomNavigationBarExample.dart';
import '../Screens/Admin Screens/admin-homepage.dart';
import '../Screens/Business Owner Screens/Login-SingUp Screens/business_pending_for_verification.dart';
import '../Screens/Client Screens/Login-SignUp Screens/email_verification_screen.dart';
import '../Screens/Shared Screens/splash_screen.dart';
import '../Screens/Shared Screens/welcome-page.dart';


class AuthController extends GetxController {

  late NotificationService _notificationService;
  late NotificationService2 _notificationService2;
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

  _initialScreen(User? user) async {
    if (user == null) {
      print("login page");
      Get.offAll(() => SplashScreenPage());
    } else {
      bool isUserInUsersCollection = await _checkUserInCollection('users', user.uid);
      bool isUserInBusinessOwnersCollection = await _checkUserInCollection('BusinessOwners', user.uid);

      if (isUserInUsersCollection && !isUserInBusinessOwnersCollection && user!=null) {
        if (!user.emailVerified) {
          print("email verification page");
          Get.offAll(() => EmailVerificationPage());
        } else {
          print("main app screen for users");
         // _notificationService = new NotificationService();
         // _notificationService.listenForRequestChanges(user.uid);
          Get.offAll(() => BottomNavigationBarExample());
        }
        return;
      }  else if (isUserInBusinessOwnersCollection && FirebaseAuth.instance.currentUser != null) {
        bool isBusinessOwnerVerified = await _checkBusinessOwnerVerified(user.uid);
        if (isBusinessOwnerVerified) {
          print("main app screen for verified business owners");
         //_notificationService = new NotificationService();
          //_notificationService.listenForRequestChanges(user.uid);
          Get.offAll(() => BottomNavigationBarBusinessOwner());
        } else {
          print("business owner pending page");
          Get.offAll(() => BusinessOwnerPendingPage());
        }
      } else {
        print("user not found in any collection");
        // Handle the case when the user is not found in any collection
      }
    }
  }


  Future<bool> _checkBusinessOwnerVerified(String uid) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('BusinessOwners')
          .doc(uid)
          .get();
      if (snapshot.exists) {
        // Check the 'verified' field value
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?; // Explicitly cast to Map<String, dynamic>
        return data?['verified'] ?? false;
      }
    } catch (e) {
      print("Error checking business owner verification: $e");
    }
    return false;
  }


  Future<bool> _checkUserInCollection(String collectionName, String uid) async {
    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection(collectionName).doc(uid).get();
      return snapshot.exists;
    } catch (e) {
      print("Error checking user in collection: $e");
      return false;
    }
  }

  Future<void> register(String fullName, String email, String password, String phoneNumber) async {

    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    UserModel userModel = UserModel(
      uid: userCredential.user!.uid,
      fullName: fullName,
      email: email,
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
        _notificationService = new NotificationService();
        _notificationService.listenForRequestChanges(uid);

        // Check if the user exists in the "BusinessOwners" collection
        DocumentSnapshot businessOwnerSnapshot = await FirebaseFirestore.instance
            .collection('BusinessOwners')
            .doc(uid)
            .get();

        if (businessOwnerSnapshot.exists) {
          // User exists in the "BusinessOwners" collection instead of "users"
          Get.snackbar(
            "Incorrect Account Type",
            "Please login using the correct account type.",
            backgroundColor: Colors.redAccent,
            snackPosition: SnackPosition.BOTTOM,
            titleText: Text(
              "Login failed",
              style: TextStyle(color: Colors.white),
            ),
          );
          FirebaseAuth.instance.signOut();
          return;
        }

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'isEmailVerified': isEmailVerified,
          'isLoggedIn': isLoggedIn,
          'isSignedOut': isSignedOut,
        }, SetOptions(merge: true));

        if (isEmailVerified) {
          // Successful login for regular user
          // Get.offAll(() => HomePageScreen());
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

        _notificationService.destroyNotifications();
      }

      await auth.signOut();
      Get.offAll(() => WelcomePage());
    } catch (e) {
      print("Error logging out: $e");
      Get.snackbar(
        'Logout Error',
        'Unable to logout. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

/////////////////////////////////////////////////////////////////////////////////


  Future<void> businessOwnerRegister(
      String ownerId,
      String name,
      String email,
      String password,
      String phoneNumber,
      List<String> brands,
      List<String> type,
      String address,
      num latitude,
      num longitude,
      String imageURL,
      String documentURL,
      ) async {
    try {

      // Register the user using FirebaseAuth
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(

        email:email,
        password:password,
      );

      // Retrieve the user's UID
      String uid = userCredential.user!.uid;


      // Save business owner details to Firestore
      await FirebaseFirestore.instance.collection('BusinessOwners').doc(uid).set({

        'name': name,
        'email': email,
        'phone': phoneNumber,
        'brands': brands,
        'type': type,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'documentURL':documentURL,
        'imageURL' : imageURL,
        'verified': false,
        'rejected': false,
        'isLoggedIn': false,
        'isSignedOut': false,
      });

      // Redirect to pending page for verification
      Get.offAll(() => BusinessOwnerPendingPage());
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    } finally {
      //isLoading.value = false;
    }
  }



  Future<void> loginBusinessOwner(String email, String password) async {
    try {
      if (email == "admin@email.com" && password == "123") {
        // Successful login as admin
        Get.offAll(() => AdminHomepage());
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        User user = userCredential.user!;
        String uid = user.uid;

        // Check if the user exists in the "BusinessOwners" collection
        DocumentSnapshot businessOwnerSnapshot = await FirebaseFirestore.instance
            .collection('BusinessOwners')
            .doc(uid)
            .get();

        if (businessOwnerSnapshot.exists) {
          bool isAccepted = businessOwnerSnapshot.get('verified') ?? false;
          bool isRejected = businessOwnerSnapshot.get('rejected') ?? false;
          bool isLoggedIn = true;
          bool isSignedOut = false;
          _notificationService2 = new NotificationService2();
          _notificationService2.listenForRequestChanges2(uid);

          if (!isAccepted && !isRejected) {
            // User not yet accepted by admin
            Get.snackbar(
              "Email Verification",
              "Please wait for admin to accept you to log in",
              backgroundColor: Colors.redAccent,
              snackPosition: SnackPosition.BOTTOM,
              titleText: Text(
                "Login failed",
                style: TextStyle(color: Colors.white),
              ),
            );
            FirebaseAuth.instance.signOut();
            return;
          }

          if (isRejected && !isAccepted) {
            // User rejected by admin
            Get.snackbar(
              "Signup Rejected",
              "You cannot login to the application as your signup request was rejected by the admin.",
              backgroundColor: Colors.redAccent,
              snackPosition: SnackPosition.BOTTOM,
              titleText: Text(
                "Login failed",
                style: TextStyle(color: Colors.white),
              ),
            );
            FirebaseAuth.instance.signOut();
            return;
          }

          await FirebaseFirestore.instance.collection('BusinessOwners').doc(uid).set(
            {
              'isLoggedIn': isLoggedIn,
              'isSignedOut': isSignedOut,
            },
            SetOptions(merge: true),
          );

          if (isAccepted) {
            // Successful login as business owner
            Get.offAll(() => BottomNavigationBarBusinessOwner());
          }
        } else {
          // Check if the user exists in the "users" collection
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();

          if (userSnapshot.exists) {
            // User exists in the "users" collection instead of "BusinessOwners"
            Get.snackbar(
              "Incorrect Account Type",
              "Please login using the correct account type.",
              backgroundColor: Colors.redAccent,
              snackPosition: SnackPosition.BOTTOM,
              titleText: Text(
                "Login failed",
                style: TextStyle(color: Colors.white),
              ),
            );
            FirebaseAuth.instance.signOut();
            return;
          }

          // User does not exist in either "BusinessOwners" or "users" collection
          Get.snackbar(
            "Account Not Found",
            "The account does not exist.",
            backgroundColor: Colors.redAccent,
            snackPosition: SnackPosition.BOTTOM,
            titleText: Text(
              "Login failed",
              style: TextStyle(color: Colors.white),
            ),
          );
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



  Future<void> logoutBusinessOwner() async {
    try {
      String uid = auth.currentUser?.uid ?? '';
      if (uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('BusinessOwners').doc(uid).set({
          'isLoggedIn': false,
          'isSignedOut': true,
        }, SetOptions(merge: true));

       _notificationService2.destroyNotifications();
      }
      await auth.signOut();
      Get.offAll(() => WelcomePage());
    }catch (e) {
      print("Error logging out: $e");
      Get.snackbar(
        'Logout Error',
        'Unable to logout. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  Future<void> forgotPasswordBusinessOwner(String email) async {
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

  Future<void> resetPasswordBusinessOwner(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);

      // Retrieve the user document from Firestore
      String uid = auth.currentUser?.uid ?? '';
      DocumentReference userRef = FirebaseFirestore.instance.collection('BusinessOwners').doc(uid);
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
