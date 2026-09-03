import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/study_data.dart';

class WrongBookPage extends StatefulWidget {
  const WrongBookPage({super.key});

  @override
  State<WrongBookPage> createState() => _WrongBookPageState();
}

class _WrongBookPageState extends State<WrongBookPage> {
  List<Map<String, dynamic>> _wrongQuestions = [];

  @override
  void initState() {
    super.initState();
    _loadWrongQuestions();
  }

  void _loadWrongQuestions() {
    setState(() => _wrongQuestions = StudyData.wrongQuestions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('错题本'),
        backgroundColor: Colors.transparent,
        actions: [
          if (_wrongQuestions.isNotEmpty)
            TextButton(onPressed: () {
              showDialog(context: context, builder: (d) => AlertDialog(title: Text('清空错题本'), content: Text('确定要清空所有错题吗？'), actions: [TextButton(onPressed: () => Navigator.pop(d), child: Text('取消')), FilledButton(onPressed: () async { for (var q in _wrongQuestions) { await StudyData.removeWrongQuestion(q['question']); } _loadWrongQuestions(); Navigator.pop(d); }, child: Text('清空'))]));
            }, child: Text('清空', style: TextStyle(color: AppColors.danger))),
        ],
      ),
      body: _wrongQuestions.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.check_circle_outline, size: 72, color: AppColors.success), SizedBox(height: 16), Text('太棒了！', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)), SizedBox(height: 8), Text('暂无错题，继续保持！', style: TextStyle(fontSize: 14, color: AppColors.textTertiary))]))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _wrongQuestions.length,
              itemBuilder: (context, index) => _buildWrongItem(_wrongQuestions[index]),
            ),
    );
  }

  Widget _buildWrongItem(Map<String, dynamic> q) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border(left: BorderSide(color: AppColors.danger, width: 4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(6)), child: Text('错题', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.danger))),
            Spacer(),
            GestureDetector(onTap: () async { await StudyData.removeWrongQuestion(q['question']); _loadWrongQuestions(); }, child: Icon(Icons.delete_outline, color: AppColors.textTertiary, size: 20)),
          ]),
          SizedBox(height: 12),
          Text(q['question'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          SizedBox(height: 12),
          Row(children: [
            Text('你的答案: ', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
            Text(q['wrongAnswer'] ?? '', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.danger, decoration: TextDecoration.lineThrough)),
            SizedBox(width: 16),
            Text('正确答案: ', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
            Text(q['answer'] ?? '', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.success)),
          ]),
          if (q['explanation'] != null) ...[
            SizedBox(height: 10),
            Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(8)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.lightbulb, color: AppColors.warning, size: 16), SizedBox(width: 6), Expanded(child: Text(q['explanation'], style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5)))]))),
          ],
        ],
      ),
    );
  }
}
