import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lekki_project/screens/all_properties.dart';
import 'package:lekki_project/services/properties.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String allPropertiesURL =
      'https://sfc-lekki-property.herokuapp.com/api/v1/lekki/property';

  @override
  void initState() {
    getAllProperties(allPropertiesURL);
    super.initState();
  }

//get all available properties
  void getAllProperties(loadingUrl) async {
    var _allPropertiesData =
        await PropertiesModel().getAllProperties(loadingUrl).then((response) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AllPropertiesScreen(
          propertiesData: response,
          title: 'All properties',
        );
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Lekki Project",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SpinKitDoubleBounce(
                color: Colors.black,
                size: 100,
              ),
              Text("Loading Data...")
            ],
          ),
        ),
      ),
    );
  }
}
