

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/pages/dashboard/saleDashBoard/salesDashBoard.dart';
import 'package:quarry/pages/dashboard/saleDashBoard/salesMatertial.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/animation/animePageRoutes.dart';
import 'package:quarry/widgets/arrowBack.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/charts/highChart/high_chart.dart';
import 'package:quarry/widgets/fittedText.dart';
import 'package:quarry/widgets/linearProgressBar.dart';
import 'package:quarry/widgets/loader.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../notifier/planNotifier.dart';

class PlanPlantList extends StatefulWidget {

  VoidCallback? drawerCallback;
  PlanPlantList({this.drawerCallback});
  @override
  _PlanPlantListState createState() => _PlanPlantListState();
}

class _PlanPlantListState extends State<PlanPlantList> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;


  final PlanNotifier planNotifier = Get.put(PlanNotifier());
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){
      silverController=new ScrollController();

      setState(() {
        silverBodyTopMargin=0;
      });

      silverController!.addListener(() {
        if(silverController!.offset>150){
          setState(() {
            silverBodyTopMargin=50-(-(silverController!.offset-200));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController!.offset<170){
          setState(() {
            silverBodyTopMargin=0;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.yellowColor,
      body: Consumer<DashboardNotifier>(
        builder:(ctx,db,c)=> Stack(
          children: [
            NestedScrollView(
              controller: silverController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    elevation: 0,
                    toolbarHeight: 50,
                    backgroundColor: AppTheme.yellowColor,
                    leading: Container(),
                    actions: [
                      Container(
                        height: 50,
                        width:SizeConfig.screenWidth,
                        child: Row(
                          children: [
                            CancelButton(
                              ontap: (){
                                Navigator.pop(context);
                              },
                            ),
                            Text("Select Plant",style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16)),

                          ],
                        ),
                      ),
                    ],
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          height: 200,
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/saleFormheader.jpg",),
                                  fit: BoxFit.cover
                              )
                          ),
                        )
                    ),
                  ),
                ];
              },
              body: Container(
                width: SizeConfig.screenWidth,
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(top: silverBodyTopMargin),
                padding: EdgeInsets.only(top: 30,bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  //color: Color(0xFFF6F7F9),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                      children: planNotifier.plantList.asMap()
                          .map((i, value) => MapEntry(i,
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              planNotifier.selectPlantId.value=value['Id'].toString();
                              planNotifier.selectPlantName.value=value['Text'];
                            });
                            planNotifier.getActivationDetail();
                            Get.back();
                          },
                          child: Container(
                            height: 200,
                            width: SizeConfig.screenWidth!*0.5,
                            color: Colors.white,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                              opacity: planNotifier.selectPlantId==value['Id'].toString()?1:0.3,
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
                                  Text("${value['Text']}  ",
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
                ),
              ),
            ),




          ],
        ),
      ),
    );
  }
}





class PlanDrpList extends StatefulWidget {
  @override
  _PlanDrpListState createState() => _PlanDrpListState();
}

class _PlanDrpListState extends State<PlanDrpList> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;


  final PlanNotifier planNotifier = Get.put(PlanNotifier());
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){
      silverController=new ScrollController();

      setState(() {
        silverBodyTopMargin=0;
      });

      silverController!.addListener(() {
        if(silverController!.offset>150){
          setState(() {
            silverBodyTopMargin=50-(-(silverController!.offset-200));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController!.offset<170){
          setState(() {
            silverBodyTopMargin=0;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.yellowColor,
      body: Consumer<DashboardNotifier>(
        builder:(ctx,db,c)=> Stack(
          children: [
            NestedScrollView(
              controller: silverController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    elevation: 0,
                    toolbarHeight: 50,
                    backgroundColor: AppTheme.yellowColor,
                    leading: Container(),
                    actions: [
                      Container(
                        height: 50,
                        width:SizeConfig.screenWidth,
                        child: Row(
                          children: [
                            CancelButton(
                              ontap: (){
                                Navigator.pop(context);
                              },
                            ),
                            Text("Select Plan",style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16)),

                          ],
                        ),
                      ),
                    ],
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          height: 200,
                          width: SizeConfig.screenWidth,

                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/saleFormheader.jpg",),
                                  fit: BoxFit.cover
                              )
                          ),
                        )
                    ),
                  ),
                ];
              },
              body: Container(
                width: SizeConfig.screenWidth,
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(top: silverBodyTopMargin),
                padding: EdgeInsets.only(top: 30,bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  //color: Color(0xFFF6F7F9),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                      children: planNotifier.planList.asMap()
                          .map((i, value) => MapEntry(i,
                        GestureDetector(
                          onTap: (){
                            // setState(() {
                            //   planNotifier.planId.value=value['Id'].toString();
                            //   planNotifier.planName.value=value['Text'];
                            //   planNotifier.noOfDays.value=value['NumberOfDays'].toString();
                            // });
                            CustomAlert(
                              Cancelcallback: (){
                                Get.back();
                              },
                              callback: (){
                                planNotifier.insertPlan(null, value['Id'], value['NumberOfDays'],"Plan Changed Successfully");
                                Get.close(2);

                              }
                            ).confirmDialog("Are you sure want to change the plan ?",);
                          },
                          child: Container(
                            height: 150,
                            width: SizeConfig.screenWidth!*0.5,
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                              opacity: 1,
                              child: Container(
                                padding: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Color(0xffE2E2E2)),
                                  color: Color(0xffF9F9F9)
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Text("${value['Text']}",
                                      style: TextStyle(color: Color(0xff9f9f9f),fontFamily: 'RM',fontSize: 16),
                                    ),
                                    SizedBox(height: 5,),
                                    Text("${value['NumberOfDays']} days",
                                      style: TextStyle(color: Color(0xff9f9f9f),fontFamily: 'RM',fontSize: 20),
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




          ],
        ),
      ),
    );
  }
}


