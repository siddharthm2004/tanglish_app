import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  double _subtitleFontSize = 16.0;

  // Updated color scheme to match HomePage
  final Color _pinkAccent = Color(0xFFED2A90);
  final Color _purpleAccent = Color(0xFFAB49D0);
  final Color _brightPurpleButton = Color(0xFF5E60CD);
  final Color _fgMutedBlue = Color(0xFF142748);
  final Color _bgDarkBlue = Color(0xFF0D2146);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDarkBlue, // Changed to dark blue
      appBar: AppBar(
        backgroundColor: _bgDarkBlue, // Changed to dark blue
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
                activeColor: _pinkAccent, // Changed to pink accent
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
                activeColor: _pinkAccent, // Changed to pink accent
              ),
            ),
            _buildSettingCard(
              title: 'Language',
              subtitle: 'Select app language',
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                underline: Container(),
                icon: Icon(Icons.arrow_drop_down, color: _pinkAccent), // Changed to pink accent
                dropdownColor: _fgMutedBlue, // Added dropdown color
                style: TextStyle(color: Colors.white), // Added text style
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
                    activeColor: _pinkAccent, // Changed to pink accent
                    thumbColor: _purpleAccent, // Added thumb color
                    inactiveColor: _brightPurpleButton.withOpacity(0.3), // Added inactive color
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
                        Text('Small', style: TextStyle(fontSize: 12, color: Colors.white70)),
                        Text('Large', style: TextStyle(fontSize: 12, color: Colors.white70)),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language pair settings coming soon!'),
                    backgroundColor: _purpleAccent, // Changed to purple accent
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
            ),
            _buildSectionHeader('Account & Data'),
            _buildSettingCard(
              title: 'Account Information',
              subtitle: 'Manage your profile',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Account settings coming soon!'),
                    backgroundColor: _purpleAccent, // Changed to purple accent
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
            ),
            _buildSettingCard(
              title: 'Storage Management',
              subtitle: 'Manage video and subtitle files',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Storage management coming soon!'),
                    backgroundColor: _purpleAccent, // Changed to purple accent
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
            ),
            _buildSettingCard(
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Privacy policy coming soon!'),
                    backgroundColor: _purpleAccent, // Changed to purple accent
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Help & support coming soon!'),
                    backgroundColor: _purpleAccent, // Changed to purple accent
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign out functionality coming soon!'),
                        backgroundColor: _purpleAccent, // Changed to purple accent
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brightPurpleButton, // Changed to bright purple
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
          color: _pinkAccent, // Changed to pink accent
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
      color: _fgMutedBlue, // Changed to foreground muted blue
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _brightPurpleButton.withOpacity(0.3), width: 1), // Added border
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: _purpleAccent.withOpacity(0.3), // Changed splash color
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
                            color: Colors.white, // Changed to white
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70, // Changed to white with opacity
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