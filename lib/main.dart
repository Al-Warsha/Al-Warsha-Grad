import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:myapp/Screens/splash_screen.dart';

import 'Controller/auth_controller.dart';



void main() async{
  
  double? selectedLatitude;
  double? selectedLongitude;
  
 WidgetsFlutterBinding.ensureInitialized();
 //Firebase.initializeApp();
 await Firebase.initializeApp().then((value) => Get.put(AuthController()));

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  get selectedLatitude => null;

  get selectedLongitude => null;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AlWarsha app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
    );
  }


}
