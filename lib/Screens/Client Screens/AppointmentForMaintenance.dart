import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Models/scheduleAppointment.dart';
import '../../Shared/network/local/firebase_utils.dart';
import 'BottomNavigationBarExample.dart';
import 'add_car.dart';


class AppointmentForMaintenance extends StatefulWidget {
  final String? mechanicId;
  final String? businessOwnerId;
  const AppointmentForMaintenance({Key? key,
    required this.mechanicId,
    required this.businessOwnerId,}) : super(key: key);

  @override
  State<AppointmentForMaintenance> createState() => _AppointmentForMaintenance();
}

class _AppointmentForMaintenance extends State<AppointmentForMaintenance> {

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedtime = TimeOfDay.now();
  final DateTime currentDateTime = DateTime.now();
  List<String> cars = [];
  String? selectedcar;
  var reasonController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  late String? userId;
  late String? businessOwnerId;

  @override
  void initState() {
    super.initState();
    // Retrieve the current user ID
    User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    // Retrieve the business owner ID from Firestore
    businessOwnerId = widget.businessOwnerId;
    // if (userId != null) {
    //   getBusinessOwnerDetails(businessOwnerId).then((businessOwner) {
    //     setState(() {
    //       businessOwnerId = businessOwner?.id;
    //     });
    //   });
    // }
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
      // Retrieve the current user ID
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      // Fetch the user's cars from Firestore
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 25,),
              Column(
                children: [
                  Row(
                    children: [
                      BackButton( color: Colors.black,),
                      Text('Appointment For Maintenance', style: TextStyle(fontSize: 20, color: Colors.black)),
                    ],
                  ),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: reasonController,
                  maxLines: 9,
                  minLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Reason for Appointment',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                    ),
                    //contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 50),
                    focusedBorder: OutlineInputBorder(
                      //borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(252, 84, 72, 1),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: const TextStyle(fontSize: 20) ,
                      ),
                      ElevatedButton(
                        child: Text('Select date',
                          style:TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(252	,84	,72, 1),
                        ),
                        onPressed: () async {
                          DateTime? newdate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: selectedDate,
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          ).then((value) {
                            setState(() {
                              selectedDate=value!;
                            });
                          });
                          if(newdate == null ) return;
                        },
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text('${selectedtime.hour}:${selectedtime.minute}',
                        style: const TextStyle(fontSize: 20) ,),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(252	,84	,72, 1),
                          ),
                          onPressed: () async{
                            final TimeOfDay? timeofday= await showTimePicker(context: context,
                              initialTime: selectedtime, initialEntryMode:TimePickerEntryMode.dial,
                            );
                            if(timeofday !=null)
                            {
                              setState(() {
                                selectedtime=timeofday;
                              });
                            }
                          },
                          child: const Text('Select Time', style:TextStyle(fontSize: 20),)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                onPressed: () async {
                  final String formattedDateTime =
                  DateFormat('MMM dd, yyyy - hh:mm a').format(currentDateTime);
                  scheduleAppointment  appointment= scheduleAppointment(scheduleddate: selectedDate.microsecondsSinceEpoch,
                      scheduledhour: selectedtime.hour, scheduledminute: selectedtime.minute,description: reasonController.text,
                      car: selectedcar!, userid: userId, mechanicid: businessOwnerId!, timestamp: formattedDateTime);
                  addScheduleToFireStore(appointment);
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
        ],
      ),
    );
  }
}

