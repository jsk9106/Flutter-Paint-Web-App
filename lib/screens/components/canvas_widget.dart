import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/controllers/paint_controller.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../models/line.dart';

class CanvasWidget extends StatelessWidget {
  CanvasWidget({Key? key}) : super(key: key);
  final PaintController controller = Get.find<PaintController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaintController>(
      builder: (_) => CustomPaint(
        painter: DrawingPainter(controller.lines),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.lines);

  final List<Line> lines;

  @override
  void paint(Canvas canvas, Size size) {
    for (Line oneLine in lines) {
      Color color = paletteColorList[oneLine.colorIdx];
      double size = oneLine.size;
      var l = <Offset>[];
      var p = Path();
      for (Offset oneDot in oneLine.dotInfoList) {
        l.add(oneDot);
      }
      p.addPolygon(l, false);
      canvas.drawPath(
        p,
        Paint()
          ..color = color
          ..strokeWidth = size
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PaintingGestureWidget extends StatelessWidget {
  PaintingGestureWidget({Key? key}) : super(key: key);
  final PaintController controller = Get.find<PaintController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (s) {
        if (controller.eraseMode.value) {
          controller.erase(s.localPosition);
        } else {
          controller.drawStart(s.localPosition);
        }
      },
      onPanUpdate: (s) {
        if (controller.eraseMode.value) {
          controller.erase(s.localPosition);
        } else {
          controller.drawing(s.localPosition);
        }
      },
      onPanEnd: (s) {
        if(!controller.eraseMode.value) controller.createLine();
      },
      child: Container(),
    );
  }
}
