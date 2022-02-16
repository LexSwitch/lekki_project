import 'package:flutter/material.dart';

const labelTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.grey,
);

class Gap extends StatelessWidget {
  const Gap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
    );
  }
}

//text field styling for all text inputs
InputDecoration kTextFieldInputDecoration(String hint) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey),
  );
}
