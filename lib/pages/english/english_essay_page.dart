import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/english_essays.dart';
import '../../data/study_data.dart';

class EnglishEssayPage extends StatefulWidget {
  const EnglishEssayPage({super.key});

  @override
  State<EnglishEssayPage> createState() => _EnglishEssayPageState();
}

class _EnglishEssayPageState extends State<EnglishEssayPage> {
  int _selectedGrade = 3;

  @override
  Widget build(BuildContext context) {
    List<EnglishEssay> essays = EnglishEssayData.getEssaysByGrade(_selectedGrade);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('英语作文'), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 年级选择
            Padding(
              padding: EdgeInsets.all(16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(4, (index) {
                  int grade = index + 3;
                  bool isSelected = _selectedGrade == grade;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedGrade = grade),
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 52) / 4,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.success : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? AppColors.success : AppColors.border),
                      ),
                      child: Center(child: Text('$grade年级', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.textPrimary))),
                    ),
                  );
                }),
              ),
            ),
            // 作文列表
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: essays.map((essay) => _buildEssayCard(context, essay)).toList(),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEssayCard(BuildContext context, EnglishEssay essay) {
    return GestureDetector(
      onTap: () {
        StudyData.addReadEssay();
        Navigator.push(context, MaterialPageRoute(builder: (_) => EnglishEssayDetailPage(essay: essay)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(8)), child: Text('${essay.grade}年级', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success))),
              SizedBox(width: 8),
              Text(essay.wordCount, style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
            ]),
            SizedBox(height: 10),
            Text(essay.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text(essay.titleCn, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            SizedBox(height: 8),
            Text(essay.content, style: TextStyle(fontSize: 12, color: AppColors.textTertiary, height: 1.6, overflow: TextOverflow.ellipsis), maxLines: 2),
            SizedBox(height: 10),
            Row(children: [
              Icon(Icons.lightbulb_outline, size: 14, color: AppColors.warning),
              SizedBox(width: 4),
              Text('附写作框架+中文翻译', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              Spacer(),
              Text('查看详情', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w700)),
              Icon(Icons.chevron_right, size: 16, color: AppColors.success),
            ]),
          ],
        ),
      ),
    );
  }
}

class EnglishEssayDetailPage extends StatelessWidget {
  final EnglishEssay essay;
  const EnglishEssayDetailPage({super.key, required this.essay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: AppColors.englishGradient),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(essay.title, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                      SizedBox(height: 4),
                      Text('${essay.titleCn} · ${essay.wordCount}', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 写作框架
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Color(0xFFFFFBEB), border: Border.all(color: AppColors.warning.withOpacity(0.3)), borderRadius: BorderRadius.circular(16)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [Icon(Icons.lightbulb, color: AppColors.warning, size: 20), SizedBox(width: 8), Text('写作框架', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.warning))]),
                      SizedBox(height: 12),
                      Text(essay.outline, style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.8)),
                    ]),
                  ),
                  SizedBox(height: 20),
                  // 英文原文
                  Row(children: [Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(2))), SizedBox(width: 8), Text('英文原文', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))]),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]),
                    child: Text(essay.content, style: TextStyle(fontSize: 15, color: AppColors.textPrimary, height: 2.0, letterSpacing: 0.3)),
                  ),
                  SizedBox(height: 20),
                  // 中文翻译
                  Row(children: [Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))), SizedBox(width: 8), Text('中文翻译', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))]),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]),
                    child: Text(essay.translation, style: TextStyle(fontSize: 15, color: AppColors.textPrimary, height: 2.0)),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
