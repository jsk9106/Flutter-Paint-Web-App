import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/constants.dart';
import 'package:flutter_paint_web_app/controllers/login_controller.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginController controller = Get.put(LoginController());
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter Catch Mind',
              style: Theme.of(context).textTheme.headline3!.copyWith(color: kColorGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: defaultPadding * 2),
            nickNameTextField(context, size),
            const SizedBox(height: defaultPadding * 2),
            loginButton(size, context),
          ],
        ),
      ),
    );
  }

  Widget loginButton(Size size, BuildContext context) {
    return InkWell(
      onTap: () => controller.createUser(textEditingController.text),
      child: Container(
        width: size.width * 0.5,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: kColorOrange, borderRadius: BorderRadius.circular(10)),
        child: Text(
          '로그인',
          style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  SizedBox nickNameTextField(BuildContext context, Size size) {
    return SizedBox(
      width: size.width * 0.5,
      child: TextField(
        controller: textEditingController,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
        cursorColor: kColorGray,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: '닉네임',
          hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: kColorGray),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kColorGray),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kColorGray),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
