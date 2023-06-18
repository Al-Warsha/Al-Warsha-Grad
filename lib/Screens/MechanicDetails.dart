import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../Controller/viewMechanicsForAppointmentController.dart';
import '../Models/businessOwner_model.dart';


class MechanicDetails extends StatelessWidget {
  final String? mechanicId;
  MechanicDetails({required this.mechanicId});

  viewMechanicsForAppointmentController vm = new viewMechanicsForAppointmentController();

  @override
  Widget build(BuildContext context) {
    final Rx<BusinessOwnerModel?> businessOwner = Rx<BusinessOwnerModel?>(null);
    // Fetch the business owner details
    vm.fetchBusinessOwnerDetails(mechanicId).then((owner) {
      businessOwner.value = owner;
    });
    //bool isEmergency = true;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mechanic Details'),
        backgroundColor: Color(0xFFFC5448),
      ),
      body: Center(
        child: Column(
          children: [
            Obx(
                  () => businessOwner.value != null
                  ? Container(
                margin: EdgeInsets.fromLTRB(30, 25, 30, 30),
                child: Card(
                  elevation: 10,
                  shadowColor: Color(0xFFFC5448),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: Text('Name'),
                          subtitle: Text('${businessOwner.value!.name}'),
                        ),
                        ListTile(
                          title: Text('Phone'),
                          subtitle:
                          Text('${businessOwner.value!.phone}'),
                        ),
                        ListTile(
                          title: Text('Type'),
                          subtitle: Text('${businessOwner.value!.type}'),
                        ),
                        ListTile(
                          title: Text('Supported Brands'),
                          subtitle:
                          Text('${businessOwner.value!.brands}'),
                        ),
                        ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star, size: 18, color: Colors.yellow),
                                  SizedBox(width: 8),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text('${businessOwner.value!.rate}'),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            // if (isEmergency) {
                            //   Navigator.pushNamed(context, 'EmergencyRoadHelp');
                            // } else {
                            //   Navigator.pushNamed(context, 'AppointmentForMaintenance');
                            // }

                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFC5448),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: Icon(Icons.directions_car_sharp),
                          label: Text(
                            'Schedule',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : CircularProgressIndicator(),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     GestureDetector(
            //       onTap: handleRejectedIconClick,
            //       child: Container(
            //         margin: EdgeInsets.only(right: 10),
            //         width: 50,
            //         height: 50,
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: Colors.red,
            //         ),
            //         child: Icon(
            //           Icons.close,
            //           color: Colors.white,
            //           size: 30,
            //         ),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: handleVerifiedIconClick,
            //       child: Container(
            //         margin: EdgeInsets.only(left: 100),
            //         width: 50,
            //         height: 50,
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: Colors.green,
            //         ),
            //         child: Icon(
            //           Icons.check,
            //           color: Colors.white,
            //           size: 30,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
