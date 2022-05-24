import 'package:flutter_paint_web_app/models/user.dart';

enum GameState { play, ready }

class Room {
  Room({
    this.id = '',
    this.title = '',
    this.correctAnswer = '',
    this.turn = '',
    this.gameState = GameState.play,
    this.answerIdxList = const [],
    this.wrongAnswer,
    // this.users = const [],
    // this.lines = const [],
  });

  final String id;
  final String title;
  final List<int> answerIdxList;
  final String correctAnswer;
  String turn;
  GameState gameState;
  Map<String, dynamic>? wrongAnswer;
  // List<User> users;
  // final List<Line> lines;

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      turn: json['turn'] ?? '',
      gameState: GameState.values[json['gameState']],
      answerIdxList: json['answerIdxList'] == null ? [] : (json['answerIdxList'] as List).map((e) => int.parse(e.toString())).toList(),
      wrongAnswer: json['wrongAnswer'],
      // lines: json['lines'] == null ? [] : (json['lines'] as List).map((e) => Line.fromJson(e)).toList(),
      // users: json['users'] == null ? [] : (json['users'] as List).map((e) => User.fromJson(e)).toList(),
    );
  }
}
