import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/2D%20Geometris/bezier_curve.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'package:three_d_model_tool/constants/get_index_for_list.dart';
import 'package:three_d_model_tool/extensions.dart';
import 'package:three_d_model_tool/math/get_angle_between_twolines_from_given_3_points.dart';
import 'package:three_d_model_tool/math/get_anglebisector_lineequation_of_2_lines.dart';
import 'package:three_d_model_tool/math/get_dist_between_2_points.dart';
import 'package:three_d_model_tool/math/get_interpolated_point_from_2_points.dart';
import 'package:three_d_model_tool/math/get_max_radius_for_arc_between_3_points.dart';
import 'package:three_d_model_tool/math/get_point_from_origin_at_angle_with_radius.dart';
import 'package:three_d_model_tool/math/model/line_equation_model.dart';

class ConicCurvePage extends StatefulWidget {
  ConicCurvePage({Key? key}) : super(key: key);

  @override
  State<ConicCurvePage> createState() => _ConicCurvePageState();
}

double _arcradius = 50;
List<Offset> _points = [
  ...List.generate(20, (i) {
    return Offset(i * 50 + 60, i * 30 + 30);
  })
];
Offset bisectorPoint = Offset(200, 200);

class _ConicCurvePageState extends State<ConicCurvePage> {
  double angleFactorFrom_a1 = 0.5;
  double smallerLength = 1;
  double smallerLengthFactor = 0.1;
  double maxLength = 100;
      double a1 = 0;
    double a2 = 0;
  @override
  Widget build(BuildContext context) {
    double a = getAngleBetween2LinesFromGiven3PointsInRadian(
        [..._points.sublist(0, 3)]);

    // d.log("angle betwn ${a.radToDeg()}");
    LineEquation_2D l1 = get2DLineEquationFrom2Points(_points[0], _points[1]);
    LineEquation_2D l2 = get2DLineEquationFrom2Points(_points[1], _points[2]);
    LineEquation_2D l3 =
        getLineEquationFoAcuteAngleBisectorOfGiven2Lines(l1, l2);
    // double angleDiff = 180- ()
    double m1 =
        (_points[0].dy - _points[1].dy) / (_points[0].dx - _points[1].dx);
    double m2 =
        (_points[2].dy - _points[1].dy) / (_points[2].dx - _points[1].dx);
     a1 = atan(m1).radToDeg();
     a2 = atan(m2).radToDeg();
    d.log("angdiff befo  a1/a2 / $a1 /$a2");
    if (a1 < 0) {
      if (_points[0].dx > _points[1].dx) {
        // 1st quadrant  i.e above screen
        a1 = 360 + a1;
      } else {
        // 3rd quadrant i.e left side of screen
        a1 = 180 + a1;
      }
    } else {
      if (_points[0].dx > _points[1].dx) {
        // 4th quadrant i.e actual screen in flutter

      } else {
        // 2ndrd quadrant
        a1 = 180 + a1;
      }
    }
    if (a2 < 0) {
      if (_points[2].dx > _points[1].dx) {
        // 1st quadrant  i.e above screen
        a2 = 360 + a2;
      } else {
        // 3rd quadrant i.e left side of screen
        a2 = 180 + a2;
      }
    } else {
      if (_points[2].dx > _points[1].dx) {
        // 4th quadrant i.e actual screen in flutter

      } else {
        // 2ndrd quadrant
        a2 = 180 + a2;
      }
    }
    double angDiff = 0;
    double diff = (a1 - a2).abs();
    if (diff > 180) {
      diff = 360 - diff;
      if (a2 > a1) {
        angDiff = a2 + diff * angleFactorFrom_a1;
      } else {
        angDiff = a1 + diff * angleFactorFrom_a1;
      }
    } else {
      if (a2 > a1) {
        angDiff = a1 + diff * angleFactorFrom_a1;
      } else {
        angDiff = a2 + diff * angleFactorFrom_a1;
      }
    }
    maxLength = get_max_radius_for_arc_between_3_points(_points.sublist(0, 3));
    double dist1 = get_dist_between_2_points(points.first, points[1]);
    double dist2 = get_dist_between_2_points(points[2], points[1]);

    double rad = maxLength / (cos((diff * 0.5).degToRad()));
    d.log("maxx $maxLength / $rad");
    d.log("angdiff a1/a2 / $a1 /$a2");
    d.log("angdiff $angDiff / $diff");

    _points[4] = get_point_from_origin_at_angle_with_radius(
        _points[1],
        //  360-     angleFactorFrom_a1*(360)
        (360 - angDiff.abs()),
        rad);
    Offset Offset1 = get_point_from_origin_at_angle_with_radius(
        _points[1],
        //  360-     angleFactorFrom_a1*(360)
        360 - a1,
        maxLength);
    Offset Offset2 = get_point_from_origin_at_angle_with_radius(
        _points[1],
        //  360-     angleFactorFrom_a1*(360)
        360 - a2,
        maxLength);
    _points[5] = get_interpolated_point_from_2_points(
        _points[1], Offset1, smallerLengthFactor);
    _points[6] = get_interpolated_point_from_2_points(
        _points[1], Offset2, smallerLengthFactor);
    _arcradius = tan((diff * 0.5).degToRad()) * maxLength * smallerLengthFactor;
    List<Offset> l1points = [];
    bisectorPoint = getPointOnLineFor_X(l3, -200);
    bisectorPoint = Offset(bisectorPoint.dx * (-1), bisectorPoint.dy * (-1));
    d.log("bisect $bisectorPoint");

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: w,
                height: h,
                child: CustomPaint(painter: _ConicPainter()),
              ),
              Positioned(
                  right: 0,
                  top: 80,
                  child: Text(
                    "a1 : ${a1.toStringAsFixed(2)} / a2 : ${a2.toStringAsFixed(2)}  / diff : ${diff.toStringAsFixed(2)} / angdiff : ${angDiff.toStringAsFixed(2)}\n Angle ${360 - angleFactorFrom_a1 * (360)} ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
              Positioned(
                  right: 0,
                  child: Container(
                    width: w * 0.4,
                    height: 30,
                    child: Slider(
                      min: 0.1,
                      max: 1.0,
                      divisions: 100,
                      onChanged: (d) {
                        smallerLengthFactor = d;

                        setState(() {});
                      },
                      value: smallerLengthFactor,
                    ),
                  )),
              ...List.generate(_points.length, (i) {
                return Positioned(
                  left: _points[i].dx - 6,
                  top: _points[i].dy - 6,
                  child: GestureDetector(
                      onPanUpdate: (d) {
                        setState(() {
                          _points[i] = Offset(_points[i].dx + d.delta.dx,
                              _points[i].dy + d.delta.dy);
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: getItemFromList(i, Colors.primaries),
                        radius: 6,
                      )),
                );
              }),
              ...List.generate(l1points.length, (i) {
                return Positioned(
                  left: l1points[i].dx - 6,
                  top: l1points[i].dy - 6,
                  child: GestureDetector(
                      onPanUpdate: (d) {
                        // setState(() {
                        //   _points[i] = Offset(_points[i].dx + d.delta.dx,
                        //       _points[i].dy + d.delta.dy);
                        // });
                      },
                      child: CircleAvatar(
                        backgroundColor: getItemFromList(i, Colors.primaries),
                        radius: 2,
                      )),
                );
              })
            ],
          )
        ],
      ),
    );
  }
}

