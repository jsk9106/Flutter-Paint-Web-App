import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_paint_web_app/constants.dart';
import 'package:flutter_paint_web_app/controllers/paint_controller.dart';
import 'package:flutter_paint_web_app/global/global_data.dart';
import 'package:flutter_paint_web_app/repository/database.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../models/room.dart';
import '../models/user.dart';

class GameController extends GetxController {
  static get to => Get.find<GameController>();

  Room room = Room(id: 'sdf');
  List<User> userList = [];
  GameState gameState = GameState.play;
  RxBool showWrongAnswer = false.obs;

  bool get isMyTurn => room.turn == GlobalData.loggedInUser.id;

  @override
  void onClose() {
    // 마지막 유저인 경우
    if (userList.length == 1) {
      Database.submitAnswer(roomID: room.id, json: {'answerIdxList': []}); // 정답 리스트 초기화
      Database.deleteLines(room.id); // lines 초기화
    }

    Database.deleteRoomUserByID(roomID: room.id, userID: GlobalData.loggedInUser.id); // 유저 삭제
    super.onClose();
  }

  void setRoom(Map<String, dynamic> roomJson) async {
    room = Room.fromJson(roomJson); // room 세팅

    if (room.answerIdxList.isEmpty) await setAnswerList(); // 정답 세팅

    // 게임이 ready 상태일 때
    if (room.gameState == GameState.ready) {
      checkGameState(); // state 체크해서 ready 가 지속되면 변경
    }

    // 오답 보여주기
    DateTime? wrongAnswerCreatedAt;

    if(room.wrongAnswer != null) {
      wrongAnswerCreatedAt = room.wrongAnswer!['createdAt'].toDate();

      if(DateTime.now().difference(wrongAnswerCreatedAt!).inSeconds <= 3) {
        showWrongAnswer(true);
        Future.delayed(const Duration(seconds: 3), () => showWrongAnswer(false));
      }
    }
  }

  // 유저 리스트 세팅
  void setUserList(List<QueryDocumentSnapshot> docs){
    userList = docs.map((e) => User.fromJson(e.data() as Map<String, dynamic>)).toList();

    // 첫번 째 유저인 경우
    if (userList.length == 1) setTurn(); // turn 세팅
  }

  // 정답 제출
  void submitAnswer(String value) async {
    final String answer = answerList[room.answerIdxList.last];

    // 정답이 맞을 경우
    if (value == answer) {
      PaintController.to.lines.clear(); // 그림 삭제

      // 다음 정답 처리
      int nextAnswerIdx = room.answerIdxList.last;
      while (room.answerIdxList.contains(nextAnswerIdx)) {
        nextAnswerIdx = Random().nextInt(answerList.length);
      }
      room.answerIdxList.add(nextAnswerIdx);

      // 다음 출제자 처리
      late String nextTurn;
      for(int i = 0; i < userList.length; i++) {
        final User user = userList[i];

        if(user.id == room.turn) {
          if(i == userList.length - 1) {
            nextTurn = userList[0].id;
            break;
          } else {
            nextTurn = userList[i + 1].id;
            break;
          }
        }
      }

      await Database.deleteLines(room.id); // lines 삭제

      final bool result = await Database.submitAnswer(
        roomID: room.id,
        json: {
          'gameState': GameState.ready.index,
          'answerIdxList': room.answerIdxList,
          'turn': nextTurn,
          'correctAnswer': GlobalData.loggedInUser.nickName,
        },
      );


      if (result) {
        changeStateToPlay(); // 5초 뒤에 게임 재게
      } else {
        Get.snackbar('error', '잠시후 다시 시도해주세요!');
      }
    } else {
      // 정답이 틀릴 경우 오답 세팅
      await Database.submitAnswer(
        roomID: room.id,
        json: {
          'wrongAnswer': {
            'answer': value,
            'id': GlobalData.loggedInUser.id,
            'createdAt': DateTime.now(),
          },
        },
      );
      
      showWrongAnswer(true); // 오답보여주기
    }
  }

  // turn 세팅
  void setTurn() {
    Database.submitAnswer(
      roomID: room.id,
      json: {'turn': GlobalData.loggedInUser.id},
    );
  }

  // answerList 세팅
  Future<void> setAnswerList() async {
    int randomIdx = Random().nextInt(answerList.length);

    room.answerIdxList.add(randomIdx);
    await Database.submitAnswer(
      roomID: room.id,
      json: {
        'answerIdxList': [randomIdx]
      },
    );
  }

  // 5초 뒤에 게임 재게
  void changeStateToPlay({int seconds = 5}) async {
    Future.delayed(
      Duration(seconds: seconds),
      () => Database.submitAnswer(
        roomID: room.id,
        json: {'gameState': GameState.play.index},
      ),
    );
  }

  // state 체크해서 ready 가 지속되면 변경
  void checkGameState() {
    if (userList.isEmpty) {
      changeStateToPlay(seconds: 0); // 유저가 나 혼자면 바로 게임 재게
    } else {
      // 내가 첫번째 유저이고, 6초가 지난 후에도 ready 상태이면 게임 재게
      if (GlobalData.loggedInUser.id == userList.first.id) {
        Future.delayed(const Duration(seconds: 6), () {
          if (room.gameState == GameState.ready) {
            changeStateToPlay(seconds: 0); // 게임 재게
          }
        });
      }
    }
  }

  String getUserNickByID(String id){
    for(User user in userList) {
      if(user.id == id) return user.nickName;
    }

    return '';
  }
}
