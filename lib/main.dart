import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';

void main() {
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
