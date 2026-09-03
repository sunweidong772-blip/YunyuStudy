import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/english_words.dart';
import 'word_page.dart';

class EnglishPage extends StatelessWidget {
  const EnglishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部渐变
            Container(
              decoration: BoxDecoration(gradient: AppColors.englishGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.menu_book, color: Colors.white, size: 28),
                        SizedBox(width: 10),
                        Text('英语单词', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                      ]),
                      SizedBox(height: 8),
                      Text('1-6年级必考单词，卡片式记忆', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
            // 选择年级
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(children: [
                Container(width: 4, height: 18, decoration: BoxDecoration(color: Color(0xFF10B981), borderRadius: BorderRadius.circular(2))),
                SizedBox(width: 8),
                Text('选择年级', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1.1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(6, (index) => _buildGradeCard(context, index + 1)),
              ),
            ),
            // 学习说明
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(children: [
                Container(width: 4, height: 18, decoration: BoxDecoration(color: Color(0xFF34D399), borderRadius: BorderRadius.circular(2))),
                SizedBox(width: 8),
                Text('学习方式', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.style, '卡片式学习', '正面单词，背面释义'),
                    Divider(height: 20, color: AppColors.divider),
                    _buildInfoRow(Icons.record_voice_over, '音标标注', '每个单词都有标准音标'),
                    Divider(height: 20, color: AppColors.divider),
                    _buildInfoRow(Icons.article, '例句翻译', '配套例句和中文翻译'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeCard(BuildContext context, int grade) {
    int wordCount = EnglishData.getWordsByGrade(grade).length;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WordPage(grade: grade))),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Color(0x3310B981), blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$grade', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
            SizedBox(height: 2),
            Text('年级', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(8)), child: Text('$wordCount词', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.success, size: 18)),
      SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        SizedBox(height: 2),
        Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
      ])),
    ]);
  }
}
