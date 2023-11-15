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
  final List<Marker>  markerList= const[
   Marker(
      markerId: MarkerId("first"),
      position:  LatLng(28.65701173874114, 77.23689340564452),
      infoWindow: InfoWindow(title: 'Lal Quila'),
    ),
    Marker(
      markerId: MarkerId("second"),
      position:  LatLng(28.655204116077005, 77.23221563323246),
      infoWindow: InfoWindow(title: 'Khatu Shaym Temple'),
    ),
    Marker(
      markerId: MarkerId("Third"),
      position:  LatLng(28.6620955103881, 77.23011278141419),
      infoWindow: InfoWindow(title: 'Delhi junction'),
    ),
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
      appBar: AppBar(
        title:Text("MAP",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,letterSpacing: 2),),
        centerTitle: true,
        backgroundColor: Colors.blue.shade200.withOpacity(.4),
      ),
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
