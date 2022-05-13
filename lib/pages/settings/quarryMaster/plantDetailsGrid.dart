
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/settings/quarryMaster/plantDetailsAddNew.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';

import '../../../styles/constants.dart';
import '../../../widgets/alertDialog.dart';





class PlantDetailsGrid extends StatefulWidget {
  VoidCallback? drawerCallback;
  PlantDetailsGrid({this.drawerCallback});
  @override
  PlantDetailsGridState createState() => PlantDetailsGridState();
}

class PlantDetailsGridState extends State<PlantDetailsGrid> with TickerProviderStateMixin{

  bool isEdit=false;
  bool isListScroll=false;


  ScrollController? scrollController;
  ScrollController? listViewController;



  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance!.addPostFrameCallback((_){


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
      body: Consumer<QuarryNotifier>(
          builder: (context,qn,child)=> Stack(
            children: [



              Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      height:200,

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

                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child:  NotificationListener<ScrollNotification>(
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
                            child: ListView(
                              controller: listViewController,
                              scrollDirection: Axis.vertical,
                              physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),

                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: SizeConfig.screenWidth!*0.5,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                                        ),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: (){
                                              if(userAccessMap[13]??false){
                                                qn.PlantDropDownValues(context);
                                                qn.clearPlantLicenseForm();
                                                qn.updatePlantDetailEdit(false);
                                                Navigator.push(context, _createRoute());
                                              }
                                              else{
                                                CustomAlert().accessDenied(context);
                                              }


                                            },
                                            child: Container(
                                              height: 80,
                                              width: 80,
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
                                                ]
                                              ),
                                              child: Center(
                                                child: SvgPicture.asset("assets/svg/plusIcon.svg",height: 35,width: 35,color: AppTheme.addNewTextFieldFocusBorder,),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      qn.plantGridList.isNotEmpty? GestureDetector(
                                        onTap: (){

                                          if(userAccessMap[14]??false){
                                            qn.PlantDropDownValues(context);
                                            qn.updatePlantDetailEdit(true);
                                            Navigator.push(context, _createRoute());
                                            qn.GetplantDetailDbhit(context, qn.plantGridList[0].plantId,this);
                                          }
                                          else{
                                            CustomAlert().accessDenied(context);
                                          }

                                        },
                                        onLongPress: (){

                                          if(userAccessMap[15]??false){
                                            CustomAlert(
                                                callback: (){
                                                  qn.deleteById(qn.plantGridList[0].plantId!);
                                                  Navigator.pop(context);
                                                },
                                                Cancelcallback: (){
                                                  Navigator.pop(context);
                                                }
                                            ).yesOrNoDialog(context, "", "Are you sure want to delete this Plant ?");
                                          }
                                          else{
                                            CustomAlert().accessDenied2();
                                          }
                                        },
                                        child: Container(
                                          height: 200,
                                          width: SizeConfig.screenWidth!*0.5,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(10))
                                          ),
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
                                              Text("${qn.plantGridList[0].plantName}  ",
                                              style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RM',fontSize: 14),
                                              ),
                                              SizedBox(height: 3,),
                                              Text("${qn.plantGridList[0].location}  ",
                                                style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RR',fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ):Container(
                                        height: 200,
                                        width: SizeConfig.screenWidth!*0.5,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),



                                SingleChildScrollView(
                                  child: Wrap(
                                      children: qn.plantGridList.asMap()
                                          .map((i, value) => MapEntry(i,    i==0?Container():
                                      GestureDetector(
                                        onTap: (){


                                        },
                                        child: Container(
                                          height: 200,
                                          width: SizeConfig.screenWidth!*0.5,
                                          color: Colors.white,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 50,),
                                              GestureDetector(
                                                onTap: (){
                                                  if(userAccessMap[14]??false){
                                                    qn.PlantDropDownValues(context);
                                                    qn.updatePlantDetailEdit(true);
                                                    qn.GetplantDetailDbhit(context, qn.plantGridList[i].plantId,this);
                                                    Navigator.push(context, _createRoute());
                                                  }
                                                  else{
                                                    CustomAlert().accessDenied(context);
                                                  }

                                                },
                                                onLongPress: (){

                                                  if(userAccessMap[15]??false){
                                                    CustomAlert(
                                                        callback: (){
                                                          qn.deleteById(qn.plantGridList[i].plantId!);
                                                          Navigator.pop(context);
                                                        },
                                                        Cancelcallback: (){
                                                          Navigator.pop(context);
                                                        }
                                                    ).yesOrNoDialog(context, "", "Are you sure want to delete this Plant ?");
                                                  }
                                                  else{
                                                    CustomAlert().accessDenied2();
                                                  }
                                                },
                                                child: Container(
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
                                              ),

                                              SizedBox(height: 20,),
                                              Text("${qn.plantGridList[i].plantName}  ",
                                                style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RM',fontSize: 14),
                                              ),
                                              SizedBox(height: 3,),
                                              Text("${qn.plantGridList[i].location}  ",
                                                style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RR',fontSize: 12),
                                              ),
                                            ],
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
              Container(
                height: SizeConfig.height60,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    CancelButton(
                      ontap: (){
                        Navigator.pop(context);
                      },
                    ),

                    Text("Our Plants",
                      style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                    ),

                  ],
                ),
              ),


              Container(

                height: qn.insertCompanyLoader? SizeConfig.screenHeight:0,
                width: qn.insertCompanyLoader? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                  //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

                ),
              ),
            ],
          )
      ),
    );
  }
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PlantDetailsAddNew(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}

