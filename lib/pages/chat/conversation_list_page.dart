import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'chat_page.dart';

class ConversationListPage extends StatefulWidget {
  const ConversationListPage({super.key});

  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> {
  List<dynamic> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final result = await ApiService.getConversations();
      if (result['success'] == true && mounted) {
        setState(() {
          _conversations = result['list'] ?? [];
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getRoleText(String? role) {
    switch (role) {
      case 'teacher': return '教师';
      case 'parent': return '家长';
      case 'admin': return '管理员';
      default: return '学生';
    }
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'teacher': return AppColors.primary;
      case 'parent': return AppColors.success;
      case 'admin': return Colors.purple;
      default: return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('私信'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 72, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text('暂无私信', style: TextStyle(fontSize: 16, color: AppColors.textTertiary)),
                      const SizedBox(height: 8),
                      const Text('可以在班级群或用户资料中发起私信', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadConversations,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _conversations.length,
                    itemBuilder: (context, index) {
                      final conv = _conversations[index];
                      final user = conv['other_user'] ?? {};
                      final lastMsg = conv['last_message'] ?? {};
                      final unread = conv['unread_count'] ?? 0;
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => ChatPage(
                              userId: user['id'],
                              userName: user['nickname'] ?? '用户',
                              userRole: user['role'],
                            ),
                          )).then((_) => _loadConversations());
                        },
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
                              Stack(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: _getRoleColor(user['role']).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Icon(Icons.person, color: _getRoleColor(user['role']), size: 28),
                                  ),
                                  if (unread > 0)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                                        child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(user['nickname'] ?? '用户', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(color: _getRoleColor(user['role']).withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                          child: Text(_getRoleText(user['role']), style: TextStyle(fontSize: 10, color: _getRoleColor(user['role']), fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      lastMsg['content'] ?? '',
                                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
