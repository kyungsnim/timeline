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
      body: SafeArea(
        child: alarms.isNotEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '현재 알람',
                style: TextStyle(
                  color: textColor,
                  fontSize: 32,
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 150),
              ExampleAlarmTile(
                key: Key(alarms[0].id.toString()),
                title: TimeOfDay(
                  hour: alarms[0].dateTime.hour,
                  minute: alarms[0].dateTime.minute,
                ).format(context),
                onPressed: () {},
                onDismissed: () {
                  Alarm.stop(alarms[0].id).then((_) => loadAlarms());
                },
              ),
              const SizedBox(height: 150),
              GestureDetector(
                onTap: () => navigateToAlarmScreen(alarms[0]),
                child: Container(
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
                      ]
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 14),
                  child: const Text('수정',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pretendard',
                      )),
                ),
              ),
            ],
          ),
        )
        // ListView.separated(
        //         itemCount: alarms.length,
        //         separatorBuilder: (context, index) => const Divider(height: 1),
        //         itemBuilder: (context, index) {
        //           return ExampleAlarmTile(
        //             key: Key(alarms[index].id.toString()),
        //             title: TimeOfDay(
        //               hour: alarms[index].dateTime.hour,
        //               minute: alarms[index].dateTime.minute,
        //             ).format(context),
        //             onPressed: () => navigateToAlarmScreen(alarms[index]),
        //             onDismissed: () {
        //               Alarm.stop(alarms[index].id).then((_) => loadAlarms());
        //             },
        //           );
        //         },
        //       )
            :
        Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '알람 맞추기',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 32,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(height: 150),
                    const Text('설정된 알람이 없어요!',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontFamily: 'Pretendard',
                        )),
                    const SizedBox(height: 150),
                    GestureDetector(
                      onTap: () => onTapSetAlarm(),
                      child: Container(
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
                          ]
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 14),
                        child: const Text('알람 설정',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Pretendard',
                            )),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
