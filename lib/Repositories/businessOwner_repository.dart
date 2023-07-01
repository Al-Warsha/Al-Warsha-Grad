import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/businessOwner_model.dart';
import 'package:http/http.dart' as http;


class BusinessOwnerRepository extends GetxController {
  static BusinessOwnerRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<BusinessOwnerModel>> getAllBusinessOwners() async {
    final snapshot = await _db.collection("BusinessOwners").get();
    final businessOwnerData = snapshot.docs
        .map((e) =>
        BusinessOwnerModel.fromSnapshot(
          e,


        ))
        .toList();
    return businessOwnerData.cast<BusinessOwnerModel>();
  }

  Future<List<BusinessOwnerModel>> getAllUnverifiedBusinessOwners() async {
    final snapshot = await _db
        .collection("BusinessOwners")
        .where("verified", isEqualTo: false)
        .where("rejected", isEqualTo: false)
        .get();
    final businessOwnerData = snapshot.docs
        .map((e) =>
        BusinessOwnerModel.fromSnapshot(
          e,


        ))
        .toList();
    return businessOwnerData.cast<BusinessOwnerModel>();
  }

  Future<BusinessOwnerModel?> getBusinessOwnerDetails(String? id) async {
    final snapshot = await _db.collection("BusinessOwners").doc(id).get();
    final businessOwnerData = BusinessOwnerModel.fromSnapshot(snapshot);
    return businessOwnerData;
  }

  Future<void> updateBusinessOwnerVerification(BusinessOwnerModel owner) async {
    try {
      final docRef = _db.collection("BusinessOwners").doc(owner.id);

      // Update only the 'verified' field with the new value
      await docRef.update({'verified': owner.verified});
    } catch (error) {
      print("Error updating business owner verification: $error");
      // Handle the error accordingly
    }
  }

  Future<void> updateBusinessOwnerRejection(BusinessOwnerModel owner) async {
    try {
      final docRef = _db.collection("BusinessOwners").doc(owner.id);

      // Update only the 'rejected' field with the new value
      await docRef.update({'rejected': owner.rejected});
    } catch (error) {
      print("Error updating business owner rejection: $error");
      // Handle the error accordingly
    }
  }

  Future<void> deleteBusinessOwner(BusinessOwnerModel owner) async {
    try {
      final ownerRef = _db.collection("BusinessOwners").doc(owner.id);
      await ownerRef.delete();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      // Handle the error as per your requirement (show error message, log, etc.)
      throw error;
    }
  }

  Future<Map<String, dynamic>> getBusinessOwnerData(
      BusinessOwnerModel owner) async {
    try {
      DocumentSnapshot snapshot =
      await _db.collection("BusinessOwners").doc(owner.id).get();
      return snapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching Business owner data: $e');
      return {};
    }
  }


  Future<void> updateBusinessOwnerData(BusinessOwnerModel owner, Map<String, dynamic> newData) async {
    try {
      final ownerUpdate = _db.collection("BusinessOwners").doc(owner.id);
      await ownerUpdate.update(newData);
      print('Business owner data updated successfully');
    } catch (e) {
      print('Error updating Business owner data: $e');
    }
  }


  Future<void> updateBusinessOwnerDataPhone(String ownerId, String newPhone) async {
    try {
      final ownerUpdate = _db.collection("BusinessOwners").doc(ownerId);
      await ownerUpdate.update({'phone': newPhone});
      print('Business owner phone number updated successfully');
    } catch (e) {
      print('Error updating Business owner phone number: $e');
    }
  }


  Future<File?> getImageFromFirebase(String imagePath) async {
    try {
      // Reference to the Firebase Storage bucket where the images are stored
      var storageRef = firebase_storage.FirebaseStorage.instance.ref();

      // Get the image download URL using the provided image path
      var downloadURL = await storageRef.child(imagePath).getDownloadURL();

      // Use the download URL to fetch the image
      var response = await http.get(Uri.parse(downloadURL));

      // Create a temporary file to store the image
      var tempDir = await getTemporaryDirectory();
      File tempFile = File('${tempDir.path}/tempImage.jpg');

      // Write the image data to the temporary file
      await tempFile.writeAsBytes(response.bodyBytes);

      return tempFile;
    } catch (e) {
      print('Error fetching image from Firebase Storage: $e');
      return null;
    }
  }

}

