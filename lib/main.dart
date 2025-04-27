import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';
import 'screens/home_page.dart';
import 'screens/upload_page.dart';

import 'screens/settings_page.dart';
import 'screens/history_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Color scheme matching UploadPage
  final Color _pinkAccent = Color(0xFFED2A90);
  final Color _purpleAccent = Color(0xFFAB49D0);
  final Color _brightPurpleButton = Color(0xFF5E60CD);
  final Color _fgMutedBlue = Color(0xFF142748);
  final Color _bgDarkBlue = Color(0xFF0D2146);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanglish Subtitle Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: _brightPurpleButton,
        scaffoldBackgroundColor: _bgDarkBlue,
        colorScheme: ColorScheme.dark(
          primary: _pinkAccent,
          secondary: _purpleAccent,
          tertiary: _brightPurpleButton,
          surface: _fgMutedBlue,
          background: _bgDarkBlue,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Poppins',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _brightPurpleButton,
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
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _purpleAccent,
            side: BorderSide(color: _purpleAccent),
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
          backgroundColor: _bgDarkBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: _brightPurpleButton,
        scaffoldBackgroundColor: _bgDarkBlue,
        colorScheme: ColorScheme.dark(
          primary: _pinkAccent,
          secondary: _purpleAccent,
          tertiary: _brightPurpleButton,
          surface: _fgMutedBlue,
          background: _bgDarkBlue,
        ),
        fontFamily: 'Poppins',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _brightPurpleButton,
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
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _purpleAccent,
            side: BorderSide(color: _purpleAccent),
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
          backgroundColor: _bgDarkBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => IntroScreen(),
        '/home': (context) => HomePage(),
        '/upload': (context) => UploadPage(),

        '/settings': (context) => SettingsPage(),
        '/history': (context) => HistoryPage(),
      },
    );
  }
}