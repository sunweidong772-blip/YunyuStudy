import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  bool _isLoading = true;
  int _currentTab = 0;

  // 模拟数据
  final Map<String, dynamic> _stats = {
    'total_students': 128,
    'today_active': 86,
    'total_homework': 24,
    'total_points': 15680,
  };

  final List<Map<String, dynamic>> _students = [
    {'id': 1, 'name': '小明', 'grade': '三年级', 'points': 1280, 'streak': 15, 'today_done': true},
    {'id': 2, 'name': '小红', 'grade': '三年级', 'points': 1150, 'streak': 12, 'today_done': true},
    {'id': 3, 'name': '小刚', 'grade': '三年级', 'points': 980, 'streak': 8, 'today_done': false},
    {'id': 4, 'name': '小丽', 'grade': '四年级', 'points': 1420, 'streak': 20, 'today_done': true},
    {'id': 5, 'name': '小华', 'grade': '四年级', 'points': 890, 'streak': 5, 'today_done': false},
  ];

  final List<Map<String, dynamic>> _homework = [
    {'id': 1, 'title': '数学练习第3课', 'grade': '三年级', 'deadline': '2026-09-05', 'submitted': 45, 'total': 60},
    {'id': 2, 'title': '英语单词10个', 'grade': '三年级', 'deadline': '2026-09-05', 'submitted': 52, 'total': 60},
    {'id': 3, 'title': '作文：我的妈妈', 'grade': '四年级', 'deadline': '2026-09-06', 'submitted': 28, 'total': 45},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('教师后台'),
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
          : Column(
              children: [
                _buildTabBar(),
                Expanded(
                  child: _currentTab == 0 ? _buildOverview() : _currentTab == 1 ? _buildStudents() : _currentTab == 2 ? _buildHomework() : _buildSettings(),
                ),
              ],
            ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _buildTabItem(0, '数据概览', Icons.dashboard),
          _buildTabItem(1, '学生管理', Icons.people),
          _buildTabItem(2, '作业管理', Icons.assignment),
          _buildTabItem(3, '设置', Icons.settings),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label, IconData icon) {
    final isSelected = _currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.primary : AppColors.textTertiary, size: 20),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 11, color: isSelected ? AppColors.primary : AppColors.textTertiary, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverview() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('今日数据', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard('学生总数', '${_stats['total_students']}', Icons.people, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('今日活跃', '${_stats['today_active']}', Icons.whatshot, Colors.orange)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard('作业总数', '${_stats['total_homework']}', Icons.assignment, Colors.purple)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('发放积分', '${_stats['total_points']}', Icons.stars, Colors.teal)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('快捷操作', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildActionCard('布置作业', Icons.add_task, Colors.blue, () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('布置作业功能开发中')));
              })),
              const SizedBox(width: 12),
              Expanded(child: _buildActionCard('调整积分', Icons.stars, Colors.orange, () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('调整积分功能开发中')));
              })),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildActionCard('周报告', Icons.bar_chart, Colors.purple, () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('周报告功能开发中')));
              })),
              const SizedBox(width: 12),
              Expanded(child: _buildActionCard('疑难点分析', Icons.analytics, Colors.teal, () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('疑难点分析功能开发中')));
              })),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
        ],
      ),
    );
  }

  Widget _buildActionCard(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildStudents() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(student['name'].toString().substring(0, 1), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(student['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: student['today_done'] ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(student['today_done'] ? '今日已完成' : '今日未完成', style: TextStyle(fontSize: 10, color: student['today_done'] ? Colors.green : Colors.orange)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${student['grade']} · 积分${student['points']} · 连续${student['streak']}天', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'points') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('给${student["name"]}调整积分')));
                  } else if (value == 'report') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('查看${student["name"]}的学习报告')));
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'points', child: Text('调整积分')),
                  const PopupMenuItem(value: 'report', child: Text('学习报告')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomework() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _homework.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('布置新作业功能开发中')));
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.3), style: BorderStyle.solid),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle, color: AppColors.primary, size: 24),
                  SizedBox(width: 8),
                  Text('布置新作业', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
            ),
          );
        }
        final hw = _homework[index - 1];
        final progress = (hw['submitted'] / hw['total'] * 100).round();
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
                children: [
                  Expanded(child: Text(hw['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
                  Text(hw['grade'], style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                ],
              ),
              const SizedBox(height: 8),
              Text('截止日期：${hw['deadline']}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${hw['submitted']}/${hw['total']} ($progress%)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSettingItem('个人信息', Icons.person, () {}),
        _buildSettingItem('班级管理', Icons.class_, () {}),
        _buildSettingItem('消息通知设置', Icons.notifications, () {}),
        _buildSettingItem('帮助中心', Icons.help, () {}),
        _buildSettingItem('关于云屿', Icons.info, () {}),
      ],
    );
  }

  Widget _buildSettingItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
