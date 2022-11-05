import 'dart:math';

import 'package:vector_math/vector_math.dart';

double get_squre_root_value_of_any_vector(Vector vector) {
  if (vector.storage.isNotEmpty) {
    double total = 0;
    vector.storage.forEach((e) {
      total += e * e;
    });
    return sqrt(total);
  }
  return 1.0;
}
