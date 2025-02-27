import 'package:portrait_replacer/data/models/portrait.dart';
import 'package:portrait_replacer/data/services/image_service.dart';
import 'package:portrait_replacer/data/services/path_service.dart';
import 'package:portrait_replacer/data/services/portrait_service.dart';
import 'package:portrait_replacer/utils/portrait_spec.dart';
import 'package:portrait_replacer/utils/result.dart';

import 'package:worker_manager/worker_manager.dart';

class PortraitRepository {
  final PortraitService _portraitService;
  final ImageService _imageService;
  final PathService _pathService;
  final String _path;
  List<Portrait>? portraits;
  List<Portrait> hiddenPortraits = [];

  PortraitRepository({
    required PortraitService portraitService,
    required ImageService imageService,
    required PathService pathService,
    required String path,
  }) : _portraitService = portraitService,
       _imageService = imageService,
       _pathService = pathService,
       _path = path;

  Stream<double> loadPortraits() async* {
    final filePathList = _pathService.getBmpFilePathList(_path);
    List<String> portraitSequence =
        await _portraitService.getPortraitSequence() ?? filePathList;
    final hidden = await _portraitService.getHiddenPortraits();

    yield 0;

    List<Portrait> result = [];
    List<Portrait> hiddenResult = [];

    for (var index=0;index<filePathList.length;index++) {
      final image = await _imageService.getImageFromPath(filePathList[index]);
      switch (image) {
        case Ok():
          final portrait = Portrait(
            path: filePathList[index],
            imageBytes: _imageService.imageToBytes(image.value),
          );
          if(hidden.contains(filePathList[index])){
            hiddenResult.add(portrait);
          } else {
            result.add(portrait);
          }
        case Error():
          portraitSequence.remove(filePathList[index]);
      }
      yield (index + 1) / filePathList.length;
    }

    result.sort((a, b) => _sortPortrait(portraitSequence, a, b));

    /*
    * 초상화 수(=캐릭터 수)에 변화가 있을 경우 대비 목록 업데이트
    */
    portraitSequence = result.map((item) => item.path).toList();

    portraits = result;
    hiddenPortraits = hiddenResult;
  }

  void reorderPortraits(int oldIndex, int newIndex) {
    if (portraits != null) {
      final selectedPortrait = portraits!.removeAt(oldIndex);
      portraits!.insert(newIndex, selectedPortrait);
    }
  }

  Future<void> replacePortrait(int index, String path) async {
    final image = await _imageService.getImageFromPath(path);
    if (image is Ok) {
      final resizedImage = await workerManager.execute(() {
        return _imageService.resizeImage(
          (image as Ok).value,
          PortraitSpec.width,
          PortraitSpec.height,
        );
      });
      portraits?[index].imageBytes = _imageService.imageToBytes(resizedImage);
      portraits?[index].replaced = true;
    }
  }

  Stream<double> fillAllPortrait(String path, int horizontalCount) async* {
    if (portraits == null || portraits!.isEmpty) {
      return;
    }
    final verticalCount = (portraits!.length / horizontalCount).ceil();
    yield 0;

    final image = await _imageService.getImageFromPath(path);
    yield 1 / 4;

    if (image is Ok) {
      final resizedImage = await workerManager.execute((){
        return _imageService.resizeImage(
          (image as Ok).value,
          PortraitSpec.width * horizontalCount,
          PortraitSpec.height * verticalCount,
        );
      });
      yield 2 / 4;

      final pieces = await workerManager.execute((){
        return _imageService.splitImage(
          image: resizedImage,
          horizontalCount: horizontalCount,
          verticalCount: verticalCount,
        );
      });
      yield 3 / 4;

      for (var index = 0; index < portraits!.length; index++) {
        portraits![index].imageBytes = _imageService.imageToBytes(pieces[index]);
        portraits![index].replaced = true;
        yield ((index / portraits!.length) + 3) / 4;
      }
    }
  }

  Future<void> saveAllPortraits() async {
    if (portraits != null) {
      await workerManager.execute<void>(() async {
        for (Portrait portrait in portraits!) {
          if (portrait.replaced) {
            final image = _imageService.bytesToImage(portrait.imageBytes);
            if (image != null) {
              final result = await _imageService.saveImage(image, portrait.path);
              if (result) {
                portrait.replaced = false;
              }
            }
          }
        }
      });
    }
  }

  Future<void> savePortraitSequence() async {
    if (portraits != null) {
      await _portraitService.savePortraitSequence(
        portraits!.map((item) => item.path).toList(),
      );
    }
  }

  void hidePortrait(int index) {
    if (portraits != null) {
      final selected = portraits!.removeAt(index);
      hiddenPortraits.add(selected);
      savePortraitSequence();
      _portraitService.saveHiddenPortraits(
        hiddenPortraits.map((item) => item.path).toList(),
      );
    }
  }

  void showPortrait(int index) {
    if (portraits != null) {
      final selected = hiddenPortraits.removeAt(index);
      portraits!.add(selected);
      savePortraitSequence();
      _portraitService.saveHiddenPortraits(
        hiddenPortraits.map((item) => item.path).toList(),
      );
    }
  }

  Stream<double> resetAllPortrait() async* {
    if (portraits?.isNotEmpty ?? false) {
      int length = portraits!.length;
      yield 0;
      for(var index=0;index<length;index++){
        final image = await _imageService.getImageFromPath(portraits![index].path);
        if (image is Ok) {
          portraits![index].imageBytes = _imageService.imageToBytes(
            (image as Ok).value,
          );
          portraits![index].replaced = false;
        }
        yield (index + 1) / length;
      }
    }
  }

  Future<void> resetPortrait(int index) async {
    if (portraits != null) {
      final image = await _imageService.getImageFromPath(
        portraits![index].path,
      );
      if (image is Ok) {
        portraits![index].imageBytes = _imageService.imageToBytes(
          (image as Ok).value,
        );
        portraits![index].replaced = false;
      }
    }
  }

  int _sortPortrait(List<String> table, Portrait a, Portrait b) {
    int aa = table.contains(a.path) ? table.indexOf(a.path) : 999;
    int bb = table.contains(b.path) ? table.indexOf(b.path) : 999;
    return aa.compareTo(bb);
  }
}
