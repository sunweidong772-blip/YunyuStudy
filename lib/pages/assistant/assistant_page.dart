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

    // 先尝试本地问答库
    final localAnswer = _getLocalAnswer(question);
    if (localAnswer != null) {
      await Future.delayed(const Duration(milliseconds: 500));
      _addMessage('assistant', localAnswer);
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final result = await ApiService.askAssistant(question);
      if (result['success'] == true) {
        _addMessage('assistant', result['answer'] ?? '抱歉，我暂时无法回答这个问题。');
      } else {
        _addMessage('assistant', '抱歉，出现了一些问题，请稍后再试。');
      }
    } catch (e) {
      _addMessage('assistant', '网络连接异常，请检查网络后重试。你可以试试问我：怎么学习数学？、怎么背单词？、今天有什么任务？');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _getLocalAnswer(String question) {
    final q = question.toLowerCase();

    // 数学相关
    if (q.contains('数学') || q.contains('算数') || q.contains('计算')) {
      if (q.contains('怎么学') || q.contains('如何学') || q.contains('方法')) {
        return '学习数学的好方法：\n\n1. 每天坚持练习，从基础题开始\n2. 准备错题本，定期复习错题\n3. 理解公式原理，不要死记硬背\n4. 多做应用题，培养数学思维\n5. 遇到难题先思考，再看解析\n\n在云屿学习APP中，你可以在"数学"模块进行每日练习，系统会自动记录错题哦！';
      }
      if (q.contains('乘法') || q.contains('除法')) {
        return '乘除法学习技巧：\n\n1. 先熟记乘法口诀表\n2. 理解乘法是加法的简便运算\n3. 除法是乘法的逆运算\n4. 多做竖式练习，掌握计算步骤\n5. 做完后用逆运算验算\n\n加油！每天练习10道题，一个月就能熟练掌握！';
      }
      return '数学学习建议：\n\n• 每天在APP的数学模块练习15-20分钟\n• 重点关注错题本中的题目\n• 遇到不会的题先思考5分钟\n• 每周复习一次本周错题\n\n有具体的数学问题可以告诉我哦！';
    }

    // 英语相关
    if (q.contains('英语') || q.contains('单词') || q.contains('英文')) {
      if (q.contains('怎么背') || q.contains('怎么记') || q.contains('方法')) {
        return '背单词的好方法：\n\n1. 艾宾浩斯遗忘曲线法：当天、第2天、第4天、第7天、第15天复习\n2. 词根词缀法：理解单词构成\n3. 联想记忆法：把单词和画面联系起来\n4. 多听多读，培养语感\n5. 在句子中记忆单词\n\n云屿学习APP的英语模块有1-6年级必考单词，支持卡片式学习，快去试试吧！';
      }
      if (q.contains('语法') || q.contains('时态')) {
        return '英语语法学习建议：\n\n1. 先掌握八大词性：名词、动词、形容词、副词、代词、介词、连词、冠词\n2. 重点学习五大基本时态：一般现在时、一般过去时、一般将来时、现在进行时、现在完成时\n3. 多做语法练习题\n4. 阅读英语短文，在语境中理解语法\n\n小学阶段重点掌握一般现在时、现在进行时、一般过去时哦！';
      }
      return '英语学习建议：\n\n• 每天背5-10个新单词\n• 多听英语音频，培养语感\n• 大声朗读英语课文\n• 尝试用英语写简单的句子\n\n云屿学习APP的英语模块有1-6年级必考单词和英语作文范文，快去学习吧！';
    }

    // 语文/作文相关
    if (q.contains('语文') || q.contains('作文') || q.contains('写作')) {
      if (q.contains('怎么写') || q.contains('方法') || q.contains('技巧')) {
        return '写好作文的技巧：\n\n1. 审题要清楚，明确写作要求\n2. 列好提纲，理清文章结构\n3. 开头要吸引人，结尾要点题\n4. 多用好词好句和修辞手法\n5. 写真人真事，表达真情实感\n6. 写完后多读几遍，修改病句\n\n云屿学习APP的作文模块有1-6年级优秀作文范文和写作框架，快去参考吧！';
      }
      if (q.contains('写人') || q.contains('我的妈妈') || q.contains('我的爸爸')) {
        return '写人作文要点：\n\n1. 抓住人物外貌特征（不要千篇一律）\n2. 通过具体事例表现人物性格\n3. 运用语言、动作、神态、心理描写\n4. 表达对人物的真实感情\n\n写《我的妈妈》可以这样写：\n• 开头：描写妈妈的外貌和特点\n• 中间：用1-2件具体事例表现妈妈的爱（比如生病照顾你、辅导你学习）\n• 结尾：表达对妈妈的爱和感谢\n\n加油！写出你心中最真实的妈妈！';
      }
      return '作文学习建议：\n\n• 多读课外书，积累好词好句\n• 每天写日记，锻炼写作能力\n• 学习范文的结构和写法\n• 多观察生活，积累写作素材\n\n云屿学习APP的作文模块有大量优秀作文范文，快去学习吧！';
    }

    // 学习方法
    if (q.contains('学习方法') || q.contains('怎么学习') || q.contains('如何提高')) {
      return '高效学习方法：\n\n1. 制定学习计划，合理安排时间\n2. 课前预习，课上认真听讲，课后复习\n3. 劳逸结合，学习45分钟休息10分钟\n4. 多做练习题，巩固知识点\n5. 准备错题本，定期复习\n6. 保持良好的作息，充足睡眠\n7. 保持积极的学习心态\n\n记住：学习没有捷径，坚持就是胜利！';
    }

    // 今日任务
    if (q.contains('今天') || q.contains('任务') || q.contains('作业') || q.contains('待办')) {
      return '今日学习建议：\n\n1. 数学：完成10道练习题\n2. 英语：背诵5个新单词\n3. 语文：阅读一篇优秀作文\n4. 复习：查看错题本\n5. 打卡：完成今日学习打卡\n\n你可以在APP的各个模块完成今日学习任务，加油！';
    }

    // 打卡
    if (q.contains('打卡') || q.contains('连续')) {
      return '关于学习打卡：\n\n• 每天完成学习任务后记得打卡\n• 连续打卡可以获得积分奖励\n• 积分可以在积分商城兑换礼品\n• 连续打卡天数越多，奖励越丰厚\n\n坚持打卡，养成良好的学习习惯！';
    }

    // 积分
    if (q.contains('积分') || q.contains('奖励')) {
      return '关于积分系统：\n\n• 完成每日练习可以获得积分\n• 连续打卡可以获得额外积分\n• 考试成绩优秀可以获得积分奖励\n• 教师可以给表现好的同学加积分\n• 积分可以在积分商城兑换礼品\n\n好好学习，积分多多！';
    }

    // 教师认证
    if (q.contains('教师认证') || q.contains('认证教师') || q.contains('怎么认证')) {
      return '教师认证流程：\n\n1. 进入"我的"页面\n2. 点击"教师认证"\n3. 填写真实姓名、联系方式（电话、QQ、微信）\n4. 填写工作经历或上传教师资格证\n5. 提交认证申请\n6. 等待管理员审核（24小时内）\n\n认证通过后，你将获得教师头衔和"已认证"标识，可以使用教师专属功能！';
    }

    // 班级群
    if (q.contains('班级群') || q.contains('群聊')) {
      return '关于班级群：\n\n• 教师和管理员可以创建班级群\n• 学生和家长可以加入班级群\n• 在班级群中可以交流学习问题\n• 所有班级群默认管理员都在群里\n• 目前有一个官方测试群可以加入\n\n进入"我的"→"班级群"即可查看和加入班级群！';
    }

    // 私信
    if (q.contains('私信') || q.contains('消息')) {
      return '关于私信功能：\n\n• 家长和学生可以私信老师\n• 老师可以私信学生和家长\n• 私信记录会保存在会话列表中\n• 有未读消息时会有提醒\n\n进入"消息"页面即可查看私信和通知！';
    }

    // 帮助
    if (q.contains('帮助') || q.contains('怎么用') || q.contains('使用说明')) {
      return '云屿学习APP使用指南：\n\n【首页】查看学习概览和推荐内容\n【数学】1-6年级数学练习题，自动批改\n【英语】1-6年级必考单词，卡片式学习\n【作文】1-6年级优秀作文范文和写作框架\n【消息】私信、班级群消息、系统通知\n【我的】个人中心、学习工具、设置\n\n常用功能：\n• 错题本：自动记录错题，定期复习\n• 每日小考：检验学习成果\n• 云屿小助手：解答学习问题\n• 教师认证：成为认证教师\n\n有任何问题随时问我！';
    }

    // 问候
    if (q.contains('你好') || q.contains('hi') || q.contains('hello') || q.contains('在吗')) {
      return '你好呀！我是云屿小助手😊\n\n我可以帮你：\n• 解答学习问题\n• 推荐学习方法\n• 提醒今日任务\n• 介绍APP功能\n\n你可以问我：\n"怎么学习数学？"\n"怎么背单词？"\n"今天有什么任务？"\n"怎么写好作文？"\n\n有什么可以帮你的吗？';
    }

    // 谢谢
    if (q.contains('谢谢') || q.contains('感谢') || q.contains('thanks')) {
      return '不客气！😊\n\n能帮到你我很开心！\n\n学习路上有任何问题，随时来找我哦！\n\n加油，你是最棒的！💪';
    }

    return null;
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
