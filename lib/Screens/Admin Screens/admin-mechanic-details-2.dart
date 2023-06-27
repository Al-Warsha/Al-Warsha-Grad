import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Screens/Admin%20Screens/pdf_api.dart';
import 'package:myapp/Screens/Admin%20Screens/pdf_viewer_page.dart';
import 'dart:ui';
import '../../Controller/adminMechanicDetailsController2.dart';
import '../../Controller/all-business-accounts-Controller.dart';
import '../../Models/businessOwner_model.dart';
import 'dart:io';

class MechanicDetails2 extends StatelessWidget {
  final String? mechanicId;
  final AdminMechanicDetailsController2 _controller = Get.put(AdminMechanicDetailsController2());
  final AllBusinessOwnersPageController _controller2 = Get.put(AllBusinessOwnersPageController());
  MechanicDetails2({required this.mechanicId});

  @override
  Widget build(BuildContext context) {
    final Rx<BusinessOwnerModel?> businessOwner = Rx<BusinessOwnerModel?>(null);
    // Fetch the business owner details
    _controller.fetchBusinessOwnerDetails(mechanicId).then((owner) {
      businessOwner.value = owner;
    });

    void handleDeleteIconClick() async {
      if (businessOwner.value != null) {
        _controller.deleteBusinessOwner(businessOwner.value!);

      }
      await _controller2.fetchAllBusinessOwners();
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
                          subtitle: Text('${businessOwner.value!.type}'),
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
                  onTap: handleDeleteIconClick,
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Delete Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
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
