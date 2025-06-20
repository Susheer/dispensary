import 'package:flutter/material.dart';

class BlockingOverlay extends StatelessWidget {
  late double percentage;

  BlockingOverlay({required this.percentage});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight - 10,
      width: screenWidth - 10,
      child: Stack(
        children: [
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: CircularProgressBar(percentage: percentage),
          ),
        ],
      ),
    );
  }
}

class CircularProgressBar extends StatelessWidget {
  final double percentage;

  CircularProgressBar({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: percentage / 100,
          strokeWidth: 8.0,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        Text(
          '${percentage.toInt()}%',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
