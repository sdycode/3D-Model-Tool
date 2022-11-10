import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/model/trapezium.dart';
import 'package:three_d_model_tool/extensions.dart';

getTrapeziumForPlaneAtAnglewerCentroid({
  required double ringStepAngleInDeg,
  required int ring_NoFrom_XZPlane,
  required double polygonRadius,
  required Size planeSize,
}) {
  double angleOfTopSideOfTrapezium =
      ringStepAngleInDeg * 0.5 + ringStepAngleInDeg * ring_NoFrom_XZPlane;
  double angleOfBottomSideOfTrapezium =
      ringStepAngleInDeg * 0.5 + ringStepAngleInDeg * (ring_NoFrom_XZPlane - 1);
  d.log("stepAngle angleOfTopSideOfTrapezium $angleOfTopSideOfTrapezium");
  double bottomWidth = planeSize.width;
  if (ring_NoFrom_XZPlane > 1) {}
  bottomWidth = planeSize.width *
      ((cos(angleOfBottomSideOfTrapezium.degToRad())) /
          (cos((ringStepAngleInDeg * 0.5).degToRad())));
  d.log("bottomWidth @ $ring_NoFrom_XZPlane  : $bottomWidth / ${planeSize.width} ");
  double topWidth = planeSize.width *
      ((cos(angleOfTopSideOfTrapezium.degToRad())) /
          (cos((ringStepAngleInDeg * 0.5).degToRad())));

  return Trapezium(topWidth, bottomWidth, planeSize.height);
}
