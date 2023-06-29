import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'current_schedule_card.dart';
import 'current_winch_card.dart';
import 'current_emergency_card.dart';

class ViewCurrentRequest extends StatelessWidget {
  final String appointmentId;
  final String appointmentState;

  const ViewCurrentRequest({
    required this.appointmentId,
    required this.appointmentState,
  });

  Future<String> getCollectionName(String appointmentId) async {
    CollectionReference emergencyCollection =
    FirebaseFirestore.instance.collection('emergencyAppointment');
    CollectionReference scheduleCollection =
    FirebaseFirestore.instance.collection('scheduleAppointment');
    CollectionReference winchCollection =
    FirebaseFirestore.instance.collection('winchAppointment');

    List<Future<DocumentSnapshot>> futures = [
      emergencyCollection.doc(appointmentId).get(),
      scheduleCollection.doc(appointmentId).get(),
      winchCollection.doc(appointmentId).get(),
    ];

    List<DocumentSnapshot> snapshots = await Future.wait(futures);

    for (int i = 0; i < snapshots.length; i++) {
      if (snapshots[i].exists) {
        if (i == 0) {
          return 'emergencyAppointment';
        } else if (i == 1) {
          return 'scheduleAppointment';
        } else if (i == 2) {
          return 'winchAppointment';
        }
      }
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getCollectionName(appointmentId),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Center(
              child: SizedBox(
                width: 20,  // Adjust the size of the circle as needed
                height: 20,  // Adjust the size of the circle as needed
                child: CircularProgressIndicator(
                  strokeWidth: 2,  // Adjust the stroke width as needed
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(252, 84, 72, 1.0),
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final String collectionName = snapshot.data!;
          Widget currentCard;

          switch (collectionName) {
            case 'emergencyAppointment':
              currentCard = CurrentEmergencyCard(
                appointmentState: appointmentState,
                appointmentId: appointmentId,
              );
              break;
            case 'scheduleAppointment':
              currentCard = CurrentScheduleCard(
                appointmentState: appointmentState,
                appointmentId: appointmentId,
              );
              break;
            case 'winchAppointment':
              currentCard = CurrentWinchCard(
                appointmentState: appointmentState,
                appointmentId: appointmentId,
              );
              break;
            default:
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
