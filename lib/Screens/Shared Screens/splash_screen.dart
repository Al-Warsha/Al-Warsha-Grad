import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Screens/Shared%20Screens/welcome-page.dart';
import '../Client Screens/Login-SignUp Screens/login_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}
class _SplashScreenPageState extends State<SplashScreenPage>{
  startSplashTimer() async {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => WelcomePage()));
      }
    });
  }

  @override
  void initState()
  {
    super.initState();
    startSplashTimer();
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xFFFC5448),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.jpg"),
            const SizedBox(height: 15,),
            const Text("ورشتك في ايدك" ,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),),
          ],
        )
      ),
    );
  }

}