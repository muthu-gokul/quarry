import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArrowBack extends StatelessWidget {
  VoidCallback? ontap;
  Color? iconColor;
  ArrowBack({this.ontap,this.iconColor});
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:ontap,
      child: Container(
        height: 50,
        width: 50,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: SvgPicture.asset("assets/bottomIcons/arrow-back.svg",height: 20,color: iconColor,),
      ),
    );
  }
}
