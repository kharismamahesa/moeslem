import 'dart:math' as math;

import '../../../../core/location/app_location.dart';

abstract final class QiblaCalculator {
  static const kaabaLatitude = 21.4225;
  static const kaabaLongitude = 39.8262;

  static double bearing(AppLocation from) {
    final fromLat = _toRadians(from.latitude);
    final toLat = _toRadians(kaabaLatitude);
    final deltaLongitude = _toRadians(kaabaLongitude - from.longitude);

    final y = math.sin(deltaLongitude) * math.cos(toLat);
    final x = math.cos(fromLat) * math.sin(toLat) -
        math.sin(fromLat) * math.cos(toLat) * math.cos(deltaLongitude);

    final degrees = math.atan2(y, x) * 180 / math.pi;
    return (degrees + 360) % 360;
  }

  static String directionLabel(double degrees) {
    const directions = [
      'Utara',
      'Timur Laut',
      'Timur',
      'Tenggara',
      'Selatan',
      'Barat Daya',
      'Barat',
      'Barat Laut',
    ];
    final index = ((degrees + 22.5) ~/ 45) % 8;
    return directions[index];
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;
}
