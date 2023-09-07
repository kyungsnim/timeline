import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timeline/_importer.dart';
import 'package:timeline/screens/home.dart';

const Map<String, String> UNIT_ID = kReleaseMode
    ? {
  'ios': 'ca-app-pub-1738707641643524~1765207573',
  'android': 'ca-app-pub-1738707641643524~8330615921',
}
    : {
  'ios': 'ca-app-pub-3940256099942544/2934735716',
  'android': 'ca-app-pub-3940256099942544/6300978111',
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  MobileAds.instance.initialize();

  await Alarm.init(showDebugLogs: true);
  runApp(const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePresenter()));
}