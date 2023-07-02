import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:ui';
import '../../Controller/all-business-accounts-Controller.dart';
import '../../Models/businessOwner_model.dart';
import 'admin-mechanic-details-2.dart';




class AllBusinessOwnerAccount extends StatelessWidget {
  final AllBusinessOwnersPageController _controller = Get.put(AllBusinessOwnersPageController());
  //final BusinessOwnerController _controller = Get.find<BusinessOwnerController>();
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton( color: Colors.black,),
        title: Text(
          'Business Accounts',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(8 * fem, 20 * fem, 0 * fem, 530 * fem),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   margin: EdgeInsets.fromLTRB(221.34 * fem, 0 * fem, 0 * fem, 8 * fem),
            //   width: 22.34 * fem,
            //   height: 22.34 * fem,
            // ),
            // Container(
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Container(
            //         child: IconButton(
            //           icon: Icon(Icons.arrow_back),
            //           onPressed: () {
            //             // Add onPressed function here
            //             Navigator.pop(context);
            //           },
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 120 * fem, 0 * fem),
            //         child: Text('Business Accounts',
            //           style: TextStyle(
            //             fontFamily: 'Urbanist',
            //             fontSize: 20 * ffem,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            Obx(() {
              if (_controller.isLoading.value) {
                return CircularProgressIndicator();
              } else {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _controller.businessOwners.length,
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
                    BusinessOwnerModel businessOwner = _controller.businessOwners[index];
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
                                builder: (context) =>MechanicDetails2(
                                  mechanicId: businessOwner.id,
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
                                          'Brands: ${businessOwner.brands}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 14 * ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3 * ffem / fem,
                                            color: Color(0xff6f6f6f),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          'Type: ${businessOwner.type}',
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
                );
              }
            }),
          ],
        ),
      ),
    );
  }

}
