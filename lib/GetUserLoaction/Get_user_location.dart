import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserLocation extends StatefulWidget {
  const GetUserLocation({Key? key}) : super(key: key);

  @override
  State<GetUserLocation> createState() => _GetUserLocationState();
}

class _GetUserLocationState extends State<GetUserLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _initialPosition = CameraPosition(
    target: LatLng(28.65701173874114, 77.23689340564452),
    zoom: 15,
  );
  final List<Marker> myMarker = [];
  final List<Marker> markerList = const [
    Marker(
      markerId: MarkerId("first"),
      position: LatLng(28.65701173874114, 77.23689340564452),
      infoWindow: InfoWindow(title: 'Lal Quila'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    myMarker.addAll(markerList);
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error,
        stackTrace) {
      print('error$error');
    });
    return Geolocator.getCurrentPosition();
  }

  void packData() {
    Geolocator.getCurrentPosition().then((value) async {
      print("my Location");
      print("${value.latitude}${value.longitude}");
      myMarker.add(
        Marker(
          markerId: MarkerId('Second position'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: InfoWindow(title: "My location"),
        ),
      );
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 15,
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "MAP",
            style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 2,
                fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue.shade200.withOpacity(.4),
          actions: [
            IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                packData();
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Handle search functionality

              },
            ),
            PopupMenuButton<String>(

              itemBuilder: (BuildContext context) {
                return {'profile', 'History', 'Share Loaction'}.map((
                    String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              onSelected: (String choice) {
                // Handle menu item selection
              },
            ),
          ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 25),
          child: FloatingActionButton(
            backgroundColor: Colors.blue.shade200.withOpacity(.7),
            onPressed: () {
              packData();
            },
            child: Icon(Icons.radio_button_off),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: GoogleMap(
          initialCameraPosition: _initialPosition,
          markers: Set<Marker>.of(myMarker),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}