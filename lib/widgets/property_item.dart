import 'package:flutter/material.dart';
import 'package:lekki_project/screens/single_property_details.dart';

import '../services/properties.dart';

//data model of a single property
class PropertyItem extends StatelessWidget {
  final String id;
  final String firstImage;
  final String bedroom;
  final String type;
  final String address;

  PropertyItem(
      {required this.id,
      required this.firstImage,
      required this.bedroom,
      required this.type,
      required this.address});

  @override
  Widget build(BuildContext context) {
    //get details of selected property to display on details page
    void getSingleProperty() async {
      var singlePropData = await PropertiesModel().getPropById(id);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SinglePropertyDetails(singlePropData);
      }));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            getSingleProperty();
          },
          child: Image.network(
            firstImage,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Container(
            width: 70,
            child: Text(
              "${bedroom} bedroom ${type}",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
