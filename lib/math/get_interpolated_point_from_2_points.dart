import 'dart:ui';

import 'package:flutter/material.dart';

Offset get_interpolated_point_from_2_points(
    Offset startPoint, Offset endPoint, double factorFromStart) {
  double x = lerpDouble(startPoint.dx, endPoint.dx, factorFromStart)??0;
  double y = lerpDouble(startPoint.dy, endPoint.dy, factorFromStart)??0;
  return Offset(x, y);
}
