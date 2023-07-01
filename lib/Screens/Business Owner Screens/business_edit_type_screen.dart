import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import '../../Controller/auth_controller.dart';
import '../../Models/businessOwner_model.dart';
import '../../Repositories/businessOwner_repository.dart';
import 'business_profile_page3.dart';

class BusinessEditTypeScreen extends StatefulWidget {
  const BusinessEditTypeScreen({Key? key}) : super(key: key);

  @override
  _BusinessEditTypeScreenState createState() => _BusinessEditTypeScreenState();
}

class _BusinessEditTypeScreenState extends State<BusinessEditTypeScreen> {
  late BusinessOwnerModel businessOwnerModel;
  List<String> selectedTypes = [];
  final BusinessOwnerRepository _businessOwnerRepository = BusinessOwnerRepository();
  late String businessOwnerId = '';
  Set<String> existingTypes = {};

  @override
  void initState() {
    super.initState();
    fetchBusinessOwnerData();
  }

  Future<void> fetchBusinessOwnerData() async {
    try {
      String? userId = AuthController.instance.currentUserUid;
      if (userId != null) {
        BusinessOwnerModel owner = BusinessOwnerModel(
          id: userId,
          email: "",
          name: "",
          password: "",
          phone: "",
          type: [],
          brands: [],
          latitude: 0,
          longitude: 0,
          address: "",
          documentURL: "",
          imageURL: "",
          isLoggedIn: false,
          isSignedOut: false,
          rate: 0,
          rejected: false,
          verified: false,
        );
        Map<String, dynamic> businessOwnerData = await _businessOwnerRepository.getBusinessOwnerData(owner);
        List<String> currentTypes = List<String>.from(businessOwnerData['type']);
        setState(() {
          existingTypes = currentTypes.toSet();
        });
      }
    } catch (e) {
      print('Error fetching business owner data: $e');
    }
  }

  Future<void> updateBusinessOwnerData(Map<String, dynamic> newData) async {
    try {
      String? userId = AuthController.instance.currentUserUid;
      if (userId != null) {
        BusinessOwnerModel owner = BusinessOwnerModel(
          id: userId,
          email: "",
          name: "",
          password: "",
          phone: "",
          type: [],
          brands: [],
          latitude: 0,
          longitude: 0,
          address: "",
          documentURL: "",
          imageURL: "",
          isLoggedIn: false,
          isSignedOut: false,
          rate: 0,
          rejected: false,
          verified: false,
        );
        Map<String, dynamic> businessOwnerData = await _businessOwnerRepository.getBusinessOwnerData(owner);
        List<String> currentTypes = List<String>.from(businessOwnerData['type']);
        List<String> updatedTypes = List<String>.from(currentTypes)..addAll(newData['type']);
        newData['type'] = updatedTypes;
        await _businessOwnerRepository.updateBusinessOwnerData(owner, newData);
        print('Business owner data updated successfully');
        showSuccessAlert();
      }
    } catch (e) {
      print('Error updating business owner data: $e');
      showErrorAlert();
    }
  }


  void showSuccessAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Types added successfully.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showErrorAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update types.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BusinessProfileScreenThree()),
            );
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(
          'Edit Types',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  initialValue: selectedTypes,
                  autovalidateMode: AutovalidateMode.always,
                  builder: (FormFieldState<List<String>> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        hintText: '',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.menu, size: 20, color: Color(0xFFFC5448)),
                      ),
                      isEmpty: selectedTypes.isEmpty,
                      child: MultiSelectFormField(
                        title: Text('Types'),
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
                            selectedTypes = List<String>.from(value ?? []);
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select at least one brand.';
                          }
                          return null;
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: h * 0.01),
              GestureDetector(
                onTap: () {
                  if (selectedTypes.isNotEmpty) {
                    List<String> newTypes = [];
                    for (String type in selectedTypes) {
                      if (existingTypes.contains(type)) {
                        showBrandExistsAlert(type);
                        return;
                      }
                      newTypes.add(type);
                    }
                    Map<String, dynamic> newData = {'type': newTypes};
                    updateBusinessOwnerData(newData);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.25),
                  child: Container(
                    width: w * 0.4,
                    height: h * 0.06,
                    decoration: BoxDecoration(
                      color: Color(0xFFFC5448),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showBrandExistsAlert(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('type Exists'),
          content: Text('The type "$type" already exists.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
