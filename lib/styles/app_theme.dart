import 'package:flutter/material.dart';
import 'package:quarry/styles/size.dart';


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
  static  Color gridbodyBgColor=Color(0xFFF6F7F9);
  static  Color disableColor=Color(0xFFe8e8e8);

  static  Color uploadColor=Color(0xFFC7D0D8);
  static  Color hintColor=Color(0xFFC5C5C5);

  static const Color EFEFEF=Color(0xFFEFEFEF);
  static const Color f737373=Color(0xFF737373);
  static const Color unitSelectColor=Color(0xFFF3F4F9);

  static TextStyle discountDeactive=TextStyle(fontFamily: 'RR',fontSize: 20,color: Color(0xFF777A92));
  static TextStyle discountactive=TextStyle(fontFamily: 'RR',fontSize: 20,color: Colors.white);

  static  TextStyle hintText=TextStyle(fontFamily: 'RR',fontSize: 16,color: addNewTextFieldText.withOpacity(0.5));
  static TextStyle TSWhite20=TextStyle(fontFamily: 'RR',fontSize: 20,color: Colors.white,letterSpacing: 0.1);
  static TextStyle TSWhite16=TextStyle(fontFamily: 'RR',fontSize: 18,color: Colors.white,letterSpacing: 0.1);
  static TextStyle TSWhite166=TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white,letterSpacing: 0.1);

  static TextStyle TSWhiteML=TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.white,letterSpacing: 0.1);
  //CT colourTextStyle
  static TextStyle ML_bgCT=TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 14);


  static TextStyle userNameTS=TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16);
  static TextStyle userGroupTS=TextStyle(fontFamily: 'RL',color: AppTheme.gridTextColor,fontSize: 14);
  static TextStyle userDesgTS=TextStyle(fontFamily: 'RR',color:AppTheme.grey.withOpacity(0.5),fontSize: 12);



  static TextStyle bgColorTS=TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16);
  static TextStyle bgColorTS14=TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 14);
  static TextStyle gridTextColorTS=TextStyle(fontFamily: 'RR',color: AppTheme.gridTextColor,fontSize: 16);
  static TextStyle gridTextColor14=TextStyle(fontFamily: 'RR',color: AppTheme.gridTextColor,fontSize: 14);
  static TextStyle gridTextGreenColor14=TextStyle(fontFamily: 'RR',color: Colors.green,fontSize: 14);
  static TextStyle gridTextRedColor14=TextStyle(fontFamily: 'RR',color: AppTheme.red,fontSize: 14);


  static const Color popUpSelectedColor=Color(0xFF3B3B3D);
  static const Color editDisableColor=Color(0xFFF2F2F2);

  static  Border gridBottomborder= Border(bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5)));


  //yellow BoxShadow
static BoxShadow yellowShadow=  BoxShadow(
  color: AppTheme.yellowColor.withOpacity(0.4),
  spreadRadius: 1,
  blurRadius: 5,
  offset: Offset(1, 8), // changes position of shadow
  );
/*  boxShadow: [
  qn.supplierMaterialMappingList.length==0?BoxShadow():
        BoxShadow(
            color: AppTheme.addNewTextFieldText.withOpacity(0.2),
        spreadRadius: 2,
  blurRadius: 15,
  offset: Offset(0, 0), // changes position of shadow
  )
  ]*/

 static EdgeInsets gridAppBarPadding=EdgeInsets.only(bottom: 15);
 static EdgeInsets leftRightMargin20=EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!);
 static BorderRadius gridTopBorder=BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15));


 //Appbar TextStyle
 static TextStyle appBarTS=TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16);

 //rawScrollBar Properties
  static const Color srollBarColor=Colors.grey;
  static const double scrollBarRadius=5.0;
  static const double scrollBarThickness=4.0;


  //DashBoard
  static const Color dashCalendar=Color(0xFFCDCDCD);
  static const Color attendanceDashText1=Color(0xFF949494);
  static const Color spikeColor=Color(0xFFD1E7E7);
  static const Color yAxisText=Color(0xFFB38C1E);

  static TextStyle saleChartTotal=TextStyle(fontFamily: 'RM',fontSize: 12,color: Color(0xffadadad),letterSpacing: 0.1);
  static TextStyle saleChartQty=TextStyle(fontFamily: 'RM',fontSize: 12,color: Color(0xFF6a6a6a),letterSpacing: 0.1);

}
