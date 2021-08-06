import 'package:flutter/material.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';

class Loader extends StatelessWidget {
  bool isLoad;
  Loader({this.isLoad=false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isLoad? SizeConfig.screenHeight:0,
      width: isLoad? SizeConfig.screenWidth:0,
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
      ),
    );
  }
}
