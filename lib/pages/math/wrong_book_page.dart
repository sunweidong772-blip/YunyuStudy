import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/study_data.dart';
import '../../services/api_service.dart';

class WrongBookPage extends StatefulWidget {
  const WrongBookPage({super.key});

  @override
  State<WrongBookPage> createState() => _WrongBookPageState();
}

class _WrongBookPageState extends State<WrongBookPage> {
  List<Map<String, dynamic>> _wrongQuestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWrongQuestions();
  }

  Future<void> _loadWrongQuestions() async {
    if (ApiService.isLoggedIn) {
      try {
        final result = await ApiService.getWrongQuestions(limit: 100);
        if (result['success'] == true && mounted) {
          final list = result['list'] as List;
          setState(() {
            _wrongQuestions = list.map((q) => {
              'id': q['id'],
              'question': q['question'],
              'answer': q['answer'],
              'wrongAnswer': q['wrong_answer'],
              'explanation': q['explanation'],
              'grade': q['grade'],
              'created_at': q['created_at'],
            }).toList();
            _isLoading = false;
          });
          return;
        }
      } catch (e) {
        // 失败则使用本地数据
      }
    }
    if (mounted) {
      setState(() {
        _wrongQuestions = StudyData.wrongQuestions;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteQuestion(Map<String, dynamic> q) async {
    if (ApiService.isLoggedIn && q['id'] != null) {
      await ApiService.deleteWrongQuestion(q['id']);
    } else {
      await StudyData.removeWrongQuestion(q['question']);
    }
    _loadWrongQuestions();
  }

  Future<void> _clearAll() async {
    if (ApiService.isLoggedIn) {
      await ApiService.clearWrongQuestions();
    } else {
      for (var q in _wrongQuestions) {
        await StudyData.removeWrongQuestion(q['question']);
      }
    }
    _loadWrongQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('错题本'),
        backgroundColor: Colors.transparent,
        actions: [
          if (_wrongQuestions.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (d) => AlertDialog(
                    title: const Text('清空错题本'),
                    content: const Text('确定要清空所有错题吗？'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(d), child: const Text('取消')),
                      FilledButton(
                        onPressed: () async {
                          Navigator.pop(d);
                          await _clearAll();
                        },
                        child: const Text('清空'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('清空', style: TextStyle(color: AppColors.danger)),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wrongQuestions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 72, color: AppColors.success),
                      const SizedBox(height: 16),
                      const Text('太棒了！', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      const Text('暂无错题，继续保持！', style: TextStyle(fontSize: 14, color: AppColors.textTertiary)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadWrongQuestions,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _wrongQuestions.length,
                    itemBuilder: (context, index) => _buildWrongItem(_wrongQuestions[index]),
                  ),
                ),
    );
  }

  Widget _buildWrongItem(Map<String, dynamic> q) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(color: AppColors.danger, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(6)),
                child: const Text('错题', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.danger)),
              ),
              if (q['grade'] != null) ...[
                const SizedBox(width: 8),
                Text('${q['grade']}年级', style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
              ],
              const Spacer(),
              GestureDetector(
                onTap: () => _deleteQuestion(q),
                child: const Icon(Icons.delete_outline, color: AppColors.textTertiary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(q['question'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('你的答案: ', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
              Text(
                q['wrongAnswer'] ?? '',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.danger, decoration: TextDecoration.lineThrough),
              ),
              const SizedBox(width: 16),
              const Text('正确答案: ', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
              Text(q['answer'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.success)),
            ],
          ),
          if (q['explanation'] != null && q['explanation'].toString().isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb, color: AppColors.warning, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      q['explanation'],
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (q['created_at'] != null) ...[
            const SizedBox(height: 8),
            Text(q['created_at'], style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
          ],
        ],
      ),
    );
  }
}
