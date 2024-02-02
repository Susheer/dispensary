import 'package:dispensary/models/patient.dart';
import 'package:dispensary/services/database_service.dart';
import 'package:flutter/foundation.dart';

class DashboardScreenProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  DashboardScreenProvider(this._databaseService);
  int _newPatients = 0;
  int _followUpatients = 0;
  int _scheduledToday = 0;
  int _scheduledTomorrow = 0;
  double _pendingAmount = 0;

  int get followUpatients => _followUpatients;
  int get newPatients => _newPatients;
  int get scheduledToday => _scheduledToday;
  int get scheduledTomorrow => _scheduledTomorrow;
  double get pendingAmount => _pendingAmount;

  set pendingAmount(double value) {
    _pendingAmount = value;
    notifyListeners();
  }

  set newPatients(int newP) {
    _newPatients = newP;
    notifyListeners();
  }

  set scheduledToday(int newP) {
    _scheduledToday = newP;
    notifyListeners();
  }

  set scheduledTomorrow(int value) {
    _scheduledTomorrow = value;
    notifyListeners();
  }

  set followUpatients(int newfollowUpatients) {
    _followUpatients = newfollowUpatients;
    notifyListeners();
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

  Future<List<Patient>> getFollowUpPatientsToday() async {
    String query =
        ''' SELECT * FROM patients WHERE date(updated_date) == date('now', 'localtime') AND date(created_date) != date('now', 'localtime') 
        ''';
    List<Map<String, dynamic>> result =
        await _databaseService.db.rawQuery(query);

    List<Patient> patients = result.map((map) => Patient.fromMap(map)).toList();
    if (patients.length >= 0) {
      followUpatients = patients.length;
    }
    debugPrint("Follow up length ${patients.length}");
    return patients;
  }

  Future<void>
      calculateTotalPendingAmountForScheduledPatientsOnTommrow() async {
    double total, paid, pending;
    total = paid = pending = 0.0;
    String query =
        ''' select SUM(total_amount) as total, SUM(paid_amount) as paid, (SUM(total_amount) - SUM(paid_amount))  as pending from prescriptions where patient_id in (SELECT id FROM patients WHERE date(scheduled_date) == date('now','+1 day')) 
        ''';
    List<Map<String, dynamic>> result =
        await _databaseService.db.rawQuery(query);
    if (result.isEmpty) {
      return;
    }

    if (!result[0].containsKey('total') ||
        !result[0].containsKey('paid') ||
        !result[0].containsKey('pending')) {
      return;
    }

    if (result[0]['total'] != null && result[0]['total'] >= 0) {
      total = result[0]['total'];
    }

    if (result[0]['paid'] != null && result[0]['paid'] >= 0) {
      paid = result[0]['paid'];
    }

    if (result[0]['pending'] != null && result[0]['pending'] >= 0) {
      pending = result[0]['pending'];
    }

    Map<String, dynamic> op = {
      "total": total,
      "paid": paid,
      "pending": pending
    };
    pendingAmount = pending;
  }

  Future<void> scheduledPatientsToday() async {
    String query =
        ''' SELECT * FROM patients WHERE date(scheduled_date) == date('now', 'localtime')
        ''';
    List<Map<String, dynamic>> result =
        await _databaseService.db.rawQuery(query);

    if (result.isNotEmpty) {
      scheduledToday = result.length;
    } else {
      scheduledToday = 0;
    }
  }

  Future<void> scheduledPatientsTomorrow() async {
    String query =
        ''' SELECT * FROM patients WHERE date(scheduled_date) == date('now','+1 day', 'localtime')
        ''';
    List<Map<String, dynamic>> result =
        await _databaseService.db.rawQuery(query);

    if (result.isNotEmpty) {
      scheduledTomorrow = result.length;
    } else {
      scheduledTomorrow = 0;
    }
  }
}
