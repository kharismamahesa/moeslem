import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/surah.dart';
import '../models/surah_detail.dart';

class QuranApiService {
  Future<List<Surah>> fetchSurahs() async {
    final body = await ApiClient.getJson(AppConstants.quranBaseUrl, '/v1/surah');
    final data = body['data'] as List<dynamic>;
    return data
        .map((item) => Surah.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<SurahDetail> fetchSurahDetail(int number) async {
    final body = await ApiClient.getJson(
      AppConstants.quranBaseUrl,
      '/v1/surah/$number/editions/quran-uthmani,id.indonesian',
    );
    return SurahDetail.fromEditions(body['data'] as List<dynamic>);
  }
}
