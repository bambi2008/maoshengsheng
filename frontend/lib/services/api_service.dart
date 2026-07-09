import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/analysis_result.dart';

class ApiService {
  // Change this to your backend URL
  static const String baseUrl = 'http://10.0.2.2:8080'; // Android emulator
  // For iOS simulator use: 'http://localhost:8080'
  // For real device use your computer's IP

  static Future<AnalysisResult> analyzeText(String symptomText) async {
    final response = await http.post(
      Uri.parse('$baseUrl/analyze/text'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'symptom_text': symptomText}),
    );

    if (response.statusCode == 200) {
      return AnalysisResult.fromJson(jsonDecode(response.body));
    }
    throw Exception('分析失败: ${response.statusCode}');
  }

  static Future<AnalysisResult> analyzeImage(File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/analyze/upload'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 200) {
      return AnalysisResult.fromJson(jsonDecode(response.body));
    }
    throw Exception('图片分析失败: ${response.statusCode}');
  }

  static Future<List<AlternativeItem>> getAlternatives() async {
    final response = await http.get(
      Uri.parse('$baseUrl/knowledge/alternatives'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((j) => AlternativeItem.fromJson(j)).toList();
    }
    throw Exception('获取平替清单失败');
  }
}
