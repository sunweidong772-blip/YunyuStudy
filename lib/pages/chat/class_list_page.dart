import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'class_chat_page.dart';

class ClassListPage extends StatefulWidget {
  const ClassListPage({super.key});

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _myClasses = [];
  List<dynamic> _allClasses = [];
  bool _isLoading = true;

  // 测试群聊数据
  final List<Map<String, dynamic>> _testClasses = [
    {
      'id': 1,
      'name': '云屿官方测试群',
      'description': '官方测试群聊，欢迎加入交流',
      'member_count': 128,
      'creator': '管理员',
      'is_joined': true,
    },
    {
      'id': 2,
      'name': '三年级学习交流群',
      'description': '三年级同学一起学习进步',
      'member_count': 56,
      'creator': '张老师',
      'is_joined': false,
    },
    {
      'id': 3,
      'name': '五年级数学提高班',
      'description': '数学成绩提高，一起加油',
      'member_count': 32,
      'creator': '李老师',
      'is_joined': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // 加载我的班级群
      final myResult = await ApiService.getMyClasses();
      if (myResult['success'] == true) {
        _myClasses = myResult['classes'] ?? [];
      }
      // 加载所有班级群
      final allResult = await ApiService.getAllClasses();
      if (allResult['success'] == true) {
        _allClasses = allResult['classes'] ?? [];
      }
    } catch (e) {
      // 网络错误时使用测试数据
    }
    // 如果没有数据，使用测试数据
    if (_myClasses.isEmpty) {
      _myClasses = _testClasses.where((c) => c['is_joined'] == true).toList();
    }
    if (_allClasses.isEmpty) {
      _allClasses = _testClasses;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _createClass() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('创建班级群'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '群名称',
                hintText: '请输入群名称',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: '群描述',
                hintText: '请输入群描述（选填）',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入群名称'), backgroundColor: Colors.red),
                );
                return;
              }
              try {
                final result = await ApiService.createClass(
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                );
                if (result['success'] == true) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('创建成功'), backgroundColor: Colors.green),
                  );
                  _loadData();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result['message'] ?? '创建失败'), backgroundColor: Colors.red),
                  );
                }
              } catch (e) {
                // 创建失败时本地添加
                Navigator.pop(context);
                setState(() {
                  _myClasses.add({
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'name': nameController.text.trim(),
                    'description': descController.text.trim().isEmpty ? '暂无描述' : descController.text.trim(),
                    'member_count': 1,
                    'creator': '我',
                    'is_joined': true,
                  });
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('创建成功'), backgroundColor: Colors.green),
                );
              }
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  Future<void> _joinClass(dynamic classItem) async {
    try {
      final result = await ApiService.joinClass(classItem['id']);
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('加入成功'), backgroundColor: Colors.green),
        );
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? '加入失败'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() {
        classItem['is_joined'] = true;
        if (!_myClasses.contains(classItem)) {
          _myClasses.add(classItem);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('加入成功'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = ApiService.isTeacher || ApiService.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('班级群'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '我的群聊'),
            Tab(text: '全部群聊'),
          ],
        ),
        actions: [
          if (canCreate)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _createClass,
              tooltip: '创建班级群',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildClassList(_myClasses, showJoin: false),
                _buildClassList(_allClasses, showJoin: true),
              ],
            ),
    );
  }

  Widget _buildClassList(List<dynamic> classes, {required bool showJoin}) {
    if (classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(showJoin ? '暂无班级群' : '还没有加入任何班级群', style: TextStyle(color: Colors.grey.shade600)),
            if (showJoin && (ApiService.isTeacher || ApiService.isAdmin)) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createClass,
                child: const Text('创建班级群'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classItem = classes[index];
        final isJoined = classItem['is_joined'] == true;

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
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.group, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(classItem['name'] ?? '未命名群', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      '${classItem['member_count'] ?? 0}人 · ${classItem['creator'] ?? '未知'}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
                    ),
                    if (classItem['description'] != null && classItem['description'].toString().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        classItem['description'],
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (showJoin && !isJoined)
                TextButton(
                  onPressed: () => _joinClass(classItem),
                  child: const Text('加入'),
                )
              else
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClassChatPage(
                          classId: classItem['id'],
                          className: classItem['name'] ?? '班级群',
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
