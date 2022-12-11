// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as m;
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart' hide Gradient;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/curves/get_arc_model.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/functions%20to%20fill%20CurvePoints%20data/get_enums_to_fill_curvePointsList_from_map_data.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/model/PathModel.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/model/arc_model.dart';
import 'package:three_d_model_tool/2D%20Gerometry%20Functions/model/curve_point.dart';
import 'package:three_d_model_tool/3D%20Paint/dartCodeWithCopyButton.dart';
import 'package:three_d_model_tool/3D%20Plane%20in%20Space/3d_plane_in_space_trial1.dart';
import 'package:three_d_model_tool/constants/consts.dart';
import 'package:three_d_model_tool/constants/get_index_for_list.dart';
import 'package:three_d_model_tool/constants/icons_images_paths.dart';
import 'package:three_d_model_tool/enum/enums.dart';
import 'package:three_d_model_tool/math/get_dist_between_2_points.dart';
import 'package:three_d_model_tool/provider/paint3d_provider.dart';
import 'package:three_d_model_tool/res/colors_row.dart';
import 'package:url_launcher/url_launcher.dart';

bool _strokePath = true;

class Paint3DPage1 extends StatefulWidget {
  Paint3DPage1({Key? key}) : super(key: key);

  @override
  State<Paint3DPage1> createState() => _Paint3DPage1State();
}

int _selectedPoint = -1;
double _rad = 0.5;
List<CurvePoint> _points = [];
double _pointSize = 10;
Map<int, int> _selectedPoints = {};
double _arcRadius = 50;
Size _paintBoxSize = Size(0, 0);
List<PathModel> pathModels = [
  PathModel.withCurvePoints(List.from(_points),
      paint: Paint()..color = Colors.primaries.first, pathName: "path0")
];
int pathModelIndex = 0;
List<CurvePoint> list = [];

// get
class _Paint3DPage1State extends State<Paint3DPage1> {
  late Paint3DProv p;
  @override
  Widget build(BuildContext context) {
    _paintBoxSize = Size(h * 0.8, h * 0.8);
    const _kFontFam = 'IslamicIcons';
    const fontarm = "Arapey-Regular";

    ///Package name
    const String _kFontPkg = "flutter_islamic_icons";

    ///Allah 99 Icon
    const IconData allah99 =
        IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
    Paint3DProv p = Provider.of<Paint3DProv>(context);
    // log("hei $h : ${MediaQuery.of(context).size.height} / points ${_points.length}");
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(fit: StackFit.loose, children: [
          // Positioned(right: 0, bottom: 0, child: ColorsRow(w * 0.4, 30)),
          Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: w * 0.5,
                height: 40,
                child: Row(
                  children: [
                    ...List.generate(pathModels.length, (i) {
                      return TextButton(
                          onPressed: () {
                            _points = pathModels[i].points;
                            pathModelIndex = i;
                            _selectedPoint = -1;
                            _selectedPoints.clear();
                            setState(() {});
                          },
                          child: Text(
                            i.toString(),
                            style: TextStyle(
                                fontSize: pathModelIndex == i ? 25 : 18),
                          ));
                    }),
                    IconButton(
                        onPressed: () {
                          pathModels.add(
                            PathModel.withCurvePoints([],
                                paint: Paint()
                                  ..color = Colors.primaries[
                                      (pathModels.length) %
                                          Colors.primaries.length]
                                  ..strokeWidth = 3,
                                pathName: "path${pathModels.length}"),
                          );
                          _points = pathModels.last.points;
                          _selectedPoint = -1;
                          _selectedPoints.clear();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ))
                  ],
                ),
              )),
          Positioned(
            top: 0,
            width: w,
            height: 30,
            child: Slider(
                value: _rad,
                min: 0.05,
                max: 0.5,
                divisions: 100,
                onChanged: (d) {
                  setState(() {
                    _rad = d;
                  });
                }),
          ),
          Positioned(
            top: 50,
            width: w,
            height: 30,
            child: Slider(
                activeColor: Colors.orange,
                value: _arcRadius,
                min: 0.0,
                max: 500,
                divisions: 500,
                onChanged: (d) {
                  setState(() {
                    _arcRadius = d;

                    if (checkIfIndexPresentInList(_points, _selectedPoint)) {
                      _points[_selectedPoint].tempArcRadius = d;
                      updatePrePostBothPointsForPoint(_selectedPoint);
                    }
                  });
                }),
          ),
          Positioned(
              left: 50,
              top: 100,
              child: Container(
                width: h * 0.8,
                height: h * 0.8,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 0, 0),
                    border: Border.all(
                      color: Colors.white,
                    )),
                child: CustomPaint(
                  painter: _PointPainter(),
                  child: Stack(children: [
                    Column(
                      children: [
                        Icon(
                          IconData(
                            0xe810,
                            fontFamily: fontarm,
                            // fontPackage: _kFontPkg
                          ),
                          // UniconsLine.apps,
                          size: 50,
                          color: Colors.amber,
                        )
                      ],
                    ),
                    GestureDetector(
                      onTapUp: (d) {
                        _points.add(CurvePoint.withIndexAndOffset(
                            index: _points.length, point: d.localPosition));
                        _selectedPoint = _points.length - 1;
                        _setCurvePointJustAfterAdded(_selectedPoint);
                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                      ),
                    ),
                    ...List.generate(_points.length, (i) {
                      return Positioned(
                          left: _points[i].point.dx - _pointSize * 0.5,
                          top: _points[i].point.dy - _pointSize * 0.5,
                          child: GestureDetector(
                            onTap: () {
                              _selectedPoint = i;
                              if (_selectedPoints.containsKey(i)) {
                                _selectedPoints.remove(i);
                              } else {
                                _selectedPoints.putIfAbsent(i, () => i);
                              }
                              p.updateUi();
                            },
                            onPanUpdate: (d) {
                              _points[i].point = Offset(
                                _points[i].point.dx + d.delta.dx,
                                _points[i].point.dy + d.delta.dy,
                              );

                              _points[i].prePoint = Offset(
                                _points[i].prePoint.dx + d.delta.dx,
                                _points[i].prePoint.dy + d.delta.dy,
                              );
                              _points[i].postPoint = Offset(
                                _points[i].postPoint.dx + d.delta.dx,
                                _points[i].postPoint.dy + d.delta.dy,
                              );
                              updatePrePostBothPointsForPoint(i);
                              p.updateUi();
                            },
                            child: Transform.scale(
                              scale: _selectedPoint == i ? 1.3 : 1.0,
                              child: Container(
                                width: _pointSize,
                                height: _pointSize,
                                decoration: BoxDecoration(
                                  border: _selectedPoint == i
                                      ? Border.all(
                                          width: 2, color: Colors.white)
                                      : null,
                                  color: getItemFromList(i, Colors.primaries),
                                ),
                              ),
                            ),
                          ));
                    }),
                    ...(_selectedPoints.keys.map((int k) {
                      return Positioned(
                          left: _points[k].prePoint.dx - _pointSize * 0.5,
                          top: _points[k].prePoint.dy - _pointSize * 0.5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            onPanUpdate: (d) {
                              _points[k].prePoint = Offset(
                                _points[k].prePoint.dx + d.delta.dx,
                                _points[k].prePoint.dy + d.delta.dy,
                              );
                              _selectedPoint = k;
                              if (_points[k].pointSymmetry !=
                                  PointSymmetry.nonSymmetric) {
                                bool isPre = true;
                                _updatePrePostPointForSymmetry(isPre, k);
                              }

                              setState(() {});
                            },
                            child: Container(
                              width: _pointSize,
                              height: _pointSize,
                              color: Colors.purple.withAlpha(150),
                            ),
                          ));
                    })),
                    ...(_selectedPoints.keys.map((int k) {
                      return Positioned(
                          left: _points[k].postPoint.dx - _pointSize * 0.5,
                          top: _points[k].postPoint.dy - _pointSize * 0.5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            onPanUpdate: (d) {
                              _points[k].postPoint = Offset(
                                _points[k].postPoint.dx + d.delta.dx,
                                _points[k].postPoint.dy + d.delta.dy,
                              );
                              _selectedPoint = k;
                              if (_points[k].pointSymmetry !=
                                  PointSymmetry.nonSymmetric) {
                                bool isPre = false;
                                _updatePrePostPointForSymmetry(isPre, k);
                              }

                              setState(() {});
                            },
                            child: Container(
                              width: _pointSize,
                              height: _pointSize,
                              color: Colors.green.withAlpha(150),
                            ),
                          ));
                    })),
                  ]),
                ),
              )),
          if (_isSelectedPoint())
            Positioned(
                top: 100,
                right: 0,
                child:
                    // FlutterLogo(
                    //   size: 100,
                    // )
                    _PointCurvetypeWidget())
          // CustomPaint(
          //   size: Size(400, 400),
          //   painter: _Painter(),
          // )
        ]),
      ),
    );
  }

  bool _isSelectedPoint() {
    if (_selectedPoint >= 0 && _selectedPoint < _points.length) {
      return true;
    }
    return false;
  }

  void _setCurvePointJustAfterAdded(int i) {
    if (_points.length == 0) {
      return;
    }
    if (i == 1) {
      /// 2nd point added and modify start point (i.e first point along with 2nd)
      /// modify start point
      Offset startPostPoint =
          Offset.lerp(_points[0].point, _points[1].point, 0.3) ??
              _points[0].point;
      Offset startPrePoint =
          Offset.lerp(_points[0].point, startPostPoint, -0.3) ??
              _points[0].point;
      _points[0].prePoint = startPrePoint;
      _points[0].postPoint = startPostPoint;

      /// modify current point
      ///
      Offset prePoint = Offset.lerp(_points[0].point, _points[1].point, 0.7) ??
          _points[1].point;
      Offset postPoint = Offset.lerp(_points[0].point, _points[1].point, 0.7) ??
          _points[1].point;
      _points[1].prePoint = prePoint;
      _points[1].postPoint = postPoint;
    } else {
      /// i>1 [ 2,3,4,. . . . ]
      /// modify post point of previous (i.e  i-1 point)
      Offset previousPostPoint =
          Offset.lerp(_points[i - 1].point, _points[i].point, 0.3) ??
              _points[i - 1].point;
      _points[i - 1].postPoint = previousPostPoint;

      /// modify current point
      Offset prePoint =
          Offset.lerp(_points[i - 1].point, _points[i].point, 0.7) ??
              _points[i].point;
      Offset postPoint = Offset.lerp(_points[i].point, _points[0].point, 0.3) ??
          _points[i].point;

      _points[i].prePoint = prePoint;
      _points[i].postPoint = postPoint;
    }
  }
}

