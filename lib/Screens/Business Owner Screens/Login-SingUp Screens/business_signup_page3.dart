import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:myapp/Models/businessOwner_model.dart';
import 'business_signup_page4.dart';

class BusinessOwnerPageThree extends StatefulWidget {
  const BusinessOwnerPageThree({Key? key,required this.businessOwnerId,required this.businessOwnerModel}) : super(key: key);
  final BusinessOwnerModel businessOwnerModel;
  final String businessOwnerId;

  @override
  _BusinessOwnerPageThreeState createState() => _BusinessOwnerPageThreeState();
}

class _BusinessOwnerPageThreeState extends State<BusinessOwnerPageThree> {
  late BusinessOwnerModel businessOwnerModel;
  List<String> selectedType = [];
  bool canNext = false;
  late String businessOwnerId='';

  @override
  void initState() {
    super.initState();
    businessOwnerId = widget.businessOwnerId;
    businessOwnerModel = widget.businessOwnerModel;
    // Update the document with additional data using businessOwnerId
    updateNextButton();
  }

  void _updateDocument() {
    if (businessOwnerId.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('Test')
          .doc(businessOwnerId)
          .update({
        'type': selectedType,
      })
          .then((value) {
        final businessOwnerData = BusinessOwnerModel(
          id: businessOwnerId,
          name:businessOwnerModel.name,
          email:businessOwnerModel.email,
          password:businessOwnerModel.password,
          phone:businessOwnerModel.phone,
          address: "",
          brands : businessOwnerModel.brands,
          documentURL: "",
          imageURL: "",
          isLoggedIn: false,
          isSignedOut: false,
          latitude: 0,
          longitude: 0,
          rate: 0,
          rejected: false,
          type: selectedType,
          verified: false,

        );
        //businessOwnerId = value.id;
        _updateBusinessOwnerModel(businessOwnerData);
      })
          .catchError((error) {
        print('Failed to update document: $error');
      });
    } else {
      print('Invalid businessOwnerId');
    }
  }

  void updateNextButton() {
    setState(() {
      canNext = selectedType .isNotEmpty;
    });
  }

  void goToBusinessOwnerPageFour() async {
    Get.to(() => BusinessOwnerPageFour(businessOwnerModel: businessOwnerModel,
        businessOwnerId:businessOwnerId));
  }

  void _updateBusinessOwnerModel(BusinessOwnerModel businessOwnerData) {
    setState(() {
      businessOwnerModel.type = businessOwnerData.type;
    });
  }

  void checkNextEligibility(BuildContext context) {
    // Validate MultiSelectFormField
    if (!isMultiSelectFormFieldValidType(selectedType)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Selecting an item is required for Types."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  updateNextButton();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Both options are selected, proceed to the next page
    goToBusinessOwnerPageFour();
  }

  bool isMultiSelectFormFieldValidType(List<String> selectedType) {
    // Check if an option is selected
    return selectedType.isNotEmpty;
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

                SizedBox(height: h * 0.03),
                Container(
                  height: h * 0.35,
                  width: w * 0.9,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(1, 1),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                  ),
                  child: FormField<List<String>>(
                    initialValue: selectedType,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      if (!isMultiSelectFormFieldValidType(value!)) {
                        return 'Selecting an item is required';
                      }
                      return null;
                    },
                    builder: (FormFieldState<List<String>> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          hintText: '',
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon:
                          Icon(Icons.menu, size: 20, color: Color(0xFFFC5448)),
                        ),
                        isEmpty: selectedType.isEmpty,
                        child: MultiSelectFormField(
                          title: Text('Type'),
                          dataSource: [
                            {'display': 'General automotive mechanic', 'value': 'General automotive mechanic'},
                            {'display': 'Brake and transmission technicians', 'value': 'Brake and transmission technicians'},
                            {'display': 'Diesel mechanic', 'value': 'Diesel mechanic'},
                            {'display': 'Auto body mechanics', 'value': 'Auto body mechanics'},
                            {'display': 'Auto glass mechanics', 'value': 'Auto glass mechanics'},
                            {'display': 'Service technicians', 'value': 'Service technicians'},
                            {'display': 'Electrical', 'value': 'Electrical'},
                            {'display': 'Tire mechanics', 'value': 'Tire mechanics'},
                            {'display': 'Winch service', 'value': 'Winch service'},
                          ],
                          textField: 'display',
                          valueField: 'value',
                          okButtonLabel: 'OK',
                          cancelButtonLabel: 'CANCEL',
                          onSaved: (value) {
                            setState(() {
                              selectedType = List<String>.from(value ?? []);

                            });
                            updateNextButton();
                            // Update the "Next" button eligibility
                          },
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: h * 0.1),
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
