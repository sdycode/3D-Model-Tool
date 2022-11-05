import 'package:vector_math/vector_math.dart';

double getDotProduct(Vector3 v1, Vector3 v2) {
  double ans = 0.0;
  ans = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
  return ans;
}
