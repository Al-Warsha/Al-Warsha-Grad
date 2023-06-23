import 'package:flutter/material.dart';
import 'package:myapp/Screens/emergencyCard.dart';
import 'package:myapp/Screens/scheduleCard.dart';
import 'package:myapp/Screens/winchCard.dart';

class ViewRequest extends StatelessWidget{
  final String Id;
  final int selection;

  ViewRequest({required this.Id, required this.selection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text('Request Details', textAlign: TextAlign.left, style: TextStyle(color: Colors.black),),
          leading: BackButton(
          color: Colors.black,
        ),
          ),
      body: selection == 1?
      EmergencyCard(Id: Id):
          selection == 2?
          ScheduleCard(Id: Id):
              WinchCard(Id: Id),

    );
  }
}