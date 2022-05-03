
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';

import 'package:quarry/pages/goodsReceived/goodsMaterialsList.dart';
import 'package:quarry/pages/goodsReceived/goodsOutGateForm.dart';
import 'package:quarry/pages/goodsReceived/goodsPlantList.dart';
import 'package:quarry/pages/goodsReceived/goodsToInvoice.dart';

import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:quarry/widgets/navigationBarIcon.dart';

import '../../styles/size.dart';





class GoodsReceivedGrid extends StatefulWidget {
  VoidCallback? drawerCallback;
  GoodsReceivedGrid({this.drawerCallback});
  @override
  GoodsReceivedGridState createState() => GoodsReceivedGridState();
}

class GoodsReceivedGridState extends State<GoodsReceivedGrid> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController? scrollController;
  ScrollController? listViewController;

  bool isListScroll=false;

  bool isInvoiceOpen=false;
  bool isInvoice=false;

  bool isCompletedGoods=false;

 late AnimationController _controller,goodsAllController,goodsDataController;
  late Animation goodsAllAnimation,goodsDataAnimation;

  int index=1;

  @override
  void initState() {
    isEdit=false;
    index=1;
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this,);

    goodsAllController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this,);
    goodsAllAnimation=Tween(begin: 0.0,end: 1.0).animate(goodsAllController);

    goodsDataController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this,);
    goodsDataAnimation=Tween<double>(begin: 0.0,end: 1.0).animate(goodsDataController);

    WidgetsBinding.instance!.addPostFrameCallback((_){

      goodsDataController.forward();

      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<GoodsReceivedNotifier>(
          builder: (context,gr,child)=> Stack(
            children: [



              //IMAGE
              Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Column(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth,
                      height: 190,
                      decoration: BoxDecoration(
                        color: AppTheme.yellowColor,
                         image: DecorationImage(
                                     image: AssetImage("assets/svg/gridHeader/goodsHeader.jpg",),
                                   fit: BoxFit.cover
                                 )

                      ),
                  //    child: SvgPicture.asset("assets/svg/gridHeader/goodsHeader.svg"),

                    ),
                  ],
                ),
              ),


              Container(
                height: SizeConfig.screenHeight,

                // color: Colors.transparent,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(height: 160,),
                      GestureDetector(
                        onVerticalDragUpdate: (details){

                          int sensitivity = 5;
                          if (details.delta.dy > sensitivity) {
                            scrollController!.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                              if(isListScroll){
                                setState(() {
                                  isListScroll=false;
                                });
                              }
                            });

                          } else if(details.delta.dy < -sensitivity){
                            scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

                              if(!isListScroll){
                                setState(() {
                                  isListScroll=true;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          height: SizeConfig.screenHeight!-60,
                          width: SizeConfig.screenWidth,
                          padding: EdgeInsets.only(top: 0,bottom: 80),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: AppTheme.gridbodyBgColor,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: Stack(
                            children: [
                              FadeTransition(
                                opacity: goodsDataAnimation as Animation<double>,
                                child:index==1? NotificationListener<ScrollNotification>(
                                  onNotification: (s){
                                    //   print(ScrollStartNotification);
                                    if(s is ScrollStartNotification){

                                      if(listViewController!.offset==0 && isListScroll && scrollController!.offset==100 && listViewController!.position.userScrollDirection==ScrollDirection.idle){

                                        Timer(Duration(milliseconds: 100), (){
                                          if(listViewController!.position.userScrollDirection!=ScrollDirection.reverse){

                                            //if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
                                            if(listViewController!.offset==0){

                                              scrollController!.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value) {
                                                if(isListScroll){
                                                  setState(() {
                                                    isListScroll=false;
                                                  });
                                                }
                                              });
                                            }

                                          }
                                        });
                                      }
                                    }
                                    return true;
                                  } ,
                                  child: SingleChildScrollView(
                                    physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                                    controller: listViewController,
                                    child: gr.goodsGridList.isEmpty?Container(
                                      width: SizeConfig.screenWidth,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 70,),
                                          Text("No Data Found",style: TextStyle(fontSize: 18,fontFamily:'RMI',color: AppTheme.addNewTextFieldText),),
                                          SvgPicture.asset("assets/nodata.svg",height: 350,),

                                        ],
                                      ),
                                    ):
                                    Wrap(
                                        children: gr.goodsGridList.asMap()
                                            .map((i, value) => MapEntry(i,
                                          GestureDetector(
                                            onTap: (){
                                              //  Navigator.push(context, _createRoute());
                                              /*   gr.GetplantDetailDbhit(context, gr.plantGridList[i].plantId);*/

                                            },
                                            child: ScaleTransition(
                                              scale: Tween(begin: 1.0, end: 0.0)
                                                  .animate(new CurvedAnimation(parent: value.controller!, curve: Curves.easeInOutBack)),
                                              child: AnimatedOpacity(
                                                // opacity: value.isAnimate?0:1,
                                                opacity: 1,

                                                duration: Duration(milliseconds: 200),
                                                curve: Curves.easeIn,
                                                child:Container(
                                                  //  duration: Duration(milliseconds: 200),
                                                  //  curve: Curves.easeIn,
                                                  height: value.isAnimate!?0: 200,
                                                  width:value.isAnimate!?0: SizeConfig.screenWidth!*0.5,
                                                  /*height: value.isAnimate?0:200,
                                            width:  value.isAnimate?0: SizeConfig.screenWidth*0.5,
                                            transform: Matrix4.translationValues(value.isAnimate?SizeConfig.screenWidth*0.25:0, value.isAnimate?100:0, 0),*/
                                                  child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      //  margin: EdgeInsets.only(top: 10),
                                                      height: 200,
                                                      // height: SizeConfig.screenWidth*0.5,
                                                      width: SizeConfig.screenWidth!*0.5,

                                                      decoration: BoxDecoration(
                                                        //  borderRadius: BorderRadius.circular(10),
                                                        color: AppTheme.gridbodyBgColor,
                                                      ),
                                                      child: Center(
                                                        child: Container(
                                                          height: 160,
                                                          // height: SizeConfig.screenWidth*0.4,
                                                          width: SizeConfig.screenWidth!*0.4,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(20),
                                                            /* boxShadow: [
                                                          BoxShadow(
                                                            color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(0, 0), // changes position of shadow
                                                          )
                                                        ]*/
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              value.status!='Not Yet'?Text("${value.grnNumber}",
                                                                style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16),
                                                              ):Container(),
                                                              value.status!='Not Yet'? SizedBox(height: 5,):Container(),
                                                              Text("${value.purchaseOrderNumber}",
                                                                style: TextStyle(fontFamily: 'RM',color: value.status!='Not Yet'?AppTheme.gridTextColor: AppTheme.bgColor,
                                                                    fontSize: value.status!='Not Yet'? 12:16),
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Text("${value.date}",
                                                                style: TextStyle(fontFamily: 'RR',color: AppTheme.gridTextColor.withOpacity(0.6),fontSize: 14),
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Text("${value.status}",
                                                                style: TextStyle(fontFamily: 'RR',color: value.status=="Not Yet"? AppTheme.gridTextColor.withOpacity(0.6):
                                                                value.status=='Completed'?Colors.green:AppTheme.red.withOpacity(0.6)
                                                                    ,fontSize: 14),
                                                              ),
                                                              SizedBox(height: 20,),
                                                              GestureDetector(
                                                                onTap: (){
                                                                  if(isInvoice){
                                                                    if(value.status!='Not Yet'){
                                                                      if(value.IsVehicleOutPending==0){
                                                                        gr.GoodsDropDownValues(context);
                                                                        gr.GINV_clear();
                                                                        gr.GPO_clear();
                                                                        gr.GetGoodsDbHit(context, value.goodsReceivedId, value.purchaseOrderId,true,this);
                                                                        Navigator.push(context, _createRouteGoodsToInvoice());

                                                                        gr.goodsGridList.forEach((element) {
                                                                          Timer(Duration(milliseconds: 300), (){
                                                                            if(element.status=="Not Yet"){
                                                                              setState(() {
                                                                                element.isAnimate=false;
                                                                              });
                                                                              element.controller!.reverse().then((value){

                                                                              });
                                                                            }
                                                                          });

                                                                        });
                                                                        setState(() {
                                                                          isInvoiceOpen=false;
                                                                          isInvoice=false;
                                                                        });
                                                                        _controller.reverse();
                                                                      }
                                                                      else{
                                                                        CustomAlert().commonErrorAlert(context, "Cant Convert to Invoice", "Complete the Pending InGate Vehicles to raise Invoice");
                                                                      }

                                                                    }
                                                                  }
                                                                  else{
                                                                    gr.GoodsDropDownValues(context);
                                                                    gr.GetGoodsDbHit(context, value.goodsReceivedId, value.purchaseOrderId,false,this);
                                                                    Navigator.push(context, _createRoute());
                                                                  }

                                                                },
                                                                child: Container(
                                                                  height: 40,
                                                                  width: SizeConfig.screenWidth!*0.3,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: AppTheme.yellowColor,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: AppTheme.yellowColor.withOpacity(0.4),
                                                                          spreadRadius: 1,
                                                                          blurRadius: 5,
                                                                          offset: Offset(1, 8),
                                                                        )// changes position of shadow

                                                                      ]
                                                                  ),
                                                                  child: Center(
                                                                    child: Text("View",style:TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),



                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                        )
                                        ).values.toList()
                                    ),
                                  ),
                                ):Container(),
                              ),


                              FadeTransition(
                                opacity: goodsAllAnimation as Animation<double>,
                                child:index==2? NotificationListener<ScrollNotification>(
                                  onNotification: (s){
                                    //   print(ScrollStartNotification);
                                    if(s is ScrollStartNotification){

                                      if(listViewController!.offset==0 && isListScroll && scrollController!.offset==100 && listViewController!.position.userScrollDirection==ScrollDirection.idle){

                                        Timer(Duration(milliseconds: 100), (){
                                          if(listViewController!.position.userScrollDirection!=ScrollDirection.reverse){

                                            //if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
                                            if(listViewController!.offset==0){

                                              scrollController!.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value) {
                                                if(isListScroll){
                                                  setState(() {
                                                    isListScroll=false;
                                                  });
                                                }
                                              });
                                            }

                                          }
                                        });
                                      }
                                    }
                                    return true;
                                  } ,
                                  child: SingleChildScrollView(
                                    physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                                    controller: listViewController,
                                    child: gr.goodsAllGridList.isEmpty?Container(
                                      width: SizeConfig.screenWidth,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 70,),
                                          Text("No Data Found",style: TextStyle(fontSize: 18,fontFamily:'RMI',color: AppTheme.addNewTextFieldText),),
                                          SvgPicture.asset("assets/nodata.svg",height: 350,),

                                        ],
                                      ),
                                    ):
                                    Wrap(
                                        children: gr.goodsAllGridList.asMap()
                                            .map((i, value) => MapEntry(i,
                                          GestureDetector(
                                            onTap: (){
                                              //  Navigator.push(context, _createRoute());
                                              /*   gr.GetplantDetailDbhit(context, gr.plantGridList[i].plantId);*/

                                            },
                                            child: ScaleTransition(
                                              scale: Tween(begin: 1.0, end: 0.0)
                                                  .animate(new CurvedAnimation(parent: value.controller!, curve: Curves.easeInOutBack)),
                                              child: AnimatedOpacity(
                                                // opacity: value.isAnimate?0:1,
                                                opacity: 1,

                                                duration: Duration(milliseconds: 200),
                                                curve: Curves.easeIn,
                                                child:Container(
                                                  //  duration: Duration(milliseconds: 200),
                                                  //  curve: Curves.easeIn,
                                                  height: value.isAnimate!?0: 200,
                                                  width:value.isAnimate!?0: SizeConfig.screenWidth!*0.5,
                                                  /*height: value.isAnimate?0:200,
                                            width:  value.isAnimate?0: SizeConfig.screenWidth*0.5,
                                            transform: Matrix4.translationValues(value.isAnimate?SizeConfig.screenWidth*0.25:0, value.isAnimate?100:0, 0),*/
                                                  child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Container(
                                                      //  margin: EdgeInsets.only(top: 10),
                                                      height: 200,
                                                      // height: SizeConfig.screenWidth*0.5,
                                                      width: SizeConfig.screenWidth!*0.5,

                                                      decoration: BoxDecoration(
                                                        //  borderRadius: BorderRadius.circular(10),
                                                        color: AppTheme.gridbodyBgColor,
                                                      ),
                                                      child: Center(
                                                        child: Container(
                                                          height: 160,
                                                          // height: SizeConfig.screenWidth*0.4,
                                                          width: SizeConfig.screenWidth!*0.4,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(20),
                                                            /* boxShadow: [
                                                          BoxShadow(
                                                            color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(0, 0), // changes position of shadow
                                                          )
                                                        ]*/
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              value.status!='Not Yet'?Text("${value.grnNumber}",
                                                                style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16),
                                                              ):Container(),
                                                              value.status!='Not Yet'? SizedBox(height: 5,):Container(),
                                                              Text("${value.purchaseOrderNumber}",
                                                                style: TextStyle(fontFamily: 'RM',color: value.status!='Not Yet'?AppTheme.gridTextColor: AppTheme.bgColor,
                                                                    fontSize: value.status!='Not Yet'? 12:16),
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Text("${value.date}",
                                                                style: TextStyle(fontFamily: 'RR',color: AppTheme.gridTextColor.withOpacity(0.6),fontSize: 14),
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Text("${value.status}",
                                                                style: TextStyle(fontFamily: 'RR',color: value.status=="Not Yet"? AppTheme.gridTextColor.withOpacity(0.6):
                                                                value.status=='Completed'?Colors.green:AppTheme.red.withOpacity(0.6)
                                                                    ,fontSize: 14),
                                                              ),
                                                              SizedBox(height: 20,),
                                                              GestureDetector(
                                                                onTap: (){


                                                                    gr.GoodsDropDownValues(context);
                                                                    gr.GetGoodsDbHit(context, value.goodsReceivedId, value.purchaseOrderId,false,this);
                                                                    Navigator.push(context, _createRoute());


                                                                },
                                                                child: Container(
                                                                  height: 40,
                                                                  width: SizeConfig.screenWidth!*0.3,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: AppTheme.yellowColor,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: AppTheme.yellowColor.withOpacity(0.4),
                                                                          spreadRadius: 1,
                                                                          blurRadius: 5,
                                                                          offset: Offset(1, 8),
                                                                        )// changes position of shadow

                                                                      ]
                                                                  ),
                                                                  child: Center(
                                                                    child: Text("View",style:TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),



                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                        )
                                        ).values.toList()
                                    ),
                                  ),
                                ):Container(),
                              ),

                            ],
                          )
                        ),
                      )
                    ],
                  ),
                ),
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
                          size: Size( SizeConfig.screenWidth!, 65),
                          //  painter: RPSCustomPainter(),
                          painter: RPSCustomPainter3(),
                        ),
                      ),

                      Container(
                        width:  SizeConfig.screenWidth,
                        height: 80,
                        padding: EdgeInsets.only(bottom: 10),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Consumer<ProfileNotifier>(
                                builder: (context,pn,child)=> GestureDetector(
                                  onTap: (){
                                    if(pn.usersPlantList.length>1){
                                      if(gr.filterUsersPlantList.isEmpty){
                                        setState(() {
                                          pn.usersPlantList.forEach((element) {
                                            gr.filterUsersPlantList.add(ManageUserPlantModel(
                                              plantId: element.plantId,
                                              plantName: element.plantName,
                                              isActive: element.isActive,

                                            ));
                                          });
                                        });
                                      }
                                      else if(gr.filterUsersPlantList.length!=pn.usersPlantList.length){
                                        gr.filterUsersPlantList.clear();
                                        setState(() {
                                          pn.usersPlantList.forEach((element) {
                                            gr.filterUsersPlantList.add(ManageUserPlantModel(
                                              plantId: element.plantId,
                                              plantName: element.plantName,
                                              isActive: element.isActive,

                                            ));
                                          });
                                        });
                                      }

                                      Navigator.push(context, _createRouteGoodsPlant());
                                    }
                                  },
                                  child: SvgPicture.asset("assets/bottomIcons/plant-slection.svg",height: 40,width: 40,
                                    color: pn.usersPlantList.length<=1?AppTheme.bgColor.withOpacity(0.4):AppTheme.bgColor,),
                                )
                            ),
                            GestureDetector(
                                onTap: (){
                                  setState(() {
                                    isCompletedGoods=true;
                                    index=2;
                                  });
                                  _controller.forward();
                                  goodsDataController.reverse();
                                  goodsAllController.forward();
                                },
                                child: SvgPicture.asset("assets/bottomIcons/completed-Goods.svg",height: 37,width: 37,)),


                            SizedBox(width: SizeConfig.screenWidth!*0.25,),
                            GestureDetector(
                                onTap: (){
                                  gr.clearOGFform();
                                  gr.GoodsDropDownValues(context);
                                  Navigator.push(context, _createRouteOutGateForm());

                                },
                                child: SvgPicture.asset("assets/bottomIcons/out-gate.svg",height: 42,width: 40,color: AppTheme.bgColor)
                            ),
                            GestureDetector(
                                onTap:isInvoiceOpen?null: (){
                                  print(isInvoiceOpen);
                                  print(isInvoice);
                                  _controller.forward();
                                  setState(() {
                                    isInvoiceOpen=true;
                                   // isInvoice=!isInvoice;
                                    isInvoice=true;
                                  });





                                  if(isInvoice){



                                    gr.goodsGridList.forEach((element) {

                                     Timer(Duration(milliseconds: 300), (){
                                       if(element.status=="Not Yet"){
                                         element.controller!.forward().then((value){
                                           setState(() {
                                             element.isAnimate=true;
                                           });
                                         });
                                       }
                                        });


                                    });
                                    setState(() {
                                      isInvoiceOpen=false;
                                      //isInvoice=true;
                                    });
                                  }
                                  else{
                                   /* gr.goodsGridList.forEach((element) {
                                      Timer(Duration(milliseconds: 300), (){
                                        if(element.status=="Not Yet"){
                                          setState(() {
                                            element.isAnimate=false;
                                          });
                                          element.controller.reverse().then((value){

                                          });
                                        }
                                      });

                                    });
                                    setState(() {
                                      isInvoiceOpen=false;
                                      //isInvoice=true;
                                    });*/
                                  }
                                },
                             //   child:Icon(Icons.cancel,size: 35,)
                                child: SvgPicture.asset("assets/bottomIcons/convert-invoice.svg",height: 40,width: 40,color: AppTheme.bgColor,)
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          setState(() {
                            isCompletedGoods=false;
                            index=1;
                          });
                          _controller.reverse();
                          goodsDataController.forward();
                          goodsAllController.reverse();

                          if(isInvoice){
                            gr.goodsGridList.forEach((element) {
                              Timer(Duration(milliseconds: 300), (){
                                if(element.status=="Not Yet"){
                                  setState(() {
                                    element.isAnimate=false;
                                  });
                                  element.controller!.reverse().then((value){

                                  });
                                }
                              });

                            });
                            setState(() {
                              isInvoiceOpen=false;
                              isInvoice=false;
                            });
                          }
                        },
                        child: Container(
                          height:isCompletedGoods||isInvoice? 70:0,
                          width: SizeConfig.screenWidth,
                          color: Colors.transparent,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //Add Button
              Align(
                alignment: Alignment.bottomCenter,
                child:GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){


                    setState(() {
                      isCompletedGoods=false;
                      index=1;
                    });
                    _controller.reverse();
                    goodsDataController.forward();
                    goodsAllController.reverse();


                    if(isInvoice){
                      gr.goodsGridList.forEach((element) {
                        Timer(Duration(milliseconds: 300), (){
                          if(element.status=="Not Yet"){
                            setState(() {
                              element.isAnimate=false;
                            });
                            element.controller!.reverse().then((value){

                            });
                          }
                        });

                      });
                      setState(() {
                        isInvoiceOpen=false;
                        isInvoice=false;
                      });
                    }

                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    height: 65,
                    width: 65,
                    margin: EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:isCompletedGoods||isInvoice?AppTheme.red.withOpacity(0.9): AppTheme.yellowColor,
                      boxShadow: [
                        BoxShadow(
                          color:isCompletedGoods||isInvoice?AppTheme.red.withOpacity(0.4): AppTheme.yellowColor.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(1, 8), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: RotationTransition(
                          turns: Tween(begin: 0.0, end: 0.125).animate(_controller),
                          child: SvgPicture.asset( "assets/svg/plusIcon.svg",height: 30,width: 30,
                            color: isCompletedGoods||isInvoice?Colors.white:AppTheme.indicatorColor,)
                      ),
                    ),
                  ),
                ),
              ),





              Container(
                height: SizeConfig.height55,
                width: SizeConfig.screenWidth,

                child: Row(
                  children: [
                    GestureDetector(
                      onTap:widget.drawerCallback,
                      child: NavBarIcon(),
                    ),
                    Text("Goods Received",
                      style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async{
                        final List<DateTime?>?  picked1 = await DateRagePicker.showDatePicker(
                            context: context,
                            initialFirstDate: new DateTime.now(),
                            initialLastDate: (new DateTime.now()),
                            firstDate: DateTime.parse('2000-01-01'),
                            lastDate: (new DateTime.now())
                        );
                        if (picked1 != null && picked1.length == 2) {
                          setState(() {
                            gr.picked=picked1;
                            gr.GetGoodsDbHit(context,null,null,false,this);
                          });
                        }
                        else if(picked1!=null && picked1.length ==1){
                          setState(() {
                            gr.picked=picked1;
                            gr.GetGoodsDbHit(context,null,null,false,this);
                          });
                        }

                      },
                      child: SvgPicture.asset("assets/svg/calender.svg",width: 27,height: 27,color: AppTheme.bgColor,
                        //    color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor:AppTheme.bgColor.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(width: 20,)
                  ],
                ),
              ),


              Container(

                height: gr.GoodsLoader? SizeConfig.screenHeight:0,
                width: gr.GoodsLoader? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                ),
              ),
            ],
          )
      ),
    );
  }
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GoodsMaterialsList(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteGoodsToInvoice() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GoodsToInvoice(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteOutGateForm() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GoodsOutGateForm(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteGoodsPlant() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GoodsPlantList(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(-1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
}

