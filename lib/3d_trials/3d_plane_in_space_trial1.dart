import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/3d_trials/3D%20Plane%20in%20Space/enums_in.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'package:three_d_model_tool/extensions.dart';
import 'package:three_d_model_tool/math/angle_conversion.dart';
import 'package:flutter/material.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'package:three_d_model_tool/math/equation_screen.dart';
import 'package:three_d_model_tool/math/get_angle_between_2_planes.dart';
import 'package:three_d_model_tool/math/get_angles_of_vector_though_origin_wrt_3planes.dart';
import 'package:three_d_model_tool/math/get_line_perp_to_plane.dart';
import 'package:three_d_model_tool/math/model/plane_equation_model.dart';
import 'dart:math' as m;
import 'package:vector_math/vector_math.dart' as vm;
import 'package:three_d_model_tool/math/get_angles_and_translated_value_for_trianlge_points.dart';

List<vm.Vector3> spacePointsList = [
  // vm.Vector3(150, 200, 100),
  // vm.Vector3(0, 70, 130),
  // vm.Vector3(160, 90, 0),

// 2nd above
//  vm.Vector3(150, 0, 150),
//   vm.Vector3(0, -100, 130),
//   vm.Vector3(160, -100, 0),

  vm.Vector3(100, 0, 0),
  vm.Vector3(0, 100, 0),
  vm.Vector3(0, 0, 100),
  // Inter point of above plane pooints
  vm.Vector3(
    0,
    0,
    0,
  ),
];

class PlanePositionModel {
  List<double> rotAngles = [0, 0, 0];
  List<double> translateValues = [0, 0, 0];
  List<double> translateValuesWRTSpace = [0, 0, 0];

  List<double> rotAnglesWRTSpace = [0, 0, 0];
  PlanePositionModel();
  PlanePositionModel.withAllValues(this.rotAngles, this.translateValues,
      this.translateValuesWRTSpace, this.rotAnglesWRTSpace);
}

double planeSize = 200;
List<PlanePositionModel> planePositionModels = [
  PlanePositionModel.withAllValues([0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]),
  PlanePositionModel.withAllValues([90, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]),
  PlanePositionModel.withAllValues(
      [0, 90, 90], [0, 0, 0], [0, 0, 0], [0, 0, 0]),
  PlanePositionModel.withAllValues([0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]),
  // PlanePositionModel.withAllValues([-37.5, -37.5, 0], [469.2, -127, 0]),
  // PlanePositionModel.withAllValues(
  //     [-37.50, -147.00, 0.00], [-444.00, 278.00, 0.00]),
];

class ThreeD_plane_in_space_trial1 extends StatefulWidget {
  ThreeD_plane_in_space_trial1({Key? key}) : super(key: key);

  @override
  State<ThreeD_plane_in_space_trial1> createState() =>
      _ThreeD_plane_in_space_trial1State();
}

