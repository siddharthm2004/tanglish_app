import 'package:flutter/material.dart';

class SubtitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Subtitles'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // subtitle generation logic placeholder
          },
          child: Text('Generate Subtitles'),
        ),
      ),
    );
  }
}
