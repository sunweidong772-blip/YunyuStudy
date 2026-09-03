import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../math/wrong_book_page.dart';
import '../auth/login_page.dart';
import 'message_page.dart';
import 'homework_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userInfo;
  Map<String, dynamic>? _stats;
  int _unreadMessages = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!ApiService.isLoggedIn) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      final results = await Future.wait([
        ApiService.getProfile(),
        ApiService.getStats(),
        ApiService.getMessages(),
      ]);
      if (mounted) {
        setState(() {
          if (results[0]['success'] == true) _userInfo = results[0]['user'];
          if (results[1]['success'] == true) _stats = results[1]['stats'];
          if (results[2]['success'] == true) _unreadMessages = results[2]['unread'] ?? 0;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _checkIn() async {
    if (!ApiService.isLoggedIn) {
      _showLoginPrompt();
      return;
    }
    try {
      final result = await ApiService.checkIn();
      if (result['success'] == true) {
        _showSuccess(result['message'] ?? '打卡成功');
        _loadData();
      } else {
        _showError(result['message'] ?? '打卡失败');
      }
    } catch (e) {
      _showError('网络错误');
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text('取消')),
          FilledButton(
            onPressed: () async {
              await ApiService.clearToken();
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }

  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('请先登录'),
        content: const Text('该功能需要登录后使用'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              Navigator.pop(d);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
            child: const Text('去登录'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nickname = _userInfo?['nickname'] ?? '云屿小学员';
    final email = _userInfo?['email'] ?? '';
    final points = _stats?['totalPoints'] ?? 0;
    final streakDays = _stats?['streakDays'] ?? 0;
    final totalExams = _stats?['totalExams'] ?? 0;
    final totalWrong = _stats?['totalWrong'] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部用户信息
                  Container(
                    decoration: const BoxDecoration(gradient: AppColors.brandGradient),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.person, color: Colors.white, size: 36),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(nickname, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 4),
                                  Text(email.isNotEmpty ? email : '每天进步一点点', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
                                ],
                              ),
                            ),
                            if (ApiService.isLoggedIn)
                              GestureDetector(
                                onTap: _logout,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                  child: const Text('退出', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 积分和统计卡片
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Container(
                      transform: Matrix4.translationValues(0, -20, 0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: const Color(0x1A172C49), blurRadius: 16, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.stars, color: Colors.amber, size: 24),
                              const SizedBox(width: 8),
                              Text('$points', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary)),
                              const SizedBox(width: 8),
                              const Text('积分', style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1, color: AppColors.divider),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStat('$totalExams', '考试次数', AppColors.primary),
                              _buildStat('$totalWrong', '错题数', AppColors.danger),
                              _buildStat('$streakDays', '连续打卡', AppColors.success),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 学习工具
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(children: [
                      Container(width: 4, height: 18, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 8),
                      const Text('学习工具', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: const Color(0x0A172C49), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(Icons.assignment, '我的作业', '查看教师布置的作业', AppColors.primary, () {
                            if (!ApiService.isLoggedIn) return _showLoginPrompt();
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeworkPage()));
                          }),
                          _buildDivider(),
                          _buildMenuItem(Icons.error_outline, '错题本', '复习做错的题目', AppColors.danger, () {
                            if (!ApiService.isLoggedIn) return _showLoginPrompt();
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const WrongBookPage()));
                          }),
                          _buildDivider(),
                          _buildMenuItem(Icons.favorite_border, '我的收藏', '收藏的单词和作文', AppColors.danger, () {
                            _showInfo('我的收藏', '收藏功能开发中，敬请期待！');
                          }),
                          _buildDivider(),
                          _buildMenuItem(Icons.history, '学习记录', '查看历史学习记录', AppColors.primary, () {
                            if (!ApiService.isLoggedIn) return _showLoginPrompt();
                            _showInfo('学习记录', '考试次数：$totalExams 次\n错题数：$totalWrong 道\n连续打卡：$streakDays 天\n当前积分：$points 分');
                          }),
                          _buildDivider(),
                          _buildMenuItem(Icons.calendar_today, '每日打卡', '每天学习后打卡', AppColors.success, _checkIn),
                        ],
                      ),
                    ),
                  ),
                  // 更多
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(children: [
                      Container(width: 4, height: 18, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 8),
                      const Text('更多', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: const Color(0x0A172C49), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(Icons.notifications_none, '消息通知', '学习提醒和通知', AppColors.warning, () {
                            if (!ApiService.isLoggedIn) return _showLoginPrompt();
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const MessagePage())).then((_) => _loadData());
                          }, badge: _unreadMessages),
                          _buildDivider(),
                          _buildMenuItem(Icons.help_outline, '帮助中心', '常见问题解答', AppColors.success, () {
                            _showInfo('帮助中心', '1. 如何使用数学练习？\n点击底部"数学"，选择年级即可开始练习\n\n2. 如何查看作业？\n在"我的"页面点击"我的作业"查看教师布置的作业\n\n3. 错题在哪里？\n在"我的"页面点击"错题本"查看\n\n4. 如何打卡？\n在"我的"页面点击"每日打卡"');
                          }),
                          _buildDivider(),
                          _buildMenuItem(Icons.info_outline, '关于云屿', '版本信息', AppColors.textTertiary, () {
                            _showInfo('关于云屿', '云屿小学学业辅导工具\n版本：v2.0.0\n\n涵盖数学练习、英语单词、作文范文三大模块，覆盖小学1-6年级。\n\n教师后台：http://8.160.178.28:8090/admin\n\n让学习更轻松，让成长更快乐！');
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(child: Text('云屿学习 v2.0.0', style: TextStyle(color: AppColors.textTertiary, fontSize: 12))),
                  const SizedBox(height: 12),
                ],
              ),
            ),
    );
  }

  Widget _buildStat(String value, String label, Color color) => Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary, fontWeight: FontWeight.w600)),
        ],
      );

  Widget _buildMenuItem(IconData icon, String title, String subtitle, Color color, VoidCallback onTap, {int? badge}) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                  ],
                ),
              ),
              if (badge != null && badge > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.danger, borderRadius: BorderRadius.circular(10)),
                  child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
            ],
          ),
        ),
      );

  Widget _buildDivider() => const Padding(padding: EdgeInsets.only(left: 70), child: Divider(height: 1, color: AppColors.divider));

  void _showInfo(String title, String content) => showDialog(
        context: context,
        builder: (d) => AlertDialog(
          title: Text(title),
          content: Text(content, style: const TextStyle(height: 1.6)),
          actions: [TextButton(onPressed: () => Navigator.pop(d), child: const Text('知道了'))],
        ),
      );

  void _showSuccess(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating),
      );

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.danger, behavior: SnackBarBehavior.floating),
      );
}
