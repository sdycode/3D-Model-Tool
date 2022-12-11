import 'package:flutter/material.dart';

class ColorsRow extends StatelessWidget {
  final double w;
  final double h;
  const ColorsRow(this.w, this.h,{Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
     child:  ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: Colors.primaries.length,
      itemBuilder: (c, i) {
                  return Container(
                    width: h,
                    height: h,
                    color: Colors.primaries[i],
                  );
                }),
    );
  }
}
