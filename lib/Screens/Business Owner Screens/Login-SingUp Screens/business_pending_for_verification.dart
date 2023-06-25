import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Screens/Business%20Owner%20Screens/Login-SingUp%20Screens/business_login_page.dart';

class BusinessOwnerPendingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your account is pending approval",
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),

            ),
            SizedBox(height: h * 0.02),
            Text(
              "Please wait for the admin to accept your registration.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: h * 0.02),
            Text(
              "An email verification will be sent to you upon approval.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: h * 0.02),
            TextButton(
              onPressed: () {
                // Handle button press
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BusinessLoginPage(),
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
    );
  }
}
