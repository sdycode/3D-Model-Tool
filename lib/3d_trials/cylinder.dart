import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'dart:math' as m;
import 'package:flutter/material.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'package:three_d_model_tool/math/angle_conversion.dart';

class CylinderDemoScreen extends StatefulWidget {
  CylinderDemoScreen({Key? key}) : super(key: key);

  @override
  State<CylinderDemoScreen> createState() => _CylinderDemoScreenState();
}

class _CylinderDemoScreenState extends State<CylinderDemoScreen> {
  List<double> rotAngles = [0, 0, 0];
  List<double> translateValues = [0, 0, 0];
  List<String> rotAnglesAxesNames = ["X", "Y", "Z"];
  double stepValue = 5;
  double cylinderHeight = 400;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(children: [
          slidersForManipulation(),
          xyzValuesChart(),
          threeDWidget()
        ]),
      ),
    );
  }

  // threeDWidget() {}

  slidersForManipulation() {
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
            child: Slider(
                min: 0.5,
                max: 40,
                divisions: 80,
                value: stepValue,
                onChanged: (double v) {
                  setState(() {
                    stepValue = v;
                  });
                }),
          ),
          Container(
            width: w,
            child: Slider(
                min: 100,
                max: 1000,
                divisions: 900,
                value: cylinderHeight,
                onChanged: (double v) {
                  setState(() {
                    cylinderHeight = v;
                  });
                }),
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

  xyzValuesChart() {
    return Positioned(
        right: 0,
        top: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...List.generate(3, (i) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rotAnglesAxesNames[i],
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          radToDeg(rotAngles[i]).toStringAsFixed(1),
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Container(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...List.generate(3, (i) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rotAnglesAxesNames[i],
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          radToDeg(translateValues[i]).toStringAsFixed(1),
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),

            SizedBox(
              height: 80,
            ),
            Row(
              children: [
                Text(
                  "No of Planes  ",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                Text(
                  "${(300 / stepValue).toInt()}",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )
              ],
            ),

            SizedBox(
              height: 80,
            ),
            Row(
              children: [
                Text(
                  "Cylinder Height  ",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                Text(
                  "${cylinderHeight.toInt()}",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )
              ],
            )
            //  (height / step).toInt()
          ],
        ));
  }

  threeDWidget() {
    return Container(
      width: w,
      height: h,
      child: CuboidForDemp(
        height: cylinderHeight,
        step: stepValue,
        rotAngles: rotAngles,
        translateValues: translateValues,
      ),
    );
  }
}

class CuboidForDemp extends StatelessWidget {
  CuboidForDemp(
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

  @override
  Widget build(BuildContext context) {
    double borderEdge = 2;
    int framesCount = (height / step).toInt();
    return Container(
      width: 500,
      height: 500,
      // color: Colors.green,
      child: Stack(children: [
        ...List.generate(framesCount, (i) {
          double w = 300;
          double h = 300;
          double left = 0;
          double top = 0;
          double zTranslate = 0;
          zTranslate = (i * step).toDouble();
          // Color mix = Color.fromARGB(255, (50+5*i)%255, (150+5*i)%255,  ((15*i-40)%255).abs());
          Color redWithShade =
              Colors.blue.withRed(((i / framesCount) * 255).toInt());
          Color rededWithShade =
              Colors.red.withGreen(((i / framesCount) * 255).toInt());
          Color greenShade =
              Colors.green.withBlue(((i / framesCount) * 255).toInt());
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
                      shape: BoxShape.circle,
                      color: greenShade,
                      border: (i == 0 || i == framesCount - 1)
                          ? Border.all(width: borderEdge)
                          : null),
                  // color:
                  // Colors.red.shade300,
                  child: Stack(fit: StackFit.expand, children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: borderEdge,
                        height: borderEdge,
                        color: Colors.black,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: borderEdge,
                        height: borderEdge,
                        color: Colors.black,
                      ),
                    ),
                  ])
                  //  Align(
                  //   alignment: Alignment.topRight,
                  //   child: Container(
                  //     width: 1,
                  //     height: 2,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  // redWithShade,
                  ),
            ),
          );
        })
      ]),
    );
  }
}
