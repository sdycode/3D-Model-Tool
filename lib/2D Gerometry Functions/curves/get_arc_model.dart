import 'dart:math';
import 'dart:developer' as d;
import 'package:flutter/material.dart';
import 'package:three_d_model_tool/2D%20Geometris/conic_curve.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/model/arc_model.dart';
import 'package:three_d_model_tool/extensions.dart';
import 'package:three_d_model_tool/math/get_dist_between_2_points.dart';
import 'package:three_d_model_tool/math/get_interpolated_point_from_2_points.dart';
import 'package:three_d_model_tool/math/get_max_radius_for_arc_between_3_points.dart';
import 'package:three_d_model_tool/math/get_point_from_origin_at_angle_with_radius.dart';

Arc3PointModel getArcModel(List<Offset> _points, double givebRadius) {
  if (_points.length != 3) {
    return Arc3PointModel(Offset.zero, Offset.zero, 0, true);
  }
  double _a1 = 0;
  double _a2 = 0;
  double m1 = (_points[0].dy - _points[1].dy) / (_points[0].dx - _points[1].dx);
  double m2 = (_points[2].dy - _points[1].dy) / (_points[2].dx - _points[1].dx);
  _a1 = atan(m1).radToDeg();
  _a2 = atan(m2).radToDeg();
  //  d.log("angdiff befo  _a1/_a2 / $_a1 /$_a2");
  if (_a1 < 0) {
    if (_points[0].dx > _points[1].dx) {
      // 1st quadrant  i.e above screen
      _a1 = 360 + _a1;
    } else {
      // 3rd quadrant i.e left side of screen
      _a1 = 180 + _a1;
    }
  } else {
    if (_points[0].dx > _points[1].dx) {
      // 4th quadrant i.e actual screen in flutter

    } else {
      // 2ndrd quadrant
      _a1 = 180 + _a1;
    }
  }
  if (_a2 < 0) {
    if (_points[2].dx > _points[1].dx) {
      // 1st quadrant  i.e above screen
      _a2 = 360 + _a2;
    } else {
      // 3rd quadrant i.e left side of screen
      _a2 = 180 + _a2;
    }
  } else {
    if (_points[2].dx > _points[1].dx) {
      // 4th quadrant i.e actual screen in flutter

    } else {
      // 2ndrd quadrant
      _a2 = 180 + _a2;
    }
  }
  bool isClockwise = true;
  double angleFactorFrom_a1 = 0.5;
  double angDiff = 0;
  double diff = (_a1 - _a2).abs();
  if (diff > 180) {
    diff = 360 - diff;
    if (_a2 > _a1) {
      angDiff = _a2 + diff * angleFactorFrom_a1;
      isClockwise = true;
    } else {
      isClockwise = false;
      angDiff = _a1 + diff * angleFactorFrom_a1;
    }
  } else {
    if (_a2 > _a1) {
      isClockwise = false;
      angDiff = _a1 + diff * angleFactorFrom_a1;
    } else {
      isClockwise = true;
      angDiff = _a2 + diff * angleFactorFrom_a1;
    }
  }
  double maxLength = 100;
  maxLength = get_max_radius_for_arc_between_3_points(_points.sublist(0, 3));
  double dist1 = get_dist_between_2_points(_points.first, _points[1]);
  double dist2 = get_dist_between_2_points(_points[2], _points[1]);
  //  d.log("distt $dist1 / $dist2 / $maxLength");
  double rad = maxLength / (cos((diff * 0.5).degToRad()));
  //  d.log("maxx $maxLength / $rad");
  //  d.log("angdiff _a1/_a2 / $_a1 /$_a2");
  //  d.log("angdiff $angDiff / $diff");
  double smallerLengthFactor = 1.0;
  if (givebRadius >= 0 && givebRadius <= maxLength) {
    smallerLengthFactor = givebRadius / maxLength;
  }

  smallerLengthFactor = smallerLengthFactor * 0.5;
  Offset Offset1 = get_point_from_origin_at_angle_with_radius(
      _points[1],
      //  360-     angleFactorFrom_a1*(360)
      360 - _a1,
      maxLength * smallerLengthFactor);
  Offset Offset2 = get_point_from_origin_at_angle_with_radius(
      _points[1],
      //  360-     angleFactorFrom_a1*(360)
      360 - _a2,
      maxLength * smallerLengthFactor);
  double dist = get_dist_between_2_points(Offset1, _points[1]);

  double _arcradiuss = tan((diff * 0.5).degToRad()) * dist;
  //  d.log("diffang ${(diff * 0.5)} / $_arcradiuss / $dist / $dist1 ");
  return Arc3PointModel(Offset1, Offset2, _arcradiuss, isClockwise);
}
