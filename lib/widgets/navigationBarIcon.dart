import 'package:flutter/material.dart';
import 'package:quarry/styles/app_theme.dart';

class NavBarIcon extends StatelessWidget {
  const NavBarIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 22,
      color: Colors.transparent,
      margin: EdgeInsets.only(left: 20,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6,),
          Container(
            height: 2,
            width: 25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppTheme.bgColor
            ),
          ),
          SizedBox(height: 2,),
          Container(
            height: 2,
            width: 17,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppTheme.grey
            ),
          ),
          SizedBox(height: 2,),
          Container(
            height: 2,
            width: 25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppTheme.bgColor
            ),
          ),
          SizedBox(height: 2,),
          Container(
            height: 2,
            width: 17,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppTheme.grey
            ),
          ),
        ],
      ),
    );
  }
}
