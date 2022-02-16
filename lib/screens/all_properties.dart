import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lekki_project/screens/add_new_property_screen.dart';
import 'package:lekki_project/screens/loading_screen.dart';
import 'package:lekki_project/screens/search_screen.dart';
import '../widgets/property_item.dart';

class AllPropertiesScreen extends StatefulWidget {
  final propertiesData;
  String title;

  AllPropertiesScreen({this.propertiesData, required this.title});

  @override
  State<AllPropertiesScreen> createState() => _AllPropertiesScreenState();
}

//search modal to be shown when user taps on the search button
void _showSearch(BuildContext ctx) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: SearchScreen(),
          behavior: HitTestBehavior.opaque,
        );
      });
}

//all available properties are displayed on this. It receives the data as an argument from
// the loading screen. Filtered data can also be shown here by use of the search modal.
class _AllPropertiesScreenState extends State<AllPropertiesScreen> {
  @override
  Widget build(BuildContext context) {
    var items = widget.propertiesData["data"];

//Function gets image of the property. If property has no image, a blank image will replace it.
    String getFirstImage(int index) {
      String image;

      String noImage = "https://i.postimg.cc/4dmDK3Yv/noImage.png";
      if (items[index]["images"].length == 0) {
        image = noImage;
      } else {
        image = items[index]["images"][0]["path"];
      }
      return image;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: InkWell(
              child: Icon(Icons.search),
              onTap: () {
                //search modal function
                _showSearch(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: InkWell(
              child: Icon(Icons.refresh),
              onTap: () {
                //function refreshes app data
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoadingScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
          )
        ],
      ),

      // the GridView builder populates the screen with duplicates of a tile with different property details
      //a tap on a single grid tile the details screen of the property.
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          // received data from loading scren is parsed, converted to string formats and displayed in this manner.
          return PropertyItem(
              id: items[index]["_id"],
              firstImage: getFirstImage(index),
              bedroom: items[index]["bedroom"].toString(),
              type: items[index]["type"].toString(),
              address: items[index]["address"].toString());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //takes the user to the add new property screen
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddNewProperty();
          }));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
