import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/math_questions.dart';
import '../../data/study_data.dart';

class PracticePage extends StatefulWidget {
  final int grade;
  const PracticePage({super.key, required this.grade});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  late List<MathQuestion> _questions;
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  int _correctCount = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _questions = MathGenerator.generateQuestions(widget.grade, 10);
  }

  void _selectAnswer(String answer) {
    if (_showResult) return;
    setState(() => _selectedAnswer = answer);
  }

  void _submitAnswer() {
    if (_selectedAnswer == null) return;
    setState(() {
      _showResult = true;
      if (_selectedAnswer == _questions[_currentIndex].answer) {
        _correctCount++;
      } else {
        // 记录错题
        StudyData.addWrongQuestion({
          'question': _questions[_currentIndex].question,
          'answer': _questions[_currentIndex].answer,
          'wrongAnswer': _selectedAnswer,
          'explanation': _questions[_currentIndex].explanation,
        });
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      // 完成练习，增加练习次数
      StudyData.addMathPractice();
      StudyData.checkIn();
      setState(() => _finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return _buildResultPage();
    final q = _questions[_currentIndex];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('${widget.grade}年级数学练习'), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: (_currentIndex + 1) / _questions.length, minHeight: 8, backgroundColor: AppColors.primaryLight, valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))),
            SizedBox(width: 12),
            Text('${_currentIndex + 1}/${_questions.length}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          ]),
          SizedBox(height: 24),
          Container(width: double.infinity, padding: EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]), child: Column(children: [Text('题目 ${_currentIndex + 1}', style: TextStyle(fontSize: 13, color: AppColors.textTertiary, fontWeight: FontWeight.w600)), SizedBox(height: 16), Text(q.question, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary), textAlign: TextAlign.center)])),
          SizedBox(height: 24),
          ...q.options.asMap().entries.map((entry) {
            int idx = entry.key;
            String opt = entry.value;
            bool isSelected = _selectedAnswer == opt;
            bool isCorrect = opt == q.answer;
            Color bgColor = Colors.white, borderColor = AppColors.border, textColor = AppColors.textPrimary;
            if (_showResult) {
              if (isCorrect) { bgColor = Color(0xFFECFDF5); borderColor = AppColors.success; textColor = AppColors.success; }
              else if (isSelected) { bgColor = Color(0xFFFEF2F2); borderColor = AppColors.danger; textColor = AppColors.danger; }
            } else if (isSelected) { bgColor = AppColors.primaryLight; borderColor = AppColors.primary; textColor = AppColors.primary; }
            return Padding(padding: EdgeInsets.only(bottom: 12), child: GestureDetector(onTap: () => _selectAnswer(opt), child: Container(width: double.infinity, padding: EdgeInsets.all(16), decoration: BoxDecoration(color: bgColor, border: Border.all(color: borderColor, width: 2), borderRadius: BorderRadius.circular(14)), child: Row(children: [Container(width: 32, height: 32, decoration: BoxDecoration(color: borderColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(String.fromCharCode(65 + idx), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor)))), SizedBox(width: 14), Expanded(child: Text(opt, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor))), if (_showResult && isCorrect) Icon(Icons.check_circle, color: AppColors.success, size: 24), if (_showResult && isSelected && !isCorrect) Icon(Icons.cancel, color: AppColors.danger, size: 24)]))));
          }),
          SizedBox(height: 16),
          if (_showResult) ...[
            Container(width: double.infinity, padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFFFFFBEB), border: Border.all(color: AppColors.warning.withOpacity(0.3)), borderRadius: BorderRadius.circular(14)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.lightbulb, color: AppColors.warning, size: 18), SizedBox(width: 6), Text('解题思路', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.warning))]), SizedBox(height: 8), Text(q.explanation, style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5))])),
            SizedBox(height: 16),
          ],
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _selectedAnswer == null ? null : (_showResult ? _nextQuestion : _submitAnswer), style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), backgroundColor: AppColors.primary), child: Text(_showResult ? (_currentIndex < _questions.length - 1 ? '下一题' : '完成练习') : '提交答案', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)))),
          SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _buildResultPage() {
    double percentage = _correctCount / _questions.length * 100;
    String message = percentage >= 90 ? '太棒了！你是数学小天才！' : percentage >= 70 ? '很不错！继续加油！' : percentage >= 60 ? '及格了，还要多练习哦！' : '别灰心，错题本里多复习！';
    IconData icon = percentage >= 90 ? Icons.emoji_events : percentage >= 70 ? Icons.thumb_up : percentage >= 60 ? Icons.sentiment_satisfied : Icons.sentiment_dissatisfied;
    Color color = percentage >= 90 ? AppColors.warning : percentage >= 70 ? AppColors.success : percentage >= 60 ? AppColors.primary : AppColors.danger;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 100, height: 100, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(50)), child: Icon(icon, size: 56, color: color)),
            SizedBox(height: 24),
            Text('练习完成！', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            SizedBox(height: 12),
            Text(message, style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            SizedBox(height: 32),
            Container(width: double.infinity, padding: EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]), child: Column(children: [Text('${percentage.toStringAsFixed(0)}分', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: color)), SizedBox(height: 8), Text('正确率', style: TextStyle(fontSize: 14, color: AppColors.textTertiary)), Divider(height: 32, color: AppColors.divider), Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildStat('正确', '$_correctCount', AppColors.success), _buildStat('错误', '${_questions.length - _correctCount}', AppColors.danger), _buildStat('总题数', '${_questions.length}', AppColors.primary)])])),
            if (_questions.length - _correctCount > 0) ...[
              SizedBox(height: 16),
              Text('错题已自动加入错题本', style: TextStyle(fontSize: 13, color: AppColors.danger, fontWeight: FontWeight.w600)),
            ],
            SizedBox(height: 32),
            Row(children: [Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: Text('返回', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)))), SizedBox(width: 12), Expanded(child: ElevatedButton(onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PracticePage(grade: widget.grade))); }, style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: Text('再练一次', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))))]),
          ]),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) => Column(children: [Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)), SizedBox(height: 4), Text(label, style: TextStyle(fontSize: 12, color: AppColors.textTertiary))]);
}
