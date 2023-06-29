import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:myapp/Models/notification_model.dart';
import 'package:myapp/Repositories/notification_repository.dart';

class NotificationsController extends GetxController {
  static NotificationsController get instance => Get.find();

  final NotificationRepository _notificationRepo = Get.put(NotificationRepository());

  final RxBool isLoading = true.obs;
  final RxList<NotificationModel> notifications = RxList<NotificationModel>([]);

  Future<void> fetchAllUserNotifications(String userId) async {
    try {
      isLoading.value = true;
      notifications.clear();

      final List<NotificationModel> userNotifications =
      await _notificationRepo.getAllNotificationsForUser(userId);

      notifications.addAll(userNotifications);
    } catch (e) {
      // Handle the error appropriately
      print('Error fetching user notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> deleteNotification(NotificationModel notification) async {
    try {
      isLoading.value = true;
      await _notificationRepo.deletenotification(notification);
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    } finally {
      isLoading.value = false;
    }
  }
}
