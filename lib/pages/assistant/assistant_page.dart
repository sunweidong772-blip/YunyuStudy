import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  List<dynamic> _todayTasks = [];
  bool _isLoading = false;
  bool _tasksLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodayTasks();
    _addMessage('assistant', '你好！我是云屿小助手，有什么可以帮你的吗？你可以问我关于学习、作业、打卡等问题，我也会提醒你今天还有什么任务没完成。');
  }

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTodayTasks() async {
    try {
      final result = await ApiService.getTodayTasks();
      if (result['success'] == true && mounted) {
        setState(() {
          _todayTasks = result['tasks'] ?? [];
          _tasksLoading = false;
        });
        if (_todayTasks.isNotEmpty) {
          String taskText = '📋 今日待办提醒：\n\n';
          for (var task in _todayTasks) {
            taskText += '• ${task['title']}\n';
          }
          taskText += '\n加油完成今天的任务吧！';
          _addMessage('assistant', taskText);
        }
      } else {
        if (mounted) setState(() => _tasksLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _tasksLoading = false);
    }
  }

  void _addMessage(String role, String content) {
    setState(() {
      _messages.add({'role': role, 'content': content, 'time': DateTime.now().toString()});
    });
    _scrollToBottom();
  }

  Future<void> _sendQuestion() async {
    final question = _questionController.text.trim();
    if (question.isEmpty || _isLoading) return;

    _addMessage('user', question);
    _questionController.clear();
    setState(() => _isLoading = true);

    try {
      final result = await ApiService.askAssistant(question);
      if (result['success'] == true) {
        _addMessage('assistant', result['answer'] ?? '抱歉，我暂时无法回答这个问题。');
      } else {
        _addMessage('assistant', '抱歉，出现了一些问题，请稍后再试。');
      }
    } catch (e) {
      _addMessage('assistant', '网络连接异常，请检查网络后重试。');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('云屿小助手'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTodayTasks,
          ),
        ],
      ),
      body: Column(
        children: [
          // 今日待办
          if (!_tasksLoading && _todayTasks.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                border: Border(bottom: BorderSide(color: AppColors.warning.withOpacity(0.2))),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active, color: AppColors.warning, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '今日有${_todayTasks.length}项待办任务',
                      style: const TextStyle(fontSize: 13, color: AppColors.warning, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          // 聊天区域
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.smart_toy, color: AppColors.primary, size: 48),
                        ),
                        const SizedBox(height: 16),
                        const Text('云屿小助手', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        const Text('有问题随时问我', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return _buildMessageBubble(msg);
                    },
                  ),
          ),
          // 输入框
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _questionController,
                      decoration: InputDecoration(
                        hintText: '输入你的问题...',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: (_) => _sendQuestion(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _isLoading ? null : _sendQuestion,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _isLoading ? Colors.grey : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: _isLoading
                          ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isUser = msg['role'] == 'user';
    return Container(
      margin: EdgeInsets.only(bottom: 16, left: isUser ? 60 : 0, right: isUser ? 0 : 60),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy, color: AppColors.primary, size: 16),
                  ),
                  const SizedBox(width: 6),
                  const Text('小助手', style: TextStyle(fontSize: 11, color: AppColors.textTertiary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
              ),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
            ),
            child: Text(
              msg['content'] ?? '',
              style: TextStyle(color: isUser ? Colors.white : AppColors.textPrimary, fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
