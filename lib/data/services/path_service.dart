import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PathService {
  final String _key = "target path";

  Future<String?> pickImageFile() async {
    final selected = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: false,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'tif',
        'tiff',
        'bmp',
        'tga',
        'ico',
        'pvr',
        'webp',
        'psd',
        'exr',
        'pbm',
        'pgm',
        'ppm',
      ],
    );
    return selected?.files.first.path;
  }

  Future<String?> pickDirectory() async {
    return await FilePicker.platform.getDirectoryPath();
  }

  bool exists(String path) {
    final directory = Directory(path);
    return directory.existsSync();
  }

  Future<String> getDefaultPath() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    return documentsDir.path + r"\Black Desert\FaceTexture";
  }

  List<String> getBmpFilePathList(String path) {
    final directory = Directory(path);
    return directory
        .listSync()
        .map((item) => item.path)
        .where((path) => path.endsWith(".bmp"))
        .toList();
  }

  Future<String?> getSavedPath() async {
    final pref = SharedPreferencesAsync();
    return await pref.getString(_key);
  }

  Future<void> save(String path) async {
    final pref = SharedPreferencesAsync();
    await pref.setString(_key, path);
  }

  Future<void> remove() async {
    final pref = SharedPreferencesAsync();
    await pref.remove(_key);
  }
}
