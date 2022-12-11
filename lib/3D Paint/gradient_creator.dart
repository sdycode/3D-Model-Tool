import 'dart:developer';
import 'dart:math' as m;

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'package:three_d_model_tool/provider/gradient_provider.dart';

class ColorStopModel {
  double colorStop;
  String hexColorString;
  ColorStopModel(this.colorStop, this.hexColorString);
  ColorStopModel.withStopValue(this.colorStop,
      [this.hexColorString = "ffffffff"]);
  factory ColorStopModel.copy(ColorStopModel model) {
    return ColorStopModel(model.colorStop, model.hexColorString);
  }
}
  late double colorListBoxW ;//= w * 0.25;
  late double colorListBoxH ;//= h = 0.6;
  late double sliderWidth ;//= w * 0.7;
  late double gradeSelectBoxW ;//= h * 0.1;
  late double demoBoxSizeW ;//= h * 0.4;
  late double demoBoxSizeH ;//= h * 0.4;
  late double tileModeW ;//= h * 0.1;
  late double pointRad ;//= 12;
class GradientCreator extends StatefulWidget {
  GradientCreator({Key? key}) : super(key: key);

  @override
  State<GradientCreator> createState() => _GradientCreatorState();
}

class _GradientCreatorState extends State<GradientCreator> {
  late GradProvider gradProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // GradProvider grad = Provider.of(context, listen: false);
    //         log("demoo beff inits ${demoBoxSizeW} / $demoBoxSizeH /");

