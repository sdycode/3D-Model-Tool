import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/Polygon/get_polygon_points_from_radius_no_initialAngle.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/model/point.dart';
import 'package:three_d_model_tool/3D%20Plane%20in%20Space/3D%20parts%20widgets/circleRing3DModelWidget.dart';
import 'package:three_d_model_tool/3D%20Plane%20in%20Space/3D%20parts%20widgets/plane_from_origin_at_circumference.dart';
import 'package:three_d_model_tool/3D%20Plane%20in%20Space/3D%20parts%20widgets/sphere_using_circular_rings_rotated_wrt_xz_plane.dart';
import 'package:three_d_model_tool/3D%20Plane%20in%20Space/enums_in.dart';

import 'package:three_d_model_tool/constants/consts.dart';
import 'package:three_d_model_tool/extensions.dart';
import 'package:three_d_model_tool/math/angle_conversion.dart';
import 'package:flutter/material.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'package:three_d_model_tool/math/equation_screen.dart';
import 'package:three_d_model_tool/math/get_angle_between_2_planes.dart';
import 'package:three_d_model_tool/math/get_angles_of_vector_though_origin_wrt_3planes.dart';
import 'package:three_d_model_tool/math/get_line_perp_to_plane.dart';
import 'package:three_d_model_tool/math/get_squre_root_value_of_any_vector.dart';
import 'package:three_d_model_tool/math/model/plane_equation_model.dart';
import 'package:three_d_model_tool/math/planeInterSectionPerpendilarDistanceForVector.dart';
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
double polygonRadius = 200;
double ringThickness = 100;
int noOfRingsAboveXZPlane = 1;
int noOfPolygonSides = 4;
double planeInterSectionPerpendilarDist = 10;

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
  List<double> axisAngles = [0, 0, 0];
  List<double> spaceRotAngles = [-18, -22, 0];
  List<double> spaceTranslateValues = [w * 0.5, h * 0.5, 0];
  List<double> rotAngles = [0, 0, 0];
  List<double> translateValues = [0, 0, 0];
  List<double> translateValuesWRTSpace = [0, 0, 0];
  List<double> rotAnglesWRTSpace = [0, 0, 0];
  List<String> rotAnglesAxesNames = ["X", "Y", "Z"];
  vm.Vector3 lineAngles = vm.Vector3(0, 0, 0);
  double mainScale = 1;
  @override
  Widget build(BuildContext context) {
    double planeInterSectionPerpendilarDist =
        planeInterSectionPerpendilarDistanceForVector(spacePointsList[3]);
    lineAngles = get_angles_of_vector_though_origin_wrt_3planes_YZ_XY_XZ(
        spacePointsList[3]);
    if (lineAngles.y.toString() == "NaN") {}
    log("NaN : ${lineAngles.y.toString()}");

    if (lineAngles.y.toString().trim() == "NaN" ||
        lineAngles.z.toString().trim() == "NaN") {
    } else {
      axisAngles = [0, (-1) * (lineAngles.y), lineAngles.z * 1];
    }
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
            transform: Matrix4.identity()
              ..scale(mainScale, mainScale, mainScale),
            //  Matrix4.rotationZ(1*180.0.degToRad())..rotateY(1*180.0.degToRad())..rotateX(1*360.0.degToRad()),
            child: Transform(
              origin: Offset(w * 0.5, h * 0.5),
              transform: Matrix4.rotationX(spaceRotAngles[0].degToRad())
                ..rotateY(spaceRotAngles[1].degToRad())
                ..rotateZ(spaceRotAngles[2].degToRad())
                ..translate(spaceTranslateValues[0], spaceTranslateValues[1],
                    spaceTranslateValues[2]),
              child: Stack(children: [
                ...List.generate(planePositionModels.length, (i) {
                  return plane(i);
                }),
                Positioned(
                    child: Transform(
                  transform: Matrix4.rotationX(0)
                    ..translate(
                        planePositionModels[3].translateValuesWRTSpace[0] +
                            planeSize * 0.5,
                        planePositionModels[3].translateValuesWRTSpace[1] +
                            planeSize * 0.5,
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
                // ...List.generate(spacePointsList.length, (i) {
                //   return i < 4
                //       ? Container()
                //       : Positioned(
                //           child: planeFromCentroidPoint(spacePointsList[i],
                //               planeRectSize: Size(300, 100)));
                // }),
                // SphereUsingcircularRingsRotatedwrtXZPlane(  noOfPolygonSides: noOfPolygonSides,
                //   polygonRadius: polygonRadius,),
                // CircleRing3DModelWidgetAtAnglewrtXZPlane(
                //   noOfPolygonSides: noOfPolygonSides,
                //   polygonRadius: polygonRadius,
                //   xzAngle: 45,
                // ),
                CircleRing3DModelWidgetAtAnglewrtXZPlane(
                    noOfPolygonSides: noOfPolygonSides,
                    polygonRadius: polygonRadius,
                    ringThickness: ringThickness

                    //  polygonRadius / (1 + m.sqrt(2)),
                    ),

                // CircleRing3DModelWidget(
                //   noOfPolygonSides: noOfPolygonSides,
                //   polygonRadius: polygonRadius,
                //   ringThickness: polygonRadius / (1 + m.sqrt(2)),
                //   // color: Colors.amber,
                // )
                // Positioned(child: axisLine(axisAngles)),
                // Positioned(child: axisPerpPlane(axisAngles)),
                // Positioned(
                //     child: axisLine(lineAngles.vect3TodoubleList(),
                //         color: Colors.green.shade300))
              ]),
            ),
          )),
          Positioned(
            left: 400,
            top: 50,
            child: Builder(builder: (c) {
              double phi = m.asin(m.sin(lineAngles[2].degToRad()) /
                  (m.sin(lineAngles[1].degToRad())));
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableText("${90 - phi.radToDeg()}",
                      style: const TextStyle(color: Colors.white)),
                  SelectableText(
                      " XZ [ Z axis ]${getAngleofVector_wrt_XZ_Plane(spacePointsList.first)}\n XY [ Y axis ]${getAngleofVector_wrt_XY_Plane(spacePointsList.first)}",
                      style: const TextStyle(color: Colors.white))
                ],
              );
            }),
          ),

          // plane(0),
          // plane(1),

          xyzValuesChart(),
          axisSliderBox(),
          Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
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
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 60,
                        width: 300,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  rotAngles = List.from([
                                    lineAngles.x.roundTo3Places(),
                                    lineAngles.y.roundTo3Places(),
                                    lineAngles.z.roundTo3Places()
                                  ]);
                                });
                              },
                              child: const Text("lineAngles values: ",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            SelectableText(
                                "${lineAngles.x.roundTo3Places()}, ${lineAngles.y.roundTo3Places()}, ${lineAngles.z.roundTo3Places()},",
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
                            InkWell(
                              onTap: () {
                                setState(() {
                                  rotAngles = List.from([
                                    90 - lineAngles.x.roundTo3Places(),
                                    90 - lineAngles.y.roundTo3Places(),
                                    90 - lineAngles.z.roundTo3Places()
                                  ]);
                                });
                              },
                              child: const Text("lineAngles values: ",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            SelectableText(
                                "${90 - lineAngles.x.roundTo3Places()}, ${90 - lineAngles.y.roundTo3Places()}, ${90 - lineAngles.z.roundTo3Places()},",
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  )
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
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              spacePointsList.add(vm.Vector3(200, 200, 200));
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.add_box,
                              color: Colors.amber,
                            )),
                        Container(
                          width: 250,
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
                      ],
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
          origin: planeNo < 3
              ? Offset.zero
              : Offset(planeSize * 0.5, planeSize * 0.5),
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

  Offset position = Offset.zero;
  axisSliderBox() {
    return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) state) {
      return Positioned(
        top: position.dy,
        left: position.dx,
        // alignment: Alignment.topLeft,
        //  Alignment(w - 300 - 300, h - 300),
        child: GestureDetector(
            onPanUpdate: (d) {
              position =
                  Offset(position.dx + d.delta.dx, position.dy + d.delta.dy);
              // log("axisSliderBox ${position}");
              state(() {});
            },
            child: Container(
                width: 300,
                // height: 350,
                color: Colors.blue.shade200,
                child: Column(children: [
                  // Expanded(
                  //     child: Container(
                  //   height: double.infinity,
                  //   width: 300,
                  //   color: Color.fromARGB(255, 9, 49, 82),
                  // )),
                  ExpansionTile(
                    title: Text(""),
                    children: [
                      getAxisSlider(0),
                      getAxisSlider(1),
                      getAxisSlider(2),
                    ],
                  ),

                  ExpansionTile(
                    title: Text(""),
                    children: [
                      Row(
                        children: [
                          IconButton(
                              iconSize: 30,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  xtrans = 0;
                                });
                              },
                              icon: Text("x [${xtrans}]")),
                          IconButton(
                              iconSize: 30,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  ztrans = 0;
                                });
                              },
                              icon: Text("z [${ztrans}]")),
                          IconButton(
                              iconSize: 30,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  ytrans = 0;
                                });
                              },
                              icon: Text("y [${ytrans}]")),
                        ],
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                            trackHeight: 2,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 4)),
                        child: Slider(
                            min: -500,
                            max: 500,
                            divisions: 1000,
                            value: xtrans,
                            onChanged: (double v) {
                              setState(() {
                                xtrans = v;
                              });
                            }),
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                            trackHeight: 2,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 4)),
                        child: Slider(
                            min: -500,
                            max: 500,
                            divisions: 1000,
                            value: ztrans,
                            onChanged: (double v) {
                              setState(() {
                                ztrans = v;
                              });
                            }),
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                            trackHeight: 2,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 4)),
                        child: Slider(
                            min: -500,
                            max: 500,
                            divisions: 1000,
                            value: ytrans,
                            onChanged: (double v) {
                              setState(() {
                                ytrans = v;
                              });
                            }),
                      )
                    ],
                  ),

                  ExpansionTile(title: Text(""), children: [
                    Row(
                      children: [
                        IconButton(
                            iconSize: 50,
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: Text("Rings [${noOfRingsAboveXZPlane}]")),
                        SliderTheme(
                          data: SliderThemeData(
                              trackHeight: 2,
                              thumbShape:
                                  RoundSliderThumbShape(enabledThumbRadius: 4)),
                          child: Slider(
                              min: 1,
                              max: 100,
                              divisions: 100,
                              value: noOfRingsAboveXZPlane.toDouble(),
                              onChanged: (double v) {
                                setState(() {
                                  if (v.toInt() > 0) {
                                    noOfRingsAboveXZPlane = v.toInt();
                                    double angle = (m.pi * 0.5) /
                                        (noOfRingsAboveXZPlane + 1);
                                   
                                    ringThickness =
                                        2 * polygonRadius * m.tan(angle*0.5); log("stepAngle anglee ${(angle*0.5).radToDeg()} / ring ${ringThickness}");
                                  }
                                });
                              }),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            iconSize: 50,
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: Text("Radius [${polygonRadius}]")),
                        SliderTheme(
                          data: SliderThemeData(
                              trackHeight: 2,
                              thumbShape:
                                  RoundSliderThumbShape(enabledThumbRadius: 4)),
                          child: Slider(
                              min: 1,
                              max: 1000,
                              divisions: 999,
                              value: polygonRadius,
                              onChanged: (double v) {
                                setState(() {
                                  polygonRadius = v;

                                    // noOfRingsAboveXZPlane = v.toInt();
                                    double angle = (m.pi * 0.5) /
                                        (noOfRingsAboveXZPlane + 1);
                                   
                                    ringThickness =
                                        2 * polygonRadius * m.tan(angle*0.5); log("stepAngle anglee ${(angle*0.5).radToDeg()} / ring ${ringThickness}");
                               
                                });
                              }),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            iconSize: 50,
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: Text("Polygon [${noOfPolygonSides}]")),
                        SliderTheme(
                          data: SliderThemeData(
                              trackHeight: 2,
                              thumbShape:
                                  RoundSliderThumbShape(enabledThumbRadius: 4)),
                          child: Slider(
                              min: 4,
                              max: 100,
                              divisions: 97,
                              value: noOfPolygonSides.toDouble(),
                              onChanged: (double v) {
                                setState(() {
                                  if (v.toInt() % 2 == 0) {
                                    noOfPolygonSides = v.toInt();
                                  }
                                });
                              }),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            iconSize: 50,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                mainScale = 1;
                              });
                            },
                            icon: Text("Scale [${mainScale}]")),
                        SliderTheme(
                          data: SliderThemeData(
                              trackHeight: 2,
                              thumbShape:
                                  RoundSliderThumbShape(enabledThumbRadius: 4)),
                          child: Slider(
                              min: 0.1,
                              max: 10,
                              divisions: 100,
                              value: mainScale,
                              onChanged: (double v) {
                                setState(() {
                                  mainScale = v;
                                });
                              }),
                        )
                      ],
                    ),
                  ])
                ]))),
      );
    });
  }

  getAxisSlider(int i) {
    return Container(
      width: 300,
      height: 40,
      child: Row(
        children: [
          iconWithTextList[i],
          Expanded(
              child: SliderTheme(
            data: SliderThemeData(
                trackHeight: 2,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4)),
            child: Slider(
                min: -180,
                max: 180,
                divisions: 360,
                value: axisAngles[i],
                onChanged: (double v) {
                  setState(() {
                    axisAngles[i] = v;
                  });
                }),
          )),
          IconButton(
              onPressed: () {
                axisAngles[i] = 0;
                setState(() {});
              },
              padding: EdgeInsets.zero,
              icon: Text(axisAngles[i].toStringAsFixed(1)))
        ],
      ),
    );
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
        children: [
          iconWithTextList[i],
          Expanded(child: getSelectedSlider(i)),
          IconButton(
              onPressed: () {
                setSliderValueToZero(i);
              },
              padding: EdgeInsets.zero,
              icon: Icon(Icons.exposure_zero))
        ],
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
      // log("slider object rot $j");
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

  void setSliderValueToZero(int j) {
    if (j <= 2 && enitiyForSlider == EnitiyForSlider.space) {
      int i = j;
      spaceTranslateValues[i] = 0;
    }
    if (j > 2 && j < 6 && enitiyForSlider == EnitiyForSlider.space) {
      int i = j % 3;
      spaceRotAngles[i] = 0;
    }
    if (j <= 2 && enitiyForSlider == EnitiyForSlider.object) {
      int i = j;
      translateValues[i] = 0;
    }
    if (j > 2 && j < 6 && enitiyForSlider == EnitiyForSlider.object) {
      int i = j % 3;
      rotAngles[i] = 0;
    }

    if (j > 5 && j < 9 && enitiyForSlider == EnitiyForSlider.object) {
      int i = j % 3;
      translateValuesWRTSpace[i] = 0;
    }
    if (j > 8 && j < 12 && enitiyForSlider == EnitiyForSlider.object) {
      // log("slider object rot $j");
      int i = j % 3;
      rotAnglesWRTSpace[i] = 0;
    }
    if (j <= 2 && enitiyForSlider == EnitiyForSlider.point) {
      int i = j;
      double v = 0;
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
    }

    setState(() {});
  }

  // getSelectedSlider(int i) {}

  // iconWithText(int i) {}

}

