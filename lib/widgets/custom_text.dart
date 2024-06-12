import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text,
    this.color = const Color.fromARGB(255, 0, 0, 0),
    this.fontSize = 20.0,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
