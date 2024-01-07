// landing_screen.dart
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispensary App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Dispensary App'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registration');
              },
              child: Text('Register Patient'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              child: Text('Search Patients'),
            ),
          ],
        ),
      ),
    );
  }
}
