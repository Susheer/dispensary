import 'package:flutter/foundation.dart';

class LandingScreenProvider with ChangeNotifier {
  int _index = 0;

  // Getter for the index property
  int get index => _index;

  // Setter for the index property
  set index(int newIndex) {
    _index = newIndex;
    // Notify listeners that the value has changed
    notifyListeners();
  }
}