class _ThreeD_plane_in_space_trial1State
    extends State<ThreeD_plane_in_space_trial1> {
  ScrollController xyzchartScrollController =
      ScrollController(initialScrollOffset: -200);
  int selecteSpacePointIndex = 0;
  int selectedPlaneIndex = 3;
  int sliderIndex = 0;
  bool spaceTransform = true;
  List<double> spaceRotAngles = [-18, -22, 0];
  List<double> spaceTranslateValues = [w * 0.5, h * 0.5, 0];
  List<double> rotAngles = [0, 0, 0];
  List<double> translateValues = [0, 0, 0];
  List<double> translateValuesWRTSpace = [0, 0, 0];
  List<double> rotAnglesWRTSpace = [0, 0, 0];
  List<String> rotAnglesAxesNames = ["X", "Y", "Z"];
  vm.Vector3 lineAngles = vm.Vector3(0, 0, 0);
  @override
  Widget build(BuildContext context) {
    lineAngles =
        get_angles_of_vector_though_origin_wrt_3planes(spacePointsList[3]);

    updateSelectedPlane();

    return Scaffold(
        // backgroundColor: Colors.black,
        body: Container(
      width: w,
      height: h,
      color: Color.fromARGB(245, 8, 5, 3),
      child: Stack(
        // fit: StackFit.expand,
        children: [
          Positioned(
              child: Transform(
            origin: Offset(w * 0.5, h * 0.5),
            transform: Matrix4.identity(),
            //  Matrix4.rotationZ(1*180.0.degToRad())..rotateY(1*180.0.degToRad())..rotateX(1*360.0.degToRad()),
            child: Transform(
              origin: Offset(w * 0.5, h * 0.5),
              transform: Matrix4.rotationX(spaceRotAngles[0].degToRad())
                ..rotateY(spaceRotAngles[1].degToRad())
                ..rotateZ(spaceRotAngles[2].degToRad())
                ..translate(spaceTranslateValues[0], spaceTranslateValues[1],
                    spaceTranslateValues[2]),
              child: Stack(children: [
                // Positioned(
                //   child: Transform(
                //     transform: Matrix4.rotationX(rotAngles[0].degToRad())
                //       ..rotateY(rotAngles[1].degToRad())
                //       ..rotateZ(rotAngles[2].degToRad())
                //       ..translate(translateValues[0], translateValues[1],
                //           translateValues[2]),
                //     child: ClipRRect(
                //       // borderRadius: BorderRadius.circular(60),
                //       child: Container(
                //         width: 200,
                //         height: 200,
                //         color: Colors.blue.shade200.withAlpha(150),
                //         child: Stack(
                //           fit: StackFit.loose,
                //           children: [],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                ...List.generate(planePositionModels.length, (i) {
                  return plane(i);
                }),
                Positioned(
                    child: Transform(
                  transform: Matrix4.rotationX(0)
                    ..translate(
                        planePositionModels[3].translateValuesWRTSpace[0],
                        planePositionModels[3].translateValuesWRTSpace[1],
                        planePositionModels[3].translateValuesWRTSpace[2]),
                  child: CircleAvatar(
                    backgroundColor: Colors.purple.shade600,
                    radius: 4,
                  ),
                )),
                ...List.generate(spacePointsList.length, (i) {
                  return Positioned(
                      child: spacePoint(
                          spacePointsList[i],
                          i == 3
                              ? Colors.green
                              : selecteSpacePointIndex == i
                                  ? Colors.red
                                  : Colors.white));
                }),
              ]),
            ),
          )),

          // plane(0),
          // plane(1),

          xyzValuesChart(),
          Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "space tra ${translateValuesWRTSpace}\n ${planePositionModels[3].translateValuesWRTSpace}, ",
                      style: const TextStyle(color: Colors.white)),
                  Container(
                    height: 60,
                    width: 300,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(" Intersect point: ",
                            style: TextStyle(color: Colors.white)),
                        SelectableText(
                            "${spacePointsList[3].x.roundTo3Places()}, ${spacePointsList[3].y.roundTo3Places()}, ${spacePointsList[3].z.roundTo3Places()},",
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 300,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("lineAngles values: ",
                            style: TextStyle(color: Colors.white)),
                        SelectableText(
                            "${lineAngles.x.roundTo3Places()}, ${lineAngles.y.roundTo3Places()}, ${lineAngles.z.roundTo3Places()},",
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              )),
          // spaceTransform
          //     ? spaceSlidersForManipulation()
          //     : slidersForManipulation()
        ],
      ),
    ));
  }

  xyzValuesChart() {
    // log("before drage ${xyzchartScrollController.} ");

    return Positioned(
        right: 0,
        top: 0,
        child: Row(
          children: [
            GestureDetector(
              onVerticalDragUpdate: (d) async {
                // xyzchartScrollController.addListener(() {
                // xyzchartScrollController.jumpTo(xyzchartScrollController.offset+100);
                setState(() {});

                xyzchartScrollController.jumpTo(
                    xyzchartScrollController.position.pixels + d.delta.dy);
                // log("delta ${xyzchartScrollController.position.keepScrollOffset} ");
                // if (d.delta.dy > 0) {
                //   // log("delta");
                // }

                // .animateTo(xyzchartScrollController.offset + d.delta.dy, curve: Curves.bounceIn, duration: Duration(seconds: 2));
              },
              child: Container(
                width: 8,
                height: h,
                color: Colors.red.shade100,
              ),
            ),
            Container(
              height: h,
              width: 300,
              child: ListView(
                shrinkWrap: true,
                controller: xyzchartScrollController,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => EquationScreen()));
                      },
                      child: Text("Go to Equation Screen")),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // 7,13,4>  and <0,0,1>
                        List<double> pNos = [
                          150,
                          0,
                          150,
                          0,
                          -100,
                          130,
                          160,
                          -100,
                          0
                        ];
                        List<vm.Vector3> points =
                            getListof3Vector3sFromcoorinatelistof9(pNos
                                // [100, 100, 0, 100, 0, 100, 0, 100, 100]
                                );
                        getAngleBetween2Planes(
                            vm.Vector3(7, 13, 4), vm.Vector3(0, 0, 1));
                        log("points $points");
                        PlaneEquation planeEquation =
                            getPlaneEquationFrom3Points(points)!;
                        if (planeEquation != null) {
                          // getListof3Vector3sFromcoorinatelistof9(values)
                          vm.Vector3 vector3 = vm.Vector3(planeEquation.x,
                              planeEquation.y, planeEquation.z);
                          log("points planeEquation ${planeEquation}");
                          double x = getAngleWRT_XY_Plane(vector3);
                          double y = getAngleWRT_YZ_Plane(vector3);
                          double z = getAngleWRT_XZ_Plane(vector3);

                          rotAngles = [x, y, z];
                          setState(() {});
                        }
                      },
                      child: Text("Get Determinant")),

                  if (enitiyForSlider == EnitiyForSlider.space)
                    ...spaceTextFields(),
                  if (enitiyForSlider == EnitiyForSlider.object)
                    objectTextFields(),
                  if (enitiyForSlider == EnitiyForSlider.point)
                    pointsTextFields(),
                  // if (enitiyForSlider == EnitiyForSlider.point)
                  // if (enitiyForSlider == EnitiyForSlider.point)
                  if (enitiyForSlider == EnitiyForSlider.point)
                    Container(
                      width: 300,
                      height: 40,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: spacePointsList.length,
                          itemBuilder: (c, i) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selecteSpacePointIndex = i;
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: i == 3
                                    ? Colors.blue
                                    : selecteSpacePointIndex == i
                                        ? Colors.red.shade100.withAlpha(160)
                                        : Colors.white,
                                radius: 20,
                                child: Center(
                                  child: Text(i.toString()),
                                ),
                              ),
                            );
                          }),
                    ),
                  if (enitiyForSlider == EnitiyForSlider.object)
                    Container(
                      height: 60,
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  sliderTypeForObject =
                                      SliderTypeForObject.wrtSpace;
                                  // spaceTransform = true;
                                });
                              },
                              icon: Icon(sliderTypeForObject !=
                                      SliderTypeForObject.wrtSpace
                                  ? Icons.check_box_outline_blank
                                  : Icons.check_box),
                              label: Text("wrt Space")),
                          ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  sliderTypeForObject =
                                      SliderTypeForObject.wrtItself;
                                });
                              },
                              icon: Icon(sliderTypeForObject !=
                                      SliderTypeForObject.wrtItself
                                  ? Icons.check_box_outline_blank
                                  : Icons.check_box),
                              label: Text("wrt Itself")),
                        ],
                      ),
                    ),
                  singleSliderBox(),
                  Container(
                    height: 60,
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                enitiyForSlider = EnitiyForSlider.space;
                                // spaceTransform = true;
                              });
                            },
                            icon: Icon(enitiyForSlider != EnitiyForSlider.space
                                ? Icons.check_box_outline_blank
                                : Icons.check_box),
                            label: Text("Space")),
                        ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                enitiyForSlider = EnitiyForSlider.object;
                              });
                            },
                            icon: Icon(enitiyForSlider != EnitiyForSlider.object
                                ? Icons.check_box_outline_blank
                                : Icons.check_box),
                            label: Text("Object")),
                        ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                enitiyForSlider = EnitiyForSlider.point;
                              });
                            },
                            icon: Icon(enitiyForSlider != EnitiyForSlider.point
                                ? Icons.check_box_outline_blank
                                : Icons.check_box),
                            label: Text("Point"))
                      ],
                    ),
                  )
                  //  (height / step).toInt()
                ],
              ),
            )
          ],
        ));
  }

  Widget positionedLine(Widget line) {
    return Positioned(left: 0, top: 0, child: line);
  }

  Widget line({double? len = 100, Color? color = Colors.amber}) {
    return Container(
      width: len,
      height: 1,
      color: color,
    );
  }

  slidersForManipulation() {
    return Positioned(
      bottom: 0,
      left: 0,
      // alignment: Alignment.bottomCenter,
      child: Container(
        height: 140,
        width: w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            // stepValueSlider(),
            // topbottomradiusSlider(),
            // cylinderHeightSlider(),
            ...List.generate(
                3,
                (i) => Container(
                    width: w * 0.33,
                    height: 140,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rotAnglesAxesNames[i],
                          style: TextStyle(color: Colors.white),
                        ),
                        Container(
                          width: w * 0.33,
                          height: 60,
                          child: Slider(
                              min: -180,
                              max: 180,
                              divisions: 360,
                              value: rotAngles[i],
                              onChanged: (double v) {
                                setState(() {
                                  rotAngles[i] = v;
                                });
                              }),
                        ),
                        Container(
                          width: w * 0.33,
                          height: 60,
                          child: Slider(
                              min: -1000,
                              max: 1000,
                              divisions: 1000,
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

  spaceSlidersForManipulation() {
    return Positioned(
      bottom: 0,
      left: 0,
      // alignment: Alignment.bottomCenter,
      child: Container(
        height: 140,
        width: w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            // stepValueSlider(),
            // topbottomradiusSlider(),
            // cylinderHeightSlider(),
            ...List.generate(
                3,
                (i) => Container(
                    width: w * 0.33,
                    height: 140,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rotAnglesAxesNames[i],
                          style: TextStyle(color: Colors.white),
                        ),
                        Container(
                          width: w * 0.33,
                          height: 60,
                          child: Slider(
                              min: -180,
                              max: 180,
                              divisions: 360,
                              value: spaceRotAngles[i],
                              onChanged: (double v) {
                                setState(() {
                                  spaceRotAngles[i] = v;
                                });
                              }),
                        ),
                        Container(
                          width: w * 0.33,
                          height: 60,
                          child: Slider(
                              min: -1000,
                              max: 1000,
                              divisions: 1000,
                              value: spaceTranslateValues[i],
                              onChanged: (double v) {
                                setState(() {
                                  spaceTranslateValues[i] = v;
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

  plane(int planeNo) {
    return Positioned(
      child: Transform(
        transform: Matrix4.rotationX(
            planePositionModels[planeNo].rotAnglesWRTSpace[0].degToRad())
          ..rotateY(
              planePositionModels[planeNo].rotAnglesWRTSpace[1].degToRad())
          ..rotateZ(
              planePositionModels[planeNo].rotAnglesWRTSpace[2].degToRad())
          ..translate(
              planePositionModels[planeNo].translateValuesWRTSpace[0],
              planePositionModels[planeNo].translateValuesWRTSpace[1],
              planePositionModels[planeNo].translateValuesWRTSpace[2]),
        child: Transform(
          transform: Matrix4.rotationX(
              planePositionModels[planeNo].rotAngles[0].degToRad())
            ..rotateY(planePositionModels[planeNo].rotAngles[1].degToRad())
            ..rotateZ(planePositionModels[planeNo].rotAngles[2].degToRad())
            ..translate(
                planePositionModels[planeNo].translateValues[0],
                planePositionModels[planeNo].translateValues[1],
                planePositionModels[planeNo].translateValues[2]),
          child: Container(
            // color: Colors.purple,
            child: InkWell(
              onTap: () {
                setState(() {
                  rotAngles = List.from(planePositionModels[planeNo].rotAngles);
                  translateValues =
                      List.from(planePositionModels[planeNo].translateValues);
                });
              },
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(60),
                child: Container(
                  width: planeSize,
                  height: planeSize,
                  color: Colors
                      .primaries[(planeNo + 1) % Colors.primaries.length]
                      .withAlpha(150),
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      Positioned.fill(
                          child: Center(
                              child: Text(
                        "$planeNo",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      )))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  pointsTextFields() {
    return Container(
      width: 300,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ...List.generate(3, (i) {
            double value = getPointTransValue(i);
            TextEditingController controller =
                TextEditingController(text: value.toString());
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  rotAnglesAxesNames[i],
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Container(
                  width: 100,
                  height: 50,
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: controller,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      onSubmitted: (value) {
                        setState(() {});
                      },
                      onChanged: (value) {
                        if (double.parse(value).abs() <= 500) {
                          double v = double.parse(value);
                          switch (i) {
                            case 0:
                              spacePointsList[selecteSpacePointIndex].x = v;
                              break;
                            case 1:
                              spacePointsList[selecteSpacePointIndex].y = v;
                              break;
                            case 2:
                              spacePointsList[selecteSpacePointIndex].z = v;
                              break;
                          }

                          // controller.text = value;

                          // setState(() {});
                        }
                      },
                    ),
                  ),
                )
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget objectTextFields() {
    return Container(
      // height: 1000,
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (sliderTypeForObject == SliderTypeForObject.wrtItself)
              ? Container(
                  width: 300,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...List.generate(3, (i) {
                        TextEditingController controller =
                            TextEditingController(
                                text: rotAngles[i].toString());
                        controller.selection = TextSelection.collapsed(
                            offset: controller.text.length);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              rotAnglesAxesNames[i],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              width: 80,
                              height: 40,
                              child: Center(
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: controller,
                                  onChanged: (value) {
                                    if (double.parse(value).abs() <= 180) {
                                      rotAngles[i] = double.parse(value);
                                      // controller.text = value;

                                    }
                                  },
                                  onSubmitted: (value) {
                                    setState(() {});
                                  },
                                  // radToDeg(rotAngles[i]).toStringAsFixed(1),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                )
              : Container(
                  width: 300,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...List.generate(3, (i) {
                        TextEditingController controller =
                            TextEditingController(
                                text: rotAnglesWRTSpace[i].toString());
                        controller.selection = TextSelection.collapsed(
                            offset: controller.text.length);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              rotAnglesAxesNames[i],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              width: 80,
                              height: 40,
                              child: Center(
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: controller,
                                  onChanged: (value) {
                                    if (double.parse(value).abs() <= 180) {
                                      rotAnglesWRTSpace[i] =
                                          double.parse(value);
                                      // controller.text = value;

                                    }
                                  },
                                  onSubmitted: (value) {
                                    setState(() {});
                                  },
                                  // radToDeg(rotAngles[i]).toStringAsFixed(1),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
          SizedBox(
            height: 5,
          ),
          (sliderTypeForObject == SliderTypeForObject.wrtItself)
              ? Container(
                  width: 300,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...List.generate(3, (i) {
                        TextEditingController controller =
                            TextEditingController(
                                text: translateValues[i].toString());
                        controller.selection = TextSelection.collapsed(
                            offset: controller.text.length);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              rotAnglesAxesNames[i],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              width: 100,
                              height: 40,
                              child: Center(
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: controller,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  onSubmitted: (value) {
                                    setState(() {});
                                  },
                                  onChanged: (value) {
                                    if (double.parse(value).abs() <= 500) {
                                      translateValues[i] = double.parse(value);
                                      // controller.text = value;

                                      // setState(() {});
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                    ],
                  ),
                )
              : Container(
                  width: 300,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...List.generate(3, (i) {
                        TextEditingController controller =
                            TextEditingController(
                                text: translateValuesWRTSpace[i].toString());
                        controller.selection = TextSelection.collapsed(
                            offset: controller.text.length);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              rotAnglesAxesNames[i],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              width: 100,
                              height: 40,
                              child: Center(
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: controller,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  onSubmitted: (value) {
                                    setState(() {});
                                  },
                                  onChanged: (value) {
                                    if (double.parse(value).abs() <= 500) {
                                      translateValuesWRTSpace[i] =
                                          double.parse(value);
                                      // controller.text = value;

                                      // setState(() {});
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                    ],
                  ),
                ),
          SizedBox(
            height: 2,
          ),
          Container(
            width: 300,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      translateValues =
                          List.filled(translateValues.length, 0.0);
                      rotAngles = List.filled(rotAngles.length, 0.0);
                      translateValuesWRTSpace =
                          List.filled(translateValuesWRTSpace.length, 0.0);
                      rotAnglesWRTSpace =
                          List.filled(rotAnglesWRTSpace.length, 0.0);
                      setState(() {});
                    },
                    child: Text("Set All to Zero")),
                // SizedBox(
                //   height: 80,
                // ),
                ElevatedButton(
                    onPressed: () {
                      planePositionModels.add(PlanePositionModel.withAllValues(
                          List.from(rotAngles),
                          List.from(translateValues),
                          List.from(translateValuesWRTSpace),
                          List.from(rotAnglesWRTSpace)));
                      // log("rot $rotAngles $translateValues");
                      setState(() {});
                    },
                    child: Text("Add New Plane"))
              ],
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            height: 60,
            width: 300,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: planePositionModels.length,
                itemBuilder: (c, i) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        rotAngles = List.from(planePositionModels[i].rotAngles);
                        translateValues =
                            List.from(planePositionModels[i].translateValues);
                        translateValuesWRTSpace = List.from(
                            planePositionModels[i].translateValuesWRTSpace);
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Center(
                        child: Text(i.toString()),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  List<Widget> getSliderForSpaceAndPoint() {
    return [
      sliderWithIcon(0),
      sliderWithIcon(1),
      sliderWithIcon(2),
      sliderWithIcon(3),
      sliderWithIcon(4),
      sliderWithIcon(5),
    ];
  }

  List<Widget> getSlidersForObject() {
    return (sliderTypeForObject == SliderTypeForObject.wrtItself)
        ? [
            sliderWithIcon(0),
            sliderWithIcon(1),
            sliderWithIcon(2),
            sliderWithIcon(3),
            sliderWithIcon(4),
            sliderWithIcon(5),
          ]
        : [
            sliderWithIcon(6),
            sliderWithIcon(7),
            sliderWithIcon(8),
            sliderWithIcon(9),
            sliderWithIcon(10),
            sliderWithIcon(11),
          ];
  }

  singleSliderBox() {
    bool isObject = enitiyForSlider == EnitiyForSlider.object;
    return Container(
      width: 300,
      // height: 400,
      color: Colors.pink.shade100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isObject) ...getSliderForSpaceAndPoint(),
          if (isObject) ...getSlidersForObject(),
        ],
      ),
    );
  }

  List<Widget> spaceTextFields() {
    return [
      Container(
        width: 300,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...List.generate(3, (i) {
              TextEditingController controller =
                  TextEditingController(text: spaceRotAngles[i].toString());
              controller.selection =
                  TextSelection.collapsed(offset: controller.text.length);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    rotAnglesAxesNames[i],
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Container(
                    width: 80,
                    height: 40,
                    child: Center(
                      child: TextField(
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.zero),
                        textAlign: TextAlign.center,
                        controller: controller,
                        onChanged: (value) {
                          if (double.parse(value).abs() <= 180) {
                            spaceRotAngles[i] = double.parse(value);
                            // controller.text = value;

                          }
                        },
                        onSubmitted: (value) {
                          setState(() {});
                        },
                        // radToDeg(rotAngles[i]).toStringAsFixed(1),
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Container(
        width: 300,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...List.generate(3, (i) {
              TextEditingController controller = TextEditingController(
                  text: spaceTranslateValues[i].toString());
              controller.selection =
                  TextSelection.collapsed(offset: controller.text.length);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    rotAnglesAxesNames[i],
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),

                  Container(
                    width: 100,
                    height: 40,
                    child: Center(
                      child: TextField(
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.zero),
                        textAlign: TextAlign.center,
                        controller: controller,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        onSubmitted: (value) {
                          setState(() {});
                        },
                        onChanged: (value) {
                          if (double.parse(value).abs() <= 500) {
                            spaceTranslateValues[i] = double.parse(value);
                            // controller.text = value;

                            // setState(() {});
                          }
                        },
                      ),
                    ),
                  )
                  // Text(
                  //   radToDeg(translateValues[i]).toStringAsFixed(1),
                  //   style: TextStyle(color: Colors.white, fontSize: 15),
                  // ),
                ],
              );
            }),
          ],
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        width: 300,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: () {
                  spaceTranslateValues =
                      List.filled(spaceTranslateValues.length, 0.0);
                  spaceRotAngles = List.filled(spaceRotAngles.length, 0.0);
                  setState(() {});
                },
                child: Text("Set All to Zero")),
            SizedBox(
              height: 80,
            ),
            // ElevatedButton(
          ],
        ),
      ),
    ];
  }

  sliderWithIcon(int i) {
    return Container(
      width: 300,
      height: 40,
      child: Row(
        children: [iconWithTextList[i], Expanded(child: getSelectedSlider(i))],
      ),
    );
  }

  List<Widget> iconWithTextList = const [
    IconWithText(0),
    IconWithText(1),
    IconWithText(2),
    IconWithText(3),
    IconWithText(4),
    IconWithText(5),
    IconWithText(0),
    IconWithText(1),
    IconWithText(2),
    IconWithText(3),
    IconWithText(4),
    IconWithText(5),
  ];

  getSelectedSlider(int j) {
    if (j <= 2 && enitiyForSlider == EnitiyForSlider.space) {
      int i = j;
      return SliderTheme(
        data: SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4)),
        child: Slider(
            min: -1000,
            max: 1000,
            divisions: 1000,
            value: spaceTranslateValues[i],
            onChanged: (double v) {
              setState(() {
                spaceTranslateValues[i] = v;
              });
            }),
      );
    }
    if (j > 2 && j < 6 && enitiyForSlider == EnitiyForSlider.space) {
      int i = j % 3;
      return SliderTheme(
        data: SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4)),
        child: Slider(
            min: -180,
            max: 180,
            divisions: 360,
            value: spaceRotAngles[i],
            onChanged: (double v) {
              setState(() {
                spaceRotAngles[i] = v;
              });
            }),
      );
    }
    if (j <= 2 && enitiyForSlider == EnitiyForSlider.object) {
      int i = j;
      return SliderTheme(
        data: SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4)),
        child: Slider(
            min: -1000,
            max: 1000,
            divisions: 1000,
            value: translateValues[i],
            onChanged: (double v) {
              setState(() {
                translateValues[i] = v;
              });
            }),
      );
    }
    if (j > 2 && j < 6 && enitiyForSlider == EnitiyForSlider.object) {
      int i = j % 3;
      return SliderTheme(
        data: SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4)),
        child: Slider(
            min: -180,
            max: 180,
            divisions: 360,
            value: rotAngles[i],
            onChanged: (double v) {
              setState(() {
                rotAngles[i] = v;
              });
            }),
      );
    }

    if (j > 5 && j < 9 && enitiyForSlider == EnitiyForSlider.object) {
      int i = j % 3;
      return SliderTheme(
        data: SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4)),
        child: Slider(
            min: -1000,
            max: 1000,
            divisions: 1000,
            value: translateValuesWRTSpace[i],
            onChanged: (double v) {
              setState(() {
                translateValuesWRTSpace[i] = v;
              });
            }),
      );
    }
    if (j > 8 && j < 12 && enitiyForSlider == EnitiyForSlider.object) {
      log("slider object rot $j");
      int i = j % 3;
      return SliderTheme(
        data: SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4)),
        child: Slider(
            min: -180,
            max: 180,
            divisions: 360,
            value: rotAnglesWRTSpace[i],
            onChanged: (double v) {
              setState(() {
                rotAnglesWRTSpace[i] = v;
              });
            }),
      );
    }
    if (j <= 2 && enitiyForSlider == EnitiyForSlider.point) {
      int i = j;
      return SliderTheme(
        data: SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4)),
        child: Slider(
            min: -1000,
            max: 1000,
            divisions: 1000,
            value: i == 0
                ? spacePointsList[selecteSpacePointIndex].x
                : (i == 1
                    ? spacePointsList[selecteSpacePointIndex].y
                    : spacePointsList[selecteSpacePointIndex].z),
            onChanged: (double v) {
              setState(() {
                switch (i) {
                  case 0:
                    spacePointsList[selecteSpacePointIndex].x = v;
                    break;
                  case 1:
                    spacePointsList[selecteSpacePointIndex].y = v;
                    break;
                  case 2:
                    spacePointsList[selecteSpacePointIndex].z = v;
                    break;
                  default:
                }
                spacePointsList[3] = getInterSectionPointForPlane(
                    getPlaneEquationFrom3Points(spacePointsList)!);
              });
            }),
      );
    }

    // if (j > 2 && enitiyForSlider == EnitiyForSlider.point) {
    //   int i = j % 3;
    //   return SliderTheme(
    //     data: SliderThemeData(
    //         trackHeight: 2,
    //         thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4)),
    //     child: Slider(
    //         min: -180,
    //         max: 180,
    //         divisions: 360,
    //         value: rotAngles[i],
    //         onChanged: (double v) {
    //           setState(() {
    //             rotAngles[i] = v;
    //           });
    //         }),
    //   );
    // }
    return Container();
  }

  double getPointTransValue(int i) {
    switch (i) {
      case 0:
        return spacePointsList[selecteSpacePointIndex].x;
        break;
      case 1:
        return spacePointsList[selecteSpacePointIndex].y;
        break;
      case 2:
        return spacePointsList[selecteSpacePointIndex].z;
        break;
      default:
        return spacePointsList[selecteSpacePointIndex].x;
    }
  }

  void updateSelectedPlane() {
    if (planePositionModels.length > 3) {
      planePositionModels[selectedPlaneIndex].translateValuesWRTSpace =
          List.from(translateValuesWRTSpace);
      planePositionModels[selectedPlaneIndex].translateValues =
          List.from(translateValues);
      planePositionModels[selectedPlaneIndex].rotAngles = List.from(rotAngles);
      planePositionModels[selectedPlaneIndex].rotAnglesWRTSpace =
          List.from(rotAnglesWRTSpace);
    }
  }

  // getSelectedSlider(int i) {}

  // iconWithText(int i) {}
}

spacePoint(vm.Vector3 ve, [Color? color]) {
  return Transform(
    transform: Matrix4.rotationX(0)..translate(ve.x, ve.y, ve.z),
    child: Container(height: 10, width: 10, color: color ?? Colors.white),
  );
}

List<Widget> iconsForSliders = [
  Image.asset("assets/icons/translate_arrow_transp.png"),
  Image.asset("assets/icons/translate_arrow_transp.png"),
  Image.asset("assets/icons/translate_arrow_transp.png"),
  Icon(Icons.rotate_left_outlined),
  Icon(Icons.rotate_left_outlined),
  Icon(Icons.rotate_left_outlined),
];
List<String> iconTextsForSliders = ["X", "Y", "Z", "X", "Y", "Z"];

class IconWithText extends StatelessWidget {
  final int i;
  const IconWithText(
    this.i, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          iconsForSliders[i],
          Text(iconTextsForSliders[i],
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ))
        ],
      ),
    );
  }
}
