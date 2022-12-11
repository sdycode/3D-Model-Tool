import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/extensions.dart';

double _h = 200;
double _w = 200;

class Loading_bouncing_box_animation extends StatefulWidget {
  Loading_bouncing_box_animation({Key? key}) : super(key: key);

  @override
  State<Loading_bouncing_box_animation> createState() =>
      _Loading_bouncing_box_animationState();
}

class _Loading_bouncing_box_animationState
    extends State<Loading_bouncing_box_animation>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    // TODO: implement initState
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 16));
    controller.forward();
    controller.repeat();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    controller.addListener(() {
      d.log("controoler ${controller.status}");
      if (controller.status == AnimationStatus.forward && !isForward) {
        isForward = true;
        totalAng -= 0.5 * pi;
        setState(() {});
      }
      if (controller.status == AnimationStatus.reverse && isForward) {
        isForward = false;

        setState(() {});
      }
    });
    animation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  int count = 0;
  bool isForward = true;

  double totalAng = 0;
  double maxn = 0;
  Radius minorRadius = const Radius.circular(30);
  Radius majorRadius = const Radius.circular(100);
  @override
  Widget build(BuildContext context) {
    _w = MediaQuery.of(context).size.width;
    _h = MediaQuery.of(context).size.height;
    // _getCornerRadius();
    maxn = max(maxn, ((animation.value * 100.toInt() % 50) / 100) * 300);
    // d.log(        "value  $maxn / ${((animation.value * 100.toInt() % 50) / 100) * 300}");

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: _w,
        height: _h,
        child: Stack(
          fit: StackFit.loose,
          children: [
            Positioned(
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (controller.isCompleted || controller.isDismissed) {
                          controller.forward();
                        }
                        if (controller.isAnimating) {
                          controller.stop();
                        } else {
                          controller.forward();
                        }
                      });
                    },
                    child: Text("bbbb"))),
            Positioned(
                left: 100,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        controller.reset();
                        controller.forward();
                        controller.repeat();
                        // if(animation.value ==1.0){

                        // }
                      });
                    },
                    child: Text(
                      "${animation.value.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 40),
                    ))),
            Positioned(
              left: _w * 0.4,
              top: _h * 0.2,
              child: Container(
                width: _w * 0.2,
                height: _w * 0.2,
                child: Transform.translate(
                  offset: Offset(
                      0,
                      // 0
                      //  animation.value*100
                      _getYOffsetForAnimationValue(animation)),
                  child: Transform(
                    origin: Offset(_w * 0.2 * 0.5, _w * 0.2 * 0.5),
                    transform: Matrix4.rotationZ(
                        pi * 0.25 + animation.value * (2 * pi)),
                    // ..translate(0,((animation.value*100.toInt()%50)/100),0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: _getCornerRadius(Alignment.topLeft),
                        topRight: _getCornerRadius(Alignment.topRight),
                        bottomLeft: _getCornerRadius(Alignment.bottomLeft),
                        bottomRight: _getCornerRadius(Alignment.bottomRight),
                      ),
                      child: Container(
                        width: _w * 0.2,
                        height: _w * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(_w * 0.05)

                              //  _w*0.05
                              ),
                          color: Colors.white,
                        ),
                        child: Stack(fit: StackFit.loose, children: [
                          Container(
                            width: _w * 0.2,
                            height: _w * 0.2,
                          ),
                          ...List.generate(4, (i) {
                            return Align(
                              alignment: _getAlign(i),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.primaries[i * 2],
                              ),
                            );
                          })
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                right: 120,
                child: Container(
                  height: _h * 0.8 * animation.value,
                  width: 80,
                  color: animation.value < 0.5
                      ? Colors.red.shade600
                      : Colors.amber.shade100,
                ))
          ],
        ),
      ),
    );
  }

  double _getYOffsetForAnimationValue(Animation<double> animation) {
    // For each 90 degree 1 oscillation
    // i.e for 1st 45 : go down and Next 45 go up
    // for 1st oscilation i.e [ 0 - 0.25 ] -->[ 0.125,0.25]
    double fullLength = 400;
    double shortLength = fullLength / 8;
    if (valueLiesBetween(0, 0.25, animation.value)) {
      if (valueLiesBetween(0, 0.125, animation.value)) {
        return ((animation.value * 1000.toInt() % 125) / 1000) * fullLength;
      } else {
        return shortLength -
            ((animation.value * 1000.toInt() % 125) / 1000) * fullLength;
      }
    }
    if (valueLiesBetween(0.25, 0.5, animation.value)) {
      if (valueLiesBetween(0.25, 0.375, animation.value)) {
        return ((animation.value * 1000.toInt() % 125) / 1000) * fullLength;
      } else {
        return shortLength -
            ((animation.value * 1000.toInt() % 125) / 1000) * fullLength;
      }
    }
    if (valueLiesBetween(0.5, 0.75, animation.value)) {
      if (valueLiesBetween(0.5, 0.625, animation.value)) {
        return ((animation.value * 1000.toInt() % 125) / 1000) * fullLength;
      } else {
        return shortLength -
            ((animation.value * 1000.toInt() % 125) / 1000) * fullLength;
      }
    }
    if (valueLiesBetween(0.75, 1.0, animation.value)) {
      if (valueLiesBetween(0.75, 0.875, animation.value)) {
        return ((animation.value * 1000.toInt() % 125) / 1000) * fullLength;
      } else {
        return shortLength -
            ((animation.value * 1000.toInt() % 125) / 1000) * fullLength;
      }
    }
    return 0;
  }

  valueLiesBetween(double min, double max, double value) {
    if (value >= min && value < max) {
      return true;
    }
    return false;
  }

  Radius _getCornerRadius(Alignment alignment) {
       if (Alignment.bottomLeft == alignment) {
      if (valueLiesBetween(0.125, 0.125 + 0.25, animation.value)) {
        return majorRadius;
      }
      return minorRadius;
    }
    if (Alignment.topLeft == alignment) {
      if (valueLiesBetween(0.375, 0.375 + 0.25, animation.value)) {
        return majorRadius;
      }
      return minorRadius;
    }
 if (Alignment.topRight == alignment) {
      if (valueLiesBetween(0.625, 0.625 + 0.25, animation.value)) {
        return majorRadius;
      }
      return minorRadius;
    }

     if (Alignment.bottomRight == alignment) {
      if (valueLiesBetween(0.875, 0.875 + 0.25, animation.value)) {
        return majorRadius;
      }
      return minorRadius;
    }
    // double i = ((animation.value * 1000.toInt() / 125) / 8) * 8;
    // int j = i.round();
    // int k = i.round() % 2;
    // d.log("ii ${j-k} /  ${animation.value}");
    // switch (j-k) {
    //   case 0:
    //     return Alignment.topLeft==alignment ?majorRadius :minorRadius;
    //   case 2:
    //     return Alignment.topRight==alignment ?majorRadius :minorRadius;
    //   case 4:
    //     return Alignment.bottomRight==alignment ?majorRadius :minorRadius;
    //   case 6:
    //     return Alignment.bottomLeft==alignment ?majorRadius :minorRadius;

    //     break;
    //   default:
    //     return minorRadius;
    // }
    return minorRadius;
  }

  _getAlign(int i) {
    switch (i) {
      case 0:
        return Alignment.topLeft;
      case 1:
        return Alignment.topRight;
      case 2:
        return Alignment.bottomRight;
      case 3:
        return Alignment.bottomLeft;

        break;
      default:
        return Alignment.topLeft;
    }
  }
}
