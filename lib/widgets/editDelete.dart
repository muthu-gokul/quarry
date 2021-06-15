import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';

class EditDelete extends StatelessWidget {

  bool showEdit;
  VoidCallback editTap;
  VoidCallback deleteTap;
  EditDelete({this.showEdit,this.editTap,this.deleteTap});

  @override
  Widget build(BuildContext context) {
    return  AnimatedPositioned(
      bottom:showEdit?5:-60,
      duration: Duration(milliseconds: 300,),
      curve: Curves.bounceOut,
      child: Container(

          width: SizeConfig.screenWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              GestureDetector(
                onTap: editTap,
                child:Container(
                  width: 130,
                  height: 50,
                  padding: EdgeInsets.only(left: 20),
                  child:FittedBox(
                    child: Container(
                        height: 55,
                        width: 130,
                        alignment: Alignment.centerLeft,
                        child: FittedBox(child: Image.asset("assets/bottomIcons/edit-text-icon.png"))
                    ),
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: deleteTap,
                child: Container(
                  width: 130,
                  height: 50,
                  padding: EdgeInsets.only(right: 20),
                  child:FittedBox(
                    child: Container(
                        height: 47,
                        width: 130,
                        alignment: Alignment.centerRight,
                        child: FittedBox(child: Image.asset("assets/bottomIcons/delete-text-icon.png"))
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}

class EditDeletePdf extends StatelessWidget {

  bool showEdit;
  VoidCallback editTap;
  VoidCallback deleteTap;
  VoidCallback viewTap;
  VoidCallback pdfTap;
  EditDeletePdf({this.showEdit,this.editTap,this.deleteTap,this.viewTap,this.pdfTap});

  @override
  Widget build(BuildContext context) {
    return  AnimatedPositioned(
      bottom:showEdit?15:-60,
      duration: Duration(milliseconds: 300,),
      curve: Curves.bounceOut,
      child: Container(

          width: SizeConfig.screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              GestureDetector(
                onTap: editTap,
                child: SvgPicture.asset("assets/svg/edit.svg",width: 23,height: 23,
                  color: AppTheme.bgColor,
                ),
              ),
              GestureDetector(
                onTap: deleteTap,
                child: SvgPicture.asset("assets/svg/delete.svg",width: 25,height: 25,
            //      color: AppTheme.bgColor,
                ),
              ),

              SizedBox(width: SizeConfig.screenWidth*0.27,),
              GestureDetector(
                onTap: viewTap,
                child: SvgPicture.asset("assets/svg/pdfView.svg",width: 27,height: 27,
               //   color: AppTheme.bgColor,
                ),
              ),
              GestureDetector(
                onTap: pdfTap,
                child: SvgPicture.asset("assets/bottomIcons/pdf-active.svg",width: 25,height: 25,
             //     color: AppTheme.bgColor,
                ),
              ),
            ],
          )
      ),
    );
  }
}
