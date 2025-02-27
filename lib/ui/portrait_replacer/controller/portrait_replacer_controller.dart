import 'package:flutter/foundation.dart';
import 'package:portrait_replacer/data/models/portrait.dart';
import 'package:portrait_replacer/data/repositories/path_repository.dart';
import 'package:portrait_replacer/data/repositories/portrait_repository.dart';
import 'package:portrait_replacer/data/repositories/user_config_data_repository.dart';

class PortraitReplacerController extends ChangeNotifier {
  final PortraitRepository _portraitRepository;
  final PathRepository _pathRepository;
  final UserConfigDataRepository _userConfigDataRepository;

  PortraitReplacerController({
    required PortraitRepository portraitRepository,
    required UserConfigDataRepository userConfigDataRepository,
    required PathRepository pathRepository,
  }) : _portraitRepository = portraitRepository,
       _userConfigDataRepository = userConfigDataRepository, _pathRepository = pathRepository {
    _init();
  }

  List<Portrait>? get portraits => _portraitRepository.portraits;

  List<Portrait> get hiddenPortraits => _portraitRepository.hiddenPortraits;

  int get width => _userConfigDataRepository.width;

  int get dragDelay => _userConfigDataRepository.dragDelay;

  Future<void> _init() async {
    await _userConfigDataRepository.getWidth();
    await _userConfigDataRepository.getDragDelay();
    notifyListeners();
  }

  Stream<double> load() async* {
    yield* _portraitRepository.loadPortraits();
    notifyListeners();
  }

  void onReorder(int oldIndex, int newIndex) {
    _portraitRepository.reorderPortraits(oldIndex, newIndex);
    notifyListeners();
  }

  Future<void> onReorderEnd() async {
    await _portraitRepository.savePortraitSequence();
  }

  Future<void> updateWidth(double value) async {
    final int parsed = value.toInt();
    await _userConfigDataRepository.saveWidth(parsed);
    notifyListeners();
  }

  Future<void> updateDragDelay(double value) async {
    final int parsed = value.toInt();
    await _userConfigDataRepository.saveDragDelay(parsed);
    notifyListeners();
  }

  Future<void> replacePortrait(String path, int index) async {
    await _portraitRepository.replacePortrait(index, path);
    notifyListeners();
  }

  Future<void> selectNewImage(int index) async {
    final selected = await pickImage();
    if (selected != null) {
      await _portraitRepository.replacePortrait(index, selected);
      notifyListeners();
    }
  }

  Stream<double> fillWithOne(String path) async* {
    yield* _portraitRepository.fillAllPortrait(path, width);
    notifyListeners();
  }

  Future<String?> pickImage() async {
    return await _pathRepository.pickImageFile();
  }

  void hideImage(int index) {
    _portraitRepository.hidePortrait(index);
    notifyListeners();
  }

  void showImage(int index) {
    _portraitRepository.showPortrait(index);
    notifyListeners();
  }

  Future<void> resetImage(int index) async {
    await _portraitRepository.resetPortrait(index);
    notifyListeners();
  }

  Stream<double> resetAllImage() async* {
    yield* _portraitRepository.resetAllPortrait();
    notifyListeners();
  }

  Future<void> saveAllPortraits() async {
    await _portraitRepository.saveAllPortraits();
    notifyListeners();
  }
}
