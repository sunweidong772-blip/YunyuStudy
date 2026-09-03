import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/math_questions.dart';
import 'practice_page.dart';

class MathPage extends StatelessWidget {
  const MathPage({super.key});

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
              decoration: BoxDecoration(gradient: AppColors.mathGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.calculate, color: Colors.white, size: 28),
                        SizedBox(width: 10),
                        Text('数学练习', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                      ]),
                      SizedBox(height: 8),
                      Text('选择年级，开始智能出题练习', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
            // 选择年级
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(children: [
                Container(width: 4, height: 18, decoration: BoxDecoration(color: Color(0xFF3B82F6), borderRadius: BorderRadius.circular(2))),
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
            // 题目数量
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(children: [
                Container(width: 4, height: 18, decoration: BoxDecoration(color: Color(0xFF60A5FA), borderRadius: BorderRadius.circular(2))),
                SizedBox(width: 8),
                Text('练习说明', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.quiz, '每次10道题', '选择题形式'),
                    Divider(height: 20, color: AppColors.divider),
                    _buildInfoRow(Icons.auto_graph, '智能出题', '根据年级自动调整难度'),
                    Divider(height: 20, color: AppColors.divider),
                    _buildInfoRow(Icons.lightbulb, '答案解析', '每题都有详细解题思路'),
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
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PracticePage(grade: grade))),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Color(0x333B82F6), blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$grade', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
            SizedBox(height: 4),
            Text('年级', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 18)),
      SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        SizedBox(height: 2),
        Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
      ])),
    ]);
  }
}
