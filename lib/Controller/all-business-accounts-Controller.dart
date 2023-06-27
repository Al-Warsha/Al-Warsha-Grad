
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../Models/businessOwner_model.dart';
import '../Repositories/businessOwner_repository.dart';

class AllBusinessOwnersPageController extends GetxController {
  final BusinessOwnerRepository _businessOwnerRepo = Get.put(BusinessOwnerRepository());
  CollectionReference businessOwnersCollection =
  FirebaseFirestore.instance.collection('BusinessOwners');
  final RxBool isLoading = true.obs;
  final RxList<BusinessOwnerModel> businessOwners = RxList<BusinessOwnerModel>([]);

  @override
  void onReady() {
    super.onReady();
    fetchAllBusinessOwners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBusinessOwnersStream() {
    return businessOwnersCollection.snapshots().map(
          (QuerySnapshot querySnapshot) => querySnapshot as QuerySnapshot<Map<String, dynamic>>,
    );
  }

  Future<void> fetchAllBusinessOwners() async {
    try {
      isLoading.value = true;
      List<BusinessOwnerModel> owners = await _businessOwnerRepo.getAllBusinessOwners();
      businessOwners.assignAll(owners);
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    } finally {
      isLoading.value = false;
    }
  }
}
