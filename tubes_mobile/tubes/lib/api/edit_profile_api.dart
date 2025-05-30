import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class EditProfileAPI {
  static const String baseUrl = 'http://127.0.0.1:3000/api';

  /// Fetch Profile by ID
  static Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    final url = Uri.parse('$baseUrl/profile/$userId');
    final headers = {
      'Content-Type': 'application/json', // Format data yang dikirim
      'Authorization':
          'Bearer YOUR_TOKEN', // Ganti dengan token jika diperlukan
    };

    try {
      final response = await http.get(url, headers: headers);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to fetch profile: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  /// Update Profile
  static Future<bool> updateProfile(
      String userId, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/profile/$userId');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['success'];
      } else {
        print('Failed to update profile: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  /// Upload Profile Picture
  static Future<bool> uploadProfilePicture(
      String userId, File imageFile, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/profile/$userId/upload');
    final request = http.MultipartRequest('PUT', url);

    try {
      // Attach image file
      final image = await http.MultipartFile.fromPath(
        'profile_picture',
        imageFile.path,
      );
      request.files.add(image);

      // Attach additional data
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Profile picture uploaded successfully');
        return true;
      } else {
        print('Failed to upload profile picture: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
      return false;
    }
  }
}
