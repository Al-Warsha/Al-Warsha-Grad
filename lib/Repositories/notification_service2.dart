import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/Controller/auth_controller.dart';

class NotificationService2 {
  final AuthController _authController = AuthController();
  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> get notifications => _notifications;

  Future<void> initializeNotifications2(String userId) async {
    listenForRequestChanges2(userId);
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    await createNotificationChannel();
  }
  Future<void> createNotificationChannel() async {
    NotificationChannel channel = NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Channel',
      channelDescription: 'Channel for basic notifications',
      importance: NotificationImportance.Default,
      defaultColor: const Color(0xFFF43C36),
      ledColor: Colors.white,
      playSound: true,
      enableVibration: true,
    );

    AwesomeNotifications().setChannel(channel);
  }


  void listenForRequestChanges2(String userId) {
    FirebaseFirestore.instance
        .collection('emergencyAppointment')
        .where('mechanicid', isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((DocumentChange change) async {
        final request = change.doc.data() as Map<String, dynamic>;
        final state = request['state'];
        final Business_notificationSent = request['Bnotification_sent'];
        final requesterId = request['userid'];
        final requestId = change.doc.id;

        if ((change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) &&
            (state == 'pending') &&
            Business_notificationSent== 0) {
          // Update the 'notification_sent' field to indicate that the notification has been sent
          change.doc.reference.update({'Bnotification_sent': 1});

          // Fetch the business owner document
          final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(requesterId).get();

          if (userSnapshot.exists) {
            final userData = userSnapshot.data() as Map<String, dynamic>;
            final userName = userData['fullName'];

            // Send a notification to the user with the business owner name
            sendNotification2(userId,"Pending", userName, 'Emergency request',requestId);
          }
        }
      });
    });

    FirebaseFirestore.instance
        .collection('scheduleAppointment')
        .where('mechanicid', isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((DocumentChange change) async {
        final request = change.doc.data() as Map<String, dynamic>;
        final state = request['state'];
        final Business_notificationSent = request['Bnotification_sent'];
        final requesterId = request['userid'];
        final requestId = change.doc.id;

        if ((change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) &&
            (state == 'pending') &&
            Business_notificationSent== 0) {
          // Update the 'Bnotification_sent' field to indicate that the notification has been sent
          change.doc.reference.update({'Bnotification_sent': 1});

          // Fetch the business owner document
          final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(requesterId).get();

          if (userSnapshot.exists) {
            final userData = userSnapshot.data() as Map<String, dynamic>;
            final userName = userData['fullName'];

            // Send a notification to the user with the business owner name
            sendNotification2(userId,"Pending", userName, 'Scheduling request',requestId);
          }
        }
      });
    });

    FirebaseFirestore.instance
        .collection('winchAppointment')
        .where('mechanicid', isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((DocumentChange change) async {
        final request = change.doc.data() as Map<String, dynamic>;
        final state = request['state'];
        final Business_notificationSent = request['Bnotification_sent'];
        final requesterId = request['userid'];
        final requestId = change.doc.id;

        if ((change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) &&
            (state == 'pending') &&
            Business_notificationSent== 0) {
          // Update the 'Bnotification_sent' field to indicate that the notification has been sent
          change.doc.reference.update({'Bnotification_sent': 1});

          // Fetch the business owner document
          final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(requesterId).get();

          if (userSnapshot.exists) {
            final userData = userSnapshot.data() as Map<String, dynamic>;
            final userName = userData['fullName'];

            // Send a notification to the user with the business owner name
            sendNotification2(userId,"Pending", userName,'Winch request',requestId);
          }
        }
      });
    });
  }

  void sendNotification2(
      String userId, String state, String Name, String notificationType, String requestId) async {
    String notificationTitle;
    String notificationBody;

    notificationTitle = 'You have a new pending request!';
    notificationBody = 'A $notificationType from $Name is pending.';

    final notificationRef = FirebaseFirestore.instance.collection('Notifications');

    final DateTime currentDateTime = DateTime.now();
    final String formattedDateTime =
    DateFormat('MMM dd, yyyy - hh:mm a').format(currentDateTime);

    // Check if a notification with the same type and request ID already exists
    final existingNotificationSnapshot = await notificationRef
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: notificationType)
        .where('requestId', isEqualTo: requestId)
        .get();

    if (existingNotificationSnapshot.docs.isEmpty) {
      final newNotification = await notificationRef.add({
        'userId': userId,
        'type': notificationType,
        'timestamp': formattedDateTime,
        'title': notificationTitle,
        'body': notificationBody,
        'requestId': requestId
      });

      if (newNotification != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: newNotification.id.hashCode,
            channelKey: 'basic_channel',
            title: notificationTitle,
            body: notificationBody,
          ),
        );
      }
    }
  }
}
