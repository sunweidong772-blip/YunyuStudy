import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({super.key});

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  List<dynamic> _homework = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomework();
  }

  Future<void> _loadHomework() async {
    try {
      final result = await ApiService.getHomework();
      if (result['success'] == true && mounted) {
        setState(() {
          _homework = result['list'] ?? [];
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitHomework(int id) async {
    try {
      final result = await ApiService.submitHomework(id);
      if (result['success'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? '提交成功'), backgroundColor: AppColors.success),
        );
        _loadHomework();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? '提交失败'), backgroundColor: AppColors.danger),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('网络错误'), backgroundColor: AppColors.danger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pending = _homework.where((h) => h['status'] == 'pending').toList();
    final completed = _homework.where((h) => h['status'] == 'completed').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的作业'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _homework.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text('暂无作业', style: TextStyle(fontSize: 16, color: AppColors.textTertiary)),
                      const SizedBox(height: 8),
                      const Text('教师布置作业后会在这里显示', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadHomework,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (pending.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text('待完成', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        ),
                        ...pending.map((h) => _buildHomeworkCard(h, false)),
                        const SizedBox(height: 16),
                      ],
                      if (completed.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text('已完成', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        ),
                        ...completed.map((h) => _buildHomeworkCard(h, true)),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildHomeworkCard(Map<String, dynamic> h, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        border: isCompleted ? Border.all(color: AppColors.success.withOpacity(0.3)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(h['subject'] ?? '综合', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isCompleted ? '已完成' : '待完成',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isCompleted ? AppColors.success : AppColors.warning),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(h['title'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          if (h['content'] != null && h['content'].toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(h['content'], style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text('教师：${h['teacher_name'] ?? '未知'}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              const Spacer(),
              if (h['deadline'] != null) ...[
                Icon(Icons.schedule, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text('截止：${h['deadline']}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              ],
            ],
          ),
          if (!isCompleted) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => _submitHomework(h['id']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('标记完成', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
          if (isCompleted && h['submitted_at'] != null) ...[
            const SizedBox(height: 8),
            Text('提交时间：${h['submitted_at']}', style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
          ],
        ],
      ),
    );
  }
}
