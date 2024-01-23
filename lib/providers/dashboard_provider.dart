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

  Future<void> deleteDatabaseAndClear() async {
    debugPrint(" _databaseService.deleteDatabaseAndClear: Invoked");
    await _databaseService.deleteDatabaseAndClear();
    debugPrint(" _databaseService.deleteDatabaseAndClear: Completed");
  }
}