bool checkIfIndexPresentInList(List<dynamic> list, int i) {
  if (i >= 0 && i < list.length) {
    return true;
  }
  return false;
}

setCubicBezeirToQuadIfNextIsNormal(int i) {
  int next = (i + 1) % _points.length;
  if (_points[i].arcTypeOnPoint == ArcTypeOnPoint.normal) {
    if (_points[next].prePointCurveType == PrePointCurveType.cubicBezier) {
      _points[i].postPointCurveType = PostPointCurveType.normal;
      _points[next].prePointCurveType == PrePointCurveType.quadBezier;
    }
  }
}

class _PointPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    Paint paint = Paint()
      ..strokeWidth = 3
      // ..color = Colors.red
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(s.width, s.height),
        [Colors.red, Colors.amber],
      )
      ..style = _strokePath ? PaintingStyle.stroke : PaintingStyle.fill;
    Path path = Path();
    if (_points.length < 2) {
      return;
    }

    for (var i = 1; i < _points.length; i++) {
      if (i == 1) {
        // && _points[0].arcTypeOnPoint != ArcTypeOnPoint.arc
        path.moveTo(_points.first.point.dx, _points.first.point.dy);
        if (!_strokePath) {
          path.moveTo(_points[i - 1].postArcEndPoint.dx,
              _points[i - 1].postArcEndPoint.dy);
        }
      } else {}
      if (_points[i - 1].postPointCurveType == PostPointCurveType.arc) {
        // move to
        path.lineTo(_points[i - 1].postArcEndPoint.dx,
            _points[i - 1].postArcEndPoint.dy);
      } else {
        // move to
        path.lineTo(_points[i - 1].point.dx, _points[i - 1].point.dy);
      }
      int nextIndex = (i + 1) % _points.length;
      int preIndex = i - 1;
      Offset p = _points[i].point;
      Offset pre = _points[i].prePoint;
      Offset postPoint = _points[i].postPoint;
      Offset preArcEnd = _points[i].preArcEndPoint;
      Offset postArcEnd = _points[i].postArcEndPoint;
      Offset prePost = _points[i - 1].postPoint;
      Offset nextPoint = _points[nextIndex].point;

      // Check next of arc  point is cubic bezier ( and make pre point of next as quad from cubic)

      if (_points[i].arcTypeOnPoint == ArcTypeOnPoint.arc) {
        if (_points[nextIndex].prePointCurveType ==
            PrePointCurveType.cubicBezier) {
          _points[nextIndex].prePointCurveType = PrePointCurveType.quadBezier;
        }
      }

      if (_points[i].prePointCurveType == PrePointCurveType.normal) {
        path.lineTo(p.dx, p.dy);
      } else if (_points[i].prePointCurveType == PrePointCurveType.quadBezier) {
        path.quadraticBezierTo(pre.dx, pre.dy, p.dx, p.dy);
        if (_points[nextIndex].arcTypeOnPoint == ArcTypeOnPoint.normal) {
          path.quadraticBezierTo(
              postPoint.dx, postPoint.dy, nextPoint.dx, nextPoint.dy);
          i++;
        }
      } else if (_points[i].prePointCurveType ==
          PrePointCurveType.cubicBezier) {
        path.cubicTo(prePost.dx, prePost.dy, pre.dx, pre.dy, p.dx, p.dy);
      } else if (_points[i].prePointCurveType == PrePointCurveType.arc) {
        if (_points[i - 1].postPointCurveType ==
            PostPointCurveType.quadBezier) {
          path.quadraticBezierTo(
              prePost.dx, prePost.dy, preArcEnd.dx, preArcEnd.dy);
        }
        path.lineTo(preArcEnd.dx, preArcEnd.dy);
        path.arcToPoint(postArcEnd,
            radius: Radius.circular(_points[i].arcRadius),
            clockwise: _points[i].isArcClockwise);

        // i++;
        // path.lineTo(nextPoint, y)
        canvas.drawPoints(
            PointMode.points,
            [preArcEnd, postArcEnd],
            Paint()
              ..color = Colors.amber
              ..strokeWidth = 6);
      }
    }
    if (!_open) {
      Offset pLast = _points[0].point;
      Offset preLast = _points[0].prePoint;
      Offset preArcEnd = _points[0].preArcEndPoint;
      Offset postArcEnd = _points[0].postArcEndPoint;
      Offset prePostLast = _points.last.postPoint;

      int nextIndex = 1;

      if (_points[0].arcTypeOnPoint == ArcTypeOnPoint.arc) {
        if (_points[nextIndex].prePointCurveType ==
            PrePointCurveType.cubicBezier) {
          _points[nextIndex].prePointCurveType = PrePointCurveType.quadBezier;
        }
      }
      if (_points[0].prePointCurveType == PrePointCurveType.normal) {
        path.lineTo(pLast.dx, pLast.dy);
      } else if (_points[0].prePointCurveType == PrePointCurveType.quadBezier) {
        path.quadraticBezierTo(preLast.dx, preLast.dy, pLast.dx, pLast.dy);
        if (_points[1].arcTypeOnPoint == ArcTypeOnPoint.normal) {
          Offset postPoint = _points[0].postPoint;
          Offset nextPoint = _points[1].point;
          path.quadraticBezierTo(
              postPoint.dx, postPoint.dy, nextPoint.dx, nextPoint.dy);
          // i++;
        }
      } else if (_points[0].prePointCurveType ==
          PrePointCurveType.cubicBezier) {
        path.cubicTo(prePostLast.dx, prePostLast.dy, preLast.dx, preLast.dy,
            pLast.dx, pLast.dy);
      } else if (_points[0].prePointCurveType == PrePointCurveType.arc) {
        path.lineTo(preArcEnd.dx, preArcEnd.dy);
        path.arcToPoint(postArcEnd,
            radius: Radius.circular(_points[0].arcRadius),
            clockwise: _points[0].isArcClockwise);
        canvas.drawPoints(
            PointMode.points,
            [preArcEnd, postArcEnd],
            Paint()
              ..color = Colors.amber
              ..strokeWidth = 6);
      }

      if (!_strokePath) {
        path.close();
      }
    }

    canvas.drawPath(path, paint);

    Path preLinePath = Path();
    Path postLinePath = Path();
    Paint prePathPaint = Paint()
      ..strokeWidth = 1.5
      ..color = Colors.deepPurple
      ..style = PaintingStyle.stroke;
    Paint postPathPaint = Paint()
      ..strokeWidth = 1.5
      ..color = Colors.green
      ..style = PaintingStyle.stroke;

    _selectedPoints.forEach((k, v) {
      if (checkIfIndexPresentInList(_points, k)) {
        preLinePath.moveTo(_points[k].point.dx, _points[k].point.dy);
        preLinePath.lineTo(_points[k].prePoint.dx, _points[k].prePoint.dy);

        postLinePath.moveTo(_points[k].point.dx, _points[k].point.dy);
        postLinePath.lineTo(_points[k].postPoint.dx, _points[k].postPoint.dy);
      }
      // preLinePath.moveTo(_p, y)
    });

    canvas.drawPath(preLinePath, prePathPaint);

    canvas.drawPath(postLinePath, postPathPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// int _typeIndex
class _PointCurvetypeWidget extends StatelessWidget {
  _PointCurvetypeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Paint3DProv p = Provider.of<Paint3DProv>(context);
    // log("in _PointCurvetypeWidget $_selectedPoint ");
    return !(_selectedPoint >= 0 && _selectedPoint < _points.length)
        ? Container()
        : Container(
            width: w * 0.4,
            height: h * 0.6,
            color: Colors.amber.shade100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: w * 0.4,
                    height: w * 0.1,
                    child: ListView.builder(
                        itemCount: curvePointIcons.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (c, i) {
                          return InkWell(
                            onTap: () {
                              if (checkIfIndexPresentInList(
                                  _points, _selectedPoint)) {
                                _points[_selectedPoint].arcTypeOnPoint =
                                    ArcTypeOnPoint.values[i];
                                updatePrePostCurveTypeBasedOnArcTypeOnPoint(
                                    _selectedPoint);

                                updatePrePostBothPointsForPoint(_selectedPoint);
                                setCubicBezeirToQuadIfNextIsNormal(
                                    _selectedPoint);
                                p.updateUi();
                              }
                            },
                            child: Container(
                              width: w * 0.06,
                              height: w * 0.06,
                              decoration: BoxDecoration(
                                  border: (checkIfIndexPresentInList(
                                          _points, _selectedPoint))
                                      ? _points[_selectedPoint]
                                                  .arcTypeOnPoint ==
                                              ArcTypeOnPoint.values[i]
                                          ? Border.all()
                                          : null
                                      : null),
                              child: Image.asset(
                                curvePointIcons[i],
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        })),
                Container(
                  width: w * 0.4,
                  height: h * 0.12,
                  child: ListView.builder(
                      itemCount: PrePointCurveType.values.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (c, i) {
                        return Transform.scale(
                            scale: _points[_selectedPoint].prePointCurveType ==
                                    PrePointCurveType.values[i]
                                ? 1.3
                                : 1.0,
                            child: InkWell(
                              onTap: () {
                                if (i == 1) {
                                  _points[_selectedPoint].postPointCurveType =
                                      PostPointCurveType.values[i];
                                  _points[_selectedPoint].prePointCurveType =
                                      PrePointCurveType.values[i];
                                  // post of previous point
                                  int preNo = _selectedPoint > 0
                                      ? _selectedPoint - 1
                                      : _points.length - 1;
                                  _points[preNo].postPointCurveType =
                                      PostPointCurveType.values[i];
                                  // pre of next point

                                  _points[(_selectedPoint + 1) % _points.length]
                                          .prePointCurveType =
                                      PrePointCurveType.values[i];
                                } else {
                                  _points[_selectedPoint].prePointCurveType =
                                      PrePointCurveType.values[i];
                                }
                                p.updateUi();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Chip(
                                  label: Text(
                                    PrePointCurveType.values[i].name,
                                  ),
                                ),
                              ),
                            ));
                      }),
                ),
                Container(
                  width: w * 0.4,
                  height: h * 0.12,
                  child: ListView.builder(
                      itemCount: PostPointCurveType.values.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (c, i) {
                        return Transform.scale(
                            scale: _points[_selectedPoint].postPointCurveType ==
                                    PostPointCurveType.values[i]
                                ? 1.3
                                : 1.0,
                            child: InkWell(
                              onTap: () {
                                if (i == 1) {
                                  _points[_selectedPoint].postPointCurveType =
                                      PostPointCurveType.values[i];
                                  _points[_selectedPoint].prePointCurveType =
                                      PrePointCurveType.values[i];
                                  // post of previous point
                                  int preNo = _selectedPoint > 0
                                      ? _selectedPoint - 1
                                      : _points.length - 1;
                                  _points[preNo].postPointCurveType =
                                      PostPointCurveType.values[i];
                                  // pre of next point

                                  _points[(_selectedPoint + 1) % _points.length]
                                          .prePointCurveType =
                                      PrePointCurveType.values[i];
                                } else {
                                  _points[_selectedPoint].postPointCurveType =
                                      PostPointCurveType.values[i];
                                }

                                p.updateUi();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Chip(
                                  label: Text(
                                    PostPointCurveType.values[i].name,
                                  ),
                                ),
                              ),
                            ));
                      }),
                ),
                Row(
                  children: [
                    if (checkIfIndexPresentInList(_points, _selectedPoint))
                      Container(
                        height: 60,
                        width: w * 0.3,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: PointSymmetry.values.length,
                            itemBuilder: (c, i) {
                              return ElevatedButton.icon(
                                  onPressed: () {
                                    _points[_selectedPoint].pointSymmetry =
                                        PointSymmetry.values[i];

                                    p.updateUi();
                                  },
                                  icon: Icon(
                                      _points[_selectedPoint].pointSymmetry ==
                                              PointSymmetry.values[i]
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank),
                                  label: Text(PointSymmetry.values[i].name));
                            }),
                      ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          _open = !_open;

                          p.updateUi();
                        },
                        icon: Icon(_open
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                        label: Text(_open ? "Open" : "Close")),
                    ElevatedButton.icon(
                        onPressed: () {
                          _strokePath = !_strokePath;

                          p.updateUi();
                        },
                        icon: Icon(_strokePath
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                        label: Text(_strokePath ? "Stroke" : "Fill")),
                    ElevatedButton.icon(
                        onPressed: () async {
                          // _printCurvpoitvsinMapForm();
                          // getStringOfCurvePOintsInListofObjectsFrom(_points, 0);
                          String painterClassName = "MyFirstPainter";
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: Container(
                                      height: h * 0.9,
                                      color: Color.fromARGB(255, 241, 238, 220),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ExpansionTile(
                                              title: Row(
                                                children: [
                                                  Text(
                                                      "Models & Enums : Add Only Once In Project"),
                                                  Spacer(),
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        Directory? dir =
                                                            await getDownloadsDirectory();
                                                        log("dirpath ${dir?.path}");
                                                        File file = File(
                                                            "${dir?.path}/Painter_Models_Enums.dart");
                                                        String
                                                            totalDataIn1File =
                                                            getModelAndEnumsStringData();
                                                        file.writeAsString(
                                                            totalDataIn1File);
                                                      },
                                                      child: Text(
                                                          "Download Models & Enums")),
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        Directory? dir =
                                                            await getDownloadsDirectory();
                                                        log("dirpath ${dir?.path}");
                                                        String
                                                            painterClassName =
                                                            "MyFirstPainter";
                                                        File file = File(
                                                            "${dir?.path}/${painterClassName}.dart");

                                                        String totalDataIn1File = getImportLinessString() +
                                                            getPaintContainerWidgetAsString(
                                                                painterClassName) +
                                                            getAllStringData(
                                                                painterClassName) +
                                                            getStringOfListOfPathModelsInObjectListForm() +
                                                            getStringofAllCanvasFunctions(
                                                                pathModels) +
                                                            getStringOfAllFunctionsOfCurvepointsList(
                                                                pathModels) +
                                                            getStringOfCommonCanvasFunction();
                                                        file.writeAsString(
                                                            totalDataIn1File);
                                                      },
                                                      child: Text(
                                                          "Download Paint File"))
                                                ],
                                              ),
                                              children: [
                                                DartCodeWithCopyButton(
                                                  w: w * 0.8,
                                                  h: h * 0.3,
                                                  title: "Model - Enums",
                                                  content:
                                                      getModelAndEnumsStringData(),
                                                ),
                                              ],
                                            ),
                                            DartCodeWithCopyButton(
                                              w: w * 0.8,
                                              h: 80,
                                              title: "Import Lines",
                                              content: getImportLinessString(),
                                            ),
                                            DartCodeWithCopyButton(
                                              w: w * 0.8,
                                              h: 120,
                                              title: "Widget",
                                              content:
                                                  getPaintContainerWidgetAsString(
                                                      painterClassName),
                                            ),
                                            DartCodeWithCopyButton(
                                              w: w * 0.8,
                                              h: h * 0.3,
                                              title: "Painter",
                                              content: getAllStringData(
                                                  painterClassName),
                                            ),
                                            DartCodeWithCopyButton(
                                              w: w * 0.8,
                                              h: h * 0.3,
                                              title: "PathModels",
                                              content:
                                                  getStringOfListOfPathModelsInObjectListForm(),
                                            ),
                                            DartCodeWithCopyButton(
                                              w: w * 0.8,
                                              h: h * 0.3,
                                              title: "CanvasFunctions",
                                              content:
                                                  getStringofAllCanvasFunctions(
                                                      pathModels),
                                            ),
                                            DartCodeWithCopyButton(
                                              w: w * 0.8,
                                              h: h * 0.3,
                                              title: "Points List",
                                              content:
                                                  getStringOfAllFunctionsOfCurvepointsList(
                                                      pathModels),
                                            ),
                                            DartCodeWithCopyButton(
                                              w: w * 0.8,
                                              h: h * 0.3,
                                              title: "Canvas Function",
                                              content:
                                                  getStringOfCommonCanvasFunction(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                          p.updateUi();
                        },
                        icon: Icon(_strokePath
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                        label: Text("Get Map Data")),
                    ElevatedButton.icon(
                        onPressed: () async {
                          String painterClassName = "MyFirstPainter";
                          // launch('file://C:');
                          Directory? dir = await getDownloadsDirectory();
                          log("dirpath ${dir?.path}");
                          File file = File(
                              "${dir?.path}/${painterClassName}_file.dart");
                          String totalDataIn1File = getImportLinessString() +
                              getPaintContainerWidgetAsString(
                                  painterClassName) +
                              getAllStringData(painterClassName) +
                              getModelAndEnumsStringData() +
                              getStringofAllCanvasFunctions(pathModels) +
                              getStringOfAllFunctionsOfCurvepointsList(
                                  pathModels) +
                              getStringOfCommonCanvasFunction();
                          file.writeAsString(totalDataIn1File);

                          p.updateUi();
                        },
                        icon: Icon(_strokePath
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                        label: Text("Pick Folder")),
                  ],
                )
              ],
            ));
  }

  void updatePrePostCurveTypeBasedOnArcTypeOnPoint(int i) {
    int preIndex = i > 0 ? i - 1 : _points.length - 1;
    int postIndex = (i + 1) % (_points.length);
    CurvePoint point = _points[i];
    CurvePoint prePoint = _points[preIndex];
    CurvePoint postPoint = _points[postIndex];
    switch (point.arcTypeOnPoint) {
      case ArcTypeOnPoint.normal:
        point.prePointCurveType = PrePointCurveType.normal;
        point.postPointCurveType = PostPointCurveType.normal;
        break;
      case ArcTypeOnPoint.arc:
        point.prePointCurveType = PrePointCurveType.arc;
        point.postPointCurveType = PostPointCurveType.arc;
        _resetPreV_Next_SelfPoint_to_quad_bezier_whenTappedOn_point(i);
        break;
      case ArcTypeOnPoint.symmetric:
        _points[i].pointSymmetry = PointSymmetry.allSymmetry;
        setPointCurveTypeForBezierCurve(i);
        break;
      case ArcTypeOnPoint.nonSymmetric:
        _points[i].pointSymmetry = PointSymmetry.nonSymmetric;

        setPointCurveTypeForBezierCurve(i);
        break;
      case ArcTypeOnPoint.angleSymmetric:
        _points[i].pointSymmetry = PointSymmetry.angleSymmetry;
        setPointCurveTypeForBezierCurve(i);
        break;
      default:
    }
  }

  String getPainterStartingBody(String painterClassName) {
    return '''
class $painterClassName extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    double sw = s.width;
    double sh = s.height;
''';
  }

  String getPainterEndingBody(String painterClassName) {
    return '''
 }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
''';
  }

  String getAllStringData(String painterClassName) {
    String totalData = "";
    totalData += getPainterStartingBody("$painterClassName");
    for (var i = 0; i < pathModels.length; i++) {
      PathModel pathModel = pathModels[i];
      log("data @$i : ${pathModel.points.length} ");
      // totalData += getStringOfCurvePOintsInListofObjectsFrom(pathModel);
      totalData += getStringOfSinglePathDrawFunCall(
        pathModel,
        i,
      );
    }

    totalData += getPainterEndingBody(painterClassName);
    return totalData;
  }

  String getStringofAllCanvasFunctions(List<PathModel> pathModels) {
    String data = '';
    for (var i = 0; i < pathModels.length; i++) {
      String pointsName = "${pathModels[i].pathName}Points";
      data += '''
 
drawCanvasForPath${pathModels[i].pathName}(PathModel pathModel, Canvas canvas,List<CurvePoint> $pointsName){
  List<CurvePoint>pathPoints =$pointsName;
    bool stroke = pathModel.stroke;
    Paint paint = pathModel.paint..style=stroke?PaintingStyle.stroke:PaintingStyle.fill;
  
    bool open=pathModel.open;

  drawCanvasCommonFunction(pathPoints,paint,  stroke,  open,canvas );

}
''';
    }
    // ${getStringDataOfDrawing1PathInCanvasFunction(pathModels[i])}
    return data;
  }

  getStringOfSinglePathDrawFunCall(PathModel pathModel, int i) {
    String pointsName = "${pathModels[i].pathName}Points";
    return '''\nList<CurvePoint> $pointsName = getCurvePointsListForPath_${pathModels[i].pathName}(pathModels[$i],s);
    drawCanvasForPath${pathModels[i].pathName}(pathModels[$i],canvas,$pointsName);''';
  }

  String getStringOfAllFunctionsOfCurvepointsList(List<PathModel> pathModels) {
    String allFunctionsString = '';
    for (var i = 0; i < pathModels.length; i++) {
      PathModel pathModel = pathModels[i];
      allFunctionsString +=
          getStringOfCurvePOintsInListofObjectsFromInFunctionString(pathModel);
    }

    return allFunctionsString;
  }

  String getStringOfCurvePOintsInListofObjectsFromInFunctionString(
      PathModel pathModel) {
    return '''
 List<CurvePoint> getCurvePointsListForPath_${pathModel.pathName}(PathModel pathModel, Size s) {
    double sw = s.width;
    double sh = s.height;
 ${getStringOfCurvePOintsInListofObjectsFrom(pathModel)}
    return ${pathModel.pathName}Points;
  }
''';
  }

  String getStringDataOfDrawing1PathInCanvasFunction(PathModel pathModel) {
    String pathName = pathModel.pathName;
    String pointsName = "${pathName}Points";
    String paintName = "${pathName}Paint";
    String isStrokeName = "${pathName}IsStroke";
    String openName = "${pathName}open";

    return ''' 
    $isStrokeName= ${pathModel.stroke};
$openName= ${pathModel.open};
        Paint $paintName = Paint()
        $paintName= ${pathModel.paint}
      ..strokeWidth = 3
      // ..color = Colors.red
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(s.width, s.height),
        [Colors.red, Colors.amber],
      )
      ..style = $isStrokeName ? PaintingStyle.stroke : PaintingStyle.fill;
    Path $pathName = Path();
    if ($pointsName.length < 2) {
      return;
    }

    for (var i = 1; i < $pointsName.length; i++) {
      if (i == 1) {
        // && $pointsName[0].arcTypeOnPoint != ArcTypeOnPoint.arc
        $pathName.moveTo($pointsName.first.point.dx, $pointsName.first.point.dy);
        if (!$isStrokeName) {
          $pathName.moveTo($pointsName[i - 1].postArcEndPoint.dx,
              $pointsName[i - 1].postArcEndPoint.dy);
        }
      } else {}
      if ($pointsName[i - 1].postPointCurveType == PostPointCurveType.arc) {
        // move to
        $pathName.lineTo($pointsName[i - 1].postArcEndPoint.dx,
            $pointsName[i - 1].postArcEndPoint.dy);
      } else {
        // move to
        $pathName.lineTo($pointsName[i - 1].point.dx, $pointsName[i - 1].point.dy);
      }
      int nextIndex = (i + 1) % $pointsName.length;
      int preIndex = i - 1;
      Offset p = $pointsName[i].point;
      Offset pre = $pointsName[i].prePoint;
      Offset postPoint = $pointsName[i].postPoint;
      Offset preArcEnd = $pointsName[i].preArcEndPoint;
      Offset postArcEnd = $pointsName[i].postArcEndPoint;
      Offset prePost = $pointsName[i - 1].postPoint;
      Offset nextPoint = $pointsName[nextIndex].point;

      // Check next of arc  point is cubic bezier ( and make pre point of next as quad from cubic)

      if ($pointsName[i].arcTypeOnPoint == ArcTypeOnPoint.arc) {
        if ($pointsName[nextIndex].prePointCurveType ==
            PrePointCurveType.cubicBezier) {
          $pointsName[nextIndex].prePointCurveType = PrePointCurveType.quadBezier;
        }
      }

      if ($pointsName[i].prePointCurveType == PrePointCurveType.normal) {
        $pathName.lineTo(p.dx, p.dy);
      } else if ($pointsName[i].prePointCurveType == PrePointCurveType.quadBezier) {
        $pathName.quadraticBezierTo(pre.dx, pre.dy, p.dx, p.dy);
        if ($pointsName[nextIndex].arcTypeOnPoint == ArcTypeOnPoint.normal) {
          $pathName.quadraticBezierTo(
              postPoint.dx, postPoint.dy, nextPoint.dx, nextPoint.dy);
          i++;
        }
      } else if ($pointsName[i].prePointCurveType ==
          PrePointCurveType.cubicBezier) {
        $pathName.cubicTo(prePost.dx, prePost.dy, pre.dx, pre.dy, p.dx, p.dy);
      } else if ($pointsName[i].prePointCurveType == PrePointCurveType.arc) {
        if ($pointsName[i - 1].postPointCurveType ==
            PostPointCurveType.quadBezier) {
          $pathName.quadraticBezierTo(
              prePost.dx, prePost.dy, preArcEnd.dx, preArcEnd.dy);
        }
        $pathName.lineTo(preArcEnd.dx, preArcEnd.dy);
        $pathName.arcToPoint(postArcEnd,
            radius: Radius.circular($pointsName[i].arcRadius),
            clockwise: $pointsName[i].isArcClockwise);

       
      }
    }
    if (!$openName) {
      Offset pLast = $pointsName[0].point;
      Offset preLast = $pointsName[0].prePoint;
      Offset preArcEnd = $pointsName[0].preArcEndPoint;
      Offset postArcEnd = $pointsName[0].postArcEndPoint;
      Offset prePostLast = $pointsName.last.postPoint;

      int nextIndex = 1;

      if ($pointsName[0].arcTypeOnPoint == ArcTypeOnPoint.arc) {
        if ($pointsName[nextIndex].prePointCurveType ==
            PrePointCurveType.cubicBezier) {
          $pointsName[nextIndex].prePointCurveType = PrePointCurveType.quadBezier;
        }
      }
      if ($pointsName[0].prePointCurveType == PrePointCurveType.normal) {
        $pathName.lineTo(pLast.dx, pLast.dy);
      } else if ($pointsName[0].prePointCurveType == PrePointCurveType.quadBezier) {
        $pathName.quadraticBezierTo(preLast.dx, preLast.dy, pLast.dx, pLast.dy);
        if ($pointsName[1].arcTypeOnPoint == ArcTypeOnPoint.normal) {
          Offset postPoint = $pointsName[0].postPoint;
          Offset nextPoint = $pointsName[1].point;
          $pathName.quadraticBezierTo(
              postPoint.dx, postPoint.dy, nextPoint.dx, nextPoint.dy);
        
        }
      } else if ($pointsName[0].prePointCurveType ==
          PrePointCurveType.cubicBezier) {
        $pathName.cubicTo(prePostLast.dx, prePostLast.dy, preLast.dx, preLast.dy,
            pLast.dx, pLast.dy);
      } else if ($pointsName[0].prePointCurveType == PrePointCurveType.arc) {
        $pathName.lineTo(preArcEnd.dx, preArcEnd.dy);
        $pathName.arcToPoint(postArcEnd,
            radius: Radius.circular($pointsName[0].arcRadius),
            clockwise: $pointsName[0].isArcClockwise);
         }
      
      if (!$isStrokeName ) {
        $pathName.close();
      }
    }

    canvas.drawPath($pathName, $paintName);''';
  }

  String getStringOfCommonCanvasFunction() {
    String pathName = "path";
    // pathModel.pathName;
    String pointsName = "pathPoints";
    // "${pathName}Points";
    String paintName = "paint";
    // "${pathName}Paint";
    String isStrokeName = "stroke";
    // "${pathName}IsStroke";
    String openName = "open";
    // "${pathName}open";
    // $isStrokeName= "stroke";
    // $openName= "open";
    // Paint $paintName = Paint()
    return ''' 
void drawCanvasCommonFunction(List<CurvePoint>pathPoints, Paint paint, bool stroke, bool open,Canvas canvas ){
  
      
    Path $pathName = Path();
    if ($pointsName.length < 2) {
      return;
    }

    for (var i = 1; i < $pointsName.length; i++) {
      if (i == 1) {
        // && $pointsName[0].arcTypeOnPoint != ArcTypeOnPoint.arc
        $pathName.moveTo($pointsName.first.point.dx, $pointsName.first.point.dy);
        if (!$isStrokeName) {
          $pathName.moveTo($pointsName[i - 1].postArcEndPoint.dx,
              $pointsName[i - 1].postArcEndPoint.dy);
        }
      } else {}
      if ($pointsName[i - 1].postPointCurveType == PostPointCurveType.arc) {
        // move to
        $pathName.lineTo($pointsName[i - 1].postArcEndPoint.dx,
            $pointsName[i - 1].postArcEndPoint.dy);
      } else {
        // move to
        $pathName.lineTo($pointsName[i - 1].point.dx, $pointsName[i - 1].point.dy);
      }
      int nextIndex = (i + 1) % $pointsName.length;
      int preIndex = i - 1;
      Offset p = $pointsName[i].point;
      Offset pre = $pointsName[i].prePoint;
      Offset postPoint = $pointsName[i].postPoint;
      Offset preArcEnd = $pointsName[i].preArcEndPoint;
      Offset postArcEnd = $pointsName[i].postArcEndPoint;
      Offset prePost = $pointsName[i - 1].postPoint;
      Offset nextPoint = $pointsName[nextIndex].point;

      // Check next of arc  point is cubic bezier ( and make pre point of next as quad from cubic)

      if ($pointsName[i].arcTypeOnPoint == ArcTypeOnPoint.arc) {
        if ($pointsName[nextIndex].prePointCurveType ==
            PrePointCurveType.cubicBezier) {
          $pointsName[nextIndex].prePointCurveType = PrePointCurveType.quadBezier;
        }
      }

      if ($pointsName[i].prePointCurveType == PrePointCurveType.normal) {
        $pathName.lineTo(p.dx, p.dy);
      } else if ($pointsName[i].prePointCurveType == PrePointCurveType.quadBezier) {
        $pathName.quadraticBezierTo(pre.dx, pre.dy, p.dx, p.dy);
        if ($pointsName[nextIndex].arcTypeOnPoint == ArcTypeOnPoint.normal) {
          $pathName.quadraticBezierTo(
              postPoint.dx, postPoint.dy, nextPoint.dx, nextPoint.dy);
          i++;
        }
      } else if ($pointsName[i].prePointCurveType ==
          PrePointCurveType.cubicBezier) {
        $pathName.cubicTo(prePost.dx, prePost.dy, pre.dx, pre.dy, p.dx, p.dy);
      } else if ($pointsName[i].prePointCurveType == PrePointCurveType.arc) {
        if ($pointsName[i - 1].postPointCurveType ==
            PostPointCurveType.quadBezier) {
          $pathName.quadraticBezierTo(
              prePost.dx, prePost.dy, preArcEnd.dx, preArcEnd.dy);
        }
        $pathName.lineTo(preArcEnd.dx, preArcEnd.dy);
        $pathName.arcToPoint(postArcEnd,
            radius: Radius.circular($pointsName[i].arcRadius),
            clockwise: $pointsName[i].isArcClockwise);

       
      }
    }
    if (!$openName) {
      Offset pLast = $pointsName[0].point;
      Offset preLast = $pointsName[0].prePoint;
      Offset preArcEnd = $pointsName[0].preArcEndPoint;
      Offset postArcEnd = $pointsName[0].postArcEndPoint;
      Offset prePostLast = $pointsName.last.postPoint;

      int nextIndex = 1;

      if ($pointsName[0].arcTypeOnPoint == ArcTypeOnPoint.arc) {
        if ($pointsName[nextIndex].prePointCurveType ==
            PrePointCurveType.cubicBezier) {
          $pointsName[nextIndex].prePointCurveType = PrePointCurveType.quadBezier;
        }
      }
      if ($pointsName[0].prePointCurveType == PrePointCurveType.normal) {
        $pathName.lineTo(pLast.dx, pLast.dy);
      } else if ($pointsName[0].prePointCurveType == PrePointCurveType.quadBezier) {
        $pathName.quadraticBezierTo(preLast.dx, preLast.dy, pLast.dx, pLast.dy);
        if ($pointsName[1].arcTypeOnPoint == ArcTypeOnPoint.normal) {
          Offset postPoint = $pointsName[0].postPoint;
          Offset nextPoint = $pointsName[1].point;
          $pathName.quadraticBezierTo(
              postPoint.dx, postPoint.dy, nextPoint.dx, nextPoint.dy);
        
        }
      } else if ($pointsName[0].prePointCurveType ==
          PrePointCurveType.cubicBezier) {
        $pathName.cubicTo(prePostLast.dx, prePostLast.dy, preLast.dx, preLast.dy,
            pLast.dx, pLast.dy);
      } else if ($pointsName[0].prePointCurveType == PrePointCurveType.arc) {
        $pathName.lineTo(preArcEnd.dx, preArcEnd.dy);
        $pathName.arcToPoint(postArcEnd,
            radius: Radius.circular($pointsName[0].arcRadius),
            clockwise: $pointsName[0].isArcClockwise);
         }
      
      if (!$isStrokeName ) {
        $pathName.close();
      }
    }

    canvas.drawPath($pathName, $paintName);
    }''';
  }

  String getImportLinessString() {
    return '''import 'package:flutter/material.dart';
import 'dart:ui' as ui;''';
  }

  String getPaintContainerWidgetAsString(String painterClassName) {
    return '''

class MyPainterWidget extends StatelessWidget {
  const MyPainterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        width: 300,
        height: 300,
        child: CustomPaint(
          painter: ${painterClassName}(),
          size: Size(300, 300),
        ),
      );
  }
}    ''';
  }

  String getStringOfCurvePOintsInListofObjectsFrom(PathModel pathModel) {
    double sw = _paintBoxSize.width;
    double sh = _paintBoxSize.height;
    List<CurvePoint> ps = pathModel.points;
    String total = '''List<CurvePoint> ${pathModel.pathName}Points =[''';
    int c = 0;
    ps.forEach((p) {
      String data =
          '''CurvePoint.withAllData(${p.index}, ${getOffsetAsString(p.point, _paintBoxSize)}, ${p.pointPosition}, ${p.prePointCurveType}, ${p.postPointCurveType},${getOffsetAsString(p.prePoint, _paintBoxSize)} ,${getOffsetAsString(p.postPoint, _paintBoxSize)} ,${getOffsetAsString(p.preArcEndPoint, _paintBoxSize)} ,${getOffsetAsString(p.postArcEndPoint, _paintBoxSize)} , ${p.arcRadius}, ${p.tempArcRadius}, ${p.isArcClockwise}, ${p.pointSymmetry}, ${p.arcTypeOnPoint}),''';

      // Offset point = Offset((p.point.dx/sw), dy)
      // CurvePoint.withAllData(p.index, getOffsetAsString(p.point,_paintBoxSize ), pointPosition, prePointCurveType, postPointCurveType, prePoint, postPoint, preArcEndPoint, postArcEndPoint, arcRadius, tempArcRadius, isArcClockwise, pointSymmetry, arcTypeOnPoint)

      total += data;
      c++;
    });
    total += '];';
    log("newdata $total");
    return total;
  }

  void _printCurvpoitvsinMapForm() async {
    int c = 0;
    Map<String, List<Map<String, String>>> map = {};
    List<Map<String, String>> mp = [];
    String total = '{"points":[';
    _points.forEach((p) {
      log("pppp ${p.arcRadius.toStringAsFixed(4)}+ ${p.tempArcRadius.toStringAsFixed(4)}");
      c++;

      mp.add({
        LongToshortMap["index"]!: p.index.toString(),
        LongToshortMap["pointX"]!: p.point.dx.toStringAsFixed(4),
        LongToshortMap["pointY"]!: p.point.dy.toStringAsFixed(4),
        LongToshortMap["pointPosition"]!:
            p.pointPosition.toString().split('.')[1],
        LongToshortMap["prePointCurveType"]!:
            p.prePointCurveType.toString().split('.')[1],
        LongToshortMap["postPointCurveType"]!:
            p.postPointCurveType.toString().split('.')[1],
        LongToshortMap["prePointX"]!: p.prePoint.dx.toStringAsFixed(4),
        LongToshortMap["prePointY"]!: p.prePoint.dy.toStringAsFixed(4),
        LongToshortMap["postPointX"]!: p.postPoint.dx.toStringAsFixed(4),
        LongToshortMap["postPointY"]!: p.postPoint.dy.toStringAsFixed(4),
        LongToshortMap["preArcEndPointX"]!:
            p.preArcEndPoint.dx.toStringAsFixed(4),
        LongToshortMap["preArcEndPointY"]!:
            p.preArcEndPoint.dy.toStringAsFixed(4),
        LongToshortMap["postArcEndPointX"]!:
            p.postArcEndPoint.dx.toStringAsFixed(4),
        LongToshortMap["postArcEndPointY"]!:
            p.postArcEndPoint.dy.toStringAsFixed(4),
        LongToshortMap["arcRadius"]!: p.arcRadius.toStringAsFixed(4),
        LongToshortMap["tempArcRadius"]!: p.tempArcRadius.toStringAsFixed(4),
        LongToshortMap["isArcClockwise"]!: p.isArcClockwise.toString(),
        LongToshortMap["pointSymmetry"]!:
            p.pointSymmetry.toString().split('.')[1],
        LongToshortMap["arcTypeOnPoint"]!:
            p.arcTypeOnPoint.toString().split('.')[1]
      });
      String data = '''
{
  "${LongToshortMap["index"]!}": "${p.index.toString()}", 
"${LongToshortMap["pointX"]!}" :"${p.point.dx.toStringAsFixed(4)}", 
"${LongToshortMap["pointY"]!}" :"${p.point.dy.toStringAsFixed(4)}",
"${LongToshortMap["pointPosition"]!}" :"${p.pointPosition.toString().split('.')[1]}", 
"${LongToshortMap["prePointCurveType"]!}" :"${p.prePointCurveType.toString().split('.')[1]}", 
"${LongToshortMap["postPointCurveType"]!}" :"${p.postPointCurveType.toString().split('.')[1]}", 
"${LongToshortMap["prePointX"]!}" :"${p.prePoint.dx.toStringAsFixed(4)}", 
"${LongToshortMap["prePointY"]!}" :"${p.prePoint.dy.toStringAsFixed(4)}", 
"${LongToshortMap["postPointX"]!}" :"${p.postPoint.dx.toStringAsFixed(4)}", 
"${LongToshortMap["postPointY"]!}" :"${p.postPoint.dy.toStringAsFixed(4)}", 
"${LongToshortMap["preArcEndPointX"]!}" :"${p.preArcEndPoint.dx.toStringAsFixed(4)}", 
"${LongToshortMap["preArcEndPointY"]!}" :"${p.preArcEndPoint.dy.toStringAsFixed(4)}", 
"${LongToshortMap["postArcEndPointX"]!}" :"${p.postArcEndPoint.dx.toStringAsFixed(4)}", 
"${LongToshortMap["postArcEndPointY"]!}" :"${p.postArcEndPoint.dy.toStringAsFixed(4)}", 
"${LongToshortMap["arcRadius"]!}" :"${p.arcRadius.toStringAsFixed(4)}", 
"${LongToshortMap["tempArcRadius"]!}" :"${p.tempArcRadius.toStringAsFixed(4)}", 
"${LongToshortMap["isArcClockwise"]!}" :"${p.isArcClockwise.toString()}", 
"${LongToshortMap["pointSymmetry"]!}" :"${p.pointSymmetry.toString().split('.')[1]}", 
"${LongToshortMap["arcTypeOnPoint"]!}" :"${p.arcTypeOnPoint.toString().split('.')[1]}" } ${c == _points.length ? "" : ","}''';
      total += "\n$data";
    });
    total += "]}";

    // log(total);
    map["points"] = mp;
    // final File file = File(
    //     'E:/Shubham in E/Personal projects/three_d_model_tool/lib/3D Paint/a.json');
    // await file.writeAsString(json.encode(map));
    // log(map.toString());
    // Map<String, List<Map<String, String>>> m =
    //     GetPointsDataFromJson.getMapForPointsof1Path(file);
    // GetPointsDataFromJson.createCurvePointsListFromJson(m);
  }

  String getOffsetAsString(Offset point, Size paintBoxSize) {
    double sw = _paintBoxSize.width;
    double sh = _paintBoxSize.height;
    return "Offset(sw*${(point.dx / sw)}, sh*${(point.dy / sh)})";
  }

  getStringOfListOfPathModelsInObjectListForm() {
    // PathModel pathModel=
    String total = ' List<PathModel> pathModels = [\n';

    pathModels.forEach((p) {
      String data = '''
      PathModel.withoutPoints(
          paint: Paint()..color= ${p.paint.color},
          stroke: ${p.stroke},
          open: ${p.open},
          pathName: "${p.pathName}",
          pathNo: ${p.pathNo}),\n
''';
      total += data ;
    });
    return total+ "\n];";
  }

  getModelAndEnumsStringData() {
    return '''
import 'package:flutter/material.dart';

enum PrePointCurveType {
  normal,
  arc,
  quadBezier,
  cubicBezier,
}

enum PostPointCurveType {
  normal,
  arc,
  quadBezier,
  cubicBezier,
}

enum PointPosition { normal, start, end }

enum PointSymmetry { angleSymmetry, allSymmetry, nonSymmetric }

enum ArcTypeOnPoint { normal, arc, symmetric, angleSymmetric, nonSymmetric }


class CurvePoint {
  int index = 0;
  Offset point = Offset.zero;
  PrePointCurveType prePointCurveType = PrePointCurveType.normal;
  PostPointCurveType postPointCurveType = PostPointCurveType.normal;
  Offset prePoint = Offset.zero;
  Offset postPoint = Offset.zero;
  Offset preArcEndPoint = Offset.zero;
  Offset postArcEndPoint = Offset.zero;
  double arcRadius = 0;
  double tempArcRadius = 50;
  bool isArcClockwise = true;

  PointPosition pointPosition = PointPosition.normal;
  PointSymmetry pointSymmetry = PointSymmetry.nonSymmetric;
  ArcTypeOnPoint arcTypeOnPoint = ArcTypeOnPoint.normal;
  CurvePoint.withOffset(this.point);
  CurvePoint.withIndexAndOffset({required this.index, required this.point});
  CurvePoint.withAllNamedData(
      {required this.index,
      required this.point,
      required this.pointPosition,
      required this.prePointCurveType,
      required this.postPointCurveType,
      required this.prePoint,
      required this.postPoint,
      required this.preArcEndPoint,
      required this.postArcEndPoint,
      required this.arcRadius,
      required this.tempArcRadius,
      required this.isArcClockwise,
      required this.pointSymmetry,
      required this.arcTypeOnPoint});

  CurvePoint.withAllData(
      this.index,
      this.point,
      this.pointPosition,
      this.prePointCurveType,
      this.postPointCurveType,
      this.prePoint,
      this.postPoint,
      this.preArcEndPoint,
      this.postArcEndPoint,
      this.arcRadius,
      this.tempArcRadius,
      this.isArcClockwise,
      this.pointSymmetry,
      this.arcTypeOnPoint);
  factory CurvePoint.fromCopy(CurvePoint p) {
    CurvePoint point = CurvePoint.withAllNamedData(
        index: p.index,
        point: p.point,
        pointPosition: p.pointPosition,
        prePointCurveType: p.prePointCurveType,
        postPointCurveType: p.postPointCurveType,
        prePoint: p.prePoint,
        postPoint: p.postPoint,
        preArcEndPoint: p.preArcEndPoint,
        postArcEndPoint: p.postArcEndPoint,
        arcRadius: p.arcRadius,
        tempArcRadius: p.tempArcRadius,
        isArcClockwise: p.isArcClockwise,
        pointSymmetry: p.pointSymmetry,
        arcTypeOnPoint: p.arcTypeOnPoint);
   

    return point;
  }
  }


  class PathModel {
  int pathNo;
  String pathName;
  List<CurvePoint> points = [];
  bool open;
  bool stroke;
  Paint paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;
  PathModel.withCurvePoints(this.points,
      {required this.paint,
      this.stroke = false,
      this.open = true,
      this.pathName = "path",
      this.pathNo = 0});

  PathModel.withoutPoints(
      {required this.paint,
      required this.stroke ,
      required this.open ,
      required this.pathName ,
      required this.pathNo });
}
''';
  }
}

setPointCurveTypeForBezierCurve(int i) {
  int preIndex = i > 0 ? i - 1 : _points.length - 1;
  int postIndex = (i + 1) % (_points.length);
  CurvePoint point = _points[i];
  CurvePoint prePoint = _points[preIndex];
  CurvePoint postPoint = _points[postIndex];

  if (prePoint.postPointCurveType == PostPointCurveType.normal) {
    point.prePointCurveType = PrePointCurveType.quadBezier;
  }
  if (prePoint.postPointCurveType == PostPointCurveType.arc) {
    point.prePointCurveType = PrePointCurveType.quadBezier;
  }
  if (prePoint.postPointCurveType == PostPointCurveType.quadBezier ||
      prePoint.postPointCurveType == PostPointCurveType.cubicBezier) {
    point.prePointCurveType = PrePointCurveType.cubicBezier;
    prePoint.postPointCurveType = PostPointCurveType.cubicBezier;
  }
// For post section
  if (postPoint.postPointCurveType == PostPointCurveType.normal) {
    point.postPointCurveType = PostPointCurveType.quadBezier;
  }
  if (postPoint.postPointCurveType == PostPointCurveType.arc) {
    point.postPointCurveType = PostPointCurveType.quadBezier;
  }
  if (postPoint.postPointCurveType == PostPointCurveType.quadBezier ||
      postPoint.postPointCurveType == PostPointCurveType.cubicBezier) {
    point.postPointCurveType = PostPointCurveType.cubicBezier;
    postPoint.prePointCurveType = PrePointCurveType.cubicBezier;
  }
  _resetPreV_Next_SelfPoint_to_quad_bezier_whenTappedOn_point(i);
}

_getAndUpdateArcEndPointsOnArcSelectedOnPoint(int selectedPointIndex) {
  /// Here arc end points are calclated using [getArcModel] and set these data [radius, clockwise] to curvePoint attributes
  int i = selectedPointIndex;
  int preIndex = i > 0 ? i - 1 : _points.length - 1;
  int postIndex = (i + 1) % (_points.length);
  CurvePoint point = _points[i];
  CurvePoint prePoint = _points[preIndex];
  CurvePoint postPoint = _points[postIndex];
  List<Offset> arcPoints = [
    Offset(prePoint.point.dx, prePoint.point.dy),
    Offset(point.point.dx, point.point.dy),
    Offset(postPoint.point.dx, postPoint.point.dy),
  ];
  if (prePoint.postPointCurveType == PostPointCurveType.quadBezier ||
      prePoint.postPointCurveType == PostPointCurveType.cubicBezier) {
    arcPoints[0] = Offset(prePoint.postPoint.dx, prePoint.postPoint.dy);
  }
  if (postPoint.prePointCurveType == PrePointCurveType.quadBezier ||
      postPoint.prePointCurveType == PrePointCurveType.cubicBezier) {
    arcPoints[2] = Offset(postPoint.prePoint.dx, postPoint.prePoint.dy);
  }
  Arc3PointModel arc3pointModel =
      getArcModel(arcPoints, _points[i].tempArcRadius);

  point.preArcEndPoint = arc3pointModel.startPoint;
  point.postArcEndPoint = arc3pointModel.endPoint;
  point.arcRadius = arc3pointModel.radius;
  point.isArcClockwise = arc3pointModel.isClockwise;
}

_updatePrePostPointWhenArcSelectedAtPoint(int selectedPointIndex) {
  int k = selectedPointIndex;
}

_resetAdjcentCubicToQuadBezeirifSelectedPointIsArc(int selectedPointIndex) {
  int i = selectedPointIndex;
  int preIndex = i > 0 ? i - 1 : _points.length - 1;
  int postIndex = (i + 1) % (_points.length);
  // log("_resetAdjcentCubicToQuadBezeirifSelectedPointIsArc ${_points[i].arcTypeOnPoint}");
  if (_points[i].arcTypeOnPoint == ArcTypeOnPoint.arc) {
    if (_points[preIndex].postPointCurveType ==
        PostPointCurveType.cubicBezier) {
      _points[preIndex].postPointCurveType = PostPointCurveType.quadBezier;
    }
    if (_points[postIndex].prePointCurveType ==
        PostPointCurveType.cubicBezier) {
      _points[postIndex].prePointCurveType = PrePointCurveType.quadBezier;
    }
  }
}

_resetPreV_Next_SelfPoint_to_quad_bezier_whenTappedOn_point(
    int selectedPointIndex) {
  int i = selectedPointIndex;
  int preIndex = i > 0 ? i - 1 : _points.length - 1;
  int postIndex = (i + 1) % (_points.length);
  _resetAdjcentCubicToQuadBezeirifSelectedPointIsArc(preIndex);
  _resetAdjcentCubicToQuadBezeirifSelectedPointIsArc(i);
  _resetAdjcentCubicToQuadBezeirifSelectedPointIsArc(postIndex);
}

_updatePrePostPointForSymmetry(bool isPre, int k) {
  log("isPre $isPre / $k /  ${_points[k].prePoint} /${_points[k].postPoint} / ${_points[k].arcTypeOnPoint}");
  if (_points[k].arcTypeOnPoint == ArcTypeOnPoint.symmetric) {
    if (isPre) {
      _points[k].postPoint =
          Offset.lerp(_points[k].prePoint, _points[k].point, 2) ??
              _points[k].point;
    } else {
      _points[k].prePoint =
          Offset.lerp(_points[k].postPoint, _points[k].point, 2) ??
              _points[k].point;
    }
  } else if (_points[k].arcTypeOnPoint == ArcTypeOnPoint.angleSymmetric) {
    if (isPre) {
      double distFromControlPoint =
          get_dist_between_2_points(_points[k].prePoint, _points[k].point);
      double distFromOtherPoint =
          get_dist_between_2_points(_points[k].postPoint, _points[k].point);
      _points[k].postPoint = Offset.lerp(_points[k].prePoint, _points[k].point,
              1 + distFromOtherPoint / distFromControlPoint) ??
          _points[k].point;

      log("pre angle ${_points[k].prePoint} /${_points[k].postPoint}");
    } else {
      double distFromControlPoint =
          get_dist_between_2_points(_points[k].postPoint, _points[k].point);
      double distFromOtherPoint =
          get_dist_between_2_points(_points[k].prePoint, _points[k].point);
      _points[k].prePoint = Offset.lerp(_points[k].postPoint, _points[k].point,
              1 + distFromOtherPoint / distFromControlPoint) ??
          _points[k].point;
    }
  }
  int preIndex = k > 0 ? k - 1 : _points.length - 1;
  int postIndex = (k + 1) % (_points.length);
  _getAndUpdateArcEndPointsOnArcSelectedOnPoint(preIndex);
  _getAndUpdateArcEndPointsOnArcSelectedOnPoint(k);
  _getAndUpdateArcEndPointsOnArcSelectedOnPoint(postIndex);
}

updatePrePostBothPointsForPoint(int i) {
  int preI = i > 0 ? i - 1 : _points.length - 1;
  int postI = (i + 1) % _points.length;
  _updatePrePostPointForSymmetry(true, i);
  _updatePrePostPointForSymmetry(false, preI);
  _updatePrePostPointForSymmetry(true, postI);
}

bool _open = true;

class _Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    double w = s.width;
    double h = s.height;
    // bool stroke;
    Paint paint1 = Paint()
      // ..color = Colors.red
      ..shader = Gradient.linear(
          Offset.zero, Offset(w, h), [Colors.green, Colors.blue], [0.1, 0.4]);

    Path path1 = Path();
    path1.moveTo(w * 0.2, h * 0.2);
    path1.lineTo(w * 0.4, h * 0.1);
    path1.lineTo(w * 0.6, h * 0.1);
    path1.lineTo(w * 0.4, h * 0.2);
    path1.close();
    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
