import 'dart:typed_data';

class Portrait {
  ///Original image path
  String path;  //id
  bool replaced = false;
  Uint8List imageBytes;


  Portrait({required this.path, required this.imageBytes});
}