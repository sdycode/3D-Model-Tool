import 'dart:math';
import 'package:vector_math/vector_math.dart' as vm;

extension DegRoRad on double {
  // int parseInt() {
  //       return int.parse(this);
  //   }
  double degToRad() {
    return (pi / 180) * (this);
  }
}

extension Vect3ToDoubleList on vm.Vector3 {
  List<double> vect3TodoubleList() {
    return [this.x, this.y, this.z];
  }
}

extension RadToDeg on double {
  double radToDeg() {
    return (180 / pi) * (this);
  }
}

extension RoundTo3Places on double {
  double roundTo3Places() {
    String no = this.toStringAsFixed(3);
    return double.parse(no);
  }
}
double thresholdValueNearAndAboveZero = 0.000001;
extension ThresholdNum on double {
  double threshold() {
    if (this < thresholdValueNearAndAboveZero && this > 0) {
      return 0.0;
    }
    if (this < 0 && this > -thresholdValueNearAndAboveZero) {
      return 0.0;
    }
    return this;
  }
}
