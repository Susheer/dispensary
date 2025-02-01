import 'package:dispensary/models/patient.dart';
import 'package:dispensary/services/database_service.dart';
import 'package:flutter/foundation.dart';

class DashboardScreenProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  DashboardScreenProvider(this._databaseService) {
    // Fetch data after the provider is initialized
    Future.delayed(Duration.zero, () {
      //getPatientsCreatedToday();
      //getFollowUpPatientsToday();
      //calculateTotalPendingAmountForScheduledPatientsOnTommrow();
      //scheduledPatientsToday();
      //scheduledPatientsTomorrow();
    });
  }

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
    // String query = "SELECT * FROM patients WHERE DATE(created_date) = date('now', 'localtime')";
    // List<Map<String, dynamic>> result = await _databaseService.db.rawQuery(query);

    // List<Patient> patients = result.map((map) => Patient.fromMap(map)).toList();
    // if (_newPatients != patients.length) {
    //   _newPatients = patients.length;
    // }
    // notifyListeners();
    // return patients;
    return [];
  }

  Future<List<Patient>> getFollowUpPatientsToday() async {
    // String query =
    //     ''' SELECT * FROM patients
    //WHERE date(updated_date) == date('now', 'localtime') AND
    //date(created_date) != date('now', 'localtime')
    //     ''';
    // List<Map<String, dynamic>> result = await _databaseService.db.rawQuery(query);

    // List<Patient> patients = result.map((map) => Patient.fromMap(map)).toList();
    // if (patients.length >= 0) {
    //   followUpatients = patients.length;
    // }
    // debugPrint("Follow up length ${patients.length}");
    return [];
  }

  Future<void> calculateTotalPendingAmountForScheduledPatientsOnTommrow() async {
    _databaseService.calculateTotalsInBatches(500).then((response) {
      debugPrint('---------------------Pending amount ${response['pending']}');
      pendingAmount = response['pending'] as double? ?? 0;
    }).catchError((e) => {debugPrint('Error in caalculation ${e.toString()}')});
  }

  Future<void> scheduledPatientsToday() async {
    // String query = ''' SELECT * FROM patients WHERE date(scheduled_date) == date('now', 'localtime')
    //     ''';
    // List<Map<String, dynamic>> result = await _databaseService.db.rawQuery(query);

    // if (result.isNotEmpty) {
    //   scheduledToday = result.length;
    // } else {
    //   scheduledToday = 0;
    // }
  }

  Future<void> scheduledPatientsTomorrow() async {
    // String query =
    //     ''' SELECT * FROM patients WHERE date(scheduled_date) == date('now','+1 day', 'localtime')
    //     ''';
    // List<Map<String, dynamic>> result =
    //     await _databaseService.db.rawQuery(query);

    // if (result.isNotEmpty) {
    //   scheduledTomorrow = result.length;
    // } else {
    //   scheduledTomorrow = 0;
    // }

    scheduledTomorrow = 222;
  }
}
