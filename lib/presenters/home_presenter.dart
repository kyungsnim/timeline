import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline/_importer.dart';

var firstCamera;

class HomePresenter extends StatefulWidget {
  const HomePresenter({super.key});

  @override
  State<HomePresenter> createState() => _HomePresenterState();
}

class _HomePresenterState extends State<HomePresenter> {
  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  @override
  void initState() {
    loadAlarms();
    getCamera();
    subscription ??= Alarm.ringStream.stream.listen(
          (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
    super.initState();
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  getCamera() async {
    // 디바이스에서 이용가능한 카메라 목록을 받아옵니다.
    final cameras = await availableCameras();

    // 이용가능한 카메라 목록에서 특정 카메라를 얻습니다.
    firstCamera = cameras.first;
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RingAlarmPresenter(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return HomeView(
      alarms: alarms,
        loadAlarms: () => loadAlarms(),
        navigateToAlarmScreen: (settings) => navigateToAlarmScreen(settings),
      onTapSetAlarm: () => onTapSetAlarm(),
    );
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await Get.to(() => EditAlarmPresenter(alarmSettings: settings));
    if (res != null && res == true) loadAlarms();
  }

  Future<void> onTapSetAlarm() async {
    final res = await Get.to(() => EditAlarmPresenter(alarmSettings: null));
    if (res != null && res == true) loadAlarms();
  }
}
