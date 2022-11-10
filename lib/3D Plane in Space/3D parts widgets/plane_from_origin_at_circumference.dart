import 'dart:developer';
import 'dart:math' as m;
import 'package:flutter/material.dart';
import 'package:three_d_model_tool/3D%20Plane%20in%20Space/3D%20parts%20widgets/trapezium_clipped_on_sphere.dart';
import 'package:three_d_model_tool/extensions.dart';
import 'package:three_d_model_tool/math/get_angles_of_vector_though_origin_wrt_3planes.dart';

import 'package:vector_math/vector_math.dart' as vm;

class PlaneFromOriginAtCircmference extends StatelessWidget {
  final vm.Vector3 vector3;
  final double polygonRadius;
  final Size planeRectSize;
  final double ytrans;
  final double ztrans;
  final Color color;
  final int alpha;
  final Widget? child;
  const PlaneFromOriginAtCircmference(
      {Key? key,
      required this.vector3,
      this.polygonRadius = 200,
      this.planeRectSize = const Size(100, 100),
      this.ytrans = 0,
      this.ztrans = 0,
      this.color = Colors.white,
      this.alpha = 255,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    vm.Vector3 lineAngles = vm.Vector3(0, 0, 0);
    lineAngles =
        get_angles_of_vector_though_origin_wrt_3planes_YZ_XY_XZ(vector3);

    List<double> axisAngles = [0, 0, 0];

    if (lineAngles.y.toString().trim() == "NaN" ||
        lineAngles.z.toString().trim() == "NaN" ||
        lineAngles.x.toString().trim() == "NaN") {
      lineAngles = vm.Vector3(0, 0, 0);
    } else {
      if (vector3.x < 0) {
        axisAngles = [0, (-1) * (lineAngles.y), lineAngles.z * (1)];
      } else {
        axisAngles = [0, (-1) * (lineAngles.y), lineAngles.z * 1];
      }
    }
    log("${vector3.x} lineangle ${lineAngles}\naxisAngles ${axisAngles}");
    // double z = get_squre_root_value_of_any_vector(vector3);
    double z = polygonRadius;
    // axisAngles = [0,0,0];
    double planeW = planeRectSize.width;
    double planeH = planeRectSize.height;
    return Transform(
        transform: Matrix4.rotationY(vector3.x < 0 ? m.pi : 0),
        child: Transform(
          transform: Matrix4.translationValues(0, 0, 0),
          child: Transform(
            transform: Matrix4.rotationX(axisAngles[0].degToRad())
              ..rotateY(axisAngles[1].degToRad())
              ..rotateZ(axisAngles[2].degToRad()),
            child: Transform(
              origin:
                  // Offset.zero,
                  Offset(planeW * 0.5, planeH * 0.5),
              transform: Matrix4.translationValues(
                  z, ytrans - planeH * 0.5, ztrans + planeW * 0.5),
              child: Transform(
                transform: Matrix4.rotationX(axisAngles[0].degToRad() * 0)
                  ..rotateY(axisAngles[1].degToRad() * 0 + 90.0.degToRad())
                  ..rotateZ(axisAngles[2].degToRad() * 0),
                child: child ??
                    Container(
                      width: planeW,
                      height: planeH,
                      color: (color).withAlpha(alpha),
                      child: Stack(
                        children: [
                          // Positioned(
                          //   left: planeW * 0.5 - 5,
                          //   top: planeH * 0.5 - 10,
                          //   child: Container(
                          //     width: 10,
                          //     height: 10,
                          //     // color: Colors.blue,
                          //   ),
                          // )
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ));
  }
}
