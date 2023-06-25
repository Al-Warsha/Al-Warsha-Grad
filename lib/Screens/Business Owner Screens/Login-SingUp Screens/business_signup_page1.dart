import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Models/businessOwner_model.dart';
import 'business_signup_page2.dart';

class BusinessOwnerPageOne extends StatefulWidget {
  const BusinessOwnerPageOne({Key? key}) : super(key: key);

  @override
  _BusinessOwnerPageOneState createState() => _BusinessOwnerPageOneState();
}

class _BusinessOwnerPageOneState extends State<BusinessOwnerPageOne> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isNextButtonEnabled = false;
  bool isPhoneNumberValid = false;
  late String businessOwnerId;

  String fullNameError = '';
  String emailError = '';
  String passwordError = '';
  String phoneNumberError = '';
  BusinessOwnerModel businessOwnerModel = BusinessOwnerModel(
    name: '', // Provide a default or empty value
    email: '', // Provide a default or empty value
    password: '', // Provide a default or empty value
    phone: '', // Provide a default or empty value
    address: "",
    brands : [],
    documentURL: "",
    imageURL: "",
    isLoggedIn: false,
    isSignedOut: false,
    latitude: 0,
    longitude: 0,
    rate: 0,
    rejected: false,
    type: "",
    verified: false,
    id: '',

  );

  void goToBusinessOwnerPageTwo(BusinessOwnerModel businessOwnerData, String businessOwnerId) {
    Get.to(() => BusinessOwnerPageTwo(businessOwnerModel: businessOwnerModel,
        businessOwnerId: businessOwnerData.id,));

  }


  void _saveDataToFirestore(BuildContext context) {
    String fullName = fullNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();

    // Validate full name
    if (!_isFullNameValid(fullName)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter a valid name."),
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

    // Validate email
    if (!_isEmailValid(email)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter a valid email address."),
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

    // Validate password
    if (!_isPasswordValid(password)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter a valid password (at least 6 characters)."),
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

    // Validate phone number
    if (!_isPhoneNumberValid(phoneNumber)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter a valid phone number (format: +20XXXXXXXXXX)."),
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

    // Generate a unique ID for the business owner




    // Save data to Firestore
    FirebaseFirestore.instance.collection('Test').add({
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    }).then((value) {
      // Data saved successfully
      final businessOwnerData = BusinessOwnerModel(
        id: value.id,
        email: email,
        name: fullName,
        password: password,
        phone: phoneNumber,
        address: "",
        brands : [],
        documentURL: "",
        imageURL: "",
        isLoggedIn: false,
        isSignedOut: false,
        latitude: 0,
        longitude: 0,
        rate: 0,
        rejected: false,
        type: "",
        verified: false,
      );
      businessOwnerId = value.id;
      print(value.id);
      _updateBusinessOwnerModel(businessOwnerData);

      goToBusinessOwnerPageTwo(businessOwnerData,value.id);
    })
        .catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("An error occurred while saving data to Firestore."),
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
    });
  }
  void _updateBusinessOwnerModel(BusinessOwnerModel businessOwnerData) {
    setState(() {
      businessOwnerModel.name = businessOwnerData.name;
      businessOwnerModel.email = businessOwnerData.email;
      businessOwnerModel.password = businessOwnerData.password;
      businessOwnerModel.phone = businessOwnerData.phone;
    });
  }

  bool _isFullNameValid(String fullName) {
    // Check if full name contains only letters
    final RegExp fullNameRegExp = RegExp(r'^[a-zA-Z ]+$');
    return fullNameRegExp.hasMatch(fullName);
  }

  bool _isEmailValid(String email) {
    // Use a simple email pattern matching
    final RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool _isPhoneNumberValid(String phoneNumber) {
    // Check if phone number starts with '+20' and has 12 digits
    final RegExp phoneNumberRegExp = RegExp(r'^\+20\d{10}$');
    return phoneNumberRegExp.hasMatch(phoneNumber);
  }

  void updateNextButtonState() {
    final bool isFullNameValid = _isFullNameValid(fullNameController.text.trim());
    final bool isEmailValid = _isEmailValid(emailController.text.trim());
    final bool isPasswordValid = _isPasswordValid(passwordController.text.trim());
    final bool isPhoneNumberValid = _isPhoneNumberValid(phoneNumberController.text.trim());

    setState(() {
      isNextButtonEnabled =
          isFullNameValid && isEmailValid && isPasswordValid && isPhoneNumberValid;
    });

    if (!isFullNameValid) {
      fullNameError = 'Please enter a valid full name.';
    } else {
      fullNameError = '';
    }

    if (!isEmailValid) {
      emailError = 'Please enter a valid email address.';
    } else {
      emailError = '';
    }

    if (!isPasswordValid) {
      passwordError = 'Please enter a valid password (at least 6 characters).';
    } else {
      passwordError = '';
    }

    if (!isPhoneNumberValid) {
      phoneNumberError = 'Please enter a valid phone number (format: +20XXXXXXXXXX).';
    } else {
      phoneNumberError = '';
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
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
                SizedBox(height: h * 0.04),
                Container(
                  width: w * 0.9,
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
                    controller: fullNameController,
                    onChanged: (value) {
                      businessOwnerModel.name = value.trim();
                      updateNextButtonState();
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Color(0xFFFC5448)),
                      hintText: "Name",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                Text(
                  fullNameError,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: h * 0.04),
                Container(
                  width: w * 0.9,
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
                    controller: emailController,
                    onChanged: (value) {
                      businessOwnerModel.email = value.trim();
                      updateNextButtonState();
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Color(0xFFFC5448)),
                      hintText: "Email",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                Text(
                  emailError,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: h * 0.04),
                Container(
                  width: w * 0.9,
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
                    controller: passwordController,
                    onChanged: (value) {
                      businessOwnerModel.password = value.trim();
                      updateNextButtonState();
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Color(0xFFFC5448)),
                      hintText: "Password",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                Text(
                  passwordError,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: h * 0.04),
                Container(
                  width: w * 0.9,
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
                    controller: phoneNumberController,
                    onChanged: (value) {
                      businessOwnerModel.phone = value.trim();
                      updateNextButtonState();
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone, color: Color(0xFFFC5448)),
                      hintText: "Phone Number",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                Text(
                  phoneNumberError,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: h * 0.05),
                GestureDetector(
                  onTap: isNextButtonEnabled ? () {
                    _saveDataToFirestore(context);
                    goToBusinessOwnerPageTwo(businessOwnerModel, businessOwnerId);
                  } : null,
                  child: Container(
                    width: w * 0.4,
                    height: h * 0.07,
                    decoration: BoxDecoration(
                      color: isNextButtonEnabled ? Color(0xFFFC5448) : Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
