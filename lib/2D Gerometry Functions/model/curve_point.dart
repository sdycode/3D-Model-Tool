import 'package:flutter/material.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/functions%20to%20fill%20CurvePoints%20data/get_enums_to_fill_curvePointsList_from_map_data.dart';
import 'package:three_d_model_tool/enum/enums.dart';

class CurvePoint {
  int index = 0;
  Offset point = Offset.zero;
  PrePointCurveType prePointCurveType = PrePointCurveType.normal;
  PostPointCurveType postPointCurveType = PostPointCurveType.normal;
  Offset prePoint = Offset.zero;
  Offset postPoint = Offset.zero;
  Offset preArcEndPoint = Offset.zero;
  Offset postArcEndPoint = Offset.zero;
  double arcRadius = 0;
  double tempArcRadius = 50;
  bool isArcClockwise = true;

  PointPosition pointPosition = PointPosition.normal;
  PointSymmetry pointSymmetry = PointSymmetry.nonSymmetric;
  ArcTypeOnPoint arcTypeOnPoint = ArcTypeOnPoint.normal;
  CurvePoint.withOffset(this.point);
  CurvePoint.withIndexAndOffset({required this.index, required this.point});
  CurvePoint.withAllNamedData(
      {required this.index,
      required this.point,
      required this.pointPosition,
      required this.prePointCurveType,
      required this.postPointCurveType,
      required this.prePoint,
      required this.postPoint,
      required this.preArcEndPoint,
      required this.postArcEndPoint,
      required this.arcRadius,
      required this.tempArcRadius,
      required this.isArcClockwise,
      required this.pointSymmetry,
      required this.arcTypeOnPoint});

  CurvePoint.withAllData(
      this.index,
      this.point,
      this.pointPosition,
      this.prePointCurveType,
      this.postPointCurveType,
      this.prePoint,
      this.postPoint,
      this.preArcEndPoint,
      this.postArcEndPoint,
      this.arcRadius,
      this.tempArcRadius,
      this.isArcClockwise,
      this.pointSymmetry,
      this.arcTypeOnPoint);
  factory CurvePoint.fromCopy(CurvePoint p) {
    CurvePoint point = CurvePoint.withAllNamedData(
        index: p.index,
        point: p.point,
        pointPosition: p.pointPosition,
        prePointCurveType: p.prePointCurveType,
        postPointCurveType: p.postPointCurveType,
        prePoint: p.prePoint,
        postPoint: p.postPoint,
        preArcEndPoint: p.preArcEndPoint,
        postArcEndPoint: p.postArcEndPoint,
        arcRadius: p.arcRadius,
        tempArcRadius: p.tempArcRadius,
        isArcClockwise: p.isArcClockwise,
        pointSymmetry: p.pointSymmetry,
        arcTypeOnPoint: p.arcTypeOnPoint);
   

    return point;
  }
  factory CurvePoint.fromCurvePointData(CurvePointData p) {
    return CurvePoint.withAllNamedData(
        index: p.i ?? 0,
        point: Offset(
          p.pX ?? 0.0,
          p.pY ?? 0.0,
        ),
        pointPosition: p.pP ?? PointPosition.normal,
        prePointCurveType: p.prPCT ?? PrePointCurveType.normal,
        postPointCurveType: p.psPCT ?? PostPointCurveType.normal,
        prePoint: Offset(
          p.prX ?? 0.0,
          p.prY ?? 0.0,
        ),
        postPoint: Offset(
          p.psX ?? 0.0,
          p.psY ?? 0.0,
        ),
        preArcEndPoint: Offset(
          p.prAEX ?? 0.0,
          p.prAEY ?? 0.0,
        ),
        postArcEndPoint: Offset(
          p.psAEX ?? 0.0,
          p.psAEY ?? 0.0,
        ),
        arcRadius: p.r ?? 0,
        tempArcRadius: p.tr ?? 0,
        isArcClockwise: p.cl ?? true,
        pointSymmetry: p.pS ?? PointSymmetry.allSymmetry,
        arcTypeOnPoint: p.aTP ?? ArcTypeOnPoint.normal);
  }
}
