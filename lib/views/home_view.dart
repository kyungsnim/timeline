import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline/_importer.dart';

class HomeView extends StatelessWidget {
  late List<AlarmSettings> alarms;
  Function loadAlarms;
  Function navigateToAlarmScreen;
  Function onTapSetAlarm;

  HomeView(
      {required this.alarms,
      required this.loadAlarms,
      required this.navigateToAlarmScreen,
      required this.onTapSetAlarm,
      super.key});

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
                children: [
                  const SizedBox(height: 50),
                  alarms.isNotEmpty
                      ? const Column(
                          children: [
                            Text(
                              'WAKE UP TIME',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Nats',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '이 시간에 깨워줄게요',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'MIRACLE MORNING ALARM',
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Nats',
                          ),
                        ),
                  const Spacer(),
                  alarms.isNotEmpty
                      ? ExampleAlarmTile(
                          key: Key(alarms[0].id.toString()),
                          title: TimeOfDay(
                            hour: alarms[0].dateTime.hour,
                            minute: alarms[0].dateTime.minute,
                          ).format(context),
                          onPressed: () {},
                          onDismissed: () {
                            Alarm.stop(alarms[0].id).then((_) => loadAlarms());
                          },
                        )
                      : Text('설정된 알람이 없어요!',
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Pretendard',
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 0),
                                  blurRadius: 13,
                                  color: Colors.black.withOpacity(0.14),
                                )
                              ])),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => alarms.isNotEmpty
                        ? navigateToAlarmScreen(alarms[0])
                        : onTapSetAlarm(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 55, vertical: 12),
                      child: Text(alarms.isNotEmpty ? '수정' : '알람 맞추기',
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Pretendard',
                          )),
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
}
