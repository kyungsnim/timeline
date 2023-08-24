import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:timeline/_importer.dart';

class RingAlarmPresenter extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const RingAlarmPresenter({
    required this.alarmSettings,
    super.key});

  @override
  State<RingAlarmPresenter> createState() => _RingAlarmPresenterState();
}

class _RingAlarmPresenterState extends State<RingAlarmPresenter> {
  @override
  Widget build(BuildContext context) {
    return RingAlarmView(
      alarmSettings: widget.alarmSettings,
    );
  }
}
