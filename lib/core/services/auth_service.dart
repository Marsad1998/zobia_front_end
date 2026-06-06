import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class AuthService {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:3000";
    }
    try {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:3000";
      }
    } catch (_) {}
    return "http://localhost:3000";
  }

  static final box = GetStorage();

  // User Login
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final data = json.decode(response.body);
      print('Login API Response: $data');

      if (response.statusCode == 200 && data['success'] == true) {
        // Save Auth States
        if (data['token'] != null) {
          box.write('token', data['token']);
          box.write('user', data['user']);
          box.write('role', data['user']['role']); // admin, buyer, wholesaler
          box.write('userName', data['user']['name']);
          box.write('isLoggedIn', true);
        }
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'Cannot connect to backend: $e'};
    }
  }

  // User Signup
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
    required String gender,
  }) async {
    try {
      final body = {
        'name': name,
        'email': email,
        'password': password,
        'role': role.toLowerCase(),
        'phone': phone,
        'gender': gender.toLowerCase(),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      final data = json.decode(response.body);
      print('Register API Response: $data');

      if ((response.statusCode == 201 || response.statusCode == 200) &&
          data['success'] == true) {
        return {'success': true};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Signup failed'};
      }
    } catch (e) {
      print('Register error: $e');
      return {'success': false, 'message': 'Cannot connect to backend: $e'};
    }
  }

  // Logout
  static void logout() {
    box.remove('token');
    box.remove('user');
    box.remove('role');
    box.remove('userName');
    box.remove('isLoggedIn');
  }
}
