import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lekki_project/models/property.dart';
import 'package:lekki_project/screens/loading_screen.dart';
import 'package:lekki_project/services/properties.dart';
import 'package:toast/toast.dart';

import '../services/networking.dart';
import '../widgets/form_components.dart';

class AddNewProperty extends StatefulWidget {
  const AddNewProperty({Key? key}) : super(key: key);

  @override
  _AddNewPropertyState createState() => _AddNewPropertyState();
}

class _AddNewPropertyState extends State<AddNewProperty> {
  DateTime _selectedInitDate = DateTime.now().add(Duration(days: 3));

  DateTime _selectedEndDate = DateTime.now().add(Duration(days: 7));
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  String imagePromptText = "Add images";
  String baseUrl =
      'https://sfc-lekki-property.herokuapp.com/api/v1/lekki/property';

  NetworkHelper networkHelper = NetworkHelper(allPropertiesURL);

  void _fromDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 3)),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedInitDate = pickedDate;
        });
      }
    });
  }
//minimum duration between a property validity dates is one week.

  void _tillDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: DateTime.now().add(Duration(days: 7)),
      lastDate: DateTime(2025),
    ).then((endPickedDate) {
      if (endPickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedEndDate = endPickedDate;
        });
      }
    });
  }

  var _newProperty = Property(
    id: '',
    address: '',
    type: '',
    bedroom: -1,
    sittingRoom: -1,
    kitchen: -1,
    toilet: -1,
    propertyOwner: '',
    description: '',
    validFrom: '',
    validTo: '',
    images: [],
    bathroom: -1,
  );

  void _saveForm() {
    setState(() {
      _isLoading = true;
    });
    _newProperty.validFrom = DateFormat("yyyy-MM-dd").format(_selectedInitDate);
    _newProperty.validTo = DateFormat("yyyy-MM-dd").format(_selectedEndDate);

    Map fullData = {
      'address': _newProperty.address,
      'type': _newProperty.type,
      'bedroom': _newProperty.bedroom,
      'sittingRoom': _newProperty.sittingRoom,
      'kitchen': _newProperty.kitchen,
      'bathroom': _newProperty.bathroom,
      'toilet': _newProperty.toilet,
      'propertyOwner': _newProperty.propertyOwner,
      'description': _newProperty.description,
      'validFrom': _newProperty.validFrom,
      'validTo': _newProperty.validTo,
      'images': _newProperty.images
    };

    _saveNewProperty(fullData);

    setState(() {
      _isLoading = false;
    });
  }

  Future _saveNewProperty(fullData) async {
    _isLoading = true;
    //bool saveResponse = await networkHelper.saveProperty(fullData);
    try {
      http.Response saveResponse = await http.post(Uri.parse(baseUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(fullData));

      if (saveResponse.statusCode == 201) {
        _isLoading = false;
        Toast.show("New property added successfully.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoadingScreen()),
            (Route<dynamic> route) => false);
      } else {
        var decodedError = jsonDecode(saveResponse.body);
        print(decodedError["error"]["errors"][0]["message"]);
        Toast.show(decodedError["error"]["errors"][0]["message"], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

        return null;
      }
    } catch (Exception) {
      print(Exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _storedImage;

    Future uploadImage(fileName) async {
      http.StreamedResponse imageResponse =
          await networkHelper.uploadImage(fileName);

      if (imageResponse.statusCode == 200) {
        dynamic feedback = await imageResponse.stream.bytesToString();
        final decodedJson = jsonDecode(feedback);
        _newProperty.images.add(decodedJson["data"]);
        Toast.show(decodedJson["message"], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        setState(() {
          _storedImage = decodedJson["data"]["path"];
          imagePromptText = "Image added successfully.";
        });
      } else {
        Toast.show(imageResponse.reasonPhrase.toString(), context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      }
    }

    Future pickImage() async {
      try {
        var file = await ImagePicker.pickImage(source: ImageSource.gallery);
        var res = await uploadImage(file.path);
      } catch (e) {
        Toast.show("Upload failed. Check internet connection", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add new property"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                autovalidateMode: AutovalidateMode.always,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: inputDecoration("Address"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Address cannot be empty";
                        } else {
                          _newProperty.address = value;
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration:
                          inputDecoration('Type (eg. house,flat,duplex etc)'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Type cannot be empty";
                        } else {
                          _newProperty.type = value;
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration: inputDecoration('Number of bedrooms'),
                      validator: (value) {
                        if (value == null) {
                          return "Bedroom number cannot be empty or negative";
                        } else if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        } else if (double.parse(value) < 0) {
                          return 'Value must be > 0';
                        } else {
                          _newProperty.bedroom = int.parse(value);
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration: inputDecoration('Number of sitting rooms'),
                      validator: (value) {
                        if (value == null) {
                          return "Sitting room number cannot be empty or negative";
                        } else if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        } else if (double.parse(value) < 0) {
                          return 'Value must be > 0';
                        } else {
                          _newProperty.sittingRoom = int.parse(value);
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration: inputDecoration('Number of kitchens'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Kitchen number cannot be empty or negative";
                        } else if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        } else if (double.parse(value) < 0) {
                          return 'Value must be >0';
                        } else {
                          _newProperty.kitchen = int.parse(value);
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration: inputDecoration('Number of bathrooms'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Bathroom number cannot be empty or negative";
                        } else if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        } else if (double.parse(value) < 0) {
                          return 'Value must be >0';
                        } else {
                          _newProperty.bathroom = int.parse(value);
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration: inputDecoration('Number of toilets'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Toilet number cannot be empty or negative";
                        } else if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        } else if (double.parse(value) < 0) {
                          return 'Value must be >0';
                        } else {
                          _newProperty.toilet = int.parse(value);
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration: inputDecoration('Property owner'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Owner name cannot be empty";
                        } else {
                          _newProperty.propertyOwner = value;
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: inputDecoration('Description'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Description cannot be empty";
                        } else {
                          _newProperty.description = value;
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
                              'Valid From: ${DateFormat("yyyy-MM-dd").format(_selectedInitDate)}   ',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _fromDatePicker,
                            child: Text("Choose Start Date"),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Valid From: ${DateFormat("yyyy-MM-dd").format(_selectedEndDate)}   ',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Add images:"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: pickImage,
                              child: Text("Upload image"),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 70,
                              width: 100,
                              child: Text(imagePromptText),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_form.currentState!.validate()) {
                            _saveForm();
                            //_saveNewProperty;
                          } else {
                            return;
                          }
                        },
                        child: Text("Submit"))
                  ],
                ),
              ),
            ),
    );
  }
}
