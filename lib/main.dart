import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:three_d_model_tool/2D%20Geometris/bezier_curve.dart';
import 'package:three_d_model_tool/2D%20Geometris/conic_curve.dart';
import 'package:three_d_model_tool/2D%20Geometris/polycurve.dart';
import 'package:three_d_model_tool/3D%20Paint/gradient_creator.dart';
import 'package:three_d_model_tool/3D%20Paint/paint_3d_1.dart';
import 'package:three_d_model_tool/3D%20Plane%20in%20Space/3d_plane_in_space_trial1.dart';
import 'package:three_d_model_tool/3D%20Plane%20in%20Space/ThreeD_plane_in_space_trial1_2D_Planar_Objects.dart';

import 'package:three_d_model_tool/constants/consts.dart';
import 'package:three_d_model_tool/demo/nthdegreepolycurve.dart';
import 'package:three_d_model_tool/demo/physics_demo.dart';
import 'package:three_d_model_tool/others/kbc_option_box.dart';
import 'package:three_d_model_tool/others/kbc_option_demo.dart';
import 'package:three_d_model_tool/provider/gradient_provider.dart';
import 'package:three_d_model_tool/provider/paint3d_provider.dart';
import 'package:three_d_model_tool/tried/loading_bouncing_box_animation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Paint3DProv()),
        ChangeNotifierProvider(create: (context) => GradProvider())
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: 
          
          // true?GradientCreator():
          Builder(builder: (context) {
            w = MediaQuery.of(context).size.width;
            h = MediaQuery.of(context).size.height;
   colorListBoxW = w * 0.25;
   colorListBoxH = h = 0.6;
   sliderWidth = w * 0.7;
   gradeSelectBoxW = h * 0.1;
   demoBoxSizeW = h * 0.4;
   demoBoxSizeH = h * 0.4;
   tileModeW = h * 0.1;
   pointRad = 12;
             log("demoo demo ${w} / $h");
            return
                // PhysicsDemo();
                // KBC_option_demo_page();
                // KBCOptionPage();
                // Loading_bouncing_box_animation();
                GradientCreator();
            // Paint3DPage1();
            // ConicCurvePage();
            // BezeirCurvePage();
            // NthDegreePolyCurvePage();
            // ThreeD_plane_in_space_trial1_2D_Planar_Objects();
            // ThreeD_plane_in_space_trial1_Sphere();
          })),
    );
  }
}
