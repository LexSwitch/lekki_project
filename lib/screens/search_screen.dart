import 'package:flutter/material.dart';
import 'package:lekki_project/services/networking.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:toast/toast.dart';

import '../constants.dart';
import '../services/properties.dart';
import '../widgets/form_components.dart';
import 'all_properties.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String queryValue = "";

  Map<String, String> parameters = {};

  final List<Map<String, dynamic>> _filters = [
    {'value': 'Sitting Room', 'query': 'sittingRoom='},
    {'value': 'Kitchen', 'query': 'kitchen='},
    {'value': 'Bedroom', 'query': 'bedroom='},
    {'value': 'Bathroom', 'query': 'bathroom='},
    {'value': 'Toilet', 'query': 'toilet='},
    {'value': 'Property Owner', 'query': 'propertyOwner='},
  ];

  void getFilteredProperties(loadingUrl) async {
    var _allPropertiesData =
        await PropertiesModel().getAllProperties(loadingUrl).then((response) {
      if (response == 400 || response["data"].length == 0) {
        Toast.show("No properties found.Please try again.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        resetFilters();
        return;
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AllPropertiesScreen(
                      title: 'Filtered Properties',
                      propertiesData: response,
                    )),
            (Route<dynamic> route) => false);
      }
    });
  }

  String baseUrl =
      "https://sfc-lekki-property.herokuapp.com/api/v1/lekki/property?";

  String selectedFilter = 'Property Owner';

  String selectedQuery = 'propertyOwner';
  void combineUrl(filterParam) {
    if (filterParam == _filters[0]["value"]) {
      setState(() {
        selectedQuery = _filters[0]["query"];
      });
    } else if (filterParam == _filters[1]["value"]) {
      setState(() {
        selectedQuery = _filters[1]["query"];
      });
    } else if (filterParam == _filters[2]["value"]) {
      setState(() {
        selectedQuery = _filters[2]["query"];
      });
    } else if (filterParam == _filters[3]["value"]) {
      setState(() {
        selectedQuery = _filters[3]["query"];
      });
    } else if (filterParam == _filters[4]["value"]) {
      setState(() {
        selectedQuery = _filters[4]["query"];
      });
    } else if (filterParam == _filters[5]["value"]) {
      setState(() {
        selectedQuery = _filters[5]["query"];
      });
    }

    String combinedUrl = baseUrl + '${selectedQuery}' + '${queryValue}';

    print(combinedUrl);
    getFilteredProperties(combinedUrl);
  }

  @override
  void initState() {
    selectedFilter = _filters[5]["value"];
    super.initState();
  }

  void resetFilters() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        color: Color.fromRGBO(255, 238, 173, 1),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 150,
                      child: SelectFormField(
                        type: SelectFormFieldType.dropdown,
                        initialValue: _filters[5]["value"].toString(),
                        labelText: 'Filter:',
                        items: _filters,
                        onChanged: (val) {
                          setState(() {
                            selectedFilter = val;
                          });
                        },
                        onSaved: (val) {
                          setState(() {
                            //print(selectedQuery);
                            selectedFilter = val.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 220,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      style: TextStyle(color: Colors.black),
                      decoration: kTextFieldInputDecoration(selectedFilter),
                      onChanged: (value) {
                        setState(() {
                          queryValue = value;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          queryValue = value.toString();
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          combineUrl(selectedFilter);
                        },
                        child: Text("Search"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          resetFilters();
                        },
                        child: Text("Reset"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
