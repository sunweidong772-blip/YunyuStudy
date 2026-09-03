import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';
import 'pages/auth/login_page.dart';
import 'services/api_service.dart';
import 'data/study_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StudyData.init();
  await ApiService.init();
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
      initialRoute: ApiService.isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
