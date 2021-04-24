import 'package:flutter/material.dart';


class AppTheme {
  AppTheme._();



  static const Color yellowColor=Color(0xFFFFC010);
  static const Color bgColor=Color(0xFF3B3B3D);
  static const Color red=Color(0xFFE34343);
  static const Color addNewTextFieldBorder=Color(0xFFCDCDCD);
  static const Color addNewTextFieldFocusBorder=Color(0xFF6B6B6B);

  static  Color addNewTextFieldText=Color(0xFF787878);

  static  Color indicatorColor=Color(0xFF1C1C1C);

  static  Color grey=Color(0xFF787878);
  static  Color gridTextColor=Color(0xFF787878);

  static  Color uploadColor=Color(0xFFC7D0D8);


  static  TextStyle hintText=TextStyle(fontFamily: 'RR',fontSize: 16,color: addNewTextFieldText.withOpacity(0.5));
  static TextStyle TSWhite20=TextStyle(fontFamily: 'RR',fontSize: 20,color: Colors.white,letterSpacing: 0.1);
  static TextStyle TSWhite16=TextStyle(fontFamily: 'RR',fontSize: 18,color: Colors.white,letterSpacing: 0.1);


  static TextStyle userNameTS=TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16);
  static TextStyle userGroupTS=TextStyle(fontFamily: 'RL',color: AppTheme.gridTextColor,fontSize: 14);

  static TextStyle bgColorTS=TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16);


  static const Color popUpSelectedColor=Color(0xFF3B3B3D);
  static const Color editDisableColor=Color(0xFFF2F2F2);


  //yellow BoxShadow
static BoxShadow yellowShadow=  BoxShadow(
  color: AppTheme.yellowColor.withOpacity(0.4),
  spreadRadius: 1,
  blurRadius: 5,
  offset: Offset(1, 8), // changes position of shadow
  );


}
