import 'dart:math';

import 'package:vector_math/vector_math.dart';

planeInterSectionPerpendilarDistanceForVector(Vector3 v) {
  return sqrt(pow(v.x, 2)+pow(v.y, 2)+pow(v.z, 2),);
}
