import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/models/line.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../repository/database.dart';
import 'game_controller.dart';

class PaintController extends GetxController {
  static get to => Get.find<PaintController>();

  List<Line> lines = [];
  RxDouble size = 3.0.obs;
  RxBool eraseMode = false.obs;
  RxInt colorIdx = 0.obs;
  String deletedLindID = '';

  void changeColor(int index, Color c) {
    colorIdx(index);
  }
  
  void changeEraseMode(bool mode){
    eraseMode(mode);
  }

  void drawStart(Offset offset){
    Line oneLine = Line();

    oneLine = Line(size: size.value, colorIdx: colorIdx.value, dotInfoList: [offset]);
    lines.add(oneLine);
    update();
  }

  void drawing(Offset offset){
    lines.last.dotInfoList.add(offset);
    update();
  }

  void erase(Offset offset) async{
    const double eraseGap = 15;

    for(Line oneLine in List<Line>.from(lines)){
      for(Offset oneDot in oneLine.dotInfoList) {
        if(sqrt(pow((offset.dx - oneDot.dx), 2) + pow((offset.dy - oneDot.dy), 2)) < eraseGap){
            lines.remove(oneLine);
            deletedLindID = oneLine.id; // 삭제된 아이디

            bool result = await Database.deleteLine(GameController.to.room.id, deletedLindID);
            if(!result) Get.snackbar('error', '통신 장애!');
            break;
          }
      }
    }

    update();
  }

  void createLine() async{
    final String? result = await Database.createLine(GameController.to.room.id, lines.last);

    if(result != null) {
      lines.last.id = result;
    } else {
      Get.snackbar('error', '통신 장애!');
    }
  }

  // 내 턴이 아닐 때 라인 삭제 이벤트
  void deleteLine(){
    lines.removeWhere((element) => element.id == deletedLindID);
  }

}