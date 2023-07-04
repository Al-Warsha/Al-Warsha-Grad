import 'dart:async';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class NotificationService2 {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _emergencySubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _scheduleSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _winchSubscription;

  Future<void> initializeNotifications2() async {
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
    initializeNotifications2();
    _emergencySubscription = FirebaseFirestore.instance
        .collection('emergencyAppointment')
        .where('mechanicid', isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((DocumentChange change) async {
        final request = change.doc.data() as Map<String, dynamic>;
        final state = request['state'];
        final businessNotificationSent = request['Bnotification_sent'];
        final requesterId = request['userid'];
        final requestId = change.doc.id;

        if ((change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) &&
            (state == 'pending') &&
            businessNotificationSent == 0) {

          // Fetch the business owner document
          final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(requesterId).get();

          if (userSnapshot.exists) {
            final userData = userSnapshot.data() as Map<String, dynamic>;
            final userName = userData['fullName'];

            // Send a notification to the user with the business owner name
            await sendNotification2(userId, "Pending", userName, 'Emergency request', requestId);
            // Update the 'notification_sent' field to indicate that the notification has been sent
            change.doc.reference.update({'Bnotification_sent': 1});

          }
        }
      });
    });

    _scheduleSubscription = FirebaseFirestore.instance
        .collection('scheduleAppointment')
        .where('mechanicid', isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((DocumentChange change) async {
        final request = change.doc.data() as Map<String, dynamic>;
        final state = request['state'];
        final businessNotificationSent = request['Bnotification_sent'];
        final requesterId = request['userid'];
        final requestId = change.doc.id;

        if ((change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) &&
            (state == 'pending') &&
            businessNotificationSent == 0) {

          // Fetch the business owner document
          final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(requesterId).get();

          if (userSnapshot.exists) {
            final userData = userSnapshot.data() as Map<String, dynamic>;
            final userName = userData['fullName'];

            // Send a notification to the user with the business owner name
            await sendNotification2(userId, "Pending", userName, 'Scheduling request', requestId);
            // Update the 'Bnotification_sent' field to indicate that the notification has been sent
            change.doc.reference.update({'Bnotification_sent': 1});

          }
        }
      });
    });

    _winchSubscription = FirebaseFirestore.instance
        .collection('winchAppointment')
        .where('mechanicid', isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((DocumentChange change) async {
        final request = change.doc.data() as Map<String, dynamic>;
        final state = request['state'];
        final businessNotificationSent = request['Bnotification_sent'];
        final requesterId = request['userid'];
        final requestId = change.doc.id;

        if ((change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) &&
            (state == 'pending') &&
            businessNotificationSent == 0) {

          // Fetch the business owner document
          final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(requesterId).get();

          if (userSnapshot.exists) {
            final userData = userSnapshot.data() as Map<String, dynamic>;
            final userName = userData['fullName'];

            // Send a notification to the user with the business owner name
            await  sendNotification2(userId, "Pending", userName, 'Winch request', requestId);
            // Update the 'Bnotification_sent' field to indicate that the notification has been sent
            change.doc.reference.update({'Bnotification_sent': 1});

          }
        }
      });
    });
  }

  Future<void> sendNotification2(
      String userId, String state, String name, String type, String requestId) async {
    String notificationTitle = 'You have a new pending request!';
    String notificationBody = 'A $type from $name is pending.';

    final notificationRef = FirebaseFirestore.instance.collection('Notifications');

    final DateTime currentDateTime = DateTime.now();
    final String formattedDateTime =
    DateFormat('MMM dd, yyyy - hh:mm a').format(currentDateTime);

    final newNotification = await notificationRef.add({
      'userId': userId,
      'type': type,
      'timestamp': formattedDateTime,
      'title': notificationTitle,
      'body': notificationBody,
      'requestId': requestId
    });

    if (newNotification != null) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: notificationTitle,
          body: notificationBody,
        ),
      );
    }
  }

  void destroyNotifications() {
    _emergencySubscription?.cancel();
    _scheduleSubscription?.cancel();
    _winchSubscription?.cancel();
  }
}