double ztrans = 0;
double xtrans = 0;
double ytrans = 0;
planeFromCentroidPoint(
  vm.Vector3 vector3, {
  Size planeRectSize = const Size(100, 100),
  Color color = Colors.white,
  int alpha = 244,
  double distFromOriginToPlane = 200,
}) {
  vm.Vector3 lineAngles = vm.Vector3(0, 0, 0);
  lineAngles = get_angles_of_vector_though_origin_wrt_3planes_YZ_XY_XZ(vector3);

  List<double> axisAngles = [0, 0, 0];

  if (lineAngles.y.toString().trim() == "NaN" ||
      lineAngles.z.toString().trim() == "NaN" ||
      lineAngles.x.toString().trim() == "NaN") {
    lineAngles = vm.Vector3(0, 0, 0);
  } else {
    if (vector3.x < 0) {
      axisAngles = [0, (-1) * (lineAngles.y), lineAngles.z * (1)];
    } else {
      axisAngles = [0, (-1) * (lineAngles.y), lineAngles.z * 1];
    }
  }
  log("${vector3.x} lineangle ${lineAngles}\naxisAngles ${axisAngles}");
  // double z = get_squre_root_value_of_any_vector(vector3);
  double z = polygonRadius;
  // axisAngles = [0,0,0];
  double planeW = planeRectSize.width;
  double planeH = planeRectSize.height;
  return Transform(
    transform: Matrix4.rotationY(vector3.x < 0 ? m.pi : 0),
    child: Transform(
      transform: Matrix4.translationValues(0, 0, 0),
      child: Transform(
        transform: Matrix4.rotationX(axisAngles[0].degToRad())
          ..rotateY(axisAngles[1].degToRad())
          ..rotateZ(axisAngles[2].degToRad()),
        child: Transform(
          origin:
              // Offset.zero,
              Offset(planeW * 0.5, planeH * 0.5),
          transform: Matrix4.translationValues(
              z
              //  xtrans-planeW*0.5
              ,
              ytrans - planeH * 0.5,
              ztrans + planeW * 0.5),
          child: Transform(
            transform: Matrix4.rotationX(axisAngles[0].degToRad() * 0)
              ..rotateY(axisAngles[1].degToRad() * 0 + 90.0.degToRad())
              ..rotateZ(axisAngles[2].degToRad() * 0),
            child: Container(
              width: planeW,
              height: planeH,
              color: (color).withAlpha(alpha),
              child: Stack(
                children: [
                  Positioned(
                    left: planeW * 0.5 - 5,
                    top: planeH * 0.5 - 10,
                    child: Container(
                      width: 10,
                      height: 10,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

axisPerpPlane(List<double> lineAngles, {double? length, Color? color}) {
  double planeW = 200;
  double planeH = 100;
  return Transform(
    transform: Matrix4.translationValues(0, -planeH * 0.5, 0),
    child: Transform(
      transform:

          // Matrix4.identity(),
          Matrix4.rotationX(lineAngles[0].degToRad())
            ..rotateY(lineAngles[1].degToRad())
            ..rotateZ(lineAngles[2].degToRad()),
      // Matrix4.rotationX(90 - lineAngles[0].degToRad())
      //   ..rotateY(90 - lineAngles[1].degToRad())
      //   ..rotateZ(90 - lineAngles[2].degToRad()),
      child: Transform(
        origin:
            //  Offset.zero,
            Offset(
                planeW * 0.5,
                // planeInterSectionPerpendilarDist*0.5,
                // (length ?? 600) * 0.5,
                planeH * 0.5),
        transform: Matrix4.rotationX(
            lineAngles[0].degToRad() * 0 + 0 * 90.0.degToRad())
          ..rotateY(90.0.degToRad())
          ..rotateZ(lineAngles[2].degToRad() * 0),
        child: Container(
          width: planeW,
          height: planeH,
          color: (color ?? Colors.white).withAlpha(120),
          child: Stack(
            children: [
              Positioned(
                left: planeW * 0.5 - 5,
                top: planeH * 0.5 - 10,
                child: Container(
                  width: 10,
                  height: 10,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

axisLine(List<double> lineAngles, {double? length, Color? color}) {
  log("axisLine ${lineAngles}");
  return Transform(
    transform:

        // Matrix4.identity(),
        Matrix4.rotationX(lineAngles[0].degToRad())
          ..rotateY(lineAngles[1].degToRad())
          ..rotateZ(lineAngles[2].degToRad()),
    // Matrix4.rotationX(90 - lineAngles[0].degToRad())
    //   ..rotateY(90 - lineAngles[1].degToRad())
    //   ..rotateZ(90 - lineAngles[2].degToRad()),
    child: Container(
      width:

          // planeInterSectionPerpendilarDist,
          length ?? 600,
      height: 2,
      color: color ?? Colors.white,
    ),
  );
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
