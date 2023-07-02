import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Controller/Requests.dart';
import 'package:myapp/Screens/Client%20Screens/BottomNavigationBarExample.dart';
import 'package:myapp/Screens/Client%20Screens/viewRequest.dart';
import '../../Controller/adminMechaniDetailsController.dart';
import '../../Controller/auth_controller.dart';


class ClientRequests extends StatefulWidget {

  static const String routeName = 'requests';
  const ClientRequests({Key? key}) : super(key: key);


  @override
  State<ClientRequests> createState() => _clientRequestsState();
}

class _clientRequestsState extends State<ClientRequests> {
  int selection = 1;
  String name= '';
  AdminMechanicDetailsController controller = AdminMechanicDetailsController();
  String? userId = AuthController.instance.currentUserUid;
  late List<DocumentSnapshot<Map<String, dynamic>>> dataList = [];


  Future<void> _loadEmergencyRequests() async {
  List<DocumentSnapshot<Map<String, dynamic>>> temp =
  await Requests().emergencyRequests(userId!);
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
          backgroundColor: Colors.white,
            leading: IconButton(icon: Icon(Icons.arrow_back), color: Colors.black,onPressed: (){                        Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => BottomNavigationBarExample())
            );
            }),
          title: Text(
            'Requests',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   shadowColor: Colors.transparent,
      //   title: Text('Requests', textAlign: TextAlign.left, style: TextStyle(color: Colors.black),),
      //   leading: IconButton(icon: Icon(Icons.arrow_back), color: Colors.black,onPressed: (){                        Navigator.pop(context);
      //   Navigator.push(context, MaterialPageRoute(
      //       builder: (context) => BottomNavigationBarExample())
      //   );
      //   }),
      // ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    List<DocumentSnapshot<Map<String, dynamic>>> temp = await Requests().emergencyRequests(userId!);
                    setState(() {
                      selection = 1;
                      dataList = temp;
                    });
                    },
                  child: Text("Emergency"),
                  style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(),
                      backgroundColor: selection == 1 ? Color.fromRGBO(252,84, 72, 1.0) : Colors.grey
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    List<DocumentSnapshot<Map<String, dynamic>>> temp = await Requests().scheduleRequests(userId!);
                    setState(() {
                      selection = 2;
                      dataList = temp;

                    });
                  },
                  child: Text("Scheduled"),
                  style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(),
                      backgroundColor: selection == 2 ? Color.fromRGBO(252,84, 72, 1.0) : Colors.grey
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    List<DocumentSnapshot<Map<String, dynamic>>> temp = await Requests().winchRequests(userId!);
                    setState(() {
                      selection = 3;
                      dataList = temp;

                    });
                  },
                  child: Text("Winch"),
                  style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(),
                      backgroundColor: selection == 3 ? Color.fromRGBO(252,84, 72, 1.0) : Colors.grey
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

                return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10* fem),
                    ),
                    elevation: 5,
                    shadowColor: Color(0xff6f6f6f),
                    child: Padding(
                    padding: EdgeInsets.all(20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewRequest(
                                Id: data?['id'],
                                selection: selection,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: FutureBuilder<String>(
                            future: Requests().getName(data?['mechanicid']),
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(snapshot.data ?? '');
                              }
                            },
                          ),
                          subtitle: Text(data?['state']?? 'N/A'),
                        ),
                      ),
                    )
                  );
                }, separatorBuilder: (BuildContext context, int index) =>  Divider(
                color: Color.fromRGBO(252,84, 72, 1.0),
                indent: 30,
                endIndent: 30,
                thickness: 3
            )
            ),
          )

        ],
      )

    );

}}