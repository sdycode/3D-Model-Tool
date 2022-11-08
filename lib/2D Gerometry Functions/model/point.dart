import 'dart:convert';

import 'package:flutter/material.dart';

class Point {
  const Point({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;

  factory Point.fromJson(String str) => Point.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
  factory Point.fromOffset(Offset offset) {
    return Point(x: offset.dx, y: offset.dy);
  }
  factory Point.fromMap(Map<String, dynamic> json) => Point(
        x: json["x"] ?? 0,
        y: json["y"] ?? 0,
      );

  factory Point.fromPoint(Point p) => Point(x: p.x, y: p.y);
  static const Point zero = Point(x: 0, y: 0);
  Map<String, dynamic> toMap() => {
        "x": x,
        "y": y,
      };
}
