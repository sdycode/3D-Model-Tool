import 'dart:math';

import 'package:three_d_model_tool/2D%20Gerometry%20Functions/model/point.dart';
import 'package:three_d_model_tool/extensions.dart';

List<Point> getNthPointFromInitialAngleWithStepAngle(
    double rad, Point center, double width, double height, int n,
    {double? initAngle}) {
  double initialAngle = initAngle ?? 0;
  if (n < 3) {
    return [Point.zero];
  }
  double stepAngle = (2 * pi) / n;

  double h2wFactor = height / width;

  if (initAngle == null) {
    if (n % 4 == 0) {
      initialAngle = stepAngle * 0.5;
    } else if (n % 2 == 0) {
      initialAngle = 0;
    } else {
      int angleinDeg = stepAngle.radToDeg().toInt();
      int newang = 90 % angleinDeg;
      initialAngle = newang.toDouble().degToRad();
    }
  }

  List<Point> points = [];

  for (var i = 0; i < n; i++) {
    double x = rad * cos(initialAngle + stepAngle * i).threshold();
    double y = rad * sin(initialAngle + stepAngle * i);
    // if()

    Point p = Point(x: x + center.x, y: y * h2wFactor + center.y);
    points.add(p);
    // d.log(        "point @ $i : [${radianToDegree(initialAngle + stepAngle * i)}] : ${p.toMap()}");
  }

  return points;
}
