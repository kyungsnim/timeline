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
  static const AdRequest request = AdRequest(
    keywords: <String>['alarm, miracle'],
    nonPersonalizedAds: true,
  );

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
    'marimba',
    'mozart',
    'nokia',
    'one_piece',
    'star_wars',
  ];

  VolumeController volumeController = VolumeController();
  AudioPlayer audioPlayer = AudioPlayer();
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

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
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
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
      assetAudio = 'marimba';
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
      assetAudio = widget.alarmSettings!.assetAudioPath
          .replaceAll('assets/', '')
          .replaceAll('.mp3', '');
    }
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
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

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volumeMax: false,
      // volumeMax,
      notificationTitle: showNotification ? '알람' : null,
      notificationBody: showNotification ? '일어나세요!' : null,
      assetAudioPath: 'assets/$assetAudio.mp3',
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
      _showInterstitialAd();
      if (res) Get.back(result: true);
    });
    setState(() => loading = false);
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
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
    audioPlayer.play(AssetSource('$assetAudio.mp3'));
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
}
