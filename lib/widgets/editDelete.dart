import 'package:flutter/material.dart';
import 'package:quarry/styles/size.dart';

class EditDelete extends StatelessWidget {

  bool showEdit;
  VoidCallback editTap;
  EditDelete({this.showEdit,this.editTap});

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
              Container(
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
            ],
          )
      ),
    );
  }
}
