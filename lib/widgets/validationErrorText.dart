import 'package:flutter/material.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';

class ValidationErrorText extends StatelessWidget {
 final String title;
 ValidationErrorText({this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20),
      child: Align(
        alignment: Alignment.centerLeft,
          child: Text(title,style: TextStyle(fontSize: 14,color: AppTheme.red,fontFamily: 'RR'),textAlign: TextAlign.left,)),
    );
  }
}
