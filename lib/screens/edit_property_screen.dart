import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lekki_project/models/propertyUpdate.dart';
import 'package:lekki_project/screens/loading_screen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../widgets/form_components.dart';

class EditPage extends StatefulWidget {
  var singleProperty;
  EditPage(this.singleProperty);

  // static const routeName = "/edit-page";

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _form = GlobalKey<FormState>();
  var _selectedEndDate = DateTime.now().add(Duration(days: 200));
  String baseUrl =
      "https://sfc-lekki-property.herokuapp.com/api/v1/lekki/property/";

  var _isLoading = false;

//populates screen with editable details of selected property
  @override
  Widget build(BuildContext context) {
    var items = widget.singleProperty["data"];
    String itemId = items["_id"];
    var bedroom = items["bedroom"];
    var sittingRooms = items["sittingRoom"];
    var kitchen = items["kitchen"];
    var bathroom = items["bathroom"];
    var toilet = items["toilet"];
    var description = items["description"];
    var validTo = items["validTo"];
    var validFrom = DateTime.parse(items["validFrom"]);

//enables user to change validity date of property
    void _tillDatePicker() {
      showDatePicker(
        context: context,
        initialDate: validFrom.add(Duration(days: 90)),
        firstDate: validFrom.add(Duration(days: 90)),
        lastDate: DateTime(2025),
      ).then((endPickedDate) {
        if (endPickedDate != null) {
          setState(() {
            _selectedEndDate = endPickedDate;
          });
        }

        print(_selectedEndDate);
      });
    }

    var updateDetails = PropertyUpdate(
      bedroom: -1,
      sittingRoom: -1,
      kitchen: -1,
      bathroom: -1,
      toilet: -1,
      description: '',
      validTo: '',
    );

//overrides old property data with newly updated details
    Future _saveUpdate(_saveUpdate) async {
      try {
        var updateRequest = await http
            .patch(Uri.parse(baseUrl + '/' + itemId),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode(_saveUpdate))
            .then((http.Response response) {
          if (response.statusCode == 200) {
            final decodedBody = jsonDecode(response.body);
            var message = decodedBody["message"];
            Toast.show("$message", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    //if successful app restarts and fetches updated data.
                    builder: (BuildContext context) => LoadingScreen()),
                (Route<dynamic> route) => false);
          } else {
            //if unsuccessful toast prompts are shown instead
            setState(() {
              _isLoading = false;
            });

            final decodedBody = jsonDecode(response.body);
            var message = decodedBody["error"]["errors"][0]["message"];
            Toast.show("UPDATE UNSUCCESSFULL. $message", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          }
        });
      } catch (e) {
        Toast.show("UPDATE UNSUCCESSFULL. $e", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        setState(() {
          _isLoading = false;
        });
        return;
      }
      setState(() {
        _isLoading = false;
      });
    }

//converts date format and maps new properties to be overriden
    void _updateProperty() {
      setState(() {
        _isLoading = true;
      });
      updateDetails.validTo = DateFormat("yyyy-MM-dd").format(_selectedEndDate);

      Map updatedData = {
        "bedroom": updateDetails.bedroom,
        "sittingRoom": updateDetails.sittingRoom,
        "kitchen": updateDetails.kitchen,
        "bathroom": updateDetails.bathroom,
        "toilet": updateDetails.toilet,
        "description": updateDetails.description,
        "validTo": updateDetails.validTo
      };

      _saveUpdate(updatedData);
    }

//UI with validator messages to be shown when data is incomplete
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Propertey"),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.blue[600],
                  ),
                  Text("Updating property.")
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                autovalidateMode: AutovalidateMode.always,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: bedroom.toString(),
                      decoration: inputDecoration("Bedroom"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null) {
                          return "Bedroom number cannot be empty or negative";
                        } else if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        } else if (double.parse(value) < 0) {
                          return 'Value must be > 0';
                        } else {
                          updateDetails.bedroom = int.parse(value);
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration: inputDecoration("Sitting Room"),
                      keyboardType: TextInputType.number,
                      initialValue: sittingRooms.toString(),
                      validator: (value) {
                        if (value == null) {
                          return "Sitting room number cannot be empty or negative";
                        } else if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        } else if (double.parse(value) < 0) {
                          return 'Value must be > 0';
                        } else {
                          updateDetails.sittingRoom = int.parse(value);
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration: inputDecoration("Kitchen"),
                      keyboardType: TextInputType.number,
                      initialValue: kitchen.toString(),
                      validator: (value) {
                        if (value == null) {
                          return "Kitchen number cannot be empty or negative";
                        } else if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        } else if (double.parse(value) < 0) {
                          return 'Value must be > 0';
                        } else {
                          updateDetails.kitchen = int.parse(value);
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration: inputDecoration("Bathroom"),
                      keyboardType: TextInputType.number,
                      initialValue: bathroom.toString(),
                      validator: (value) {
                        if (value == null) {
                          return "Bathroom number cannot be empty or negative";
                        } else if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        } else if (double.parse(value) < 0) {
                          return 'Value must be > 0';
                        } else {
                          updateDetails.bathroom = int.parse(value);
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration: inputDecoration("Toilet"),
                      keyboardType: TextInputType.number,
                      initialValue: toilet.toString(),
                      validator: (value) {
                        if (value == null) {
                          return "Toilet number cannot be empty or negative";
                        } else if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        } else if (double.parse(value) < 0) {
                          return 'Value must be > 0';
                        } else {
                          updateDetails.toilet = int.parse(value);
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      maxLines: 3,
                      decoration: inputDecoration("Description"),
                      initialValue: description.toString(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Description cannot be empty";
                        } else {
                          updateDetails.description = value;
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Valid To: ${DateFormat("yyyy-MM-dd").format(_selectedEndDate)}   ',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _tillDatePicker,
                            child: Text("Choose End Date"),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(

                        //FAB initializes property update
                        onPressed: () {
                          if (_form.currentState!.validate()) {
                            _updateProperty();
                          } else {
                            Toast.show("Check internet connection.", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.CENTER);

                            return;
                          }
                        },
                        child: Text("Update Details"))
                  ],
                ),
              ),
            ),
    );
  }
}