class _ConicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.red;
    Path path = Path();

//     path.moveTo(_points.first.dx, _points.first.dy);
//     path.cubicTo(_points[1].dx, _points[1].dy, _points[2].dx, _points[2].dy,
//         _points[3].dx, _points[3].dy);
// //
//     path.moveTo(_points[4].dx, _points[4].dy);
//     path.arcToPoint(_points[5], radius: Radius.circular(30));

//     path.moveTo(_points[6].dx, _points[6].dy);
//     path.conicTo(_points[7].dx, _points[7].dy, _points[8].dx, _points[8].dy, 1);
//     //
//     double degToRad(num deg) => deg * (pi / 180.0);
    // path.addRRect(
    //     RRect.fromRectAndRadius(Rect.fromPoints(_points[9], _points[10]), Radius.circular(60)));
    // path.addArc(Rect.fromLTWH(100,100, 800, 400), degToRad(0), degToRad(270));

// Draw first line from 0 to 1 and 1 to 2 and 1 to newPoint

    path.moveTo(_points[0].dx, _points[0].dy);
    path.lineTo(_points[1].dx, _points[1].dy);
    path.lineTo(_points[2].dx, _points[2].dy);

    Path bisectpath = Path();
    bisectpath.moveTo(_points[1].dx, _points[1].dy);
    bisectpath.lineTo(_points[4].dx, _points[4].dy);
    Path arcPath = Path();
    arcPath.moveTo(_points[5].dx, _points[5].dy);
    arcPath.arcToPoint(_points[6], radius: Radius.circular(_arcradius), clockwise: false);

    canvas.drawPath(arcPath, paint..color = Colors.green.shade300);
    canvas.drawPath(path, paint);
    canvas.drawPath(bisectpath, paint..color = Colors.blue.shade200);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
