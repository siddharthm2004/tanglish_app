import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Color scheme matching the app theme
  final Color _pinkAccent = Color(0xFFED2A90);
  final Color _purpleAccent = Color(0xFFAB49D0);
  final Color _brightPurpleButton = Color(0xFF5E60CD);
  final Color _fgMutedBlue = Color(0xFF142748);
  final Color _bgDarkBlue = Color(0xFF0D2146);

  // Sample history data
  final List<HistoryItem> _historyItems = [
    HistoryItem(
      title: 'My Cooking Video',
      date: 'April 10, 2025',
      duration: '2:35',
      thumbnailColor: Color(0xFFED2A90).withOpacity(0.7), // Using _pinkAccent
      languages: ['Tamil', 'English'],
    ),
    HistoryItem(
      title: 'Travel Vlog - Kodaikanal',
      date: 'April 8, 2025',
      duration: '5:12',
      thumbnailColor: Color(0xFFAB49D0).withOpacity(0.7), // Using _purpleAccent
      languages: ['Tamil', 'English'],
    ),
    HistoryItem(
      title: 'Tech Review',
      date: 'April 5, 2025',
      duration: '8:45',
      thumbnailColor: Color(0xFF5E60CD).withOpacity(0.7), // Using _brightPurpleButton
      languages: ['Tamil', 'English'],
    ),
    HistoryItem(
      title: 'Family Gathering',
      date: 'April 3, 2025',
      duration: '12:20',
      thumbnailColor: Color(0xFFED2A90).withOpacity(0.7), // Using _pinkAccent
      languages: ['Tamil', 'English'],
    ),
    HistoryItem(
      title: 'Product Tutorial',
      date: 'March 30, 2025',
      duration: '7:45',
      thumbnailColor: Color(0xFFAB49D0).withOpacity(0.7), // Using _purpleAccent
      languages: ['Tamil', 'English'],
    ),
    HistoryItem(
      title: 'Interview with Artist',
      date: 'March 28, 2025',
      duration: '15:30',
      thumbnailColor: Color(0xFF5E60CD).withOpacity(0.7), // Using _brightPurpleButton
      languages: ['Tamil', 'English'],
    ),
    HistoryItem(
      title: 'Dance Performance',
      date: 'March 25, 2025',
      duration: '4:15',
      thumbnailColor: Color(0xFFED2A90).withOpacity(0.7), // Using _pinkAccent
      languages: ['Tamil', 'English'],
    ),
  ];

  String _filterOption = 'All';
  List<String> _filterOptions = ['All', 'This Week', 'This Month', 'Oldest'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDarkBlue, // Changed to dark blue
      appBar: AppBar(
        backgroundColor: _bgDarkBlue, // Changed to dark blue
        elevation: 0,
        title: Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Search functionality coming soon!'),
                  backgroundColor: _purpleAccent, // Changed to purple accent
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: _historyItems.isEmpty
                ? _buildEmptyState()
                : _buildHistoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: _fgMutedBlue, // Changed to foreground muted blue
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter by:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white, // Changed to white
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: _pinkAccent, width: 1.5), // Changed to pink accent
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filterOption,
                icon: Icon(Icons.keyboard_arrow_down, color: _pinkAccent), // Changed to pink accent
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500), // Changed to white
                dropdownColor: _fgMutedBlue, // Added dropdown color
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _filterOption = newValue;
                      // In real app, you would filter list based on newValue
                    });
                  }
                },
                items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.white.withOpacity(0.5), // Changed to white with opacity
          ),
          SizedBox(height: 16),
          Text(
            'No History Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Changed to white
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your subtitle generation history will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70, // Changed to white with opacity
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/upload');
            },
            icon: Icon(Icons.add),
            label: Text('Create New Subtitle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _brightPurpleButton, // Changed to bright purple
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _historyItems.length,
      itemBuilder: (context, index) {
        return _buildHistoryCard(_historyItems[index]);
      },
    );
  }

  Widget _buildHistoryCard(HistoryItem item) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: _fgMutedBlue, // Changed to foreground muted blue
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _brightPurpleButton.withOpacity(0.3), width: 1), // Added border
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening "${item.title}" details...'),
              backgroundColor: _purpleAccent, // Changed to purple accent
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: _purpleAccent.withOpacity(0.3), // Added splash color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_pinkAccent.withOpacity(0.7), item.thumbnailColor],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.video_file,
                        color: Colors.white, // Changed to white
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white, // Changed to white
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Generated on ${item.date}',
                          style: TextStyle(
                            color: Colors.white70, // Changed to white with opacity
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _brightPurpleButton.withOpacity(0.5), // Changed to bright purple with opacity
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.duration,
                                style: TextStyle(
                                  color: Colors.white, // Changed to white
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _bgDarkBlue, // Changed to background dark blue
                                border: Border.all(color: _pinkAccent, width: 1), // Changed to pink accent
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${item.languages[0]} → ${item.languages[1]}',
                                style: TextStyle(
                                  color: Colors.white, // Changed to white
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.white70), // Changed to white with opacity
                    color: _fgMutedBlue, // Added menu background color
                    onSelected: (String choice) {
                      if (choice == 'download') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Downloading subtitles for "${item.title}"...'),
                            backgroundColor: _purpleAccent, // Changed to purple accent
                          ),
                        );
                      } else if (choice == 'share') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sharing "${item.title}"...'),
                            backgroundColor: _purpleAccent, // Changed to purple accent
                          ),
                        );
                      } else if (choice == 'delete') {
                        _showDeleteConfirmation(item);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'download',
                          child: Row(
                            children: [
                              Icon(Icons.download, color: _pinkAccent, size: 20), // Changed to pink accent
                              SizedBox(width: 8),
                              Text('Download Subtitles', style: TextStyle(color: Colors.white)), // Changed to white
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(Icons.share, color: _pinkAccent, size: 20), // Changed to pink accent
                              SizedBox(width: 8),
                              Text('Share', style: TextStyle(color: Colors.white)), // Changed to white
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.white)), // Changed to white
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(HistoryItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _fgMutedBlue, // Changed to foreground muted blue
          title: Text('Delete "${item.title}"?', style: TextStyle(color: Colors.white)), // Changed to white
          content: Text('Are you sure you want to delete this history item?', style: TextStyle(color: Colors.white70)), // Changed to white with opacity
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: _pinkAccent)), // Changed to pink accent
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _historyItems.remove(item);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleted "${item.title}" successfully!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

// Model Class
class HistoryItem {
  final String title;
  final String date;
  final String duration;
  final Color thumbnailColor;
  final List<String> languages;

  HistoryItem({
    required this.title,
    required this.date,
    required this.duration,
    required this.thumbnailColor,
    required this.languages,
  });
}