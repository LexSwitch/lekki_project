import 'package:flutter/material.dart';
import 'package:lekki_project/constants.dart';

class TextLabel extends StatelessWidget {
  final String label;

//text styling for property details screen
  TextLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: labelTextStyle.copyWith(
          fontSize: 20, color: Color.fromRGBO(255, 238, 173, 1)),
    );
  }
}
