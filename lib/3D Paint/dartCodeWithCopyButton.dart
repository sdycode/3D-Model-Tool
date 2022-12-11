import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DartCodeWithCopyButton extends StatelessWidget {
  double? w;
  double? h;
  String title;
  String content;
  DartCodeWithCopyButton(
      {Key? key,
      this.w,
      this.h,
      this.title = "Title",
      this.content = "Content"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Container(
      width: w ?? s.width * 0.8,
      // height:  h ?? s.height*0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Text(title)),
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: content));
                  },
                  icon: Icon(Icons.copy))
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black87,
            
            
            borderRadius: BorderRadius.circular(8)
            ),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: h ?? s.height * 0.2),
                child: SingleChildScrollView(child: Text(content,
                style: TextStyle(color: Colors.white
                ),
                 ))),
          )
        ],
      ),
    );
  }
}
