// patient_provider.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/services/database_service.dart';
import 'package:dispensary/appConfig.dart';

class PatientProvider extends ChangeNotifier {
  List<Patient> _patients = [];
  List<Patient> _searchResults = [];

  final DatabaseService _databaseService;

  PatientProvider(this._databaseService);

  Future<void> initializePatients() async {
    // Load patients from the database (example)
    _patients =
        await _databaseService.fetchPaginatedPatients(0, AppConfig.PageSize);
    notifyListeners();
  }

  Future<void> registerPatient({
    required String name,
    required String mobileNumber,
    required String gender,
    required String address,
    required List<String> allergies,
    String? guardianName,
    String? guardianMobileNumber,
    String? guardianGender,
    String? guardianAddress,
    String? relation,
  }) async {
    Gender? gen;
    GuardianRelation? rel;
    if (guardianGender != null && guardianGender.trim() != "") {
      gen = Patient.parseGender(guardianGender);
    }

    if (relation != null && relation.trim() != "") {
      rel = Patient.parseRelation(relation);
    }
    Patient newPatient = Patient(
        id: _patients.length +
            1, // Assuming the id is auto-incremented by the database
        name: name,
        mobileNumber: mobileNumber,
        gender: Patient.parseGender(gender),
        address: address,
        allergies: allergies,
        guardianName: guardianName,
        guardianMobileNumber: guardianMobileNumber,
        guardianGender: gen,
        guardianAddress: guardianAddress,
        relation: rel);

    _patients.add(newPatient);
    notifyListeners();

    // Save to SQLFlite Db using DatabaseService
    await _databaseService.savePatient(
        name: name,
        mobileNumber: mobileNumber,
        gender: gender,
        address: address,
        allergies: allergies,
        guardianName: guardianName ?? "",
        guardianMobileNumber: guardianMobileNumber ?? "",
        guardianGender: guardianGender ?? "",
        guardianAddress: guardianAddress ?? "",
        guardianRelation: relation ?? "");
  }

  Future<int> getPatientsCount() {
    return _databaseService.getPatientsCount();
  }

  Future<void> searchPatients({
    required String name,
    required String mobileNumber,
    required Gender gender,
  }) async {
    // Search patients in the database based on the provided criteria
    _searchResults = _patients
        .where((patient) =>
            patient.name.toLowerCase().contains(name.toLowerCase()) &&
            patient.mobileNumber.contains(mobileNumber) &&
            patient.gender == gender)
        .toList();
    notifyListeners();
  }

  // Simulated method to fetch the next page of patients
  Future<int> fetchNextPage(int startIndex, int pageSize) async {
    // Simulate fetching data from a data source (e.g., a database)
    // Replace this with your actual data fetching logic
    await Future.delayed(Duration(seconds: 2));

    List<Patient> nextPage =
        await _databaseService.fetchPaginatedPatients(startIndex, pageSize);
    //_generateDummyPatients(pageSize);
    if (nextPage.isEmpty != true) {
      _patients.addAll(nextPage);
    }
    notifyListeners();
    return Future.value(2);
  }

  Future<void> registerDummyPatient() async {
    print("registerDummyPatient invoked");
    const int numberOfPatients = 5;
    for (int i = 1; i <= numberOfPatients; i++) {
      await _databaseService.savePatient(
        name: 'Patient $i',
        mobileNumber: '+1${Random().nextInt(1000000000)}',
        gender: Random().nextBool() ? 'Male' : 'Female',
        address: 'Address $i',
        allergies: ['a1', 'a2'],
        guardianName: 'Guardian Name $i',
        guardianMobileNumber: '+1${Random().nextInt(1000000000)}',
        guardianGender: Random().nextBool() ? 'Male' : 'Female',
        guardianAddress: 'Guardian Address $i',
        guardianRelation: Random().nextBool() ? 'parent' : 'sibling',
      );
      print("Patient $i inserted");
    }
  }

  Future<void> deleteAllPatients() async {
    print("deleteAllPatients invoked");
    await _databaseService.deleteAllPatients();
    print("deleteAllPatients All Deleted");
  }

  Future<Patient?> fetchPatientById(int patientId) async {
    return _databaseService.fetchPatientById(patientId);
  }

  // Simulated method to generate dummy patients for testing
  List<Patient> _generateDummyPatients(int count) {
    Patient lastPatient;
    int startCount = 0;
    if (_patients.isNotEmpty) {
      lastPatient = _patients.last;
      startCount = lastPatient.id;
      startCount++;
    }

    print("_generateDummyPatients received $count");
    return List.generate(
      count,
      (index) => Patient(
          id: startCount + index,
          name: 'Patient ${startCount + index}',
          address: 'Address ${startCount + index}',
          mobileNumber: '123456789${startCount + index}',
          gender: index % 2 == 0 ? Gender.Male : Gender.Female,
          allergies: ['a1', 'a2']),
    );
  }

  List<Patient> get patients => _patients;

  List<Patient> get searchResults => _searchResults;
  // Add more functions as needed, e.g., searchPatients, editPatient, etc.
}
