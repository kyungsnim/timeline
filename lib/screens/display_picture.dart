import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeline/_importer.dart';

class DisplayCaptureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayCaptureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _DisplayCaptureScreenState createState() => _DisplayCaptureScreenState();
}

class _DisplayCaptureScreenState extends State<DisplayCaptureScreen> {
  GlobalKey _globalKey = GlobalKey();
  final ScreenshotController _screenshotController = ScreenshotController(

  );
  late Uint8List _imageFile;
  String currentTime = '';
  String currentDate = '';

  @override
  void initState() {
    saveCurrentScreen();
    super.initState();
  }

  getCurrentTime() {
    String currentYear = '${DateTime.now().year}';
    String currentMonth = DateTime.now().month < 10
        ? '0${DateTime.now().month}'
        : '${DateTime.now().month}';
    String currentDay = DateTime.now().day < 10
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    String currentHour = '';
    String currentMinute = DateTime.now().minute < 10
        ? '0${DateTime.now().minute}'
        : '${DateTime.now().minute}';
    String currentWeekDay = '월';
    String currentTimeText = '오전';

    switch (DateTime.now().weekday) {
      case 0:
        currentWeekDay = '일';
        break;
      case 1:
        currentWeekDay = '월';
        break;
      case 2:
        currentWeekDay = '화';
        break;
      case 3:
        currentWeekDay = '수';
        break;
      case 4:
        currentWeekDay = '목';
        break;
      case 5:
        currentWeekDay = '금';
        break;
      case 6:
        currentWeekDay = '토';
        break;
    }

    if (DateTime.now().hour <= 12) {
      currentTimeText = '오전';

      if (DateTime.now().hour == 12) {
        currentTimeText = '오후';
      }
      currentHour = '${DateTime.now().hour}';
    } else {
      currentTimeText = '오후';
      currentHour = '${DateTime.now().hour - 12}';
    }
    setState(() {
      currentTime = '$currentTimeText $currentHour:$currentMinute';
      currentDate =
          '$currentYear년\n$currentMonth월 $currentDay일 ($currentWeekDay)';
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          '인증샷',
          style: TextStyle(
            color: textColor,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: widget.imagePath != ''
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RepaintBoundary(
                  key: _globalKey,
                  child: Screenshot(
                    controller: _screenshotController,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.file(
                          File(widget.imagePath),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(currentTime,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    shadows: [
                                      Shadow(
                                          color: Colors.black87,
                                          offset: Offset(1, 1),
                                          blurRadius: 4)
                                    ],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 70,
                                    fontFamily: 'Pretendard',
                                    color: Colors.white)),
                            const SizedBox(height: 40),
                            Text(currentDate,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    shadows: [
                                      Shadow(
                                          color: Colors.black87,
                                          offset: Offset(1, 1),
                                          blurRadius: 4)
                                    ],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                    fontFamily: 'Pretendard',
                                    color: Colors.white)),
                            const SizedBox(height: 80),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async =>
                            await Share.shareFiles([widget.imagePath]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          child: const Text(
                            '공유',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _saveLocalImage(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          child: const Text(
                            '저장',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  _saveLocalImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List(),
          quality: 100);
      Fluttertoast.showToast(msg: '저장 완료');
      print(result);
    }
  }
}
