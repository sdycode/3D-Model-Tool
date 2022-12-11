import 'dart:developer';
import 'dart:math' as m;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:three_d_model_tool/3D%20Paint/gradient_creator.dart';

enum GradientType { linear, radial, sweep }

class GradProvider with ChangeNotifier {
  updateUi() {
    notifyListeners();
  }

  GradientType gradientType = GradientType.linear;
  TileMode selectedTileMode = TileMode.clamp;
  Alignment linearAlignStart = Alignment(0.1, 0.1);
  Alignment linearAlignEnd = Alignment(0.9, 0.9);
  Offset linearAlignStartPoint = Offset(0, 0);
  Offset linearAlignEndPoint = Offset(0, 0);

  Alignment radialAlignCenter = Alignment(0, 0);
  Alignment radialAlignFocal = Alignment(1, 1);
  Offset radialAlignCenterPoint = Offset(0, 0);
  Offset radialAlignFocalPoint = Offset(0, 0);
  double radialRadius = 0.5;
  double radialFocalRadius = 0.0;

  Alignment sweepAlignCenter = Alignment(0, 0);
  Offset sweepAlignCenterPoint = Offset(0, 0);
  double sweepStartAngle = 0;
  double sweepEndAngle = m.pi * 2;
  List<ColorStopModel> colorStopModels = [
    ColorStopModel(0.0, "fff8b249"),
    ColorStopModel(1.0, "fffee795")
  ];

  updateAlignPointsForBoxSize(Size boxSize) {
    double bw = boxSize.width;
    double bh = boxSize.height;
    linearAlignEndPoint = Offset(bw, bh);
    radialAlignFocalPoint = Offset(bw * 1, bh*1);

    radialAlignCenterPoint = Offset(bw * 0.5, bh * 0.5);
    sweepAlignCenterPoint = Offset(bw * 0.5, bh * 0.5);
    // radialAlignFocalPoint = Offset();
  }

  addNewColorStopModel(ColorStopModel colorStopModel) {
    colorStopModels.add(colorStopModel);
  }

  removeColorStopModel(ColorStopModel colorStopModel) {
    if (colorStopModels.contains(colorStopModel)) {
      colorStopModels.remove(colorStopModel);
    }
  }

  sortColorStopModelsAsPerStopValue(int ind, [bool ascending = true]) {
    // colorStopModels.sort((a, b) {
    //   return a.colorStop.compareTo(b.colorStop);
    // });

    ColorStopModel cmodel = ColorStopModel.copy(colorStopModels[ind]);
    int legthBeforeRemove = colorStopModels.length;
    log("bef remove aftersort $ind /ll ${colorStopModels.length}");
    colorStopModels.removeAt(ind);
//  return;
    log("bef aftersort $ind /ll ${colorStopModels.length} / ${cmodel.colorStop}");
    log("bef aftersort insert $ind / ${colorStopModels.length}");

    // return;
    for (var i = 0; i < colorStopModels.length; i++) {
      if (cmodel.colorStop < colorStopModels[i].colorStop) {
        if (i < ind) {
          colorStopModels.insert(
              i, ColorStopModel(cmodel.colorStop, cmodel.hexColorString));
          // colorStopModels.removeAt(ind + 1);
        } else {
          colorStopModels.insert(
              i, ColorStopModel(cmodel.colorStop, cmodel.hexColorString));
          // colorStopModels.removeAt(ind - 1);
        }
        break;
      }
    }
    if (colorStopModels.length != legthBeforeRemove) {
      colorStopModels.add(cmodel);
    }
    log("aftersort ${colorStopModels.map((e) => e.colorStop)}");
    log("aftersort ${colorStopModels.map((e) => e.hexColorString)}");
    return;
  }
}
