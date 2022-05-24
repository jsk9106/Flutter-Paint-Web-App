import 'package:flutter/material.dart';

// class DotInfo {
//   DotInfo({
//     required this.offset,
//     required this.size,
//     required this.color,
//   });
//
//   final Offset offset;
//   final double size;
//   final Color color;
// }

class Line {
  Line({
    this.id = '',
    this.size = 0,
    this.colorIdx = 0,
    this.dotInfoList = const [],
  });

  String id;
  final double size;
  final int colorIdx;
  final List<Offset> dotInfoList;

  factory Line.fromJson(Map<String, dynamic> json) => Line(
        id: json['id'] ?? '',
        size: json['size'].toDouble(),
        colorIdx: json['colorIdx'] ?? 0,
        dotInfoList: json['dotInfoList'] == null ? [] : (json['dotInfoList'] as List).map((e) => Offset(e['dx'].toDouble(), e['dy'].toDouble())).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'size': size,
        'colorIdx': colorIdx,
        'dotInfoList': dotInfoList.map((e) => {'dx': e.dx, 'dy': e.dy}).toList(),
        'createdAt': DateTime.now(),
      };
}
