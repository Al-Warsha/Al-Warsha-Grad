import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/viewMechanicsForAppointmentController.dart';
import '../../Models/businessOwner_model.dart';
import '../../Shared/network/local/firebase_utils.dart';
import 'MechanicDetails.dart';

class viewMechanicsForAppointment extends StatefulWidget {
  const viewMechanicsForAppointment({Key? key}) : super(key: key);

  @override
  State<viewMechanicsForAppointment> createState() =>
      viewMechanicsForAppointment_State();
}

class viewMechanicsForAppointment_State
    extends State<viewMechanicsForAppointment> {
  final viewMechanicsForAppointmentController _controller =
  Get.put(viewMechanicsForAppointmentController());

  List<BusinessOwnerModel> businessOwners = [];

  @override
  void initState() {
    super.initState();
    _controller.fetchBusinessOwners();
    setRate();
  }

  void setRate() async {
    List<BusinessOwnerModel> tempOwners = _controller.businessOwners
        .where((businessOwner) =>
    (businessOwner.type.contains('Winch Service') &&
        businessOwner.type.length > 1) ||
        !businessOwner.type.contains('Winch Service'))
        .toList();
    List<String> businessOwnerIds = tempOwners.map((
        businessOwner) => businessOwner.id).toList();

    // Fetch the rates for all business owners
    Future.wait(
      businessOwnerIds.map((id) => avgRate(id)),
    ).then((List<num> rates) {
      if (mounted) { // Check if the widget is still mounted
        for (int i = 0; i < tempOwners.length; i++) {
          tempOwners[i].rate = rates[i];
        }

        setState(() {
          businessOwners = tempOwners;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;
    List<BusinessOwnerModel> businessOwners = _controller.businessOwners
        .where((businessOwner) =>
    (businessOwner.type.contains('Winch Service') &&
        businessOwner.type.length > 1) ||
        !businessOwner.type.contains('Winch Service'))
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black,),
        title: Text(
          'Displaying All Mechanic',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 19
          ),
        ),
        centerTitle: true,
      ),
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
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: businessOwners.length,
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
                  BusinessOwnerModel businessOwner = businessOwners[index];
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 12 * fem, horizontal: 10 * fem),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        businessOwner.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 19 * ffem,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Services: '
                                            '${businessOwner.type.join("\n")}',
                                        style: TextStyle(
                                          fontSize: 13 * ffem,
                                          fontWeight: FontWeight.w700,
                                          height:
                                          1.4000000272 * ffem / fem,
                                          color: Color(0xff6f6f6f),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'PhoneNumber: ${businessOwner.phone}',
                                        style: TextStyle(
                                          fontSize: 13 * ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4000000272 * ffem / fem,
                                          color: Color(0xff6f6f6f),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Address: ${businessOwner.address}',
                                        style: TextStyle(
                                          fontSize: 13 * ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4000000272 * ffem / fem,
                                          color: Color(0xff6f6f6f),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 18,
                                            color: Colors.yellow,
                                          ),
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
              )
       ]
      ),
    )
          );

  }
}
