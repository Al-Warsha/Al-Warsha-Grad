

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'businessowner_current_requests.dart';
import 'current_requests.dart';

class HistoryScheduleCard extends StatefulWidget {
  final String appointmentId;
  final String appointmentState;

  HistoryScheduleCard({
    required this.appointmentId,
    required this.appointmentState,
  });

  @override
  _HistoryScheduleCardState createState() => _HistoryScheduleCardState();
}

class _HistoryScheduleCardState extends State<HistoryScheduleCard> {
  String currentState = "";

  @override
  void initState() {
    super.initState();
    currentState = widget.appointmentState;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getRequest(String id) async {
    final request = await FirebaseFirestore.instance.collection('scheduleAppointment').doc(id).get();
    return request;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: getRequest(widget.appointmentId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching the data
          return Center(child: CircularProgressIndicator(color: Color(0xFFFC5448)));
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
                      title: Text('Client Number'),
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
                      title: Text('Car'),
                      subtitle: Text(data?['car']),
                    ),
                    ListTile(
                      title: Text('Request Type'),
                      subtitle: Text('Scheduled appointment'),
                    ),
                    ListTile(
                      title: Text('Description'),
                      subtitle: Text(data?['description']),
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