    // grad.updateAlignPointsForBoxSize(Size(demoBoxSizeW, demoBoxSizeH));
  }

  List<Color> pointColors = const [Colors.red, Color.fromARGB(255, 38, 10, 74)];

  
  @override
  Widget build(BuildContext context) {
   double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
        w = MediaQuery.of(context).size.width;
        h = MediaQuery.of(context).size.height;
    colorListBoxW = sw * 0.25;
    colorListBoxH = sh = 0.6;
    sliderWidth = sw * 0.7;
    gradeSelectBoxW = sh * 0.1;
    demoBoxSizeW =sh * 0.4;
    demoBoxSizeH = sh * 0.4;
    tileModeW =sh * 0.1;
        log("demoo beff ${demoBoxSizeW} / $sw //${MediaQuery.of(context).size.height}");
    gradProvider = Provider.of(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(fit: StackFit.expand, children: [
        // Column(
        //   children: [
        //     Container(
        //       width: 200,
        //       height: 200,
        //       decoration: BoxDecoration(
        //           // gradient: Line
        //           ),
        //     )
        //   ],
        // ),
        _colorPicker(),
        _gradientDemo(),
        _colorSliderBar(),
        _gradientTypesList(),
        // colorListBox()
      ]),
    );
  }

  Color pickedColor = Colors.amber;
  _colorPicker() {
    return Positioned(
        right: 0,
        bottom: 0,
        child: ElevatedButton(
            onPressed: () async {}, child: Text("Color Picker")));
  }

  _colorSliderBar() {
    return Positioned(
        bottom: 0,
        left: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (gradProvider.gradientType == GradientType.radial)
              _radiusSliders(),
            if (gradProvider.gradientType == GradientType.sweep)
              _sweepAngleSliders(),
            ColorStopSlider(tw: sliderWidth, th: h * 0.08)
          ],
        ));
  }

  colorListBox() {
    double bh = 20;
    return Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          width: colorListBoxW,
          height: colorListBoxH,

          /*
          child: Column(
            children: [
              Text("Colors"),
              ...gradProvider.colorStopModels.map((e) {
                double pad = colorListBoxW * 0.02;
                return Container(
                  width: colorListBoxW,
                  height:bh,
                  child: Row(
                    children: [
                      Container(
                        height: bh - pad * 2,
                        margin: EdgeInsets.all(colorListBoxW * 0.02),
                        width: bh - pad * 2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: getHexColor(e.hexColorString)),
                      ),
                      Container(
                        height: bh - pad * 2,
                        margin: EdgeInsets.all(colorListBoxW * 0.02),
                        width: colorListBoxW * 0.8 - bh - pad * 2,
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
          */
        ));
  }

  getHexColor(String colorString) {
    if (colorString.length == 6) {
      return Color(int.parse("0xff${colorString}"));
    }
    if (colorString.length == 8) {
      return Color(int.parse("0x${colorString}"));
    }
    return Colors.white;
  }

  _gradientTypesList() {
    return Positioned(
        right: w * 0.01,
        top: h * 0.1,
        child: Container(
          // color: Colors.purple.shade200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // width: gradeSelectBoxW + w * 0.05 + 6,
                // width: w * 0.,
                height: h * 0.1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(GradientType.values.length,
                        (i) => _gradientSelectionBox(i))
                  ],
                ),
              ),
              Container(
                height: tileModeW * 2,
                // width: w * 0.6,
                // color: Colors.red,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...List.generate(
                          TileMode.values.length, (i) => tileModeSIngleBox(i))
                    ]),
              ),
            ],
          ),
        ));
  }

  // List<Gradient> gradients = [
  //   const LinearGradient(
  //     colors: [Colors.purple, Colors.blueAccent],
  //     begin: Alignment.bottomLeft,
  //     end: Alignment.topRight,
  //     stops: [0.4, 0.7],
  //     tileMode: TileMode.repeated,
  //   ),
  //   const RadialGradient(
  //     colors: [Colors.red, Colors.yellow],
  //     radius: 0.75,
  //   ),
  //   const SweepGradient(
  //     endAngle: m.pi * 2,
  //     colors: [
  //       Colors.red,
  //       Colors.yellow,
  //       Colors.blue,
  //       Colors.green,
  //       Colors.yellow,
  //       Colors.red,
  //     ],
  //     stops: <double>[0.0, 0.25, 0.5, 0.75, 0.85, 1.0],
  //     tileMode: TileMode.clamp,
  //   ),
  // ];
  _gradientSelectionBox(int i) {
    return InkWell(
      onTap: () {
        gradProvider.gradientType = GradientType.values[i];
        gradProvider.updateUi();
      },
      child: Row(
        children: [
          Container(
            height: gradeSelectBoxW,
            width: gradeSelectBoxW,
            decoration: BoxDecoration(
                color: Colors.green,
                border: gradProvider.gradientType == GradientType.values[i]
                    ? Border.all(color: Colors.white, width: 4)
                    : null,
                borderRadius: BorderRadius.circular(8),
                gradient: getGradientForTileMode(TileMode.values[i], i)),
          ),
          Container(
            width: w * 0.05,
            child: Center(
              child: Text(
                GradientType.values[i].toString().split('.')[1].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  tileModeSIngleBox(int i) {
    return InkWell(
      onTap: () {
        gradProvider.selectedTileMode = TileMode.values[i];
        gradProvider.updateUi();
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: tileModeW,
              height: tileModeW,
              decoration: BoxDecoration(
                  border: gradProvider.selectedTileMode == TileMode.values[i]
                      ? Border.all(
                          width: 3,
                          color: Colors.white,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  gradient: getGradientForTileMode(TileMode.values[i],
                      GradientType.values.indexOf(gradProvider.gradientType))
                  // gradients[GradientType.values.indexOf(gradProvider.gradientType)].
                  ),
            ),
            Container(
              height: tileModeW * 0.3,
              child: Center(
                child: Text(
                  TileMode.values[i].name,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getGradientForTileMode(TileMode tileMode, int gradIndex) {
    // log("tilemode $tileMode / grdi $gradIndex");

    return [
      LinearGradient(
        colors: [
          ...gradProvider.colorStopModels
              .map((e) => Color(int.parse("0x${e.hexColorString}")))
        ],
        begin: gradProvider.linearAlignStart,
        end: gradProvider.linearAlignEnd,
        stops: [...gradProvider.colorStopModels.map((e) => e.colorStop)],
        tileMode: tileMode,
      ),
      RadialGradient(
          focalRadius: gradProvider.radialFocalRadius,
          focal: gradProvider.radialAlignFocal,
          center: gradProvider.radialAlignCenter,
          colors: [
            ...gradProvider.colorStopModels
                .map((e) => Color(int.parse("0x${e.hexColorString}")))
          ],
          radius: gradProvider.radialRadius,
          tileMode: tileMode),
      SweepGradient(
        startAngle: gradProvider.sweepStartAngle,
        endAngle: gradProvider.sweepEndAngle,
        colors: [
          ...gradProvider.colorStopModels
              .map((e) => Color(int.parse("0x${e.hexColorString}")))
        ],
        stops: [...gradProvider.colorStopModels.map((e) => e.colorStop)],
        tileMode: tileMode,
      ),
    ][gradIndex];
  }

  _radiusSliders() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: sliderWidth,
            child: SliderTheme(
                data: SliderThemeData(),
                child: Slider(
                  value: gradProvider.radialRadius,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (d) {
                    gradProvider.radialRadius = d;
                    gradProvider.updateUi();
                  },
                ))),
        Container(
            width: sliderWidth,
            child: SliderTheme(
                data: SliderThemeData(),
                child: Slider(
                  value: gradProvider.radialFocalRadius,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (d) {
                    gradProvider.radialFocalRadius = d;
                    gradProvider.updateUi();
                  },
                )))
      ],
    );
  }

  _sweepAngleSliders() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: sliderWidth,
            child: SliderTheme(
                data: SliderThemeData(),
                child: Slider(
                  value: gradProvider.sweepStartAngle,
                  min: 0.0,
                  max: m.pi * 2,
                  onChanged: (d) {
                    if (d < gradProvider.sweepEndAngle) {
                      gradProvider.sweepStartAngle = d;
                      gradProvider.updateUi();
                    }
                  },
                ))),
        Container(
            width: sliderWidth,
            child: SliderTheme(
                data: SliderThemeData(),
                child: Slider(
                  value: gradProvider.sweepEndAngle,
                  min: 0.0,
                  max: m.pi * 2,
                  onChanged: (d) {
                    if (d > gradProvider.sweepStartAngle) {
                      gradProvider.sweepEndAngle = d;
                      gradProvider.updateUi();
                    }
                  },
                )))
      ],
    );
  }

  _gradientDemo() {
    log("demoo ${demoBoxSizeW}");
    return Positioned(
        left: w * 0.1,
        top: h * 0.05,
        child: Container(
          width: demoBoxSizeW + pointRad * 2,
          height: demoBoxSizeH + pointRad * 2,
          decoration: BoxDecoration(
              color: Colors.amber,
              border: Border.all(color: Colors.white),
              gradient: getGradientForTileMode(gradProvider.selectedTileMode,
                  GradientType.values.indexOf(gradProvider.gradientType))),
          child: Center(
            child: gradientModifierWidget(),
          ),
        ));
  }

  gradientModifierWidget() {
    switch (gradProvider.gradientType) {
      case GradientType.linear:
        return linearGradientModifier();
        break;
      case GradientType.radial:
        return radialGradientModifier();
      case GradientType.radial:
        return sweepGradientModifier();
      default:
        return Container();
    }
  }

  linearGradientModifier() {
    gradProvider.linearAlignEnd = Alignment(
        gradProvider.linearAlignEndPoint.dx / demoBoxSizeW,
        (gradProvider.linearAlignEndPoint.dy / demoBoxSizeH));
    gradProvider.linearAlignStart = Alignment(
        gradProvider.linearAlignStartPoint.dx / demoBoxSizeW,
        (gradProvider.linearAlignStartPoint.dy / demoBoxSizeH));
    log("alpoints ${gradProvider.linearAlignStartPoint}/ ${gradProvider.linearAlignEndPoint}");
    return Container(
      color: Colors.white,
      width: demoBoxSizeW + pointRad * 2,
      height: demoBoxSizeH + pointRad * 2,
      // padding: EdgeInsets.all(4),
      child: Center(
        child: Stack(

            // fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Container(
                  width: demoBoxSizeW,
                  height: demoBoxSizeH,
                  decoration: BoxDecoration(
                      gradient: getGradientForTileMode(
                          gradProvider.selectedTileMode,
                          GradientType.values
                              .indexOf(gradProvider.gradientType))),
                ),
              ),
              circlePoint(gradProvider.linearAlignStartPoint,
                  gradProvider.linearAlignStart, 0),
              circlePoint(gradProvider.linearAlignEndPoint,
                  gradProvider.linearAlignEnd, 1),
            ]),
      ),
    );
  }

  circlePoint(Offset point, Alignment alignment, int i) {
    return Positioned(
      left: point.dx,
      top: point.dy,
      child: GestureDetector(
        onPanUpdate: (d) {
          updatePoint(alignment, d, point);
        },
        child: CircleAvatar(
          radius: pointRad,
          backgroundColor: Colors.white,
          child: CircleAvatar(
              radius: pointRad - 2, backgroundColor: pointColors[i]),
        ),
      ),
    );
  }

  updatePoint(Alignment alignment, DragUpdateDetails d, Offset point) {
    if (alignment == gradProvider.linearAlignStart) {
      Offset updatePoint = Offset(gradProvider.linearAlignStartPoint.dx,
          gradProvider.linearAlignStartPoint.dy);
      gradProvider.linearAlignStartPoint = Offset(
          gradProvider.linearAlignStartPoint.dx + d.delta.dx,
          gradProvider.linearAlignStartPoint.dy + d.delta.dy);
      double x = gradProvider.linearAlignStartPoint.dx;
      double y = gradProvider.linearAlignStartPoint.dy;
      if (x < -pointRad * 0.25 ||
          y < -pointRad * 0.25 ||
          x + pointRad * 0.25 > demoBoxSizeW ||
          y + pointRad * 0.25 > demoBoxSizeW) {
        gradProvider.linearAlignStartPoint = updatePoint;
      }
    }
    if (alignment == gradProvider.linearAlignEnd) {
      Offset updatePoint = Offset(gradProvider.linearAlignEndPoint.dx,
          gradProvider.linearAlignEndPoint.dy);
      gradProvider.linearAlignEndPoint = Offset(
          gradProvider.linearAlignEndPoint.dx + d.delta.dx,
          gradProvider.linearAlignEndPoint.dy + d.delta.dy);
      double x = gradProvider.linearAlignEndPoint.dx;
      double y = gradProvider.linearAlignEndPoint.dy;

      // log("x $x")
      if (x < -pointRad * 0.5 ||
          y < -pointRad * 0.5 ||
          x + pointRad * 0.5 > demoBoxSizeW + pointRad ||
          y + pointRad * 0.5 > demoBoxSizeW + pointRad) {
        gradProvider.linearAlignEndPoint = updatePoint;
      }
    }

    if (alignment == gradProvider.radialAlignCenter) {
      Offset updatePoint = Offset(gradProvider.radialAlignCenterPoint.dx,
          gradProvider.radialAlignCenterPoint.dy);
      gradProvider.radialAlignCenterPoint = Offset(
          gradProvider.radialAlignCenterPoint.dx + d.delta.dx,
          gradProvider.radialAlignCenterPoint.dy + d.delta.dy);
      double x = gradProvider.radialAlignCenterPoint.dx;
      double y = gradProvider.radialAlignCenterPoint.dy;

      // log("x $x")
      if (x < -pointRad * 0.5 ||
          y < -pointRad * 0.5 ||
          x + pointRad * 0.5 > demoBoxSizeW + pointRad ||
          y + pointRad * 0.5 > demoBoxSizeW + pointRad) {
        gradProvider.radialAlignCenterPoint = updatePoint;
      }
    }

    if (alignment == gradProvider.radialAlignFocal) {
      Offset updatePoint = Offset(gradProvider.radialAlignFocalPoint.dx,
          gradProvider.radialAlignFocalPoint.dy);
      gradProvider.radialAlignFocalPoint = Offset(
          gradProvider.radialAlignFocalPoint.dx + d.delta.dx,
          gradProvider.radialAlignFocalPoint.dy + d.delta.dy);
      double x = gradProvider.radialAlignFocalPoint.dx;
      double y = gradProvider.radialAlignFocalPoint.dy;

      // log("x $x")
      if (x < -pointRad * 0.5 ||
          y < -pointRad * 0.5 ||
          x + pointRad * 0.5 > demoBoxSizeW + pointRad ||
          y + pointRad * 0.5 > demoBoxSizeW + pointRad) {
        gradProvider.radialAlignCenterPoint = updatePoint;
      }
    }

    if (alignment == gradProvider.sweepAlignCenter) {
      Offset updatePoint = Offset(gradProvider.sweepAlignCenterPoint.dx,
          gradProvider.sweepAlignCenterPoint.dy);
      gradProvider.sweepAlignCenterPoint = Offset(
          gradProvider.sweepAlignCenterPoint.dx + d.delta.dx,
          gradProvider.sweepAlignCenterPoint.dy + d.delta.dy);
      double x = gradProvider.sweepAlignCenterPoint.dx;
      double y = gradProvider.sweepAlignCenterPoint.dy;

      // log("x $x")
      if (x < -pointRad * 0.5 ||
          y < -pointRad * 0.5 ||
          x + pointRad * 0.5 > demoBoxSizeW + pointRad ||
          y + pointRad * 0.5 > demoBoxSizeW + pointRad) {
        gradProvider.sweepAlignCenterPoint = updatePoint;
      }
    }
    gradProvider.updateUi();
  }

  radialGradientModifier() {
    gradProvider.radialAlignCenter = Alignment(
        gradProvider.radialAlignCenterPoint.dx / demoBoxSizeW - 0.5,
        (gradProvider.radialAlignCenterPoint.dy / demoBoxSizeH - 0.5));
    gradProvider.radialAlignFocal = Alignment(
        gradProvider.radialAlignFocalPoint.dx / demoBoxSizeW - 0.5,
        (gradProvider.radialAlignFocalPoint.dy / demoBoxSizeH - 0.5));

    return Container(
      color: Colors.white,
      width: demoBoxSizeW + pointRad * 2,
      height: demoBoxSizeH + pointRad * 2,
      // padding: EdgeInsets.all(4),
      child: Center(
        child: Stack(

            // fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Container(
                  width: demoBoxSizeW,
                  height: demoBoxSizeH,
                  decoration: BoxDecoration(
                      gradient: getGradientForTileMode(
                          gradProvider.selectedTileMode,
                          GradientType.values
                              .indexOf(gradProvider.gradientType))),
                ),
              ),
              circlePoint(gradProvider.radialAlignFocalPoint,
                  gradProvider.radialAlignFocal, 0),
              circlePoint(gradProvider.radialAlignCenterPoint,
                  gradProvider.radialAlignCenter, 1),
            ]),
      ),
    );
  }

  sweepGradientModifier() {
    gradProvider.sweepAlignCenter = Alignment(
        gradProvider.sweepAlignCenterPoint.dx / demoBoxSizeW - 0.5,
        (gradProvider.sweepAlignCenterPoint.dy / demoBoxSizeH - 0.5));

    return Container(
      color: Colors.red.shade100,
      width: demoBoxSizeW + pointRad * 2,
      height: demoBoxSizeH + pointRad * 2,
      // padding: EdgeInsets.all(4),
      child: Center(
        child: Stack(

            // fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Container(
                  width: demoBoxSizeW,
                  height: demoBoxSizeH,
                  decoration: BoxDecoration(
                      gradient: getGradientForTileMode(
                          gradProvider.selectedTileMode,
                          GradientType.values
                              .indexOf(gradProvider.gradientType))),
                ),
              ),
              circlePoint(gradProvider.sweepAlignCenterPoint,
                  gradProvider.sweepAlignCenter, 0),
            ]),
      ),
    );
  }
}

