import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpClient {
  HttpClient({required this.base});

  final String base;

  Future<http.Response> get(String endpoint, Map<String, String> params, Map<String, String> headers) {
    String formattedParams = "";

    if (params.isNotEmpty) {
      formattedParams = "?";


      for (var key in params.keys) {
        formattedParams = "$formattedParams$key=${params[key]}&";
      }

      formattedParams = formattedParams.substring(0, formattedParams.length - 1);
    }

    final path = '$base$endpoint$formattedParams';
    final uri = Uri.parse(path);

    return http.get(uri, headers: headers);
  }

  Future<http.Response> post(String endpoint, Map<String, String> headers, Map<String, dynamic> body) {
    return http.post(
      Uri.parse("$base$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> patch(String endpoint, Map<String, String> headers, Map<String, dynamic> body) {
    return http.patch(
        Uri.parse("$base$endpoint"),
        headers: headers,
        body: jsonEncode(body)
    );
  }

  Future<http.Response> delete(String endpoint, Map<String, String> headers, Map<String, dynamic> body) {
    return http.delete(
        Uri.parse("$base$endpoint"),
        headers: headers,
        body: jsonEncode(body)
    );
  }
}