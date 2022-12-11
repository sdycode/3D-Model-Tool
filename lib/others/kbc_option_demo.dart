// import 'dart:math';
// import 'dart:developer' as d;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:three_d_model_tool/2D%20Gerometry%20Functions/model/arc_model.dart';
// // import 'package:three_d_model_tool/constants/consts.dart';
// // import 'package:three_d_model_tool/extensions.dart';


// import 'dart:math';
// import 'package:vector_math/vector_math.dart' as vm;
// double _h = 200;
// double _w = 200;
// class KBC_option_demo_page extends StatefulWidget {
//   KBC_option_demo_page({Key? key}) : super(key: key);

//   @override
//   State<KBC_option_demo_page> createState() => _KBC_option_demo_pageState();
// }

// class _KBC_option_demo_pageState extends State<KBC_option_demo_page> {
//   @override
//   Widget build(BuildContext context) {
//       _w = MediaQuery.of(context).size.width;
//           _h = MediaQuery.of(context).size.height;
//     double sh = _h * 0.7;
//     double sw = _w * (0.8);
//     return Scaffold(
//       body: Container(
//           width: _w,
//           height: _h,
//           child: Center(
//             child: Stack(children: [
//               Container(
//                 width: sw,
//                 height: sh,
//                 decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 52, 15, 58),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Stack(children: [
//                   ClipPath(
//                     clipper: _KBC_Clipper(),
//                     child: Container(
//                       width: double.infinity,
//                       height: double.infinity,
//                       decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                             Color.fromARGB(255, 12, 10, 63),
//                             Color.fromARGB(255, 106, 104, 151)
//                           ])),
//                     ),
//                   ),
//                   CustomPaint(
//                     size: Size(sw, sh),
//                     painter: _KBC_optionBox_Painter(),
//                     child: Stack(fit: StackFit.loose, children: [
//                       Positioned(
//                           left: sw * 0.16,
//                           top: sh * 0.4,
//                           child:

//                               // Container(width: 200,height: 80,
//                               // color: Colors.amber,
//                               // ),
//                               Container(
//                             height: sh * 0.2,
//                             width: sh * 0.2,
//                             child: FittedBox(
//                               child: Text(
//                                 "A : ",
//                                 style: TextStyle(
//                                     color: Colors.amber,
//                                     // fontSize: 45,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           )),
//                       Positioned(
//                           left: sw * 0.26,
//                           top: sh * 0.4,
//                           child: Container(
//                             height: sh * 0.18,
//                             // width: sw*0.6,
//                             child: const FittedBox(
//                               // fit: BoxFit.fitHeight,
//                               child: Text(
//                                 "Option A",
//                                 textAlign: TextAlign.left,
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     // fontSize: 45,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ))
//                     ]),
//                   )
//                 ]),
//               )
//             ]),
//           )),
//     );
//   }
// }

// class _KBC_Clipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size s) {
//     return getPath(s);
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }

// class _KBC_optionBox_Painter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size s) {
//     Path path = Path();
//     Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3.0
//       ..color = Colors.white;
//     Paint pointpaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3.0
//       ..color = Colors.amber;
//     canvas.drawCircle(offset1, 4, pointpaint);
//       canvas.drawCircle(offset2, 4, pointpaint);
//     canvas.drawPath(getPath(s), paint);
//     Path linePath = Path();
//     linePath.moveTo(s.width * 0.04, s.height * 0.5);
//     linePath.lineTo(s.width * 0.1, s.height * 0.5);
//     linePath.moveTo(s.width * 0.9, s.height * 0.5);
//     linePath.lineTo(s.width * 0.96, s.height * 0.5);
//     canvas.drawPath(linePath, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// Path _optionBoxPath(Size s) {
//   Path path = Path();
//   double heightFactor = (0.8);
//   path.moveTo(s.width * 0.1, s.height * 0.5);
//   path.lineTo(s.width * 0.2, s.height * (1 - heightFactor));
//   path.lineTo(s.width * 0.8, s.height * (1 - heightFactor));
//   path.lineTo(s.width * 0.9, s.height * 0.5);

//   path.lineTo(s.width * 0.8, s.height * (heightFactor));
//   // path.lineTo(s.width * 0.9, s.height * 0.5);
//   path.lineTo(s.width * 0.2, s.height * (heightFactor));

//   path.close();
//   return path;
// }

// Offset offset1 = Offset.zero;

// Offset offset2 = Offset.zero;


