import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/Screens/Client%20Screens/BottomNavigationBarExample.dart';
import '../../Models/emegencyAppointment.dart';
import '../../Shared/network/local/firebase_utils.dart';
import 'Google_map.dart';
import 'add_car.dart';


class EmergencyRoadHelp extends StatefulWidget {
  final String? mechanicId;
  final String? businessOwnerId;
  const EmergencyRoadHelp({Key? key,required this.mechanicId,
    required this.businessOwnerId,}) : super(key: key);

  @override
  State<EmergencyRoadHelp> createState() => _EmergencyRoadHelp();
}

class _EmergencyRoadHelp extends State<EmergencyRoadHelp> {

  List<String> cars = [];
  String? selectedcar;
  var descriptionController= TextEditingController();
  //GeoPoint? currentLocation;

  double? currentLatitude;
  double? currentLongitude;
  //TimeOfDay selectedtime = TimeOfDay.now();
  final DateTime currentDateTime = DateTime.now();

  late String? userId;
  late String? businessOwnerId;

  @override
  void initState() {
    super.initState();
    // Retrieve the current user ID
    User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    // Retrieve the business owner ID from the widget parameters
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
      // Fetch the user's cars from Firestore using the correct user ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cars')
          .where('userId', isEqualTo: userId)
          .get();

      querySnapshot.docs.forEach((doc) {
        // Add each car to the list
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String? carName = data['model'];
        if (carName != null) {
          userCars.add(carName);
        }
      });
    } catch (error) {
      // Handle any errors that occur during the fetch process
      print('Error fetching user cars: $error');
    }

    return userCars;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CupertinoColors.white,
        body:
        Stack(
            children:[
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/Picture2.png',
                ),
                width: 300,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      BackButton( color: Colors.black,),
                      Text('Emergency Road Help', style: TextStyle(fontSize: 17, color: Colors.black)),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Container(alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15, top: 20, ),
                      child: Text('Select a car or add new one', style: TextStyle(fontSize: 20),)),
                  //const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: DropdownButton<String>(
                      value: selectedcar,
                      items: cars.map((car) => DropdownMenuItem(value: car, child: Text(car, style: TextStyle(fontSize: 22)))).toList(),
                      onChanged: (String? car) {
                        if (car == 'add new car')
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddCar(fromSchedule: true,)),
                          );
                        setState(() {
                          selectedcar = car;
                        });
                      },
                    )
                  ),
                  //const SizedBox(height: 20),
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
                      primary: Color.fromRGBO(252	,84	,72, 1),
                    ),
                    onPressed: (){ Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Google_map(
                          onLocationSelected: updateLocation, emergency: true, mechanicId: '', businessOwnerId: '',
                        ),
                      ),
                    );
                    },
                    child: const Text("Get Current Location"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async{
                      final String formattedDateTime =
                      DateFormat('MMM dd, yyyy - hh:mm a').format(currentDateTime);
                      emergencyAppointment appointment = emergencyAppointment(
                        description: descriptionController.text,
                        car: selectedcar!,
                        latitude: currentLatitude!,
                        longitude: currentLongitude!,
                          userid: userId, mechanicid: businessOwnerId!, timestamp: formattedDateTime);
                      addemergencyToFireStore(appointment);
                      await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                      content: const Text('Request has been send'),
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
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 60),
                      primary: Color.fromRGBO(252	,84	,72, 1),
                      shape: RoundedRectangleBorder( //to set border radius to button
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    child: Center(
                      child: Text('REQUEST', style: TextStyle(fontSize: 20),),
                    ),)
                ],
              ),
            ]
        )
    );
  }
  void updateLocation(double? latitude, double? longitude) {
    setState(() {
      currentLatitude = latitude;
      currentLongitude = longitude;
    });

  }
}
