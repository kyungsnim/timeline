import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline/_importer.dart';
import 'package:volume_controller/volume_controller.dart';

class EditAlarmPresenter extends StatefulWidget {
  final AlarmSettings? alarmSettings;
  String? mode;

  EditAlarmPresenter({required this.alarmSettings, this.mode, super.key});

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
  double volume = 0.5;

  // late TimeOfDay selectedTime;
  late Time selectedTime;
  List<String> assetAudioList = [
    '삐삐삐(보통)',
    '삐삐삐(빠르게)',
    '레인보우',
    '따르릉',
    'ringtone',
    '꼬끼오',
    '귀뚜라미',
  ];

  VolumeController volumeController = VolumeController();
  AudioPlayer audioPlayer = AudioPlayer();

  List<bool> loopDayList = List.generate(7, (index) => false);

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

  void getVolume() async{
    volume = await volumeController.getVolume();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    getVolume();

    if (creating) {
      final dt = DateTime.now().add(const Duration(minutes: 1));
      // selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      selectedTime = Time(hour: dt.hour, minute: dt.minute);
      loopAudio = true;
      vibrate = true;
      volumeMax = true;
      showNotification = true;
      assetAudio = '삐삐삐(보통)';
    } else {
      selectedTime = Time(
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

      switch (widget.alarmSettings!.assetAudioPath
          .replaceAll('assets/', '')
          .replaceAll('.mp3', '')) {
        case 'audio_1': assetAudio = '삐삐삐(보통)'; break;
        case 'audio_2': assetAudio = '삐삐삐(빠르게)'; break;
        case 'audio_3': assetAudio = '레인보우'; break;
        case 'audio_4': assetAudio = '따르릉'; break;
        case 'audio_5': assetAudio = 'ringtone'; break;
        case 'audio_6': assetAudio = '꼬끼오'; break;
        case 'audio_7': assetAudio = '귀뚜라미'; break;
      }

      // assetAudio = widget.alarmSettings!.assetAudioPath
      //     .replaceAll('assets/', '')
      //     .replaceAll('.mp3', '');
    }
  }

  Future<void> pickTime() async {
    await Navigator.of(context).push(
      showPicker(
        context: context,
        value: selectedTime,
        sunrise: TimeOfDay(hour: 6, minute: 0),
        // optional
        sunset: TimeOfDay(hour: 18, minute: 0),
        accentColor: mainButtonColor,
        // optional
        // optional
        onChange: (Time newTime) {
          setState(() {
            selectedTime = newTime;
          });
        },
        okText: '확인',
        okStyle: const TextStyle(
          fontSize: 20,
          color: mainButtonColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Pretendard',
        ),
        cancelText: '취소',
        cancelStyle: const TextStyle(
          fontSize: 20,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontFamily: 'Pretendard',
        ),
      ),
    );
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

    String assetAudioPath = '';

    switch(assetAudio) {
      case '삐삐삐(보통)': assetAudioPath = 'assets/audio_1.mp3'; break;
      case '삐삐삐(빠르게)': assetAudioPath = 'assets/audio_2.mp3'; break;
      case '레인보우': assetAudioPath = 'assets/audio_3.mp3'; break;
      case '따르릉': assetAudioPath = 'assets/audio_4.mp3';  break;
      case 'ringtone': assetAudioPath = 'assets/audio_5.mp3'; break;
      case '꼬끼오': assetAudioPath = 'assets/audio_6.mp3'; break;
      case '귀뚜라미': assetAudioPath = 'assets/audio_7.mp3'; break;
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volumeMax: false,
      // volumeMax,
      notificationTitle: showNotification ? '알람' : null,
      notificationBody: showNotification ? '일어나세요!' : null,
      assetAudioPath: assetAudioPath,
      stopOnNotificationOpen: false,
    );
    return alarmSettings;
  }

  AlarmSettings buildAlarmSettingsList() {
    final now = DateTime.now();

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

    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 100000
        : widget.alarmSettings!.id;

    /// 월(1), 화(2), 수(3), 목(4), 금(5), 토(6), 일(7)
    for (int i = 0; i < loopDayList.length; i++) {
      if (loopDayList[i]) {

      }
    }

    if (dateTime.weekday == 1) {

    }

    String assetAudioPath = '';

    switch(assetAudio) {
      case '삐삐삐(보통)': assetAudioPath = 'assets/audio_1.mp3'; break;
      case '삐삐삐(빠르게)': assetAudioPath = 'assets/audio_2.mp3'; break;
      case '레인보우': assetAudioPath = 'assets/audio_3.mp3'; break;
      case '따르릉': assetAudioPath = 'assets/audio_4.mp3';  break;
      case 'ringtone': assetAudioPath = 'assets/audio_5.mp3'; break;
      case '꼬끼오': assetAudioPath = 'assets/audio_6.mp3'; break;
      case '귀뚜라미': assetAudioPath = 'assets/audio_7.mp3'; break;
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volumeMax: false,
      // volumeMax,
      notificationTitle: showNotification ? '알람' : null,
      notificationBody: showNotification ? '일어나세요!' : null,
      assetAudioPath: assetAudioPath,
      stopOnNotificationOpen: false,
    );
    return alarmSettings;
  }

  void saveAlarm() async {
    setState(() => loading = true);
    final prefs = await SharedPreferences.getInstance();

    /// alarm 패키지가 볼륨설정 지원을 안하므로 기기에 볼륨 저장하고 알람이 울릴 때 해당 볼륨으로 변경
    prefs.setDouble('volume', volume);

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
      mode: widget.mode,
      creating: creating,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volumeMax: volumeMax,
      showNotification: showNotification,
      assetAudio: assetAudio,
      loading: loading,
      alarmSettings: widget.alarmSettings,
      selectedTime: selectedTime,
        loopDayList: loopDayList,
      saveAlarm: () => saveAlarm(),
      isToday: () => isToday(),
      pickTime: () => pickTime(),
      deleteAlarm: () => deleteAlarm(),
      onChangeAudio: (value) => onChangeAudio(value),
      onChangeLoopAudio: (value) => onChangeLoopAudio(value),
      onChangeVibrate: (value) => onChangeVibrate(value),
      onChangeVolumeMax: (value) => onChangeVolumeMax(value),
      onChangeShowNotification: (value) => onChangeShowNotification(value),
        onTapLoopday: (index) => onTapLoopday(index),
    );
  }

