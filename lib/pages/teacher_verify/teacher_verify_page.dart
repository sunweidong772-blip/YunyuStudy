import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class TeacherVerifyPage extends StatefulWidget {
  const TeacherVerifyPage({super.key});

  @override
  State<TeacherVerifyPage> createState() => _TeacherVerifyPageState();
}

class _TeacherVerifyPageState extends State<TeacherVerifyPage> {
  final _realNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _qqController = TextEditingController();
  final _wechatController = TextEditingController();
  final _workExperienceController = TextEditingController();

  bool _isLoading = true;
  bool _isSubmitting = false;
  Map<String, dynamic>? _verification;
  bool _isTeacher = false;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  @override
  void dispose() {
    _realNameController.dispose();
    _phoneController.dispose();
    _qqController.dispose();
    _wechatController.dispose();
    _workExperienceController.dispose();
    super.dispose();
  }

  Future<void> _loadStatus() async {
    try {
      final result = await ApiService.getMyVerificationStatus();
      if (result['success'] == true && mounted) {
        setState(() {
          _verification = result['verification'];
          _isTeacher = result['is_teacher'] == true;
          _isVerified = result['is_verified'] == true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submit() async {
    final realName = _realNameController.text.trim();
    final phone = _phoneController.text.trim();
    final qq = _qqController.text.trim();
    final wechat = _wechatController.text.trim();
    final workExperience = _workExperienceController.text.trim();

    if (realName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写真实姓名'), backgroundColor: AppColors.danger),
      );
      return;
    }
    if (phone.isEmpty && qq.isEmpty && wechat.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少填写一种联系方式'), backgroundColor: AppColors.danger),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final result = await ApiService.submitTeacherVerification(
        realName: realName,
        phone: phone,
        qq: qq,
        wechat: wechat,
        workExperience: workExperience,
      );
      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('认证申请已提交'), backgroundColor: AppColors.success),
          );
        }
        _loadStatus();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? '提交失败'), backgroundColor: AppColors.danger),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('网络错误'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('教师认证'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isVerified
              ? _buildVerifiedView()
              : _verification != null && _verification!['status'] == 'pending'
                  ? _buildPendingView()
                  : _buildFormView(),
    );
  }

  Widget _buildVerifiedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified, color: AppColors.success, size: 60),
          ),
          const SizedBox(height: 24),
          const Text('已认证教师', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('您已通过教师身份认证', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, color: AppColors.primary, size: 18),
                SizedBox(width: 6),
                Text('已认证', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.hourglass_empty, color: AppColors.warning, size: 60),
            ),
            const SizedBox(height: 24),
            const Text('认证审核中', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            const Text(
              '您的教师认证申请已提交，我们将在24小时内完成审核。\n\n期间可能会有官方人员通过您提交的联系方式进行复核，请保持通讯畅通。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
            ),
            const SizedBox(height: 24),
            if (_verification?['real_name'] != null)
              Text('申请人：${_verification!['real_name']}', style: const TextStyle(fontSize: 13, color: AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: AppColors.primary, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '教师认证通过后将获得教师头衔和已认证标识，可创建班级群、布置作业、管理学生。',
                    style: TextStyle(fontSize: 13, color: AppColors.primary, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('基本信息', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          _buildTextField('真实姓名 *', _realNameController, '请输入真实姓名'),
          const SizedBox(height: 16),
          const Text('联系方式（至少填写一种）', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          _buildTextField('电话', _phoneController, '请输入手机号码', TextInputType.phone),
          const SizedBox(height: 16),
          _buildTextField('QQ', _qqController, '请输入QQ号', TextInputType.number),
          const SizedBox(height: 16),
          _buildTextField('微信', _wechatController, '请输入微信号'),
          const SizedBox(height: 24),
          const Text('工作经历 / 教师资格证', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _workExperienceController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '请描述您的教学工作经历，或上传教师资格证图片（图片上传功能开发中，可先填写文字描述）',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning, color: AppColors.warning, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '提交后我们将在24小时内完成审核，期间可能会有官方人员通过您提交的联系方式进行复核。',
                    style: TextStyle(fontSize: 13, color: AppColors.warning, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('提交认证申请', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, [TextInputType? keyboardType]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
