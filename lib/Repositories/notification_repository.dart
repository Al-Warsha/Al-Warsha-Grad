import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Models/notification_model.dart';

class NotificationRepository extends GetxController {
  static NotificationRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<NotificationModel>> getAllNotificationsForUser(String userId) async {
    try {
      final querySnapshot = await _db
          .collection('Notifications')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => NotificationModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      // Handle the error appropriately
      throw Exception('Failed to get notifications: $e');
    }
  }
}
