import 'package:permission_handler/permission_handler.dart';

class StoragePermissioner {
  static Future<bool> get arePermissionsGranted async {
    return (await Permission.manageExternalStorage.isGranted) ||
        (await Permission.storage.isGranted);
  }

  static Future<void> requestPermissions() async {
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
  }
}
