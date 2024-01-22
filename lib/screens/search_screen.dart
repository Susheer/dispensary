// search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispensary/providers/patient_provider.dart';
import 'package:dispensary/models/patient.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: mobileController,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
            ),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Invoke search function from the PatientProvider
                Provider.of<PatientProvider>(context, listen: false)
                    .searchPatients(
                  name: nameController.text,
                  mobileNumber: mobileController.text,
                  gender: Patient.parseGender(genderController.text),
                );
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Consumer<PatientProvider>(
                builder: (context, patientProvider, child) {
                  // Display search results in a ListView
                  return ListView.builder(
                    itemCount: patientProvider.searchResults.length,
                    itemBuilder: (context, index) {
                      Patient patient = patientProvider.searchResults[index];
                      return ListTile(
                        title: Text(patient.name),
                        subtitle: Text(
                            'Mobile: ${patient.mobileNumber}, Gender: ${patient.gender}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
