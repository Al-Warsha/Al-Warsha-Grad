import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusinessOwnerPageTwo extends StatelessWidget{
  @override
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery
        .of(context)
        .size
        .width;
    double h = MediaQuery
        .of(context)
        .size
        .height;

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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}