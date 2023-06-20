import '../Models/businessOwner_model.dart';
import 'package:get/get.dart';
import '../Models/user_model.dart';
import '../Shared/network/local/firebase_utils.dart';

class viewMechanicsForAppointmentController extends GetxController{
  final RxBool isLoading = true.obs;
  final RxList<BusinessOwnerModel> businessOwners = RxList<BusinessOwnerModel>([]);

  @override
  void onReady() {
    super.onReady();
    fetchBusinessOwners();
  }

  Future<void> fetchBusinessOwners() async {
    try {
      isLoading.value = false;
      List<BusinessOwnerModel> owners = await getAllBusinessOwners();
      businessOwners.value = owners;
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    } finally {
      isLoading.value = true;
    }
  }
  Future<BusinessOwnerModel?> fetchBusinessOwnerDetails(String? id) async {
    try {
      isLoading.value = true;
      BusinessOwnerModel? owner = await getBusinessOwnerDetails(id);
      return owner;
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      return null;
    } finally {
      isLoading.value = false;
    }
  }


}