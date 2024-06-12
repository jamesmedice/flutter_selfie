import 'package:flutter/material.dart';

class CustomButtonStyle {
  static ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 7, 31, 213),
      shadowColor: Color.fromARGB(255, 249, 250, 249),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
