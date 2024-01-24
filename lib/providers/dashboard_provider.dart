import 'package:dispensary/models/patient.dart';
import 'package:dispensary/services/database_service.dart';
import 'package:flutter/foundation.dart';

class DashboardScreenProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  DashboardScreenProvider(this._databaseService);
  int _newPatients = 0;
  int _followUpatients = 0;

  int get followUpatients => _followUpatients;
  int get newPatients => _newPatients;

  set newPatients(int newP) {
    _newPatients = newP;
    notifyListeners();
  }

  set followUpatients(int newfollowUpatients) {
    _followUpatients = newfollowUpatients;
    notifyListeners();
  }

  Future<void> updatedPatients() async {
    await this._databaseService.db.query("");
  }

  Future<List<Patient>> getPatientsCreatedToday() async {
    String query =
        "SELECT * FROM patients WHERE DATE(created_date) = date('now', 'localtime')";
    List<Map<String, dynamic>> result =
        await _databaseService.db.rawQuery(query);

    List<Patient> patients = result.map((map) => Patient.fromMap(map)).toList();
    if (_newPatients != patients.length) {
      _newPatients = patients.length;
    }
    notifyListeners();
    return patients;
  }

  Future<void> scheduledPatients() async {}
}
