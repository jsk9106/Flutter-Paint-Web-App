import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/controllers/game_controller.dart';
import 'package:flutter_paint_web_app/controllers/paint_controller.dart';
import 'package:flutter_paint_web_app/models/line.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../components/canvas_widget.dart';
import 'components/answer_area.dart';

class ShowScreen extends StatelessWidget {
  ShowScreen({Key? key}) : super(key: key);

  final GameController gameController = Get.find<GameController>();
  final PaintController paintController = Get.find<PaintController>();
  final CollectionReference _lineCollection = FirebaseFirestore.instance.collection('room').doc(GameController.to.room.id).collection('lines');

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: StreamBuilder<QuerySnapshot>(
              stream: _lineCollection.snapshots(),
              builder: (context, snapshot) {
                debugPrint('room -> line Listen!');
                final List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];

                final List<Line> lines = docs.map((e) => Line.fromJson(e.data() as Map<String, dynamic>)).toList();
                paintController.lines = lines;

                return CustomPaint(
                  painter: DrawingPainter(paintController.lines),
                );
              }),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: defaultPadding,
          child: AnswerArea(),
        ),
      ],
    );
  }
}
