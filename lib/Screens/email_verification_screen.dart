import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'login_page.dart';



class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    void sendVerificationEmail() async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        try {
          await user.sendEmailVerification();
          Get.snackbar(
            "Verify Email",
            "A verification email has been sent to ${user.email}",
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
            titleText: Text(
              "Verification Email Sent",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        } catch (e) {
          Get.snackbar(
            "Error Sending Verification Email",
            "Failed to send verification email. Please try again.",
            backgroundColor: Colors.redAccent,
            snackPosition: SnackPosition.BOTTOM,
            titleText: Text(
              "Error",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: h * 0.35,
            left: w * 0.05,
            right: w * 0.05,
            child: Column(
              children: [
                Text(
                  "Email Verification",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: h * 0.03),
                Text(
                  "An email verification link has been sent to your email address. Please check your inbox and click on the link to verify your account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: h * 0.05),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFFFC5448)),
                  ),
                  onPressed: sendVerificationEmail,
                  child: Text(
                    "Resend Verification Email",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: h * 0.02),
                TextButton(
                  onPressed: () {
                    // Handle button press
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Go to Login",
                    style: TextStyle(fontSize: 16, color: Color(0xFFFC5448)),
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
