import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../Models/businessOwner_model.dart';
import '../Repositories/businessOwner_repository.dart';




class AdminMechanicDetailsController extends GetxController {
  static AdminMechanicDetailsController get instance => Get.find();

  final BusinessOwnerRepository _businessOwnerRepo = Get.put(BusinessOwnerRepository());

  final RxBool isLoading = true.obs;


  Future<BusinessOwnerModel?> fetchBusinessOwnerDetails(String? id) async {
    try {
      isLoading.value = true;
      BusinessOwnerModel? owner = await _businessOwnerRepo.getBusinessOwnerDetails(id);
      return owner;
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBusinessOwner(BusinessOwnerModel owner, {bool isVerification = true}) async {
    try {
      isLoading.value = true;

      if (isVerification) {
        await _businessOwnerRepo.updateBusinessOwnerVerification(owner);
      } else {
        await _businessOwnerRepo.updateBusinessOwnerRejection(owner);
      }

      // Optional: Perform any additional tasks after updating the details
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

}