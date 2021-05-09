import 'package:flutter/material.dart';

import '../../styles/app_theme.dart';
import '../../styles/size.dart';

class CustomDataTable extends StatefulWidget {
  List<String> gridCol=[];
  List<String> gridDataRowList=[];
  List<dynamic> gridData=[];

  int selectedIndex;
  VoidCallback voidCallback;
  Function(int) func;
  double topMargin;//70 || 50
  double gridBodyReduceHeight;// 260  // 140

  CustomDataTable({this.gridCol,this.gridDataRowList,this.gridData,this.selectedIndex,this.voidCallback,this.func,this.topMargin,this.gridBodyReduceHeight});
  @override
  _CustomDataTableState createState() => _CustomDataTableState(gridCol: gridCol,gridDataRowList: gridDataRowList,voidCallback: voidCallback);
}

class _CustomDataTableState extends State<CustomDataTable> {


  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;
  List<String> gridCol=[];
  List<String> gridDataRowList=[];

  VoidCallback voidCallback;

  _CustomDataTableState({this.gridCol,this.gridDataRowList,this.voidCallback});

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
                          children: gridCol.asMap().
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
                                  // padding: EdgeInsets.only(top: 20,bottom: 20),
                                  child: Row(
                                    children: gridDataRowList.asMap().map((j, v) => MapEntry(j,
                                      j==0?Container():Container(
                                        alignment: Alignment.center,
                                        // padding: EdgeInsets.only(left: 20,right: 20),
                                        width: 150,
                                        child: Text("${value.get(v)??""}",
                                          style:widget.selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                        ),

                                      ),
                                    )).values.toList()
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
                    alignment: Alignment.center,
                    child: Text("${gridCol[0]}",style: AppTheme.TSWhite166,),

                  ),
                  Container(
                    height: SizeConfig.screenHeight-widget.gridBodyReduceHeight,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        color: AppTheme.gridbodyBgColor,
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
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: AppTheme.gridBottomborder,
                                  color: widget.selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,
                                ),
                                height: 50,
                                width: 150,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    //color:value.invoiceType=='Receivable'? Colors.green:AppTheme.red,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text("${value.get(gridDataRowList[0])}",
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




          ],
        )




    );
  }
}
