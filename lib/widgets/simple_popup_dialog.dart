import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimplePopupDialog extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final String title;
  final List<String> content;
  final String selectedAudio;
  final Function onChangeAudio;
  final double volume;
  final bool vibrate;
  final Function onChangeVibrate;
  final Function onChangeVolume;

  const SimplePopupDialog({
    Key? key,
    required this.audioPlayer,
    required this.title,
    required this.content,
    required this.selectedAudio,
    required this.volume,
    required this.vibrate,
    required this.onChangeVolume,
    required this.onChangeVibrate,
    required this.onChangeAudio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ic_music.png',
              width: 24,
            ),
            const SizedBox(height: 10),
            Text(
              '볼륨버튼으로 소리를 조절하세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 0),
                      blurRadius: 5,
                      color: Colors.white.withOpacity(0.5),
                    )
                  ]),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFFFFFF),
                ),
                color: const Color(0xB2FFFFFF),
              ),
              width: 250,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          if (audioPlayer.state == PlayerState.playing) {
                            audioPlayer.pause();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Icon(
                            Icons.clear,
                            color: Colors.black.withOpacity(0.5),
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // title
                  Text(
                    title ?? "",
                    // style: MidTextStyles.title1Bold.apply(color: MidColors.baseFontBlack40),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.20,
                    ),
                  ),
                  SizedBox(height: 20),
                  // content
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => onChangeAudio(content[index]),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            color: selectedAudio == content[index]
                                ? Colors.white.withOpacity(0.4)
                                : Colors.white.withOpacity(0),
                            child: Text(
                              content[index],
                              style: const TextStyle(
                                color: Color(0xFF444444),
                                fontSize: 18,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/volume_up.png',
                  width: 20,
                ),
                SliderTheme(
                  data: SliderThemeData(
                    // thumbShape: SliderComponentShape.,
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(
                    activeColor: Color(0xFF9391B7),
                    inactiveColor: Colors.white,
                    thumbColor: Colors.white,
                    value: volume,
                    min: 0,
                    max: 1,
                    onChanged: (value) => onChangeVolume(value),
                  ),
                ),
                Image.asset(
                  'assets/images/edgesensor_high.png',
                  width: 20,
                ),
                Transform.scale(
                  transformHitTests: false,
                  scale: 0.8,
                  child: CupertinoSwitch(
                      activeColor: Color(0xFF9391B7),
                      trackColor: Color(0xFFB7B7B7),
                      value: vibrate,
                      onChanged: (newValue) => onChangeVibrate(newValue)),
                ),
              ],
            )
          ],
        ));
  }
}
