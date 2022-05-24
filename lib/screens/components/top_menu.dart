import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/constants.dart';

class TopMenu extends StatelessWidget {
  const TopMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      color: kColorDark,
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            color: kColorOrange,
            alignment: Alignment.center,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: kColorOrange,
                border: Border.all(color: Colors.white, width: 5),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
