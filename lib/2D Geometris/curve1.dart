import 'dart:math';

import 'package:flutter/animation.dart';

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
    return  pow(t, degree).toDouble() ;
    return super.transform(t);
  }
}
