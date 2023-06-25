import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../Models/businessOwner_model.dart';

class BusinessOwnerRepository extends GetxController {
  static BusinessOwnerRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<BusinessOwnerModel>> getAllBusinessOwners() async {
    final snapshot = await _db.collection("BusinessOwners").get();
    final businessOwnerData = snapshot.docs
        .map((e) => BusinessOwnerModel.fromSnapshot(
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
        .map((e) => BusinessOwnerModel.fromSnapshot(
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
}
