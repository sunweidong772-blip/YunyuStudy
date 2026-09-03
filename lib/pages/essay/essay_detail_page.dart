import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/essay_samples.dart';

class EssayDetailPage extends StatelessWidget {
  final Essay essay;
  const EssayDetailPage({super.key, required this.essay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 顶部渐变标题
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: AppColors.essayGradient),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(8)), child: Text(essay.category, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))),
                          SizedBox(width: 8),
                          Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(8)), child: Text('${essay.grade}年级', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))),
                          SizedBox(width: 8),
                          Text(essay.wordCount, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85), fontWeight: FontWeight.w600)),
                        ]),
                        SizedBox(height: 12),
                        Text(essay.title, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                      ],
                    ),
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
                  // 范文正文
                  Row(children: [
                    Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.warning, borderRadius: BorderRadius.circular(2))),
                    SizedBox(width: 8),
                    Text('范文正文', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  ]),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]),
                    child: Text(
                      essay.content,
                      style: TextStyle(fontSize: 15, color: AppColors.textPrimary, height: 2.0, letterSpacing: 0.3),
                    ),
                  ),
                  SizedBox(height: 20),
                  // 学习提示
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Color(0xFFEFF6FF), border: Border.all(color: AppColors.primary.withOpacity(0.2)), borderRadius: BorderRadius.circular(16)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [Icon(Icons.tips_and_updates, color: AppColors.primary, size: 20), SizedBox(width: 8), Text('学习提示', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary))]),
                      SizedBox(height: 12),
                      Text('1. 先看写作框架，了解文章结构\n2. 再读范文正文，学习好词好句\n3. 最后模仿框架，自己写一篇同类型作文\n4. 可以把范文中的好词好句摘抄下来', style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.8)),
                    ]),
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
