import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/content.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8076/api";
  static const String imageUrl = "http://localhost:8076/uploads/avatars/";

  // --- LOGIN ---
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      body: {'username': username, 'password': password},
    );
    return json.decode(response.body);
  }

  // --- READ PROFILE ---
  static Future<Map<String, dynamic>> getUserProfile(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/profile/$id"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load profile');
  }

  // --- UPDATE PROFILE (WITH IMAGE) ---
  static Future<Map<String, dynamic>> updateProfile(
      int id, String username, String password, File? imageFile) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("$baseUrl/profile/update"));

    request.fields['id_user'] = id.toString();
    request.fields['username'] = username;
    request.fields['password'] = password;

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('avatar', imageFile.path));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return json.decode(response.body);
  }

  // --- DELETE ACCOUNT ---
  static Future<Map<String, dynamic>> deleteAccount(int id) async {
    final response =
        await http.delete(Uri.parse("$baseUrl/profile/delete/$id"));
    return json.decode(response.body);
  }

  // --- CONTENTS ---
  static Future<List<Content>> getContents() async {
    final response = await http.get(Uri.parse("$baseUrl/contents"));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List data = jsonResponse['data'] ?? [];
      return data.map((e) => Content.fromJson(e)).toList();
    }
    throw Exception('Failed to load contents');
  }
}
