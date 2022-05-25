import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/constants.dart';
import 'package:flutter_paint_web_app/controllers/game_controller.dart';
import 'package:flutter_paint_web_app/global/global_fuction.dart';
import 'package:flutter_paint_web_app/responsive.dart';
import 'package:flutter_paint_web_app/screens/game/painting_screen.dart';
import 'package:get/get.dart';

import '../../controllers/paint_controller.dart';
import '../../models/room.dart';
import '../components/palette.dart';
import 'components/user_list.dart';
import 'show_screen.dart';

// git test02 merge
class GameScreen extends StatelessWidget {
  GameScreen({Key? key, required this.room}) : super(key: key);

  final Room room;
  final GameController controller = Get.put(GameController());
  final PaintController paintController = Get.put(PaintController());
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _key,
      endDrawer: !Responsive.isMobile(context) ? null : Palette(),
      appBar: customAppBar(context),
      body: GestureDetector(
        onTap: () => GlobalFunction.unFocus(context),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('room').doc(room.id).snapshots(),
            builder: (context, snapshot) {
              debugPrint('room Listen!');
              if (snapshot.data != null) controller.setRoom(snapshot.data!.data()!);

              return Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (!Responsive.isMobile(context)) ...[
                          Expanded(
                            flex: 2,
                            child: UserList(),
                          ),
                          Container(width: 2, height: size.height, color: kColorGray),
                        ],
                        Expanded(
                          flex: 6,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if(controller.room.gameState == GameState.play)...[
                                controller.isMyTurn
                                    ? const PaintingScreen()
                                    : ShowScreen()
                              ] else...[
                                Center(
                                  child: Text(
                                    controller.room.answerIdxList.length > 1
                                        ? '정답은 ${answerList[controller.room.answerIdxList[controller.room.answerIdxList.length - 2]]}\n${controller.room.correctAnswer}님 정답!'
                                        : '',
                                    style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                              if (controller.room.wrongAnswer != null) ...[
                                Obx(
                                  () => controller.showWrongAnswer.value
                                      ? const Positioned(
                                          top: 10,
                                          child: WrongAnswerWidget(),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (!Responsive.isMobile(context)) ...[
                          Expanded(
                            flex: 2,
                            child: Palette(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (Responsive.isMobile(context)) ...[
                    Container(
                      width: double.infinity,
                      height: 60,
                      color: kColorDark,
                      child: UserList(),
                    ),
                  ],
                ],
              );
            }),
      ),
    );
  }

  AppBar customAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kColorDark,
      centerTitle: true,
      elevation: 0,
      title: Text(
        room.title,
        style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      actions: [
        !Responsive.isMobile(context)
            ? const SizedBox.shrink()
            : IconButton(
                onPressed: () => _key.currentState!.openEndDrawer(),
                icon: const Icon(Icons.menu),
              )
      ],
    );
  }
}
