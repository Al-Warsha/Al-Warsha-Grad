import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:myapp/Screens/Client%20Screens/BottomNavigationBarExample.dart';
import '../../Models/emegencyAppointment.dart';
import '../../Shared/network/local/firebase_utils.dart';
import 'Google_map.dart';
import 'add_car.dart';

class EmergencyRoadHelp extends StatefulWidget {
  final String? mechanicId;
  final String? businessOwnerId;

  const EmergencyRoadHelp({
    Key? key,
    required this.mechanicId,
    required this.businessOwnerId,
  }) : super(key: key);

  @override
  State<EmergencyRoadHelp> createState() => _EmergencyRoadHelp();
}

class _EmergencyRoadHelp extends State<EmergencyRoadHelp> {
  List<String> cars = [];
  String? selectedcar;
  var descriptionController = TextEditingController();
  double? currentLatitude;
  double? currentLongitude;
  final DateTime currentDateTime = DateTime.now();
  late String? userId;
  late String? businessOwnerId;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    businessOwnerId = widget.businessOwnerId;

    fetchUserCars().then((userCars) {
      setState(() {
        cars = [...userCars, 'add new car'];
        selectedcar = userCars.isNotEmpty ? userCars[0] : null;
      });
    });
  }

  Future<List<String>> fetchUserCars() async {
    List<String> userCars = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cars')
          .where('userId', isEqualTo: userId)
          .get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String? carName = data['model'];
        if (carName != null) {
          userCars.add(carName);
        }
      });
    } catch (error) {
      print('Error fetching user cars: $error');
    }

    return userCars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CupertinoColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
        title: Text(
          'Emergency Road Help',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Picture2.png',
            ),
            width: 300,
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 15, top: 20),
                child: Text(
                  'Select a car or add new one',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: DropdownButton<String>(
                  value: selectedcar,
                  items: cars
                      .map(
                          (car) => DropdownMenuItem(value: car, child: Text(car, style: TextStyle(fontSize: 22))))
                      .toList(),
                  onChanged: (String? car) {
                    if (car == 'add new car')
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCar(fromSchedule: true)),
                      );
                    setState(() {
                      selectedcar = car;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: descriptionController,
                  maxLines: 9,
                  minLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(252, 84, 72, 1),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Latitude: ${currentLatitude ?? ''}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Longitude: ${currentLongitude ?? ''}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(252, 84, 72, 1),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Google_map(
                        onLocationSelected: updateLocation,
                        emergency: true,
                        mechanicId: '',
                        businessOwnerId: '',
                      ),
                    ),
                  );
                },
                child: const Text("Get Current Location"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (selectedcar == null || descriptionController.text.isEmpty ||
                      currentLatitude == null || currentLongitude == null) {
                    Get.snackbar(
                      "Error",
                      "All fields are required.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    final String formattedDateTime =
                    DateFormat('MMM dd, yyyy - hh:mm a').format(currentDateTime);
                    emergencyAppointment appointment = emergencyAppointment(
                      description: descriptionController.text,
                      car: selectedcar!,
                      latitude: currentLatitude!,
                      longitude: currentLongitude!,
                      userid: userId,
                      mechanicid: businessOwnerId!,
                      timestamp: formattedDateTime,
                    );
                    addemergencyToFireStore(appointment);
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: const Text('Request has been sent'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavigationBarExample(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 60),
                  primary: Color.fromRGBO(252, 84, 72, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Center(
                  child: Text(
                    'REQUEST',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ],
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
