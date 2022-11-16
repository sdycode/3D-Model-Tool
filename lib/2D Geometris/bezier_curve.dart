import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/2D%20Geometris/curve1.dart';
import 'package:three_d_model_tool/constants/consts.dart';

class BezeirCurvePage extends StatefulWidget {
  BezeirCurvePage({Key? key}) : super(key: key);

  @override
  State<BezeirCurvePage> createState() => _BezeirCurvePageState();
}

// List<Offset> points = [
//   Offset.zero,
//   Offset(h * 0.2, h * 0.2),
//   Offset(h * 0.2, h * 0.2),
//   Offset(h * 0.4, h * 0.4)
// ];
double boxsize = h * 0.4;
List<Offset> points = [
  Offset.zero,
  Offset(boxsize * cubics[0], boxsize * cubics[1]),
  Offset(boxsize * cubics[2], boxsize * cubics[3]),
  Offset(boxsize, boxsize),
];
// 0.215, 0.61, 0.355, 1.0
List<double> cubics = [
  // 0.25, 0.46, 0.45, 0.94
  0.215, 0.61, 0.355, 1.0,
  // 0.18, 1.0, 0.04, 1.0
];

List<double> pointsToCubicDecimalValues(
    List<Offset> points, Offset origin, Offset oppositeCorner) {
  double maxY = (origin.dy - oppositeCorner.dy).abs();
  return points.map((e) {
    return e.dy / maxY;
  }).toList();
}

class _BezeirCurvePageState extends State<BezeirCurvePage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animation = CurvedAnimation(
      parent: controller,
      curve: BezierCurve(points),
      reverseCurve: Curves.easeOut,
    );
    animation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  late AnimationController controller;
  late Animation<double> animation;
  setAnimation() {
    animation = CurvedAnimation(
      parent: controller,
      curve: BezierCurve(points),
      reverseCurve: Curves.easeOut,
    );
  }

  List<List<Offset>> listOfPointsList = [];
  List<CurvedAnimation> animations = [];
  addNewPointsSet() {
    listOfPointsList.add(List.from(points));
    CurvedAnimation tempAnimation = CurvedAnimation(
      parent: controller,
      curve: BezierCurve(listOfPointsList.last),
      reverseCurve: Curves.easeOut,
    );

    animations.add(tempAnimation);
    animations.last.addListener(() {
      setState(() {});
    });
  }

  Offset curveEditorBoxPosition = Offset.zero;
  @override
  Widget build(BuildContext context) {
    //  cubics= pointsToCubicDecimalValues(points, points.first, points.last);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(fit: StackFit.loose, children: [
          Container(
            width: w,
            height: h,
          ),
          Positioned(
            left: curveEditorBoxPosition.dx,
            top: curveEditorBoxPosition.dy,
            child: 
            
            Stack(
              clipBehavior: Clip.none,
              children: [ 
              
              Container(
            width: w,
            height: h,
          ),
  GestureDetector(
              onPanUpdate: (d) {
                setState(() {
                  curveEditorBoxPosition = Offset(
                      curveEditorBoxPosition.dx + d.delta.dx,
                      curveEditorBoxPosition.dy + d.delta.dy);
                });
              },
              child: Container(
                width: boxsize + 10,
                height: boxsize + 10,
                color: Colors.amber.shade100,
                child: Transform.rotate(
                  origin: Offset.zero,
                  // Offset(boxsize*0.5, boxsize*0.5),
                  angle: pi * 0.5 * 0,
                  child: CustomPaint(
                    size: Size(boxsize, boxsize),
                    painter: BezeirPaint(),
                  ),
                ),
              ),
            ),
              ...List.generate(points.length, (i) {
            return Positioned(
              left: points[i].dx,
              top: points[i].dy,
              child: GestureDetector(
                onPanUpdate: (d) {
                  setState(() {
                    points[i] = Offset(
                        points[i].dx + d.delta.dx, points[i].dy + d.delta.dy);
                  });
                },
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: (i == 0 || i == points.length - 1)
                      ? Colors.deepPurple
                      : Colors.red,
                ),
              ),
            );
          })
          
            ],),),
          
          // 
          Positioned(
            left: boxsize * 0.3,
            top: boxsize + 100,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red,
              child: Center(
                child: IconButton(
                    onPressed: () {
                      addNewPointsSet();
                      setState(() {});
                    },
                    icon: Icon(Icons.add_circle_rounded)),
              ),
            ),
          ),
          Positioned(
            left: boxsize * 0.3 + 60,
            top: boxsize + 100,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red,
              child: Center(
                child: IconButton(
                    onPressed: () {
                      controller.reset();
                      controller.forward();
                    },
                    icon: Icon(Icons.start)),
              ),
            ),
          ),
          Positioned(
              top: h * 0.6,
              child: Listener(
                onPointerDown: (event) {
                  d.log("onpointerdown parent $event");
                },
                child: Stack(
                  children: [
                    Listener(
                        onPointerDown: (event) {
                          d.log("onpointerdown 2  $event");
                        },
                        child: Container(
                          color: Colors.red,
                          width: 100,
                          height: 100,
                        )),
                    Listener(
                        onPointerDown: (event) {
                          d.log("onpointerdown 1  $event");
                        },
                        child: Container(
                          color: Colors.amber.withAlpha(150),
                          width: 50,
                          height: 50,
                        )),
                  ],
                ),
              )),
          Positioned(
            left: boxsize + 50,
            top: 0,
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                  width: w - boxsize * 1.2,
                  height: h,
                  child: ListView.builder(
                      itemCount: animations.length,
                      itemBuilder: (c, i) {
                        return _AnimCurveBoard(
                          animValue: animations[i].value,
                          no: i,
                        );
                      }),
                ),
            ),
          ),
        
        ]),
      ),
    );
  }
}

