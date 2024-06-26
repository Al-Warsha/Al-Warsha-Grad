import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Screens/Admin%20Screens/pdf_api.dart';
import 'package:myapp/Screens/Admin%20Screens/pdf_viewer_page.dart';
import 'package:url_launcher/url_launcher.dart';
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
    final Rx<BusinessOwnerModel?> businessOwner =
    Rx<BusinessOwnerModel?>(null);
    // Fetch the business owner details
    _controller.fetchBusinessOwnerDetails(mechanicId).then((owner) {
      businessOwner.value = owner;
    });

    void handleRejectedIconClick() async {
      try {
        businessOwner.value?.setRejected(true);
        await _controller.updateBusinessOwner(businessOwner.value!, isVerification: false);
        await _controller2.fetchBusinessOwners();
        Navigator.pop(context);
      } catch (e) {
        print('Error rejecting business owner: $e');
        Get.snackbar(
          'Error',
          'Unable to reject business owner request. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    void handleVerifiedIconClick() async {
      try {
        businessOwner.value?.setVerified(true);
        await _controller.updateBusinessOwner(businessOwner.value!, isVerification: true);
        await _controller2.fetchBusinessOwners();
        Navigator.pop(context);
      } catch (e) {
        print('Error verifying business owner: $e');
        Get.snackbar(
          'Error',
          'Unable to accept business owner request. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }



    void openPDF(BuildContext context, File file) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PDFViewerPage(file: file, key: UniqueKey()),
        ),
      );
    }

    _launchEmail(String email, String subject, String body) async {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          'subject': Uri.encodeComponent(subject),
          'body': Uri.encodeComponent(body),
        },
      );

      String url = emailUri.toString();
      url = Uri.decodeComponent(url);

      try {
        await launch(url);
      } catch (e) {
        throw 'Could not launch email: $e';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mechanic Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                              final url =
                                  businessOwner.value!.documentURL;
                              final file =
                              await PDFApi.loadFirebase(url);
                              if (file == null) return;
                              openPDF(context, file as File);
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
                    : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFC5448)), // Set your custom color here
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      try {
                        handleRejectedIconClick();
                        _launchEmail(
                          businessOwner.value?.email ?? '',
                          'Your Business Account in El-Warsha has been Rejected.',
                          'Hello Dear,  \n\n Sorry to let you know that you have not been verified due to your documents not being up to bar. Looking forward to reviewing your account again once they have been re-submitted! \n\n Warmest Regards,\nEl-Warsha Team ',
                        );
                      } catch (e) {
                        print('Error occurred: $e');
                        Get.snackbar(
                          'Error',
                          'An error occurred. Please try again.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
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
                    onTap: () {
                      try {
                        handleVerifiedIconClick();
                        _launchEmail(
                          businessOwner.value?.email ?? '',
                          'Your Business Account in El-Warsha has been Approved.',
                          'Hello Dear, \n\n Glad to let you know that you have been verified and part of our application now. Looking forward to growing our application with you! \n\n Warmest Regards,\nEl-Warsha Team ',
                        );
                      } catch (e) {
                        print('Error occurred: $e');
                        Get.snackbar(
                          'Error',
                          'An error occurred. Please try again.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
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
      ),
    );
  }
}
