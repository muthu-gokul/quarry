
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/goodsReceived/goodsMaterialsList.dart';
import 'package:quarry/pages/goodsReceived/goodsOutGateForm.dart';
import 'package:quarry/pages/goodsReceived/goodsToInvoice.dart';
import 'package:quarry/pages/quarryMaster/plantDetailsAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';

import '../../styles/size.dart';





class GoodsReceivedGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  GoodsReceivedGrid({this.drawerCallback});
  @override
  GoodsReceivedGridState createState() => GoodsReceivedGridState();
}

class GoodsReceivedGridState extends State<GoodsReceivedGrid> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;

  bool isListScroll=false;

  bool isInvoiceOpen=false;
  bool isInvoice=false;

  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });
      scrollController.addListener(() {

        if(scrollController.offset==100){
    /*      setState(() {
            isListScroll=true;
          });*/
        }
        else{
          /*if(isListScroll){
            print("ISCROLL");
            setState(() {
              isListScroll=false;
            });
          }*/

        }
/*        print("isListScroll$isListScroll");*/
      });

      listViewController.addListener(() {
       // print(listViewController.position.userScrollDirection);
        /*f(listViewController.offset==0){

          scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value) {
            if(isListScroll){
              print("ISCROLL");
              setState(() {
                isListScroll=false;
              });
            }
          });
        }*/


        /*if(listViewController.offset>20){
          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
        else if(listViewController.offset==0){
          scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }*/
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
                            scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                              if(isListScroll){
                                setState(() {
                                  isListScroll=false;
                                });
                              }
                            });

                          } else if(details.delta.dy < -sensitivity){
                            scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

                              if(!isListScroll){
                                setState(() {
                                  isListScroll=true;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          height: SizeConfig.screenHeight-60,
                          width: SizeConfig.screenWidth,
                          padding: EdgeInsets.only(top: 0,bottom: 80),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: AppTheme.gridbodyBgColor,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: NotificationListener<ScrollNotification>(
                              onNotification: (s){
                                if(s is ScrollStartNotification){

                                  if(listViewController.offset==0 && isListScroll && scrollController.offset==100 && listViewController.position.userScrollDirection==ScrollDirection.idle){
                                    Timer(Duration(milliseconds: 100), (){
                                      if(listViewController.position.userScrollDirection!=ScrollDirection.reverse){
                                        if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
                                          scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value) {
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
                              },
                            child: SingleChildScrollView(
                              physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                              controller: listViewController,
                              child: Wrap(
                                  children: gr.goodsGridList.asMap()
                                      .map((i, value) => MapEntry(i,
                                  GestureDetector(
                                    onTap: (){
                                    //  Navigator.push(context, _createRoute());
                                   /*   gr.GetplantDetailDbhit(context, gr.plantGridList[i].plantId);*/

                                    },
                                    child: ScaleTransition(
                                      scale: Tween(begin: 1.0, end: 0.0)
                                          .animate(new CurvedAnimation(parent: value.controller, curve: Curves.easeInOutBack)),
                                      child: AnimatedOpacity(
                                       // opacity: value.isAnimate?0:1,
                                        opacity: 1,

                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeIn,
                                        child:Container(
                                        //  duration: Duration(milliseconds: 200),
                                        //  curve: Curves.easeIn,
                                         height: value.isAnimate?0: 200,
                                         width:value.isAnimate?0: SizeConfig.screenWidth*0.5,
                                          /*height: value.isAnimate?0:200,
                                          width:  value.isAnimate?0: SizeConfig.screenWidth*0.5,
                                          transform: Matrix4.translationValues(value.isAnimate?SizeConfig.screenWidth*0.25:0, value.isAnimate?100:0, 0),*/
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Container(
                                            //  margin: EdgeInsets.only(top: 10),
                                              height: 200,
                                             // height: SizeConfig.screenWidth*0.5,
                                              width: SizeConfig.screenWidth*0.5,

                                              decoration: BoxDecoration(
                                                //  borderRadius: BorderRadius.circular(10),
                                                color: AppTheme.gridbodyBgColor,
                                              ),
                                              child: Center(
                                                child: Container(
                                                  height: 160,
                                                 // height: SizeConfig.screenWidth*0.4,
                                                  width: SizeConfig.screenWidth*0.4,
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
                                                      Text("${value.purchaseOrderNumber}",
                                                      style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16),
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
                                                            gr.GoodsDropDownValues(context);
                                                            gr.GetGoodsDbHit(context, value.goodsReceivedId, value.purchaseOrderId,true,GoodsReceivedGridState());
                                                            Navigator.push(context, _createRouteGoodsToInvoice());

                                                            gr.goodsGridList.forEach((element) {
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
                                                              isInvoice=false;
                                                            });

                                                           /* int i=0;
                                                            if(mounted){
                                                              Timer.periodic(Duration(milliseconds: 150),(v){
                                                                print(i);
                                                                if(gr.goodsGridList[i].status=="Not Yet"){
                                                                  if(mounted){
                                                                    setState(() {
                                                                      gr.goodsGridList[i].isAnimate=!gr.goodsGridList[i].isAnimate;
                                                                    });
                                                                  }

                                                                }
                                                                i=i+1;
                                                                if(i==gr.goodsGridList.length){
                                                                  v.cancel();
                                                                  if(mounted){
                                                                    setState(() {
                                                                      isInvoiceOpen=false;
                                                                      isInvoice=false;
                                                                    });
                                                                  }

                                                                }

                                                              });
                                                            }*/

                                                            }
                                                          }
                                                          else{
                                                            gr.GoodsDropDownValues(context);
                                                            gr.GetGoodsDbHit(context, value.goodsReceivedId, value.purchaseOrderId,false,GoodsReceivedGridState());
                                                            Navigator.push(context, _createRoute());
                                                          }

                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: SizeConfig.screenWidth*0.3,
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
                          ),
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
                          size: Size( SizeConfig.screenWidth, 65),
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
                            Image.asset("assets/goodsIcons/plant.jpg"),
                            Image.asset("assets/goodsIcons/cart.jpg"),

                            SizedBox(width: SizeConfig.width50,),
                            GestureDetector(
                                onTap: (){
                                  gr.clearOGFform();
                                  gr.GoodsDropDownValues(context);
                                  Navigator.push(context, _createRouteOutGateForm());

                                },
                                child: Image.asset("assets/goodsIcons/outGate.jpg")
                            ),
                            GestureDetector(
                                onTap:isInvoiceOpen?null: (){
                                  print(isInvoiceOpen);
                                  print(isInvoice);

                                  setState(() {
                                    isInvoiceOpen=true;
                                    isInvoice=!isInvoice;
                                  });





                                  if(isInvoice){



                                    gr.goodsGridList.forEach((element) {

                                     Timer(Duration(milliseconds: 300), (){
                                       if(element.status=="Not Yet"){
                                         element.controller.forward().then((value){
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
                                    gr.goodsGridList.forEach((element) {
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
                                    });
                                  }




                                  /*int i=0;
                                  if(mounted){
                                    Timer.periodic(Duration(milliseconds: 200),(v){
                                      print(i);
                                      if(gr.goodsGridList[i].status=="Not Yet"){
                                        if(mounted){
                                          gr.goodsGridList[i].controller.forward().then((value) {
                                            setState(() {
                                              gr.goodsGridList[i].isAnimate=true;
                                              i=i+1;
                                            });
                                          });

                                        }

                                      }
                                      else{
                                        i=i+1;
                                      }

                                      if(i==gr.goodsGridList.length){
                                        v.cancel();
                                        if(mounted){
                                          setState(() {
                                            isInvoiceOpen=false;
                                          });
                                        }

                                      }

                                    });*/



                                },
                             //   child:Icon(Icons.cancel,size: 35,)
                                child:isInvoice? Icon(Icons.cancel,size: 35,) :Image.asset("assets/goodsIcons/invoice.jpg")
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //Add Button
              Align(
                alignment: Alignment.bottomCenter,
                child: AddButton(
                  image: "assets/svg/plusIcon.svg",
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
}

