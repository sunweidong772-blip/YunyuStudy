import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://8.160.178.28:8090/api';

  static String? _token;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static bool get isLoggedIn => _token != null;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // ========== 认证相关 ==========

  // 发送验证码
  static Future<Map<String, dynamic>> sendCode(String email, {String type = 'register'}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/send-code'),
      headers: _headers,
      body: jsonEncode({'email': email, 'type': type}),
    );
    return jsonDecode(res.body);
  }

  // 注册
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String code,
    String? nickname,
    String role = 'student',
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
        'code': code,
        'nickname': nickname,
        'role': role,
      }),
    );
    final data = jsonDecode(res.body);
    if (data['success'] == true && data['token'] != null) {
      await setToken(data['token']);
    }
    return data;
  }

  // 登录
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(res.body);
    if (data['success'] == true && data['token'] != null) {
      await setToken(data['token']);
    }
    return data;
  }

  // 重置密码
  static Future<Map<String, dynamic>> resetPassword(String email, String code, String newPassword) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: _headers,
      body: jsonEncode({'email': email, 'code': code, 'newPassword': newPassword}),
    );
    return jsonDecode(res.body);
  }

  // ========== 学生相关 ==========

  // 获取个人信息
  static Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(Uri.parse('$baseUrl/student/profile'), headers: _headers);
    return jsonDecode(res.body);
  }

  // 修改个人信息
  static Future<Map<String, dynamic>> updateProfile({String? nickname, String? avatar}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/student/update-profile'),
      headers: _headers,
      body: jsonEncode({'nickname': nickname, 'avatar': avatar}),
    );
    return jsonDecode(res.body);
  }

  // 打卡
  static Future<Map<String, dynamic>> checkIn() async {
    final res = await http.post(Uri.parse('$baseUrl/student/check-in'), headers: _headers);
    return jsonDecode(res.body);
  }

  // 获取错题列表
  static Future<Map<String, dynamic>> getWrongQuestions({int page = 1, int limit = 20}) async {
    final res = await http.get(
      Uri.parse('$baseUrl/student/wrong-questions?page=$page&limit=$limit'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  // 添加错题
  static Future<Map<String, dynamic>> addWrongQuestion({
    required String question,
    required String answer,
    String? wrongAnswer,
    String? explanation,
    int? grade,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/student/wrong-questions/add'),
      headers: _headers,
      body: jsonEncode({
        'question': question,
        'answer': answer,
        'wrong_answer': wrongAnswer,
        'explanation': explanation,
        'grade': grade,
      }),
    );
    return jsonDecode(res.body);
  }

  // 删除错题
  static Future<Map<String, dynamic>> deleteWrongQuestion(int id) async {
    final res = await http.post(
      Uri.parse('$baseUrl/student/wrong-questions/delete'),
      headers: _headers,
      body: jsonEncode({'id': id}),
    );
    return jsonDecode(res.body);
  }

  // 清空错题
  static Future<Map<String, dynamic>> clearWrongQuestions() async {
    final res = await http.post(Uri.parse('$baseUrl/student/wrong-questions/clear'), headers: _headers);
    return jsonDecode(res.body);
  }

  // 提交学习记录
  static Future<Map<String, dynamic>> submitStudyRecord({
    required String type,
    String? subject,
    int? score,
    int? total,
    int? duration,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/student/study-record'),
      headers: _headers,
      body: jsonEncode({
        'type': type,
        'subject': subject,
        'score': score,
        'total': total,
        'duration': duration,
      }),
    );
    return jsonDecode(res.body);
  }

  // 获取学习记录
  static Future<Map<String, dynamic>> getStudyRecords({int page = 1, int limit = 20}) async {
    final res = await http.get(
      Uri.parse('$baseUrl/student/study-records?page=$page&limit=$limit'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  // 获取作业列表
  static Future<Map<String, dynamic>> getHomework() async {
    final res = await http.get(Uri.parse('$baseUrl/student/homework'), headers: _headers);
    return jsonDecode(res.body);
  }

  // 提交作业
  static Future<Map<String, dynamic>> submitHomework(int homeworkId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/student/homework/submit'),
      headers: _headers,
      body: jsonEncode({'homework_id': homeworkId}),
    );
    return jsonDecode(res.body);
  }

  // 获取积分记录
  static Future<Map<String, dynamic>> getPointRecords() async {
    final res = await http.get(Uri.parse('$baseUrl/student/point-records'), headers: _headers);
    return jsonDecode(res.body);
  }

  // 获取学习统计
  static Future<Map<String, dynamic>> getStats() async {
    final res = await http.get(Uri.parse('$baseUrl/student/stats'), headers: _headers);
    return jsonDecode(res.body);
  }

  // ========== 消息通知 ==========

  // 获取消息列表
  static Future<Map<String, dynamic>> getMessages({int page = 1, int limit = 20}) async {
    final res = await http.get(
      Uri.parse('$baseUrl/message/list?page=$page&limit=$limit'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  // 标记已读
  static Future<Map<String, dynamic>> readMessage({int? id}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/message/read'),
      headers: _headers,
      body: jsonEncode({'id': id}),
    );
    return jsonDecode(res.body);
  }

  // 删除消息
  static Future<Map<String, dynamic>> deleteMessage(int id) async {
    final res = await http.post(
      Uri.parse('$baseUrl/message/delete'),
      headers: _headers,
      body: jsonEncode({'id': id}),
    );
    return jsonDecode(res.body);
  }

  // 清空消息
  static Future<Map<String, dynamic>> clearMessages() async {
    final res = await http.post(Uri.parse('$baseUrl/message/clear'), headers: _headers);
    return jsonDecode(res.body);
  }
}