class _AnimCurveBoard extends StatelessWidget {
  final int no;
  final double animValue;
  const _AnimCurveBoard({Key? key, required this.no, required this.animValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // d.log("boxsize $animValue");
    return Container(
      width: w - boxsize * 1.2,
      height: 50,
      color: Colors.primaries[no % Colors.primaries.length].shade100,
      child: Stack(fit: StackFit.expand, children: [
        Positioned(
          top: 0,
          left: animValue * (w - boxsize * 1.2 - 50),
          child: Center(
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.primaries[no % Colors.primaries.length],
            ),
          ),
        )
      ]),
    );
  }
}

class BezeirCubicModel {
  List<Offset> points = [
    Offset.zero,
    Offset.zero,
    Offset.zero,
    Offset.zero,
  ];
  BezeirCubicModel(this.points);
  Offset getPointAt(double t) {
    double x = points[0].dx * pow(1 - t, 3) +
        points[1].dx * pow(1 - t, 2) * 3 * t +
        points[2].dx * pow(1 - t, 1) * 3 * t * t +
        points[3].dx * pow(t, 3);

    double y = points[0].dy * pow(1 - t, 3) +
        points[1].dy * pow(1 - t, 2) * 3 * t +
        points[2].dy * pow(1 - t, 1) * 3 * t * t +
        points[3].dy * pow(t, 3);
    return Offset(x, y);
  }

  double getYValueFor_t(double t) {
    double y = points[0].dy * pow(1 - t, 3) +
        points[1].dy * pow(1 - t, 2) * 3 * t +
        points[2].dy * pow(1 - t, 1) * 3 * t * t +
        points[3].dy * pow(t, 3);
    return y;
  }
}

class BezeirPaint extends CustomPainter {
  /// Berzier Paramteric equation
  /// P(t) = B0(1-t)3 + B13t(1-t)2 + B23t2(1-t) + B3t3
  /// Bn are controll points

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.red;
    Path path = Path();

    path.moveTo(points.first.dx, points.first.dy);
    path.cubicTo(points[1].dx, points[1].dy, points[2].dx, points[2].dy,
        points[3].dx, points[3].dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
