import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myapp/Models/businessOwner_model.dart';
import '../../Controller/auth_controller.dart';
import '../../Repositories/businessOwner_repository.dart';
import 'BottomNavigationBar-BusinessOwner.dart';
import 'business_profile_page2.dart';


class BusinessProfileScreenOne extends StatefulWidget {
  const BusinessProfileScreenOne({Key? key}) : super(key: key);

  @override
  _BusinessProfileScreenOneState createState() => _BusinessProfileScreenOneState();
}

class _BusinessProfileScreenOneState extends State<BusinessProfileScreenOne> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final BusinessOwnerRepository _businessOwnerRepository = BusinessOwnerRepository();
  File? _image;


  @override
  void initState() {
    super.initState();
    fetchBusinessOwnerData();

  }

  Future<void> fetchBusinessOwnerData() async {
    try {
      String? userId = AuthController.instance.currentUserUid;
      if (userId != null) {
        BusinessOwnerModel owner = BusinessOwnerModel(id: userId,
          email: "",
          name: "",
          password:"",
          phone:"",
          type: [],
          brands:[],
          latitude: 0,
          longitude: 0,
          address: "",
          documentURL: "",
          imageURL: "",
          isLoggedIn:false,
          isSignedOut: false,
          rate: 0,
          rejected: false,
          verified: false,
        );
        Map<String, dynamic> businessOwnerData =
        await _businessOwnerRepository.getBusinessOwnerData(owner);
        // Update the text controllers with the fetched data
        _fullNameController.text = businessOwnerData['name'] ?? '';
        _emailController.text = businessOwnerData['email'] ?? '';
        _phoneNumberController.text = businessOwnerData['phone'] ?? '';
        _addressController.text = businessOwnerData['address'] ?? '';
        // Load the image if imageURL is available
        if (owner.imageURL.isNotEmpty) {
          File? image =
          await _businessOwnerRepository.getImageFromFirebase(owner.imageURL);
          if (image != null) {
            setState(() {
              _image = image;
            });
          }
        }

      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> updateUserProfile() async {
    try {
      String? userId = AuthController.instance.currentUserUid;
      if (userId != null) {
        String newPhone = _phoneNumberController.text;
        await _businessOwnerRepository.updateBusinessOwnerDataPhone(userId, newPhone);
        // Show a success message or navigate to another screen
      }
    } catch (e) {
      print('Error updating user data: $e');
      // Show an error message
    }
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
              MaterialPageRoute(builder: (context) => BottomNavigationBarBusinessOwner()),
            );
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: h * 0.021),
              Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _image != null
                          ? FileImage(_image!) as ImageProvider<Object>?
                          : AssetImage('assets/images/profile.jpg') as ImageProvider<Object>?,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,


                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: w * 0.7,
                height: h * 0.07,
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
                child: TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Color(0xFFFC5448)),
                    hintText: "Name",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16), // Adjust the padding value as needed
                  ),
                ),
              ),
              SizedBox(height: h * 0.04),
              Container(
                width: w * 0.7,
                height: h * 0.07,
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
                child: Center(
                  child: TextField(
                    controller: _emailController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Color(0xFFFC5448)),
                      hintText: "Email",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.04),
              Container(
                width: w * 0.7,
                height: h * 0.07,
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
                child: Center(
                  child: TextField(
                    controller: _phoneNumberController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone, color: Color(0xFFFC5448)),
                      hintText: "Phone Number",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.04),
              Container(
                width: w * 0.7,
                height: h * 0.07,
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
                child: Center(
                  child: TextField(
                    controller: _addressController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on, color: Color(0xFFFC5448)),
                      hintText: "Address",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.01),
              GestureDetector(
                onTap: () {
                  updateUserProfile();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.25),  // Add horizontal margin
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
              SizedBox(height: h * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.25),  // Add horizontal margin
                child: Container(
                  width: w * 0.4,
                  height: h * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => BusinessProfileScreenTwo());
                    },
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFC5448)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}