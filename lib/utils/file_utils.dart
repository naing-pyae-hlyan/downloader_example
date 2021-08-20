import '../lib.dart';

class FileUtils {
  static Future<Directory> get getDownloadDirectory async =>
      await getApplicationDocumentsDirectory();

  static Future<bool> get requestPermission async {
    PermissionStatus permission = await Permission.storage.status;
    if (permission.isDenied) {
      Map<Permission, PermissionStatus> permissions =
          await [Permission.storage].request();
      if (permissions[Permission.storage] == PermissionStatus.granted)
        return true;
    } else {
      return true;
    }
    return false;
  }
}
