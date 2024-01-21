import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final double height;
  final Color color;

  const Separator({this.height = 1.0, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
    );
  }
}
