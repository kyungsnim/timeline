import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timeline/_importer.dart';

class HomeView extends StatefulWidget {
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
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    if (_bannerAd != null) {
      _bannerAd!.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/img_background.png',
            width: Get.width,
            height: Get.height,
            fit: BoxFit.fill,
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  widget.alarms.isNotEmpty
                      ? const Column(
                          children: [
                            Text(
                              'WAKE UP TIME',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
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
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                  const Spacer(),
                  widget.alarms.isNotEmpty
                      ? ExampleAlarmTile(
                          key: Key(widget.alarms[0].id.toString()),
                          title: TimeOfDay(
                            hour: widget.alarms[0].dateTime.hour,
                            minute: widget.alarms[0].dateTime.minute,
                          ).format(context),
                          onPressed: () {},
                          onDismissed: () {
                            Alarm.stop(widget.alarms[0].id).then((_) => widget.loadAlarms());
                          },
                        )
                      : Text('설정된 알람이 없어요!',
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'PretendardBold',
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 0),
                                  blurRadius: 13,
                                  color: Colors.black.withOpacity(0.14),
                                )
                              ])),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => widget.alarms.isNotEmpty
                        ? widget.navigateToAlarmScreen(widget.alarms)
                        : widget.onTapSetAlarm(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 55, vertical: 12),
                      child: Text(widget.alarms.isNotEmpty ? '수정' : '알람 맞추기',
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Pretendard',
                          )),
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (_bannerAd != null)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
