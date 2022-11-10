import 'dart:developer' as de;
import 'dart:math' as m;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/Polygon/get_polygon_points_from_radius_no_initialAngle.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/Polygon/get_trapezim_for_ring_at_angle.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/model/point.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/model/trapezium.dart';
import 'package:three_d_model_tool/3D%20Plane%20in%20Space/3D%20parts%20widgets/plane_from_origin_at_circumference.dart';
import 'package:three_d_model_tool/3D%20Plane%20in%20Space/3D%20parts%20widgets/trapezium_clipped_on_sphere.dart';
import 'package:three_d_model_tool/3D%20Plane%20in%20Space/3d_plane_in_space_trial1.dart';
import 'package:three_d_model_tool/extensions.dart';
import 'package:vector_math/vector_math.dart' as vm;

class CircleRing3DModelWidget extends StatelessWidget {
  int noOfPolygonSides;
  double polygonRadius;
  double rotateAngle = 0;
  double ringThickness;
  Color color;
  CircleRing3DModelWidget(
      {Key? key,
      required this.noOfPolygonSides,
      required this.polygonRadius,
      this.rotateAngle = 0,
      this.ringThickness = 10,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (polygonRadius < 1) {
      polygonRadius = 1;
    }
    if (noOfPolygonSides < 4) {
      noOfPolygonSides = 4;
    }
    if (noOfPolygonSides % 2 != 0) {
      noOfPolygonSides++;
    }

    double side = 2 * polygonRadius * (m.tan(((m.pi) / noOfPolygonSides)));
    List<Point> points = getNthPointFromInitialAngleWithStepAngle(polygonRadius,
        Point.zero, polygonRadius * 2, polygonRadius * 2, noOfPolygonSides);
    return Stack(
      children: [
        ...List.generate(points.length, (i) {
          return PlaneFromOriginAtCircmference(
            vector3: vm.Vector3(
              points[i].x,
              0,
              points[i].y,
            ),
            polygonRadius: polygonRadius,
            planeRectSize: Size(side, ringThickness),
            color: Colors.primaries[(i + 4) % Colors.primaries.length],
            //  color,
          );
        })
      ],
    );
  }
}

class NthRingModel {
  int ringNo;
  Trapezium trapezium;
  double fullStepAngleFromXZPlane;
  List<Point> polygonPointsOFCentroidPlane;
  double projectedPolyfonRadius;
  double distanceOFCentroidFromXZPlane;
  NthRingModel({
    required this.ringNo,
    required this.trapezium,
    required this.fullStepAngleFromXZPlane,
    required this.polygonPointsOFCentroidPlane,
    required this.projectedPolyfonRadius,
    required this.distanceOFCentroidFromXZPlane,
  });
}

NthRingModel getNthRingModelforRingNo(
  int ringNo,
  Size planeSize,
) {
  double stepAngleFromXZPlane =
      2 * m.atan((ringThickness) / (polygonRadius * 2));
  double side = 2 * polygonRadius * (m.tan(((m.pi) / noOfPolygonSides)));
  double stepAngleFromXZPlaneForRing = stepAngleFromXZPlane * ringNo;
  double projectedPolyfonRadius =
      polygonRadius * (m.cos(stepAngleFromXZPlaneForRing));
  List<Point> points = getNthPointFromInitialAngleWithStepAngle(
      projectedPolyfonRadius,
      Point.zero,
      projectedPolyfonRadius * 2,
      projectedPolyfonRadius * 2,
      noOfPolygonSides);
  double distanceOFCentroidFromXZPlane =
      polygonRadius * m.sin(stepAngleFromXZPlaneForRing);
  Trapezium trapezium = getTrapeziumForPlaneAtAnglewerCentroid(
      ringStepAngleInDeg: stepAngleFromXZPlane.radToDeg(),
      ring_NoFrom_XZPlane: ringNo,
      polygonRadius: polygonRadius,
      planeSize: Size(side, ringThickness));
  return NthRingModel(
      ringNo: ringNo,
      distanceOFCentroidFromXZPlane: distanceOFCentroidFromXZPlane,
      polygonPointsOFCentroidPlane: points,
      projectedPolyfonRadius: projectedPolyfonRadius,
      fullStepAngleFromXZPlane: stepAngleFromXZPlaneForRing,
      trapezium: trapezium);
}

List<Widget> getTrapeziumRing(int ringNo, NthRingModel ringModel) {
  de.log(
      "for ringno $ringNo / top ${ringModel.trapezium.topWidth} / bottom ${ringModel.trapezium.bottomWidth}");
  return List.generate(ringModel.polygonPointsOFCentroidPlane.length, (i) {
    return Transform(
      transform: Matrix4.rotationY(0.0.degToRad()),
      child: PlaneFromOriginAtCircmference(
        vector3: vm.Vector3(
          ringModel.polygonPointsOFCentroidPlane[i].x,
          -ringModel.distanceOFCentroidFromXZPlane,
          ringModel.polygonPointsOFCentroidPlane[i].y,
        ),
        polygonRadius: polygonRadius,
        planeRectSize: Size(ringModel.trapezium.bottomWidth, ringThickness),
        color: Colors.primaries[i % Colors.primaries.length],
        // color,
        child: TrapeziumClippedOnSphereSurface(
          bottomWidth: ringModel.trapezium.bottomWidth,
          topWidth: ringModel.trapezium.topWidth,
          height: ringThickness,
          color: Colors.primaries[i % Colors.primaries.length],
        ),
      ),
    );
  });
}

class CircleRing3DModelWidgetAtAnglewrtXZPlane extends StatelessWidget {
  int noOfPolygonSides;
  double polygonRadius;
  double rotateAngle = 0;
  double xzAngle;
  double ringThickness;
  Color color;
  CircleRing3DModelWidgetAtAnglewrtXZPlane(
      {Key? key,
      required this.noOfPolygonSides,
      required this.polygonRadius,
      this.rotateAngle = 0,
      this.xzAngle = 0,
      this.ringThickness = 10,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (polygonRadius < 1) {
      polygonRadius = 1;
    }
    if (noOfPolygonSides < 4) {
      noOfPolygonSides = 4;
    }
    if (noOfPolygonSides % 2 != 0) {
      noOfPolygonSides++;
    }

    double side = 2 * polygonRadius * (m.tan(((m.pi) / noOfPolygonSides)));
    Size planeSize = Size(side, ringThickness);
    
    return Stack(
      children: [
        ...List.generate(noOfRingsAboveXZPlane, (ringNo) {
          return Stack(
            children: [
              ...getTrapeziumRing(
                  ringNo, getNthRingModelforRingNo(ringNo, planeSize))
            ],
          );
        }),
      //  Transform(
      //   transform: Matrix4.rotationZ(pi),
      //    child: Stack(
      //     children: [ ...List.generate(noOfRingsAboveXZPlane, (ringNo) {
      //     return Stack(
      //       children: [
      //         ...getTrapeziumRing(
      //             ringNo, getNthRingModelforRingNo(ringNo, planeSize))
      //       ],
      //     );
      //   })],
      //    ),
      //  )
      ],
    );
  }
}
