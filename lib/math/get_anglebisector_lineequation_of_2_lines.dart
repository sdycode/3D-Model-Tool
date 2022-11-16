import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:three_d_model_tool/math/model/line_equation_model.dart';

LineEquation_2D getLineEquationForObtuseAngleBisectorOfGiven2Lines(
    LineEquation_2D l1, LineEquation_2D l2) {
  double factor =
      (sqrt(l2.x * l2.x + l2.y * l2.y) / (l1.x * l1.x + l1.y * l1.y));
  // a1a2 + b1b2 > 0  (obtuse is + side) comparativeFactor
  double comparativeFactor = l1.x * l2.x + l1.y * l2.y;
  if (comparativeFactor > 0) {
    double x = (l1.x - l2.x) * factor;
    double y = (l1.y - l2.y) * factor;
    double c = (l1.c - l2.c) * factor;
    return LineEquation_2D(x, y, c);
  } else {
    double x = (l1.x + l2.x) * factor;
    double y = (l1.y + l2.y) * factor;
    double c = (l1.c + l2.c) * factor;
    return LineEquation_2D(x, y, c);
  }
}

LineEquation_2D getLineEquationFoAcuteAngleBisectorOfGiven2Lines(
    LineEquation_2D l1, LineEquation_2D l2) {
  double factor =
      (sqrt(l2.x * l2.x + l2.y * l2.y) / (l1.x * l1.x + l1.y * l1.y));
  // a1a2 + b1b2 > 0  (acute is - side) comparativeFactor
  double comparativeFactor = l1.x * l2.x + l1.y * l2.y;
  if (comparativeFactor > 0) {
    double x = (l1.x + l2.x) * factor;
    double y = (l1.y + l2.y) * factor;
    double c = (l1.c + l2.c) * factor;
    return LineEquation_2D(x, y, c);
  } else {
    double x = (l1.x - l2.x) * factor;
    double y = (l1.y - l2.y) * factor;
    double c = (l1.c - l2.c) * factor;
    return LineEquation_2D(x, y, c);
  }
}

Offset getPointOnLineFor_X(LineEquation_2D line, double x) {
  double y = (-1) * (line.x * x + line.c) / (line.y);
  return Offset(x, y);
}

LineEquation_2D get2DLineEquationFrom2Points(Offset p1, Offset p2) {
  double slope = (p2.dy - p1.dy) / (p2.dx - p1.dx);
  return LineEquation_2D(slope, 1, p2.dy - slope * p2.dx);
}
/// https://www.math-only-math.com/equations-of-the-bisectors-of-the-angles-between-two-straight-lines.html
///If a1a2 + b1b2 < 0, then the bisector corresponding to “ + “ and “ - “ symbol give the acute and obtuse angle bisectors respectively i.e.

/// a1x+b1y+c1a21+b21√ = + a2x+b2y+c2a22+b22√ and a1x+b1y+c1a21+b21√ = -  a2x+b2y+c2a22+b22√
