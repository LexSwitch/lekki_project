import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url;
  NetworkHelper(this.url);

  String baseUrl =
      'https://sfc-lekki-property.herokuapp.com/api/v1/lekki/property';
  String uploadUrl =
      "https://sfc-lekki-property.herokuapp.com/api/v1/lekki/upload/";

  //Gets property data on startup and returns a response data
  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 400) {
      return response.statusCode;
    } else {
      print(response.reasonPhrase);
      return;
    }
  }

//saves new property to database when user taps on SUBMIT BUTTON on Add New Property Screen
  Future saveProperty(fullData) async {
    http.Response saveResponse = await http.post(Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(fullData));
    if (saveResponse.statusCode == 201) {
      return true;
    } else {
      print(false);
    }
  }

// function to upload image and return status code and other relevant details
  Future uploadImage(fileName) async {
    var imageRequest =
        await http.MultipartRequest('POST', Uri.parse(uploadUrl));
    imageRequest.files.add(await http.MultipartFile.fromPath('file', fileName));

    http.StreamedResponse imageResponse = await imageRequest.send();
    return imageResponse;
  }
}
