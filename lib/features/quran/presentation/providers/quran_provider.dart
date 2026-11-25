import 'package:flutter/foundation.dart';

import '../../../../core/error/api_exception.dart';
import '../../../../core/state/view_status.dart';
import '../../data/local/bookmark_storage.dart';
import '../../data/models/surah.dart';
import '../../data/models/surah_detail.dart';
import '../../data/services/quran_api_service.dart';

class QuranProvider extends ChangeNotifier {
  QuranProvider(this._api, this._storage) {
    loadSurahs();
    loadBookmarks();
  }

  final QuranApiService _api;
  final BookmarkStorage _storage;

  ViewStatus _status = ViewStatus.initial;
  ViewStatus _detailStatus = ViewStatus.initial;
  List<Surah> _surahs = [];
  SurahDetail? _detail;
  int? _detailNumber;
  String? _error;
  String? _detailError;
  String _query = '';
  Set<int> _bookmarks = <int>{};
  Set<String> _ayahBookmarks = <String>{};

  ViewStatus get status => _status;
  ViewStatus get detailStatus => _detailStatus;
  String? get error => _error;
  String? get detailError => _detailError;
  String get query => _query;
  SurahDetail? get detail => _detail;
  Set<int> get bookmarks => Set.unmodifiable(_bookmarks);

  List<Surah> get visibleSurahs {
    final keyword = _query.trim().toLowerCase();
    if (keyword.isEmpty) return _surahs;
    return _surahs.where((surah) {
      return surah.englishName.toLowerCase().contains(keyword) ||
          surah.translation.toLowerCase().contains(keyword) ||
          surah.arabicName.contains(keyword) ||
          surah.number.toString() == keyword;
    }).toList();
  }

  List<Surah> get bookmarkedSurahs =>
      _surahs.where((surah) => _bookmarks.contains(surah.number)).toList();

  List<({int surahNumber, int ayahNumber})> get bookmarkedAyahs {
    final entries = _ayahBookmarks.map((key) {
      final parts = key.split(':');
      return (
        surahNumber: int.tryParse(parts.first) ?? 0,
        ayahNumber: int.tryParse(parts.last) ?? 0,
      );
    }).toList();
    entries.sort((a, b) => a.surahNumber.compareTo(b.surahNumber) == 0
        ? a.ayahNumber.compareTo(b.ayahNumber)
        : a.surahNumber.compareTo(b.surahNumber));
    return entries;
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  Future<void> loadSurahs() async {
    _status = ViewStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _surahs = await _api.fetchSurahs();
      _status = ViewStatus.success;
    } on ApiException catch (error) {
      _error = error.message;
      _status = ViewStatus.error;
    } on Exception {
      _error = 'Gagal memuat daftar surah.';
      _status = ViewStatus.error;
    }
    notifyListeners();
  }

  Future<void> loadBookmarks() async {
    _bookmarks = await _storage.readSurahs();
    _ayahBookmarks = await _storage.readAyahs();
    notifyListeners();
  }

  bool isBookmarked(int number) => _bookmarks.contains(number);

  bool isAyahBookmarked(int surahNumber, int ayahNumber) =>
      _ayahBookmarks.contains('$surahNumber:$ayahNumber');

  Future<void> toggleBookmark(int number) async {
    if (_bookmarks.contains(number)) {
      _bookmarks.remove(number);
    } else {
      _bookmarks.add(number);
    }
    notifyListeners();
    await _storage.writeSurahs(Set<int>.from(_bookmarks));
  }

  Future<void> toggleAyahBookmark(int surahNumber, int ayahNumber) async {
    final key = '$surahNumber:$ayahNumber';
    if (_ayahBookmarks.contains(key)) {
      _ayahBookmarks.remove(key);
    } else {
      _ayahBookmarks.add(key);
    }
    notifyListeners();
    await _storage.writeAyahs(Set<String>.from(_ayahBookmarks));
  }

  Future<void> loadDetail(int number) async {
    if (_detail?.number == number && _detailStatus == ViewStatus.success) {
      return;
    }

    _detailNumber = number;
    _detailStatus = ViewStatus.loading;
    _detailError = null;
    notifyListeners();

    try {
      _detail = await _api.fetchSurahDetail(number);
      _detailStatus = ViewStatus.success;
    } on ApiException catch (error) {
      _detailError = error.message;
      _detailStatus = ViewStatus.error;
    } on Exception {
      _detailError = 'Gagal memuat ayat surah.';
      _detailStatus = ViewStatus.error;
    }
    notifyListeners();
  }

  bool isCurrentDetail(int number) => _detailNumber == number;

  String surahName(int number) {
    final names = _surahs
        .where((surah) => surah.number == number)
        .map((surah) => surah.englishName)
        .toList();
    return names.isEmpty ? 'Surah $number' : names.first;
  }
}
