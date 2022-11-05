import 'dart:developer' as de;
import 'dart:math';

import 'package:three_d_model_tool/math/angle_conversion.dart';
import 'package:three_d_model_tool/math/get_dot_product.dart';
import 'package:three_d_model_tool/math/get_squre_root_value_of_any_vector.dart';
import 'package:vector_math/vector_math.dart';

/*
5


Thanks DoomMuffins and Klause.

So our equation of plane is 7x+13y+4z=9 and 0.x+0.y+0.z=0
So Normal vectors is <7,13,4> and <0,0,1>
So cosθ=<7,13,4>.<0,0,1>72+132+42−−−−−−−−−−−√1–√=4234−−−√
So θ=cos−1(4234−−−√)
*/
List<Vector3> getListof3Vector3sFromcoorinatelistof9(List<double> values) {
  if (values.length == 9) {
    List<Vector3> vectors = [
      Vector3(
        values[0],
        values[1],
        values[2],
      ),
      Vector3(
        values[3],
        values[4],
        values[5],
      ),
      Vector3(
        values[6],
        values[7],
        values[8],
      ),
    ];
    // for (var i = 0; i < 3; i++) {
    //   vectors.add(Vector3(values[i*], values[i * 2 + 1], values[i * 3 + 2-1]));
    // }
    return vectors;
  }
  return [
    Vector3(100, 0, 0),
    Vector3(0, 100, 0),
    Vector3(0, 0, 100),
  ];
}

getAngleWRT_XY_Plane(
  Vector3 v1,
) {
  return getAngleBetween2Planes(v1, Vector3(0, 0, 1));
}

getAngleWRT_YZ_Plane(
  Vector3 v1,
) {
  return getAngleBetween2Planes(v1, Vector3(1, 0, 0));
}

getAngleWRT_XZ_Plane(
  Vector3 v1,
) {
  return getAngleBetween2Planes(v1, Vector3(0, 1, 0));
}

getAngleBetween2Planes(
  Vector3 v1,
  Vector3 v2,
) {
  double dotProduct = getDotProduct(v1, v2);
  double getSquareRootProduct = get_squre_root_value_of_any_vector(v1) *
      get_squre_root_value_of_any_vector(v2);
  double cosTheta = dotProduct / getSquareRootProduct;
  double angle = acos(cosTheta);

  // de.log("costheta $cosTheta /  $angle / ${radToDeg(angle)}");
  return radToDeg(angle);
}
