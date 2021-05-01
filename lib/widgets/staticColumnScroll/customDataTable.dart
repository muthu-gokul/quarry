import 'package:flutter/material.dart';

import '../../styles/app_theme.dart';
import '../../styles/size.dart';

class CustomDataTable extends StatefulWidget {
  List<String> dieselPurchaseGridCol=[];
  Widget scrollable;
  Widget nonScrollable;
  CustomDataTable({this.nonScrollable,this.scrollable,this.dieselPurchaseGridCol});
  @override
  _CustomDataTableState createState() => _CustomDataTableState(nonScrollable: nonScrollable,scrollable: scrollable,dieselPurchaseGridCol: dieselPurchaseGridCol);
}

class _CustomDataTableState extends State<CustomDataTable> {


  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;
  List<String> dieselPurchaseGridCol=[];
  Widget scrollable;
  Widget nonScrollable;

  _CustomDataTableState({this.nonScrollable,this.scrollable,this.dieselPurchaseGridCol});

  @override
  void initState() {
    header.addListener(() {
      if(body.offset!=header.offset){
        body.jumpTo(header.offset);
      }
      if(header.offset==0){
        setState(() {
          showShadow=false;
        });
      }
      else{
        if(!showShadow){
          setState(() {
            showShadow=true;
          });
        }
      }
    });

    body.addListener(() {
      if(header.offset!=body.offset){
        header.jumpTo(body.offset);
      }
    });

    verticalLeft.addListener(() {
      if(verticalRight.offset!=verticalLeft.offset){
        verticalRight.jumpTo(verticalLeft.offset);
      }
    });

    verticalRight.addListener(() {
      if(verticalLeft.offset!=verticalRight.offset){
        verticalLeft.jumpTo(verticalRight.offset);
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.screenHeight-140,
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(top: 140),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color:AppTheme.gridbodyBgColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        child: Stack(
          children: [

            //Scrollable
            Positioned(
              left:149,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: SizeConfig.screenWidth-150,
                    color: showShadow? AppTheme.bgColor.withOpacity(0.8):AppTheme.bgColor,
                    child: SingleChildScrollView(
                      controller: header,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: dieselPurchaseGridCol.asMap().
                          map((i, value) => MapEntry(i, i==0?Container():
                          Container(
                              alignment: Alignment.center,
                              //  padding: EdgeInsets.only(left: 20,right: 20),
                              width: 150,
                              child: Text(value,style: AppTheme.TSWhite166,)
                          )
                          )).values.toList()
                      ),
                    ),

                  ),
                  Container(
                    height: SizeConfig.screenHeight-260,
                    width: SizeConfig.screenWidth-150,
                    alignment: Alignment.topCenter,
                    color: AppTheme.gridbodyBgColor,
                    child: SingleChildScrollView(
                      controller: body,
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        height: SizeConfig.screenHeight-260,
                        alignment: Alignment.topCenter,
                        color:AppTheme.gridbodyBgColor,
                        child: SingleChildScrollView(
                          controller: verticalRight,
                          scrollDirection: Axis.vertical,
                          child: scrollable
                        ),


                      ),
                    ),
                  ),
                ],
              ),
            ),


            //not Scrollable
            Positioned(
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 150,
                    color: AppTheme.bgColor,
                    alignment: Alignment.center,
                    child: Text("${dieselPurchaseGridCol[0]}",style: AppTheme.TSWhite166,),

                  ),
                  Container(
                    height: SizeConfig.screenHeight-260,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        color: AppTheme.gridbodyBgColor,
                        boxShadow: [
                          showShadow?  BoxShadow(
                            color: AppTheme.addNewTextFieldText.withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: Offset(10, -8), // changes position of shadow
                          ):BoxShadow(color: Colors.transparent)
                        ]
                    ),
                    child: Container(
                      height: SizeConfig.screenHeight-260,
                      alignment: Alignment.topCenter,

                      child: SingleChildScrollView(
                        controller: verticalLeft,
                        scrollDirection: Axis.vertical,
                        child: nonScrollable
                      ),


                    ),
                  ),
                ],
              ),
            ),




          ],
        )




    );
  }
}