// Path getPath(Size s) {
//   Path path = Path();
//   double cornerRad = 20;
//   path.moveTo(s.width * 0.1, s.height * 0.5);
//   double heightFactor = 0.7;
//   // path.conicTo(
//   //     s.width * 0.15, s.height * 0.2, s.width * 0.15 + gapx, s.height * 0.2, 1);
//   Arc3PointModel arc3pointModel = getArcModel([
//     Offset(s.width * 0.1, s.height * 0.5),
//     Offset(s.width * 0.15, s.height * (1 - heightFactor)),
//     Offset(s.width * 0.85, s.height * (1 - heightFactor))
//   ], cornerRad);

//   path.lineTo(arc3pointModel.startPoint.dx, arc3pointModel.startPoint.dy);
//   path.arcToPoint(arc3pointModel.endPoint,
//       radius: Radius.circular(arc3pointModel.radius),
//       clockwise: arc3pointModel.isClockwise);

//   Arc3PointModel arc3pointModel_topright = getArcModel([
//     Offset(s.width * 0.15, s.height * (1 - heightFactor)),
//     Offset(s.width * 0.85, s.height * (1 - heightFactor)),
//     Offset(s.width * 0.9, s.height * 0.5)
//   ], cornerRad);

//   path.lineTo(arc3pointModel_topright.startPoint.dx,
//       arc3pointModel_topright.startPoint.dy);
//   path.arcToPoint(arc3pointModel_topright.endPoint,
//       radius: Radius.circular(arc3pointModel_topright.radius),
//       clockwise: arc3pointModel_topright.isClockwise);
//   path.lineTo(s.width * 0.9, s.height * 0.5);

//   Arc3PointModel arc3pointModel_bottomRight = getArcModel([
//     Offset(s.width * 0.9, s.height * 0.5),
//     Offset(s.width * 0.85, s.height * heightFactor),
//     Offset(s.width * 0.15, s.height * heightFactor),
//   ], cornerRad);

//   path.lineTo(arc3pointModel_bottomRight.startPoint.dx,
//       arc3pointModel_bottomRight.startPoint.dy);
//   path.arcToPoint(arc3pointModel_bottomRight.endPoint,
//       radius: Radius.circular(arc3pointModel_bottomRight.radius),
//       clockwise: arc3pointModel_bottomRight.isClockwise);

//   Arc3PointModel arc3pointModel_bottomLeft = getArcModel([
//     Offset(s.width * 0.85, s.height * heightFactor),
//     Offset(s.width * 0.15, s.height * heightFactor),
//     Offset(s.width * 0.1, s.height * 0.5),
//   ], cornerRad);
//   path.lineTo(arc3pointModel_bottomLeft.startPoint.dx,
//       arc3pointModel_bottomLeft.startPoint.dy);
//   path.arcToPoint(arc3pointModel_bottomLeft.endPoint,
//       radius: Radius.circular(arc3pointModel_bottomLeft.radius),
//       clockwise: arc3pointModel_bottomLeft.isClockwise);
//   path.close();
//   return path;
// }

// Arc3PointModel _getArcModel(List<Offset> _points, double givebRadius) {
//   if (_points.length != 3) {
//     return Arc3PointModel(Offset.zero, Offset.zero, 0, true);
//   }
//   double angleFactorFromA1 = 0.5;
//   double m1 = (_points[0].dy - _points[1].dy) / (_points[0].dx - _points[1].dx);
//   double m2 = (_points[2].dy - _points[1].dy) / (_points[2].dx - _points[1].dx);
//   double a1 = atan(m1).radToDeg();
//   double a2 = atan(m2).radToDeg();
//   d.log("angdiff befo  a1/a2 / $a1 /$a2");
//   if (a1 < 0) {
//     if (_points[0].dx > _points[1].dx) {
//       // 1st quadrant  i.e above screen
//       a1 = 360 + a1;
//     } else {
//       // 3rd quadrant i.e left side of screen
//       a1 = 180 + a1;
//     }
//   } else {
//     if (_points[0].dx > _points[1].dx) {
//       // 4th quadrant i.e actual screen in flutter

//     } else {
//       // 2ndrd quadrant
//       a1 = 180 + a1;
//     }
//   }
//   if (a2 < 0) {
//     if (_points[2].dx > _points[1].dx) {
//       // 1st quadrant  i.e above screen
//       a2 = 360 + a2;
//     } else {
//       // 3rd quadrant i.e left side of screen
//       a2 = 180 + a2;
//     }
//   } else {
//     if (_points[2].dx > _points[1].dx) {
//       // 4th quadrant i.e actual screen in flutter

