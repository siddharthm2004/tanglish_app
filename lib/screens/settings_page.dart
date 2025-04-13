import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Example settings
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  double _subtitleFontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E5F5),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('App Settings'),
            _buildSettingCard(
              title: 'Notifications',
              subtitle: 'Receive alerts about processed videos',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: Color(0xFF6A1B9A),
              ),
            ),
            _buildSettingCard(
              title: 'Dark Mode',
              subtitle: 'Use dark theme throughout the app',
              trailing: Switch(
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
                activeColor: Color(0xFF6A1B9A),
              ),
            ),
            _buildSettingCard(
              title: 'Language',
              subtitle: 'Select app language',
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                underline: Container(),
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF6A1B9A)),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                  }
                },
                items: <String>['English', 'Tamil', 'Hindi', 'Telugu']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),

            _buildSectionHeader('Subtitle Settings'),
            _buildSettingCard(
              title: 'Font Size',
              subtitle: 'Adjust size of subtitles',
              customWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: _subtitleFontSize,
                    min: 12.0,
                    max: 24.0,
                    divisions: 6,
                    label: _subtitleFontSize.toStringAsFixed(1),
                    activeColor: Color(0xFF6A1B9A),
                    onChanged: (double value) {
                      setState(() {
                        _subtitleFontSize = value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Small', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        Text('Large', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildSettingCard(
              title: 'Default Language Pairs',
              subtitle: 'Change default translation settings',
              onTap: () {
                // Navigate to language pair settings
                // This would be another screen in a real app
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language pair settings coming soon!'),
                    backgroundColor: Color(0xFF6A1B9A),
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),

            _buildSectionHeader('Account & Data'),
            _buildSettingCard(
              title: 'Account Information',
              subtitle: 'Manage your profile',
              onTap: () {
                // Navigate to account settings
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Account settings coming soon!'),
                    backgroundColor: Color(0xFF6A1B9A),
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
            _buildSettingCard(
              title: 'Storage Management',
              subtitle: 'Manage video and subtitle files',
              onTap: () {
                // Navigate to storage settings
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Storage management coming soon!'),
                    backgroundColor: Color(0xFF6A1B9A),
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
            _buildSettingCard(
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () {
                // Navigate to privacy policy
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Privacy policy coming soon!'),
                    backgroundColor: Color(0xFF6A1B9A),
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),

            _buildSectionHeader('About'),
            _buildSettingCard(
              title: 'App Version',
              subtitle: 'Tanglish v1.0.2',
              trailing: null,
            ),
            _buildSettingCard(
              title: 'Help & Support',
              subtitle: 'Get assistance with the app',
              onTap: () {
                // Navigate to help & support
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Help & support coming soon!'),
                    backgroundColor: Color(0xFF6A1B9A),
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle sign out
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign out functionality coming soon!'),
                        backgroundColor: Color(0xFF6A1B9A),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A1B9A),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Add some padding at the bottom
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6A1B9A),
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    Widget? trailing,
    Widget? customWidget,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trailing != null) trailing,
                ],
              ),
              if (customWidget != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: customWidget,
                ),
            ],
          ),
        ),
      ),
    );
  }
}