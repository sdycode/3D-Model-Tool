import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'package:three_d_model_tool/extensions.dart';
import 'package:three_d_model_tool/math/get_angle_between_2_planes.dart';
import 'package:three_d_model_tool/math/get_angles_and_translated_value_for_trianlge_points.dart';
import 'package:three_d_model_tool/math/get_angles_of_vector_though_origin_wrt_3planes.dart';
import 'package:three_d_model_tool/math/get_line_perp_to_plane.dart';
import 'package:three_d_model_tool/math/model/plane_equation_model.dart';
import 'package:vector_math/vector_math.dart' as v;

class EquationScreen extends StatefulWidget {
  EquationScreen({Key? key}) : super(key: key);

  @override
  State<EquationScreen> createState() => _EquationScreenState();
}

class _EquationScreenState extends State<EquationScreen> {
  List<double> _3x3MatrixValues = [1, 0, 0, 0, 1, 0, 0, 0, 1];
  v.Vector3 interSectionPoint = v.Vector3(0, 0, 0);
  v.Vector3 lineAngles = v.Vector3(0, 0, 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Row(
            children: [_3x3MatrixFor3Dplane(), _3dPlaneEquationFrom3x3Matrix()],
          )
        ],
      ),
    );
  }

  _3x3MatrixFor3Dplane() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey,
      child: GridView.builder(
          itemCount: _3x3MatrixValues.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (c, i) {
            TextEditingController controller =
                TextEditingController(text: _3x3MatrixValues[i].toString());
            return Container(
              width: 36,
              height: 36,
              color: Colors.black,
              child: Center(
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: controller,
                  onSubmitted: (d) {
                    setState(() {});
                  },
                  onChanged: (d) {
                    if (double.tryParse(d) != null) {
                      _3x3MatrixValues[i] = double.parse(d);
                    }
                  },
                ),
              ),
            );
          }),
    );
  }

  _3dPlaneEquationFrom3x3Matrix() {
    PlaneEquation? pe = getPlaneEquationFrom3Points(
        getListof3Vector3sFromcoorinatelistof9(_3x3MatrixValues))!;
    interSectionPoint = getInterSectionPointForPlane(pe);
    log("interppoit values ${interSectionPoint} / ");
    lineAngles =
        get_angles_of_vector_though_origin_wrt_3planes(interSectionPoint);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          width: 200,
          child: Text(
            pe != null
                ? "${pe.x}x + ${pe.y}y + ${pe.z}z = ${pe.c}  "
                : "No points",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          height: 60,
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("[ ", style: TextStyle(color: Colors.white)),
              ..._3x3MatrixValues.map((double e) {
                return Text("${e.toInt()}, ",
                    style: TextStyle(color: Colors.white));
              }),
              Text(" ] ", style: TextStyle(color: Colors.white))
            ],
          ),
        ),
        Container(
          height: 60,
          width: w * 0.7,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Intersect Point : ",
                  style: TextStyle(color: Colors.white)),
              SelectableText(
                  "${interSectionPoint.x.roundTo3Places()}, ${interSectionPoint.y.roundTo3Places()}, ${interSectionPoint.z.roundTo3Places()},",
                  style: const TextStyle(color: Colors.white)),
              
            ],
          ),
        ),
  Container(
          height: 60,
          width: w * 0.7,
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
    );
  }
}
