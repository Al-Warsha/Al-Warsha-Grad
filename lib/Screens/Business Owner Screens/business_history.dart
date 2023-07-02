import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Screens/Business%20Owner%20Screens/view_history.dart';
import '../../Controller/adminMechaniDetailsController.dart';
import '../../Controller/auth_controller.dart';
import 'BottomNavigationBar-BusinessOwner.dart';
import 'history_queries.dart';


class BusinessHistory extends StatefulWidget {
  static const String routeName = 'requests';

  const BusinessHistory({Key? key}) : super(key: key);

  @override
  State<BusinessHistory> createState() =>
      _BusinessCurrentRequestsState();
}

class _BusinessCurrentRequestsState extends State<BusinessHistory> {
  int selection = 1;
  String name = '';
  AdminMechanicDetailsController controller = AdminMechanicDetailsController();
  String? userId =AuthController.instance.currentUserUid;
  List<DocumentSnapshot<Map<String, dynamic>>> dataList = [];

  Future<void> _loadEmergencyRequests() async {
    List<DocumentSnapshot<Map<String, dynamic>>> temp =
    await HistoryQueries().rejectedRequests(userId!);
    setState(() {
      selection = 1;
      dataList = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize dataList with emergency requests
    _loadEmergencyRequests();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          'Previous Requests',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back), color: Colors.black,onPressed: (){                        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => BottomNavigationBarBusinessOwner())
        );
        }),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    List<DocumentSnapshot<Map<String, dynamic>>> temp =
                    await HistoryQueries().rejectedRequests(userId!);
                    setState(() {
                      selection = 1;
                      dataList = temp;
                    });
                  },
                  child: Text("rejected"),
                  style: ElevatedButton.styleFrom(
                    shape: ContinuousRectangleBorder(),
                    backgroundColor: selection == 1
                        ? Color.fromRGBO(252, 84, 72, 1.0)
                        : Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    List<DocumentSnapshot<Map<String, dynamic>>> temp =
                    await HistoryQueries().doneRequests(userId!);
                    setState(() {
                      selection = 2;
                      dataList = temp;
                    });
                  },
                  child: Text("done"),
                  style: ElevatedButton.styleFrom(
                    shape: ContinuousRectangleBorder(),
                    backgroundColor: selection == 2
                        ? Color.fromRGBO(252, 84, 72, 1.0)
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 5),
              shrinkWrap: true,
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final data = dataList[index].data();
                final userId = data?['userid'];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10 * fem),
                  ),
                  elevation: 5,
                  shadowColor: Color(0xff6f6f6f),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: InkWell(
                      onTap: () async {
                        String userName =
                        await HistoryQueries().getName(userId);
                        String phoneNumber =
                        await HistoryQueries().getNumber(userId);
                        String car = data?['car'] ?? ''; // Replace with the correct field name
                        String description =
                            data?['description'] ?? ''; // Replace with the correct field name
                        String hour = data?['hour']?.toString() ?? ''; // Replace with the correct field name

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewHistory(
                              appointmentId: data?['id'],
                              appointmentState: data?['state'],

                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: FutureBuilder<String>(
                          future: HistoryQueries().getName(data?['userid']),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(snapshot.data ?? '');
                            }
                          },
                        ),
                        subtitle: FutureBuilder<String>(
                          future: HistoryQueries().getNumber(data?['userid']),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(snapshot.data ?? '');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Color.fromRGBO(252, 84, 72, 1.0),
                indent: 30,
                endIndent: 30,
                thickness: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
