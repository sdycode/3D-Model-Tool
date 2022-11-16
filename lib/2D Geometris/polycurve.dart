import 'package:flutter/material.dart';
import 'package:three_d_model_tool/2D%20Geometris/bezier_curve.dart';
import 'package:three_d_model_tool/2D%20Geometris/curve1.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'package:three_d_model_tool/extensions.dart';

class PolyCurvePage extends StatefulWidget {
  PolyCurvePage({Key? key}) : super(key: key);

  @override
  State<PolyCurvePage> createState() => _PolyCurvePageState();
}


class _PolyCurvePageState extends State<PolyCurvePage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
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
    // animation = CurvedAnimation(
    //   parent: controller,
    //   curve: CurveOf_n_Degree(3),
    //   reverseCurve: Curves.easeOut,
    // );
    // animation.addListener(() {
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: w,
        height: h,
        child: Stack(
          children: [
            Container(
              height: h * 0.8,
              width: w,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (c, i) {
                    return NthDegreeCurveAnimationBox(
                      degree: i,
                      controller: controller,
                    );
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        controller.reset();
                        controller.forward();
                      },
                      child: Text("Start Animation"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _painter1() {
    return CustomPaint(
      size: Size(h * 0.6, h * 0.6),
      painter: _Painter1(),
    );
  }
}

class NthDegreeCurveAnimationBox extends StatefulWidget {
  final int degree;
  // final double animValue;
  final AnimationController controller;
  const NthDegreeCurveAnimationBox(
      {Key? key,
      required this.degree,
      // required this.animValue,
      required this.controller})
      : super(key: key);

  @override
  State<NthDegreeCurveAnimationBox> createState() =>
      _NthDegreeCurveAnimationBoxState();
}

class _NthDegreeCurveAnimationBoxState extends State<NthDegreeCurveAnimationBox>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animation = CurvedAnimation(
      parent: widget.controller,
      curve: CurveOf_n_Degree(widget.degree),
      reverseCurve: Curves.easeOut,
    );
    animation?.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w * 0.05,
      height: h * 0.7,
      color: Colors.primaries[widget.degree].shade100,
      child: Column(
        children: [
          Text(
            widget.degree.toString(),
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
              child: Container(
                  width: w * 0.05,
                  height: h * 0.6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                          top: ((animation != null)
                                  ? (animation?.value)
                                  : 0.5)! *
                              h *
                              0.5,
                          child: Container(
                            width: w * 0.05,
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.primaries[
                                    widget.degree % Colors.primaries.length],
                                radius: 20,
                              ),
                            ),
                          ))
                    ],
                  )))
        ],
      ),
    );
  }
}

class _Painter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 3;
    Path path = Path();
    path.moveTo(50, 50);

    // path.arcTo(Rect.fromPoints(Offset(50, 50), Offset(200, 200)),
    //     20.0.degToRad(), 120.0.degToRad(), true);

    // path.moveTo(100, 100);
    // path.conicTo(300, 450, 200, 100, 1*2*0.2);

    // path.cubicTo(x1, y1, x2, y2, x3, y3)

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
