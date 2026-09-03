import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StudyData {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 数学练习次数
  static int get mathPracticeCount => _prefs?.getInt('math_practice_count') ?? 0;
  static Future<void> addMathPractice() async {
    await _prefs?.setInt('math_practice_count', mathPracticeCount + 1);
  }

  // 已学单词数
  static int get learnedWords => _prefs?.getInt('learned_words') ?? 0;
  static Future<void> addLearnedWord() async {
    await _prefs?.setInt('learned_words', learnedWords + 1);
  }

  // 阅读作文数
  static int get readEssays => _prefs?.getInt('read_essays') ?? 0;
  static Future<void> addReadEssay() async {
    await _prefs?.setInt('read_essays', readEssays + 1);
  }

  // 连续打卡天数
  static int get streakDays {
    String? lastDate = _prefs?.getString('last_study_date');
    int streak = _prefs?.getInt('streak_days') ?? 0;
    if (lastDate == null) return 0;
    DateTime last = DateTime.parse(lastDate);
    DateTime today = DateTime.now();
    int diff = today.difference(DateTime(last.year, last.month, last.day)).inDays;
    if (diff == 0) return streak;
    if (diff == 1) return streak;
    return 0;
  }

  static Future<void> checkIn() async {
    String? lastDate = _prefs?.getString('last_study_date');
    int streak = _prefs?.getInt('streak_days') ?? 0;
    DateTime today = DateTime.now();
    String todayStr = today.toIso8601String().split('T')[0];
    if (lastDate == todayStr) return;
    if (lastDate != null) {
      DateTime last = DateTime.parse(lastDate);
      int diff = today.difference(DateTime(last.year, last.month, last.day)).inDays;
      if (diff == 1) {
        streak++;
      } else {
        streak = 1;
      }
    } else {
      streak = 1;
    }
    await _prefs?.setInt('streak_days', streak);
    await _prefs?.setString('last_study_date', todayStr);
  }

  // 错题本
  static List<Map<String, dynamic>> get wrongQuestions {
    String? data = _prefs?.getString('wrong_questions');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  static Future<void> addWrongQuestion(Map<String, dynamic> q) async {
    List<Map<String, dynamic>> list = wrongQuestions;
    // 去重
    bool exists = list.any((item) => item['question'] == q['question']);
    if (!exists) {
      list.add(q);
      await _prefs?.setString('wrong_questions', json.encode(list));
    }
  }

  static Future<void> removeWrongQuestion(String question) async {
    List<Map<String, dynamic>> list = wrongQuestions;
    list.removeWhere((item) => item['question'] == question);
    await _prefs?.setString('wrong_questions', json.encode(list));
  }

  // 收藏
  static List<String> get favorites {
    String? data = _prefs?.getString('favorites');
    if (data == null) return [];
    return List<String>.from(json.decode(data));
  }

  static Future<void> toggleFavorite(String id) async {
    List<String> list = favorites;
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    await _prefs?.setString('favorites', json.encode(list));
  }

  static bool isFavorite(String id) => favorites.contains(id);

  // 每日小考成绩
  static List<Map<String, dynamic>> get examRecords {
    String? data = _prefs?.getString('exam_records');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  static Future<void> addExamRecord(Map<String, dynamic> record) async {
    List<Map<String, dynamic>> list = examRecords;
    list.add(record);
    await _prefs?.setString('exam_records', json.encode(list));
  }
}
