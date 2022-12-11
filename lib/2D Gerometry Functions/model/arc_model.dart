
import 'package:flutter/material.dart';

class Arc3PointModel {
  final Offset startPoint;
  final Offset endPoint;
  final double radius;
  final bool isClockwise;
  const Arc3PointModel(
      this.startPoint, this.endPoint, this.radius, this.isClockwise);
}