import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Models/scheduleAppointment.dart';
import '../Shared/network/local/firebase_utils.dart';
import 'add_car.dart';


class AppointmentForMaintenance extends StatefulWidget {
  static const String routeName='AppointmentForMaintenance';
  const AppointmentForMaintenance({Key? key}) : super(key: key);

  @override
  State<AppointmentForMaintenance> createState() => _AppointmentForMaintenance();
}

class _AppointmentForMaintenance extends State<AppointmentForMaintenance> {

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedtime = TimeOfDay.now();
  List<String> cars = ['car1', 'car2', 'add new car'];
  String? selectedcar;
  var reasonController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CupertinoColors.white,
      body:
      Stack(
        children: [
        //   Positioned(
        //   top: 0,
        //   left: 0,
        //   child: Image.asset(
        //     'assets/images/Picture1.jpg',
        //   ),
        //   width: 250,
        // ),
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
                items: cars.map((car) => DropdownMenuItem(value: car,
                    child: Text(car, style: TextStyle(fontSize: 22),)))
                    .toList(),
                onChanged: (String? car) {
                  if(car == 'add new car')
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCar()),
                    );
                  setState(() {
                    selectedcar = car;
                  });
                }
            ),
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
            onPressed: (){
              scheduleAppointment  appointment= scheduleAppointment(date: selectedDate.microsecondsSinceEpoch,
                  hour: selectedtime.hour, minute: selectedtime.minute,description: reasonController.text, car: selectedcar!);
              addScheduleToFireStore(appointment);
            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 60),
              primary: Color.fromRGBO(252	,84	,72, 1),
                shape: RoundedRectangleBorder( //to set border radius to button
                    borderRadius: BorderRadius.circular(30)
                ),
            ),
            child: Center(
              child: Text('CONTINUE', style: TextStyle(fontSize: 20),),
            ),)
        ],
      ),
        ],
      ),
    );
  }
}

