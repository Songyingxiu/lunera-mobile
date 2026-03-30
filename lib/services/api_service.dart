import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/content.dart';

class ApiService {
  // Use localhost because you are testing on Flutter Web
  static const String baseUrl = "http://localhost:8076/api";

  // Login Method
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      body: {'username': username, 'password': password},
    );
    return json.decode(response.body);
  }

  // Get All Contents Method
  static Future<List<Content>> getContents() async {
    final response = await http.get(Uri.parse("$baseUrl/contents"));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // Assuming your CI4 API returns data inside a 'data' key: { "status": 200, "data": [...] }
      List data = jsonResponse['data'];
      return data.map((e) => Content.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load contents');
    }
  }
}
