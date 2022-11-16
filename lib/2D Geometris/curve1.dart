import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class Curve1 extends Curve {
  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) {
      return t;
    }
    return t * t;
    return super.transform(t);
  }
}

class CurveOf_n_Degree extends Curve {
  final int degree;
  CurveOf_n_Degree(this.degree);
  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) {
      return t;
    }
    // For nth degree polynomial
    return pow(t, degree).toDouble();
    return super.transform(t);
  }
}

class BezierCurve extends Curve {
  final List<Offset> points;
  BezierCurve(this.points);
  @override
  double transform(double t) {
    // if (t == 0.0 || t == 1.0) {
    //   return t;
    // }

     double maxX = max(points[0].dx, points[3].dx);
    double x = 
        (points[0].dx/maxX) * pow(1 - t, 3) +
        (points[1].dx/maxX) * pow(1 - t, 2) * 3 * t +
        (points[2].dx/maxX) * pow(1 - t, 1) * 3 * t * t +
        (points[3].dx/maxX) * pow(t, 3);
    double maxY = max(points[0].dy, points[3].dy);
    double y = 
        (points[0].dy/maxY) * pow(1 - t, 3) +
        (points[1].dy/maxY) * pow(1 - t, 2) * 3 * t +
        (points[2].dy/maxY) * pow(1 - t, 1) * 3 * t * t +
        (points[3].dy/maxY) * pow(t, 3);


    //         double velocity = 
    //     3*(points[0].dy/maxY) * pow(1 - t, 2) +
    //    2* (points[1].dy/maxY) * pow(1 - t, 1) * 3 * t +
    //     (points[2].dy/maxY) * pow(1 - t, 0) * 3 * t * t +
    //  3*   (points[3].dy/maxY) * pow(t, 2);
    return x;
    return super.transform(t);
  }
}
