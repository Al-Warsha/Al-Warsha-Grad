import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:myapp/Screens/EmergencyRoadHelp.dart';
import '../Models/winchAppointment.dart';
import '../Shared/network/local/firebase_utils.dart';
import 'package:flutter/cupertino.dart';

import 'ServicesScreen.dart';


class Google_map extends StatefulWidget {
  final String? mechanicId;
  final String? businessOwnerId;
  final Function(double, double) onLocationSelected;
  final bool emergency;
  const Google_map({Key? key, required this.onLocationSelected, required this.emergency,
    required this.mechanicId,
    required this.businessOwnerId,}) : super(key: key);

  @override
  State<Google_map> createState() => _Google_mapState();
}

class _Google_mapState extends State<Google_map> {
  late String? userId;
  late String? businessOwnerId;
  @override
  void initState() { //bttndh awal ma screen ttndh
    super.initState();
    getCurrentLocation();
    User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    // Retrieve the business owner ID from Firestore
    businessOwnerId = widget.businessOwnerId;
  }
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.9060999,30.8768375),
    zoom: 17.4746,
  );

  Set<Marker>markers={};
  int count=0;
  // double? currentLatitude;
  // double? currentLongitude;
  TimeOfDay selectedtime = TimeOfDay.now();


  @override
  Widget build(BuildContext context) {
    bool emergency = widget.emergency; // Access the 'emergency' variable using 'widget'
    return Scaffold(
      body: GoogleMap(
        // onLongPress: (latlog){ 34an yt7d mn user mark bs dah e7na m4 3yzeno
        //   Marker marker = Marker(markerId: MarkerId('marker$count'), position: latlog,);
        //   markers.add(marker);
        //   setState(() {
        //   count++;
        //   });
        // },
        mapType: MapType.terrain, //show them normal
        initialCameraPosition: mycurrentlocation==null?_kGooglePlex:mycurrentlocation!,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (emergency) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmergencyRoadHelp(),
              ),
            );
          } else if (!emergency) {
            winchAppointment appointment = winchAppointment(
              latitude: locationData!.latitude!,
              longitude: locationData!.longitude!,
              hour: selectedtime.hour,
              minute: selectedtime.minute,
                userid: userId, mechanicid: businessOwnerId!
            );
            addWinchToFireStore(appointment);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServicesScreen(),
              ),
            );
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: const Text('Request has been sent'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServicesScreen(),
              ),
            );
          }
        },
        label: const Text('CONFIRM'),
        icon: const Icon(Icons.pin_drop_outlined),
        backgroundColor: Color.fromRGBO(252, 84, 72, 1),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<Position> currentlocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(mycurrentlocation!));
    return await Geolocator.getCurrentPosition();
  }

  Location location= Location();
  PermissionStatus? permissionStatus;
  bool serviceEnabled=false;
  LocationData? locationData;
  CameraPosition? mycurrentlocation;

  Future<bool> isPermissionGranted() async
  {
    permissionStatus= await location.hasPermission(); // low hya true hyd5ol 3ala else 3ala tol
    if(permissionStatus==PermissionStatus.denied) //bya5od permission mn user tany
        {
      permissionStatus= await location.requestPermission();
      return permissionStatus==PermissionStatus.granted; // low hya granted hy-return true, low l2 yb2a return false
    } else{
      return permissionStatus==PermissionStatus.granted;
    }
  }

  Future<bool> isServicesEnabled() async
  {
    serviceEnabled = await location.serviceEnabled();
    if (serviceEnabled == false) {
      serviceEnabled= await location.requestService();
      return serviceEnabled;
    }
    return serviceEnabled;
  }

  void getCurrentLocation() async
  {
    var permission= await isPermissionGranted();
    if(permission==false) return;
    var service= await isServicesEnabled();
    if(!service) return;

    locationData= await location.getLocation();
    location.onLocationChanged.listen((event) { //k2no byb2a live location lek kol ma tt7rk by3ml update
      locationData=event;
      updateUserLocation();
      print("my location: lat: ${locationData?.latitude}, long: ${locationData?.longitude}");
    });

    Marker usermarker= Marker(markerId: MarkerId('userLocation'),
        position: LatLng(locationData!.latitude!, locationData!.longitude!));
    markers.add(usermarker);
    setState(() {
    });
  }
  void updateUserLocation() async
  {
    mycurrentlocation = CameraPosition(
        bearing: 190.8334901395799,
        target: LatLng(locationData!.latitude!, locationData!.longitude!), // dah m3nah eno m4 hygelo ba null
        tilt: 40.440717697143555,
        zoom: 19.151926040649414);
    Marker usermarker= Marker(markerId: MarkerId('userLocation'),
        position: LatLng(locationData!.latitude!, locationData!.longitude!));
    markers.add(usermarker);
    final GoogleMapController controller = await _controller.future; // elsatr dah w ely b3do bywdony 3ala current location 3ala tol,
    controller.animateCamera(CameraUpdate.newCameraPosition(mycurrentlocation!)); // bs low location m4 mfto7 3ndk hywdek la defult
    setState(() {});
    widget.onLocationSelected(locationData!.latitude!, locationData!.longitude!);

  }
}


//api key
//AIzaSyDRy7stM8lVq1LbYPHNqdgAoGkdleWS7q0