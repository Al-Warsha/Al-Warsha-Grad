import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Business Owner Screens/Login-SingUp Screens/business_login_page.dart';
import '../Client Screens/Login-SignUp Screens/login_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Container(
      width: w,
      height: h,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: -10,
              left: -20,
              child: Container(
                width: w + 40,
                height: h + 40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/welcome.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: h * 0.521,
              left: w * 0.4,
              child: GestureDetector(
                onTap: () {
                  Get.off(() => LoginPage());
                  // Handle the onTap action
                },
                child: Text(
                  'User',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: h * 0.58,
              left: w * 0.45,
              child: Text(
                'OR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: h * 0.62,
              left: w * 0.38,
              child: GestureDetector(
                onTap: () {

                  // Handle the onTap action
                  Get.off(() => BusinessLoginPage());
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Business\n',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'Owner',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Add more positioned widgets for other clickable texts
          ],
        ),
      ),
    );
  }
}
