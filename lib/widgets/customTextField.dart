import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quarry/styles/app_theme.dart';

import 'package:quarry/styles/size.dart';

class AddNewLabelTextField extends StatelessWidget {
  bool isEnabled;
  String labelText;
  TextEditingController textEditingController;
  double scrollPadding;
  TextInputType textInputType;
  Widget prefixIcon;
  Widget suffixIcon;
  Function(String) onChange;
  VoidCallback ontap;
  TextInputFormatter textInputFormatter;


  AddNewLabelTextField({this.textEditingController,this.labelText,this.scrollPadding,this.textInputType:TextInputType.text,
    this.prefixIcon,this.ontap,this.onChange,this.textInputFormatter,this.isEnabled=true,this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return  Container(

      margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
      // height:maxLines>1?(SizeConfig.height100): SizeConfig.height60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.transparent
      ),
      child:  TextFormField(
         enabled: isEnabled,
         onTap: ontap,
         scrollPadding: EdgeInsets.only(bottom: scrollPadding),
        style:  TextStyle(fontFamily: 'RR',fontSize: 20,color:AppTheme.addNewTextFieldText),
        controller: textEditingController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelStyle: TextStyle(fontFamily: 'RR',fontSize: 20,color: AppTheme.addNewTextFieldText.withOpacity(0.5)),
          border:  OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color:AppTheme.addNewTextFieldFocusBorder)
          ),
          labelText: labelText,
          // contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon



        ),
        maxLines: null,
        keyboardType: textInputType,
        textInputAction: TextInputAction.done,
        // inputFormatters:  <TextInputFormatter>[
        //
        //   //textInputFormatter
        // ],

        // inputFormatters: <TextInputFormatter>[
        //   FilteringTextInputFormatter.digitsOnly
        // ],
        onChanged: (v){
           onChange(v);
        },
      ),

    );

  }
}
