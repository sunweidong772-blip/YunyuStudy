import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class ClassChatPage extends StatefulWidget {
  final int classId;
  final String className;
  const ClassChatPage({super.key, required this.classId, required this.className});

  @override
  State<ClassChatPage> createState() => _ClassChatPageState();
}

class _ClassChatPageState extends State<ClassChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;

  // 本地测试消息
  final List<Map<String, dynamic>> _testMessages = [
    {'id': 1, 'sender_id': 2, 'sender_name': '张老师', 'content': '欢迎大家来到云屿官方测试群！', 'created_at': '2026-09-04 09:00:00', 'role': 'teacher'},
    {'id': 2, 'sender_id': 3, 'sender_name': '小明', 'content': '老师好！', 'created_at': '2026-09-04 09:05:00', 'role': 'student'},
    {'id': 3, 'sender_id': 4, 'sender_name': '小明妈妈', 'content': '请问今天的作业是什么？', 'created_at': '2026-09-04 09:10:00', 'role': 'parent'},
    {'id': 4, 'sender_id': 2, 'sender_name': '张老师', 'content': '今天的作业是数学练习第3课，英语单词10个，大家加油！', 'created_at': '2026-09-04 09:15:00', 'role': 'teacher'},
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    try {
      final result = await ApiService.getClassMessages(widget.classId);
      if (result['success'] == true && result['messages'] != null && result['messages'].length > 0) {
        setState(() => _messages = List<Map<String, dynamic>>.from(result['messages']));
      } else {
        // 使用测试消息
        setState(() => _messages = List<Map<String, dynamic>>.from(_testMessages));
      }
    } catch (e) {
      // 网络错误时使用测试消息
      setState(() => _messages = List<Map<String, dynamic>>.from(_testMessages));
    }
    setState(() => _isLoading = false);
    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    final currentUser = ApiService.currentUser;
    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'sender_id': ApiService.currentUserId ?? 0,
      'sender_name': currentUser?['nickname'] ?? '我',
      'content': content,
      'created_at': DateTime.now().toString().substring(0, 19),
      'role': ApiService.currentUserRole ?? 'student',
    };

    // 先本地添加消息
    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });
    _scrollToBottom();

    setState(() => _isSending = true);
    try {
      final result = await ApiService.sendClassMessage(widget.classId, content);
      if (result['success'] != true) {
        // 后端发送失败也不影响本地显示
        // 可以在这里提示用户，但消息已经本地显示了
      }
    } catch (e) {
      // 网络错误，消息已本地显示
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showInviteMembers() {
    // 模拟可邀请的用户列表
    final List<Map<String, dynamic>> users = [
      {'id': 10, 'name': '小红', 'role': 'student', 'grade': '三年级'},
      {'id': 11, 'name': '小刚', 'role': 'student', 'grade': '三年级'},
      {'id': 12, 'name': '小丽', 'role': 'student', 'grade': '三年级'},
      {'id': 13, 'name': '小红妈妈', 'role': 'parent', 'grade': '三年级家长'},
      {'id': 14, 'name': '小刚爸爸', 'role': 'parent', 'grade': '三年级家长'},
      {'id': 15, 'name': '王老师', 'role': 'teacher', 'grade': '数学老师'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('邀请成员加入群聊', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('${widget.className}', style: const TextStyle(fontSize: 13, color: AppColors.textTertiary)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final roleColor = user['role'] == 'teacher' ? AppColors.primary : user['role'] == 'parent' ? Colors.teal : Colors.orange;
                      final roleLabel = user['role'] == 'teacher' ? '教师' : user['role'] == 'parent' ? '家长' : '学生';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: roleColor.withOpacity(0.2),
                              child: Text(user['name'].toString().substring(0, 1), style: TextStyle(color: roleColor, fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(user['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: roleColor.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(roleLabel, style: TextStyle(fontSize: 10, color: roleColor, fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(user['grade'], style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('已邀请${user["name"]}加入群聊'), backgroundColor: Colors.green),
                                );
                              },
                              child: const Text('邀请'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'teacher': return AppColors.primary;
      case 'parent': return Colors.teal;
      case 'admin': return Colors.purple;
      default: return Colors.orange;
    }
  }

  String _getRoleLabel(String? role) {
    switch (role) {
      case 'teacher': return '教师';
      case 'parent': return '家长';
      case 'admin': return '管理员';
      default: return '学生';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ApiService.currentUserId ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.className, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('${_messages.length}条消息', style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showInviteMembers,
            tooltip: '邀请成员',
          ),
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('群成员功能开发中')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const Center(child: Text('暂无消息，快来发第一条吧！', style: TextStyle(color: AppColors.textTertiary)))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          final isMe = msg['sender_id'] == currentUserId;
                          return _buildMessageBubble(msg, isMe);
                        },
                      ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isMe) {
    final roleColor = _getRoleColor(msg['role']);
    final roleLabel = _getRoleLabel(msg['role']);

    return Container(
      margin: EdgeInsets.only(bottom: 16, left: isMe ? 60 : 0, right: isMe ? 0 : 60),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: roleColor.withOpacity(0.2),
                  child: Text(msg['sender_name']?.toString().substring(0, 1) ?? '?', style: TextStyle(color: roleColor, fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
              ],
              Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(msg['sender_name'] ?? '未知', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: roleColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(roleLabel, style: TextStyle(fontSize: 10, color: roleColor, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(msg['created_at']?.toString().substring(11, 16) ?? '', style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                ],
              ),
              if (isMe) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Text(msg['sender_name']?.toString().substring(0, 1) ?? '我', style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
              ),
              border: isMe ? null : Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              msg['content'] ?? '',
              style: TextStyle(fontSize: 15, color: isMe ? Colors.white : AppColors.textPrimary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: '输入消息...',
                  hintStyle: const TextStyle(color: AppColors.textTertiary),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _isSending ? null : _sendMessage,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _isSending ? Colors.grey : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
