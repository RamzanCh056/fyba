





import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  const ReusableText({
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    super.key});
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color
      ),
    );
  }
}
