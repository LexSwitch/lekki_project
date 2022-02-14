import 'package:flutter/material.dart';
import 'package:lekki_project/constants.dart';
import 'package:lekki_project/screens/edit_property_screen.dart';

import '../services/properties.dart';
import '../widgets/text_label.dart';

class SinglePropertyDetails extends StatefulWidget {
  //final String id;

  var singleProperty;
  SinglePropertyDetails(this.singleProperty);

  @override
  _SinglePropertyDetailsState createState() => _SinglePropertyDetailsState();
}

class _SinglePropertyDetailsState extends State<SinglePropertyDetails> {
  @override
  Widget build(BuildContext context) {
    var items = widget.singleProperty["data"];
    var images = items["images"].length;
    var itemId = items["_id"];
    var description = items["description"];
    var sittingRooms = items["sittingRoom"].toString();
    var kitchens = items["kitchen"].toString();
    var bathrooms = items["bathroom"].toString();
    var toilets = items["toilet"].toString();
    var validTo = items["validTo"].toString();
    var type = items["type"].toString();

    String getImage(int index) {
      String image;

      String noImage = "https://i.postimg.cc/4dmDK3Yv/noImage.png";
      if (images == 0) {
        image = noImage;
      } else {
        image = items["images"][index]["path"];
      }
      return image;
    }

    int _selectedImage = 0;

    void getSingleProperty() async {
      var singlePropData =
          await PropertiesModel().getPropById(itemId).then((result) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EditPage(result);
        }));
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(itemId)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: Image.network(
              getImage(_selectedImage),
              height: 250,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 250,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.brown[300],
                    child: Column(
                      children: [
                        TextLabel("Description:"),
                        Text(
                          description,
                          style: TextStyle(fontSize: 18),
                        ),
                        Gap(),
                        TextLabel("Property Type:"),
                        Text(
                          type,
                          style: TextStyle(fontSize: 18),
                        ),
                        Gap(),
                        TextLabel("Num of bedrooms:"),
                        Text(
                          items["bedroom"].toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        Gap(),
                        TextLabel("Num of sitting rooms:"),
                        Text(
                          sittingRooms,
                          style: TextStyle(fontSize: 18),
                        ),
                        Gap(),
                        TextLabel("Num of kitchens:"),
                        Text(
                          kitchens,
                          style: TextStyle(fontSize: 18),
                        ),
                        Gap(),
                        TextLabel("Num of bathrooms:"),
                        Text(
                          bathrooms,
                          style: TextStyle(fontSize: 18),
                        ),
                        Gap(),
                        TextLabel("Num of toilets:"),
                        Text(
                          toilets,
                          style: TextStyle(fontSize: 18),
                        ),
                        Gap(),
                        TextLabel("Valid till:"),
                        Text(
                          validTo,
                          style: TextStyle(fontSize: 18),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextLabel(
                                "Owner:",
                              ),
                              Text(
                                "${items["propertyOwner"].toString()}",
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            getSingleProperty();
          },
          child: Icon(Icons.edit)),
    );
  }
}
