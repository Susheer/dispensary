// all_patients_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispensary/providers/patient_provider.dart';
import 'package:dispensary/models/patient.dart';

class AllPatientsScreen extends StatefulWidget {
  @override
  State<AllPatientsScreen> createState() => _AllPatientsScreenState();
}

class _AllPatientsScreenState extends State<AllPatientsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(
        builder: (context, patientProvider, child) {
      patientProvider.initializePatients();
      List<Patient> patients = patientProvider.patients;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Patient List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Add your logic for the "Add" action here
                // For example: navigate to a screen for adding a new patient
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Add your logic for the "Search" action here
                // For example: navigate to a search screen
              },
            ),
            // Add more IconButton widgets for additional actions as needed
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Display the number of records
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Number of Records: ${patients.length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Display the list of patients
              patients.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          Patient patient = patients[index];
                          return ListTile(
                            title: Text(patient.name),
                            subtitle: Text(
                              'Mobile: ${patient.mobileNumber}, Gender: ${patient.gender}',
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text('No patients available.'),
                    ),
            ],
          ),
        ),
        // Responsive card with action buttons
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Add your logic for the "Add" action here
                      // For example: navigate to a screen for adding a new patient
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // Add your logic for the "Search" action here
                      // For example: navigate to a search screen
                    },
                  ),
                  // Add more IconButton widgets for additional actions as needed
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
