// registration_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispensary/providers/patient_provider.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register Patient'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Patient Name'),
            ),
            TextField(
              controller: mobileController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            TextField(
              controller: genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: allergiesController,
              decoration:
                  InputDecoration(labelText: 'Allergies (comma-separated)'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Pass form data to the PatientProvider
                await patientProvider.registerPatient(
                  name: nameController.text,
                  mobileNumber: mobileController.text,
                  gender: genderController.text,
                  address: addressController.text,
                  allergies: allergiesController.text.split(','),
                );

                // Clear form data
                nameController.clear();
                mobileController.clear();
                genderController.clear();
                addressController.clear();
                allergiesController.clear();

                // Optionally, you can navigate back to the landing screen
                Navigator.pop(context);
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
