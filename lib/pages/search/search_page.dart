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
    else { icon = Icons.g_translate; color = AppColors.primary; typeLabel = '英语作文'; }
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
}
