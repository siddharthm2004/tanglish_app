import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Sample history data
  final List<HistoryItem> _historyItems = [
    HistoryItem(
      title: 'My Cooking Video',
      date: 'April 10, 2025',
      duration: '2:35',
      thumbnailColor: Color(0xFFE1BEE7),
      languages: ['Tamil', 'English'],
    ),
    HistoryItem(
      title: 'Travel Vlog - Kodaikanal',
      date: 'April 8, 2025',
      duration: '5:12',
      thumbnailColor: Color(0xFFD1C4E9),
      languages: ['Tamil', 'English'],
    ),
    HistoryItem(
      title: 'Tech Review',
      date: 'April 5, 2025',
      duration: '8:45',
      thumbnailColor: Color(0xFFBBDEFB),
      languages: ['Tamil', 'English'],
    ),
    HistoryItem(
      title: 'Family Gathering',
      date: 'April 3, 2025',
      duration: '12:20',
      thumbnailColor: Color(0xFFC8E6C9),
      languages: ['Tamil', 'English'],
    ),
    HistoryItem(
      title: 'Product Tutorial',
      date: 'March 30, 2025',
      duration: '7:45',
      thumbnailColor: Color(0xFFFFE0B2),
      languages: ['Tamil', 'English'],
    ),
    HistoryItem(
      title: 'Interview with Artist',
      date: 'March 28, 2025',
      duration: '15:30',
      thumbnailColor: Color(0xFFFFCCBC),
      languages: ['Tamil', 'English'],
    ),
    HistoryItem(
      title: 'Dance Performance',
      date: 'March 25, 2025',
      duration: '4:15',
      thumbnailColor: Color(0xFFF8BBD0),
      languages: ['Tamil', 'English'],
    ),
  ];

  String _filterOption = 'All';
  List<String> _filterOptions = ['All', 'This Week', 'This Month', 'Oldest'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E5F5),
      appBar: AppBar(
        title: Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Search functionality coming soon!'),
                  backgroundColor: Color(0xFF6A1B9A),
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
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter by:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6A1B9A),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF6A1B9A), width: 1.5),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filterOption,
                icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6A1B9A)),
                style: TextStyle(color: Color(0xFF6A1B9A), fontWeight: FontWeight.w500),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _filterOption = newValue;
                      // In a real app, you would filter the items based on the selection
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
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            'No History Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your subtitle generation history will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to details or show subtitle
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening "${item.title}" details...'),
              backgroundColor: Color(0xFF6A1B9A),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: item.thumbnailColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.video_file,
                        color: Color(0xFF6A1B9A),
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Generated on ${item.date}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFE1BEE7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.duration,
                                style: TextStyle(
                                  color: Color(0xFF6A1B9A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFF3E5F5),
                                border: Border.all(color: Color(0xFF6A1B9A), width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${item.languages[0]} → ${item.languages[1]}',
                                style: TextStyle(
                                  color: Color(0xFF6A1B9A),
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
                  // Options
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade700),
                    onSelected: (String choice) {
                      if (choice == 'download') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Downloading subtitles for "${item.title}"...'),
                            backgroundColor: Color(0xFF6A1B9A),
                          ),
                        );
                      } else if (choice == 'share') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sharing "${item.title}"...'),
                            backgroundColor: Color(0xFF6A1B9A),
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
                              Icon(Icons.download, color: Color(0xFF6A1B9A), size: 20),
                              SizedBox(width: 8),
                              Text('Download Subtitles'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(Icons.share, color: Color(0xFF6A1B9A), size: 20),
                              SizedBox(width: 8),
                              Text('Share'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              SizedBox(height: 12),
              Divider(height: 1),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.edit,
                    label: 'Edit',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Editing subtitles for "${item.title}"...'),
                          backgroundColor: Color(0xFF6A1B9A),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.preview,
                    label: 'Preview',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Previewing "${item.title}"...'),
                          backgroundColor: Color(0xFF6A1B9A),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.download,
                    label: 'Download',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Downloading subtitles for "${item.title}"...'),
                          backgroundColor: Color(0xFF6A1B9A),
                        ),
                      );
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Color(0xFF6A1B9A), size: 20),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Color(0xFF6A1B9A),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(HistoryItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete History Item'),
          content: Text('Are you sure you want to delete "${item.title}" from your history?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Remove the item
                setState(() {
                  _historyItems.remove(item);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleted "${item.title}" from history'),
                    backgroundColor: Color(0xFF6A1B9A),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          _historyItems.add(item);
                          // In a real app, you might want to restore it to its original position
                        });
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

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