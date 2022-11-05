import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'dart:math' as m;

class CustomPathExtrudeBoxPage extends StatefulWidget {
  CustomPathExtrudeBoxPage({Key? key}) : super(key: key);

  @override
  State<CustomPathExtrudeBoxPage> createState() =>
      _CustomPathExtrudeBoxPageState();
}

class _CustomPathExtrudeBoxPageState extends State<CustomPathExtrudeBoxPage> {
  bool showDrawCanvas = false;
  List<Offset> points = [];
  List<double> rotAngles = [0, 0, 0];
  List<double> translateValues = [0, 0, 0];
  List<String> rotAnglesAxesNames = ["X", "Y", "Z"];
  double stepValue = 5;
  double extrudeHeight = 400;
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
            // if (!showDrawCanvas)
            extrudeBodyWidget(),
            // if (showDrawCanvas)
            drawingCanvas(),
            slidersForManipulation(),
            drawButton()
          ]),
        ));
  }

  drawButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        child: Text(showDrawCanvas ? "Close Canvase" : "Draw Shape"),
        onPressed: () {
          showDrawCanvas = !showDrawCanvas;
          setState(() {});
        },
      ),
    );
  }

  int curntPanPointIndex = -1;
  Offset currentPoint = Offset.zero;
  drawingCanvas() {
    return Align(
        alignment: Alignment.topRight,
        child: Container(
          width: h * 0.7,
          height: h * 0.7,
          color: Colors.black38,
          child: Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  log("onhover ontap calledd");
                },
                onTapDown: (d) {
                  log("onhover ontapdown calledd");
                  currentPoint = d.localPosition;
                  if (checkCursorisOverlapping(d)) {
                    // currentPoint = d.localPosition;
                    log("onhover ontapdown currentPoint");
                  } else {
                    points.add(d.localPosition);
                    log("onhover ontapdown point added");
                  }

                  setState(() {
                    // log(points.toString());
                  });
                },
                onPanEnd: (d) {
                  log("onhover pandend delta  localPosition${currentPoint}");
                  curntPanPointIndex = -1;
                  currentPoint = Offset.zero;
                },
                onPanUpdate: (d) {
                  log("onhover panupdate delta  localPosition${currentPoint}");
                  if (curntPanPointIndex > -1 &&
                      curntPanPointIndex < points.length) {
                    points[curntPanPointIndex] = d.localPosition;
                    setState(() {});
                  }
                },
                child: MouseRegion(
                  child: IgnorePointer(
                    ignoring: false,
                    child: Container(
                      width: h * 0.7,
                      height: h * 0.7,
                      color: Colors.black26,
                      child: Stack(children: [
                        polygon(),
                      ]),
                    ),
                  ),
                ),
              ),
              Stack(children: [
                ...List<Widget>.generate(points.length, (index) {
                  Offset e = points[index];
                  return Positioned(
                    left: e.dx - 2,
                    top: e.dy - 2,
                    child: MouseRegion(
                      opaque: false,
                      hitTestBehavior: HitTestBehavior.translucent,
                      onEnter: (e) {
                        curntPanPointIndex = index;
                      },
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.red.shade300,
                      ),
                    ),
                  );
                }),
              ]),
            ],
          ),
        ));
  }

  polygon() {
    return points.length > 2
        ? CustomPaint(
            size: Size(h * 0.7, h * 0.7),
            painter: PolygonPainter(
              points,
            ),
          )
        : Container();
  }

  slidersForManipulation() {
    return Positioned(
      bottom: 0,
      left: 0,
      // alignment: Alignment.bottomCenter,
      child: Container(
        width: w * 0.92,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            stepValueSlider(),
            // topbottomradiusSlider(),
            cylinderHeightSlider(),
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
      ),
    );
  }

  cylinderHeightSlider() {
    return Container(
      width: w,
      child: Slider(
          min: 100,
          max: 1000,
          divisions: 900,
          value: extrudeHeight,
          onChanged: (double v) {
            setState(() {
              extrudeHeight = v;
            });
          }),
    );
  }

  stepValueSlider() {
    return Container(
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
    );
  }

  bool checkCursorisOverlapping(TapDownDetails d) {
    bool overlapping = false;
    points.forEach((e) {
      if ((d.localPosition.dx - e.dx).abs() < 6 &&
          (d.localPosition.dy - e.dy).abs() < 6) {
        overlapping = true;
      }
    });

    return overlapping;
  }

  extrudeBodyWidget() {
    return Container(
      width: w,
      height: h,
      color: Colors.amber.shade100,
      child: Extrudebody(
        points: points,
        height: extrudeHeight,
        step: stepValue,
        rotAngles: rotAngles,
        translateValues: translateValues,
      ),
    );
  }
}

class Extrudebody extends StatelessWidget {
  Extrudebody({
    Key? key,
    required this.points,
    required this.height,
    required this.step,
    required this.rotAngles,
    required this.translateValues,
  }) : super(key: key);
  final List<Offset> points;
  final height;
  final step;

  List<double> rotAngles;
  List<double> translateValues;
  @override
  Widget build(BuildContext context) {
    double borderEdge = 2;
    int framesCount = (height / step).toInt();
    return Container(
      // width: 500,
      // height: 500,
      color: Color.fromARGB(255, 191, 223, 249),
      child: Stack(children: [
        ...List.generate(framesCount, (i) {
          double left = 0;
          double top = 0;
          Size size = getBoxSizeFromPoints(points);
          double w = size.width;
          double h = size.height;
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
              child: ClipPath(
                clipper: CustomClipperShape(points),
                child: Container(
                    width: w,
                    height: h,
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      color: greenShade,
                      // border: (i == 0 || i == framesCount - 1)
                      //     ? Border.all(width: borderEdge)
                      //     : null
                    ),
                    // color:
                    // Colors.red.shade300,
                    child: (i == 0 || i == framesCount - 1)
                        ? CustomPaint(
                            painter: PathPainter(points),
                            size: Size(w, h),
                          )
                        : CustomPaint(
                            painter: PointPainter(points),
                            size: Size(w, h),
                          )),
              ),
            ),
          );
        })
      ]),
    );
  }

  Size getBoxSizeFromPoints(List<Offset> points) {
    Size size = Size.zero;
    double minx = 0;
    double miny = 0;
    double maxx = 0;
    double maxy = 0;
    for (var i = 0; i < points.length; i++) {
      minx = m.min(points[i].dx, minx);
      miny = m.min(points[i].dy, miny);
      maxx = m.max(points[i].dx, maxx);
      maxy = m.max(points[i].dx, maxy);
    }
    return Size((maxx - minx).abs(), (maxy - miny).abs());
  }
}

class PointPainter extends CustomPainter {
  List<Offset> points;
  PointPainter(this.points);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    for (var i = 1; i < points.length - 1; i++) {
      canvas.drawCircle(points[i], 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PathPainter extends CustomPainter {
  List<Offset> points;
  PathPainter(this.points);
  @override
  void paint(Canvas canvas, Size s) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    double h = s.height;
    double w = s.width;
    // created a path
    Path path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class CustomClipperShape extends CustomClipper<Path> {
  List<Offset> points;
  CustomClipperShape(this.points);
  @override
  Path getClip(Size s) {
    //declared the variavles
    double h = s.height;
    double w = s.width;
    // created a path
    Path path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class PolygonPainter extends CustomPainter {
  List<Offset> points;
  PolygonPainter(this.points);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2;
    Path path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    canvas.drawPath(path, paint);
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
