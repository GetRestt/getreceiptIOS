
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateExternalFolder {
  static Future<String> createFolder() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception("Storage permission not granted");
    }

    final exDir = await getApplicationDocumentsDirectory();
    if (exDir == null) {
      throw Exception("External storage not available");
    }

    final dir = Directory('${exDir.path}/GetReceipt');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  static Future<String> createSubFolder(String subFolderName) async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception("Storage permission not granted");
    }

    final exDir = await getApplicationDocumentsDirectory();
    if (exDir == null) {
      throw Exception("External storage not available");
    }

    final dir = Directory('${exDir.path}/GetReceipt/$subFolderName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }
}
