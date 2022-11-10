import 'dart:developer' as de;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/3D%20Plane%20in%20Space/3D%20parts%20widgets/circleRing3DModelWidget.dart';
import 'package:three_d_model_tool/extensions.dart';

class SphereUsingcircularRingsRotatedwrtXZPlane extends StatelessWidget {
  final int noOfPolygonSides;
  final double polygonRadius;
  final double rotateAngle;
  final double planeThickness;
  SphereUsingcircularRingsRotatedwrtXZPlane(
      {Key? key,
      required this.noOfPolygonSides,
      required this.polygonRadius,
      this.rotateAngle = 0,
      this.planeThickness = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double xzStepAngle = 2 * (atan((planeThickness * 0.5) / polygonRadius));
    int noOfRingsRquired = ((pi) / xzStepAngle).toInt()+1;
    de.log("stepAngle $xzStepAngle deg ${xzStepAngle.radToDeg()} / ${xzStepAngle.radToDeg()*noOfRingsRquired}  /  : noof rings $noOfRingsRquired");
    return Stack(
      children: [
        ...List.generate(noOfRingsRquired, (i) {
          return CircleRing3DModelWidgetAtAnglewrtXZPlane(
            noOfPolygonSides: noOfPolygonSides,
            polygonRadius: polygonRadius,
            xzAngle: (i * xzStepAngle).radToDeg(),
            ringThickness: planeThickness,
            color: 
            Colors.red,
            // Colors.primaries[i % Colors.primaries.length].withAlpha(244),
          );
        })
      ],
    );
  }
}
