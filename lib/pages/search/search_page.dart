import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/english_words.dart';
import '../../data/essay_samples.dart';
import '../../data/english_essays.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _keyword = '';
  List<Map<String, dynamic>> _results = [];

  void _search(String keyword) {
    setState(() {
      _keyword = keyword;
      _results = [];
      if (keyword.isEmpty) return;
      String kw = keyword.toLowerCase();
      // 搜索英语单词
      for (int grade = 1; grade <= 6; grade++) {
        for (var word in EnglishData.getWordsByGrade(grade)) {
          if (word.word.toLowerCase().contains(kw) || word.meaning.contains(keyword)) {
            _results.add({
              'type': 'word',
              'title': word.word,
              'subtitle': '${word.meaning} · ${grade}年级',
              'content': '单词：${word.word}\n音标：${word.phonetic}\n释义：${word.meaning}\n年级：${grade}年级\n\n例句：${word.example}\n\n${word.exampleTranslation}',
              'data': word
            });
          }
        }
      }
      // 搜索语文作文
      for (var essay in EssayData.essays) {
        if (essay.title.contains(keyword) || essay.category.contains(keyword) || essay.content.contains(keyword)) {
          _results.add({
            'type': 'essay',
            'title': essay.title,
            'subtitle': '${essay.category} · ${essay.grade}年级 · ${essay.wordCount}字',
            'content': '【${essay.category}】${essay.title}\n年级：${essay.grade}年级\n字数：${essay.wordCount}字\n\n${essay.content}\n\n写作框架：\n${essay.outline}',
            'data': essay
          });
        }
      }
      // 搜索英语作文
      for (var essay in EnglishEssayData.essays) {
        if (essay.title.toLowerCase().contains(kw) || essay.titleCn.contains(keyword)) {
          _results.add({
            'type': 'english_essay',
            'title': essay.title,
            'subtitle': '${essay.titleCn} · ${essay.grade}年级',
            'content': '【英语作文】${essay.title}\n中文标题：${essay.titleCn}\n年级：${essay.grade}年级\n\n${essay.content}\n\n参考翻译：\n${essay.translation ?? "暂无翻译"}',
            'data': essay
          });
        }
      }
      // 搜索数学知识点
      final mathKnowledge = _getMathKnowledge();
      for (var item in mathKnowledge) {
        if (item['title'].toString().contains(keyword) || item['content'].toString().contains(keyword)) {
          _results.add({
            'type': 'math',
            'title': item['title'],
            'subtitle': '数学知识点',
            'content': '【数学知识点】${item['title']}\n\n${item['content']}',
            'data': item
          });
        }
      }
      // 搜索语文知识点
      final chineseKnowledge = _getChineseKnowledge();
      for (var item in chineseKnowledge) {
        if (item['title'].toString().contains(keyword) || item['content'].toString().contains(keyword)) {
          _results.add({
            'type': 'chinese',
            'title': item['title'],
            'subtitle': '语文知识点',
            'content': '【语文知识点】${item['title']}\n\n${item['content']}',
            'data': item
          });
        }
      }
      // 如果没有搜索结果，给出提示
      if (_results.isEmpty) {
        _results.add({
          'type': 'tip',
          'title': '未找到相关内容',
          'subtitle': '试试搜索：乘法、英语单词、我的妈妈、古诗',
          'content': '未找到与"$keyword"相关的内容。\n\n你可以试试搜索：\n• 数学：乘法、除法、面积、周长\n• 英语：apple、teacher、family\n• 语文：我的妈妈、春天、写人作文\n• 知识点：比喻句、乘法口诀',
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(border: InputBorder.none, hintText: '搜索单词、作文...', hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 14)),
            onChanged: _search,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('取消', style: TextStyle(color: AppColors.primary)))],
      ),
      body: _keyword.isEmpty
          ? _buildHotSearch()
          : _results.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.search_off, size: 64, color: AppColors.textTertiary), SizedBox(height: 12), Text('未找到相关内容', style: TextStyle(color: AppColors.textTertiary))]))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _results.length,
                  itemBuilder: (context, index) => _buildResultItem(_results[index]),
                ),
    );
  }

  Widget _buildHotSearch() {
    List<String> hotWords = ['my family', '我的妈妈', '春天', 'friend', '保护环境', '我的梦想'];
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(Icons.local_fire_department, color: Colors.red, size: 20), SizedBox(width: 6), Text('热门搜索', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))]),
        SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: hotWords.map((word) => GestureDetector(
            onTap: () { _controller.text = word; _search(word); },
            child: Container(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)), child: Text(word, style: TextStyle(fontSize: 13, color: AppColors.textSecondary))),
          )).toList(),
        ),
      ]),
    );
  }

  Widget _buildResultItem(Map<String, dynamic> result) {
    IconData icon;
    Color color;
    String typeLabel;
    if (result['type'] == 'word') { icon = Icons.menu_book; color = AppColors.success; typeLabel = '单词'; }
    else if (result['type'] == 'essay') { icon = Icons.edit_note; color = AppColors.warning; typeLabel = '语文作文'; }
    else if (result['type'] == 'english_essay') { icon = Icons.g_translate; color = AppColors.primary; typeLabel = '英语作文'; }
    else if (result['type'] == 'math') { icon = Icons.calculate; color = Colors.blue; typeLabel = '数学知识点'; }
    else if (result['type'] == 'chinese') { icon = Icons.menu_book_outlined; color = Colors.orange; typeLabel = '语文知识点'; }
    else { icon = Icons.info_outline; color = Colors.grey; typeLabel = '提示'; }
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(result['title']),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('类型：$typeLabel', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
                  SizedBox(height: 8),
                  Text(result['content'] ?? result['subtitle'] ?? '', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('关闭')),
            ],
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)),
          SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(result['title'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            SizedBox(height: 2),
            Text('$typeLabel · ${result['subtitle']}', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
          ])),
          Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ]),
      ),
    );
  }

  List<Map<String, String>> _getMathKnowledge() {
    return [
      {'title': '乘法口诀表', 'content': '一一得一，一二得二，二二得四...\n\n乘法口诀是数学学习的基础，一定要熟记！\n\n1×1=1, 1×2=2, 1×3=3...\n2×2=4, 2×3=6, 2×4=8...\n3×3=9, 3×4=12, 3×5=15...'},
      {'title': '长方形面积公式', 'content': '长方形面积 = 长 × 宽\n\n公式：S = a × b\n\n例如：长5厘米，宽3厘米的长方形，面积 = 5 × 3 = 15平方厘米。'},
      {'title': '正方形面积公式', 'content': '正方形面积 = 边长 × 边长\n\n公式：S = a × a = a²\n\n例如：边长4厘米的正方形，面积 = 4 × 4 = 16平方厘米。'},
      {'title': '长方形周长公式', 'content': '长方形周长 = (长 + 宽) × 2\n\n公式：C = (a + b) × 2\n\n例如：长5厘米，宽3厘米的长方形，周长 = (5 + 3) × 2 = 16厘米。'},
      {'title': '正方形周长公式', 'content': '正方形周长 = 边长 × 4\n\n公式：C = a × 4\n\n例如：边长4厘米的正方形，周长 = 4 × 4 = 16厘米。'},
      {'title': '三角形面积公式', 'content': '三角形面积 = 底 × 高 ÷ 2\n\n公式：S = a × h ÷ 2\n\n例如：底6厘米，高4厘米的三角形，面积 = 6 × 4 ÷ 2 = 12平方厘米。'},
      {'title': '分数的基本性质', 'content': '分数的分子和分母同时乘以或除以相同的数（0除外），分数的大小不变。\n\n例如：1/2 = 2/4 = 3/6 = 4/8'},
      {'title': '小数的加减法', 'content': '小数加减法要注意：\n1. 小数点对齐\n2. 从最低位算起\n3. 得数的小数点要和横线上的小数点对齐\n\n例如：3.5 + 2.3 = 5.8'},
      {'title': '时间单位换算', 'content': '1小时 = 60分钟\n1分钟 = 60秒\n1小时 = 3600秒\n1天 = 24小时\n\n例如：2小时 = 120分钟，180分钟 = 3小时'},
      {'title': '长度单位换算', 'content': '1千米 = 1000米\n1米 = 10分米\n1分米 = 10厘米\n1厘米 = 10毫米\n1米 = 100厘米\n\n例如：2千米 = 2000米，500厘米 = 5米'},
    ];
  }

  List<Map<String, String>> _getChineseKnowledge() {
    return [
      {'title': '比喻句', 'content': '比喻句就是打比方，用浅显、具体、生动的事物来代替抽象、难理解的事物。\n\n比喻句的基本结构：\n本体（被比喻的事物）+ 比喻词（像、好像、仿佛）+ 喻体（用来比喻的事物）\n\n例如：弯弯的月亮像小船。'},
      {'title': '拟人句', 'content': '拟人句就是把事物当作人来写，让事物具有人的动作、语言、神态、思想等。\n\n例如：\n• 小鸟在树上唱歌。\n• 花儿在风中点头微笑。\n• 太阳公公起床了。'},
      {'title': '排比句', 'content': '排比句是把三个或以上结构相同或相似、意思相关、语气一致的词语或句子排列在一起。\n\n例如：\n• 爱心是一片照射在冬日的阳光，爱心是一泓出现在沙漠里的泉水，爱心是一首飘荡在夜空的歌谣。\n• 下课了，同学们有的跳绳，有的踢毽子，有的打乒乓球。'},
      {'title': '夸张句', 'content': '夸张句是为了达到某种表达效果，对事物的形象、特征、作用、程度等方面着意夸大或缩小。\n\n例如：\n• 教室里静得连根针掉在地上都能听见。\n• 他的声音大得能把房子震塌。\n• 我饿得能吃下一头牛。'},
      {'title': '古诗《静夜思》', 'content': '静夜思\n唐·李白\n\n床前明月光，\n疑是地上霜。\n举头望明月，\n低头思故乡。\n\n译文：明亮的月光洒在床前，好像地上泛起了一层霜。我禁不住抬起头来，看那天窗外空中的一轮明月，不由得低头沉思，想起远方的家乡。'},
      {'title': '古诗《春晓》', 'content': '春晓\n唐·孟浩然\n\n春眠不觉晓，\n处处闻啼鸟。\n夜来风雨声，\n花落知多少。\n\n译文：春日里贪睡不知不觉天就亮了，到处可以听见小鸟的鸣叫声。回想昨夜的阵阵风雨声，不知吹落了多少娇美的春花。'},
      {'title': '写人作文要点', 'content': '写人作文要注意：\n1. 抓住人物外貌特征（不要千篇一律）\n2. 通过具体事例表现人物性格\n3. 运用语言、动作、神态、心理描写\n4. 表达对人物的真实感情\n\n写《我的妈妈》可以这样写：\n• 开头：描写妈妈的外貌和特点\n• 中间：用1-2件具体事例表现妈妈的爱\n• 结尾：表达对妈妈的爱和感谢'},
      {'title': '写景作文要点', 'content': '写景作文要注意：\n1. 抓住景物的特点\n2. 按一定的顺序描写（时间顺序、空间顺序）\n3. 运用比喻、拟人、排比等修辞手法\n4. 表达自己的感情\n\n写景顺序：\n• 时间顺序：春、夏、秋、冬 / 早、中、晚\n• 空间顺序：远→近 / 上→下 / 左→右'},
      {'title': '关联词', 'content': '常见关联词：\n• 并列关系：一边...一边...、既...又...\n• 递进关系：不但...而且...、不仅...还...\n• 转折关系：虽然...但是...、尽管...可是...\n• 因果关系：因为...所以...、既然...就...\n• 条件关系：只要...就...、只有...才...\n• 假设关系：如果...就...、即使...也...'},
      {'title': '标点符号用法', 'content': '常见标点符号：\n• 句号（。）：用于陈述句末尾\n• 问号（？）：用于疑问句末尾\n• 感叹号（！）：用于感叹句末尾\n• 逗号（，）：句子中间的停顿\n• 顿号（、）：并列词语之间的停顿\n• 冒号（：）：提示下文\n• 引号（""）：引用的话或特定称谓'},
    ];
  }
}