showColorPicker(BuildContext context, Function fun, Color prevColor) async {
  log("showColorPicker $fun");
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: prevColor,
              onColorChanged: (color) {
                fun(color);
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                // setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

class ColorStopSlider extends StatelessWidget {
  final double tw;
  final double th;

  const ColorStopSlider({Key? key, required this.tw, required this.th})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double actualW = tw * 0.96;
    double barH = th * 0.5;
    GradProvider gradProvider = Provider.of(context, listen: true);
    return Container(
        width: tw,
        height: th,
        color: Colors.amber.shade100,
        child: Center(
          child: Container(
            width: actualW,
            height: th,
            child: Stack(clipBehavior: Clip.none, children: [
              Padding(
                padding: EdgeInsets.only(top: th * 0.3),
                child: Center(
                  child: GestureDetector(
                    onTapUp: (d) {
                      log("onadd $d / ${gradProvider.colorStopModels.length}");
                      double stopValue = d.localPosition.dx / actualW;
                      gradProvider.colorStopModels
                          .add(ColorStopModel(stopValue, "ffffffff"));
                      log("bef remove aftersort after add /ll ${gradProvider.colorStopModels.length}");
                      gradProvider.sortColorStopModelsAsPerStopValue(
                          gradProvider.colorStopModels.length - 1);
                      gradProvider.updateUi();
                    },
                    child: Container(
                      width: actualW,
                      height: barH,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 30, 16, 85),
                          borderRadius: BorderRadius.circular(barH * 0.4)),
                    ),
                  ),
                ),
              ),
              ...List.generate(
                  gradProvider.colorStopModels.length,
                  (i) => ColorStopSliderItemWidget(
                        tw: actualW,
                        th: th,
                        colorStopModel: gradProvider.colorStopModels[i],
                        i: i,
                      ))
            ]),
          ),
        ));
  }
}

