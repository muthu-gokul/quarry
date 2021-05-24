import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../styles/app_theme.dart';
import '../../styles/size.dart';

class GridStyleModel{
  String columnName;
  double width;
  Alignment alignment;
  EdgeInsets edgeInsets;
  GridStyleModel({this.columnName,this.width=150,this.alignment=Alignment.centerLeft,
    this.edgeInsets=const EdgeInsets.only(left: 10)});
}

class CustomDataTable2 extends StatefulWidget {

  List<GridStyleModel> gridDataRowList=[];
  List<dynamic> gridData=[];

  int selectedIndex;
  VoidCallback voidCallback;
  Function(int) func;
  double topMargin;//70 || 50
  double gridBodyReduceHeight;// 260  // 140

  CustomDataTable2({this.gridDataRowList,this.gridData,this.selectedIndex,this.voidCallback,this.func,this.topMargin,this.gridBodyReduceHeight});
  @override
  _CustomDataTable2State createState() => _CustomDataTable2State(gridDataRowList: gridDataRowList,voidCallback: voidCallback);
}

class _CustomDataTable2State extends State<CustomDataTable2> {


  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;

  List<GridStyleModel> gridDataRowList=[];

  VoidCallback voidCallback;

  _CustomDataTable2State({this.gridDataRowList,this.voidCallback});

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
    // print("CustomTable");
    // print(widget.gridData);
    // print(gridDataRowList);
    // print(gridCol);
    // print(widget.selectedIndex);
    return Container(
        height: SizeConfig.screenHeight-widget.topMargin,
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(top: widget.topMargin),
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
                    width: SizeConfig.screenWidth-149,
                    color: showShadow? AppTheme.bgColor.withOpacity(0.8):AppTheme.bgColor,
                    child: SingleChildScrollView(
                      controller: header,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: widget.gridDataRowList.asMap().
                          map((i, value) => MapEntry(i, i==0?Container():
                          Container(
                              alignment: value.alignment,
                              padding: value.edgeInsets,
                              width: value.width,
                              constraints: BoxConstraints(
                                  minWidth: 100,
                                  maxWidth: 200
                              ),
                              child: FittedBox(child: Text(value.columnName,style: AppTheme.TSWhite166,))
                          )
                          )).values.toList()
                      ),
                    ),

                  ),
                  Container(
                    height: SizeConfig.screenHeight-widget.gridBodyReduceHeight,
                    width: SizeConfig.screenWidth-149,
                    alignment: Alignment.topCenter,
                    color: AppTheme.gridbodyBgColor,
                    child: SingleChildScrollView(
                      controller: body,
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        height: SizeConfig.screenHeight-widget.gridBodyReduceHeight,
                        alignment: Alignment.topCenter,
                        color:AppTheme.gridbodyBgColor,
                        child: SingleChildScrollView(
                          controller: verticalRight,
                          scrollDirection: Axis.vertical,
                          child: Column(
                              children:widget.gridData.asMap().
                              map((i, value) => MapEntry(
                                  i,InkWell(
                                //   onTap: widget.voidCallback,
                                onTap: (){
                                  widget.func(i);
                                  //setState(() {});
                                },
                                child: Container(

                                  decoration: BoxDecoration(
                                    border: AppTheme.gridBottomborder,
                                    color: widget.selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,
                                  ),
                                  height: 50,
                                  margin: EdgeInsets.only(bottom:i==widget.gridData.length-1?70: 0),
                                  child: Row(
                                      children: gridDataRowList.asMap().map((j, v) {


                                          if((7.0*value.get(v.columnName).toString().length)>v.width){
                                          setState(() {
                                            v.width=7.0*value.get(v.columnName).toString().length;
                                          });
                                          }

                                        return MapEntry(j,
                                          j==0?Container():Container(
                                            width: v.width,
                                            height: 50,
                                            alignment: v.alignment,
                                            padding: v.edgeInsets,
                                            constraints: BoxConstraints(
                                              minWidth: 100,
                                              maxWidth: 200
                                            ),
                                            decoration: BoxDecoration(

                                            ),

                                            child: Text("${value.get(v.columnName).toString().isNotEmpty?value.get(v.columnName)??" ":" "}",
                                              style:widget.selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                            ),
                                          ),
                                        );
                                      }
                                      ).values.toList()
                                  ),
                                ),
                              )
                              )
                              ).values.toList()
                          ),
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
                    padding: widget.gridDataRowList[0].edgeInsets,
                    alignment: widget.gridDataRowList[0].alignment,
                    child: Text("${widget.gridDataRowList[0].columnName}",style: AppTheme.TSWhite166,),

                  ),
                  Container(
                    height: SizeConfig.screenHeight-widget.gridBodyReduceHeight,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        color:showShadow? AppTheme.gridbodyBgColor:Colors.transparent,
                        boxShadow: [
                          showShadow?  BoxShadow(
                            color: AppTheme.addNewTextFieldText.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: Offset(0, -8), // changes position of shadow
                          ):BoxShadow(color: Colors.transparent)
                        ]
                    ),
                    child: Container(
                      height: SizeConfig.screenHeight-widget.gridBodyReduceHeight,
                      alignment: Alignment.topCenter,

                      child: SingleChildScrollView(
                        controller: verticalLeft,
                        scrollDirection: Axis.vertical,
                        child: Column(
                            children: widget.gridData.asMap().
                            map((i, value) => MapEntry(
                                i,InkWell(
                              onTap: (){
                                widget.func(i);
                                //setState(() {});
                              },
                              child:  Container(
                                alignment:gridDataRowList[0].alignment,
                                padding: gridDataRowList[0].edgeInsets,
                                margin: EdgeInsets.only(bottom:i==widget.gridData.length-1?70: 0),
                                decoration: BoxDecoration(
                                  border: AppTheme.gridBottomborder,
                                  color: widget.selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,

                                ),
                                height: 50,
                                width: 150,
                                constraints: BoxConstraints(
                                  maxWidth: 150
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    //color:value.invoiceType=='Receivable'? Colors.green:AppTheme.red,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text("${value.get(gridDataRowList[0].columnName)}",
                                      style:widget.selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            )
                            ).values.toList()


                        ),
                      ),


                    ),
                  ),
                ],
              ),
            ),


            widget.gridData.isEmpty?Container(
              width: SizeConfig.screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 70,),
                  Text("No Data",style: TextStyle(fontSize: 18,fontFamily:'RMI',color: AppTheme.addNewTextFieldText),),
                  SvgPicture.asset("assets/nodata.svg",height: 350,),

                ],
              ),
            ):Container()


          ],
        )

    );
  }
}
