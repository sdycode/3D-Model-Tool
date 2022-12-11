import 'package:flutter/material.dart';

class RoundTextButton extends StatelessWidget {
  final String text;
  bool isActive;
  Function onTap;

  RoundTextButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: isActive ? 1.2 : 1.0,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 35,
          padding: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(17),
            color: Color.fromARGB(255, 2, 42, 75),
            border: isActive
                ? Border.all(
                    color: Colors.white,
                  )
                : null,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.amber.shade100, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
