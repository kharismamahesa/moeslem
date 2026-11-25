import 'package:geolocator/geolocator.dart';

import 'app_location.dart';

class LocationService {
  Future<AppLocation?> requestCurrent() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return AppLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        label: 'Lokasi saya',
      );
    } on Exception {
      return null;
    }
  }
}
