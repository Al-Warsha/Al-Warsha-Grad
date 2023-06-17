import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/auth_controller.dart';
import 'business_second_signup.dart';
import 'business_signup.dart';
import 'email_verification_screen.dart';
import 'login_page.dart';

class BusinessOwnerPageOne extends StatefulWidget {
  const BusinessOwnerPageOne({Key? key}) : super(key: key);

  @override
  _BusinessOwnerPageOneState createState() => _BusinessOwnerPageOneState();
}

class _BusinessOwnerPageOneState extends State<BusinessOwnerPageOne> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  bool isNextButtonEnabled = false;

  void goToBusinessOwnerPageTwo() {
    Get.to(() => BusinessOwnerPageTwo());
  }

  bool validateFullName() {
    final String fullName = fullNameController.text.trim();
    final RegExp nameRegex = RegExp(r'^[a-zA-Z]+$');
    return fullName.isNotEmpty && nameRegex.hasMatch(fullName);
  }


  bool validateEmail() {
    final String email = emailController.text.trim();
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return emailRegex.hasMatch(email);
  }


  bool validatePassword() {
    return passwordController.text.trim().length >= 6;
  }

  bool validatePhoneNumber() {
    final String phoneNumber = phoneNumberController.text.trim();
    final RegExp phoneRegex = RegExp(r'^01\d{10}$');
    return phoneNumber.isNotEmpty && phoneRegex.hasMatch(phoneNumber);
  }



  void updateNextButtonState() {
    final bool isFullNameValid = validateFullName();
    final bool isEmailValid = validateEmail();
    final bool isPasswordValid = validatePassword();
    final bool isPhoneNumberValid = validatePhoneNumber();

    setState(() {
      isNextButtonEnabled =
          isFullNameValid && isEmailValid && isPasswordValid && isPhoneNumberValid;
    });
  }


  void showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _registerUser() {
    final bool isFullNameValid = validateFullName();
    final bool isEmailValid = validateEmail();
    final bool isPasswordValid = validatePassword();
    final bool isPhoneNumberValid = validatePhoneNumber();

    if (!isFullNameValid) {
      showSnackBar("Full name is required.");
      return;
    }

    if (!isEmailValid) {
      showSnackBar("Email is not valid.");
      return;
    }

    if (!isPasswordValid) {
      showSnackBar("Password is too weak.");
      return;
    }

    if (!isPhoneNumberValid) {
      showSnackBar("Phone number is required.");
      return;
    }

    AuthController.instance.register(
      fullNameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      phoneNumberController.text.trim(),
    ).then((_) {
      Get.off(() => EmailVerificationPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "img/login_gp.jpg",
              width: w * 0.6,
              height: h * 0.3,
            ),
          ),
          Positioned(
            top: h * 0.18,
            left: w * 0.05,
            right: w * 0.05,
            child: Column(
              children: [
                Text(
                  "Sign-up",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  "img/breakLogin.jpg",
                  width: w * 0.4,
                  height: h * 0.01,
                ),
                SizedBox(height: h * 0.04),
                Container(
                  width: w * 0.9,
                  height: h * 0.07,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(1, 1),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: fullNameController,
                    onChanged: (value) {
                      updateNextButtonState();
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Color(0xFFFC5448)),
                      hintText: "Name",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.04),
                Container(
                  width: w * 0.9,
                  height: h * 0.07,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(1, 1),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: emailController,
                    onChanged: (value) {
                      updateNextButtonState();
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Color(0xFFFC5448)),
                      hintText: "Email",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.04),
                Container(
                  width: w * 0.9,
                  height: h * 0.07,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(1, 1),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: passwordController,
                    onChanged: (value) {
                      updateNextButtonState();
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Color(0xFFFC5448)),
                      hintText: "Password",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.04),
                Container(
                  width: w * 0.9,
                  height: h * 0.07,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(1, 1),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: phoneNumberController,
                    onChanged: (value) {
                      updateNextButtonState();
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone, color: Color(0xFFFC5448)),
                      hintText: "Phone Number",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.05),GestureDetector(
                  onTap: () {
                    if (isNextButtonEnabled) {
                      goToBusinessOwnerPageTwo();
                    }
                  },
                  child: Container(
                    width: w * 0.4,
                    height: h * 0.07,
                    decoration: BoxDecoration(
                      color: isNextButtonEnabled ? Color(0xFFFC5448) : Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }
}



/*class AuthController extends GetxController {
  static AuthController instance = Get.find();
  RxBool isUserLoggedIn = false.obs;

  Future<void> register(String fullName, String email, String password, String phoneNumber) async {
    // Perform registration logic here
    await Future.delayed(Duration(seconds: 2));
    isUserLoggedIn.value = true;*/
