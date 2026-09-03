import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({super.key});

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  bool _isLoading = true;
  bool _isChildBound = false;
  Map<String, dynamic>? _childInfo;
  List<dynamic> _todayTasks = [];
  List<dynamic> _studyRecords = [];
  final TextEditingController _childAccountController = TextEditingController();

  // 模拟孩子数据
  final Map<String, dynamic> _mockChild = {
    'name': '小明',
    'nickname': '小明同学',
    'email': 'xiaoming@qq.com',
    'grade': '三年级',
    'points': 1280,
    'streak_days': 15,
    'today_done': false,
    'today_progress': 60,
  };

  final List<Map<String, dynamic>> _mockTasks = [
    {'title': '数学练习：乘法运算', 'status': 'completed', 'subject': '数学', 'duration': '15分钟'},
    {'title': '英语单词：10个', 'status': 'pending', 'subject': '英语', 'duration': '10分钟'},
    {'title': '作文：我的妈妈', 'status': 'pending', 'subject': '语文', 'duration': '20分钟'},
    {'title': '每日小考', 'status': 'pending', 'subject': '综合', 'duration': '10分钟'},
  ];

  final List<Map<String, dynamic>> _mockRecords = [
    {'subject': '数学', 'duration': '30分钟', 'date': '今天', 'score': '95分', 'content': '乘法运算练习'},
    {'subject': '英语', 'duration': '20分钟', 'date': '今天', 'score': '88分', 'content': '三年级单词学习'},
    {'subject': '语文', 'duration': '25分钟', 'date': '昨天', 'score': '92分', 'content': '优秀作文阅读'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    // 模拟加载数据
    _childInfo = _mockChild;
    _isChildBound = true;
    _todayTasks = List<Map<String, dynamic>>.from(_mockTasks);
    _studyRecords = List<Map<String, dynamic>>.from(_mockRecords);
    setState(() => _isLoading = false);
  }

  Future<void> _bindChild() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('绑定孩子账号'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('请输入孩子的账号邮箱进行绑定', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
            const SizedBox(height: 12),
            TextField(
              controller: _childAccountController,
              decoration: const InputDecoration(
                labelText: '孩子账号邮箱',
                hintText: '请输入孩子的注册邮箱',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              if (_childAccountController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入孩子账号邮箱'), backgroundColor: Colors.red),
                );
                return;
              }
              Navigator.pop(context);
              setState(() {
                _isChildBound = true;
                _childInfo = _mockChild;
                _childInfo!['email'] = _childAccountController.text.trim();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('绑定成功！'), backgroundColor: Colors.green),
              );
            },
            child: const Text('绑定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('家长端'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('暂无新通知')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_isChildBound
              ? _buildUnboundView()
              : _buildBoundView(),
    );
  }

  Widget _buildUnboundView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.child_care, size: 50, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text('还未绑定孩子账号', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const Text(
              '绑定孩子账号后，可以查看孩子的学习进度、作业完成情况、学习记录等',
              style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _bindChild,
                child: const Text('绑定孩子账号', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoundView() {
    final completedTasks = _todayTasks.where((t) => t['status'] == 'completed').length;
    final totalTasks = _todayTasks.length;
    final progress = totalTasks > 0 ? (completedTasks / totalTasks * 100).round() : 0;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildChildCard(),
          const SizedBox(height: 16),
          _buildTodayProgress(progress, completedTasks, totalTasks),
          const SizedBox(height: 16),
          _buildSectionTitle('今日作业任务'),
          ..._todayTasks.map((task) => _buildTaskItem(task)),
          const SizedBox(height: 16),
          _buildSectionTitle('最近学习记录'),
          ..._studyRecords.map((record) => _buildRecordItem(record)),
          const SizedBox(height: 16),
          _buildQuickActions(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildChildCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Text(
              _childInfo?['name']?.toString().substring(0, 1) ?? '孩',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_childInfo?['name'] ?? '孩子', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 4),
                Text('${_childInfo?['grade'] ?? ''} · 积分 ${_childInfo?['points'] ?? 0}', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text('连续学习${_childInfo?['streak_days'] ?? 0}天', style: const TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _bindChild,
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('切换', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayProgress(int progress, int completed, int total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('今日学习进度', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Text('$completed/$total 已完成', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: progress == 100 ? Colors.green : AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(progress == 100 ? Colors.green : AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            progress == 100 ? '太棒了！今日任务全部完成！🎉' : '还有${total - completed}项任务未完成，记得提醒孩子哦',
            style: TextStyle(fontSize: 12, color: progress == 100 ? Colors.green : AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    final completed = task['status'] == 'completed';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _getSubjectColor(task['subject']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_getSubjectIcon(task['subject']), color: _getSubjectColor(task['subject']), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['title'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, decoration: completed ? TextDecoration.lineThrough : null)),
                const SizedBox(height: 2),
                Text('${task['subject']} · 约${task['duration']}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: completed ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(completed ? '已完成' : '待完成', style: TextStyle(fontSize: 11, color: completed ? Colors.green : Colors.orange, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordItem(Map<String, dynamic> record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getSubjectColor(record['subject']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_getSubjectIcon(record['subject']), color: _getSubjectColor(record['subject']), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record['subject'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('${record['content']} · 学习${record['duration']}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(record['score'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
              Text(record['date'], style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('快捷操作'),
        Row(
          children: [
            Expanded(child: _buildActionButton(Icons.message, '联系老师', Colors.blue, () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('即将跳转到私信页面')));
            })),
            const SizedBox(width: 12),
            Expanded(child: _buildActionButton(Icons.assignment, '学习报告', Colors.purple, () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('学习报告功能开发中')));
            })),
            const SizedBox(width: 12),
            Expanded(child: _buildActionButton(Icons.calendar_today, '周汇总', Colors.teal, () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('周汇总功能开发中')));
            })),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Color _getSubjectColor(String? subject) {
    switch (subject) {
      case '数学': return AppColors.primary;
      case '英语': return Colors.teal;
      case '语文': return Colors.orange;
      default: return Colors.purple;
    }
  }

  IconData _getSubjectIcon(String? subject) {
    switch (subject) {
      case '数学': return Icons.calculate;
      case '英语': return Icons.menu_book;
      case '语文': return Icons.edit_note;
      default: return Icons.school;
    }
  }
}
