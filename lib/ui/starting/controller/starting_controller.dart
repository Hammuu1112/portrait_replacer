import 'dart:async';
import 'package:flutter/material.dart';
import 'package:portrait_replacer/data/repositories/path_repository.dart';
import 'package:portrait_replacer/data/repositories/version_repository.dart';

class StartingController extends ChangeNotifier {
  final PathRepository _pathRepository;
  final VersionRepository _versionRepository;
  TextEditingController textEditingController = TextEditingController();

  StartingController({
    required PathRepository pathRepository,
    required VersionRepository versionRepository,
  }) : _pathRepository = pathRepository,
       _versionRepository = versionRepository {
    _init();
  }

  bool get available => _pathRepository.path.isEmpty ? false : true;

  String get version => _versionRepository.currentVersion?.text ?? "";

  bool get updateAvailable => _versionRepository.updateAvailable;

  Future<void> _init() async {
    textEditingController.text = await _pathRepository.getSavedPath();
    await _versionRepository.getVersions();
    notifyListeners();
  }

  Future<void> selectPath() async {
    String? selectedDirectory = await _pathRepository.selectDirectory();
    if (selectedDirectory != null) {
      textEditingController.text = selectedDirectory;
      notifyListeners();
    }
  }

  Future<void> textChanged(String value) async {
    if (value.isNotEmpty) {
      await _pathRepository.savePath(value);
    } else {
      await _pathRepository.removePath();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