//     } else {
//       // 2ndrd quadrant
//       a2 = 180 + a2;
//     }
//   }
//   double angDiff = 0;
//   double diff = (a1 - a2).abs();
//   if (diff > 180) {
//     diff = 360 - diff;
//     if (a2 > a1) {
//       angDiff = a2 + diff * angleFactorFromA1;
//     } else {
//       angDiff = a1 + diff * angleFactorFromA1;
//     }
//   } else {
//     if (a2 > a1) {
//       angDiff = a1 + diff * angleFactorFromA1;
//     } else {
//       angDiff = a2 + diff * angleFactorFromA1;
//     }
//   }
//   double maxLength =
//       _get_max_radius_for_arc_between_3_points(_points.sublist(0, 3));

//   double _smallerLengthFactor = 0.5;
//   double rad = maxLength / (cos((diff * 0.5).degToRad())) * 0.1;
//   d.log("maxx $maxLength / $rad");
//   d.log("angdiff a1/a2 / $a1 /$a2");
//   d.log("angdiff $angDiff / $diff");

//   offset1 =
//       _get_point_from_origin_at_angle_with_radius(_points[1], 360 - a1, rad);
//   offset2 =
//       _get_point_from_origin_at_angle_with_radius(_points[1], 360 - a2, rad);

//   double _arcradius =
//       tan((diff * 0.5).degToRad()) * maxLength * _smallerLengthFactor;

//   return Arc3PointModel(offset1, offset2, _arcradius, true);
// }

// Offset _get_interpolated_point_from_2_points(
//     Offset startPoint, Offset endPoint, double factorFromStart) {
//   double x = lerpDouble(startPoint.dx, endPoint.dx, factorFromStart) ?? 0;
//   double y = lerpDouble(startPoint.dy, endPoint.dy, factorFromStart) ?? 0;
//   return Offset(x, y);
// }

// _get_max_radius_for_arc_between_3_points(List<Offset> _points) {
//   if (_points.length != 3) {
//     return 1;
//   }
//   double dist1 = _get_dist_between_2_points(_points.first, _points[1]);
//   double dist2 = _get_dist_between_2_points(_points[2], _points[1]);
//   return min(
//     dist1,
//     dist2,
//   );
// }

// double _get_dist_between_2_points(Offset p1, Offset p2) {
//   return sqrt(pow(p1.dx - p2.dx, 2) + pow(p1.dy - p2.dy, 2));
// }

// _get_point_from_origin_at_angle_with_radius(
//     Offset origin, double angleInDeg, double rad) {
//   double x = rad * cos(angleInDeg.degToRad()).threshold();
//   double y = rad * sin(angleInDeg.degToRad());
//   d.log(
//       "point angdiff  @ $angleInDeg /  $x /$y / ${cos(angleInDeg.degToRad())}");
//   return Offset(origin.dx + x, origin.dy - y);
// }

// double _getAngleBetween2LinesFromGiven3PointsInRadian(List<Offset> points) {
//   if (points.length != 3) {
//     return 0.0;
//   }

//   double m1 = (points[0].dy - points[1].dy) / (points[0].dx - points[1].dx);
//   double m2 = (points[2].dy - points[1].dy) / (points[2].dx - points[1].dx);
// //
//   double tanThetaValue = (m1 - m2) / (1 + m1 * m2);
//   d.log("ang1 ${atan(m1).radToDeg()}");
//   d.log("ang2 ${atan(m2).radToDeg()}");
//   // de.log("ang $tanThetaValue");
//   return atan(tanThetaValue);
// }



// extension DegRoRad on double {
//   // int parseInt() {
//   //       return int.parse(this);
//   //   }
//   double degToRad() {
//     return (pi / 180) * (this);
//   }
// }

// extension Vect3ToDoubleList on vm.Vector3 {
//   List<double> vect3TodoubleList() {
//     return [this.x, this.y, this.z];
//   }
// }

// extension RadToDeg on double {
//   double radToDeg() {
//     return (180 / pi) * (this);
//   }
// }

// extension RoundTo3Places on double {
//   double roundTo3Places() {
//     String no = this.toStringAsFixed(3);
//     return double.parse(no);
//   }
// }
// double thresholdValueNearAndAboveZero = 0.000001;
// extension ThresholdNum on double {
//   double threshold() {
//     if (this < thresholdValueNearAndAboveZero && this > 0) {
//       return 0.0;
//     }
//     if (this < 0 && this > -thresholdValueNearAndAboveZero) {
//       return 0.0;
//     }
//     return this;
//   }
// }
