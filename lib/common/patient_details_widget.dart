import 'package:flutter/material.dart';
import 'package:dispensary/screens/patient_screen.dart';
import 'package:dispensary/models/patient.dart';

class PatientDetailsWidget extends StatelessWidget {
  final Patient patient;

  const PatientDetailsWidget({required this.patient});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientScreen(patientId: patient.id),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(patient.name),
          subtitle: Text(
              'Mobile: ${patient.mobileNumber}, Gender: ${patient.gender}'),
        ),
      ),
    );
  }
}
