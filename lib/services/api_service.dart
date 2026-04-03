import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/content.dart';
import '../models/episode.dart';

class ApiService {
  // 🌐 Use your Computer's IP (e.g., 192.168.x.x) if testing on a real phone!
  static const String baseUrl = "http://localhost:8076/api";
  static const String imageUrl = "http://localhost:8076/uploads/avatars/";

  // --- 1. IDENTITY & AUTHENTICATION ---

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        body: {'username': username, 'password': password},
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 500, 'message': 'LOGIN_FAIL: Connection refused.'};
    }
  }

  static Future<Map<String, dynamic>> getUserProfile(int id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/profile/$id"));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load profile');
    } catch (e) {
      return {'status': 404, 'message': 'SYSTEM_ERROR: Profile unreachable.'};
    }
  }

  static Future<Map<String, dynamic>> updateProfile(
      int id, String username, String password, File? imageFile) async {
    try {
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
    } catch (e) {
      return {
        'status': 500,
        'message': 'UPLOAD_FAIL: Data corruption during sync.'
      };
    }
  }

  static Future<Map<String, dynamic>> deleteAccount(int id) async {
    try {
      final response =
          await http.delete(Uri.parse("$baseUrl/profile/delete/$id"));
      return json.decode(response.body);
    } catch (e) {
      return {
        'status': 500,
        'message': 'PURGE_FAIL: Unable to erase identity.'
      };
    }
  }

  // --- 2. DATA CORE (CONTENTS & EPISODES) ---

  static Future<List<Content>> getContents() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/contents"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List data = jsonResponse['data'] ?? [];
        return data.map((e) => Content.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("🚨 DATA_LOAD_ERROR: $e");
      return [];
    }
  }

  static Future<List<dynamic>> getCategories() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/categories"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['data'] ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 🚀 SYNCED: Fetches all episodes linked to content ID
  static Future<List<Episode>> getEpisodes(int contentId) async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/episodes/$contentId"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Priority for the 'data' key used in your Lunera.php controller
        List data = jsonResponse['data'] ?? jsonResponse['results'] ?? [];

        return data.map((e) => Episode.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("🚨 EPISODE_FETCH_ERROR: $e");
      return [];
    }
  }

  // --- 3. FAVORITES (DATABASE SYNC) ---

  static Future<Map<String, dynamic>> toggleFavorite(
      int userId, int contentId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/toggleFavorite/$contentId"),
        body: {'id_user': userId.toString()},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      }

      return {
        'status': response.statusCode,
        'message': 'SERVER_ERROR: Invalid format.',
        'is_favorite': false
      };
    } catch (e) {
      debugPrint("🚨 TOGGLE_ERROR: $e");
      return {
        'status': 'error',
        'message': 'CONNECTION_LOST: Mainframe offline.',
        'is_favorite': false
      };
    }
  }

  static Future<List<Content>> getFavorites(int userId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/favorites/$userId"));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List data = jsonResponse['data'] ?? [];
        return data.map((e) => Content.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("🚨 FAV_SYNC_ERROR: $e");
      return [];
    }
  }

  // --- 4. SEARCH ---

  static Future<List<Content>> searchContents(String query) async {
    try {
      final contents = await getContents();
      return contents.where((content) {
        return content.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
