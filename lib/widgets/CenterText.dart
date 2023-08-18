import 'package:flutter/material.dart';

class CenterText extends StatelessWidget {
  const CenterText({
    super.key,
    required this.text,
    required this.fontSize,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
