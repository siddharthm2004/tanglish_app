import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// Import the API service we created
import 'api_service.dart';
// Video player imports
import 'package:video_player/video_player.dart';
// Subtitle parser
import 'package:subtitle/subtitle.dart';

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

  // Video player controller
  VideoPlayerController? _videoPlayerController;
  bool _isVideoInitialized = false;

  // Subtitle related
  String _selectedSubtitleLanguage = 'standard_tamil'; // Default
  Map<String, List<SubtitleEntry>> _subtitlesMap = {};
  List<SubtitleEntry> _currentSubtitles = [];
  String _currentSubtitleText = '';

  // Color scheme
  final Color _pinkAccent = Color(0xFFED2A90);
  final Color _purpleAccent = Color(0xFFAB49D0);
  final Color _brightPurpleButton = Color(0xFF5E60CD);
  final Color _fgMutedBlue = Color(0xFF142748);
  final Color _bgDarkBlue = Color(0xFF0D2146);

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    if (_selectedFile == null) return;

    _videoPlayerController = VideoPlayerController.file(_selectedFile!);
    _videoPlayerController!.initialize().then((_) {
      setState(() {
        _isVideoInitialized = true;
      });

      // Setup subtitle timing listener
      _videoPlayerController!.addListener(_checkSubtitles);
    });
  }

  void _checkSubtitles() {
    if (!_isVideoInitialized || _currentSubtitles.isEmpty) return;

    final currentPosition = _videoPlayerController!.value.position;
    String newSubtitle = '';

    for (var entry in _currentSubtitles) {
      if (currentPosition >= entry.start && currentPosition <= entry.end) {
        newSubtitle = entry.text;
        break;
      }
    }

    if (newSubtitle != _currentSubtitleText) {
      setState(() {
        _currentSubtitleText = newSubtitle;
      });
    }
  }

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
          _isVideoInitialized = false;
          _currentSubtitleText = '';
          _subtitlesMap = {};
        });

        // Initialize video player with the selected file
        _initializeVideoPlayer();
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

    // Stop and dispose of video player
    _videoPlayerController?.pause();
    _videoPlayerController?.dispose();

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
      _isVideoInitialized = false;
      _videoPlayerController = null;
      _currentSubtitleText = '';
      _subtitlesMap = {};
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

        // Set the subtitle text
        _subtitleText = 'Tanglish-tamil: ' + _processResults!['pure_tamil'] + '\n\n' +
            'English: ' + _processResults!['english'] + '\n\n' +
            'Tanglish-eng: ' + _processResults!['tanglish'] + '\n\n' +
            'Tamil: ' + _processResults!['standard_tamil'];

        // Generate subtitle entries for each language
        _parseSubtitles();

        // Set current subtitles based on selected language
        _changeSubtitleLanguage(_selectedSubtitleLanguage);
      });
    } catch (e) {
      setState(() {
        _isGeneratingSubtitles = false;
      });
      _showErrorDialog('Processing error: $e');
    }
  }

  void _parseSubtitles() {
    if (_processResults == null) return;

    _subtitlesMap = {};

    // For each language, create mock subtitle entries
    // In a real app, you'd parse actual SRT timing data from your API
    final languages = ['standard_tamil', 'pure_tamil', 'english', 'tanglish'];
    final videoDuration = _videoPlayerController?.value.duration ?? Duration(minutes: 2);

    for (var lang in languages) {
      if (_processResults!.containsKey(lang)) {
        String text = _processResults![lang];
        List<String> sentences = text.split('. ');
        List<SubtitleEntry> entries = [];

        // Create equally spaced subtitle entries across the video duration
        final segmentDuration = videoDuration.inMilliseconds ~/ sentences.length;

        for (int i = 0; i < sentences.length; i++) {
          if (sentences[i].trim().isNotEmpty) {
            entries.add(
                SubtitleEntry(
                  start: Duration(milliseconds: i * segmentDuration),
                  end: Duration(milliseconds: (i + 1) * segmentDuration - 100),
                  text: sentences[i].trim() + (sentences[i].endsWith('.') ? '' : '.'),
                )
            );
          }
        }

        _subtitlesMap[lang] = entries;
      }
    }
  }

  void _changeSubtitleLanguage(String language) {
    setState(() {
      _selectedSubtitleLanguage = language;
      _currentSubtitles = _subtitlesMap[language] ?? [];
      // Reset current subtitle text for immediate update
      _currentSubtitleText = '';
      _checkSubtitles();
    });
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
        child: SingleChildScrollView(
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
    return Container(
      height: 400,
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
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _isUploading
                ? _buildUploadingIndicator()
                : _isVideoInitialized
                ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Video Player
                Center(
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController!),
                  ),
                ),
                // Subtitle overlay
                if (_currentSubtitleText.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: EdgeInsets.only(bottom: 48, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _currentSubtitleText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                // Video Controls
                Container(
                  height: 40,
                  color: Colors.black.withOpacity(0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _videoPlayerController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _videoPlayerController!.value.isPlaying
                                ? _videoPlayerController!.pause()
                                : _videoPlayerController!.play();
                          });
                        },
                      ),
                      Expanded(
                        child: VideoProgressIndicator(
                          _videoPlayerController!,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: _pinkAccent,
                            bufferedColor: _purpleAccent.withOpacity(0.5),
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                      Text(
                        _formatDuration(_videoPlayerController!.value.position) +
                            ' / ' +
                            _formatDuration(_videoPlayerController!.value.duration),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ],
            )
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
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
            'Select Subtitle Language',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          // Subtitle language selection
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildLanguageButton('Tamil', 'standard_tamil'),
                SizedBox(width: 8),
                _buildLanguageButton('Pure Tamil', 'pure_tamil'),
                SizedBox(width: 8),
                _buildLanguageButton('English', 'english'),
                SizedBox(width: 8),
                _buildLanguageButton('Tanglish', 'tanglish'),
              ],
            ),
          ),
          SizedBox(height: 16),
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
            height: 200,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _fgMutedBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _purpleAccent.withOpacity(0.5)),
            ),
            child: SingleChildScrollView(
              child: Text(
                _subtitleText,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.white,
                ),
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

  Widget _buildLanguageButton(String label, String languageCode) {
    bool isSelected = _selectedSubtitleLanguage == languageCode;

    return ElevatedButton(
      onPressed: () {
        _changeSubtitleLanguage(languageCode);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: isSelected ? _pinkAccent : _fgMutedBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

// Simple subtitle entry class
class SubtitleEntry {
  final Duration start;
  final Duration end;
  final String text;

  SubtitleEntry({required this.start, required this.end, required this.text});
}