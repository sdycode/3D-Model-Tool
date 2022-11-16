import 'dart:math';

import 'package:flutter/material.dart';

double get_dist_between_2_points(Offset p1, Offset p2) {
  return sqrt(pow(p1.dx - p2.dx, 2) + pow(p1.dy - p2.dy, 2));
}
