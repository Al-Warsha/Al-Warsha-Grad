import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/auth_controller.dart';
import '../../Models/businessOwner_model.dart';
import '../../Repositories/businessOwner_repository.dart';
import 'business_edit_type_screen.dart';
import 'business_profile_page2.dart';


class BusinessProfileScreenThree extends StatefulWidget {
  const BusinessProfileScreenThree({Key? key}) : super(key: key);

  @override
  _BusinessProfileScreenThreeState createState() => _BusinessProfileScreenThreeState();
}

class _BusinessProfileScreenThreeState extends State<BusinessProfileScreenThree> {
  final BusinessOwnerRepository _businessOwnerRepository = BusinessOwnerRepository();
  List<String> types = []; // List to store the brands retrieved from Firestore

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
        Map<String, dynamic> businessOwnerData =
        await _businessOwnerRepository.getBusinessOwnerData(owner);
        setState(() {
          types = List<String>.from(businessOwnerData['type']);
        });
      }
    } catch (e) {
      print('Error fetching business owner data: $e');
    }
  }
  Future<void> deleteType(String type) async {
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

        // Get the business owner data from Firestore
        Map<String, dynamic> businessOwnerData =
        await _businessOwnerRepository.getBusinessOwnerData(owner);

        // Get the current brands list
        List<String> currentTypes = List<String>.from(businessOwnerData['type']);

        // Remove the brand from the list
        currentTypes.remove(type);

        // Update the brands list in the Firestore document
        businessOwnerData['type'] = currentTypes;
        await _businessOwnerRepository.updateBusinessOwnerData(owner , businessOwnerData);

        // Update the UI with the new brands list
        setState(() {
          types = currentTypes;
        });
      }
    } catch (e) {
      print('Error deleting brand: $e');
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
              MaterialPageRoute(builder: (context) => BusinessProfileScreenTwo()),
            );
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(
          'List of Types',
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
              SizedBox(height: h * 0.02),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: types.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.ballot,
                      color: Color(0xFFFC5448),
                    ),
                    title: Text(types[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Color(0xFFFC5448)),
                      onPressed: () {
                        deleteType(types[index]);
                      },
                    ),
                  );
                },
              ),

              SizedBox(height: h * 0.2),
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
                      Get.to(() => BusinessEditTypeScreen());
                    },
                    child: Center(
                      child: Text(
                        "Edit",
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
            ],
          ),
        ),
      ),
    );
  }
}
