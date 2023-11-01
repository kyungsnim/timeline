import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline/_importer.dart';

class EditAlarmView extends StatelessWidget {
  String? mode;
  late bool creating;
  late bool loopAudio;
  late bool vibrate;
  late bool volumeMax;
  late bool showNotification;
  late String assetAudio;
  bool loading;
  late TimeOfDay selectedTime;
  final List<bool> loopDayList;
  Function isToday;
  Function saveAlarm;
  Function pickTime;
  Function onChangeAudio;
  Function onChangeLoopAudio;
  Function onChangeVibrate;
  Function onChangeVolumeMax;
  Function onChangeShowNotification;
  Function deleteAlarm;
  final Function onTapLoopday;

  EditAlarmView(
      {this.mode,
      required this.creating,
      required this.loopAudio,
      required this.vibrate,
      required this.volumeMax,
      required this.showNotification,
      required this.assetAudio,
      required this.loading,
      required this.selectedTime,
      required this.isToday,
      required this.saveAlarm,
      required this.pickTime,
      required this.loopDayList,
      required this.onChangeAudio,
      required this.onChangeLoopAudio,
      required this.onChangeVibrate,
      required this.onChangeVolumeMax,
      required this.onChangeShowNotification,
      required this.deleteAlarm,
      required this.onTapLoopday,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          mode == 'edit' ? backgroundColor.withOpacity(0.85) : backgroundColor,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/img_background.png',
            width: Get.width,
            height: Get.height,
            fit: BoxFit.fill,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'MIRACLE MORNING ALARM',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 100),
                  Text(
                    isToday() ? '오늘' : '내일',
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Pretendard',
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 0),
                            blurRadius: 13,
                            color: Colors.black.withOpacity(0.14),
                          )
                        ]),
                  ),
                  const SizedBox(height: 10),
                  RawMaterialButton(
                    onPressed: () => pickTime(),
                    child: Container(
                      child: Text(
                        selectedTime.format(context),
                        style: TextStyle(
                          color: whiteColor,
                          fontFamily: 'Pretendard',
                          fontSize: 48,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 0),
                              blurRadius: 13,
                              color: Colors.black.withOpacity(0.14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 12),
                    child: Row(
                      children: [
                        buildTitleText('소리'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onChangeAudio('1'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white,
                          ),
                          color: Colors.white.withOpacity(0.2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/ic_music.png',
                              width: 24, height: 24),
                          const SizedBox(width: 10),
                          const Text(
                            'SOUND',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            assetAudio,
                            style: const TextStyle(
                              color: whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 12),
                    child: Row(
                      children: [
                        buildTitleText('반복'),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white,
                        ),
                        color: Colors.white.withOpacity(0.2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildWeekdayText('일', 0),
                        const SizedBox(width: 6),
                        buildWeekdayText('월', 1),
                        const SizedBox(width: 6),
                        buildWeekdayText('화', 2),
                        const SizedBox(width: 6),
                        buildWeekdayText('수', 3),
                        const SizedBox(width: 6),
                        buildWeekdayText('목', 4),
                        const SizedBox(width: 6),
                        buildWeekdayText('금', 5),
                        const SizedBox(width: 6),
                        buildWeekdayText('토', 6),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context, false),
                          child: Container(
                            // width: 140,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: mainButtonColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 55, vertical: 12),
                            child: const Text(
                              '취소',
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => saveAlarm(),
                          child: Container(
                            // width: 140,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: whiteColor),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 55, vertical: 12),
                            child: Text(
                              mode == 'edit' ? '수정' : '완료',
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (!creating)
                    TextButton(
                      onPressed: () => deleteAlarm(),
                      child: const Text(
                        '알람 삭제',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Pretendard',
                          shadows: [
                            Shadow(
                              offset: Offset(0,0),
                              blurRadius: 10,
                              color: Colors.black38
                            )
                          ]
                        ),
                      ),
                    ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitleText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: whiteColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontFamily: 'Pretendard',
        ),
      ),
    );
  }

  Widget buildWeekdayText(String text, int weekday) {

    return GestureDetector(
      onTap: () => onTapLoopday(weekday),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white,),
          color: loopDayList[weekday] ? Colors.pinkAccent.withOpacity(0.5) : Colors.white.withOpacity(0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Text(
          text,
          style: const TextStyle(
            color: whiteColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String path, String text) {
    return DropdownMenuItem<String>(
      value: path,
      child: Text(
        text,
        style: const TextStyle(
          color: textColor,
          fontSize: 20,
          fontFamily: 'Pretendard',
        ),
      ),
    );
  }
}

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Text(
//       'Loop alarm audio',
//       style: Theme.of(context).textTheme.titleMedium,
//     ),
//     Switch(
//       value: loopAudio,
//       onChanged: (value) => onChangeLoopAudio(value),
//     ),
//   ],
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Text(
//       'Vibrate',
//       style: Theme.of(context).textTheme.titleMedium,
//     ),
//     Switch(
//       value: vibrate,
//       onChanged: (value) => onChangeVibrate(value),
//     ),
//   ],
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Text(
//       'System volume max',
//       style: Theme.of(context).textTheme.titleMedium,
//     ),
//     Switch(
//       value: volumeMax,
//       onChanged: (value) => onChangeVolumeMax(value),
//     ),
//   ],
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Text(
//       'Show notification',
//       style: Theme.of(context).textTheme.titleMedium,
//     ),
//     Switch(
//       value: showNotification,
//       onChanged: (value) => onChangeShowNotification(value),
//     ),
//   ],
// ),
