import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'dart:math' as m;
import 'package:vector_math/vector_math_64.dart' as vm64;
import 'package:vector_math/vector_math.dart' as vm;
import 'package:vector_math/vector_math_geometry.dart' as vmg;
import 'package:vector_math/vector_math_lists.dart' as vml;
import 'package:vector_math/vector_math_operations.dart' as vmop;

class RectangleFrustumPage extends StatefulWidget {
  RectangleFrustumPage({Key? key}) : super(key: key);

  @override
  State<RectangleFrustumPage> createState() => _RectangleFrustumPageState();
}

class _RectangleFrustumPageState extends State<RectangleFrustumPage> {
  double step = 1;
  List<double> rotAngles = [0, 0, 0];
  List<double> translateValues = [0, 0, 0];
  List<String> rotAnglesAxesNames = ["X", "Y", "Z"];
  Offset panOffset = Offset.zero;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

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
                Positioned(
                    left: panOffset.dx,
                    top: panOffset.dy,
                    child: RectangleFrustum(
                      smallToBigAreaRatio: 0.2,
                      height: 500,
                      step: step,
                      rotAngles: rotAngles,
                      translateValues: translateValues,
                    )),
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
          Container(
            width: w,
            height: 40,
            child: Row(
              children: [
                Text(
                  "Planes",
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(
                  child: Slider(
                      min: 0.4,
                      max: 20,
                      divisions: 200,
                      value: step,
                      onChanged: (double v) {
                        setState(() {
                          step = v;
                        });
                      }),
                ),
              ],
            ),
          ),
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

class RectangleFrustum extends StatelessWidget {
  RectangleFrustum(
      {Key? key,
      required this.height,
      required this.step,
      required this.rotAngles,
      required this.translateValues,
      required this.smallToBigAreaRatio})
      : super(key: key);
  final height;
  final step;
  final List<double> rotAngles;
  final List<double> translateValues;
  final smallToBigAreaRatio;
  // List<String> rotAnglesAxesNames = ["X", "Y", "Z"];
  @override
  Widget build(BuildContext context) {
    int framesCount = (height / step).toInt();
    log("build called on RectangleFrustum ${m.Random().nextInt(20)} ");
    return Container(
      width: 500,
      height: 500,
      // color: Colors.green,
      child: Stack(children: [
        ...List.generate(framesCount, (i) {
          double w = 300 * smallToBigAreaRatio +
              300 * (1 - smallToBigAreaRatio) * (i / framesCount);
          double h = 300 * smallToBigAreaRatio +
              300 * (1 - smallToBigAreaRatio) * (i / framesCount);
          double left = 150 - w * 0.5;
          double top = 150 - h * 0.5;
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
                  decoration: BoxDecoration(
                      color: redWithShade,
                      border: (i == 0 || i == framesCount - 1)
                          ? Border.all()
                          : null),
                  // color:
                  // Colors.red.shade300,
                  child: Stack(fit: StackFit.expand, children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 1,
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 1,
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: 1,
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 1,
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                  ])
                  // redWithShade,
                  ),
            ),
          );
        })
      ]),
    );
  }
}
