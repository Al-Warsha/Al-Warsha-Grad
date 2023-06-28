import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'current_requests.dart';

class HistoryWinchCard extends StatelessWidget {
  String appointmentId;
  String appointmentState;

  HistoryWinchCard({required this.appointmentId, required this.appointmentState});

  Future<DocumentSnapshot<Map<String, dynamic>>> getRequest(String id) async {
    final request = await FirebaseFirestore.instance
        .collection('winchAppointment')
        .doc(id)
        .get();

    return request;
  }

  bool isButtonDisabled(String state) {
    if (state == 'rejected') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: getRequest(appointmentId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching the data
          return Center(child: CircularProgressIndicator(color: Color(0xFFFC5448),));
        } else if (snapshot.hasError) {
          // Show an error message if an error occurred
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          // Show a message when the document doesn't exist
          return Text('Document not found');
        } else {
          // The document exists, use its data in your widget
          final data = snapshot.data!.data();

          return Container(
            padding: EdgeInsets.only(top: 60, left: 30, right: 30),
            child: Card(
              elevation: 10,
              shadowColor: Color(0xFFFC5448),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: Text('RequestID'),
                      subtitle: Text(data?['id'] ?? 'N/A'),
                    ),
                    ListTile(
                      title: Text('Client Name'),
                      subtitle: FutureBuilder<String>(
                        future: CurrentRequests().getName(data?['userid']),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text(snapshot.data ?? '');
                          }
                        },
                      ),

                    ),
                    ListTile(
                      title: Text('Client Nunmber'),
                      subtitle: FutureBuilder<String>(
                        future: CurrentRequests().getNumber(data?['userid']),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text(snapshot.data ?? '');
                          }
                        },
                      ),

                    ),
                    ListTile(
                      title: Text('Request State'),
                      subtitle: Text(data?['state'] ?? 'N/A'),
                    ),

                    ListTile(
                      title: Text('Request Type'),
                      subtitle: Text('Winch service'),
                    ),
                    ListTile(
                      title: Text('Date'),
                      subtitle: Text(data?['timestamp']),
                    ),

                    SizedBox(height: 30),

                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

}