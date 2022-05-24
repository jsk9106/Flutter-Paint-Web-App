import 'package:flutter_paint_web_app/global/global_data.dart';
import 'package:flutter_paint_web_app/global/global_fuction.dart';
import 'package:flutter_paint_web_app/repository/database.dart';
import 'package:flutter_paint_web_app/screens/room_list/room_list_screen.dart';
import 'package:get/get.dart';

import '../models/user.dart';

class LoginController extends GetxController {
  // 유저 생성
  void createUser(String nickName) async{
    GlobalFunction.showLoading();

    User? user = await Database.createUser(nickName);

    if(user != null) {
      GlobalData.loggedInUser = user;
    } else {
      Get.snackbar('에러', '로그인 실패! 다시 시도해주세요');
    }

    Get.back(); // 로딩 끄기
    Get.offAll(() => const RoomListScreen());
  }
}