import 'package:flutter/material.dart';
import 'package:lekki_project/screens/single_property_details.dart';

import '../services/properties.dart';

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

// class rawOne extends StatelessWidget {
//   const rawOne({
//     Key? key,
//     required this.firstImage,
//     required this.address,
//     required this.bedroom,
//     required this.type,
//   }) : super(key: key);

//   final String firstImage;
//   final String address;
//   final String bedroom;
//   final String type;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         getSingleProperty();
//       },
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         elevation: 4,
//         margin: EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(15),
//                     topRight: Radius.circular(15),
//                   ),
//                   child: Image.network(
//                     firstImage,
//                     height: 150,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 20,
//                   right: 0,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.black54,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(15),
//                       ),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                     width: 200,
//                     height: 40,
//                     child: Text(
//                       address.toUpperCase(),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                       softWrap: true,
//                       overflow: TextOverflow.fade,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [Text("${bedroom}  bedroom  ${type}")],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
