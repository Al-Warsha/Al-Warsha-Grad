import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../Controller/viewMechanicsForAppointmentController.dart';
import '../Models/businessOwner_model.dart';
import 'MechanicDetails.dart';

class viewMechanicsForEmergency extends StatefulWidget {

  const viewMechanicsForEmergency ({Key? key}) : super(key: key);

  @override
  State<viewMechanicsForEmergency> createState() => viewMechanicsForEmergency_State();
}

class viewMechanicsForEmergency_State extends State<viewMechanicsForEmergency> {
  final viewMechanicsForAppointmentController _controller = Get.put(viewMechanicsForAppointmentController());
  double deviceLatitude = 0.0;
  double deviceLongitude = 0.0;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        deviceLatitude = position.latitude;
        deviceLongitude = position.longitude;
      });
    } catch (error) {
      print('Error getting current position: $error');
    }
  }

  num _calculateDistance(
      num startLatitude,
      num startLongitude,
      num endLatitude,
      num endLongitude,
      ) {
    const int earthRadius = 6371; // Radius of the Earth in kilometers

    num lat1 = startLatitude * pi / 180;
    num lon1 = startLongitude * pi / 180;
    num lat2 = endLatitude * pi / 180;
    num lon2 = endLongitude * pi / 180;

    num dLat = lat2 - lat1;
    num dLon = lon2 - lon1;

    num a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    num c = 2 * atan2(sqrt(a), sqrt(1 - a));

    num distanceInKm = earthRadius * c;
    return distanceInKm;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    List<BusinessOwnerModel> BusinessOwners = _controller.businessOwners
        .where((businessOwner) => businessOwner.type == 'mechanic')
        .toList();

    BusinessOwners.sort((a, b) {
      num distanceA = _calculateDistance(
        deviceLatitude,
        deviceLongitude,
        a.latitude,
        a.longitude,
      );
      num distanceB = _calculateDistance(
        deviceLatitude,
        deviceLongitude,
        b.latitude,
        b.longitude,
      );
      return distanceA.compareTo(distanceB);
    });

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
                num latitude = businessOwner.latitude;
                num longitude = businessOwner.longitude;
                num distanceInKm = _calculateDistance(
                  deviceLatitude,
                  deviceLongitude,
                  latitude,
                  longitude,
                );
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
                              mechanicId: businessOwner.id, isEmergency: true, winch: false,
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
                                    alignment: Alignment.bottomRight,
                                    width: double.infinity,
                                    child: Text(
                                      '${distanceInKm.toStringAsFixed(2)} km away',
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
