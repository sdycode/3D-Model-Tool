import 'dart:math' as m;

import 'package:three_d_model_tool/extensions.dart';
import 'package:three_d_model_tool/math/get_dot_product.dart';
import 'package:three_d_model_tool/math/get_squre_root_value_of_any_vector.dart';
import 'package:three_d_model_tool/math/model/line_equation_model.dart';
import 'package:vector_math/vector_math.dart';

Vector3 get_angles_of_vector_though_origin_wrt_3planes(Vector3 v1) {
  return Vector3(
    getAngleBetweenAnyAxixAndVector(v1, Axix.x),
    getAngleBetweenAnyAxixAndVector(v1, Axix.y),
    getAngleBetweenAnyAxixAndVector(v1, Axix.z),
  );
}

enum Axix { x, y, z }

double getAngleBetweenAnyAxixAndVector(Vector3 v1, Axix axis) {
  Vector3 v2 = Vector3(1, 1, 1);
  if (axis == Axix.x) {
    v2 = Vector3(1, 0, 0);
  }
  if (axis == Axix.y) {
    v2 = Vector3(0, 1, 0);
  }
  if (axis == Axix.z) {
    v2 = Vector3(0, 0, 1);
  }
  double dotProduct = getDotProduct(v1, v2);
  double getSquareRootProduct = get_squre_root_value_of_any_vector(v1) *
      get_squre_root_value_of_any_vector(v2);
  double cosTheta = dotProduct / getSquareRootProduct;
  double angle = 90 - m.acos(cosTheta).radToDeg();
  return angle;
}
