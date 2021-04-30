import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dieselNotifier.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/pages/dieselManagement/dieselIssueAddNew.dart';
import 'package:quarry/pages/productionDetails/productionDetailsAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';

import 'dieselPurchaseAddNew.dart';



class DieselGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  DieselGrid({this.drawerCallback});
  @override
  DieselGridState createState() => DieselGridState();
}

class DieselGridState extends State<DieselGrid> with TickerProviderStateMixin{

  bool showEdit=false;
  int selectedIndex;

  PageController pageController;

  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;
  int pageIndex=0;

  @override
  void initState() {
    pageController=new PageController(initialPage: 0);
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
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<DieselNotifier>(
            builder: (context,dn,child)=>  Stack(
              children: [

                PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (i){
                    setState(() {
                      pageIndex=i;
                    });
                  },
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 50,
                          width: SizeConfig.screenWidth,
                          color: AppTheme.yellowColor,

                          child: Row(
                            children: [
                              IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                              /*SizedBox(width: SizeConfig.width10,),*/
                              Text("Diesel Management",
                                style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                              ),
                              Spacer(),
                              Container(
                                height: 30,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white
                                ),
                                child: Center(
                                  child: Text("Diesel Purchase",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.green),),
                                ),
                              ),
                              SizedBox(width: SizeConfig.width10,),

                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 50),
                            padding: EdgeInsets.only(left:5,),
                            color: AppTheme.yellowColor,
                            height: 110,
                            alignment: Alignment.topCenter,

                          /*  child:SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(

                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: pn.gridOverAllHeader.asMap().
                                  map((i, value) => MapEntry(i,
                                      Container(
                                        height: SizeConfig.height80,
                                        width: SizeConfig.width120,
                                        margin: EdgeInsets.only(right: SizeConfig.width10),
                                        //padding: EdgeInsets.only(right: SizeConfig.width10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: AppTheme.bgColor
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(value.materialName,style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white,letterSpacing: 0.1),),
                                                SizedBox(height: 5,),
                                                RichText(
                                                  text: TextSpan(
                                                    text: '${value.totalQuantity}',
                                                    style: TextStyle(fontFamily: 'RM',fontSize: 20,color: AppTheme.yellowColor),
                                                    children: <TextSpan>[
                                                      // TextSpan(text: '${value.unitName}', style: TextStyle(fontFamily: 'RR',fontSize: 11,color: AppTheme.addNewTextFieldBorder)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(bottom: SizeConfig.height18),
                                              child: Text(' ${value.unitName}',
                                                  style: TextStyle(fontFamily: 'RR',fontSize: 10,color: AppTheme.addNewTextFieldBorder)
                                              ),
                                            )
                                          ],

                                        ),
                                      )
                                  )
                                  ).values.toList()
                              ),
                            )*/
                        ),
                        Container(
                            height: SizeConfig.screenHeight-140,
                            width: SizeConfig.screenWidth,
                            margin: EdgeInsets.only(top: 140),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color:AppTheme.gridbodyBgColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                              /*  boxShadow: [
                          BoxShadow(
                            color: AppTheme.addNewTextFieldText.withOpacity(0.9),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: Offset(30, 0), // changes position of shadow
                          )
                        ]*/
                            ),
                            child: Stack(
                              children: [

                                //Scrollable
                                Positioned(
                                  left:150,
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
                                              children: dn.dieselPurchaseGridCol.asMap().
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
                                              child: Column(
                                                  children:dn.dieselPurchaseGridList.asMap().
                                                  map((i, value) => MapEntry(
                                                      i,InkWell(
                                                    onTap: (){
                                                      setState(() {

                                                        if(selectedIndex==i){
                                                          selectedIndex=-1;
                                                          showEdit=false;
                                                        } else{
                                                          selectedIndex=i;
                                                          showEdit=true;
                                                        }


                                                      });
                                                    },
                                                    child: Container(

                                                      decoration: BoxDecoration(
                                                        color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,
                                                        /*    boxShadow:[
                                                  selectedIndex==i? BoxShadow(
                                                    color: AppTheme.yellowColor.withOpacity(0.4),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: Offset(1, 8), // changes position of shadow
                                                  ):BoxShadow(
                                                      color: Colors.white
                                                  ),
                                                ],*/
                                                      ),
                                                      height: 60,
                                                      // padding: EdgeInsets.only(top: 20,bottom: 20),
                                                      child: Row(
                                                        children: [


                                                          Container(
                                                            alignment: Alignment.center,
                                                            // padding: EdgeInsets.only(left: 20,right: 20),
                                                            width: 150,
                                                            child: Text("${value.purchaserName}",
                                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                            ),

                                                          ),
                                                          Container(
                                                            alignment: Alignment.center,
                                                            width: 150,
                                                            child: Text("${value.dieselBunkLocation}",
                                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                            ),
                                                          ),

                                                          Container(
                                                            width: 150,
                                                            alignment: Alignment.center,
                                                            child: Text("${value.dieselBunkContactNumber}",
                                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            alignment: Alignment.center,
                                                            child: Text("${value.dieselQuantity}",
                                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            alignment: Alignment.center,
                                                            child: Text("${value.dieselRate}",
                                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            alignment: Alignment.center,
                                                            child: Text("${value.totalAmount}",
                                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            alignment: Alignment.center,
                                                            child: Text("${DateFormat.yMMMd().format(value.billDate)}",
                                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                            ),
                                                          ),


                                                        ],
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
                                        child: Text("${dn.dieselPurchaseGridCol[0]}",style: AppTheme.TSWhite166,),

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
                                            child: Column(
                                                children: dn.dieselPurchaseGridList.asMap().
                                                map((i, value) => MapEntry(
                                                    i,InkWell(
                                                  onTap: (){
                                                    setState(() {

                                                      if(selectedIndex==i){
                                                        selectedIndex=-1;
                                                        showEdit=false;
                                                      } else{
                                                        selectedIndex=i;
                                                        showEdit=true;
                                                      }


                                                    });
                                                  },
                                                  child:  Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,

                                                      boxShadow:[
                                                        /*    selectedIndex==i? BoxShadow(
                                                  color: AppTheme.yellowColor.withOpacity(0.4),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(1, 8), // changes position of shadow
                                                ):BoxShadow(
                                                    color: Colors.white
                                                ),*/
                                                      ],
                                                    ),
                                                    height: 60,
                                                    //  padding: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 20),
                                                    width: 150,
                                                    child: Text("${value.billNumber}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
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




                        ),
                      ],
                    ),

                    Stack(
                      children: [
                        Container(
                          height: 60,
                          padding: EdgeInsets.only(bottom: 10),
                          width: SizeConfig.screenWidth,
                          color: AppTheme.yellowColor,
                          child: Row(
                            children: [
                              IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                              /*SizedBox(width: SizeConfig.width10,),*/
                              Text("Diesel Management",
                                style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                              ),
                              Spacer(),
                              Container(
                                height: 30,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white
                                ),
                                child: Center(
                                  child: Text("Diesel Issue",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.red),),
                                ),
                              ),
                              SizedBox(width: SizeConfig.width10,),


                            ],
                          ),
                        ),

                        Container(
                            height: SizeConfig.screenHeight-50,
                            width: SizeConfig.screenWidth,
                            margin: EdgeInsets.only(top: 50),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color:AppTheme.gridbodyBgColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                            ),
                            child: Stack(
                              children: [

                                //Scrollable
                                Positioned(
                                  left:150,
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
                                              children: dn.dieselIssueGridCol.asMap().
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
                                        height: SizeConfig.screenHeight-160,
                                        width: SizeConfig.screenWidth-150,
                                        alignment: Alignment.topCenter,
                                        color: AppTheme.gridbodyBgColor,
                                        child: SingleChildScrollView(
                                          controller: body,
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            height: SizeConfig.screenHeight-160,
                                            alignment: Alignment.topCenter,
                                            color:AppTheme.gridbodyBgColor,
                                            child: SingleChildScrollView(
                                              controller: verticalRight,
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                  children:dn.dieselIssueGridList.asMap().
                                                  map((i, value) => MapEntry(
                                                      i,InkWell(
                                                    onTap: (){
                                                      setState(() {

                                                        if(selectedIndex==i){
                                                          selectedIndex=-1;
                                                          showEdit=false;
                                                        } else{
                                                          selectedIndex=i;
                                                          showEdit=true;
                                                        }


                                                      });
                                                    },
                                                    child: Container(

                                                      decoration: BoxDecoration(
                                                        color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,
                                                        /*    boxShadow:[
                                                  selectedIndex==i? BoxShadow(
                                                    color: AppTheme.yellowColor.withOpacity(0.4),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: Offset(1, 8), // changes position of shadow
                                                  ):BoxShadow(
                                                      color: Colors.white
                                                  ),
                                                ],*/
                                                      ),
                                                      height: 60,
                                                      // padding: EdgeInsets.only(top: 20,bottom: 20),
                                                      child: Row(
                                                        children: [



                                                          Container(
                                                            alignment: Alignment.center,
                                                            width: 150,
                                                            child: Text("${value.machineName}",
                                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                            ),
                                                          ),

                                                          Container(
                                                            width: 150,
                                                            alignment: Alignment.center,
                                                            child: Text("${value.machineFuelReadingQuantity}",
                                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            alignment: Alignment.center,
                                                            child: Text("${value.issuedName}",
                                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            alignment: Alignment.center,
                                                            child: Text("${value.dieselIssuedQuantity}",
                                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                            ),
                                                          ),



                                                        ],
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
                                        child: Text("${dn.dieselIssueGridCol[0]}",style: AppTheme.TSWhite166,),

                                      ),
                                      Container(
                                        height: SizeConfig.screenHeight-160,
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
                                          height: SizeConfig.screenHeight-160,
                                          alignment: Alignment.topCenter,

                                          child: SingleChildScrollView(
                                            controller: verticalLeft,
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                                children: dn.dieselIssueGridList.asMap().
                                                map((i, value) => MapEntry(
                                                    i,InkWell(
                                                  onTap: (){
                                                    setState(() {

                                                      if(selectedIndex==i){
                                                        selectedIndex=-1;
                                                        showEdit=false;
                                                      } else{
                                                        selectedIndex=i;
                                                        showEdit=true;
                                                      }


                                                    });
                                                  },
                                                  child:  Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,

                                                      boxShadow:[
                                                        /*    selectedIndex==i? BoxShadow(
                                                  color: AppTheme.yellowColor.withOpacity(0.4),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(1, 8), // changes position of shadow
                                                ):BoxShadow(
                                                    color: Colors.white
                                                ),*/
                                                      ],
                                                    ),
                                                    height: 60,
                                                    //  padding: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 20),
                                                    width: 150,
                                                    child: Text("${DateFormat.yMMMd().format(value.issuedDate)}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
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




                        ),

                      ],
                    ),
                  ],
                ),







                //bottomNav
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: 70,

                    decoration: BoxDecoration(
                        color: AppTheme.gridbodyBgColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.gridbodyBgColor,
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: Offset(0, -20), // changes position of shadow
                          )
                        ]
                    ),
                    child: Stack(

                      children: [
                        Container(
                          decoration: BoxDecoration(
                          ),
                          margin:EdgeInsets.only(top: 0),
                          child: CustomPaint(
                            size: Size( SizeConfig.screenWidth, 65),
                            //  painter: RPSCustomPainter(),
                            painter: RPSCustomPainter3(),
                          ),
                        ),
                        Center(
                          heightFactor: 0.5,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                            if(pageIndex==0){
                              dn.updateDieselEdit(false);
                              dn.PlantUserDropDownValues(context);
                              dn.DieselDropDownValues(context);
                              dn.insertDP_Form();
                              Navigator.push(context, _createRoute());
                            }
                            else if(pageIndex==1){
                              dn.updateDieselIssueEdit(false);
                              dn.PlantUserDropDownValues(context);
                              dn.DieselDropDownValues(context);
                              dn.insertDI_form();
                              Navigator.push(context, _createRouteDieselIssue());
                            }

                            /*  if(qn.tabController.index==0){
                                if(qn.SS_vehicleNo.text.isEmpty){
                                  CustomAlert().commonErrorAlert(context, "Enter Vehicle Number", "");
                                }
                                else if(qn.SS_emptyVehicleWeight.text.isEmpty){
                                  CustomAlert().commonErrorAlert(context, "Enter Vehicle Weight", "");
                                }
                                else if(qn.SS_customerNeedWeight.text.isEmpty && qn.SS_customerNeedWeight.text!="0"){
                                  CustomAlert().commonErrorAlert(context, "Enter Customer Need Weight", "");
                                }
                                else{
                                  qn.InsertSaleDetailDbhit(context);
                                }
                              }
                              else if(qn.tabController.index==1){
                                if(qn.searchVehicleNo.text.isEmpty){
                                  CustomAlert().commonErrorAlert(context, "Enter Vehicle Number", "");
                                }
                                else if(qn.SS_DifferWeightController.text.isEmpty){
                                  CustomAlert().commonErrorAlert(context, "Enter Vehicle Weight", "");
                                }else{
                                  qn.UpdateSaleDetailDbhit(context);
                                }
                              }*/



                            },
                            child: Container(

                              height: SizeConfig.width50,
                              width: SizeConfig.width50,
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
                                child: Icon(Icons.add,size: SizeConfig.height30,color: AppTheme.bgColor,),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width:  SizeConfig.screenWidth,
                          height: 80,

                          child: Stack(

                            children: [

                              AnimatedPositioned(
                                bottom:showEdit?-60:5,
                                duration: Duration(milliseconds: 300,),
                                curve: Curves.bounceInOut,
                                child: Container(
                                    width: SizeConfig.screenWidth,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: SizeConfig.width20,),
                                        GestureDetector(
                                          onTap: (){
                                            pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                          },
                                          child: Container(
                                            width: 70,

                                            child:Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/images/Empty-vehicle-active.png",height: 40,width: 40,),
                                                Text('Purchase',style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.hintColor),),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: (){
                                            pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                            dn.GetDieselIssueDbHit(context, null);
                                          },
                                          child: Container(
                                            width: 90,

                                            child:Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/images/Loaded-vehicle-active.png",height: 40,width: 40,),
                                                Text('Issue',style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.hintColor),),

                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: SizeConfig.width10,),
                                      ],
                                    )
                                ),
                              ),

                              AnimatedPositioned(
                                bottom:showEdit?15:-60,
                                duration: Duration(milliseconds: 300,),
                                curve: Curves.bounceInOut,
                                child: Container(

                                    width: SizeConfig.screenWidth,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: SizeConfig.width20,),
                                        GestureDetector(
                                          onTap: (){

                                            if(pageIndex==0){
                                              dn.insertDP_Form();
                                              dn.updateDieselEdit(true);
                                              dn.PlantUserDropDownValues(context).then((value) {
                                                dn.DieselDropDownValues(context);
                                                dn.GetDieselPurchaseDbHit(context, dn.dieselPurchaseGridList[selectedIndex].dieselPurchaseId);
                                                setState(() {
                                                  selectedIndex=-1;
                                                  showEdit=false;
                                                });
                                              });
                                              Navigator.push(context, _createRoute());
                                            }
                                            else if(pageIndex==1){
                                              dn.insertDI_form();
                                              dn.updateDieselIssueEdit(true);
                                              dn.PlantUserDropDownValues(context).then((value) {
                                                dn.DieselDropDownValues(context);
                                                dn.GetDieselIssueDbHit(context, dn.dieselIssueGridList[selectedIndex].dieselIssueId);
                                                setState(() {
                                                  selectedIndex=-1;
                                                  showEdit=false;
                                                });
                                              });
                                              Navigator.push(context, _createRouteDieselIssue());
                                            }





                                          },
                                          child: Container(
                                            width: 70,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTheme.yellowColor.withOpacity(0.7),
                                                    spreadRadius: -3,
                                                    blurRadius: 15,
                                                    offset: Offset(0, 7), // changes position of shadow
                                                  )
                                                ]
                                            ),
                                            child:FittedBox(
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset("assets/svg/edit.svg",height: 20,width: 20,color: AppTheme.yellowColor,),
                                                  SizedBox(width: SizeConfig.width10,),
                                                  Text("Edit",style: TextStyle(fontSize: 20,fontFamily: 'RR',color:Color(0xFFFF9D10)),),


                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: 90,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppTheme.red.withOpacity(0.5),
                                                  spreadRadius: -3,
                                                  blurRadius: 25,
                                                  offset: Offset(0, 7), // changes position of shadow
                                                )
                                              ]
                                          ),
                                          child:FittedBox(
                                            child: Row(
                                              children: [
                                                Text("Delete",style: TextStyle(fontSize: 18,fontFamily: 'RR',color:Colors.red),),
                                                SizedBox(width: SizeConfig.width10,),
                                                SvgPicture.asset("assets/svg/delete.svg",height: 20,width: 20,color: AppTheme.red,),




                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: SizeConfig.width10,),
                                      ],
                                    )
                                ),
                              )

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),




                Container(

                  height: dn.DieselLoader? SizeConfig.screenHeight:0,
                  width: dn.DieselLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                  ),

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => DieselPurchaseForm(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteDieselIssue() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => DieselIssueForm(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}

