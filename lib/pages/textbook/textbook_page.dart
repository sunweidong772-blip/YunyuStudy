import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TextbookPage extends StatefulWidget {
  const TextbookPage({super.key});

  @override
  State<TextbookPage> createState() => _TextbookPageState();
}

class _TextbookPageState extends State<TextbookPage> {
  int _selectedGrade = 2; // 默认三年级
  String _selectedSubject = '语文';

  final List<String> _grades = ['一年级', '二年级', '三年级', '四年级', '五年级', '六年级', '初一', '初二', '初三', '高一', '高二', '高三'];
  final List<String> _subjects = ['语文', '数学', '英语', '物理', '化学', '生物', '历史', '地理', '政治'];

  // 教材全解数据
  final Map<String, Map<String, List<Map<String, String>>>> _textbookData = {
    '语文': {
      '三年级': [
        {'title': '第1课 大青树下的小学', 'content': '【课文主题】\n本文描写了一所边疆小学欢乐祥和的校园生活，体现了我国各民族儿童之间的友爱和团结。\n\n【重点字词】\n• 晨(chén)：早晨\n• 绒(róng)：绒毛\n• 球(qiú)：足球\n• 汉(hàn)：汉族\n• 艳(yàn)：鲜艳\n\n【段落大意】\n第一段（1自然段）：写上学的路上和来到学校时的情景。\n第二段（2-3自然段）：写课上和课下的情景。\n第三段（4自然段）：以自豪的感情点题。\n\n【中心思想】\n课文通过描写边疆的一所民族小学，反映了孩子们幸福的学习生活，体现了祖国各民族之间的友爱和团结。'},
        {'title': '第2课 花的学校', 'content': '【课文主题】\n本文是一首优美而富有童趣的散文诗，作者以清新流畅的笔触，勾画出甜美纯净的儿童世界。\n\n【作者介绍】\n泰戈尔（1861-1941），印度诗人、文学家、社会活动家。代表作有《吉檀迦利》《飞鸟集》《园丁集》等。1913年获诺贝尔文学奖。\n\n【重点字词】\n• 落(luò)：落下\n• 荒(huāng)：荒野\n• 笛(dí)：口笛\n• 舞(wǔ)：跳舞\n• 狂(kuáng)：狂风\n\n【段落大意】\n第一段（1-2自然段）：写阵雨落下，花孩子们在草地上跳舞、狂欢。\n第二段（3-5自然段）：写花孩子们的学校生活。\n第三段（6-9自然段）：写花孩子们急着回家，对妈妈的依恋。\n\n【中心思想】\n课文以儿童的视角描绘了一群活泼天真的花孩子，通过丰富的想象，把花孩子写得像孩子一样可爱，表达了作者对大自然的热爱之情。'},
        {'title': '第3课 不懂就要问', 'content': '【课文主题】\n本文讲的是孙中山小时候在私塾读书，敢于独立思考，敢于质疑，为了弄懂书里的意思，不怕先生的惩罚，大胆地向先生提出问题的事情。\n\n【人物介绍】\n孙中山（1866-1925），名文，字载之，号日新，又号逸仙。中国近代伟大的民主革命先行者。\n\n【重点字词】\n• 背(bèi)：背诵\n• 诵(sòng)：诵读\n• 例(lì)：照例\n• 圈(quān)：圆圈\n• 段(duàn)：段落\n\n【段落大意】\n第一段（1-2自然段）：写孙中山小时候在私塾读书，先生只教背诵，不讲解意思。\n第二段（3-7自然段）：写孙中山壮着胆子请先生讲解，先生详细讲解了书中的意思。\n第三段（8-9自然段）：写同学们问孙中山不怕挨打吗，孙中山说不懂就要问，挨打也值得。\n\n【中心思想】\n课文通过记叙孙中山小时候在私塾读书时，遇到不懂的问题就大胆向先生请教的事，赞扬了孙中山勤学好问的精神，告诉我们遇到不懂的问题要敢于提问。'},
      ],
      '四年级': [
        {'title': '第1课 观潮', 'content': '【课文主题】\n本文描写了作者耳闻目睹钱塘江大潮潮来前、潮来时、潮头过后的景象，写出了大潮的奇特、雄伟、壮观。\n\n【重点字词】\n• 潮(cháo)：潮水\n• 据(jù)：根据\n• 堤(dī)：大堤\n• 阔(kuò)：宽阔\n• 盼(pàn)：盼望\n\n【写作顺序】\n课文按"潮来前→潮来时→潮头过后"的顺序描写钱塘江大潮。\n\n【中心思想】\n课文通过描写钱塘江大潮的壮观景象，赞美了大自然的神奇与美丽，表达了作者对祖国大好河山的热爱之情。'},
        {'title': '第2课 走月亮', 'content': '【课文主题】\n本文描写了在秋天的夜晚，作者和阿妈在洒满月光的小路上漫步时的所见、所闻、所感，表达了作者和阿妈之间浓浓的亲情和作者对生活的热爱。\n\n【重点字词】\n• 淘(táo)：淘气\n• 鹅(é)：鹅卵石\n• 卵(luǎn)：虫卵\n• 填(tián)：填空\n• 庄(zhuāng)：村庄\n\n【中心思想】\n课文通过描写"我"和阿妈在月光下散步的情景，展现了月光下美丽的景象，表达了"我"和阿妈之间浓浓的亲情，以及"我"对生活的热爱。'},
      ],
    },
    '数学': {
      '三年级': [
        {'title': '第1单元 时、分、秒', 'content': '【知识点1：秒的认识】\n计量很短的时间，常用秒。秒是比分更小的时间单位。\n\n钟面上最长最细的针是秒针。秒针走1小格的时间是1秒。\n\n【知识点2：时间单位换算】\n1时 = 60分\n1分 = 60秒\n1时 = 3600秒\n\n【知识点3：计算经过时间】\n经过时间 = 结束时刻 - 开始时刻\n\n例题：小明7:30离家，7:45到校，小明从家到学校用了多长时间？\n解答：7:45 - 7:30 = 15分钟\n答：小明从家到学校用了15分钟。\n\n【易错点】\n1. 时间单位换算时，时和分、分和秒之间的进率是60，不是100。\n2. 计算经过时间时，如果分钟不够减，要从小时借1当60分钟。'},
        {'title': '第2单元 万以内的加法和减法（一）', 'content': '【知识点1：口算两位数加两位数】\n方法：把其中一个两位数拆成整十数和一位数，先算两位数加整十数，再加一位数。\n\n例题：35 + 34 = ?\n方法：35 + 30 = 65，65 + 4 = 69\n所以35 + 34 = 69\n\n【知识点2：口算两位数减两位数】\n方法：把减数拆成整十数和一位数，先算被减数减整十数，再减一位数。\n\n例题：65 - 54 = ?\n方法：65 - 50 = 15，15 - 4 = 11\n所以65 - 54 = 11\n\n【知识点3：几百几十加、减几百几十】\n方法：可以把几百几十看作几个十，转化为两位数加、减两位数来口算。\n\n例题：380 + 550 = ?\n方法：38个十 + 55个十 = 93个十 = 930\n所以380 + 550 = 930\n\n【易错点】\n1. 口算加法时，个位相加满十要向十位进1。\n2. 口算减法时，个位不够减要从十位退1当10。'},
        {'title': '第3单元 测量', 'content': '【知识点1：毫米、分米的认识】\n1厘米 = 10毫米\n1分米 = 10厘米\n1米 = 10分米\n\n【知识点2：千米的认识】\n计量较长的路程，通常用千米作单位。\n1千米 = 1000米\n\n【知识点3：吨的认识】\n计量较重的或大宗物品的质量，通常用吨作单位。\n1吨 = 1000千克\n\n【单位换算总结】\n长度单位：千米→米→分米→厘米→毫米（除千米和米之间进率是1000，其余相邻单位进率都是10）\n质量单位：吨→千克→克（相邻单位进率都是1000）\n\n【易错点】\n1. 选择合适的单位时，要结合生活实际。\n2. 单位换算时，大单位换小单位乘进率，小单位换大单位除以进率。'},
      ],
      '四年级': [
        {'title': '第1单元 大数的认识', 'content': '【知识点1：亿以内数的认识】\n一（个）、十、百、千、万、十万、百万、千万、亿都是计数单位。\n每相邻两个计数单位之间的进率都是10。\n\n【知识点2：亿以内数的读法】\n1. 先读万级，再读个级。\n2. 万级的数，要按照个级的数的读法来读，再在后面加上一个"万"字。\n3. 每级末尾不管有几个0，都不读，其他数位上有一个0或连续几个0，都只读一个0。\n\n【知识点3：亿以内数的写法】\n1. 先写万级，再写个级。\n2. 哪个数位上一个单位也没有，就在那个数位上写0。\n\n【知识点4：数的大小比较】\n1. 位数不同的两个数，位数多的数大。\n2. 位数相同的两个数，从最高位比起，最高位上的数大的那个数就大，如果最高位上的数相同，就比较下一个数位上的数。'},
      ],
    },
    '英语': {
      '三年级': [
        {'title': 'Unit 1 Hello!', 'content': '【核心词汇】\n• pen 钢笔\n• pencil 铅笔\n• pencil-case 铅笔盒\n• ruler 尺子\n• eraser 橡皮\n• crayon 蜡笔\n• book 书\n• bag 书包\n• sharpener 卷笔刀\n• school 学校\n\n【核心句型】\n1. Hello! / Hi! 你好！\n2. I\'m... 我是...\n3. Goodbye! / Bye! 再见！\n4. What\'s your name? 你叫什么名字？\n5. My name\'s... 我的名字叫...\n\n【对话示例】\nA: Hello! I\'m Mike. What\'s your name?\nB: Hi! My name\'s Chen Jie.\nA: Goodbye!\nB: Bye!\n\n【知识点】\n1. I\'m = I am 我是\n2. My name\'s = My name is 我的名字是\n3. 自我介绍时用I\'m...或My name\'s...\n4. 询问对方名字用What\'s your name?'},
        {'title': 'Unit 2 Colours', 'content': '【核心词汇】\n• red 红色\n• yellow 黄色\n• green 绿色\n• blue 蓝色\n• purple 紫色\n• white 白色\n• black 黑色\n• orange 橙色\n• pink 粉色\n• brown 棕色\n\n【核心句型】\n1. Good morning! 早上好！\n2. Good afternoon! 下午好！\n3. This is... 这是...\n4. Nice to meet you. 见到你很高兴。\n5. Nice to meet you, too. 见到你我也很高兴。\n\n【对话示例】\nA: Good morning, Miss White.\nB: Good morning, Mike. This is Sarah.\nA: Nice to meet you, Sarah.\nC: Nice to meet you, too.\n\n【知识点】\n1. This is...用于介绍他人\n2. Nice to meet you.的回答是Nice to meet you, too.\n3. 颜色词前面不加冠词\n4. Good morning!和Good afternoon!根据时间使用'},
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('教材全解'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 年级选择
          Container(
            height: 44,
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _grades.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedGrade == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGrade = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(_grades[index], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textSecondary)),
                    ),
                  ),
                );
              },
            ),
          ),
          // 科目选择
          Container(
            height: 40,
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              children: _subjects.map((subject) {
                final isSelected = _selectedSubject == subject;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedSubject = subject),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(subject, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textSecondary)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // 教材内容列表
          Expanded(
            child: _buildContentList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList() {
    final grade = _grades[_selectedGrade];
    final subjectData = _textbookData[_selectedSubject];
    final gradeData = subjectData?[grade] ?? [];

    if (gradeData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('$grade$_selectedSubject教材全解\n正在整理中...', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: gradeData.length,
      itemBuilder: (context, index) {
        final item = gradeData[index];
        return GestureDetector(
          onTap: () => _showDetail(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.menu_book, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('点击查看详细解析', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDetail(Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
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
              Text(item['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    item['content']!,
                    style: const TextStyle(fontSize: 14, height: 1.8, color: AppColors.textPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
