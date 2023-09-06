import 'dart:io';
import 'dart:typed_data';
import 'package:alarm/alarm.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeline/_importer.dart';

class DisplayCaptureScreen extends StatefulWidget {
  final String imagePath;
  final AlarmSettings alarmSettings;

  const DisplayCaptureScreen({
    Key? key,
    required this.imagePath,
    required this.alarmSettings,
  }) : super(key: key);

  @override
  _DisplayCaptureScreenState createState() => _DisplayCaptureScreenState();
}

class _DisplayCaptureScreenState extends State<DisplayCaptureScreen> {
  GlobalKey _globalKey = GlobalKey();
  final ScreenshotController _screenshotController = ScreenshotController();
  late Uint8List _imageFile;
  String currentTime = '';
  String currentDate = '';
  File? shareImagePath;

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
    String currentWeekDay = 'MON';
    String currentTimeText = 'AM';

    switch (DateTime.now().weekday) {
      case 0:
        currentWeekDay = 'SUN';
        break;
      case 1:
        currentWeekDay = 'MON';
        break;
      case 2:
        currentWeekDay = 'TUE';
        break;
      case 3:
        currentWeekDay = 'WED';
        break;
      case 4:
        currentWeekDay = 'THU';
        break;
      case 5:
        currentWeekDay = 'FRI';
        break;
      case 6:
        currentWeekDay = 'SAT';
        break;
    }

    if (DateTime.now().hour <= 12) {
      currentTimeText = 'AM';

      if (DateTime.now().hour == 12) {
        currentTimeText = 'PM';
      }
      currentHour = '${DateTime.now().hour}';
    } else {
      currentTimeText = 'PM';
      currentHour = '${DateTime.now().hour - 12}';
    }
    setState(() {
      currentTime = '$currentHour:$currentMinute $currentTimeText';
      currentDate = '$currentYear/$currentMonth/$currentDay $currentWeekDay';
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
        shareImagePath = await File('${directory.path}/image.png').create();
        await shareImagePath!.writeAsBytes(image);

        /// Share Plugin
        // await Share.shareFiles([shareImagePath.path]);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundColor,
      body: widget.imagePath != ''
          ? RepaintBoundary(
              key: _globalKey,
              child: Stack(
                children: [
                  Screenshot(
                    controller: _screenshotController,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.file(
                          File(widget.imagePath),
                          width: Get.width,
                          height: Get.height,
                          fit: BoxFit.fill,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                                    fontSize: 64,
                                    fontFamily: 'Nats',
                                    color: Colors.white)),
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
                                    fontSize: 24,
                                    fontFamily: 'Pretendard',
                                    color: Colors.white)),
                            const SizedBox(height: 160),
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: shareImagePath != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await Share.shareFiles(
                                          [shareImagePath!.path]);
                                      // Get.off(() => const HomePresenter());
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: mainButtonColor,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 38),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.share,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '공유',
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () => _saveLocalImage(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: whiteColor,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 55),
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
                              )
                            : const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                            ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => Get.off(() => const HomePresenter()),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Text('홈으로',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              shadows: [
                                Shadow(
                                  offset: Offset(0,0),
                                  blurRadius: 10,
                                  color: Colors.black38
                                )
                              ]
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 52),
                    ],
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  _saveLocalImage() async {
    final result = await ImageGallerySaver.saveImage(
        shareImagePath!.readAsBytesSync(), // byteData.buffer.asUint8List(),
        quality: 100);
    Fluttertoast.showToast(msg: '저장 완료', gravity: ToastGravity.CENTER);
    Get.off(() => const HomePresenter());
  }
}
