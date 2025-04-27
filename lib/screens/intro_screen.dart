import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  // Define the colors to match the HomePage theme
  final Color _pinkAccent = Color(0xFFED2A90);
  final Color _purpleAccent = Color(0xFFAB49D0);
  final Color _fgMutedBlue = Color(0xFF142748);
  final Color _bgDarkBlue = Color(0xFF0D2146);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDarkBlue, // Dark blue background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_purpleAccent.withOpacity(0.6), _pinkAccent.withOpacity(0.6)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset('assets/logo.png', height: 120),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Tanglish Subtitle',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Generator',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 280,
                  child: Text(
                    'Transform your videos with Tamil-English mixed subtitles in seconds',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
                SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _bgDarkBlue, // Dark text
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    // TODO: Implement login or skip functionality
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}