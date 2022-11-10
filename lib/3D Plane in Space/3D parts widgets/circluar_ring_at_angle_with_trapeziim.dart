// import 'package:flutter/material.dart';
// import 'package:three_d_model_tool/2D%20Gerometry%20Functions/Polygon/get_polygon_points_from_radius_no_initialAngle.dart';
// import 'package:three_d_model_tool/2D%20Gerometry%20Functions/model/point.dart';
// import 'package:three_d_model_tool/3D%20Plane%20in%20Space/3D%20parts%20widgets/plane_from_origin_at_circumference.dart';
// import 'package:three_d_model_tool/extensions.dart';

// class CircularRingAtAngleWithTrapezium extends StatelessWidget {
//   int noOfPolygonSides;
//   double polygonRadius;
//   double rotateAngle = 0;
//   double xzAngle;
//   double ringThickness;
//   Color color;
//   CircularRingAtAngleWithTrapezium(
//       {Key? key,
//       required this.noOfPolygonSides,
//       required this.polygonRadius,
//       this.rotateAngle = 0,
//       this.xzAngle = 0,
//       this.ringThickness = 10,
//       this.color = Colors.white})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (polygonRadius < 1) {
//       polygonRadius = 1;
//     }
//     if (noOfPolygonSides < 4) {
//       noOfPolygonSides = 4;
//     }
//     if (noOfPolygonSides % 2 != 0) {
//       noOfPolygonSides++;
//     }

//     // double side = 2 * polygonRadius * (m.tan(((m.pi) / noOfPolygonSides)));
//     List<Point> points = getNthPointFromInitialAngleWithStepAngle(polygonRadius,
//         Point.zero, polygonRadius * 2, polygonRadius * 2, noOfPolygonSides);
//     return Stack(
//       children: [
//         ...List.generate(points.length, (i) {
//           return PlaneFromOriginAtCircmference(
//             vector3: vm.Vector3(
//               points[i].x,
//               0,
//               points[i].y,
//             ),
//             polygonRadius: polygonRadius,
//             planeRectSize: Size(side, ringThickness),
//             color: color,
//           );
//         })
//       ],
//     );
//   }
// }
