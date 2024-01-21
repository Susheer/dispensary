// patient_provider.dart
import 'dart:io';
import 'dart:math';

import 'package:dispensary/models/account_model.dart';
import 'package:dispensary/models/prescription_model.dart';
import 'package:flutter/material.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/services/database_service.dart';
import 'package:dispensary/appConfig.dart';

class PatientProvider extends ChangeNotifier {
  List<Patient> _patients = [];
  List<Patient> _searchResults = [];
  int _patientsCount = 0;

  final DatabaseService _databaseService;

  PatientProvider(this._databaseService);

  Future<void> initializePatients() async {
    // Load patients from the database (example)
    _patientsCount = await _databaseService.getPatientsCount();
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

  Future<void> fetchNextPage(int startIndex, int pageSize) async {
    await Future.delayed(const Duration(seconds: 2));
    List<Patient> nextPage =
        await _databaseService.fetchPaginatedPatients(startIndex, pageSize);
    if (nextPage.isEmpty != true) {
      _patients.addAll(nextPage);
      notifyListeners();
    }
  }

  Future<void> registerDummyPatient() async {
    print("registerDummyPatient invoked");
    const int numberOfPatients = 50;
    for (int i = 1; i <= numberOfPatients; i++) {
      await _databaseService.savePatient(
        name: 'Patient $i',
        mobileNumber: '+1${Random().nextInt(1000000000)}',
        gender: Random().nextBool() ? 'Male' : 'Female',
        address: 'Address $i',
        allergies: 'Peanuts, Pollen, Dust Mites, Shellfish, Latex'.split(','),
        guardianName: 'Guardian Name $i',
        guardianMobileNumber: '+1${Random().nextInt(1000000000)}',
        guardianGender: Random().nextBool() ? 'Male' : 'Female',
        guardianAddress: 'Guardian Address $i',
        guardianRelation: Random().nextBool() ? 'parent' : 'sibling',
      );
      initializePatients();
      print("Patient $i inserted");
    }
  }

  Future<void> deleteAllPatients() async {
    print("deleteAllPatients invoked");
    await _databaseService.deleteAllPatients();
    _patients.clear();
    notifyListeners();
    print("deleteAllPatients All Deleted");
  }

  Future<bool> updateGuardianByPatientId(Patient p) async {
    Map<String, String> obj = {
      'guardianName': p.guardianName ?? "",
      'guardianMobileNumber': p.guardianMobileNumber ?? "",
      'guardianGender':
          Patient.parseGenderToString(p.guardianGender ?? Gender.Other),
      'guardianAddress': p.guardianAddress ?? "",
      'guardianRelation':
          Patient.parseRelationToString(p.relation ?? GuardianRelation.Other),
    };

    int totalRowAffected =
        await _databaseService.updatePatientByPatientId(id: p.id, obj: obj);
    if (totalRowAffected >= 1) {
      return true;
    }
    return false;
  }

  Future<bool> updatePatientByPatientId(Patient p) async {
    Map<String, String> obj = {
      'name': p.name ?? "",
      'mobileNumber': p.mobileNumber ?? "",
      'gender': Patient.parseGenderToString(p.gender),
      'address': p.address ?? "",
      'allergies': p.allergies.join(',')
    };

    int totalRowAffected =
        await _databaseService.updatePatientByPatientId(id: p.id, obj: obj);
    if (totalRowAffected >= 1) {
      return true;
    }
    return false;
  }

  Future<Patient?> fetchPatientById(int patientId) async {
    return _databaseService.fetchPatientById(patientId);
  }

  void deleteMe(int patientId) async {
    await _databaseService.deletePatientById(patientId);
    _patients = _patients.where((el) => el.id != patientId).toList();
    _patientsCount = await _databaseService.getPatientsCount();
    notifyListeners();
  }

  void updatePatientInList(Patient p) async {
    int index = _patients.indexWhere((patient) => patient.id == p.id);
    if (index != -1) {
      _patients[index] = p;
      notifyListeners();
    }
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
  void refreshList() {
    List<Patient> tempList = [];
    tempList.addAll(_patients);
    _patients = tempList;
    notifyListeners();
  }

  int get patientsCount => _patientsCount;
  List<Patient> get searchResults => _searchResults;

  Future<Account?> getAccount(int patientId) async {
    debugPrint("getAccount invoked");
    String sql = '''
    SELECT SUM(total_amount) AS total_amount,
    SUM(paid_amount) AS total_paid_amount,
    (SUM(total_amount) - SUM(paid_amount)) AS total_pending_amount
    FROM prescriptions
    WHERE
    patient_id = $patientId;
    ''';

    final List<Map<String, dynamic>> result =
        await _databaseService.db.rawQuery(sql);
    Account? account;
    Map<String, dynamic>? obj = null;
    if (result.isEmpty) {
      return null;
    }
    obj = result[0];
    if (obj == null ||
        obj['total_amount'] == null ||
        obj['total_paid_amount'] == null ||
        obj['total_pending_amount'] == null) {
      return null;
    }

    debugPrint("Inside not empty tset");
    debugPrint(obj.toString());
    account = Account.fromMap(result.elementAt(0));
    return account;
  }

  Future<Prescription?> getLastprescription(int patientId) async {
    return null;
  }
}
