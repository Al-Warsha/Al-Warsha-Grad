import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Screens/RateScreen.dart';

import '../Controller/Requests.dart';

class ScheduleCard extends StatefulWidget{
  static const String routeName = 'schedule';

  final String Id;
  ScheduleCard({required this.Id});

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  Future<DocumentSnapshot<Map<String, dynamic>>> getRequest(String id) async {
    final request = await FirebaseFirestore.instance
        .collection('scheduleAppointment')
        .doc(id)
        .get();

    return request ;
  }

  bool isButtonDisabled(String state){
    if(state == 'pending')
      return true;
    else
      return false;
  }

  DateTime numToDate(num value){
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(value.toInt());
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: getRequest(widget.Id),
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
                      title: Text('Mechanic Name'),
                      subtitle: FutureBuilder<String>(
                        future: Requests().getName(data?['mechanicid']),
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
                      title: Text('Date'),
                      subtitle: Text(numToDate(data?['date']).toString()),
                    ),
                    ListTile(
                      title: Text('Rated'),
                      subtitle: data?['rate'] == 0? Text('No rating yet'):Text(data!['rate'].toString())
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: isButtonDisabled(data?['state']) ? null :  () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RateScreen(id: data?['id'],)
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFFC5448),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      icon: Icon(Icons.star_border),
                      label: Text(
                        'Rate',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
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