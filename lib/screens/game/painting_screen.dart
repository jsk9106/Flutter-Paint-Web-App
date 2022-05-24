import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/controllers/game_controller.dart';

import '../../constants.dart';
import '../components/canvas_widget.dart';

class PaintingScreen extends StatelessWidget {
  const PaintingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: CanvasWidget(),
        ),
        PaintingGestureWidget(),
        Positioned(
          bottom: defaultPadding,
          child: Text(
            GameController.to.room.answerIdxList.isNotEmpty ? '\'${answerList[GameController.to.room.answerIdxList.last]}\' 을 그려주세요' : '',
            style: Theme.of(context).textTheme.headline4!.copyWith(color: kColorGray),
          ),
        ),
      ],
    );
  }
}
