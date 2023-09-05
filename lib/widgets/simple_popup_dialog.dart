import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimplePopupDialog extends StatelessWidget {
  final String title;
  final List<String> content;
  final String selectedAudio;
  final Function onChangeAudio;

  const SimplePopupDialog(
      {Key? key, required this.title, required this.content,
        required this.selectedAudio,
      required this.onChangeAudio,})
      : super(key: key);

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
                  ]
              ),
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
              width: 380,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                          child: Icon(Icons.clear,
                            color: Colors.black.withOpacity(0.5),
                            size: 30,),
                        ),
                      ),
                    ],
                  ),
                  // title
                  Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
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
                            color: selectedAudio == content[index] ? Colors.white.withOpacity(0.4)
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
          ],
        ));
  }
}
