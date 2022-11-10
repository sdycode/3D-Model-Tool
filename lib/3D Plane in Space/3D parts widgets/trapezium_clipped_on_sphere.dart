import 'package:flutter/material.dart';
import 'package:three_d_model_tool/constants/consts.dart';

class TrapeziumClippedOnSphereSurface extends StatelessWidget {
  final double bottomWidth;
  final double topWidth;
  final double height;
  Color color;

   TrapeziumClippedOnSphereSurface(
      {Key? key,
      required this.topWidth,
      required this.bottomWidth,
      required this.height,
      this.color = Colors.white
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TrapeziumClipPath(
          topWidth: topWidth, bottomWidth: bottomWidth, height: height),
      child: Container(
        width: bottomWidth,
        height: height,
        color: color,
      ),
    );
  }
}

class TrapeziumClipPath extends CustomClipper<Path> {
  final double bottomWidth;
  final double topWidth;
  final double height;

  const TrapeziumClipPath(
      {Key? key,
      required this.topWidth,
      required this.bottomWidth,
      required this.height});
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo((bottomWidth - topWidth) * 0.5, 0);
    path.lineTo(bottomWidth - (bottomWidth - topWidth) * 0.5, 0);
    path.lineTo(bottomWidth, height);
    path.lineTo(0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
