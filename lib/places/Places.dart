import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
class Places extends StatefulWidget {
  const Places({super.key});

  @override
  State<Places> createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  TextEditingController _controller = TextEditingController();
  String  tokenForSession ="34765";
  var uuid=Uuid();
  List<dynamic> ListForPlaces =[];
  void makeSuggestions (String input) async {
    String googlePlacesApikey ="AIzaSyANU53A5MDj36XQWxtVtMVuQjFE-JB6IUY";
    String groundURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$groundURL?input=$input&key=$googlePlacesApikey&sessiontoken=$tokenForSession';

    var ResponseResult =await http.get(Uri.parse(request));
    var ResultData= ResponseResult.body.toString();
    print("ResultData");
    print(ResultData);
    if(ResponseResult.statusCode==200){
      setState(() {
      ListForPlaces = jsonDecode(ResponseResult.body.toString())['predictions'];
      });
    }else{
      throw Exception('showing data failed , try again');
    }
  }
  void OnModify(){
    if(tokenForSession==null){
      setState(() {
       tokenForSession =uuid.v4();
      });
    }
    makeSuggestions(_controller.text);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            colors: [Colors.blue.shade600,Colors.blue.shade400,Colors.blue.shade200],
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
                Expanded(child: ListView.builder(
                    itemCount: ListForPlaces.length,
                    itemBuilder: (context , index){
                    return ListTile(
                      onTap: ()
                      async{
                        List<Location> location = await locationFromAddress(ListForPlaces[index]['description']);
                        // List<Location> location = await locationFromAddress
                        print(location.last.latitude);
                        print(location.last.longitude);
                      },
                      title: Text(ListForPlaces[index]['description']),
                    );

                })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}