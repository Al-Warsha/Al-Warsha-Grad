import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controller/auth_controller.dart';
import 'Screens/AppointmentForMaintenance.dart';
import 'Screens/BottomNavigationBarExample.dart';
import 'Screens/Car.dart';
import 'Screens/EmergencyRoadHelp.dart';
import 'Screens/Google_map.dart';
import 'Screens/ServicesScreen.dart';
import 'Screens/splash_screen.dart';
import 'Screens/viewMechanicsForAppointment.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Alwarsha',
      initialRoute:
      //viewMechanicsForAppointment.routeName,
      //Google_map.routeName,
      //AppointmentForMaintenance.routeName,
      //EmergencyRoadHelp.routeName,
      //ServicesScreen.routeName,
      BottomNavigationBarExample.routeName,

      routes: {
        Google_map.routeName: (c)=> Google_map(onLocationSelected: (double lat , double long) {  },),
        AppointmentForMaintenance.routeName: (c)=>AppointmentForMaintenance(),
        Car.routeName: (c)=>Car(),
        EmergencyRoadHelp.routeName: (c)=>EmergencyRoadHelp(),
        ServicesScreen.routeName: (c)=>ServicesScreen(),
        BottomNavigationBarExample.routeName: (c)=> BottomNavigationBarExample(),
        viewMechanicsForAppointment.routeName: (c)=> viewMechanicsForAppointment(),
        //Try.routeName: (c)=>Try(),
      },
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
    );
  }

 
}
