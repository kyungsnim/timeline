import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline/_importer.dart';
import 'package:timeline/screens/take_picture.dart';

class RingAlarmView extends StatelessWidget {
  final AlarmSettings alarmSettings;
  const RingAlarmView({
    required this.alarmSettings,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "일어나세요",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(convertDateTime(), style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // RawMaterialButton(
                //   onPressed: () {
                //     final now = DateTime.now();
                //     Alarm.set(
                //       alarmSettings: alarmSettings.copyWith(
                //         dateTime: DateTime(
                //           now.year,
                //           now.month,
                //           now.day,
                //           now.hour,
                //           now.minute,
                //           0,
                //           0,
                //         ).add(const Duration(minutes: 1)),
                //       ),
                //     ).then((_) => Navigator.pop(context));
                //   },
                //   child: Text(
                //     "Snooze",
                //     style: Theme.of(context).textTheme.titleLarge,
                //   ),
                // ),
                RawMaterialButton(
                  onPressed: () {
                    Alarm.stop(alarmSettings.id)
                        .then((_) => Get.off(() => TakePictureScreen(camera: firstCamera)));
                  },
                  child: Text(
                    "인증샷 찍기",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String convertDateTime() {
    String hour = alarmSettings.dateTime.hour < 10 ? '0${alarmSettings.dateTime.hour}' : alarmSettings.dateTime.hour.toString();
    String minute = alarmSettings.dateTime.minute < 10 ? '0${alarmSettings.dateTime.minute}' : alarmSettings.dateTime.minute.toString();
    String morning = alarmSettings.dateTime.hour < 12 ? 'AM' : 'PM';

    return '$morning $hour : $minute';
  }
}
