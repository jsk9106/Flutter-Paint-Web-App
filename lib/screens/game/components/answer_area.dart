import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/controllers/game_controller.dart';

import '../../../constants.dart';

class AnswerArea extends StatelessWidget {
  const AnswerArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnswerTextField(),
      ],
    );
  }
}

class AnswerTextField extends StatelessWidget {
  AnswerTextField({
    Key? key,
  }) : super(key: key);

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: textEditingController,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
        cursorColor: kColorGray,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: '정답',
          hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: kColorGray),
          contentPadding: const EdgeInsets.all(defaultPadding / 2),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kColorGray),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kColorGray),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onSubmitted: (value) {
          textEditingController.clear();
          GameController.to.submitAnswer(value);
        },
      ),
    );
  }
}
