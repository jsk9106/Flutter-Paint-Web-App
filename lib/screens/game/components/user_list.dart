import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/controllers/game_controller.dart';
import 'package:flutter_paint_web_app/global/global_data.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../models/user.dart';
import '../../../responsive.dart';

class UserList extends StatelessWidget {
  UserList({Key? key}) : super(key: key);

  final GameController controller = Get.find<GameController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('room').doc(controller.room.id).collection('users').orderBy('joinAt').limit(6).snapshots(),
      builder: (context, snapshot) {
        debugPrint('room -> users Listen!');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: kColorOrange),
          );
        }

        final List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];
        if (docs.isNotEmpty) controller.setUserList(docs); // 유저 리스트 세팅

        return ListView.builder(
          scrollDirection: Responsive.isMobile(context) ? Axis.horizontal : Axis.vertical,
          itemCount: controller.userList.length,
          itemBuilder: (context, index) => UserCard(user: controller.userList[index]),
        );
      },
    );
  }
}

class UserCard extends StatelessWidget {
  UserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;
  final GameController controller = Get.find<GameController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? defaultPadding / 2 : defaultPadding, vertical: defaultPadding / 2),
          width: Responsive.isMobile(context) ? 60 : double.infinity,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: kColorGray),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            user.nickName,
            style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white, fontSize: Responsive.isMobile(context) ? 16 : null),
          ),
        ),
        if (user.id == GlobalData.loggedInUser.id) ...[
          Positioned(
            top: Responsive.isMobile(context) ? 16 : 20,
            right: Responsive.isMobile(context) ? 16 : 30,
            child: Container(
              width: Responsive.isMobile(context) ? 14 : 20,
              height: Responsive.isMobile(context) ? 14 : 20,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Text(
                '나',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: Responsive.isMobile(context) ? 10 : null,
                      height: Responsive.isMobile(context) ? 1.2 : null,
                    ),
              ),
            ),
          ),
        ],
        if (user.id == controller.room.turn) ...[
          Positioned(
            top: Responsive.isMobile(context) ? 16 : 20,
            left: Responsive.isMobile(context) ? 16 : 30,
            child: Icon(
              Icons.check_circle,
              size: Responsive.isMobile(context) ? 16 : 22,
              color: kColorOrange,
            ),
          ),
        ],
      ],
    );
  }
}

class WrongAnswerWidget extends StatelessWidget {
  const WrongAnswerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        color: kColorOrange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            GameController.to.room.wrongAnswer!['answer'],
            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: Responsive.isMobile(context) ? 16 : 20),
          ),
          const SizedBox(height: 2),
          Text(
            '- ${GameController.to.getUserNickByID(GameController.to.room.wrongAnswer!['id'])} -',
            style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white, fontSize: Responsive.isMobile(context) ? 12 : 16),
          ),
        ],
      ),
    );
  }
}
