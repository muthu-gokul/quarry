import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quarry/styles/app_theme.dart';

class AddButton extends StatelessWidget {
  VoidCallback ontap;
  String image;
  AddButton({this.ontap,this.image="assets/svg/tick.svg"});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: ontap,
      child: Container(

        height: 65,
        width: 65,
        margin: EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.yellowColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.yellowColor.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(1, 8), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(image,height: 30,width: 30,color: AppTheme.indicatorColor,),
        ),
      ),
    );
  }
}
//"assets/svg/plusIcon.svg"


class CancelButton extends StatelessWidget {
  VoidCallback ontap;
  CancelButton({this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: ontap,
      child: Container(

        height: 30,
        width: 30,
        margin: EdgeInsets.only(left: 20,right: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: Icon(Icons.clear,color: AppTheme.addNewTextFieldFocusBorder,size: 18,),
        ),
      ),
    );;
  }
}




//Add Button
/*
Align(
alignment: Alignment.bottomCenter,
child: AddButton(

),
),*/