  void onChangeAudio(value) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, bottomState) {
            return SimplePopupDialog(
              audioPlayer: audioPlayer,
              title: 'SOUND',
              content: assetAudioList,
              selectedAudio: assetAudio,
              volume: volume,
              vibrate: vibrate,
              onChangeAudio: (asset) => _onChangeAudio(asset, bottomState),
              onChangeVibrate: (value) => _onChangeVibrate(value, bottomState),
              onChangeVolume: (value) => _onChangeVolume(value, bottomState),
            );
          });
        });

    if (audioPlayer.state == PlayerState.playing) {
      audioPlayer.pause();
    }
  }

  void _onChangeAudio(asset, bottomState) {
    bottomState(() => assetAudio = asset!);

    if (audioPlayer.state == PlayerState.playing) {
      audioPlayer.pause();
    }

    String assetAudioPath = '';

    switch(assetAudio) {
      case '삐삐삐(보통)': assetAudioPath = 'audio_1.mp3'; break;
      case '삐삐삐(빠르게)': assetAudioPath = 'audio_2.mp3'; break;
      case '레인보우': assetAudioPath = 'audio_3.mp3'; break;
      case '따르릉': assetAudioPath = 'audio_4.mp3';  break;
      case 'ringtone': assetAudioPath = 'audio_5.mp3'; break;
      case '꼬끼오': assetAudioPath = 'audio_6.mp3'; break;
      case '귀뚜라미': assetAudioPath = 'audio_7.mp3'; break;
    }

    audioPlayer.play(AssetSource(assetAudioPath));
    /// 팝업 닫지 않음
    // Get.back();
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

  void _onChangeVolume(value, bottomState) {
    bottomState(() {
      volumeController.setVolume(value);
      volume = value;
    });
  }

  void _onChangeVibrate(value, bottomState) {
    bottomState(() => vibrate = value);
  }

  void onTapLoopday(int weekday) {
    setState(() {
      loopDayList[weekday] = !loopDayList[weekday];
    });
  }
}
