import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class ChangelogPage extends StatefulWidget {
  const ChangelogPage({super.key});

  @override
  State<ChangelogPage> createState() => _ChangelogPageState();
}

class _ChangelogPageState extends State<ChangelogPage> {
  List<dynamic> _versions = [];
  bool _isLoading = true;

  // 本地更新日志（兜底）
  final List<Map<String, dynamic>> _localChangelog = [
    {
      'version': 'v2.1.0',
      'title': '第三阶段重大更新',
      'date': '2026-09-03',
      'content': '''
【新增功能】
1. 后台用户管理：管理员可添加/删除家长、学生、老师
2. 班级群功能：创建班级群，群内消息互通
3. 私信功能：家长/学生私信老师，老师私信学生和家长
4. 身份头衔：教师、学生、家长不同头衔，教师有"已认证"标识
5. 教师自主认证：提供工作经历/教师资格证，24小时内审核
6. 官方QQ群入口：一键加入官方QQ群
7. 云屿小助手：智能问答、今日待办提醒、自动解答学生问题
8. 软件更新推送：管理员弹窗推送更新，邮箱提醒
9. 更新日志：我的页面查看版本更新历史

【优化改进】
1. 注册页移除教师身份选项，教师需通过认证或管理员设置
2. 登录页移除测试账号提示
3. 修复登录不上的问题
4. 优化消息通知体验
5. 提升整体性能和稳定性

【教师认证说明】
- 教师身份只能由最高管理员设置
- 管理员设置的教师和自主认证通过的教师都有教师头衔和已认证标识
- 认证期间可能会有官方人员通过提交的联系方式进行复核
'''
    },
    {
      'version': 'v2.0.0',
      'title': '第二阶段功能完善',
      'date': '2026-09-03',
      'content': '''
【新增功能】
1. 邮箱验证码注册：QQ邮箱发送验证码
2. 邮箱+密码登录：替换旧的用户名登录
3. 三角色系统：学生/教师/家长
4. 我的页面全面升级：用户信息、积分、统计数据
5. 消息通知中心：作业通知、积分奖励、系统通知
6. 我的作业模块：查看教师布置的作业，标记完成
7. 学习记录云端同步：数学练习、每日小考自动同步
8. 错题本云端同步：做错的题自动同步到云端
9. 每日打卡对接后端：打卡获得积分

【后端服务】
- 部署到云服务器：http://8.160.178.28:8090
- 教师后台网页：http://8.160.178.28:8090/admin
- SQLite数据库存储
- QQ邮箱SMTP服务
'''
    },
    {
      'version': 'v1.0.0',
      'title': '初始版本发布',
      'date': '2026-09-02',
      'content': '''
【基础功能】
1. 数学练习：1-6年级智能出题，选择题+解析
2. 英语单词：1-6年级必考单词，卡片式学习
3. 作文范文：1-6年级优秀作文，写作框架
4. 底部导航：首页/数学/英语/作文/我的
5. 云屿天空蓝品牌风格

【首页功能】
1. 搜索功能：搜索单词、作文
2. 快捷功能：每日小考、英语作文、错题本
3. 年级选择

【学习工具】
1. 每日小考：10道题，5分钟倒计时
2. 错题本：自动收集做错的题目
3. 英语作文：3-6年级范文+翻译+框架
'''
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadChangelog();
  }

  Future<void> _loadChangelog() async {
    try {
      final result = await ApiService.getChangelog();
      if (result['success'] == true && result['list'] != null && result['list'].length > 0) {
        if (mounted) {
          setState(() {
            _versions = result['list'];
            _isLoading = false;
          });
        }
        return;
      }
    } catch (e) {
      // 使用本地数据
    }
    if (mounted) {
      setState(() {
        _versions = _localChangelog;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('更新日志'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _versions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.update, size: 72, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text('暂无更新日志', style: TextStyle(fontSize: 16, color: AppColors.textTertiary)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _versions.length,
                  itemBuilder: (context, index) {
                    final version = _versions[index];
                    return _buildVersionCard(version, index == 0);
                  },
                ),
    );
  }

  Widget _buildVersionCard(Map<String, dynamic> version, bool isLatest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        border: isLatest ? Border.all(color: AppColors.primary.withOpacity(0.3)) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    version['version'] ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isLatest) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('最新版本', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ],
                const Spacer(),
                Text(
                  version['date'] ?? version['created_at'] ?? '',
                  style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
                ),
              ],
            ),
            if (version['title'] != null) ...[
              const SizedBox(height: 12),
              Text(
                version['title'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              version['content'] ?? '',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
