import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class EditAlarmView extends StatelessWidget {
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

  EditAlarmView({
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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      "Cancel",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.blueAccent),
                    ),
                  ),
                  TextButton(
                    onPressed: () => saveAlarm(),
                    child: loading
                        ? const CircularProgressIndicator()
                        : Text(
                      "Save",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
              Text(
                '${isToday() ? 'Today' : 'Tomorrow'} at',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.blueAccent.withOpacity(0.8)),
              ),
              RawMaterialButton(
                onPressed: () => pickTime(),
                fillColor: Colors.grey[200],
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Text(
                    selectedTime.format(context),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: Colors.blueAccent),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Loop alarm audio',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch(
                    value: loopAudio,
                    onChanged: (value) => onChangeLoopAudio(value),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vibrate',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch(
                    value: vibrate,
                    onChanged: (value) => onChangeVibrate(value),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'System volume max',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch(
                    value: volumeMax,
                    onChanged: (value) => onChangeVolumeMax(value),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Show notification',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch(
                    value: showNotification,
                    onChanged: (value) => onChangeShowNotification(value),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sound',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  DropdownButton(
                    value: assetAudio,
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'assets/marimba.mp3',
                        child: Text('Marimba'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'assets/nokia.mp3',
                        child: Text('Nokia'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'assets/mozart.mp3',
                        child: Text('Mozart'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'assets/star_wars.mp3',
                        child: Text('Star Wars'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'assets/one_piece.mp3',
                        child: Text('One Piece'),
                      ),
                    ],
                    onChanged: (value) => onChangeAudio(value!),
                  ),
                ],
              ),
              if (!creating)
                TextButton(
                  onPressed: () => deleteAlarm(),
                  child: Text(
                    'Delete Alarm',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.red),
                  ),
                ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
