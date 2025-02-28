import 'package:portrait_replacer/data/services/user_config_data_service.dart';
import 'package:portrait_replacer/utils/portrait_spec.dart';

class UserConfigDataRepository {
  final UserConfigDataService _service;
  int _width = PortraitSpec.width;
  int _dragDelay = 200;

  UserConfigDataRepository({required UserConfigDataService service})
    : _service = service;

  int get width => _width;

  int get dragDelay => _dragDelay;

  Future<void> getWidth() async {
    _width = await _service.getSavedWidth() ?? _width;
  }

  Future<void> saveWidth(int value) async {
    if (value < 1) {
      value = PortraitSpec.width;
    }
    await _service.saveWidth(value);
    _width = value;
  }

  Future<void> getDragDelay() async {
    _dragDelay = await _service.getSavedDragDelay() ?? _dragDelay;
  }

  Future<void> saveDragDelay(int value) async {
    await _service.saveDragDelay(value);
    _dragDelay = value;
  }
}
