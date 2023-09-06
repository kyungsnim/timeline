import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:timeline/_importer.dart';
import 'package:volume_controller/volume_controller.dart';

class RingAlarmPresenter extends StatefulWidget {
  final AlarmSettings alarmSettings;
  final double volume;
  const RingAlarmPresenter({
    required this.alarmSettings,
    required this.volume,
    super.key});

  @override
  State<RingAlarmPresenter> createState() => _RingAlarmPresenterState();
}

class _RingAlarmPresenterState extends State<RingAlarmPresenter> {
  @override
  Widget build(BuildContext context) {
    return RingAlarmView(
      volume: widget.volume,
      alarmSettings: widget.alarmSettings,
    );
  }
}
