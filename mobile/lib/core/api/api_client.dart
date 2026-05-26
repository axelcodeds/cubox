import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/algorithms/models/algorithm.dart';

class ApiClient {
  ApiClient({required String baseUrl, http.Client? httpClient})
    : baseUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl,
      _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _httpClient;

  Future<List<Algorithm>> fetchPllAlgorithms() async {
    final response = await _get('/api/v1/cases?category=PLL');
    final payload = jsonDecode(response.body);

    if (payload is! List) {
      throw const ApiException('Unexpected cases response from API.');
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map(Algorithm.fromJson)
        .toList(growable: false);
  }

  Future<Algorithm> fetchRandomPllCase() async {
    final response = await _get('/api/v1/random?category=PLL');
    final payload = jsonDecode(response.body);

    if (payload is! Map<String, dynamic>) {
      throw const ApiException('Unexpected random case response from API.');
    }

    return Algorithm.fromJson(payload);
  }

  Future<http.Response> _get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    late final http.Response response;

    try {
      response = await _httpClient.get(uri).timeout(const Duration(seconds: 8));
    } catch (_) {
      throw const ApiException('Unable to connect to the Cubox API.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('API request failed with status ${response.statusCode}.');
    }

    return response;
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
