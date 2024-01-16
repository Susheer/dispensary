import 'package:flutter/material.dart';

class NotFoundMessage extends StatelessWidget {
  final String message;

  NotFoundMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          const Icon(
            Icons.error,
            size: 50.0,
            color: Colors.red,
          ),
          const SizedBox(height: 16.0),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
