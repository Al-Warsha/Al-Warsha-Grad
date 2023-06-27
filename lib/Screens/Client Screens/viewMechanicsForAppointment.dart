import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Controller/viewMechanicsForAppointmentController.dart';
import '../../Models/businessOwner_model.dart';
import 'MechanicDetails.dart';


// class viewMechanicsForAppointment extends StatefulWidget {
// static const String routeName='viewMechanicsForAppointment';
//   const viewMechanicsForAppointment ({Key? key}) : super(key: key);
//
//   @override
//   State<viewMechanicsForAppointment> createState() => viewMechanicsForAppointment_State();
// }

class viewMechanicsForAppointment extends GetView<viewMechanicsForAppointmentController> {
  final viewMechanicsForAppointmentController _controller = Get.put(viewMechanicsForAppointmentController());
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Obx(() {
      List<BusinessOwnerModel> BusinessOwners = controller.businessOwners
          .where((businessOwner) => businessOwner.type != 'Winch Service')
          .toList();
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    221.34 * fem, 0 * fem, 0 * fem, 8 * fem),
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
                          BackButton(color: Colors.black,),
                          Text('Displaying All Mechanic', style: TextStyle(
                              fontSize: 18, color: Colors.black)),
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
                separatorBuilder: (context, index) =>
                    Container(
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
                    margin: EdgeInsets.symmetric(
                        vertical: 7 * fem, horizontal: 12 * fem),
                    child: Stack(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10 * fem),
                          ),
                          elevation: 5,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MechanicDetails(
                                        mechanicId: businessOwner.id,
                                        isEmergency: false,
                                        winch: false,
                                      ),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                              EdgeInsets.symmetric(
                                  vertical: 12 * fem, horizontal: 10 * fem),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        businessOwner.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 19 * ffem,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        'PhoneNumber: ${businessOwner.phone}',
                                        style: TextStyle(
                                          fontSize: 13 * ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4000000272 * ffem / fem,
                                          color: Color(0xff6f6f6f),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        'Address: ${businessOwner.address}',
                                        style: TextStyle(
                                          fontSize: 13 * ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4000000272 * ffem / fem,
                                          color: Color(0xff6f6f6f),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Icon(Icons.star, size: 18,
                                            color: Colors.yellow,),
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },

              ),
            ],
          ),
        ),
      );
    } );
  }

}
