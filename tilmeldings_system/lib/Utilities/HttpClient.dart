import 'package:http/http.dart' as http;

class HttpClient {
  HttpClient({required this.base});

  final String base;

  Future<http.Response> get(String endpoint, Map<String, String> headers) {
    return http.get(Uri.parse('$base$endpoint'), headers: headers);
  }

  Future<http.Response> post(String endpoint, Map<String, String> headers, Object body) {
    return http.post(
      Uri.parse("$base$endpoint"),
      headers: headers,
      body: body
    );
  }
}