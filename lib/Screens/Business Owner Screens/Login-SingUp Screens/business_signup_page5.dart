import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/Models/businessOwner_model.dart';
import 'package:path/path.dart' as path;
import '../../../Controller/auth_controller.dart';
import 'business_pending_for_verification.dart';


class BusinessOwnerPageFive extends StatefulWidget {


  const BusinessOwnerPageFive({Key? key, required this.businessOwnerModel,required this.businessOwnerId}) : super(key: key);

  final BusinessOwnerModel businessOwnerModel;
  final String businessOwnerId;


  @override
  _BusinessOwnerPageFiveState createState() => _BusinessOwnerPageFiveState();
}

class _BusinessOwnerPageFiveState extends State<BusinessOwnerPageFive> {
  File? _image;
  final picker = ImagePicker();
  File? fileToDisplay;
  FilePickerResult? result;
  bool isLoading = false;
  String? fileName;
  PlatformFile? pickedfile;
  late String businessOwnerId;
  late BusinessOwnerModel businessOwnerModel;

  @override
  void initState() {
    super.initState();
    businessOwnerId = widget.businessOwnerId;
    businessOwnerModel = widget.businessOwnerModel;
  }




  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await picker.getImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
  Future<void> _pickDocument() async {
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null && result?.files != null && result!.files!.isNotEmpty) {
        setState(() {
          fileName = path.basename(result?.files!.first.path ?? '');
          pickedfile = result?.files!.first;
          fileToDisplay = File(pickedfile!.path!);
          print("File name $fileName");
        });
      }
    } catch (e) {
      print('Error picking document: $e');
    }
  }

  /*Future<void> performSignUp() async {
    AllBusinessOwnersPageController.instance.businessOwnerRegister(
      businessOwnerId,
      businessOwnerModel.name,
      businessOwnerModel.email,
      businessOwnerModel.password,
      businessOwnerModel.phone,
      businessOwnerModel.brands,
      businessOwnerModel.type,
      businessOwnerModel.address,
      businessOwnerModel.latitude,
      businessOwnerModel.longitude,
      _image as String,
      fileName!,
    ).then((_) {
      Get.off(() => BusinessOwnerPendingPage);
    });
  }*/

  Future<void> performSignUp() async {
    try {
      setState(() {
        isLoading = true;
      });

      final docRef = FirebaseFirestore.instance.collection('Test').doc(businessOwnerId);
      String imageDownloadURL = ""; // Variable to store the image download URL
      String documentFilePath = "";

      // Upload the profile image to Firebase Storage
      if (_image != null) {
        final profileImagePath = 'profile_images/${docRef.id}.jpg';
        final profileImageRef = FirebaseStorage.instance.ref().child(profileImagePath);
        final profileImageUploadTask = profileImageRef.putFile(_image!);
        final profileImageSnapshot = await profileImageUploadTask.whenComplete(() {});
        final profileImageDownloadURL = await profileImageSnapshot.ref.getDownloadURL();
        imageDownloadURL = profileImageDownloadURL; // Save the image download URL

        // Save the profile image download URL to Firestore
        await docRef.update({'profileImageUrl': imageDownloadURL});
      }

      // Upload the document to Firebase Storage
      if (pickedfile != null && pickedfile!.path != null && pickedfile!.path!.isNotEmpty) {
        final documentPath = 'documents/${docRef.id}.pdf';
        final documentRef = FirebaseStorage.instance.ref().child(documentPath);
        final documentUploadTask = documentRef.putFile(File(pickedfile!.path!));
        final documentSnapshot = await documentUploadTask.whenComplete(() {});
        final documentDownloadURL = await documentSnapshot.ref.getDownloadURL();
        documentFilePath = documentPath;

        // Save the document file path to Firestore
        await docRef.update({'documentUrl': documentFilePath});
      }

      AuthController.instance.businessOwnerRegister(
        businessOwnerId,
        businessOwnerModel.name,
        businessOwnerModel.email,
        businessOwnerModel.password,
        businessOwnerModel.phone,
        businessOwnerModel.brands,
        businessOwnerModel.type,
        businessOwnerModel.address,
        businessOwnerModel.latitude,
        businessOwnerModel.longitude,
        imageDownloadURL, // Pass the image download URL instead of the image file path
        documentFilePath,
      ).then((_) {
        Get.off(() => BusinessOwnerPendingPage());
      });

      // Check if the document was successfully created in Firestore
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        throw Exception('Error: Document was not created in Firestore');
      }

      setState(() {
        isLoading = false;
      });

      // Once the data is saved to Firestore, show the "Pending" page to the user.
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BusinessOwnerPendingPage(),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error during signup: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred during signup. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
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
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.05, h * 0.16, w * 0.05, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: h * 0.05),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _image != null
                              ? FileImage(_image!) as ImageProvider<Object>?
                              : AssetImage('assets/images/profile.jpg'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFFFC5448),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Choose an option"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: Icon(Icons.photo_library),
                                            title: Text("Choose from gallery"),
                                            onTap: () {
                                              _pickImage(ImageSource.gallery);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.camera_alt),
                                            title: Text("Take a picture"),
                                            onTap: () {
                                              _pickImage(ImageSource.camera);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.1),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w*0.2),
                    child: ElevatedButton(
                      onPressed: _pickDocument,
                      child: Text(
                        'Upload Document',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFC5448), // Set the background color of the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),


                  if (pickedfile != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Selected Document:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(fileName ?? 'No file selected'),
                        ],
                      ),
                    ),
                  SizedBox(height: h * 0.15),
                  Container(
                    width: w * 0.4,
                    height: h * 0.07,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w*0.2), // Adjust the margin as needed
                      child: ElevatedButton(
                        onPressed: performSignUp,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFC5448),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
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
      ),
    );
  }
}