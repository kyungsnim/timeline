import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline/_importer.dart';
import 'package:timeline/screens/take_picture.dart';
import 'package:volume_controller/volume_controller.dart';

class RingAlarmView extends StatefulWidget {
  final AlarmSettings alarmSettings;
  final double volume;

  const RingAlarmView(
      {required this.alarmSettings, required this.volume, super.key});

  @override
  State<RingAlarmView> createState() => _RingAlarmViewState();
}

class _RingAlarmViewState extends State<RingAlarmView> {
  late final VolumeController _volumeController = VolumeController();

  @override
  void initState() {
    super.initState();

    /// 설정한 볼륨으로 높여주기
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _volumeController.setVolume(widget.volume);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/img_background.png',
            width: Get.width,
            height: Get.height,
            fit: BoxFit.fill,
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'GOOD MORNING',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '한 번에 일어나세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    convertDateTime(),
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 0),
                            blurRadius: 13,
                            color: Colors.black.withOpacity(0.14),
                          )
                        ]),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Alarm.stop(widget.alarmSettings.id).then(
                      (_) => Get.off(
                        () => TakePictureScreen(
                            camera: firstCamera,
                            alarmSettings: widget.alarmSettings),
                      ),
                    ),
                    child: FittedBox(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: whiteColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 55, vertical: 12),
                        child: const Text('알람 끄고 사진 찍기',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Pretendard',
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String convertDateTime() {
    String hour = widget.alarmSettings.dateTime.hour < 10
        ? '0${widget.alarmSettings.dateTime.hour}'
        : widget.alarmSettings.dateTime.hour.toString();
    String minute = widget.alarmSettings.dateTime.minute < 10
        ? '0${widget.alarmSettings.dateTime.minute}'
        : widget.alarmSettings.dateTime.minute.toString();
    String morning = widget.alarmSettings.dateTime.hour < 12 ? 'AM' : 'PM';

    return '$hour:$minute $morning';
  }
}
