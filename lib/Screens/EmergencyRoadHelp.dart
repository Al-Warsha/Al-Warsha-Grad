import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Models/emegencyAppointment.dart';
import '../Shared/network/local/firebase_utils.dart';
import 'Google_map.dart';
import 'ServicesScreen.dart';
import 'add_car.dart';


class EmergencyRoadHelp extends StatefulWidget {

  const EmergencyRoadHelp({Key? key}) : super(key: key);

  @override
  State<EmergencyRoadHelp> createState() => _EmergencyRoadHelp();
}

class _EmergencyRoadHelp extends State<EmergencyRoadHelp> {

  List<String> cars = ['car1', 'car2', 'add new car'];
  String? selectedcar;
  var descriptionController= TextEditingController();
  //GeoPoint? currentLocation;

  double? currentLatitude;
  double? currentLongitude;
  TimeOfDay selectedtime = TimeOfDay.now();

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
                        items: cars.map((car) => DropdownMenuItem(value: car,
                            child: Text(car, style: TextStyle(fontSize: 22),)))
                            .toList(),
                        onChanged: (String? car) {
                          if(car == 'add new car')
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddCar(fromSchedule: false,)),
                            );
                          setState(() {
                            selectedcar = car;
                          });
                        }
                    ),
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
                      emergencyAppointment appointment = emergencyAppointment(
                        description: descriptionController.text,
                        car: selectedcar!,
                        latitude: currentLatitude!,
                        longitude: currentLongitude!,
                        hour: selectedtime.hour, minute: selectedtime.minute,);
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
                      builder: (context) => ServicesScreen(),
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
