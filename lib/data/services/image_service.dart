import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'package:portrait_replacer/utils/result.dart';

class ImageService {
  Future<Result<img.Image>> getImageFromPath(String path) async {
    img.Image? image = await img.decodeImageFile(path);
    if(image?.hasAnimation ?? false){
      image!.frames = image.frames.take(1).toList();
    }
    if (image != null) {
      return Result.ok(image);
    }
    return Result.error(Exception("Failed to decode image. Path: $path"));
  }

  img.Image? bytesToImage(Uint8List bytes) => img.decodePng(bytes);

  Uint8List imageToBytes(img.Image image) => img.encodePng(image);

  img.Image resizeImage(img.Image image, int width, int height) {
    if (image.width != width || image.height != height) {
      return img.copyResize(
        image,
        interpolation: img.Interpolation.cubic,
        width: width,
        height: height,
      );
    }
    return image;
  }

  List<img.Image> splitImage({
    required img.Image image,
    required int horizontalCount,
    required int verticalCount,
  }) {
    final pieceWidth = (image.width / horizontalCount).round();
    final pieceHeight = (image.height / verticalCount).round();
    final List<img.Image> result = [];

    for (var y = 0; y < image.height; y += pieceHeight) {
      for (var x = 0; x < image.width; x += pieceWidth) {
        final piece = img.copyCrop(
          image,
          x: x,
          y: y,
          width: pieceWidth,
          height: pieceHeight,
        );
        result.add(piece);
      }
    }
    return result;
  }

  Future<bool> saveImage(img.Image image, String path) async {
    return await img.encodeBmpFile(path, image);
  }
}
