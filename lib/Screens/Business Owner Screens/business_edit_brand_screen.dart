import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import '../../Controller/auth_controller.dart';
import '../../Models/businessOwner_model.dart';
import '../../Repositories/businessOwner_repository.dart';
import 'business_profile_page2.dart';

class BusinessEditBrandScreen extends StatefulWidget {
  const BusinessEditBrandScreen({Key? key}) : super(key: key);

  @override
  _BusinessEditBrandScreenState createState() => _BusinessEditBrandScreenState();
}

class _BusinessEditBrandScreenState extends State<BusinessEditBrandScreen> {
  late BusinessOwnerModel businessOwnerModel;
  List<String> selectedBrands = [];
  final BusinessOwnerRepository _businessOwnerRepository = BusinessOwnerRepository();
  late String businessOwnerId = '';
  Set<String> existingBrands = {};

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
        List<String> currentBrands = List<String>.from(businessOwnerData['brands']);
        setState(() {
          existingBrands = currentBrands.toSet();
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
        List<String> currentBrands = List<String>.from(businessOwnerData['brands']);
        List<String> updatedBrands = List<String>.from(currentBrands)..addAll(newData['brands']);
        newData['brands'] = updatedBrands;
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
          content: Text('Brands added successfully.'),
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
          content: Text('Failed to update brands.'),
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
              MaterialPageRoute(builder: (context) => BusinessProfileScreenTwo()),
            );
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(
          'Edit Brands',
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
                  initialValue: selectedBrands,
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
                      isEmpty: selectedBrands.isEmpty,
                      child: ListView(
                        children:[ MultiSelectFormField(
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
                          {'display': 'Audi', 'value': 'Audi'},
                          {'display': 'Mazda', 'value': 'Mazda'},
                          {'display': 'Ford', 'value': 'Ford'},
                          {'display': 'Seat', 'value': 'Seat'},
                          {'display': 'Hyundai', 'value': 'Hyundai'},
                        ],
                        textField: 'display',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'CANCEL',
                        onSaved: (value) {
                          setState(() {
                            selectedBrands = List<String>.from(value ?? []);
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select at least one brand.';
                          }
                          return null;
                        },
                      ),],
                    ),
                    );
                  },
                ),
              ),
              SizedBox(height: h * 0.01),
              GestureDetector(
                onTap: () {
                  if (selectedBrands.isNotEmpty) {
                    List<String> newBrands = [];
                    for (String brand in selectedBrands) {
                      if (existingBrands.contains(brand)) {
                        showBrandExistsAlert(brand);
                        return;
                      }
                      newBrands.add(brand);
                    }
                    Map<String, dynamic> newData = {'brands': newBrands};
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

  void showBrandExistsAlert(String brand) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Brand Exists'),
          content: Text('The brand "$brand" already exists.'),
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
