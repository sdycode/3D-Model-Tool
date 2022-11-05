import 'package:flutter/material.dart';

class YoutubePlayPauseButton extends StatefulWidget {
  YoutubePlayPauseButton({Key? key}) : super(key: key);

  @override
  State<YoutubePlayPauseButton> createState() => _YoutubePlayPauseButtonState();
}

class _YoutubePlayPauseButtonState extends State<YoutubePlayPauseButton>
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
      left = animation.value * (300);
      setState(() {
        
      });
    });
    super.initState();
  }

  double left = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
     
          Center(
            child: ClipRRect(
              borderRadius:  BorderRadius.circular(150),
              child: GestureDetector(
                onTap: () {
                   setState(() {
                      // animationController.reset();
                      if (animationController.isAnimating) {
                        animationController.stop();
                        animationController.reverse();
                      } else {
                        if (animationController.isCompleted) {
                          animationController.reverse();
                        } else {
                          animationController.reset();
                          animationController.forward();
                        }
                      }
                    });
                },
                child: Container(
                  width: 300+150,
                  height: 150,
                  child: Stack(children: [
                        Center(
                child:   Container(
                
                    width: 300+120,
                
                    height: 120,
                
                    decoration: BoxDecoration(
                
                      color: Colors.grey.shade400.withAlpha(50),
                
                      borderRadius: BorderRadius.circular(120)
                
                    ),
                
                ),
                        ),
                    Positioned(
                        left: left,
                        child: Container(
                          decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade400
                          ),
                          width: 150,
                          height: 150,
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
          ),
        
          
        ],
      ),
    );
  }
}
