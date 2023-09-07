import 'package:flutter/material.dart';
import 'package:timeline/_importer.dart';

class ExampleAlarmTile extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final void Function()? onDismissed;

  const ExampleAlarmTile({
    Key? key,
    required this.title,
    required this.onPressed,
    this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: onDismissed != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        child: const Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDismissed?.call(),
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Container(
          alignment: Alignment.center,
          // height: 100,
          padding: const EdgeInsets.all(35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Pretendard',
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0,0),
                      blurRadius: 13,
                      color: Colors.black.withOpacity(0.14),
                    )
                  ]
                ),
              ),
              // const Icon(Icons.keyboard_arrow_right_rounded, size: 35),
            ],
          ),
        ),
      ),
    );
  }
}