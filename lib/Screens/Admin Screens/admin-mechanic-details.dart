import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myapp/Screens/Admin%20Screens/pdf_api.dart';
import 'package:myapp/Screens/Admin%20Screens/pdf_viewer_page.dart';
import '../../Controller/adminHomepageController.dart';
import '../../Controller/adminMechaniDetailsController.dart';
import '../../Models/businessOwner_model.dart';

class MechanicDetails extends StatelessWidget {
  final String? mechanicId;
  final AdminMechanicDetailsController _controller =
  Get.put(AdminMechanicDetailsController());
  final AdminHomepageController _controller2 =
  Get.put(AdminHomepageController());
  MechanicDetails({required this.mechanicId});

  @override
  Widget build(BuildContext context) {
    final Rx<BusinessOwnerModel?> businessOwner = Rx<BusinessOwnerModel?>(null);
    // Fetch the business owner details
    _controller.fetchBusinessOwnerDetails(mechanicId).then((owner) {
      businessOwner.value = owner;
    });

    void handleRejectedIconClick() async {
      businessOwner.value?.setRejected(true);
      await _controller.updateBusinessOwner(businessOwner.value!,
          isVerification: false);
      await _controller2.fetchBusinessOwners();
      Navigator.pop(context);
    }

    void handleVerifiedIconClick() async {
      businessOwner.value?.setVerified(true);
      await _controller.updateBusinessOwner(businessOwner.value!,
          isVerification: true);
      await _controller2.fetchBusinessOwners();
      Navigator.pop(context);
    }


    void openPDF(BuildContext context, File file) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file, key: UniqueKey())),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mechanic Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Obx(
                  () => businessOwner.value != null
                  ? Container(
                margin: EdgeInsets.fromLTRB(30, 25, 30, 30),
                child: Card(
                  elevation: 10,
                  shadowColor: Color(0xFFFC5448),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: Text('Name'),
                          subtitle: Text('${businessOwner.value!.name}'),
                        ),
                        ListTile(
                          title: Text('Email'),
                          subtitle:
                          Text('${businessOwner.value!.email}'),
                        ),
                        ListTile(
                          title: Text('Address'),
                          subtitle:
                          Text('${businessOwner.value!.address}'),
                        ),
                        ListTile(
                          title: Text('Phone'),
                          subtitle:
                          Text('${businessOwner.value!.phone}'),
                        ),
                        ListTile(
                          title: Text('Type'),
                          subtitle:
                          Text('${businessOwner.value!.type}'),
                        ),
                        ListTile(
                          title: Text('Supported Brands'),
                          subtitle:
                          Text('${businessOwner.value!.brands}'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            // Call the navigateToDocument method with the document URL
                            final url=businessOwner.value!.documentURL;
                            final file= await PDFApi.loadFirebase(url);
                            if (file ==null)return;
                            openPDF(context,file as File);



                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFC5448),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: Icon(Icons.description),
                          label: Text(
                            'View Document',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : CircularProgressIndicator(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: handleRejectedIconClick,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: handleVerifiedIconClick,
                  child: Container(
                    margin: EdgeInsets.only(left: 100),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _storeFile {
}
