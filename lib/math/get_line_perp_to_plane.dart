/*
3
x−1
​
 = 
4
y+2
​
 = 
−2
z−3
​
 =λ............(1)
​
 =λ............(1)
General point P on the line is,

P=(3λ+1,4λ−2,−2λ+3)

since line (1) intersect plane 2x−y+3z−1=0,
Assume it intersects at a point P
Therefore,
2(3λ+1)−(4λ−2)+3(−2λ+3)−1=0
6λ+2−4λ+2−6λ+9−1=0
4λ=12
λ=3
Therefore ,
P=(10,10,−3))
Option (B) is correct.
*/
import 'dart:developer';

import 'package:three_d_model_tool/extensions.dart';
import 'package:three_d_model_tool/math/model/plane_equation_model.dart';
import 'package:vector_math/vector_math.dart';
import 'package:three_d_model_tool/math/get_angles_and_translated_value_for_trianlge_points.dart';

Vector3 getInterSectionPointForPlane(PlaneEquation pe) {
  double sq = getSquareSumofPlaneCoefficients(pe);
  log("interppoit values ${((pe.x * pe.c) / sq).roundTo3Places()} / ${((pe.y * pe.c) / sq).roundTo3Places()} / ${((pe.z * pe.c) / sq).roundTo3Places()}");
  return Vector3(
    ((pe.x * pe.c) / sq).roundTo3Places(),
    ((pe.y * pe.c) / sq).roundTo3Places(),
    ((pe.z * pe.c) / sq).roundTo3Places(),
  );
}

getSquareSumofPlaneCoefficients(PlaneEquation pe) {
  return pe.x * pe.x + pe.y * pe.y + pe.z * pe.z;
}
