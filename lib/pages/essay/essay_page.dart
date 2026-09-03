import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/essay_samples.dart';
import 'essay_detail_page.dart';

class EssayPage extends StatefulWidget {
  const EssayPage({super.key});

  @override
  State<EssayPage> createState() => _EssayPageState();
}

class _EssayPageState extends State<EssayPage> {
  int _selectedGrade = 3;
  String _selectedCategory = '全部';

  @override
  Widget build(BuildContext context) {
    List<Essay> filteredEssays = EssayData.essays.where((e) {
      bool gradeMatch = e.grade == _selectedGrade;
      bool categoryMatch = _selectedCategory == '全部' || e.category == _selectedCategory;
      return gradeMatch && categoryMatch;
    }).toList();

    List<String> categories = ['全部', ...EssayData.getCategories()];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部渐变
            Container(
              decoration: BoxDecoration(gradient: AppColors.essayGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.edit_note, color: Colors.white, size: 28),
                        SizedBox(width: 10),
                        Text('作文范文', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                      ]),
                      SizedBox(height: 8),
                      Text('1-6年级优秀作文，附写作框架', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
            // 年级选择
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(children: [
                Container(width: 4, height: 18, decoration: BoxDecoration(color: Color(0xFFF59E0B), borderRadius: BorderRadius.circular(2))),
                SizedBox(width: 8),
                Text('选择年级', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(6, (index) {
                  int grade = index + 1;
                  bool isSelected = _selectedGrade == grade;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedGrade = grade),
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 52) / 3,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.warning : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isSelected ? AppColors.warning : AppColors.border, width: isSelected ? 2 : 1),
                        boxShadow: isSelected ? [BoxShadow(color: Color(0x33F59E0B), blurRadius: 8, offset: Offset(0, 4))] : null,
                      ),
                      child: Center(child: Text('$grade年级', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.textPrimary))),
                    ),
                  );
                }),
              ),
            ),
            // 分类筛选
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(children: [
                Container(width: 4, height: 18, decoration: BoxDecoration(color: Color(0xFFFBBF24), borderRadius: BorderRadius.circular(2))),
                SizedBox(width: 8),
                Text('作文分类', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  bool isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.warning : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? AppColors.warning : AppColors.border),
                      ),
                      child: Text(cat, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textSecondary)),
                    ),
                  );
                }).toList(),
              ),
            ),
            // 范文列表
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(children: [
                Container(width: 4, height: 18, decoration: BoxDecoration(color: Color(0xFFFCD34D), borderRadius: BorderRadius.circular(2))),
                SizedBox(width: 8),
                Text('优秀作文（${filteredEssays.length}篇）', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: filteredEssays.isEmpty
                  ? Center(child: Padding(padding: EdgeInsets.all(40), child: Column(children: [Icon(Icons.article_outlined, size: 64, color: AppColors.textTertiary), SizedBox(height: 12), Text('该年级暂无此分类作文', style: TextStyle(color: AppColors.textTertiary, fontSize: 14))])))
                  : Column(
                      children: filteredEssays.map((essay) => _buildEssayCard(context, essay)).toList(),
                    ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEssayCard(BuildContext context, Essay essay) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EssayDetailPage(essay: essay))),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(8)), child: Text(essay.category, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFD97706)))),
              SizedBox(width: 8),
              Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(8)), child: Text('${essay.grade}年级', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)))),
              Spacer(),
              Text(essay.wordCount, style: TextStyle(fontSize: 11, color: AppColors.textTertiary, fontWeight: FontWeight.w600)),
            ]),
            SizedBox(height: 12),
            Text(essay.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            SizedBox(height: 8),
            Text(essay.content, style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6, overflow: TextOverflow.ellipsis), maxLines: 2),
            SizedBox(height: 12),
            Row(children: [
              Icon(Icons.lightbulb_outline, size: 14, color: AppColors.warning),
              SizedBox(width: 4),
              Text('附写作框架', style: TextStyle(fontSize: 12, color: AppColors.textTertiary, fontWeight: FontWeight.w600)),
              Spacer(),
              Text('查看详情', style: TextStyle(fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.w700)),
              Icon(Icons.chevron_right, size: 16, color: AppColors.warning),
            ]),
          ],
        ),
      ),
    );
  }
}
