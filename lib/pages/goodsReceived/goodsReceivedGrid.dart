
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/goodsReceived/goodsMaterialsList.dart';
import 'package:quarry/pages/goodsReceived/goodsOutGateForm.dart';
import 'package:quarry/pages/quarryMaster/plantDetailsAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';





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
          setState(() {
            isListScroll=true;
          });
        }
        else{
          if(isListScroll){
            print("ISCROLL");
            setState(() {
              isListScroll=false;
            });
          }

        }
/*        print("isListScroll$isListScroll");*/
      });

      listViewController.addListener(() {
        print(listViewController.position.userScrollDirection);
        if(listViewController.offset==0){
          scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        }
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



              Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: SizeConfig.height200,

                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/saleFormheader.jpg",),
                              fit: BoxFit.cover
                          )

                      ),
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
                          print("DFSfddsf");
                          int sensitivity = 5;

                          if (details.delta.dy > sensitivity) {
                            scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                          } else if(details.delta.dy < -sensitivity){
                            scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                          }
                        },
                        child: Container(
                          height: SizeConfig.screenHeight-60,
                          width: SizeConfig.screenWidth,
                          padding: EdgeInsets.only(top: 0,bottom: 80),
                          decoration: BoxDecoration(
                              color: AppTheme.gridbodyBgColor,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: NotificationListener<ScrollNotification>(
                              onNotification: (s){
                                if(s is ScrollStartNotification){
                                  print(listViewController.hasListeners);
                                  print(listViewController.position.userScrollDirection);
                              //    print(listViewController.position);
                                  if(listViewController.offset==0 && isListScroll && scrollController.offset==100 && listViewController.position.userScrollDirection==ScrollDirection.idle){
                                    print("0");
                                    Timer(Duration(milliseconds: 100), (){
                                      if(listViewController.position.userScrollDirection!=ScrollDirection.reverse){
                                        scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
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
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 200,
                                     // height: SizeConfig.screenWidth*0.5,
                                      width: SizeConfig.screenWidth*0.5,
                                      color: AppTheme.gridbodyBgColor,
                                      child: Center(
                                        child: Container(
                                          height: 160,
                                         // height: SizeConfig.screenWidth*0.4,
                                          width: SizeConfig.screenWidth*0.4,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                                                  spreadRadius: 2,
                                                  blurRadius: 15,
                                                  offset: Offset(0, 0), // changes position of shadow
                                                )
                                              ]
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
                                                style: TextStyle(fontFamily: 'RR',color: value.status=="Not Yet"? AppTheme.gridTextColor.withOpacity(0.6):AppTheme.red.withOpacity(0.6),fontSize: 14),
                                              ),
                                              SizedBox(height: 20,),
                                              GestureDetector(
                                                onTap: (){
                                                  gr.GoodsDropDownValues(context);
                                                  gr.GetGoodsDbHit(context, value.goodsReceivedId, value.purchaseOrderId);
                                                  Navigator.push(context, _createRoute());
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
                      Center(
                        heightFactor: 0.5,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){

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
                            Image.asset("assets/goodsIcons/invoice.jpg"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),




              Container(
                height: SizeConfig.height60,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.menu,color:AppTheme.bgColor,), onPressed: widget.drawerCallback),
                    SizedBox(width: SizeConfig.width5,),
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

