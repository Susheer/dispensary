import 'dart:async';

import 'package:dispensary/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentUser;
  late StreamSubscription<GoogleSignInAccount?> streamSubscription;
  bool _isAuthorized = false;
  List<String> scopes = <String>[
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ];

  AuthProvider(this._databaseService) {
    debugPrint("AuthProvider: Constructer - invoked");
    _googleSignIn = GoogleSignIn.standard(scopes: scopes);
    streamSubscription = _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      debugPrint("onCurrentUserChanged invoked");
      bool isAuthorized = account != null;
      _currentUser = account;
      _isAuthorized = isAuthorized;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (streamSubscription != null) {
      streamSubscription.cancel();
    }
    debugPrint("Disposing authProvider");
  }

  GoogleSignInAccount? get currentUser => _currentUser;
  set currentUser(GoogleSignInAccount? indentity) {
    _currentUser = indentity;
    notifyListeners();
  }

  GoogleSignIn get googleSignIn => _googleSignIn;

  bool get isAuthorised => _isAuthorized;
  set isAuthorised(bool state) {
    _isAuthorized = state;
    notifyListeners();
  }

  Future<bool> signIn() async {
    try {
      await _googleSignIn.signIn();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> signOut() => _googleSignIn.disconnect();
}
