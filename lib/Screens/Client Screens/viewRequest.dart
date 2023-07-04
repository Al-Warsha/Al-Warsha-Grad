import 'package:flutter/material.dart';
import 'package:myapp/Screens/Client%20Screens/emergencyCard.dart';
import 'package:myapp/Screens/Client%20Screens/scheduleCard.dart';
import 'package:myapp/Screens/Client%20Screens/winchCard.dart';

class ViewRequest extends StatelessWidget{
  final String Id;
  final int selection;

  ViewRequest({required this.Id, required this.selection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Request Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: selection == 1?
      EmergencyCard(Id: Id):
      selection == 2?
      ScheduleCard(Id: Id):
      WinchCard(Id: Id),

    );
  }
}
