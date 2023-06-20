import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/viewMechanicsForAppointmentController.dart';
import '../Models/businessOwner_model.dart';
import 'MechanicDetails.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;

class winchService extends StatefulWidget {
  static const String routeName='winch';
  const winchService({Key? key}) : super(key: key);

  @override
  State<winchService> createState() => _winchServiceState();
}

class _winchServiceState extends State<winchService> {
  final viewMechanicsForAppointmentController _controller = Get.put(viewMechanicsForAppointmentController());

  

  static const double earthRadius = 6371; // Earth's radius in kilometers

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    double dLat = degreesToRadians(endLatitude - startLatitude);
    double dLon = degreesToRadians(endLongitude - startLongitude);

    double a = pow(sin(dLat / 2), 2) +
        cos(degreesToRadians(startLatitude)) *
            cos(degreesToRadians(endLatitude)) *
            pow(sin(dLon / 2), 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }


  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    List<BusinessOwnerModel> BusinessOwners = _controller.businessOwners
        .where((businessOwner) => businessOwner.type == 'winch')
        .toList();

    // List<String> cars = ['car1', 'car2', 'add new car'];
    // String? selectedcar = '';
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(221.34 * fem, 0 * fem, 0 * fem, 8 * fem),
              width: 22.34 * fem,
              height: 22.34 * fem,
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
                        Text('Displaying for "Area detected', style: TextStyle(fontSize: 18, color: Colors.black)),
                      ],
                    ),
                  ],
                ),
                // Container(alignment: Alignment.topLeft,
                //     margin: EdgeInsets.only(left: 15 ),
                //     child: Text('Select a car or add new one', style: TextStyle(fontSize: 19),)),
                // DropdownButton<String>(
                //     value: selectedcar,
                //     items: cars.map((car) => DropdownMenuItem(value: car,
                //         child: Text(car, style: TextStyle(fontSize: 15),)))
                //         .toList(),
                //     onChanged: (String? car) {
                //       if(car == 'add new car')
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(builder: (context) => AddCar()),
                //         );
                //       setState(() {
                //         selectedcar = car;
                //       });
                //     }
                // ),
              ],
            ),

            ListView.separated(

                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: BusinessOwners.length,
                separatorBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 50 * fem),
                  width: double.infinity,
                  height: 1 * fem,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFFC5448),
                        width: 3,
                      ),
                    ),
                  ),
                ),
                itemBuilder: (context, index) {
                  BusinessOwnerModel businessOwner = BusinessOwners[index];
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 7 * fem, horizontal: 12 * fem),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10* fem),
                      ),
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MechanicDetails(
                                mechanicId: businessOwner.id,isEmergency: false, winch: true,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12 * fem, horizontal: 10 * fem),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(2 * fem, 0 * fem, 0 * fem, 13.5 * fem),
                                width: 140 * fem,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 35 * fem, 3 * fem),
                                      width: double.infinity,
                                      child: Text(
                                        businessOwner.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 19 * ffem,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Text(
                                        'PhoneNumber: ${businessOwner.phone}',
                                        style: TextStyle(
                                          fontSize: 13 * ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4000000272 * ffem / fem,
                                          color: Color(0xff6f6f6f),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Icon(Icons.star, size: 18, color: Colors.yellow,),
                                          Text(
                                            ' ${businessOwner.rate}',
                                            style: TextStyle(
                                              fontSize: 13 * ffem,
                                              fontWeight: FontWeight.w700,
                                              height: 1.4000000272 * ffem / fem,
                                              color: Color(0xff6f6f6f),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      width: double.infinity,
                                      child: Text(
                                        'oryb aw b3ed',
                                        style: TextStyle(
                                          fontSize: 13 * ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4000000272 * ffem / fem,
                                          color: Color(0xff6f6f6f),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }



}

