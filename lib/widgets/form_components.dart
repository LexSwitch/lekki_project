import 'package:flutter/material.dart';

inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
  );
}

class TextFieldSpace extends StatelessWidget {
  Widget child;
  TextFieldSpace({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Container(
        width: 120,
        child: child,
      ),
    );
  }
}
