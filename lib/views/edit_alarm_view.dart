import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: mode == 'edit' ? backgroundColor.withOpacity(0.85) : backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mode == 'edit' ? '알람 수정' : '알람 맞추기',
                style: const TextStyle(
                  color: textColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 50),
              Text(
                isToday() ? '오늘' : '내일',
                style: const TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 20),
              RawMaterialButton(
                onPressed: () => pickTime(),
                fillColor: Colors.grey[200],
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Text(
                    selectedTime.format(context),
                    style: const TextStyle(
                      color: backgroundColor,
                      fontFamily: 'Pretendard',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '사운드',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    child: DropdownButton(
                      value: assetAudio,
                      underline: SizedBox(),
                      items: [
                        _buildDropdownItem('assets/marimba.mp3', 'Marimba'),
                        _buildDropdownItem('assets/nokia.mp3', 'Nokia'),
                        _buildDropdownItem('assets/mozart.mp3', 'Mozart'),
                        _buildDropdownItem('assets/star_wars.mp3', 'Star Wars'),
                        _buildDropdownItem('assets/one_piece.mp3', 'One Piece'),
                      ],
                      onChanged: (value) => onChangeAudio(value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, false),
                      child: Container(
                        width: 140,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                        width: 140,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: gradientButtonColor,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 29,
                                spreadRadius: 3,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ]),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        child: Text(
                          mode == 'edit' ? '알람 수정' : '알람 설정',
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
              const SizedBox(height: 30),
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
              const SizedBox(),
            ],
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
          color: Colors.grey,
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
