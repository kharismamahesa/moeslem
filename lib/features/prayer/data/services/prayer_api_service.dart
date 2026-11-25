import '../../../../core/constants/app_constants.dart';
import '../../../../core/location/app_location.dart';
import '../../../../core/network/api_client.dart';
import '../models/prayer_times.dart';

class PrayerApiService {
  Future<PrayerTimes> fetchByLocation(AppLocation location) => _fetch('/v1/timings', {
        'latitude': location.latitude.toString(),
        'longitude': location.longitude.toString(),
        'method': AppConstants.prayerMethod,
      });

  Future<PrayerTimes> fetchByCity(String city) => _fetch('/v1/timingsByCity', {
        'city': city,
        'country': 'Indonesia',
        'method': AppConstants.prayerMethod,
      });

  Future<PrayerTimes> _fetch(String path, Map<String, String> query) async {
    final body = await ApiClient.getJson(AppConstants.aladhanBaseUrl, path, query);
    return PrayerTimes.fromJson(body);
  }
}
