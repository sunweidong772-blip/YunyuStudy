import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../theme/app_theme.dart';
import '../../data/english_words.dart';
import '../../data/study_data.dart';

class WordPage extends StatefulWidget {
  final int grade;
  const WordPage({super.key, required this.grade});

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  late List<EnglishWord> _words;
  int _currentIndex = 0;
  bool _showBack = false;
  final Set<int> _mastered = {};
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _words = EnglishData.getWordsByGrade(widget.grade);
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  void _speak(String text) async {
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _flipCard() {
    setState(() {
      _showBack = !_showBack;
    });
  }

  void _nextWord() {
    if (_currentIndex < _words.length - 1) {
      setState(() {
        _currentIndex++;
        _showBack = false;
      });
    }
  }

  void _prevWord() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showBack = false;
      });
    }
  }

  void _markMastered() {
    setState(() {
      if (_mastered.contains(_currentIndex)) {
        _mastered.remove(_currentIndex);
      } else {
        _mastered.add(_currentIndex);
        StudyData.addLearnedWord();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = _words[_currentIndex];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${widget.grade}年级单词'),
        backgroundColor: Colors.transparent,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                '${_currentIndex + 1}/${_words.length}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 进度条
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / _words.length,
                minHeight: 6,
                backgroundColor: Color(0xFFD1FAE5),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
              ),
            ),
          ),
          SizedBox(height: 8),
          // 已掌握数量
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 16),
                SizedBox(width: 4),
                Text(
                  '已掌握 ${_mastered.length} 个单词',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // 单词卡片
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: _flipCard,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                  child: _showBack ? _buildBackCard(word) : _buildFrontCard(word),
                ),
              ),
            ),
          ),
          // 操作按钮
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              children: [
                // 掌握按钮
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _markMastered,
                    icon: Icon(
                      _mastered.contains(_currentIndex) ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: _mastered.contains(_currentIndex) ? AppColors.success : AppColors.textTertiary,
                      size: 20,
                    ),
                    label: Text(
                      _mastered.contains(_currentIndex) ? '已掌握' : '标记为已掌握',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _mastered.contains(_currentIndex) ? AppColors.success : AppColors.textSecondary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(
                        color: _mastered.contains(_currentIndex) ? AppColors.success : AppColors.border,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // 上一个/下一个
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _currentIndex > 0 ? _prevWord : null,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text('上一个', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _currentIndex < _words.length - 1 ? _nextWord : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          backgroundColor: AppColors.success,
                        ),
                        child: Text('下一个', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text('点击卡片查看释义', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontCard(EnglishWord word) {
    return Container(
      key: ValueKey('front'),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.englishGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Color(0x3310B981), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(onTap: () => _speak(word.word), child: Icon(Icons.volume_up, color: Colors.white.withOpacity(0.8), size: 36)),
          SizedBox(height: 24),
          GestureDetector(onTap: () => _speak(word.word), child: Text(word.word, style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: 1))),
          SizedBox(height: 16),
          Text(word.phonetic, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 20, fontWeight: FontWeight.w500)),
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Text('点击查看释义', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(EnglishWord word) {
    return Container(
      key: ValueKey('back'),
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Color(0x1A172C49), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(word.word, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
              GestureDetector(onTap: () => _speak(word.word), child: Icon(Icons.volume_up, color: AppColors.success, size: 28)),
            ],
          ),
          SizedBox(height: 4),
          Text(word.phonetic, style: TextStyle(fontSize: 16, color: AppColors.textTertiary)),
          Divider(height: 32, color: AppColors.divider),
          // 释义
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.translate, color: AppColors.success, size: 18),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('中文释义', style: TextStyle(fontSize: 12, color: AppColors.textTertiary, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text(word.meaning, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          // 例句
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.format_quote, color: AppColors.warning, size: 18),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('例句', style: TextStyle(fontSize: 12, color: AppColors.textTertiary, fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    Text(word.example, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.5)),
                    SizedBox(height: 6),
                    Text(word.exampleTranslation, style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          Center(child: Text('点击返回单词', style: TextStyle(fontSize: 12, color: AppColors.textTertiary))),
        ],
      ),
    );
  }
}
