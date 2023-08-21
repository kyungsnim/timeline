import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class DisplayCaptureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayCaptureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _DisplayCaptureScreenState createState() => _DisplayCaptureScreenState();
}

class _DisplayCaptureScreenState extends State<DisplayCaptureScreen> {
  ScreenshotController _screenshotController = ScreenshotController();
  late Uint8List _imageFile;
  String currentTime = '';

  @override
  void initState() {
    saveCurrentScreen();
    super.initState();
  }

  getCurrentTime() {
    String currentYear = '${DateTime.now().year}';
    String currentMonth = DateTime.now().month < 10 ? '0${DateTime.now().month}' : '${DateTime.now().month}';
    String currentDay = DateTime.now().day < 10 ? '0${DateTime.now().day}' : '${DateTime.now().day}';
    String currentHour = DateTime.now().hour < 10 ? '0${DateTime.now().hour}' : '${DateTime.now().hour}';
    String currentMinute = DateTime.now().minute < 10 ? '0${DateTime.now().minute}' : '${DateTime.now().minute}';
    String currentSecond = DateTime.now().second < 10 ? '0${DateTime.now().second}' : '${DateTime.now().second}';

    setState(() {
      currentTime = '$currentYear/$currentMonth/$currentDay $currentHour:$currentMinute:$currentSecond';
    });
  }

  saveCurrentScreen() async {
    getCurrentTime();
    await _screenshotController
        .capture(delay: const Duration(milliseconds: 1000))
        .then((Uint8List? image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        // final directory = Directory('/storage/emulated/0/DCIM');
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);

        /// Share Plugin
        // await Share.shareFiles([imagePath.path]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // 이미지는 디바이스에 파일로 저장됩니다. 이미지를 보여주기 위해 주어진
      // 경로로 `Image.file`을 생성하세요.
      body: widget.imagePath != ''
          ? Screenshot(
        controller: _screenshotController,
        child: Stack(
          children: [
            Image.file(File(widget.imagePath)),
            Positioned(
              right: 20,
              bottom: 20,
              child: Column(
                children: [
                  const Text('GEODIS',
                      style: TextStyle(
                          shadows: [
                            Shadow(
                                color: Colors.white,
                                offset: Offset(1, 1),
                                blurRadius: 4)
                          ],
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.blue)),
                  Text(
                      currentTime,
                      style: const TextStyle(
                          shadows: [
                            Shadow(
                                color: Colors.black87,
                                offset: Offset(1, 1),
                                blurRadius: 4)
                          ],
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.yellow)),
                ],
              ),
            )
          ],
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}