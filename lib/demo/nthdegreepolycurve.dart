import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/2D%20Geometris/curve1.dart';
import 'package:three_d_model_tool/constants/consts.dart';

class NthDegreePolyCurvePage extends StatefulWidget {
  NthDegreePolyCurvePage({Key? key}) : super(key: key);

  @override
  State<NthDegreePolyCurvePage> createState() => _NthDegreePolyCurvePageState();
}

class _NthDegreePolyCurvePageState extends State<NthDegreePolyCurvePage>
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
    animation = CurvedAnimation(
      parent: controller,
      curve: CurveOf_n_Degree(2),
    );
    animation.addListener(() {
      log("va ${animation.value}");
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // log("va in build ${animation.value}");
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: w,
        height: h,
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              child: Text("Start Animation"),
              onPressed: () {
                controller.reset();

                controller.forward();
              },
            ),
          ),
          Positioned(
              left: 50,
              top: animation.value * (h - 100),
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 30,
              )),
          Positioned(
            left: 200,
              child: Container(
            width: w -200,
            height: h * 0.9,
            child: ListView.builder(
              
              itemCount: 30,
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, i) {
              return NthDegreeCurveAnimationBoxForDemo(
                controller: controller,
                degree: i,
              );
            }),
          ))
        ]),
      ),
    );
  }
}

class NthDegreeCurveAnimationBoxForDemo extends StatefulWidget {
  final int degree;
  // final double animValue;
  final AnimationController controller;
  const NthDegreeCurveAnimationBoxForDemo(
      {Key? key,
      required this.degree,
      // required this.animValue,
      required this.controller})
      : super(key: key);

  @override
  State<NthDegreeCurveAnimationBoxForDemo> createState() =>
      _NthDegreeCurveAnimationBoxForDemoState();
}

class _NthDegreeCurveAnimationBoxForDemoState
    extends State<NthDegreeCurveAnimationBoxForDemo>
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
      color: Colors.primaries[widget.degree%Colors.primaries.length].shade100,
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
