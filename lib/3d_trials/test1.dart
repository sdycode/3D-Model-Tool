import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'dart:math' as m;
import 'package:vector_math/vector_math_64.dart' as vm64;
import 'package:vector_math/vector_math.dart' as vm;
import 'package:vector_math/vector_math_geometry.dart' as vmg;
import 'package:vector_math/vector_math_lists.dart' as vml;
import 'package:vector_math/vector_math_operations.dart' as vmop;

class Test1Page extends StatefulWidget {
  Test1Page({Key? key}) : super(key: key);

  @override
  State<Test1Page> createState() => _Test1PageState();
}

class _Test1PageState extends State<Test1Page> {
  List<double> rotAngles = [0, 0, 0];
  List<double> translateValues = [0, 0, 0];
  List<String> rotAnglesAxesNames = ["X", "Y", "Z"];
  Offset panOffset = Offset.zero;
  @override
  Widget build(BuildContext context) {
    // vm.Vector2(50, 60);
    // vm.Vector3(50, 60, 70);
    // Matrix4 matrix4 = Matrix4.identity();
    // matrix4.storage;
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    // Matrix4.skew(alpha, beta)
    // log("matrix4 $matrix4");

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          GestureDetector(
            onPanUpdate: (d) {
              panOffset =
                  Offset(panOffset.dx + d.delta.dx, panOffset.dy + d.delta.dy);
              setState(() {});
              log("panoff ${panOffset.toString()}");
            },
            child: Stack(
              children: [
                Container(
                  height: h,
                  width: w,
                  color: Colors.black87,
                ),
                // Positioned(
                //     left: 100,
                //     top: 200,
                //     child: Transform(
                //       transform: Matrix4.rotationX(rotAngles[0])
                //         ..rotateY(rotAngles[1])
                //         ..rotateZ(rotAngles[2])
                //         ..translate(translateValues[0], translateValues[1],
                //             translateValues[2])
                //         ..perspectiveTransform(vm64.Vector3(10, 20, 30)),
                //       child: Container(
                //         height: 200,
                //         width: 320,
                //         // color: Colors.amber,
                //         child: Image.asset(
                //           "assets/earth/4096_earth.jpg",
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     )),

                //  ---------------------------

                //
                // Positioned(
                //   left: 100 + panOffset.dx,
                //   top: 200 + panOffset.dy,
                //   child: Transform(
                //     transform: Matrix4.rotationX(rotAngles[0])
                //       ..rotateY(rotAngles[1])
                //       ..rotateZ(rotAngles[2])
                //       ..translate(translateValues[0], translateValues[1],
                //           translateValues[2] + 50),
                //     child: Container(
                //       width: 300,
                //       height: 200,
                //       color: Colors.red,
                //     ),
                //   ),
                // ),
                // Positioned(
                //   left: 100 + panOffset.dx,
                //   top: 200 + panOffset.dy,
                //   child: Transform(
                //     transform: Matrix4.rotationX(rotAngles[0])
                //       ..rotateY(rotAngles[1])
                //       ..rotateZ(rotAngles[2])
                //       ..translate(translateValues[0], translateValues[1],
                //           translateValues[2] + 70),
                //     child: Container(
                //       width: 300,
                //       height: 200,
                //       color: Colors.amber,
                //     ),
                //   ),
                // ),
                // Positioned(
                //   left: 100 + panOffset.dx,
                //   top: 200 + panOffset.dy,
                //   child: Transform(
                //     transform: Matrix4.rotationX(rotAngles[0])
                //       ..rotateY(rotAngles[1])
                //       ..rotateZ(rotAngles[2])
                //       ..translate(translateValues[0], translateValues[1],
                //           translateValues[2] + 90),
                //     child: Container(
                //       width: 300,
                //       height: 200,
                //       color: Colors.blue,
                //     ),
                //   ),
                // ),
                Positioned(
                    left: panOffset.dx,
                    top: panOffset.dy,
                    child: Cuboid(
                      height: 300,
                      step: 0.5 * 2 * 2,
                      rotAngles: rotAngles,
                      translateValues: translateValues,
                    )), // ...getFrustumPyramidData(height: 300, step: 0.5),
                // ...    getFrustumPyramidData(
                //   // initial: Size(300, 200), fin
                //   height: 300, step: 0.5
                //   ),
                angleSliders()
              ],
            ),
          ),
        ],
      ),
    );
  }

  angleSliders() {
    return Positioned(
      bottom: 0,
      left: 0,
      // alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(
              3,
              (i) => Container(
                  width: w,
                  child: Row(
                    children: [
                      Text(
                        rotAnglesAxesNames[i],
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Slider(
                            min: -m.pi,
                            max: m.pi,
                            divisions: 720,
                            value: rotAngles[i],
                            onChanged: (double v) {
                              setState(() {
                                rotAngles[i] = v;
                              });
                            }),
                      ),
                      Expanded(
                        child: Slider(
                            min: -500,
                            max: 500,
                            divisions: 500,
                            value: translateValues[i],
                            onChanged: (double v) {
                              setState(() {
                                translateValues[i] = v;
                              });
                            }),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }
}

class Cuboid extends StatelessWidget {
  Cuboid(
      {Key? key,
      required this.height,
      required this.step,
      required this.rotAngles,
      required this.translateValues})
      : super(key: key);
  final height;
  final step;
  List<double> rotAngles;
  List<double> translateValues;
  // List<String> rotAnglesAxesNames = ["X", "Y", "Z"];
  @override
  Widget build(BuildContext context) {
    int framesCount = (height / step).toInt();
    return Container(
      width: 500,
      height: 400,
      // color: Colors.green,
      child: Stack(children: [
        ...List.generate(framesCount, (i) {
          double w = 300;
          double h = 200;
          double left = 0;
          double top = 0;
          double zTranslate = 0;
          zTranslate = (i * step).toDouble();
          // Color mix = Color.fromARGB(255, (50+5*i)%255, (150+5*i)%255,  ((15*i-40)%255).abs());
          Color redWithShade =
              Colors.blue.withRed(((i / framesCount) * 255).toInt());
          return Positioned(
            left: left,
            top: top,
            child: Transform(
              transform: Matrix4.rotationX(rotAngles[0])
                ..rotateY(rotAngles[1])
                ..rotateZ(rotAngles[2])
                ..translate(translateValues[0], translateValues[1],
                    translateValues[2] + zTranslate),
              child: Container(
                width: w,
                height: h,
                decoration: BoxDecoration(color: redWithShade
                    // border: Border(top: BorderSide.)
                    ),
                // color:
                // Colors.red.shade300,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 1,
                    height: 2,
                    color: Colors.black,
                  ),
                ),
                // redWithShade,
              ),
            ),
          );
        })
      ]),
    );
    // Stack(
    //   children: [
    //     ...List.generate(framesCount, (i) {
    //       double w = 300;
    //       double h = 200;
    //       double left = 0;
    //       double top = 0;
    //       double zTranslate = 0;
    //       zTranslate = (i * step).toDouble();
    //       // Color mix = Color.fromARGB(255, (50+5*i)%255, (150+5*i)%255,  ((15*i-40)%255).abs());
    //       Color redWithShade =
    //           Colors.blue.withRed(((i / framesCount) * 255).toInt());
    //       return Positioned(
    //         left: left ,
    //         top: top ,
    //         child: Transform(
    //           transform: Matrix4.rotationX(rotAngles[0])
    //             ..rotateY(rotAngles[1])
    //             ..rotateZ(rotAngles[2])
    //             ..translate(translateValues[0], translateValues[1],
    //                 translateValues[2] + zTranslate),
    //           child: Container(
    //             width: w,
    //             height: h,
    //             color: redWithShade,
    //           ),
    //         ),
    //       );
    //     })
    //   ],
    // );
  }

  // Widget getFrustumPyramidData(
  //     {
  //     // required Size initial, required Size last,
  //     //   required Offset initialOrigin, required Offset finalOrigin,

  //     required double height,
  //     required double step}) {
  //   log("countframes $framesCount");
  //   return
  // }

}
