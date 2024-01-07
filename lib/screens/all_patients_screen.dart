// all_patients_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispensary/providers/patient_provider.dart';
import 'package:dispensary/models/patient.dart';

class AllPatientsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Patients'),
      ),
      body: Consumer<PatientProvider>(
        builder: (context, patientProvider, child) {
          List<Patient> patients = patientProvider.patients;

          return patients.isNotEmpty
              ? ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    Patient patient = patients[index];
                    return ListTile(
                      title: Text(patient.name),
                      subtitle: Text(
                          'Mobile: ${patient.mobileNumber}, Gender: ${patient.gender}'),
                    );
                  },
                )
              : Center(
                  child: Text('No patients available.'),
                );
        },
      ),
    );
  }
}
