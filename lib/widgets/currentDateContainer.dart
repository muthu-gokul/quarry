
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
class CurrentDate extends StatelessWidget {

  DateTime date;
  CurrentDate(this.date);

  @override
  Widget build(BuildContext context) {
    return Container(

        margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top:20,),
        padding: EdgeInsets.only(left:SizeConfig.width10!,),
        height: 50,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: AppTheme.addNewTextFieldBorder),
            color: AppTheme.editDisableColor
        ),
        child:  Text("${DateFormat.yMMMd().format(date)} / ${DateFormat().add_jm().format(date)}",
          style: AppTheme.bgColorTS,
        )

    );
  }
}
