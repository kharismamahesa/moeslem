import 'package:flutter/foundation.dart';

import '../../../../core/location/app_location.dart';
import '../../../../core/location/location_provider.dart';
import '../../data/services/qibla_calculator.dart';

class QiblaProvider extends ChangeNotifier {
  QiblaProvider(this._location) {
    _location.addListener(_onLocationChanged);
  }

  final LocationProvider _location;

  AppLocation get location => _location.current;
  double get bearing => QiblaCalculator.bearing(_location.current);
  String get directionLabel => QiblaCalculator.directionLabel(bearing);

  void _onLocationChanged() => notifyListeners();

  @override
  void dispose() {
    _location.removeListener(_onLocationChanged);
    super.dispose();
  }
}
