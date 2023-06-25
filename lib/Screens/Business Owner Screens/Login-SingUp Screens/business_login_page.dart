import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Screens/Shared%20Screens/welcome-page.dart';
import '../../../Controller/auth_controller.dart';
import 'business_signup_page1.dart';
import '../../Shared Screens/forget_password.dart';

class BusinessLoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      // Perform the login process
      AuthController.instance.loginBusinessOwner(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
        Positioned(
        top: 0,
        left: 0,
        child: Image.asset(
          "assets/images/login_gp.jpg",
          width: w * 0.6,
          height: h * 0.3,
        ),
      ),
      Positioned(
        top: h * 0.05,
        left: w * 0.05,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
          Positioned(
            top: h * 0.25,
            left: w * 0.05,
            right: w * 0.05,

            child: Column(
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  "assets/images/breakLogin.jpg",
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: h * 0.014),
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: h * 0.014),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Color(0xFFFC5448)),
                        hintText: "Password",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.02),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => ForgotPasswordPage());

                    },
                    child: Text(
                      "Forgot Your Password?",
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: h * 0.7,
            left: w * 0.05,
            right: w * 0.05,
            child: Column(
              children: [
                Container(
                  width: w * 0.4,
                  height: h * 0.07,
                  decoration: BoxDecoration(
                    color: Color(0xFFFC5448),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: login,
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: h * 0.85,
            left: w * 0.05,
            right: w * 0.05,
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 20,
                    ),
                    children: [
                      TextSpan(
                        text: "Create",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.to(() => BusinessOwnerPageOne()),
                      ),
                    ],
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
