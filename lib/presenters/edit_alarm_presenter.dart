import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline/_importer.dart';

class EditAlarmPresenter extends StatefulWidget {
  final AlarmSettings? alarmSettings;

  const EditAlarmPresenter({required this.alarmSettings, super.key});

  @override
  State<EditAlarmPresenter> createState() => _EditAlarmPresenterState();
}

class _EditAlarmPresenterState extends State<EditAlarmPresenter> {
  bool loading = false;

  late bool creating;
  late bool loopAudio;
  late bool vibrate;
  late bool volumeMax;
  late bool showNotification;
  late String assetAudio;
  late TimeOfDay selectedTime;

  bool isToday() {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
      0,
      0,
    );

    return now.isBefore(dateTime);
  }

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      final dt = DateTime.now().add(const Duration(minutes: 1));
      selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      loopAudio = true;
      vibrate = true;
      volumeMax = true;
      showNotification = true;
      assetAudio = 'assets/marimba.mp3';
    } else {
      selectedTime = TimeOfDay(
        hour: widget.alarmSettings!.dateTime.hour,
        minute: widget.alarmSettings!.dateTime.minute,
      );
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volumeMax = widget.alarmSettings!.volumeMax;
      showNotification = widget.alarmSettings!.notificationTitle != null &&
          widget.alarmSettings!.notificationTitle!.isNotEmpty &&
          widget.alarmSettings!.notificationBody != null &&
          widget.alarmSettings!.notificationBody!.isNotEmpty;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: selectedTime,
      context: context,
    );
    if (res != null) setState(() => selectedTime = res);
  }

  AlarmSettings buildAlarmSettings() {
    final now = DateTime.now();
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 100000
        : widget.alarmSettings!.id;

    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
      0,
      0,
    );
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volumeMax: volumeMax,
      notificationTitle: showNotification ? 'Alarm example' : null,
      notificationBody: showNotification ? 'Your alarm ($id) is ringing' : null,
      assetAudioPath: assetAudio,
      stopOnNotificationOpen: false,
    );
    return alarmSettings;
  }

  void saveAlarm() {
    setState(() => loading = true);
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res) Get.back(result: true);
    });
    setState(() => loading = false);
  }

  void deleteAlarm() {
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EditAlarmView(
      creating: creating,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volumeMax: volumeMax,
      showNotification: showNotification,
      assetAudio: assetAudio,
      loading: loading,
      alarmSettings: widget.alarmSettings,
      selectedTime: selectedTime,
      saveAlarm: () => saveAlarm(),
      isToday: () => isToday(),
      pickTime: () => pickTime(),
      deleteAlarm: () => deleteAlarm(),
      onChangeAudio: (value) => onChangeAudio(value),
      onChangeLoopAudio: (value) => onChangeLoopAudio(value),
      onChangeVibrate: (value) => onChangeVibrate(value),
      onChangeVolumeMax: (value) => onChangeVolumeMax(value),
      onChangeShowNotification: (value) => onChangeShowNotification(value),
    );
  }

  void onChangeAudio(value) {
    setState(() => assetAudio = value!);
  }

  void onChangeLoopAudio(value) {
    setState(() => loopAudio = value);
  }

  void onChangeVibrate(value) {
    setState(() => vibrate = value);
  }

  void onChangeVolumeMax(value) {
    setState(() => volumeMax = value);
  }

  void onChangeShowNotification(value) {
    setState(() => showNotification = value);
  }
}
