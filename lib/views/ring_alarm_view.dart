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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "일어나세요",
                style: TextStyle(
                  color: textColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                ),
              ),
              Text(
                convertDateTime(),
                style: const TextStyle(
                  color: textColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                ),
              ),
              GestureDetector(
                onTap: () => Alarm.stop(alarmSettings.id).then(
                  (_) => Get.off(
                    () => TakePictureScreen(camera: firstCamera),
                  ),
                ),
                child: Container(
                  width: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: gradientButtonColor,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 29,
                          spreadRadius: 3,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ]),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 38, vertical: 14),
                  child: const Text(
                    '인증샷 찍기',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
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

    return '$morning $hour : $minute';
  }
}
