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
  final AlarmSettings? alarmSettings;
  late TimeOfDay selectedTime;
  Function isToday;
  Function saveAlarm;
  Function pickTime;
  Function onChangeAudio;
  Function onChangeLoopAudio;
  Function onChangeVibrate;
  Function onChangeVolumeMax;
  Function onChangeShowNotification;
  Function deleteAlarm;

  EditAlarmView(
      {this.mode,
      required this.creating,
      required this.loopAudio,
      required this.vibrate,
      required this.volumeMax,
      required this.showNotification,
      required this.assetAudio,
      required this.loading,
      required this.alarmSettings,
      required this.selectedTime,
      required this.isToday,
      required this.saveAlarm,
      required this.pickTime,
      required this.onChangeAudio,
      required this.onChangeLoopAudio,
      required this.onChangeVibrate,
      required this.onChangeVolumeMax,
      required this.onChangeShowNotification,
      required this.deleteAlarm,
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
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Nats',
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
                  RawMaterialButton(
                    onPressed: () => pickTime(),
                    child: Container(
                      child: Text(
                        selectedTime.format(context),
                        style: TextStyle(
                          color: whiteColor,
                          fontFamily: 'Nats',
                          fontSize: 64,
                          fontWeight: FontWeight.w400,
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
                          // DropdownButton(
                          //   icon: Icon(
                          //     Icons.arrow_drop_down,
                          //     color: Colors.white,
                          //   ),
                          //   style: const TextStyle(
                          //     color: whiteColor,
                          //   ),
                          //   value: assetAudio,
                          //   underline: SizedBox(),
                          //   items: [
                          //     _buildDropdownItem('assets/marimba.mp3', 'Marimba'),
                          //     _buildDropdownItem('assets/nokia.mp3', 'Nokia'),
                          //     _buildDropdownItem('assets/mozart.mp3', 'Mozart'),
                          //     _buildDropdownItem(
                          //         'assets/star_wars.mp3', 'Star Wars'),
                          //     _buildDropdownItem(
                          //         'assets/one_piece.mp3', 'One Piece'),
                          //   ],
                          //   onChanged: (value) => onChangeAudio(value!),
                          // ),
                        ],
                      ),
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
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontFamily: 'Pretendard',
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
