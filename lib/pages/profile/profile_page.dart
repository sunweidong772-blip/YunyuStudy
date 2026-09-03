import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                    ],
                  ),
                ),
              ),
            ),
            // 学习数据
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Container(
                transform: Matrix4.translationValues(0, -20, 0),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Color(0x1A172C49), blurRadius: 16, offset: Offset(0, 8))]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('0', '数学练习', AppColors.primary),
                    _buildStat('0', '已学单词', AppColors.success),
                    _buildStat('0', '阅读作文', AppColors.warning),
                    _buildStat('0', '连续打卡', AppColors.accent),
                  ],
                ),
              ),
            ),
            // 功能列表
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(children: [
                Container(width: 4, height: 18, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2))),
                SizedBox(width: 8),
                Text('更多功能', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Color(0x0A172C49), blurRadius: 12, offset: Offset(0, 4))]),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.favorite, '我的收藏', '收藏的题目和作文', AppColors.danger),
                    _buildDivider(),
                    _buildMenuItem(Icons.history, '学习记录', '查看历史学习记录', AppColors.primary),
                    _buildDivider(),
                    _buildMenuItem(Icons.notifications, '消息通知', '学习提醒和通知', AppColors.warning),
                    _buildDivider(),
                    _buildMenuItem(Icons.help, '帮助中心', '常见问题解答', AppColors.success),
                    _buildDivider(),
                    _buildMenuItem(Icons.info, '关于云屿', '版本信息', AppColors.textTertiary),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Center(child: Text('云屿学习 v1.0.0', style: TextStyle(color: AppColors.textTertiary, fontSize: 12))),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
      SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 11, color: AppColors.textTertiary, fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle, Color color) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 20)),
          SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
          ])),
          Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
        ]),
      ),
    );
  }

  Widget _buildDivider() => Padding(padding: EdgeInsets.only(left: 70), child: Divider(height: 1, color: AppColors.divider));
}
