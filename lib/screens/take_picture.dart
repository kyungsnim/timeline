import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'display_picture.dart';

// 사용자가 주어진 카메라를 사용하여 사진을 찍을 수 있는 화면
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
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
      ResolutionPreset.medium,
    );
    getCurrentTime();
    // 다음으로 controller를 초기화합니다. 초기화 메서드는 Future를 반환합니다.
    _initializeControllerFuture = _controller.initialize();
  }

  getCurrentTime() {
    String currentYear = '${DateTime.now().year}';
    String currentMonth = DateTime.now().month < 10 ? '0${DateTime.now().month}' : '${DateTime.now().month}';
    String currentDay = DateTime.now().day < 10 ? '0${DateTime.now().day}' : '${DateTime.now().day}';
    String currentHour = '';
    String currentMinute = DateTime.now().minute < 10 ? '0${DateTime.now().minute}' : '${DateTime.now().minute}';
    String currentWeekDay = '월';
    String currentTimeText = '오전';

    switch(DateTime.now().weekday) {
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
      currentDate = '$currentYear년 $currentMonth월 $currentDay일 ($currentWeekDay)';
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
      appBar: AppBar(title: Text('Take a picture')),
      // 카메라 프리뷰를 보여주기 전에 컨트롤러 초기화를 기다려야 합니다. 컨트롤러 초기화가
      // 완료될 때까지 FutureBuilder를 사용하여 로딩 스피너를 보여주세요.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Future가 완료되면, 프리뷰를 보여줍니다.
            return Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                    aspectRatio: 9/16,
                    child: CameraPreview(_controller)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        currentTime,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            shadows: [
                              Shadow(
                                  color: Colors.black87,
                                  offset: Offset(1, 1),
                                  blurRadius: 4)
                            ],
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            color: Colors.white)),
                    Text(
                        currentDate,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            shadows: [
                              Shadow(
                                  color: Colors.black87,
                                  offset: Offset(1, 1),
                                  blurRadius: 4)
                            ],
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white)),
                  ],
                )
              ],
            );
          } else {
            // 그렇지 않다면, 진행 표시기를 보여줍니다.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        // onPressed 콜백을 제공합니다.
        onPressed: () async {
          // try / catch 블럭에서 사진을 촬영합니다. 만약 뭔가 잘못된다면 에러에
          // 대응할 수 있습니다.
          try {
            // 카메라 초기화가 완료됐는지 확인합니다.
            await _initializeControllerFuture;

            // path 패키지를 사용하여 이미지가 저장될 경로를 지정합니다.
            var path = '';

            // join(
            // // 본 예제에서는 임시 디렉토리에 이미지를 저장합니다. `path_provider`
            // // 플러그인을 사용하여 임시 디렉토리를 찾으세요.
            // (await getTemporaryDirectory()).path,
            // '${DateTime.now()}.png',
            // )

            // 사진 촬영을 시도하고 저장되는 경로를 로그로 남깁니다.
            _controller.takePicture().then((xFile) async {
              setState(() {
                path = xFile.path;
              });

              // 사진을 촬영하면, 새로운 화면으로 넘어갑니다.
              Get.to(() => DisplayCaptureScreen(imagePath: path));
            });
          } catch (e) {
            // 만약 에러가 발생하면, 콘솔에 에러 로그를 남깁니다.
            print(e);
          }
        },
      ),
    );
  }
}