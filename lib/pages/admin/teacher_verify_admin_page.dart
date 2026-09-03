import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class TeacherVerifyAdminPage extends StatefulWidget {
  const TeacherVerifyAdminPage({super.key});

  @override
  State<TeacherVerifyAdminPage> createState() => _TeacherVerifyAdminPageState();
}

class _TeacherVerifyAdminPageState extends State<TeacherVerifyAdminPage> {
  bool _isLoading = true;
  List<dynamic> _verifications = [];

  @override
  void initState() {
    super.initState();
    _loadVerifications();
  }

  Future<void> _loadVerifications() async {
    setState(() => _isLoading = true);
    try {
      final result = await ApiService.getVerifications();
      if (result['success'] == true) {
        setState(() => _verifications = result['list'] ?? []);
      }
    } catch (e) {
      // ignore
    }
    setState(() => _isLoading = false);
  }

  Future<void> _reviewVerification(int id, String status, String note) async {
    try {
      final result = await ApiService.reviewVerification(id, status, reviewNote: note);
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(status == 'approved' ? '已通过认证' : '已拒绝认证'), backgroundColor: Colors.green),
        );
        _loadVerifications();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? '操作失败'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('网络错误'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('教师认证审核'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _verifications.isEmpty
              ? const Center(child: Text('暂无认证申请', style: TextStyle(color: AppColors.textTertiary)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _verifications.length,
                  itemBuilder: (context, index) {
                    final v = _verifications[index];
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
                              CircleAvatar(
                                backgroundColor: AppColors.primary.withOpacity(0.1),
                                child: const Icon(Icons.person, color: AppColors.primary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(v['real_name'] ?? '未知', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                    Text('用户ID: ${v['user_id']}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: v['status'] == 'pending' ? Colors.orange.withOpacity(0.1) : v['status'] == 'approved' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  v['status'] == 'pending' ? '待审核' : v['status'] == 'approved' ? '已通过' : '已拒绝',
                                  style: TextStyle(fontSize: 12, color: v['status'] == 'pending' ? Colors.orange : v['status'] == 'approved' ? Colors.green : Colors.red),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (v['phone'] != null) Text('电话：${v['phone']}', style: const TextStyle(fontSize: 13)),
                          if (v['qq'] != null) Text('QQ：${v['qq']}', style: const TextStyle(fontSize: 13)),
                          if (v['wechat'] != null) Text('微信：${v['wechat']}', style: const TextStyle(fontSize: 13)),
                          if (v['work_experience'] != null) ...[
                            const SizedBox(height: 8),
                            const Text('工作经历：', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text(v['work_experience'], style: const TextStyle(fontSize: 13)),
                          ],
                          if (v['status'] == 'pending') ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                    onPressed: () => _reviewVerification(v['id'], 'approved', '认证通过'),
                                    child: const Text('通过'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                    onPressed: () => _reviewVerification(v['id'], 'rejected', '资料不符合要求'),
                                    child: const Text('拒绝'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
