import 'dart:convert';

import 'package:lekki_project/services/networking.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../screens/loading_screen.dart';

const allPropertiesURL =
    'https://sfc-lekki-property.herokuapp.com/api/v1/lekki/property';

const idPropertyUrl =
    "https://sfc-lekki-property.herokuapp.com/api/v1/lekki/property/";

class PropertiesModel {
  Future<dynamic> getAllProperties(startingUrl) async {
    NetworkHelper networkHelper = NetworkHelper(startingUrl);

    var propertiesData = await networkHelper.getData();

    return propertiesData;
  }

  Future<dynamic> getPropById(String id) async {
    NetworkHelper networkHelper = NetworkHelper(idPropertyUrl + id);
    var singlePropData = await networkHelper.getData();
    return singlePropData;
  }
}
