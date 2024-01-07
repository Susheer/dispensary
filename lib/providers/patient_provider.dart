// patient_provider.dart
import 'package:flutter/material.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/services/database_service.dart';

class PatientProvider extends ChangeNotifier {
  List<Patient> _patients = [];
  List<Patient> _searchResults = [];
  final DatabaseService _databaseService;

  PatientProvider(this._databaseService);

  Future<void> initializePatients() async {
    // Load patients from the database (example)
    _patients = await _databaseService.getAllPatients();
    notifyListeners();
  }

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

  Future<void> searchPatients({
    required String name,
    required String mobileNumber,
    required String gender,
  }) async {
    // Search patients in the database based on the provided criteria
    _searchResults = _patients
        .where((patient) =>
            patient.name.toLowerCase().contains(name.toLowerCase()) &&
            patient.mobileNumber.contains(mobileNumber) &&
            patient.gender.toLowerCase().contains(gender.toLowerCase()))
        .toList();
    notifyListeners();
  }

  List<Patient> get patients => _patients;

  List<Patient> get searchResults => _searchResults;
  // Add more functions as needed, e.g., searchPatients, editPatient, etc.
}
