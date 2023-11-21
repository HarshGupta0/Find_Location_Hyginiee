import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// A StatefulWidget for displaying a list of places and searching for places.
class Places extends StatefulWidget {
  const Places({super.key});

  @override
  State<Places> createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  // Controller for the search input field.
  TextEditingController _controller = TextEditingController();

  // Initial session token for Google Places API.
  String tokenForSession = "34765";

  // Uuid instance for generating unique session tokens.
  var uuid = Uuid();

  // List to store suggestions/places received from the Google Places API.
  List<dynamic> ListForPlaces = [];

  // Function to fetch place suggestions from the Google Places API.
  void makeSuggestions(String input) async {
    // Google Places API key for authentication.
    String googlePlacesApikey = "AIzaSyANU53A5MDj36XQWxtVtMVuQjFE-JB6IUY";

    // Google Places API endpoint for autocomplete predictions.
    String groundURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    // Build the API request URL.
    String request = '$groundURL?input=$input&key=$googlePlacesApikey&sessiontoken=$tokenForSession';

    // Make a GET request to the Google Places API.
    var ResponseResult = await http.get(Uri.parse(request));
    var ResultData = ResponseResult.body.toString();
    print("ResultData");
    print(ResultData);

    // Check if the request was successful (status code 200).
    if (ResponseResult.statusCode == 200) {
      // Update the ListForPlaces with the suggestions received from the API response.
      setState(() {
        ListForPlaces = jsonDecode(ResponseResult.body.toString())['predictions'];
      });
    } else {
      // Throw an exception if the request was not successful.
      throw Exception('Showing data failed, try again');
    }
  }

  // Function to handle modifications in the search input.
  void OnModify() {
    // If the session token is null, generate a new one.
    if (tokenForSession == null) {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }
    // Call makeSuggestions with the current input.
    makeSuggestions(_controller.text);
  }

  @override
  void initState() {
    super.initState();
    // Add a listener to the search input to trigger OnModify on text changes.
    _controller.addListener(() {
      OnModify();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade600, Colors.blue.shade400, Colors.blue.shade200],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Places"),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search Place',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: ListForPlaces.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          // Get the location details (latitude, longitude) from the selected place.
                          List<Location> location =
                          await locationFromAddress(ListForPlaces[index]['description']);
                          print(location.last.latitude);
                          print(location.last.longitude);
                        },
                        title: Text(ListForPlaces[index]['description']),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
