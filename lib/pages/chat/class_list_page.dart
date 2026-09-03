import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'class_chat_page.dart';

class ClassListPage extends StatefulWidget {
  const ClassListPage({super.key});

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  List<dynamic> _myClasses = [];
  List<dynamic> _allClasses = [];
  bool _isLoading = true;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        ApiService.getMyClasses(),
        ApiService.getAllClasses(),
      ]);
      if (mounted) {
        setState(() {
          _myClasses = results[0]['list'] ?? [];
          _allClasses = results[1]['list'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _joinClass(int classId) async {
    try {
      final result = await ApiService.joinClass(classId);
      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('加入成功'), backgroundColor: AppColors.success),
          );
        }
        _loadData();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? '加入失败'), backgroundColor: AppColors.danger),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('网络错误'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('班级群'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => setState(() => _showAll = !_showAll),
            child: Text(_showAll ? '我的班级' : '全部班级', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _showAll ? _buildAllClasses() : _buildMyClasses(),
            ),
    );
  }

  Widget _buildMyClasses() {
    if (_myClasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_outlined, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('还没有加入班级群', style: TextStyle(fontSize: 16, color: AppColors.textTertiary)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() => _showAll = true),
              child: const Text('查看全部班级群'),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _myClasses.length,
      itemBuilder: (context, index) {
        final cls = _myClasses[index];
        return _buildClassCard(cls, true);
      },
    );
  }

  Widget _buildAllClasses() {
    if (_allClasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_outlined, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('暂无班级群', style: TextStyle(fontSize: 16, color: AppColors.textTertiary)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _allClasses.length,
      itemBuilder: (context, index) {
        final cls = _allClasses[index];
        return _buildClassCard(cls, cls['is_joined'] == 1);
      },
    );
  }

  Widget _buildClassCard(Map<String, dynamic> cls, bool isJoined) {
    return InkWell(
      onTap: isJoined
          ? () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => ClassChatPage(classId: cls['id'], className: cls['name'] ?? '班级群'),
              ));
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.group, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cls['name'] ?? '班级群', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(
                    '${cls['teacher_name'] ?? '教师'} · ${cls['member_count'] ?? 0}人',
                    style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
                  ),
                  if (cls['description'] != null && cls['description'].toString().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(cls['description'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
            if (!isJoined)
              TextButton(
                onPressed: () => _joinClass(cls['id']),
                child: const Text('加入'),
              )
            else
              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
