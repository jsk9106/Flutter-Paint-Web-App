import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/global/global_data.dart';
import 'package:flutter_paint_web_app/models/line.dart';
import 'package:flutter_paint_web_app/models/room.dart';
import 'package:flutter_paint_web_app/models/user.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _usersCollection = _firestore.collection('users');
final CollectionReference _roomCollection = _firestore.collection('room');

class Database{
  // 유저 생성
  static Future<User?> createUser(String nickName) async{
    try {
      final DocumentReference doc = _usersCollection.doc();
      final String id = doc.id;
      final Map<String, dynamic> json = {'id': id, 'nickName': nickName};
      await doc.set(json);
      return User.fromJson(json);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // 방 입장
  static Future<Room?> joinRoom(Room room) async{
    try {
      await _roomCollection.doc(room.id).collection('users').doc(GlobalData.loggedInUser.id).set(GlobalData.loggedInUser.toJson());
      return room;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // 라인 생성 (그릴 때)
  static Future<String?> createLine(String roomID, Line line) async{
    try {
      final DocumentReference doc = _roomCollection.doc(roomID).collection('lines').doc();
      final String id = doc.id;
      line.id = id;
      await doc.set(line.toJson());
      return id;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // 라인 전체 삭제 (턴 바뀔 때)
  static Future<bool> deleteLines(String roomID) async{
    debugPrint('///////////////////////??');
    try {
      final QuerySnapshot snapshot = await _roomCollection.doc(roomID).collection('lines').get();
      final batch = _firestore.batch();

      for(QueryDocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // 라인 삭제 (지우개용)
  static Future<bool> deleteLine(String roomID, String lineID) async{
    try {
      await _roomCollection.doc(roomID).collection('lines').doc(lineID).delete();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // 정답 제출
  static Future<bool> submitAnswer({required String roomID, required Map<String, dynamic> json}) async{
    try {
      await _roomCollection.doc(roomID).update(json);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // users collection 에서 삭제
  static Future<bool> deleteUserByID({required String userID}) async{
    try {
      await _usersCollection.doc(userID).delete();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // room -> users 에서 삭제
  static Future<bool> deleteRoomUserByID({required String roomID, required String userID}) async{
    try {
      await _roomCollection.doc(roomID).collection('users').doc(userID).delete();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

}