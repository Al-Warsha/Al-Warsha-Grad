import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Screens/Requests.dart';


class clientRequests extends StatefulWidget {

  static const String routeName = 'requests';

  @override
  State<clientRequests> createState() => _clientRequestsState();
}

class _clientRequestsState extends State<clientRequests> {
  int selection = 1;
  late List<DocumentSnapshot<Map<String, dynamic>>> dataList = [];

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text('Requests', textAlign: TextAlign.left, style: TextStyle(color: Colors.black),),
        leading: IconButton(icon: Icon(Icons.arrow_back), color: Colors.black,onPressed: (){}),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: (){
                    setState(() {
                      selection = 1;
                      dataList = [];
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
                    List<DocumentSnapshot<Map<String, dynamic>>> temp = await Requests().scheduleRequests("v60m86fmKUQYkHtVtChAQPmQQ2w1");
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
                    List<DocumentSnapshot<Map<String, dynamic>>> temp = await Requests().winchRequests("v60m86fmKUQYkHtVtChAQPmQQ2w1");
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
                    child: ListTile(
                    title: Text(data?['mechanicid']?? 'N/A'),
                    subtitle: Text(data?['state']?? 'N/A'),
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
  }
}