// patient_provider.dart
import 'dart:math';
import 'package:dispensary/models/account_model.dart';
import 'package:dispensary/utils.dart/util.dart';
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
    _patients = await _databaseService.fetchPaginatedPatients(0, AppConfig.PageSize);
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
    required DateTime createdDate,
    required DateTime updatedDate,
    DateTime? scheduledDate,
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
        id: _patients.length + 1, // Assuming the id is auto-incremented by the database
        name: name,
        mobileNumber: mobileNumber,
        gender: Patient.parseGender(gender),
        address: address,
        allergies: allergies,
        guardianName: guardianName,
        guardianMobileNumber: guardianMobileNumber,
        guardianGender: gen,
        guardianAddress: guardianAddress,
        relation: rel,
        createdDate: createdDate,
        updatedDate: updatedDate,
        scheduledDate: scheduledDate);

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
        guardianRelation: relation ?? "",
        isoCreatedDate: newPatient.createdDate.toIso8601String(),
        isoUpdatedDate: newPatient.updatedDate.toIso8601String(),
        isoScheduledDate: newPatient.scheduledDate?.toIso8601String() ?? "");
  }

  Future<int> getPatientsCount() {
    return _databaseService.getPatientsCount();
  }

  Future<List<Patient>> searchPatients({
    String name = "",
    String mobileNumber = "",
    String? gender = "",
  }) async {
    const String tabelName = "patients";
    List<String> whereClause = [];
    String query = "SELECT * FROM $tabelName";
    if (name != "") {
      whereClause.add("UPPER(name) LIKE UPPER('%$name%')");
    }

    if (gender != "") {
      if (whereClause.isNotEmpty) {
        whereClause.add(" AND UPPER(gender) == UPPER('$gender')");
      } else {
        whereClause.add(" UPPER(gender) == UPPER('$gender')");
      }
    }

    if (mobileNumber != "") {
      if (whereClause.isNotEmpty) {
        whereClause.add(" AND UPPER(mobileNumber) LIKE UPPER('%$mobileNumber%')");
      } else {
        whereClause.add(" UPPER(mobileNumber) LIKE UPPER('%$mobileNumber%')");
      }
    }
    if (whereClause.isNotEmpty) {
      query += " WHERE ${whereClause.join()}";
    }

    query += " limit 10";
    debugPrint("Query- $query");
    final List<Map<String, dynamic>> result = await _databaseService.db.rawQuery(query);
    List<Patient> list = result.map((obj) {
      Map<String, dynamic> record = Map.from(obj);
      record['created_date'] = convertUnixTimeStampToDatetime(record['created_date']).toIso8601String();
      record['updated_date'] = convertUnixTimeStampToDatetime(record['updated_date']).toIso8601String();
      record['scheduled_date'] = convertUnixTimeStampToDatetime(record['scheduled_date']).toIso8601String();
      return Patient.fromMap(record);
    }).toList();
    return list;
  }

  Future<void> fetchNextPage(int startIndex, int pageSize) async {
    await Future.delayed(const Duration(seconds: 2));
    List<Patient> nextPage = await _databaseService.fetchPaginatedPatients(startIndex, pageSize);
    if (nextPage.isEmpty != true) {
      _patients.addAll(nextPage);
      notifyListeners();
    }
  }

  String isoStringFromNow(Duration days) {
    return DateTime.now().subtract(days).toIso8601String();
  }

  Future<void> registerDummyPatient() async {
    const int numberOfPatients = 5;
    int start = 0;
    List<Map<String, dynamic>> list = await _databaseService.db.query('patients', columns: ['id'], limit: 1, orderBy: 'id desc');
    if (list.isNotEmpty && list[0].containsKey('id')) {
      if (list[0]['id'] != null && list[0]['id'] != "" && list[0]['id'] >= 0) {
        start = list[0]['id'];
      }
    }
    for (int i = 1; i <= numberOfPatients; i++) {
      await _databaseService.savePatient(
          name: 'Patient-${i + start}',
          mobileNumber: '+1${Random().nextInt(1000000000)}',
          gender: Random().nextBool() ? 'Male' : 'Female',
          address: 'Address-${i + start}',
          allergies: 'Peanuts, Pollen, Dust Mites, Shellfish, Latex'.split(','),
          guardianName: 'Guardian Name ${i + start}',
          guardianMobileNumber: '+1${Random().nextInt(1000000000)}',
          guardianGender: Random().nextBool() ? 'Male' : 'Female',
          guardianAddress: 'Guardian Address-${i + start}',
          guardianRelation: Random().nextBool() ? 'parent' : 'sibling',
          isoCreatedDate: isoStringFromNow(const Duration(days: 1)),
          isoUpdatedDate: DateTime.now().toIso8601String(), //isoStringFromNow(const Duration(days: 10)),
          isoScheduledDate: ''); //isoStringFromNow(const Duration(days: 1)));
      debugPrint("Patient ${i + start} inserted");
    }
    initializePatients();
  }

  Future<void> deleteAllPatients() async {
    print("deleteAllPatients invoked");
    await _databaseService.deleteAllPatients();
    _patients.clear();
    notifyListeners();
    print("deleteAllPatients All Deleted");
  }

  Future<bool> updateGuardianByPatientId(Patient p) async {
    Map<String, dynamic> obj = {
      'guardianName': p.guardianName ?? "",
      'guardianMobileNumber': p.guardianMobileNumber ?? "",
      'guardianGender': Patient.parseGenderToString(p.guardianGender ?? Gender.Other),
      'guardianAddress': p.guardianAddress ?? "",
      'guardianRelation': Patient.parseRelationToString(p.relation ?? GuardianRelation.Other),
      'updated_date': convertISODateStringToUnixTimestampInSeconds(p.updatedDate.toIso8601String())
    };

    int totalRowAffected = await _databaseService.updatePatientByPatientId(id: p.id, obj: obj);
    if (totalRowAffected >= 1) {
      return true;
    }
    return false;
  }

  Future<bool> updatePatientByPatientId(Patient p) async {
    Map<String, dynamic> obj = {
      'name': p.name ?? "",
      'mobileNumber': p.mobileNumber ?? "",
      'gender': Patient.parseGenderToString(p.gender),
      'address': p.address ?? "",
      'allergies': p.allergies.join(','),
      'updated_date': convertISODateStringToUnixTimestampInSeconds(p.updatedDate.toIso8601String())
    };

    int totalRowAffected = await _databaseService.updatePatientByPatientId(id: p.id, obj: obj);
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
          allergies: ['a1', 'a2'],
          createdDate: DateTime.now(),
          updatedDate: DateTime.now(),
          scheduledDate: null),
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

    final List<Map<String, dynamic>> result = await _databaseService.db.rawQuery(sql);
    Account? account;
    Map<String, dynamic>? obj = null;
    if (result.isEmpty) {
      return null;
    }
    obj = result[0];
    if (obj == null || obj['total_amount'] == null || obj['total_paid_amount'] == null || obj['total_pending_amount'] == null) {
      return null;
    }

    debugPrint("Inside not empty tset");
    debugPrint(obj.toString());
    account = Account.fromMap(result.elementAt(0));
    return account;
  }

  Future<void> updateScheduledDate(int id, String newDate) async {
    Map<String, dynamic> obj = {
      'scheduled_date': convertISODateStringToUnixTimestampInSeconds(newDate),
      'updated_date': convertISODateStringToUnixTimestampInSeconds(DateTime.now().toIso8601String()),
    };
    await _databaseService.updatePatientByPatientId(id: id, obj: obj);
  }
}
