<<<<<<< HEAD:lib/core/plugins/storage_permissioner.dart
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
=======
import 'package:permission_handler/permission_handler.dart';

class StoragePermissionGranter {
  static Future<bool> get arePermissionsGranted async {
    return (await Permission.manageExternalStorage.isGranted) ||
        (await Permission.storage.isGranted);
  }

  static Future<void> requestPermissions() async {
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
  }
}
>>>>>>> 3dd1ed906b04a9df2f5ddf01d804006534dfe65f:lib/core/plugins/storage_permission_granter.dart
