import 'dart:math';

extension DegRoRad on double {
  // int parseInt() {
  //       return int.parse(this);
  //   }
  double degToRad() {
    return (pi / 180) * (this);
  }
}

extension RadToDeg on double {
  // int parseInt() {
  //       return int.parse(this);
  //   }
  double radToDeg() {
    return  (180 / pi) * (this);
  }
}
extension RoundTo3Places on double {
  // int parseInt() {
  //       return int.parse(this);
  //   }
  double roundTo3Places() {
    String no = this.toStringAsFixed(3);
    return double.parse(no);
  }
}
// degToRad(double d) {
//   return (pi / 180) * d;
// }
// radToDeg(double d) {
//   de.log("radto $d / ${(pi / 180)} ");
//   return
//   (180 / pi) * d;
// }