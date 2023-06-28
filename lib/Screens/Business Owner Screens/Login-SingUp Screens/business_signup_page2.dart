import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:myapp/Models/businessOwner_model.dart';
import 'business_signup_page3.dart';

class BusinessOwnerPageTwo extends StatefulWidget {
  const BusinessOwnerPageTwo({Key? key,required this.businessOwnerId,required this.businessOwnerModel}) : super(key: key);
  final BusinessOwnerModel businessOwnerModel;
  final String businessOwnerId;

  @override
  _BusinessOwnerPageTwoState createState() => _BusinessOwnerPageTwoState();
}

class _BusinessOwnerPageTwoState extends State<BusinessOwnerPageTwo> {
  late BusinessOwnerModel businessOwnerModel;
  List<String> selectedBrands = [];
  String? selectedType; // Add a default value
  List<String> types = [
    'General automotive mechanic',
    'Brake and transmission technicians',
    'Diesel mechanic',
    'Auto body mechanics',
    'Auto glass mechanics',
    'Service technicians',
    'Electrical',
    'Tire mechanics',
    'Winch service',
  ];

  bool canNext = false;

  /*@override
  void initState() {
    super.initState();
    selectedBrands = widget.businessOwnerModel.brands;
    selectedType = widget.businessOwnerModel.type;
    updateNextButton();
  }*/
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
        'brands': selectedBrands,
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
          brands : selectedBrands,
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
      canNext = selectedBrands.isNotEmpty && selectedType != null;
    });
  }

  void goToBusinessOwnerPageThree() async {
    Get.to(() => BusinessOwnerPageThree(businessOwnerModel: businessOwnerModel,
      businessOwnerId:businessOwnerId));
  }

  void _updateBusinessOwnerModel(BusinessOwnerModel businessOwnerData) {
    setState(() {
      businessOwnerModel.brands = businessOwnerData.brands;
      businessOwnerModel.type = businessOwnerData.type;

    });
  }

  void checkNextEligibility(BuildContext context) {
    // Validate MultiSelectFormField
    if (!isMultiSelectFormFieldValid(selectedBrands)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Selecting an item is required for Brands."),
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

    // Validate DropdownButtonFormField
    if (!isDropdownMenuItemValid(selectedType)) {
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
    goToBusinessOwnerPageThree();
  }

  bool isMultiSelectFormFieldValid(List<String> selectedBrands) {
    // Check if at least one option is selected
    return selectedBrands.isNotEmpty;
  }

  bool isDropdownMenuItemValid(String? selectedType) {
    // Check if an option is selected
    return selectedType != null && selectedType.isNotEmpty;
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
                SizedBox(height: h * 0.01),
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
                    initialValue: selectedBrands,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      if (!isMultiSelectFormFieldValid(value!)) {
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
                        isEmpty: selectedBrands.isEmpty,
                        child: MultiSelectFormField(
                          title: Text('Brands'),
                          dataSource: [
                            {'display': 'Nissan', 'value': 'Nissan'},
                            {'display': 'Suzuki', 'value': 'Suzuki'},
                            {'display': 'BMW', 'value': 'BMW'},
                            {'display': 'Mercedes', 'value': 'Mercedes'},
                            {'display': 'Fiat', 'value': 'Fiat'},
                            {'display': 'KIA', 'value': 'KIA'},
                            {'display': 'Toyota', 'value': 'Toyota'},
                            {'display': 'Jeep', 'value': 'Jeep'},
                            {'display': 'Opel', 'value': 'Opel'},
                          ],
                          textField: 'display',
                          valueField: 'value',
                          okButtonLabel: 'OK',
                          cancelButtonLabel: 'CANCEL',
                          onSaved: (value) {
                            setState(() {
                              selectedBrands = List<String>.from(value ?? []);

                            });
                            updateNextButton();
                            // Update the "Next" button eligibility
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: h * 0.02),
                Container(
                  height: h * 0.07,
                  width: w * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Builder(
                    builder: (context) {
                      List<DropdownMenuItem<String>> _dropdownItems() {
                        return [
                          DropdownMenuItem(
                            value: 'General',
                            child: Text('General automotive mechanic'),
                          ),
                          DropdownMenuItem(
                            value: 'Brake and transmission',
                            child: Text('Brake and transmission technicians'),
                          ),
                          DropdownMenuItem(
                            value: 'Diesel',
                            child: Text('Diesel mechanic'),
                          ),
                          DropdownMenuItem(
                            value: 'Auto body',
                            child: Text('Auto body mechanics'),
                          ),
                          DropdownMenuItem(
                            value: 'Auto glass',
                            child: Text('Auto glass mechanics'),
                          ),
                          DropdownMenuItem(
                            value: 'Service',
                            child: Text('Service technicians'),
                          ),
                          DropdownMenuItem(
                            value: 'Electric',
                            child: Text('Electrical'),
                          ),
                          DropdownMenuItem(
                            value: 'Tire',
                            child: Text('Tire mechanics'),
                          ),
                          DropdownMenuItem(
                            value: 'Winch',
                            child: Text('Winch service'),
                          ),
                        ];
                      }

                      String? _selectedValue = null;

                      // Validate the uniqueness of values
                      assert(Set.of(_dropdownItems().map((item) => item.value)).length == _dropdownItems().length);

                      return DropdownButtonFormField<String>(
                        value: _selectedValue,
                        items: _dropdownItems(),
                        onChanged: (value) {
                          setState(() {
                            selectedType = value; // Update the instance variable
                          });
                          updateNextButton();
                        },

                        decoration: InputDecoration(
                          hintText: 'Select a type',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),

                          ),
                          prefixIcon: Icon(Icons.menu, size: 20, color: Color(0xFFFC5448)),
                          prefixIconConstraints: BoxConstraints(minWidth: 27, minHeight: 40),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecting an item is required';
                          }
                          return null;
                        },
                      );
                    },
                  ),
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
