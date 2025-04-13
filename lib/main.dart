import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';
import 'screens/home_page.dart';
import 'screens/upload_page.dart';
import 'screens/subtitle_page.dart';
import 'screens/settings_page.dart';
import 'screens/history_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanglish Subtitle Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF6A1B9A),
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF6A1B9A),
          brightness: Brightness.light,
          secondary: Color(0xFFE1BEE7),
        ),
        fontFamily: 'Poppins',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6A1B9A),
            foregroundColor: Colors.white,
            elevation: 3,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF6A1B9A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => IntroScreen(),
        '/home': (context) => HomePage(),
        '/upload': (context) => UploadPage(),
        '/subtitle': (context) => SubtitlePage(),
        '/settings': (context) => SettingsPage(),
        '/history': (context) => HistoryPage(),
      },
    );
  }
}