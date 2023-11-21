import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task_hyginiee/places/Places.dart';

// This widget is responsible for getting user location and displaying it on Google Maps.
class GetUserLocation extends StatefulWidget {
  const GetUserLocation({Key? key}) : super(key: key);
  @override
  State<GetUserLocation> createState() => _GetUserLocationState();
}

class _GetUserLocationState extends State<GetUserLocation> {
  // Completer to handle the GoogleMapController asynchronously.
  final Completer<GoogleMapController> _controller = Completer();

  // Initial camera position when the map is loaded.
  static CameraPosition _initialPosition = CameraPosition(
    target: LatLng(28.65701173874114, 77.23689340564452),
    zoom: 15,
  );

  // List of markers to be displayed on the map.
  final List<Marker> myMarker = [];

  // Predefined list of markers (for demonstration purposes).
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
    // Add predefined markers to myMarker list during initialization.
    myMarker.addAll(markerList);
  }

  // Asynchronous function to get the user's current location using the Geolocator plugin.
  Future<Position> getUserLocation() async {
    // Request permission to access device location.
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) {
      print('error$error');
    });
    // Return the current position.
    return Geolocator.getCurrentPosition();
  }

  // Function to update the map with the user's current location.
  void packData() {
    // Get the user's current location using Geolocator.
    Geolocator.getCurrentPosition().then((value) async {
      print("my Location");
      print("${value.latitude}${value.longitude}");

      // Add a marker for the user's current location to the myMarker list.
      myMarker.add(
        Marker(
          markerId: MarkerId('Second position'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: InfoWindow(title: "My location"),
        ),
      );

      // Set the camera position to focus on the user's current location.
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 15,
      );

      // Get the GoogleMapController from the Completer and animate the camera to the new position.
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      // Trigger a rebuild to update the UI.
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              letterSpacing: 2,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue.shade200.withOpacity(.4),
          actions: [
            IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                // When location icon is pressed, update the map with the user's current location.
                packData();
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Navigate to the Places screen when the search icon is pressed.
                Navigator.push(context, MaterialPageRoute(builder: (context) => Places()));
              },
            ),
            PopupMenuButton<String>(
              // Create a popup menu with profile, history, and share location options.
              itemBuilder: (BuildContext context) {
                return {'profile', 'History', 'Share Location'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              onSelected: (String choice) {
                // Handle menu item selection if needed.
              },
            ),
          ],
        ),
        // Floating action button to manually update the user's location on the map.
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 25),
          child: FloatingActionButton(
            backgroundColor: Colors.blue.shade200.withOpacity(.7),
            onPressed: () {
              // When the floating action button is pressed, update the map with the user's current location.
              packData();
            },
            child: Icon(Icons.radio_button_off),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // GoogleMap widget to display the map.
        body: GoogleMap(
          initialCameraPosition: _initialPosition,
          markers: Set<Marker>.of(myMarker),
          onMapCreated: (GoogleMapController controller) {
            // Callback function when the map is created, providing the GoogleMapController.
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
