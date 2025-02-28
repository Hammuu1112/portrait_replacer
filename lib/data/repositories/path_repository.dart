import 'package:portrait_replacer/data/services/path_service.dart';

class PathRepository {
  final PathService _service;
  String path = "";

  PathRepository({required PathService service}) : _service = service {
    _init();
  }

  Future<void> _init() async {
    final savedPath = await getSavedPath();
    _updatePath(savedPath);
  }

  Future<String> getSavedPath() async {
    return await _service.getSavedPath() ?? await _service.getDefaultPath();
  }

  Future<void> savePath(String value) async {
    await _service.save(value);
    _updatePath(value);
  }

  Future<void> removePath() async {
    await _service.remove();
    path = "";
  }

  void _updatePath(String newPath) {
    final result = _service.exists(newPath);
    if (result) {
      path = newPath;
    } else {
      path = "";
    }
  }

  Future<String?> pickImageFile() async {
    return await _service.pickImageFile();
  }

  Future<String?> selectDirectory() async {
    final selected = await _service.pickDirectory();
    if (selected != null && selected.isNotEmpty) {
      await savePath(selected);
    }
    return selected;
  }
}
