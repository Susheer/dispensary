import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  static Future<Map<Permission, PermissionStatus>> grantStoragePermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.manageExternalStorage,
      Permission.storage,
    ].request();
    return statuses;
  }

  static Future<bool> canUseStorage() async {
    Map<Permission, PermissionStatus> statuses = await grantStoragePermission();
    if (statuses[Permission.manageExternalStorage] == PermissionStatus.granted || statuses[Permission.storage] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }
}
