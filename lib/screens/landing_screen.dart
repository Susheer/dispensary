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
            ElevatedButton(
              onPressed: () {
                // Navigate to AllPatientsScreen using named route
                Navigator.pushNamed(context, '/allPatients');
              },
              child: Text('View All Patients'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to AllPatientsScreen using named route
                Navigator.pushNamed(context, '/addMedicine');
              },
              child: const Text('Add Medicine'),
            ),
          ],
        ),
      ),
    );
  }
}
