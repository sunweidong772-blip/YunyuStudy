import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';
import 'data/study_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StudyData.init();
  runApp(const YunyuStudyApp());
}

class YunyuStudyApp extends StatelessWidget {
  const YunyuStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '云屿学习',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
