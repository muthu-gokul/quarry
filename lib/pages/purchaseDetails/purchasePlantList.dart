
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/manageUsersNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/notifier/purchaseNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/references/bottomNavi.dart';

import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';







class PurchasePlantList extends StatefulWidget {
  VoidCallback? drawerCallback;
  PurchasePlantList({this.drawerCallback});
  @override
  PurchasePlantListState createState() => PurchasePlantListState();
}

class PurchasePlantListState extends State<PurchasePlantList> with TickerProviderStateMixin{




  ScrollController? scrollController;
  ScrollController? listViewController;
  bool isListScroll=false;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


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
      body: Consumer<PurchaseNotifier>(
          builder: (context,pn,child)=> Stack(
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
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
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
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (s){
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
                            child: ListView(
                              controller: listViewController,
                              scrollDirection: Axis.vertical,
                              physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                              children: [

                                SizedBox(height: 20,),
                                Align(
                                    alignment: Alignment.center,
                                    child: Text("Select Plant",style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16),)),



                                SingleChildScrollView(
                                  child: Wrap(
                                      children: pn.filterUsersPlantList.asMap()
                                          .map((i, value) => MapEntry(i,
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              value.isActive=!value.isActive!;
                                            });
                                          },
                                          child: Container(
                                            height: 200,
                                            width: SizeConfig.screenWidth!*0.5,
                                            color: Colors.white,
                                            child: AnimatedOpacity(
                                              duration: Duration(milliseconds: 300),
                                              curve: Curves.easeIn,
                                              opacity: value.isActive!?1:0.3,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 50,),
                                                  Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: AppTheme.uploadColor,width: 2)
                                                    ),
                                                    child: Center(
                                                      child: SvgPicture.asset("assets/svg/Planticon.svg",height: 40,width: 40,),
                                                    ),
                                                  ),

                                                  SizedBox(height: 20,),
                                                  Text("${value.plantName}  ",
                                                    style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RM',fontSize: 14),
                                                  ),
                                                  SizedBox(height: 3,),
                                                  /*Text("${value.}  ",
                                                  style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RR',fontSize: 12),
                                                ),*/
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                      )
                                      ).values.toList()
                                  ),
                                )


                              ],
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
                  height:65,

                  decoration: BoxDecoration(
                      color: AppTheme.gridbodyBgColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.gridbodyBgColor.withOpacity(0.7),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: Offset(0, -20), // changes position of shadow
                        )
                      ]
                  ),
                  child: Stack(

                    children: [
                      Container(
                        margin:EdgeInsets.only(top: 0),
                        child: CustomPaint(
                          size: Size( SizeConfig.screenWidth!, 65),
                          painter: RPSCustomPainter3(),
                        ),
                      ),
                      Center(
                        heightFactor: 0.5,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            Navigator.pop(context);
                            pn.filterPurchaseGrid();
                          },
                          child: Container(

                            height: 65,
                            width: 65,
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
                              child: SvgPicture.asset("assets/svg/tick.svg",height: 30,width:30,color: AppTheme.bgColor,),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width:  SizeConfig.screenWidth,
                        height: 80,

                        child: Stack(

                          children: [


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
                    CancelButton(
                      ontap: (){
                        pn.filterPurchaseGrid();
                        Navigator.pop(context);
                      },
                    ),
                    Text("Plant List",
                      style: TextStyle(fontFamily: 'RR',color:AppTheme.bgColor,fontSize: 16),
                    ),

                  ],
                ),
              ),


            ],
          )
      ),
    );
  }

}

