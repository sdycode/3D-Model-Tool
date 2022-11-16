import 'dart:developer' as de;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/extensions.dart';

double getAngleBetween2LinesFromGiven3PointsInRadian(List<Offset> points) {
  if (points.length != 3) {
    return 0.0;
  }

  double m1 = (points[0].dy - points[1].dy) / (points[0].dx - points[1].dx);
  double m2 = (points[2].dy - points[1].dy) / (points[2].dx - points[1].dx);
//
  double tanThetaValue = (m1 - m2) / (1 + m1 * m2);
  de.log("ang1 ${atan(m1).radToDeg()}");
  de.log("ang2 ${atan(m2).radToDeg()}");
  // de.log("ang $tanThetaValue");
  return atan(tanThetaValue);
}
