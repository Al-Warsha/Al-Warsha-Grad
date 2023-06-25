import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myapp/Models/businessOwner_model.dart';
import 'business_signup_page4.dart';
import 'google_map_signup.dart';

class BusinessOwnerPageThree extends StatefulWidget {

  const BusinessOwnerPageThree({Key? key, required this.businessOwnerModel, required this.businessOwnerId}) : super(key: key);
  final BusinessOwnerModel businessOwnerModel;
  final String businessOwnerId;


  @override
  _BusinessOwnerPageThreeState createState() => _BusinessOwnerPageThreeState();
}

class _BusinessOwnerPageThreeState extends State<BusinessOwnerPageThree> {
  late BusinessOwnerModel businessOwnerModel ;
  TextEditingController addressController = TextEditingController();
  double? currentLatitude;
  double? currentLongitude;
  bool canNext = false;
  String address = '';

  void updateLocation(double? latitude, double? longitude) {
    setState(() {
      currentLatitude = latitude;
      currentLongitude = longitude;
    });
  }
  late String businessOwnerId;

  @override
  void initState() {
    super.initState();
    businessOwnerId = widget.businessOwnerId;
    businessOwnerModel = widget.businessOwnerModel;
    // Update the document with additional data using businessOwnerId
    updateNextButton();
  }
  void _updateDocument() {
    String address = addressController.text.trim();
    double longitude = currentLongitude ?? 0;
    double latitude = currentLatitude ?? 0;
    if (businessOwnerId.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('Test')
          .doc(businessOwnerId)
          .update({
        'address': address,
        'longitude': longitude,
        'latitude' : latitude,
      })
          .then((value) {
        final businessOwnerData = BusinessOwnerModel(
          id: businessOwnerId,
          name:businessOwnerModel.name,
          email:businessOwnerModel.email,
          password:businessOwnerModel.password,
          phone:businessOwnerModel.phone,
          address: address,
          brands : businessOwnerModel.brands,
          documentURL: "",
          imageURL: "",
          isLoggedIn: false,
          isSignedOut: false,
          latitude: longitude,
          longitude: latitude,
          rate: 0,
          rejected: false,
          type: businessOwnerModel.type,
          verified: false,



        );
        _updateBusinessOwnerModel(businessOwnerData);
      })
          .catchError((error) {
        print('Failed to update document: $error');
      });
    } else {
      print('Invalid businessOwnerId');
    }
  }

  void goToGoogleMapSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoogleMapSignup(
          onLocationSelected: updateLocation,
          businessOwnerModel: widget.businessOwnerModel,
        ),
      ),
    );
  }


  Future<void> goToBusinessOwnerPageFour() async {
    Get.to(() => BusinessOwnerPageFour(businessOwnerModel: businessOwnerModel,
        businessOwnerId:businessOwnerId));
  }
  void _updateBusinessOwnerModel(BusinessOwnerModel businessOwnerData) {
    setState(() {
      businessOwnerModel.address = businessOwnerData.address;
      businessOwnerModel.longitude = businessOwnerData.longitude;
      businessOwnerModel.latitude = businessOwnerData.latitude;

    });
  }
  void updateNextButton() {
    setState(() {
      canNext = isAddressValid(address);
    });
  }

  void checkNextEligibility(BuildContext context) {
    if (!isAddressValid(address)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter a valid address."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    goToBusinessOwnerPageFour();
  }

  bool isAddressValid(String address) {
    // Check if address contains only letters, numbers, and spaces
    final RegExp addressRegExp = RegExp(r'^[a-zA-Z0-9 ]+$');
    return addressRegExp.hasMatch(address);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/login_gp.jpg",
              width: w * 0.6,
              height: h * 0.3,
            ),
          ),
          Positioned(
            top: h * 0.18,
            left: w * 0.05,
            right: w * 0.05,
            child: Column(
              children: [
                Text(
                  "Sign-up",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  "assets/images/breakLogin.jpg",
                  width: w * 0.4,
                  height: h * 0.01,
                ),
                SizedBox(height: h * 0.05),
                SizedBox(
                  height: h * 0.07,
                  child: Container(
                    width: w * 0.9,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.location_on,
                            size: 20, color: Color(0xFFFC5448)),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: addressController,
                            onChanged: (value) {
                              setState(() {
                                address = value.trim();

                                businessOwnerModel.address = address;
                              });
                              updateNextButton();
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter your address',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Latitude: ${currentLatitude ?? ''}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Longitude: ${currentLongitude ?? ''}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(252, 84, 72, 1),
                  ),
                  onPressed: () {
                    goToGoogleMapSignup();
                  },
                  child: const Text("Get Current Location"),
                ),

                SizedBox(height: h * 0.05),
                SizedBox(
                  height: h * 0.07,
                  width: w * 0.4,
                  child: ElevatedButton(
                    onPressed: canNext
                        ? () {
                      checkNextEligibility(context);
                      _updateDocument();
                      updateNextButton();
                    }
                        : null,
                    child: Text(
                      "Next",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          canNext ? Color(0xFFFC5448) : Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
