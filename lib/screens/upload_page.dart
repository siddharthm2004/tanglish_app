import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// Import the API service we created
import 'api_service.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool _fileSelected = false;
  String _selectedFileName = '';
  double _progress = 0.0;
  bool _isUploading = false;
  bool _isGeneratingSubtitles = false;
  bool _isDownloading = false;
  String _subtitleText = '';
  File? _selectedFile;
  String? _uploadId;
  Map<String, dynamic>? _processResults;
  final ApiService _apiService = ApiService();

  // Color scheme
  final Color _pinkAccent = Color(0xFFED2A90);
  final Color _purpleAccent = Color(0xFFAB49D0);
  final Color _brightPurpleButton = Color(0xFF5E60CD);
  final Color _fgMutedBlue = Color(0xFF142748);
  final Color _bgDarkBlue = Color(0xFF0D2146);

  void _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _fileSelected = true;
          _selectedFile = File(result.files.single.path!);
          _selectedFileName = path.basename(_selectedFile!.path);
          _isUploading = false;
          _isGeneratingSubtitles = false;
          _subtitleText = '';
          _uploadId = null;
          _processResults = null;
        });
      }
    } catch (e) {
      _showErrorDialog('Error selecting file: $e');
    }
  }

  void _startUpload({bool generateSubtitlesAfterUpload = false}) async {
    if (_selectedFile == null) return;

    setState(() {
      _isUploading = true;
      _progress = 0.0;
    });

    try {
      // Show progress simulation while uploading
      _simulateProgress();

      // Actual upload call
      final result = await _apiService.uploadVideo(_selectedFile!);

      setState(() {
        _isUploading = false;
        _progress = 1.0;
        _uploadId = result['upload_id'];
      });

      // If this upload was initiated from the generate subtitles method, continue with generation
      if (generateSubtitlesAfterUpload) {
        _generateSubtitles();
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _showErrorDialog('Upload error: $e');
    }
  }

  void _simulateProgress() {
    if (_progress < 0.95) {
      Future.delayed(Duration(milliseconds: 300), () {
        if (_isUploading || _isGeneratingSubtitles || _isDownloading) {
          setState(() {
            _progress += 0.1;
          });
          _simulateProgress();
        }
      });
    }
  }

  void _cancelUpload() async {
    // Clean up any files on the server if we have an upload ID
    if (_uploadId != null) {
      try {
        await _apiService.cleanupFiles(_uploadId!);
      } catch (e) {
        print('Error cleaning up: $e');
      }
    }

    setState(() {
      _fileSelected = false;
      _isUploading = false;
      _isGeneratingSubtitles = false;
      _isDownloading = false;
      _progress = 0.0;
      _subtitleText = '';
      _selectedFile = null;
      _uploadId = null;
      _processResults = null;
    });
  }

  void _generateSubtitles() async {
    if (_uploadId == null) {
      // If we haven't uploaded yet, do that first
      _startUpload(generateSubtitlesAfterUpload: true);
      return; // Exit this method - the upload will call _generateSubtitles again when complete
    }

    setState(() {
      _isGeneratingSubtitles = true;
      _progress = 0.0;
    });

    try {
      // Show progress simulation while processing
      _simulateProgress();

      // Actual processing call
      final result = await _apiService.processVideo(_uploadId!);
      _processResults = result['results'];

      setState(() {
        _isGeneratingSubtitles = false;
        _progress = 1.0;

        // Set the subtitle text based on the selected language
        // Default to Tamil transcription, but you could add UI to select different results
        _subtitleText = 'Tanglish-tamil: '+_processResults!['pure_tamil'] + '\n\n' +
            'English: ' + _processResults!['english'] + '\n\n' +
            'Tanglish-eng: ' + _processResults!['tanglish']+'\n\n'+
            'Tamil :'+ _processResults!['standard_tamil'];
        ;

      });
    } catch (e) {
      setState(() {
        _isGeneratingSubtitles = false;
      });
      _showErrorDialog('Processing error: $e');
    }
  }

  // Download SRT file
  void _downloadSrtFile() async {
    if (_uploadId == null) return;

    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    try {
      // Show progress simulation
      _simulateProgress();

      // Actual download call
      final resultText = await _apiService.downloadResults(_uploadId!);

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${_getFileNameWithoutExtension(_selectedFileName)}.srt';
      final File file = File(filePath);
      await file.writeAsString(resultText);

      setState(() {
        _isDownloading = false;
        _progress = 1.0;
      });

      _showDownloadCompleteDialog(filePath);
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      _showErrorDialog('Download error: $e');
    }
  }

  void _showDownloadCompleteDialog([String? filePath]) {
    String message = 'Subtitles have been downloaded as "${_getFileNameWithoutExtension(_selectedFileName)}.srt"';
    if (filePath != null) {
      message += '\nSaved to: $filePath';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _fgMutedBlue,
          title: Text('Download Complete', style: TextStyle(color: Colors.white)),
          content: Text(
            message,
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(color: _pinkAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _fgMutedBlue,
          title: Text('Error', style: TextStyle(color: Colors.white)),
          content: Text(
            message,
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(color: _pinkAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Helper method to get filename without extension
  String _getFileNameWithoutExtension(String fileName) {
    if (fileName.contains('.')) {
      return fileName.split('.').first;
    }
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDarkBlue,
      appBar: AppBar(
        backgroundColor: _bgDarkBlue,
        title: Text(
          'Upload Video',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView (
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_fileSelected) ...[
                  _buildVideoView(),
                  if (_isGeneratingSubtitles || _subtitleText.isNotEmpty) ...[
                    _buildSubtitleSection(),
                  ] else ...[
                    _buildGenerateButtons(),
                  ],
                ] else ...[
                  _buildUploadButton(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_pinkAccent, _purpleAccent],
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.cloud_upload,
                  size: 60,
                  color: Colors.white,
                ),
                onPressed: _selectFile,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Upload Video',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Tap to select a video file',
              style: TextStyle(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_fgMutedBlue, _fgMutedBlue.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: _isUploading
                ? _buildUploadingIndicator()
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.videocam,
                  size: 64,
                  color: _pinkAccent,
                ),
                SizedBox(height: 8),
                Text(
                  _selectedFileName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Video Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              _uploadId != null ? 'Upload ID: ${_uploadId!.substring(0, 6)}...' : 'Ready to upload',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_pinkAccent),
        ),
        SizedBox(height: 16),
        Text(
          'Uploading video...',
          style: TextStyle(
            color: _pinkAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '${(_progress * 100).toInt()}% Complete',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButtons() {
    return Column(
      children: [
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _uploadId != null ? _generateSubtitles : _startUpload,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _brightPurpleButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _uploadId != null ? 'Generate Subtitles' : 'Upload Video',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancelUpload,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: _purpleAccent),
                  foregroundColor: _purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubtitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 24),
        if (_isGeneratingSubtitles && _subtitleText.isEmpty) ...[
          Text(
            'Generating Subtitles',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: _fgMutedBlue,
            valueColor: AlwaysStoppedAnimation<Color>(_pinkAccent),
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
          SizedBox(height: 8),
          Text(
            '${(_progress * 100).toInt()}% Complete',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
        if (_subtitleText.isNotEmpty) ...[
          Text(
            'Generated Subtitles',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _fgMutedBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _purpleAccent.withOpacity(0.5)),
            ),
            child: Text(
              _subtitleText,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 24),
          if (_isDownloading) ...[
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: _fgMutedBlue,
              valueColor: AlwaysStoppedAnimation<Color>(_pinkAccent),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            SizedBox(height: 8),
            Text(
              'Downloading SRT file: ${(_progress * 100).toInt()}%',
              style: TextStyle(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isDownloading ? null : _downloadSrtFile,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: _brightPurpleButton,
                    disabledBackgroundColor: _brightPurpleButton.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(Icons.download, color: Colors.white),
                  label: Text(
                    'Download SRT File',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          OutlinedButton(
            onPressed: _cancelUpload,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: _purpleAccent),
              foregroundColor: _purpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Back to Upload',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}