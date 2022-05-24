import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/constants.dart';

import '../../models/room.dart';
import 'components/room_item.dart';

class RoomListScreen extends StatelessWidget {
  const RoomListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: defaultPadding * 2),
          Text(
            '방 리스트',
            style: Theme.of(context).textTheme.headline4!.copyWith(color: kColorGray),
          ),
          const SizedBox(height: defaultPadding),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('room').snapshots(),
              builder: (context, snapshot) {
                final List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kColorOrange),
                  );
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) => RoomItem(
                    room: Room.fromJson(docs[index].data() as Map<String, dynamic>),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
