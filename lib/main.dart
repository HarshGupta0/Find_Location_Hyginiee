import 'package:flutter/material.dart';
import 'package:task_hyginiee/GetUserLoaction/Get_user_location.dart';
import 'package:task_hyginiee/places/Places.dart';

import 'MyHomeScreen/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home : Places(),
    );
  }
}
