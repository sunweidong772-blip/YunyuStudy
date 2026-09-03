import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<dynamic> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final result = await ApiService.getMessages();
      if (result['success'] == true && mounted) {
        setState(() {
          _messages = result['list'] ?? [];
          _isLoading = false;
        });
        // 标记全部已读
        ApiService.readMessage();
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteMessage(int id) async {
    try {
      await ApiService.deleteMessage(id);
      _loadMessages();
    } catch (e) {
      // ignore
    }
  }

  IconData _getMessageIcon(String? type) {
    switch (type) {
      case 'homework':
        return Icons.assignment;
      case 'points':
        return Icons.stars;
      case 'system':
        return Icons.notifications;
      default:
        return Icons.message;
    }
  }

  Color _getMessageColor(String? type) {
    switch (type) {
      case 'homework':
        return AppColors.primary;
      case 'points':
        return Colors.amber;
      case 'system':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息通知'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_messages.isNotEmpty)
            TextButton(
              onPressed: () async {
                await ApiService.clearMessages();
                _loadMessages();
              },
              child: const Text('清空', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text('暂无消息', style: TextStyle(fontSize: 16, color: AppColors.textTertiary)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMessages,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Dismissible(
                        key: Key(msg['id'].toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _deleteMessage(msg['id']),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(color: AppColors.danger, borderRadius: BorderRadius.circular(16)),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _getMessageColor(msg['type']).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(_getMessageIcon(msg['type']), color: _getMessageColor(msg['type']), size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            msg['title'] ?? '',
                                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (msg['is_read'] == 0)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      msg['content'] ?? '',
                                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      msg['created_at'] ?? '',
                                      style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                                    ),
                                  ],
                                ),
                              ),
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
