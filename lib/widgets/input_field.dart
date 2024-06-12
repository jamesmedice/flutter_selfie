import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.controller,
    required this.label,
    this.obscureText = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color:
                const Color.fromARGB(255, 250, 250, 251)), // Change label color
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color:
                  Color.fromARGB(255, 10, 26, 168)), // Change underline color
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Color.fromARGB(255, 2, 78, 13)), // Change focused underline color
        ),
      ),
      obscureText: obscureText,
      style: TextStyle(
          color: const Color.fromARGB(255, 243, 243, 245),
          fontSize: 16.0,
          fontWeight: FontWeight.w500),
    );
  }
}
