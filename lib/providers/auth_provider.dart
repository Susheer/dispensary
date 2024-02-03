import 'package:dispensary/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  List<String> scopes = <String>[
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ];

  AuthProvider(this._databaseService){
    _googleSignIn = GoogleSignIn.standard(scopes: scopes);
  }

  GoogleSignInAccount? get currentUser => _currentUser;
  set currentUser(GoogleSignInAccount? indentity){
    _currentUser = indentity;
    notifyListeners();
  }

  GoogleSignIn get googleSignIn => _googleSignIn;

  bool get isAuthorised => _isAuthorized;
  set isAuthorised(bool state){
    _isAuthorized = state;
    notifyListeners();
  }

  Future<void> signIn() async {
    print("------ signIn Invoked ---------");
    try {
      await _googleSignIn.signIn();
      print("------ signIn Completed ---------");
    } catch (error) {
      print("------ signIn Error ---------");
      print(error);
    }
  }

  Future<void> deleteDatabaseAndClear() async {
    debugPrint(" _databaseService.deleteDatabaseAndClear: Invoked");
    await _databaseService.deleteDatabaseAndClear();
    debugPrint(" _databaseService.deleteDatabaseAndClear: Completed");
  }
  Future<void> signOut() => _googleSignIn.disconnect();
}
