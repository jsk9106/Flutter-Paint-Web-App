import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/global/global_fuction.dart';
import 'package:flutter_paint_web_app/repository/database.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../models/room.dart';
import '../../game/game_screen.dart';

class RoomItem extends StatelessWidget {
  const RoomItem({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: defaultPadding, horizontal: size.width * 0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async{
          GlobalFunction.showLoading();
          Room? result = await Database.joinRoom(room);
          Get.back(); // 로딩 끄기

          if(result != null) {
            Get.to(() => GameScreen(room: room));
          } else {
            Get.snackbar('error', '잠시후 다시 시도해주세요');
          }

        },
        child: Container(
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: kColorGray),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            room.title,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}