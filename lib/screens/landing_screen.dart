// landing_screen.dart
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispensary App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Dispensary App'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registration');
              },
              child: const Text('Register Patient'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              child: const Text('Search Patients'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/allPatients');
              },
              child: const Text('View All Patients'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/allMedicine');
              },
              child: const Text('All Medicine'),
            ),
          ],
        ),
      ),
    );
  }
}
