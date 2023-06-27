import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/Models/businessOwner_model.dart';
import 'business_signup_page3.dart';

class GoogleMapSignup extends StatefulWidget {
  final Function(double, double) onLocationSelected;
  final BusinessOwnerModel businessOwnerModel;

  const GoogleMapSignup({Key? key, required this.onLocationSelected, required this.businessOwnerModel})
      : super(key: key);

  @override
  State<GoogleMapSignup> createState() => GoogleMapSignupState();
}

class GoogleMapSignupState extends State<GoogleMapSignup> {
  late String? userId;
  double? selectedLatitude;
  double? selectedLongitude;
  Set<Marker> markers = {};
  GoogleMapController? mapController; // Change here

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
  }

  static final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(26.9060999, 30.8768375),
    zoom: 17.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: selectedLatitude != null && selectedLongitude != null
            ? CameraPosition(
          target: LatLng(selectedLatitude!, selectedLongitude!),
          zoom: 17.0,
        )
            : initialCameraPosition,
        markers: markers,
        onTap: onMapTap,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToBusinessOwnerPageThree,
        label: const Text('CONFIRM'),
        icon: const Icon(Icons.pin_drop_outlined),
        backgroundColor: Color.fromRGBO(252, 84, 72, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<Position> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    selectedLatitude = position.latitude;
    selectedLongitude = position.longitude;
    updateUserLocation();

    // Obtain the GoogleMapController instance directly from mapController
    if (mapController != null) {
      // Define myCurrentLocation variable here
      CameraPosition myCurrentLocation = CameraPosition(
        bearing: 190.8334901395799,
        target: LatLng(selectedLatitude!, selectedLongitude!),
        tilt: 40.440717697143555,
        zoom: 19.151926040649414,
      );

      // Use the obtained mapController instance
      mapController!.animateCamera(CameraUpdate.newCameraPosition(myCurrentLocation));
    }

    return position;
  }



  Location location = Location();
  PermissionStatus? permissionStatus;
  bool serviceEnabled = false;
  LocationData? locationData;

  Future<bool> isPermissionGranted() async {
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      return permissionStatus == PermissionStatus.granted;
    } else {
      return permissionStatus == PermissionStatus.granted;
    }
  }

  Future<bool> isServicesEnabled() async {
    serviceEnabled = await location.serviceEnabled();
    if (serviceEnabled == false) {
      serviceEnabled = await location.requestService();
      return serviceEnabled;
    }
    return serviceEnabled;
  }

  void updateUserLocation() async {
    CameraPosition myCurrentLocation = CameraPosition(
      bearing: 190.8334901395799,
      target: LatLng(selectedLatitude!, selectedLongitude!),
      tilt: 40.440717697143555,
      zoom: 19.151926040649414,
    );
    Marker userMarker = Marker(
      markerId: MarkerId('userLocation'),
      position: LatLng(selectedLatitude!, selectedLongitude!),
    );
    markers.add(userMarker);

    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newCameraPosition(myCurrentLocation));
    }

    setState(() {});
    widget.onLocationSelected(selectedLatitude!, selectedLongitude!);
  }


  void navigateToBusinessOwnerPageThree() {
    if (selectedLatitude != null && selectedLongitude != null) {
      Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessOwnerPageThree(businessOwnerModel: widget.businessOwnerModel, businessOwnerId: '',),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select a location on the map.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void onMapTap(LatLng latLng) {
    setState(() {
      selectedLatitude = latLng.latitude;
      selectedLongitude = latLng.longitude;
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId('selectedLocation'),
          position: latLng,
        ),
      );
    });

    print('Selected Latitude: $selectedLatitude');
    print('Selected Longitude: $selectedLongitude');

    widget.onLocationSelected(selectedLatitude!, selectedLongitude!);
  }

}