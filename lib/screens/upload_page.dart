import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool _fileSelected = false;
  String _selectedFileName = '';
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  void _selectFile() {
    // Simulate file selection
    setState(() {
      _fileSelected = true;
      _selectedFileName = 'MyVideo.mp4';
    });
  }

  void _startUpload() {
    setState(() {
      _isUploading = true;
    });

    // Simulate upload progress
    Future.delayed(Duration(milliseconds: 500), () {
      _simulateProgress();
    });
  }

  void _simulateProgress() {
    if (_uploadProgress < 1.0) {
      setState(() {
        _uploadProgress += 0.1;
      });

      if (_uploadProgress >= 1.0) {
        // Navigate to subtitle page after upload completes
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(context, '/subtitle');
        });
      } else {
        Future.delayed(Duration(milliseconds: 300), () {
          _simulateProgress();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E5F5),
      appBar: AppBar(
        title: Text(
          'Upload Video',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isUploading) ...[
                _buildUploadingView(),
              ] else if (_fileSelected) ...[
                _buildFileSelectedView(),
              ] else ...[
                _buildInitialUploadView(),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: _fileSelected && !_isUploading ?
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: _startUpload,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            'Upload and Continue',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ) : null,
    );
  }

  Widget _buildInitialUploadView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select your video file',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A1B9A),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Supported formats: MP4, MOV, AVI (Max size: 500MB)',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(0xFFE1BEE7),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFFE1BEE7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_upload,
                    size: 40,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Drag and drop your video here',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'or',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _selectFile,
                  icon: Icon(Icons.file_open),
                  label: Text('Browse Files'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: Divider(thickness: 1, color: Colors.grey.shade300),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Divider(thickness: 1, color: Colors.grey.shade300),
            ),
          ],
        ),
        SizedBox(height: 30),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Implement camera functionality
          },
          icon: Icon(Icons.videocam),
          label: Text('Record Video'),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12),
            side: BorderSide(color: Color(0xFF6A1B9A)),
            foregroundColor: Color(0xFF6A1B9A),
          ),
        ),
        SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Implement video URL import
          },
          icon: Icon(Icons.link),
          label: Text('Import from URL'),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12),
            side: BorderSide(color: Color(0xFF6A1B9A)),
            foregroundColor: Color(0xFF6A1B9A),
          ),
        ),
      ],
    );
  }

  Widget _buildFileSelectedView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Selected Video',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A1B9A),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Color(0xFFE1BEE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.video_file,
                    size: 64,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedFileName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '28.5 MB • MP4 Format',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _selectFile,
                    icon: Icon(
                      Icons.change_circle,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFE1BEE7).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFFE1BEE7),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Video Info',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A),
                ),
              ),
              SizedBox(height: 12),
              _buildInfoRow('Duration', '3:45'),
              SizedBox(height: 8),
              _buildInfoRow('Resolution', '1920 x 1080'),
              SizedBox(height: 8),
              _buildInfoRow('Format', 'MP4 (H.264)'),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Click "Upload and Continue" to proceed with subtitle generation',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUploadingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 40),
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Color(0xFFE1BEE7),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.cloud_upload,
              size: 60,
              color: Color(0xFF6A1B9A),
            ),
          ),
        ),
        SizedBox(height: 30),
        Text(
          'Uploading Video',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A1B9A),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Please wait while we upload your video',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: LinearProgressIndicator(
            value: _uploadProgress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFF6A1B9A),
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(height: 16),
        Text(
          '${(_uploadProgress * 100).toInt()}% Complete',
          style: TextStyle(
            color: Color(0xFF6A1B9A),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Text(
          'Uploading $_selectedFileName',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFE1BEE7).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Color(0xFF6A1B9A),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'After upload completes, we\'ll automatically move to subtitle generation',
                  style: TextStyle(
                    color: Color(0xFF6A1B9A),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

