import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'BottomNavigationBarExample.dart';
import 'MechanicDetails.dart';


class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedFilter = 'All';
  String _selectedBrand = 'All Brands';
  List<DocumentSnapshot<Map<String, dynamic>>> _searchResults = [];
  double deviceLatitude = 0.0;
  double deviceLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        deviceLatitude = position.latitude;
        deviceLongitude = position.longitude;
      });
    } catch (error) {
      print('Error getting current position: $error');
    }
  }

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

  void _searchCarRepairCenters(String searchText, String name) {
    String start = searchText;
    String end = searchText + '\uf8ff';

    Query<Map<String, dynamic>> query = _firestore.collection('BusinessOwners');

    query.get().then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      List<DocumentSnapshot<Map<String, dynamic>>> allResults = snapshot.docs;

      List<DocumentSnapshot<Map<String, dynamic>>> filteredResults = [];

      for (var doc in allResults) {
        String centerName = doc.data()?['name'] ?? '';
        bool verified = doc.data()?['verified'] ?? false;
        String type = doc.data()?['type'] ?? '';

        if (centerName.toLowerCase().contains(searchText.toLowerCase()) &&
            verified &&
            type != 'winch') {
          filteredResults.add(doc);
        }
      }

      if (_selectedFilter == 'Rating') {
        filteredResults.sort((a, b) => (b.data()?['rate'] ?? 0).compareTo(a.data()?['rate'] ?? 0));
      } else if (_selectedFilter == 'Location') {
        filteredResults.sort((a, b) {
          double distanceA = _calculateDistance(
            deviceLatitude,
            deviceLongitude,
            a.data()?['latitude'] ?? 0.0,
            a.data()?['longitude'] ?? 0.0,
          );
          double distanceB = _calculateDistance(
            deviceLatitude,
            deviceLongitude,
            b.data()?['latitude'] ?? 0.0,
            b.data()?['longitude'] ?? 0.0,
          );
          return distanceA.compareTo(distanceB);
        });
      }

      setState(() {
        _searchResults = filteredResults;
      });
    }).catchError((error) {
      print('Error searching car repair centers: $error');
    });
  }



  void _searchByBrand(String searchText) {
    String start = searchText;
    String end = searchText + '\uf8ff';

    Query<Map<String, dynamic>> query = _firestore.collection('BusinessOwners');

    Query<Map<String, dynamic>> brandQuery;

    if (_selectedBrand == 'All Brands') {
      brandQuery = query.where('name', isGreaterThanOrEqualTo: start).where('name', isLessThanOrEqualTo: end);
    } else {
      brandQuery = query.where('brands', arrayContains: _selectedBrand).where('name', isGreaterThanOrEqualTo: start).where('name', isLessThanOrEqualTo: end);
    }

    brandQuery.get().then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      List<DocumentSnapshot<Map<String, dynamic>>> results = snapshot.docs;

      List<DocumentSnapshot<Map<String, dynamic>>> filteredResults = results.where((doc) {
        bool verified = doc.data()?['verified'] ?? false;
        String type = doc.data()?['type'] ?? '';

        return verified && type != 'winch';
      }).toList();

      setState(() {
        _searchResults = filteredResults;
      });
    }).catchError((error) {
      print('Error searching car repair centers: $error');
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigationBarExample()),
            );
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(
          'Search',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search for services:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                if (_selectedFilter == 'Supported brand') {
                  _searchByBrand(value);
                } else {
                  _searchCarRepairCenters(value, 'name');
                }
              },
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.grey, // Change the border color to black
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.grey, // Change the border color to black
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),
            Text(
              'Filter by category:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedFilter,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                  _searchController.clear();
                  _searchResults.clear();
                });
              },
              items: <String>[
                'All',
                'Location',
                'Rating',
                'Supported brand',
              ].map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
            ),
            if (_selectedFilter == 'Supported brand')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Select brand:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  DropdownButton<String>(
                    value: _selectedBrand,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedBrand = newValue!;
                        _searchController.clear();
                        _searchResults.clear();
                      });
                    },
                    items: <String>[
                      'All Brands',
                      'Toyota',
                      'KIA',
                      'BMW',
                      'Suzuki',
                      'Nissan',
                      'Opel',
                      'Hyundai',
                      'Honda',
                      'Renault',
                      'Chevrolet',
                      'Mercedes Benz',
                      'Cadillac',
                      'Jeep',
                      'Volkswagen',
                      'Audi',
                      'Ford',
                      'Lamborghini',
                      'Tesla',
                    ].map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            SizedBox(height: 16),
            Text(
              'Search results:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: // Replace the existing ListView.builder with ListView.separated
              ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot<Map<String, dynamic>> document = _searchResults[index];
                  Map<String, dynamic> data = document.data()!;
                  double latitude = data['latitude'];
                  double longitude = data['longitude'];
                  double distanceInKm = _calculateDistance(
                    deviceLatitude,
                    deviceLongitude,
                    latitude,
                    longitude,
                  );

                  return ListTile(
                    title: Text(data['name']),
                    subtitle: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 4),
                        Text(data['rate'].toString()),
                        Icon(Icons.star_rate, color: Colors.yellow[700], size: 20),
                      ],
                    ),
                    onTap: () {
                      String carCenterId = document.id;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MechanicDetails(
                            mechanicId: carCenterId, isEmergency: false, winch: false,
                          ),
                        ),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CarCenterDetailsPage(
                      //       carCenterId: carCenterId,
                      //       deviceLatitude: deviceLatitude,
                      //       deviceLongitude: deviceLongitude,
                      //     ),
                      //   ),
                      // );
                    },
                  );
                },
              ),


            ),
          ],
        ),
      ),
    );
  }
}