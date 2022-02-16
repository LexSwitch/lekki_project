import 'package:flutter/material.dart';
import 'package:lekki_project/screens/all_properties.dart';
import 'package:lekki_project/screens/edit_property_screen.dart';
import 'package:lekki_project/screens/loading_screen.dart';
import 'package:lekki_project/services/properties.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

//entry point of application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.lime,
          colorScheme: ColorScheme.light(
            primary: Colors.black54,
          ),
          canvasColor: Color.fromRGBO(255, 238, 173, 1)),
      home: LoadingScreen(),
    );
  }
}
