import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'math/math_page.dart';
import 'english/english_page.dart';
import 'essay/essay_page.dart';
import 'profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const StudyHomePage(),
    const MathPage(),
    const EnglishPage(),
    const EssayPage(),
    const ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [BoxShadow(color: Color(0x08172C49), blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home_rounded, '首页'),
              _buildNavItem(1, Icons.calculate_outlined, Icons.calculate_rounded, '数学'),
              _buildNavItem(2, Icons.menu_book_outlined, Icons.menu_book_rounded, '英语'),
              _buildNavItem(3, Icons.edit_note_outlined, Icons.edit_note_rounded, '作文'),
              _buildNavItem(4, Icons.person_outline_rounded, Icons.person_rounded, '我的'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outline, IconData filled, String label) {
    final on = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 58,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
              decoration: BoxDecoration(
                color: on ? AppColors.primaryLight : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(on ? filled : outline, size: 20, color: on ? AppColors.primary : AppColors.textTertiary),
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: on ? FontWeight.w700 : FontWeight.w500, color: on ? AppColors.primary : AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }
}

class StudyHomePage extends StatelessWidget {
  const StudyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部渐变区域
            Container(
              decoration: BoxDecoration(gradient: AppColors.brandGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(14)), child: Icon(Icons.cloud, color: Colors.white, size: 26)),
                        SizedBox(width: 12),
                        Text('云屿学习', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                      ]),
                      SizedBox(height: 8),
                      Text('小学1-6年级同步辅导', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14)),
                      SizedBox(height: 20),
                      // 搜索框
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                        child: Row(children: [
                          Icon(Icons.search, color: AppColors.textTertiary, size: 20),
                          SizedBox(width: 8),
                          Text('搜索题目、单词、作文...', style: TextStyle(color: AppColors.textTertiary, fontSize: 14)),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 三大模块
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(children: [
                Container(width: 4, height: 18, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                SizedBox(width: 8),
                Text('学习模块', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildModuleCard(context, '数学练习', '1-6年级题库 · 自动出题', Icons.calculate, AppColors.mathGradient, () {
                    final state = context.findAncestorStateOfType<_HomePageState>();
                    state?._onTabTapped(1);
                  }),
                  SizedBox(height: 12),
                  _buildModuleCard(context, '英语单词', '1-6年级必考单词 · 记忆打卡', Icons.menu_book, AppColors.englishGradient, () {
                    final state = context.findAncestorStateOfType<_HomePageState>();
                    state?._onTabTapped(2);
                  }),
                  SizedBox(height: 12),
                  _buildModuleCard(context, '作文范文', '1-6年级优秀作文 · 写作框架', Icons.edit_note, AppColors.essayGradient, () {
                    final state = context.findAncestorStateOfType<_HomePageState>();
                    state?._onTabTapped(3);
                  }),
                ],
              ),
            ),
            // 今日推荐
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(children: [
                Container(width: 4, height: 18, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2))),
                SizedBox(width: 8),
                Text('今日推荐', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]),
                child: Row(children: [
                  Container(width: 50, height: 50, decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: BorderRadius.circular(14)), child: Icon(Icons.lightbulb, color: Colors.white, size: 26)),
                  SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('每日一句', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    SizedBox(height: 4),
                    Text('学而不思则罔，思而不学则殆。', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ])),
                ]),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, String title, String subtitle, IconData icon, Gradient gradient, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]),
        child: Row(children: [
          Container(width: 56, height: 56, decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: Colors.white, size: 28)),
          SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
          ])),
          Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 24),
        ]),
      ),
    );
  }
}
