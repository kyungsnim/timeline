import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline/_importer.dart';
import 'package:timeline/screens/take_picture.dart';

class RingAlarmView extends StatelessWidget {
  final AlarmSettings alarmSettings;

  const RingAlarmView({required this.alarmSettings, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Image.asset('assets/images/img_background.png'),
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
                      fontSize: 20,
                      fontFamily: 'Nats',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                        fontSize: 64,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Nats',
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: const Offset(0,0),
                            blurRadius: 13,
                            color: Colors.black.withOpacity(0.14),
                          )
                        ]
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Alarm.stop(alarmSettings.id).then(
                      (_) => Get.off(
                        () => TakePictureScreen(camera: firstCamera, alarmSettings: alarmSettings),
                      ),
                    ),
                    child: FittedBox(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: whiteColor,
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 55, vertical: 12),
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
    String hour = alarmSettings.dateTime.hour < 10
        ? '0${alarmSettings.dateTime.hour}'
        : alarmSettings.dateTime.hour.toString();
    String minute = alarmSettings.dateTime.minute < 10
        ? '0${alarmSettings.dateTime.minute}'
        : alarmSettings.dateTime.minute.toString();
    String morning = alarmSettings.dateTime.hour < 12 ? 'AM' : 'PM';

    return '$hour:$minute $morning';
  }
}
