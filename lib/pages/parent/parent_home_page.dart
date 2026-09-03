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
  Map<String, dynamic>? _childInfo;
  List<dynamic> _homeworkList = [];
  List<dynamic> _studyRecords = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // 模拟加载孩子信息
      _childInfo = {
        'name': '小明',
        'grade': '三年级',
        'points': 1280,
        'streak_days': 15,
        'today_done': true,
      };
      _homeworkList = [
        {'title': '数学练习：乘法运算', 'status': 'completed', 'date': '今天'},
        {'title': '英语单词：10个', 'status': 'pending', 'date': '今天'},
        {'title': '作文：我的妈妈', 'status': 'completed', 'date': '昨天'},
      ];
      _studyRecords = [
        {'subject': '数学', 'duration': '30分钟', 'date': '今天', 'score': '95分'},
        {'subject': '英语', 'duration': '20分钟', 'date': '今天', 'score': '88分'},
        {'subject': '语文', 'duration': '25分钟', 'date': '昨天', 'score': '92分'},
      ];
    } catch (e) {
      // ignore
    }
    setState(() => _isLoading = false);
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
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildChildCard(),
                  const SizedBox(height: 16),
                  _buildTodayStatus(),
                  const SizedBox(height: 16),
                  _buildSectionTitle('今日作业'),
                  ..._homeworkList.map((hw) => _buildHomeworkItem(hw)),
                  const SizedBox(height: 16),
                  _buildSectionTitle('最近学习记录'),
                  ..._studyRecords.map((record) => _buildStudyRecordItem(record)),
                  const SizedBox(height: 16),
                  _buildQuickActions(),
                ],
              ),
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
          const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Icon(Icons.child_care, size: 36, color: AppColors.primary),
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
        ],
      ),
    );
  }

  Widget _buildTodayStatus() {
    final done = _childInfo?['today_done'] == true;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: done ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: done ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(done ? Icons.check_circle : Icons.pending_actions, color: done ? Colors.green : Colors.orange, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(done ? '今日学习已完成' : '今日学习待完成', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: done ? Colors.green : Colors.orange)),
                const SizedBox(height: 4),
                Text(done ? '孩子今天很棒，继续保持！' : '孩子今天还没完成学习任务，记得提醒哦', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              ],
            ),
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

  Widget _buildHomeworkItem(Map<String, dynamic> hw) {
    final completed = hw['status'] == 'completed';
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
          Icon(completed ? Icons.check_circle : Icons.radio_button_unchecked, color: completed ? Colors.green : Colors.grey, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hw['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(hw['date'], style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              ],
            ),
          ),
          Text(completed ? '已完成' : '待完成', style: TextStyle(fontSize: 12, color: completed ? Colors.green : Colors.orange, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildStudyRecordItem(Map<String, dynamic> record) {
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
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.school, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record['subject'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('${record['date']} · 学习${record['duration']}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              ],
            ),
          ),
          Text(record['score'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
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
            Expanded(
              child: _buildActionButton(Icons.message, '联系老师', Colors.blue, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('即将跳转到私信页面')),
                );
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(Icons.assignment, '查看报告', Colors.purple, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('即将跳转到学习报告')),
                );
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(Icons.settings, '设置', Colors.grey, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('设置功能开发中')),
                );
              }),
            ),
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
}
