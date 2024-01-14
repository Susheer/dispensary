import 'package:flutter/material.dart';

class NotFoundMessage extends StatelessWidget {
  final String message;

  NotFoundMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 50.0,
            color: Colors.red,
          ),
          SizedBox(height: 16.0),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
