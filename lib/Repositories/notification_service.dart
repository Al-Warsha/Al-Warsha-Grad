import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/Controller/auth_controller.dart';

class NotificationService {
  final AuthController _authController = AuthController();
  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> get notifications => _notifications;

  Future<void> initializeNotifications() async {
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

  void listenForRequestChanges(String userId) {
    initializeNotifications(); // Add this line to initialize the notification service

    FirebaseFirestore.instance
        .collection('emergencyAppointment')
        .where('userid', isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((DocumentChange change) async {
        final request = change.doc.data() as Map<String, dynamic>;
        final state = request['state'];
        final notificationSent = request['notification_sent'];
        final mechanicId = request['mechanicid'];
        final requestId = change.doc.id;


        if ((change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) &&
            (state == 'accepted' || state == 'rejected') &&
            notificationSent == 0) {
          // Update the 'notification_sent' field to indicate that the notification has been sent
          change.doc.reference.update({'notification_sent': 1});

          // Fetch the business owner document
          final mechanicSnapshot =
          await FirebaseFirestore.instance.collection('BusinessOwners').doc(mechanicId).get();

          if (mechanicSnapshot.exists) {
            final mechanicData = mechanicSnapshot.data() as Map<String, dynamic>;
            final mechanicName = mechanicData['name'];

            // Send a notification to the user with the business owner name
            sendNotification(userId,state, mechanicName, 'Emergency request',requestId);
          }
        }
      });
    });


    FirebaseFirestore.instance
        .collection('scheduleAppointment')
        .where('userid', isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((DocumentChange change) async {
        final request = change.doc.data() as Map<String, dynamic>;
        final state = request['state'];
        final notificationSent = request['notification_sent'];
        final mechanicId = request['mechanicid'];
        final requestId = change.doc.id;

        if ((change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) &&
            (state == 'accepted' || state == 'rejected') &&
            notificationSent == 0) {
          // Update the 'notification_sent' field to indicate that the notification has been sent
          change.doc.reference.update({'notification_sent': 1});

          // Fetch the business owner document
          final mechanicSnapshot =
              await FirebaseFirestore.instance.collection('BusinessOwners').doc(mechanicId).get();

          if (mechanicSnapshot.exists) {
            final mechanicData = mechanicSnapshot.data() as Map<String, dynamic>;
            final mechanicName = mechanicData['name'];

            // Send a notification to the user with the business owner name
            sendNotification(userId,state, mechanicName, 'Scheduling request',requestId);
          }
        }
      });
    });

    FirebaseFirestore.instance
        .collection('winchAppointment')
        .where('userid', isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((DocumentChange change) async {
        final request = change.doc.data() as Map<String, dynamic>;
        final state = request['state'];
        final notificationSent = request['notification_sent'];
        final mechanicId = request['mechanicid'];
        final requestId = change.doc.id;

        if ((change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) &&
            (state == 'accepted' || state == 'rejected') &&
            notificationSent == 0) {
          // Update the 'notification_sent' field to indicate that the notification has been sent
          change.doc.reference.update({'notification_sent': 1});


          // Fetch the business owner document
          final mechanicSnapshot =
              await FirebaseFirestore.instance.collection('BusinessOwners').doc(mechanicId).get();

          if (mechanicSnapshot.exists) {
            final mechanicData = mechanicSnapshot.data() as Map<String, dynamic>;
            final mechanicName = mechanicData['name'];

            // Send a notification to the user with the business owner name
            sendNotification(userId,state, mechanicName, 'Winch request',requestId);
          }
        }
      });
    });
  }

  void sendNotification(
      String userId, String state, String businessOwnerName, String type,String requestId) async {
    String notificationTitle;
    String notificationBody;

    if (state == 'accepted') {
      notificationTitle = 'Service Request Accepted';
      notificationBody = 'Your $type from $businessOwnerName has been accepted.';
    } else if (state == 'rejected') {
      notificationTitle = 'Service Request Rejected';
      notificationBody = 'Your $type from $businessOwnerName has been rejected.';
    } else {
      return;
    }

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
      'requestId':requestId
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

}
