import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Controller/auth_controller.dart';
import '../Client Screens/Login-SignUp Screens/login_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    TextEditingController emailController = TextEditingController();

    void forgetPassword() async {
      String email = emailController.text.trim();

      if (email.isEmpty) {
        Get.snackbar(
          "Error",
          "All fields are required.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (!GetUtils.isEmail(email)) {
        Get.snackbar(
          "Error",
          "Invalid email format.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        // Call the forget password function in the AuthController
        await AuthController.instance.forgotPassword(email);
        Get.off(() => LoginPage()); // Redirect to login page
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: h * 0.18,
            left: w * 0.05,
            right: w * 0.05,
            child: Column(
              children: [
                Text(
                  "Forgot Password",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: h * 0.03),
                Text(
                  "Please enter your email address. We will send you a password reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: h * 0.05),
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
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Color(0xFFFC5448)),
                      hintText: "Email",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.04),
                ElevatedButton(
                  onPressed: forgetPassword,
                  child: Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 16),
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
