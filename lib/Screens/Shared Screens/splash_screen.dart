import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Screens/Shared%20Screens/welcome-page.dart';


class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  startSplashTimer() async {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => WelcomePage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startSplashTimer();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFC5448), Color(0xFFEEEEEE)],
            stops: [0.615, 0.996],
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(104 * fem, 12 * fem, 61.66 * fem, 354 * fem),
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(172 * fem, 0 * fem, 0 * fem, 200 * fem),
                  width: 22.34 * fem,
                  height: 22.34 * fem,
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 42.79 * fem, 16 * fem),
                      width: 150,
                      height: 150,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 31.34 * fem, 0 * fem),
                      child: const Text(
                        "ورشتك في ايدك",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}