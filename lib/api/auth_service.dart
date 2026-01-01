import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8081/api";
    } else {
      return "http://10.126.120.69:8081/api"; 
    }
  }

  String _parseError(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body['messages'] != null) {
        if (body['messages'] is String) return body['messages'];
        if (body['messages']['error'] != null) return body['messages']['error'];
      }
      return body['message'] ?? "Terjadi kesalahan (${response.statusCode})";
    } catch (e) {
      return "Gagal terhubung ke server.";
    }
  }

  Future<dynamic> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; 
      }
      return _parseError(response);
    } catch (e) {
      return "Koneksi Error: $e";
    }
  }

  Future<dynamic> adminLogin(String email, String password) async {
    final url = Uri.parse('$baseUrl/admin/login');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return _parseError(response);
    } catch (e) {
      return "Koneksi Error: $e";
    }
  }

  Future<bool> register(String username, String phone, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "phone_number": phone,
          "email": email,
          "password": password,
        }),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> updateProfile(int id, String username, String email, String phone, String address) async {
    final url = Uri.parse('$baseUrl/user/update');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "username": username,
          "email": email,
          "phone_number": phone,
          "address": address,
        }),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>> getWorkerApplications() async {
    final url = Uri.parse('$baseUrl/admin/applications');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateWorkerStatus(int applicationId, String status) async {
    final url = Uri.parse('$baseUrl/admin/application/update');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": applicationId,
          "status": status,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitApplication({
    required int userId,
    required String name,
    required String phone,
    required String email,
    required String address,
    required String gender,
    required String skills,
    required String portfolio,
  }) async {
    final url = Uri.parse('$baseUrl/user/apply');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "name": name,
          "phone": phone,
          "email": email,
          "address": address,
          "gender": gender,
          "skills": skills,
          "portfolio": portfolio,
        }),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Error Submit App: $e");
      return false;
    }
  }
}