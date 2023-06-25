import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'history_emergency_card.dart';
import 'history_schedule_card.dart';
import 'history_winch_card.dart';



class ViewHistory extends StatelessWidget {
  final String appointmentId;
  final String appointmentState;
  final String userName;
  final String phoneNumber;
  final String hour;


  const ViewHistory({
    required this.appointmentId,
    required this.appointmentState,
    required this.userName,
    required this.phoneNumber,
    required this.hour,

  });

  Future<String> getCollectionName(String appointmentId) async {
    CollectionReference emergencyCollection = FirebaseFirestore.instance.collection('emergencyAppointment');
    CollectionReference scheduleCollection = FirebaseFirestore.instance.collection('scheduleAppointment');
    CollectionReference winchCollection = FirebaseFirestore.instance.collection('winchAppointment');

    DocumentSnapshot emergencySnapshot = await emergencyCollection.doc(appointmentId).get();
    if (emergencySnapshot.exists) {
      return 'emergencyAppointment';
    }

    DocumentSnapshot scheduleSnapshot = await scheduleCollection.doc(appointmentId).get();
    if (scheduleSnapshot.exists) {
      return 'scheduleAppointment';
    }

    DocumentSnapshot winchSnapshot = await winchCollection.doc(appointmentId).get();
    if (winchSnapshot.exists) {
      return 'winchAppointment';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getCollectionName(appointmentId),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching the collection name
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final String collectionName = snapshot.data!;

          Widget currentCard;

          // Build the corresponding container based on the collection name
          if (collectionName == 'emergencyAppointment') {
            currentCard = HistoryEmergencyCard(
              appointmentState: appointmentState,
              appointmentId: appointmentId,
            );
          } else if (collectionName == 'scheduleAppointment') {
            currentCard = HistoryScheduleCard(
              appointmentState: appointmentState,
              appointmentId: appointmentId,

            );
          } else if (collectionName == 'winchAppointment') {
            currentCard = HistoryWinchCard(
              appointmentState: appointmentState,
              appointmentId: appointmentId,

            );
          } else {
            return Text('Invalid collection name');
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              title: Text(
                'Request Details',
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black),
              ),
              leading: BackButton(
                color: Colors.black,
              ),
            ),
            body: currentCard,
          );
        } else {
          return Text('Failed to fetch appointment details');
        }
      },
    );
  }

}
