import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Screens/EmergencyRoadHelp.dart';
import 'dart:ui';
import '../Controller/viewMechanicsForAppointmentController.dart';
import '../Models/businessOwner_model.dart';
import 'AppointmentForMaintenance.dart';
import 'Google_map.dart';


class MechanicDetails extends StatefulWidget {
  final String? mechanicId;
  bool isEmergency;
  bool winch;
  MechanicDetails({Key? key, required this.mechanicId, required this.isEmergency, required this.winch }) : super(key: key);


  //MechanicDetails({required this.mechanicId, required this.isEmergency, required this.winch });
  @override
  State<MechanicDetails> createState() => _MechanicDetails();
}

class _MechanicDetails extends State<MechanicDetails> {
  viewMechanicsForAppointmentController vm = new viewMechanicsForAppointmentController();

  //viewMechanicsForEmergencyController vmm = new viewMechanicsForEmergencyController();
  double? currentLatitude;
  double? currentLongitude;

  @override
  Widget build(BuildContext context) {
    bool isEmergency = widget.isEmergency;
    bool winch = widget.winch;
    String? mechanicId= widget.mechanicId;

    final Rx<BusinessOwnerModel?> businessOwner = Rx<BusinessOwnerModel?>(null);
    vm.fetchBusinessOwnerDetails(mechanicId).then((owner) {
      businessOwner.value = owner;
    });
    // vmm.fetchBusinessOwnerDetails(mechanicId).then((owner) {
    //   businessOwner.value = owner;
    // });
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
                  () =>
              businessOwner.value != null
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
                                  Icon(Icons.star, size: 18,
                                      color: Colors.yellow),
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
                            if (isEmergency && !winch) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EmergencyRoadHelp()
                                ),
                              );
                            } else if (!isEmergency && !winch) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AppointmentForMaintenance( mechanicId: mechanicId,
                                          businessOwnerId: businessOwner.value!.id,)
                                ),
                              );
                            }
                            else if (!isEmergency && winch) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Google_map(
                                        onLocationSelected: updateLocation,
                                        emergency: false,
                                        mechanicId: mechanicId,
                                        businessOwnerId: businessOwner.value!.id,
                                      ),
                                ),
                              );
                              //   await showDialog<String>(
                              // context: context,
                              // builder: (BuildContext context) => AlertDialog(
                              // content: const Text('Request has been send'),
                              // actions: <Widget>[
                              // TextButton(
                              // onPressed: () => Navigator.pop(context, 'OK'),
                              // child: const Text('OK'),
                              // ),],),);
                              //   Navigator.pushNamed(context, 'ServicesScreen');
                            }
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
          ],
        ),
      ),
    );
  }

  void updateLocation(double? latitude, double? longitude) {
    setState(() {
      currentLatitude = latitude;
      currentLongitude = longitude;
    });
  }

}
