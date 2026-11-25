import 'package:flutter/foundation.dart';

import 'location_service.dart';
import 'app_location.dart';

class LocationProvider extends ChangeNotifier {
  LocationProvider(this._service);

  final LocationService _service;

  AppLocation _current = AppLocation.pekanbaru;
  bool _isLocating = false;
  String? _message;

  AppLocation get current => _current;
  bool get isLocating => _isLocating;
  String? get message => _message;

  Future<void> useDeviceLocation() async {
    _isLocating = true;
    _message = null;
    notifyListeners();

    final location = await _service.requestCurrent();

    _isLocating = false;
    if (location == null) {
      _message = 'Lokasi tidak tersedia. Pastikan izin lokasi aktif.';
    } else {
      _current = location;
      _message = 'Lokasi berhasil diperbarui.';
    }
    notifyListeners();
  }

  void useDefault() {
    if (_current.isDefault) return;
    _current = AppLocation.pekanbaru;
    _message = null;
    notifyListeners();
  }
}
