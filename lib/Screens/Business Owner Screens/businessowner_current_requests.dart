import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Screens/Business%20Owner%20Screens/view_current_request.dart';
import '../../Controller/adminMechaniDetailsController.dart';
import '../../Controller/auth_controller.dart';
import 'BottomNavigationBar-BusinessOwner.dart';
import 'businessOwner_homepage.dart';
import 'current_requests.dart';

class BusinessCurrentRequests extends StatefulWidget {
  static const String routeName = 'requests';

  final int initialSelection;

  const BusinessCurrentRequests({
    Key? key,
    required this.initialSelection,
  }) : super(key: key);

  @override
  State<BusinessCurrentRequests> createState() =>
      _BusinessCurrentRequestsState();
}

class _BusinessCurrentRequestsState extends State<BusinessCurrentRequests> {
  int selection =1;
  String name = '';
  AdminMechanicDetailsController controller = AdminMechanicDetailsController();
  String? userId = AuthController.instance.currentUserUid;
  List<DocumentSnapshot<Map<String, dynamic>>> dataList = [];

  Future<void> _loadEmergencyRequests() async {
    if (selection == 1) {
      List<DocumentSnapshot<Map<String, dynamic>>> temp =
      await CurrentRequests().pendingRequests(userId!);
      setState(() {
        dataList = temp;
      });
    } else if (selection == 2) {
      List<DocumentSnapshot<Map<String, dynamic>>> temp =
      await CurrentRequests().acceptedRequests(userId!);
      setState(() {
        dataList = temp;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Set the initial selection based on the value passed to the widget
    selection = widget.initialSelection;
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
          'Current Requests',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back), color: Colors.black,onPressed: (){                        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) =>BottomNavigationBarBusinessOwner())
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
                    await CurrentRequests().pendingRequests(userId!);
                    setState(() {
                      selection = 1;
                      dataList = temp;
                    });
                  },
                  child: Text("Pending"),
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
                    await CurrentRequests().acceptedRequests(userId!);
                    setState(() {
                      selection = 2;
                      dataList = temp;
                    });
                  },
                  child: Text("Accepted"),
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
                        await CurrentRequests().getName(userId);
                        String phoneNumber =
                        await CurrentRequests().getNumber(userId);
                        String car = data?['car'] ?? ''; // Replace with the correct field name
                        String description =
                            data?['description'] ?? ''; // Replace with the correct field name
                        String hour = data?['hour']?.toString() ?? ''; // Replace with the correct field name

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewCurrentRequest(
                              appointmentId: data?['id'],
                              appointmentState: data?['state'],
                              userName: userName,
                              phoneNumber: phoneNumber,
                              hour: hour,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: FutureBuilder<String>(
                          future: CurrentRequests().getName(data?['userid']),
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
                          future: CurrentRequests().getNumber(data?['userid']),
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
