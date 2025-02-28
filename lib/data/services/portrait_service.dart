import 'package:portrait_replacer/utils/portrait_spec.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PortraitService {
  final String _key;

  PortraitService({required String path}) : _key = path;

  String get _portraitSequenceKey => "$_key-sequence";
  String get _hiddenPortraitsKey => "$_key-hidden";

  Future<List<String>?> getPortraitSequence() async {
    final pref = SharedPreferencesAsync();
    return await pref.getStringList(_portraitSequenceKey);
  }

  Future<void> savePortraitSequence(List<String> list) async {
    final pref = SharedPreferencesAsync();
    await pref.setStringList(_portraitSequenceKey, list);
  }

  Future<List<String>> getHiddenPortraits() async {
    final pref = SharedPreferencesAsync();
    return await pref.getStringList(_hiddenPortraitsKey) ?? [];
  }

  Future<void> saveHiddenPortraits(List<String> list) async {
    final pref = SharedPreferencesAsync();
    await pref.setStringList(_hiddenPortraitsKey, list);
  }
}
