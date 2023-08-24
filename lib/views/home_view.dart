import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline/_importer.dart';

class HomeView extends StatelessWidget {
  late List<AlarmSettings> alarms;
  Function loadAlarms;
  Function navigateToAlarmScreen;
  Function onTapSetAlarm;

  HomeView({
    required this.alarms,
    required this.loadAlarms,
    required this.navigateToAlarmScreen,
    required this.onTapSetAlarm,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: alarms.isNotEmpty
            ? ListView.separated(
          itemCount: alarms.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            return ExampleAlarmTile(
              key: Key(alarms[index].id.toString()),
              title: TimeOfDay(
                hour: alarms[index].dateTime.hour,
                minute: alarms[index].dateTime.minute,
              ).format(context),
              onPressed: () => navigateToAlarmScreen(alarms[index]),
              onDismissed: () {
                Alarm.stop(alarms[index].id).then((_) => loadAlarms());
              },
            );
          },
        )
            : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text('설정된 알람이 없어요!'),
                  SizedBox(height: 30),
                  TextButton(
                    child: Text('알람 설정'),
                    onPressed: () => onTapSetAlarm(),
                  )
                ],
        ),
            ),
      ),
    );
  }
}
