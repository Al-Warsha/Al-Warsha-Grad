import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/auth_controller.dart';
import '../../Models/businessOwner_model.dart';
import '../../Repositories/businessOwner_repository.dart';
import 'BottomNavigationBar-BusinessOwner.dart';
import 'business_edit_brand_screen.dart';
import 'business_profile_page3.dart';

class BusinessProfileScreenTwo extends StatefulWidget {
  const BusinessProfileScreenTwo({Key? key}) : super(key: key);

  @override
  _BusinessProfileScreenTwoState createState() => _BusinessProfileScreenTwoState();
}

class _BusinessProfileScreenTwoState extends State<BusinessProfileScreenTwo> {
  final BusinessOwnerRepository _businessOwnerRepository = BusinessOwnerRepository();
  List<String> brands = []; // List to store the brands retrieved from Firestore
  bool isLoading = true; // Flag to track loading state

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
          brands = List<String>.from(businessOwnerData['brands']);
          isLoading = false; // Data fetching completed
        });
      }
    } catch (e) {
      print('Error fetching business owner data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> deleteBrand(String brand) async {
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
        List<String> currentBrands = List<String>.from(businessOwnerData['brands']);

        // Remove the brand from the list
        currentBrands.remove(brand);

        // Update the brands list in the Firestore document
        businessOwnerData['brands'] = currentBrands;
        await _businessOwnerRepository.updateBusinessOwnerData(owner , businessOwnerData);

        // Update the UI with the new brands list
        setState(() {
          brands = currentBrands;
        });
      }
    } catch (e) {
      print('Error deleting brand: $e');
      Get.snackbar(
        'Error',
        'Unable to delete brand. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
              MaterialPageRoute(builder: (context) =>BottomNavigationBarBusinessOwner()),
            );
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(
          'List of Brands',
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
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFC5448),
                  ),
                )
              else
                ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.ballot,
                      color: Color(0xFFFC5448),
                    ),
                    title: Text(brands[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Color(0xFFFC5448)),
                      onPressed: () {
                        deleteBrand(brands[index]);
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: h * 0.3),
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
                      Get.to(() => BusinessProfileScreenThree());
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
              SizedBox(height: h * 0.01),
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
                      Get.to(() => BusinessEditBrandScreen());
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
