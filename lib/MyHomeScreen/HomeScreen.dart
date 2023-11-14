import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _initialPosition=CameraPosition(target: LatLng(28.65701173874114, 77.23689340564452),
  zoom: 14,
  );
  final List<Marker> myMarker= [];
  final List<Marker>  markerList=[
    const Marker(
      markerId: MarkerId("first"),
      position:  LatLng(28.65701173874114, 77.23689340564452),
      infoWindow: InfoWindow(title: 'My position'),

    )
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myMarker.addAll(markerList);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: GoogleMap(
        initialCameraPosition:_initialPosition,
        markers: Set<Marker>.of(myMarker),
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
      ),
    ));
  }
}
