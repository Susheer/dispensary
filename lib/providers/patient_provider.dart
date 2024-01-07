// patient_provider.dart
import 'package:flutter/material.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/services/database_service.dart';

class PatientProvider extends ChangeNotifier {
  List<Patient> _patients = [];
  final DatabaseService _databaseService;

  PatientProvider(this._databaseService);

  List<Patient> get patients => _patients;

  Future<void> registerPatient({
    required String name,
    required String mobileNumber,
    required String gender,
    required String address,
    required List<String> allergies,
  }) async {
    Patient newPatient = Patient(
      id: _patients.length +
          1, // Assuming the id is auto-incremented by the database
      name: name,
      mobileNumber: mobileNumber,
      gender: gender,
      address: address,
      allergies: allergies,
    );

    _patients.add(newPatient);
    notifyListeners();

    // Save to SQLFlite Db using DatabaseService
    await _databaseService.savePatient(
      name: name,
      mobileNumber: mobileNumber,
      gender: gender,
      address: address,
      allergies: allergies,
    );
  }

  // Add more functions as needed, e.g., searchPatients, editPatient, etc.
}
