import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarCenterDetailsPage extends StatelessWidget {
  final String carCenterId;
  final double deviceLatitude;
  final double deviceLongitude;

  CarCenterDetailsPage({
    required this.carCenterId,
    required this.deviceLatitude,
    required this.deviceLongitude,
  });

  double _calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    const int earthRadius = 6371; // Radius of the Earth in kilometers

    double lat1 = startLatitude * pi / 180;
    double lon1 = startLongitude * pi / 180;
    double lat2 = endLatitude * pi / 180;
    double lon2 = endLongitude * pi / 180;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distanceInKm = earthRadius * c;
    return distanceInKm;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('BusinessOwners')
          .doc(carCenterId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Car Center Details'),
            ),
            body: Center(
              child: Text('Error loading car center details'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Car Center Details'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Car Center Details'),
            ),
            body: Center(
              child: Text('Car center details not found'),
            ),
          );
        }

        DocumentSnapshot<Map<String, dynamic>> document = snapshot.data!;
        Map<String, dynamic> data = document.data()!;
        double latitude = data['latitude'];
        double longitude = data['longitude'];
        double distanceInKm = _calculateDistance(
          deviceLatitude,
          deviceLongitude,
          latitude,
          longitude,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text('Car Center Details'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${data['name']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Distance: ${distanceInKm.toStringAsFixed(2)} km',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Rating: ${data['rate']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Address: ${data['address']}',
                  style: TextStyle(fontSize: 16),
                ),
                // Add more details here based on your Firestore data structure
              ],
            ),
          ),
        );
      },
    );
  }
}
