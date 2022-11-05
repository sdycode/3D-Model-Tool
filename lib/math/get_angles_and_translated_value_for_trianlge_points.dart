/*


*/
import 'dart:developer';

import 'package:three_d_model_tool/math/model/plane_equation_model.dart';
import 'package:vector_math/vector_math.dart';

List<Vector3> plane3Points = [
  Vector3(1, 1, 0),
  Vector3(1, 2, 1),
  Vector3(-2, 2, -1)
];

double getDeterminantForPlane3Points(List<Vector3> points) {
  if (points.length == 3) {
    Vector2 v1 = Vector2(points[1].x, points[2].x);
    Vector2 v2 = Vector2(points[1].y, points[2].y);
    Vector2 v3 = Vector2(points[1].z, points[2].z);
    log("deter first row ${points[0]}");
    log("deter 2     row ${points[1]}");
    log("deter 3     row ${points[2]}");
    double d = (points[0].x) * (get2x2Determinant(v2, v3)) -
        (points[0].y) * (get2x2Determinant(v1, v3)) +
        (points[0].z) * (get2x2Determinant(v1, v2));
    log("3x3 deter $d");
    return d;
  }
  return 0.0;
}

PlaneEquation? getPlaneEquationFrom3Points(List<Vector3> points) {
  double x = 1;
  double y = 1;
  double z = 1;
  double c = 0;
  log("plane  ${x}x + ${y}y+ ${z}z = $c ");
  // if (!checkVectorlistisCorrectFor3x3Matrix(points)) {
  //   return null;
  // }
  // if (check3PointsAreCollinearOrNot(points)) {
  //   return null;
  // }

  Vector2 v1 = Vector2(points[1].x - points[0].x, points[2].x - points[0].x);
  Vector2 v2 = Vector2(points[1].y - points[0].y, points[2].y - points[0].y);
  Vector2 v3 = Vector2(points[1].z - points[0].z, points[2].z - points[0].z);
  x = get2x2Determinant(v2, v3);
  y = get2x2Determinant(v3, v1);
  z = get2x2Determinant(v1, v2);
  c = x * points[0].x + y * points[0].y + z * points[0].z;
  log("plane  ${x}x + ${y}y+ ${z}z = $c ");
  return PlaneEquation(x, y, z, c);
}

bool check3PointsAreCollinearOrNot(List<Vector3> points) {
  if (getDeterminantForPlane3Points(points).toInt() == 0) {
    return true;
  }
  return false;
}

bool checkVectorlistisCorrectFor3x3Matrix(List<Vector3> points) {
  bool check = true;
  if (points.length == 3) {
    points.forEach((e) {
      if (e.length != 3) {
        check = false;
      }
    });
    return check;
  }
  return false;
}

double get2x2Determinant(Vector2 v1, Vector2 v2) {
  double d = v1.x * v2.y - v1.y * v2.x;
  log("2x2 deter for ${v1} & $v2 : [${d}]");

  return d;
}
