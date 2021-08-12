import 'package:flutter/material.dart';

class FittedText extends StatelessWidget {

  double? height;
  double? width;
  String? text;
  TextStyle? textStyle;
  Alignment alignment;

  FittedText({this.textStyle,this.width,this.height,this.text,this.alignment=Alignment.centerLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        alignment:alignment,
        child: FittedBox(child: Text("$text",style: textStyle,))
    );
  }
}
