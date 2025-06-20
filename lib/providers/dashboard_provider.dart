import 'dart:ffi';

import 'package:dispensary/models/patient.dart';
import 'package:dispensary/services/database_service.dart';
import 'package:flutter/foundation.dart';

class DashboardScreenProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  double _pendingAmount = 0;
  DashboardScreenProvider(this._databaseService) {
    // Fetch data after the provider is initialized
    Future.delayed(Duration.zero, () {
      //calculateTotalPendingAmountForScheduledPatientsOnTommrow();
      //scheduledPatientsToday();
      //scheduledPatientsTomorrow();
    });
  }

  int _newPatients = 0;
  int _followUpatients = 0;
  int _scheduledToday = 0;
  int _scheduledTomorrow = 0;

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

  Future<void> calculateTotalPendingAmountForScheduledPatientsOnTommrow() async {
    _databaseService.calculateTotalsInBatches(500).then((response) {
      pendingAmount = response['pending'] as double? ?? 0;
    }).catchError;
  }

  Future<void> scheduledPatientsTomorrow(int length) async {
    int count = await _databaseService.getTotalappointmentScheduledNextDayV1();
    scheduledTomorrow = count;
  }

  Future<void> updateCounts() async {
    Map<String, int> counts = await _databaseService.getCountsV1();
    _scheduledToday = counts['scheduled_today'] as int;
    _scheduledTomorrow = counts['scheduled_next_day'] as int;
    _followUpatients = counts['followups_today'] as int;
    _newPatients = counts['created_today'] as int;
    notifyListeners();
  }
}
