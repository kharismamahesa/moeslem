import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';

class BookmarkStorage {
  Future<Set<int>> readSurahs() =>
      _read(AppConstants.bookmarksKey, int.parse);

  Future<Set<String>> readAyahs() =>
      _read(AppConstants.ayahBookmarksKey, (value) => value);

  Future<void> writeSurahs(Set<int> values) =>
      _write(AppConstants.bookmarksKey, values);

  Future<void> writeAyahs(Set<String> values) =>
      _write(AppConstants.ayahBookmarksKey, values);

  Future<Set<T>> _read<T>(String key, T Function(String) parse) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(key) ?? []).map(parse).toSet();
  }

  Future<void> _write<T>(String key, Set<T> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      key,
      values.map((value) => value.toString()).toList(growable: false),
    );
  }
}
