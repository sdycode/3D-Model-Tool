import 'package:flutter/material.dart';

class NewYoutubeSwitchButton extends StatefulWidget {
  NewYoutubeSwitchButton({Key? key}) : super(key: key);

  @override
  State<NewYoutubeSwitchButton> createState() => _NewYoutubeSwitchButtonState();
}

class _NewYoutubeSwitchButtonState extends State<NewYoutubeSwitchButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  @override
  void initState() {
    // TODO: implement initState

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);

    animation.addListener(() {
      setState(() {
        leftPositionOfIcon = animation.value * 300;
      });
    });
    super.initState();
  }

  double leftPositionOfIcon = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: GestureDetector(
                onTap: () {
                  if (animationController.isCompleted) {
                    animationController.reverse();
                  } else {
                    animationController.forward();
                  }
                },
                child: Container(
                  width: 300 + 150,
                  height: 150,
                  child: Stack(children: [
                    Center(
                      child: Container(
                        width: 300 + 120,
                        height: 120,
                        decoration: BoxDecoration(
                            color: Colors.amber.shade200.withAlpha(120),
                            borderRadius: BorderRadius.circular(120)),
                      ),
                    ),
                    Positioned(
                        left: leftPositionOfIcon,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.red.shade400.withAlpha(160),
                              borderRadius: BorderRadius.circular(150)),
                          child: FittedBox(
                            child: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: animation),
                          ),
                        ))
                  ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}