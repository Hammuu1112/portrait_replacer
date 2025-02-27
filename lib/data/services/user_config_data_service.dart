import 'package:shared_preferences/shared_preferences.dart';

class UserConfigDataService {
  final String _key;

  UserConfigDataService({required String path}) : _key = path;

  String get _widthKey => "$_key-width";

  String get _dragDelayKey => "drag delay";

  Future<int?> getSavedWidth() async {
    final pref = SharedPreferencesAsync();
    return await pref.getInt(_widthKey);
  }

  Future<void> saveWidth(int width) async {
    final pref = SharedPreferencesAsync();
    await pref.setInt(_widthKey, width);
  }

  Future<int?> getSavedDragDelay() async {
    final pref = SharedPreferencesAsync();
    return await pref.getInt(_dragDelayKey);
  }

  Future<void> saveDragDelay(int delay) async {
    final pref = SharedPreferencesAsync();
    await pref.setInt(_dragDelayKey, delay);
  }
}