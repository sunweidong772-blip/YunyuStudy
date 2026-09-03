import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://8.160.178.28/api';

  static String? _token;
  static Map<String, dynamic>? _currentUser;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userStr = prefs.getString('current_user');
    if (userStr != null) {
      _currentUser = jsonDecode(userStr);
    }
  }

  static Future<void> setCurrentUser(Map<String, dynamic> user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(user));
  }

  static Map<String, dynamic>? get currentUser => _currentUser;

  static int? get currentUserId => _currentUser?['id'] as int?;

  static String? get currentUserRole => _currentUser?['role'] as String?;

  static bool get isTeacher => _currentUser?['role'] == 'teacher';
  static bool get isAdmin => _currentUser?['role'] == 'admin';
  static bool get isParent => _currentUser?['role'] == 'parent';
  static bool get isStudent => _currentUser?['role'] == 'student';

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
      if (data['user'] != null) {
        await setCurrentUser(Map<String, dynamic>.from(data['user']));
      }
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
      if (data['user'] != null) {
        await setCurrentUser(Map<String, dynamic>.from(data['user']));
      }
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

  // ========== 管理员相关 ==========

  // 获取用户列表
  static Future<Map<String, dynamic>> getAdminUsers({String? role, int page = 1, int limit = 20}) async {
    String url = '$baseUrl/admin/users?page=$page&limit=$limit';
    if (role != null) url += '&role=$role';
    final res = await http.get(Uri.parse(url), headers: _headers);
    return jsonDecode(res.body);
  }

  // 添加用户
  static Future<Map<String, dynamic>> addUser({required String email, required String password, String? nickname, String role = 'student'}) async {
    final res = await http.post(Uri.parse('$baseUrl/admin/users/add'), headers: _headers, body: jsonEncode({'email': email, 'password': password, 'nickname': nickname, 'role': role}));
    return jsonDecode(res.body);
  }

  // 删除用户
  static Future<Map<String, dynamic>> deleteUser(int userId) async {
    final res = await http.post(Uri.parse('$baseUrl/admin/users/delete'), headers: _headers, body: jsonEncode({'user_id': userId}));
    return jsonDecode(res.body);
  }

  // 修改用户密码
  static Future<Map<String, dynamic>> resetUserPassword(int userId, String newPassword) async {
    final res = await http.post(Uri.parse('$baseUrl/admin/users/reset-password'), headers: _headers, body: jsonEncode({'user_id': userId, 'new_password': newPassword}));
    return jsonDecode(res.body);
  }

  // 设置用户角色
  static Future<Map<String, dynamic>> setUserRole(int userId, String role) async {
    final res = await http.post(Uri.parse('$baseUrl/admin/users/set-role'), headers: _headers, body: jsonEncode({'user_id': userId, 'role': role}));
    return jsonDecode(res.body);
  }

  // 获取教师认证申请列表
  static Future<Map<String, dynamic>> getVerifications({String? status}) async {
    String url = '$baseUrl/admin/verifications';
    if (status != null) url += '?status=$status';
    final res = await http.get(Uri.parse(url), headers: _headers);
    return jsonDecode(res.body);
  }

  // 审核教师认证
  static Future<Map<String, dynamic>> reviewVerification(int id, String status, {String? reviewNote}) async {
    final res = await http.post(Uri.parse('$baseUrl/admin/verifications/review'), headers: _headers, body: jsonEncode({'id': id, 'status': status, 'review_note': reviewNote}));
    return jsonDecode(res.body);
  }

  // 发布新版本
  static Future<Map<String, dynamic>> publishVersion({required String version, String? title, required String content, String? downloadUrl, int forceUpdate = 0}) async {
    final res = await http.post(Uri.parse('$baseUrl/admin/version/publish'), headers: _headers, body: jsonEncode({'version': version, 'title': title, 'content': content, 'download_url': downloadUrl, 'force_update': forceUpdate}));
    return jsonDecode(res.body);
  }

  // 获取平台统计
  static Future<Map<String, dynamic>> getAdminStats() async {
    final res = await http.get(Uri.parse('$baseUrl/admin/stats'), headers: _headers);
    return jsonDecode(res.body);
  }

  // ========== 班级群相关 ==========

  // 创建班级群
  static Future<Map<String, dynamic>> createClass({required String name, String? description}) async {
    final res = await http.post(Uri.parse('$baseUrl/class/create'), headers: _headers, body: jsonEncode({'name': name, 'description': description}));
    return jsonDecode(res.body);
  }

  // 获取我加入的班级群
  static Future<Map<String, dynamic>> getMyClasses() async {
    final res = await http.get(Uri.parse('$baseUrl/class/my'), headers: _headers);
    return jsonDecode(res.body);
  }

  // 获取所有班级群
  static Future<Map<String, dynamic>> getAllClasses() async {
    final res = await http.get(Uri.parse('$baseUrl/class/all'), headers: _headers);
    return jsonDecode(res.body);
  }

  // 加入班级群
  static Future<Map<String, dynamic>> joinClass(int classId) async {
    final res = await http.post(Uri.parse('$baseUrl/class/join'), headers: _headers, body: jsonEncode({'class_id': classId}));
    return jsonDecode(res.body);
  }

  // 获取班级群消息
  static Future<Map<String, dynamic>> getClassMessages(int classId, {int page = 1, int limit = 50}) async {
    final res = await http.get(Uri.parse('$baseUrl/class/$classId/messages?page=$page&limit=$limit'), headers: _headers);
    return jsonDecode(res.body);
  }

  // 发送班级群消息
  static Future<Map<String, dynamic>> sendClassMessage(int classId, String content) async {
    final res = await http.post(Uri.parse('$baseUrl/class/$classId/send'), headers: _headers, body: jsonEncode({'content': content}));
    return jsonDecode(res.body);
  }

  // 获取班级群成员
  static Future<Map<String, dynamic>> getClassMembers(int classId) async {
    final res = await http.get(Uri.parse('$baseUrl/class/$classId/members'), headers: _headers);
    return jsonDecode(res.body);
  }

  // ========== 私信相关 ==========

  // 获取会话列表
  static Future<Map<String, dynamic>> getConversations() async {
    final res = await http.get(Uri.parse('$baseUrl/private/conversations'), headers: _headers);
    return jsonDecode(res.body);
  }

  // 获取聊天记录
  static Future<Map<String, dynamic>> getPrivateMessages(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/private/messages/$userId'), headers: _headers);
    return jsonDecode(res.body);
  }

  // 发送私信
  static Future<Map<String, dynamic>> sendPrivateMessage(int receiverId, String content) async {
    final res = await http.post(Uri.parse('$baseUrl/private/send'), headers: _headers, body: jsonEncode({'receiver_id': receiverId, 'content': content}));
    return jsonDecode(res.body);
  }

  // 获取未读私信数
  static Future<Map<String, dynamic>> getUnreadPrivateCount() async {
    final res = await http.get(Uri.parse('$baseUrl/private/unread-count'), headers: _headers);
    return jsonDecode(res.body);
  }

  // ========== 教师认证相关 ==========

  // 提交教师认证
  static Future<Map<String, dynamic>> submitTeacherVerification({required String realName, String? phone, String? qq, String? wechat, String? workExperience, String? certificateImage}) async {
    final res = await http.post(Uri.parse('$baseUrl/teacher-verify/submit'), headers: _headers, body: jsonEncode({'real_name': realName, 'phone': phone, 'qq': qq, 'wechat': wechat, 'work_experience': workExperience, 'certificate_image': certificateImage}));
    return jsonDecode(res.body);
  }

  // 获取我的认证状态
  static Future<Map<String, dynamic>> getMyVerificationStatus() async {
    final res = await http.get(Uri.parse('$baseUrl/teacher-verify/my-status'), headers: _headers);
    return jsonDecode(res.body);
  }

  // ========== 小助手相关 ==========

  // 小助手问答
  static Future<Map<String, dynamic>> askAssistant(String question) async {
    final res = await http.post(Uri.parse('$baseUrl/assistant/ask'), headers: _headers, body: jsonEncode({'question': question}));
    return jsonDecode(res.body);
  }

  // 获取今日待办
  static Future<Map<String, dynamic>> getTodayTasks() async {
    final res = await http.get(Uri.parse('$baseUrl/assistant/today-tasks'), headers: _headers);
    return jsonDecode(res.body);
  }

  // 获取常见问题
  static Future<Map<String, dynamic>> getFaqs() async {
    final res = await http.get(Uri.parse('$baseUrl/assistant/faqs'), headers: _headers);
    return jsonDecode(res.body);
  }

  // ========== 版本相关 ==========

  // 检查更新
  static Future<Map<String, dynamic>> checkUpdate(String currentVersion) async {
    final res = await http.get(Uri.parse('$baseUrl/version/check?version=$currentVersion'));
    return jsonDecode(res.body);
  }

  // 获取更新日志
  static Future<Map<String, dynamic>> getChangelog() async {
    final res = await http.get(Uri.parse('$baseUrl/version/changelog'));
    return jsonDecode(res.body);
  }
}