class ColorStopSliderItemWidget extends StatelessWidget {
  final double tw;
  final double th;

  final ColorStopModel colorStopModel;
  final int i;
  const ColorStopSliderItemWidget(
      {Key? key,
      required this.tw,
      required this.th,
      required this.colorStopModel,
      required this.i})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int colorCode = 0xfffffff;
    double barH = th * 0.5;
    double iconH = th * 0.4;
    // double boxH = th * 0.3;
    double totalItemW = iconH + 14;
    double left = colorStopModel.colorStop * tw - totalItemW * 0.5;
    GradProvider gradProvider = Provider.of(context, listen: false);
    log("co ${colorStopModel.hexColorString}");
    return Positioned(
      left: left,
      child: Container(
        height: th,
        width: totalItemW,
        child: Column(
          children: [
            Container(
              height: iconH,
              child: FittedBox(
                child: IconButton(
                  iconSize: iconH,
                  onPressed: () async {
                    if (gradProvider.colorStopModels.length > 2) {
                      gradProvider.colorStopModels.removeAt(i);
                      gradProvider.updateUi();
                    }
                  },
                  icon: CircleAvatar(
                      radius: iconH * 0.8,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: iconH,
                      )),
                  padding: EdgeInsets.zero,
                  // iconSize: iconH * 0.5,
                ),
              ),
            ),
            GestureDetector(
              onHorizontalDragEnd: (d) {
                gradProvider.sortColorStopModelsAsPerStopValue(i);
                gradProvider.updateUi();
              },
              onHorizontalDragUpdate: (d) {
                double updatedLeft = d.delta.dx / tw;
                // colorStopModel.colorStop * tw - totalItemW * 0.5;
                double stop = colorStopModel.colorStop + updatedLeft * 2;
                // log("horzd ${d.delta.dx} / $stop / $tw");
                log("colorr $i  : ${gradProvider.colorStopModels[i].hexColorString} / ${colorStopModel.hexColorString}");
                if (stop >= 0.0 && stop <= 1.0) {
                  gradProvider.colorStopModels[i] =
                      ColorStopModel(stop, colorStopModel.hexColorString);

                  gradProvider.updateUi();
                }
              },
              onTap: () {
                showColorPicker(context, (Color d) {
                  // log("showColorPicker before ${gradProvider.colorStopModels[colorStopModel.colorStop]!.hexColorString}");
                  gradProvider.colorStopModels[i] = ColorStopModel(
                      colorStopModel.colorStop,
                      d.toString().replaceAll(')', '').split('x')[1]);
                  // .hexColorString = d.toString();
                  // log("showColorPicker after ${gradProvider.colorStopModels[colorStopModel.colorStop]!.hexColorString}");
                  gradProvider.updateUi();
                },
                    Color(int.parse(
                        "0x${gradProvider.colorStopModels[i].hexColorString}")));
              },
              child: Container(
                height: barH,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Color(int.parse("0x${colorStopModel.hexColorString}")),
                ),
                width: 14,
              ),
            ),
            // Container(
            //   height: boxH,
            //   width: boxH,
            //   child: Center(
            //       child: CircleAvatar(
            //     radius: boxH * 0.35,
            //     backgroundColor:
            //         Color(int.parse("0x${colorStopModel.hexColorString}")),
            //   )),
            // ),
          ],
        ),
      ),
    );
  }
}
