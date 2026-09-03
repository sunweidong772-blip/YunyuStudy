import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/study_data.dart';
import '../math/wrong_book_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _mathCount = 0;
  int _wordCount = 0;
  int _essayCount = 0;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _mathCount = StudyData.mathPracticeCount;
      _wordCount = StudyData.learnedWords;
      _essayCount = StudyData.readEssays;
      _streak = StudyData.streakDays;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(gradient: AppColors.brandGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Row(
                    children: [
                      Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(32), border: Border.all(color: Colors.white, width: 2)), child: Icon(Icons.person, color: Colors.white, size: 36)),
                      SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('云屿小学员', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                        SizedBox(height: 4),
                        Text('每天进步一点点', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
                      ])),
                      GestureDetector(onTap: () => _showLoginDialog(), child: Container(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)), child: Text('登录', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)))),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Container(
                transform: Matrix4.translationValues(0, -20, 0),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Color(0x1A172C49), blurRadius: 16, offset: Offset(0, 8))]),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _buildStat('$_mathCount', '数学练习', AppColors.primary),
                  _buildStat('$_wordCount', '已学单词', AppColors.success),
                  _buildStat('$_essayCount', '阅读作文', AppColors.warning),
                  _buildStat('$_streak', '连续打卡', AppColors.accent),
                ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(children: [Container(width: 4, height: 18, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2))), SizedBox(width: 8), Text('学习工具', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary))]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]),
                child: Column(children: [
                  _buildMenuItem(Icons.error_outline, '错题本', '复习做错的题目', AppColors.danger, () => Navigator.push(context, MaterialPageRoute(builder: (_) => WrongBookPage()))),
                  _buildDivider(),
                  _buildMenuItem(Icons.favorite_border, '我的收藏', '收藏的单词和作文', AppColors.danger, () => _showInfo('我的收藏', '收藏功能开发中，敬请期待！')),
                  _buildDivider(),
                  _buildMenuItem(Icons.history, '学习记录', '查看历史学习记录', AppColors.primary, () => _showInfo('学习记录', '数学练习 $_mathCount 次\n已学单词 $_wordCount 个\n阅读作文 $_essayCount 篇\n连续打卡 $_streak 天')),
                  _buildDivider(),
                  _buildMenuItem(Icons.calendar_today, '每日打卡', '每天学习后打卡', AppColors.success, () async { await StudyData.checkIn(); _loadData(); _showSuccess('打卡成功！连续 $_streak 天'); }),
                ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(children: [Container(width: 4, height: 18, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2))), SizedBox(width: 8), Text('更多', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary))]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]),
                child: Column(children: [
                  _buildMenuItem(Icons.notifications_none, '消息通知', '学习提醒和通知', AppColors.warning, () => _showInfo('消息通知', '暂无新消息')),
                  _buildDivider(),
                  _buildMenuItem(Icons.help_outline, '帮助中心', '常见问题解答', AppColors.success, () => _showInfo('帮助中心', '1. 如何使用数学练习？\n点击底部"数学"，选择年级即可开始练习\n\n2. 如何朗读单词？\n在单词卡片页面点击喇叭图标即可朗读\n\n3. 错题在哪里？\n在"我的"页面点击"错题本"查看\n\n4. 如何打卡？\n在"我的"页面点击"每日打卡"')),
                  _buildDivider(),
                  _buildMenuItem(Icons.info_outline, '关于云屿', '版本信息', AppColors.textTertiary, () => _showInfo('关于云屿', '云屿小学学业辅导工具\n版本：v2.0.0\n\n涵盖数学练习、英语单词、作文范文三大模块，覆盖小学1-6年级。\n\n让学习更轻松，让成长更快乐！')),
                ]),
              ),
            ),
            SizedBox(height: 24),
            Center(child: Text('云屿学习 v2.0.0', style: TextStyle(color: AppColors.textTertiary, fontSize: 12))),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, Color color) => Column(children: [Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)), SizedBox(height: 4), Text(label, style: TextStyle(fontSize: 11, color: AppColors.textTertiary, fontWeight: FontWeight.w600))]);

  Widget _buildMenuItem(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14), child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 20)),
      SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)), SizedBox(height: 2), Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textTertiary))])),
      Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
    ])),
  );

  Widget _buildDivider() => Padding(padding: EdgeInsets.only(left: 70), child: Divider(height: 1, color: AppColors.divider));

  void _showInfo(String title, String content) => showDialog(context: context, builder: (d) => AlertDialog(title: Text(title), content: Text(content, style: TextStyle(height: 1.6)), actions: [TextButton(onPressed: () => Navigator.pop(d), child: Text('知道了'))]));

  void _showSuccess(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));

  void _showLoginDialog() => showDialog(context: context, builder: (d) => AlertDialog(
    title: Text('登录云屿'),
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(decoration: InputDecoration(hintText: '请输入邮箱', prefixIcon: Icon(Icons.email)), keyboardType: TextInputType.emailAddress),
      SizedBox(height: 12),
      TextField(decoration: InputDecoration(hintText: '请输入密码', prefixIcon: Icon(Icons.lock)), obscureText: true),
    ]),
    actions: [TextButton(onPressed: () => Navigator.pop(d), child: Text('取消')), FilledButton(onPressed: () { Navigator.pop(d); _showSuccess('登录功能开发中，敬请期待！'); }, child: Text('登录'))],
  ));
}
