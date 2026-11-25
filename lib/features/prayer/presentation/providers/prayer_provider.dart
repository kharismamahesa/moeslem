import 'package:flutter/foundation.dart';

import '../../../../core/error/api_exception.dart';
import '../../../../core/location/location_provider.dart';
import '../../../../core/state/view_status.dart';
import '../../data/models/prayer_times.dart';
import '../../data/services/prayer_api_service.dart';

class PrayerProvider extends ChangeNotifier {
  PrayerProvider(this._api, this._location) {
    _location.addListener(_onLocationChanged);
    load();
  }

  final PrayerApiService _api;
  final LocationProvider _location;

  ViewStatus _status = ViewStatus.initial;
  PrayerTimes? _times;
  String? _error;
  String? _city;

  ViewStatus get status => _status;
  PrayerTimes? get times => _times;
  String? get error => _error;
  String? get city => _city;

  void _onLocationChanged() {
    _city = null;
    load();
  }

  Future<void> load() async {
    _status = ViewStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _times = _city == null
          ? await _api.fetchByLocation(_location.current)
          : await _api.fetchByCity(_city!);
      _status = ViewStatus.success;
    } on ApiException catch (error) {
      _error = error.message;
      _status = ViewStatus.error;
    } on Exception {
      _error = 'Gagal memuat jadwal shalat.';
      _status = ViewStatus.error;
    }
    notifyListeners();
  }

  Future<void> searchCity(String value) async {
    _city = value.trim().isEmpty ? null : value.trim();
    await load();
  }

  @override
  void dispose() {
    _location.removeListener(_onLocationChanged);
    super.dispose();
  }
}
