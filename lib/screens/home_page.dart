import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Home - Do nothing as we're already here
    } else if (index == 1) {
      Navigator.pushNamed(context, '/upload');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/subtitle');
    } else if (index == 3) {
      // New history tab
      Navigator.pushNamed(context, '/history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E5F5),
      appBar: AppBar(
        title: Text(
          'Tanglish',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings page
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Create amazing Tanglish subtitles for your videos',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            // Quick actions section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickActionCard(
                    context,
                    'Upload',
                    Icons.upload_file,
                    Color(0xFF7B1FA2),
                        () => Navigator.pushNamed(context, '/upload'),
                  ),
                  _buildQuickActionCard(
                    context,
                    'Generate',
                    Icons.subtitles,
                    Color(0xFF8E24AA),
                        () => Navigator.pushNamed(context, '/subtitle'),
                  ),
                  _buildQuickActionCard(
                    context,
                    'History',
                    Icons.history,
                    Color(0xFF9C27B0),
                        () => Navigator.pushNamed(context, '/history'),
                  ),
                ],
              ),
            ),

            // Recent projects section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Projects',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildRecentProjectCard(
                    'My Cooking Video',
                    'Generated on April 10, 2025',
                    '2:35',
                  ),
                  SizedBox(height: 12),
                  _buildRecentProjectCard(
                    'Travel Vlog - Kodaikanal',
                    'Generated on April 8, 2025',
                    '5:12',
                  ),
                  SizedBox(height: 12),
                  _buildRecentProjectCard(
                    'Tech Review',
                    'Generated on April 5, 2025',
                    '8:45',
                  ),
                ],
              ),
            ),

            // Tips section
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.yellow),
                      SizedBox(width: 8),
                      Text(
                        'Pro Tip',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'For better subtitle accuracy, ensure your video has clear audio and minimal background noise.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Add some padding at the bottom to ensure content isn't hidden by the navigation bar
            SizedBox(height: 70),
          ],
        ),
      ),
      // Replace FloatingActionButton with a standard bottom nav bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF6A1B9A),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subtitles),
            label: 'Subtitles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.27,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentProjectCard(String title, String date, String duration) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Color(0xFFE1BEE7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons.video_file,
                color: Color(0xFF6A1B9A),
                size: 30,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFFE1BEE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              duration,
              style: TextStyle(
                color: Color(0xFF6A1B9A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}