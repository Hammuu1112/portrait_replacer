import 'dart:typed_data';

class Portrait {
  String path;  //id
  bool replaced = false;
  Uint8List imageBytes;


  Portrait({required this.path, required this.imageBytes});
}