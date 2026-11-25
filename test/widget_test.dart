import 'package:flutter_test/flutter_test.dart';
import 'package:moeslem/core/location/app_location.dart';
import 'package:moeslem/core/utils/formatters.dart';
import 'package:moeslem/features/qibla/data/services/qibla_calculator.dart';

void main() {
  group('QiblaCalculator', () {
    test('bearing from Pekanbaru is in the north-west quadrant', () {
      final bearing = QiblaCalculator.bearing(AppLocation.pekanbaru);

      expect(bearing, greaterThan(270));
      expect(bearing, lessThan(360));
    });

    test('bearing is normalized between 0 and 360 degrees', () {
      final bearing = QiblaCalculator.bearing(
        const AppLocation(
          latitude: -6.2,
          longitude: 106.8,
          label: 'Jakarta',
        ),
      );

      expect(bearing, greaterThanOrEqualTo(0));
      expect(bearing, lessThanOrEqualTo(360));
    });

    test('direction label follows clockwise compass points', () {
      expect(QiblaCalculator.directionLabel(0), 'Utara');
      expect(QiblaCalculator.directionLabel(90), 'Timur');
      expect(QiblaCalculator.directionLabel(180), 'Selatan');
      expect(QiblaCalculator.directionLabel(270), 'Barat');
    });
  });

  test('formatCountdown pads each unit with two digits', () {
    expect(formatCountdown(const Duration(hours: 1, minutes: 2, seconds: 3)),
        '01:02:03');
  });
}
