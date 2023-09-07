import 'dart:typed_data';

import 'package:alarm/alarm.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline/_importer.dart';

import 'display_picture.dart';

// 사용자가 주어진 카메라를 사용하여 사진을 찍을 수 있는 화면
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final AlarmSettings alarmSettings;

  const TakePictureScreen({
    Key? key,
    required this.camera,
    required this.alarmSettings,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  bool _loading = false;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String currentTime = '';
  String currentDate = '';

  @override
  void initState() {
    super.initState();
    // 카메라의 현재 출력물을 보여주기 위해 CameraController를 생성합니다.
    _controller = CameraController(
      // 이용 가능한 카메라 목록에서 특정 카메라를 가져옵니다.
      widget.camera,
      // 적용할 해상도를 지정합니다.
      ResolutionPreset.max,
    );
    getCurrentTime();
    // 다음으로 controller를 초기화합니다. 초기화 메서드는 Future를 반환합니다.
    _initializeControllerFuture = _controller.initialize();

    /// 기존 알람으로 동일하게 설정 - 고객 요청으로 주석처리
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   saveAlarm();
    // });
  }

  AlarmSettings buildAlarmSettings() {
    final now = DateTime.now();
    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      widget.alarmSettings.dateTime.hour,
      widget.alarmSettings.dateTime.minute,
      0,
      0,
    );
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: true,
      vibrate: true,
      volumeMax: false,
      // volumeMax,
      notificationTitle: widget.alarmSettings.notificationTitle,
      notificationBody: widget.alarmSettings.notificationBody,
      assetAudioPath: widget.alarmSettings.assetAudioPath,
      stopOnNotificationOpen: false,
    );
    return alarmSettings;
  }

  void saveAlarm() {
    Alarm.set(alarmSettings: buildAlarmSettings());
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

  @override
  void dispose() {
    // 위젯의 생명주기 종료시 컨트롤러 역시 해제시켜줍니다.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundColor,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Future가 완료되면, 프리뷰를 보여줍니다.
            return _loading
                ? Stack(
                    children: [
                      Image.asset(
                        'assets/images/img_background.png',
                        width: Get.width,
                        height: Get.height,
                        fit: BoxFit.fill,
                      ),
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'LOADING',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            SizedBox(height: 20),
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: AspectRatio(
                            aspectRatio: Get.width / Get.height,
                            child: CameraPreview(_controller)),
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
                                  fontSize: 48,
                                  fontFamily: 'Pretendard',
                                  color: Colors.white)),
                          const SizedBox(height: 8),
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
                          const SizedBox(height: 30),
                          GestureDetector(
                            // onPressed 콜백을 제공합니다.
                            onTap: () async {
                              try {
                                // path 패키지를 사용하여 이미지가 저장될 경로를 지정합니다.
                                var path = '';

                                setState(() {
                                  _loading = true;
                                });
                                // 사진 촬영을 시도하고 저장되는 경로를 로그로 남깁니다.
                                _controller.takePicture().then((xFile) async {
                                  setState(() {
                                    path = xFile.path;
                                    _loading = false;
                                  });

                                  // 사진을 촬영하면, 새로운 화면으로 넘어갑니다.
                                  await Get.to(() => DisplayCaptureScreen(
                                      imagePath: path,
                                      alarmSettings: widget.alarmSettings));
                                  getCurrentTime();
                                });
                              } catch (e) {
                                // 만약 에러가 발생하면, 콘솔에 에러 로그를 남깁니다.
                                print(e);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white,
                              ),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: backgroundColor.withOpacity(0.7),
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      )
                    ],
                  );
          } else {
            // 그렇지 않다면, 진행 표시기를 보여줍니다.
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }
        },
      ),
    );
  }
}
