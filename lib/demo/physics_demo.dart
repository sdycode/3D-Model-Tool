import 'package:flutter/material.dart';
import 'package:three_d_model_tool/constants/consts.dart';

class PhysicsDemo extends StatefulWidget {
  PhysicsDemo({Key? key}) : super(key: key);

  @override
  State<PhysicsDemo> createState() => _PhysicsDemoState();
}

class _PhysicsDemoState extends State<PhysicsDemo> {
  List<ScrollPhysics> physics =[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
               Container(
            width: w,
            height: h-30,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
            itemCount: physics.length,
              itemBuilder: (c, i) {
              return  Container(color: Colors.primaries[i%Colors.primaries.length],
              width: w*0.4,
              height: h*0.1,) ;
            }),
          ),
          Container(
            width: w,
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
            itemCount: physics.length,
              itemBuilder: (c, i) {
              return ElevatedButton(onPressed: () {}, child: Text(""));
            }),
          ),
        ],
      ),
    );
  }
}
