import 'package:dispensary/services/database_service.dart';
import 'package:flutter/foundation.dart';

class LandingScreenProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  LandingScreenProvider(this._databaseService);
  int _index = 0;

  // Getter for the index property
  int get index => _index;

  // Setter for the index property
  set index(int newIndex) {
    _index = newIndex;
    // Notify listeners that the value has changed
    notifyListeners();
  }

  Future<void> deleteDatabaseAndClear() async {
    debugPrint(" _databaseService.deleteDatabaseAndClear: Invoked");
    await _databaseService.deleteDatabaseAndClear();
    debugPrint(" _databaseService.deleteDatabaseAndClear: Completed");
  }
}
