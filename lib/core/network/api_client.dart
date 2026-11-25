import 'dart:convert';

import 'package:http/http.dart' as http;

import '../error/api_exception.dart';

abstract final class ApiClient {
  static final http.Client _client = http.Client();

  static Future<Map<String, dynamic>> getJson(
    String baseUrl,
    String path, [
    Map<String, String> query = const {},
  ]) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw ApiException('Server tidak merespons (${response.statusCode}).');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['code'] is num && body['code'] != 200) {
        throw ApiException(body['status']?.toString() ?? 'Permintaan gagal.');
      }
      return body;
    } on ApiException {
      rethrow;
    } on Exception catch (error) {
      throw ApiException('Tidak terhubung ke internet. $error');
    }
  }
}
