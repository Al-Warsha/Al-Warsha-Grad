import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Models/businessOwner_model.dart';
import '../Repositories/businessOwner_repository.dart';


class AllBusinessOwnersPageController extends GetxController {
  static AllBusinessOwnersPageController get instance => Get.find();

  final BusinessOwnerRepository _businessOwnerRepo = Get.put(BusinessOwnerRepository());

  final RxBool isLoading = true.obs;
  final RxList<BusinessOwnerModel> businessOwners = RxList<BusinessOwnerModel>([]);

  @override
  void onReady() {
    super.onReady();
    fetchAllBusinessOwners();
  }

  Future<void> fetchAllBusinessOwners() async {
    try {
      isLoading.value = true;
      List<BusinessOwnerModel> owners = await _businessOwnerRepo.getAllBusinessOwners();
      businessOwners.value = owners;
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    } finally {
      isLoading.value = false;
    }
  }



}