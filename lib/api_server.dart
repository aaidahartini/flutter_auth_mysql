import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServer {
  static const String baseUrl = 'http://localhost:8080';
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': email, 'password': password},
    );
    return json.decode(response.body);
  }
}
