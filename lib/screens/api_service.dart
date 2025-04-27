import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ApiService {
  // Change this to your actual API URL
  final String baseUrl = 'http://192.168.253.15:5000'; // Your server IP address

  Future<Map<String, dynamic>> uploadVideo(File videoFile) async {
    try {
      // Add /api prefix to the endpoint
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/upload'));
      request.files.add(await http.MultipartFile.fromPath('file', videoFile.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to upload video: ${response.body}');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }

  Future<Map<String, dynamic>> processVideo(String uploadId) async {
    try {
      // Add /api prefix to the endpoint
      final response = await http.post(
        Uri.parse('$baseUrl/api/process/$uploadId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to process video: ${response.body}');
      }
    } catch (e) {
      throw Exception('Processing error: $e');
    }
  }

  Future<String> downloadResults(String uploadId) async {
    try {
      // Add /api prefix to the endpoint
      final response = await http.get(
        Uri.parse('$baseUrl/api/download/$uploadId'),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to download results: ${response.body}');
      }
    } catch (e) {
      throw Exception('Download error: $e');
    }
  }

  Future<void> cleanupFiles(String uploadId) async {
    try {
      // Add /api prefix to the endpoint
      await http.delete(
        Uri.parse('$baseUrl/api/cleanup/$uploadId'),
      );
    } catch (e) {
      print('Cleanup error: $e');
    }
  }
}