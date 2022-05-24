import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/constants.dart';
import 'package:get/get.dart';

class GlobalFunction {
  static void showLoading() {
    Get.dialog(
      Material(
        color: Colors.black.withOpacity(0.2),
        child: const Center(
          child: CircularProgressIndicator(color: kColorOrange),
        ),
      ),
    );
  }

  //포커스 해제 함수
  static void unFocus(BuildContext context) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}
