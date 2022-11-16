import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/extensions.dart';

get_point_from_origin_at_angle_with_radius(
    Offset origin, double angleInDeg, double rad) {
  double x = rad * cos(angleInDeg.degToRad()).threshold();
  double y = rad * sin(angleInDeg.degToRad());
  d.log(
      "point angdiff  @ $angleInDeg /  $x /$y / ${cos(angleInDeg.degToRad())}");
  return Offset(origin.dx + x, origin.dy - y);
}


// List<Point> getNthPointFromInitialAngleWithStepAngle(
//     double rad, Point center, double width, double height, int n,
//     {double? initAngle}) 
//     {
//   double initialAngle = initAngle ?? 0;
//   if (n < 3) {
//     return [Point.zero];
//   }
//   double stepAngle = (2 * pi) / n;

//   double h2wFactor = height / width;
//   d.log("h2w $height / $width / $h2wFactor");
//   if (initAngle == null) {
//     if (n % 4 == 0) {
//       initialAngle = stepAngle * 0.5;
//     } else if (n % 2 == 0) {
//       initialAngle = 0;
//     } else {
//       int angleinDeg = radianToDegree(stepAngle);
//       int newang = 90 % angleinDeg;
//       initialAngle = degree2Radian(newang.toDouble());
//     }
//   }

//   List<Point> points = [];

//   for (var i = 0; i < n; i++) {
//     double x = rad * cos(initialAngle + stepAngle * i).threshold();
//     double y = rad * sin(initialAngle + stepAngle * i);
//     // if()

//     Point p = Point(x: x + center.x, y: y * h2wFactor + center.y);
//     points.add(p);
//     // d.log(        "point @ $i : [${radianToDegree(initialAngle + stepAngle * i)}] : ${p.toMap()}");
//   }

//   return points;
// }
