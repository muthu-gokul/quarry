
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/pages/dashboard/saleDashBoard/salesDashBoard.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/arrowBack.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/charts/highChart/high_chart.dart';
import 'package:quarry/widgets/circularProgress/circleProgressBar.dart';
import 'package:quarry/widgets/circularProgress/circularBar.dart';
import 'package:quarry/widgets/fittedText.dart';
import 'package:quarry/widgets/loader.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:quarry/widgets/waveIndicator/liquid_circular_progress_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;
class DieselDashBoard extends StatefulWidget {

  VoidCallback? drawerCallback;
  DieselDashBoard({this.drawerCallback});
  @override
  _DieselDashBoardState createState() => _DieselDashBoardState();
}

class _DieselDashBoardState extends State<DieselDashBoard> {
  late ScrollController silverController;
  double silverBodyTopMargin=0;
  List<DateTime?> picked=[];
  int selIndex=0;

  @override
  void initState() {
    Provider.of<DashboardNotifier>(context,listen: false).DashBoardDbHit(context,
        "Diesel",
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString(),
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString(),
        voidCallback: (){
          Timer(Duration(milliseconds: 500), (){
            setState(() {
              seriesList= Provider.of<DashboardNotifier>(context,listen: false).seriesList;
            });
          });
        }
    );
    WidgetsBinding.instance!.addPostFrameCallback((_){
      silverController=new ScrollController();

      setState(() {
        silverBodyTopMargin=0;
      });

      silverController.addListener(() {
        if(silverController.offset>250){
          setState(() {
            silverBodyTopMargin=50-(-(silverController.offset-300));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController.offset<270){
          setState(() {
            silverBodyTopMargin=0;
          });
        }
      });
    });
    super.initState();
  }

  List<charts.Series> seriesList=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Consumer<DashboardNotifier>(
        builder:(ctx,db,c)=> Stack(
          children: [
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              clipBehavior: Clip.antiAlias,
              // margin: EdgeInsets.only(top: silverBodyTopMargin),
              padding: EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                //  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                color: AppTheme.gridbodyBgColor,
              ),
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: SizeConfig.screenWidth,
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CancelButton(
                            bgColor: AppTheme.bgColor,
                            iconColor: Colors.white,
                            ontap: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Diesel Management",style: TextStyle(fontSize: 18,fontFamily: 'RR',),),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                              onTap: () async{
                                final List<DateTime?>?  picked1 = await DateRagePicker.showDatePicker(
                                    context: context,
                                    initialFirstDate: new DateTime.now(),
                                    initialLastDate: (new DateTime.now()),
                                    firstDate: db.dateTime,
                                    lastDate: (new DateTime.now())
                                );
                                if (picked1 != null && picked1.length == 2) {
                                  setState(() {
                                    picked=picked1;
                                    selIndex=0;
                                  });
                                  db.DashBoardDbHit(context,
                                      "Diesel",
                                      DateFormat("yyyy-MM-dd").format(picked[0]!).toString(),
                                      DateFormat("yyyy-MM-dd").format(picked[1]!).toString(),
                                      voidCallback: (){
                                        Timer(Duration(milliseconds: 500), (){
                                          setState(() {
                                            seriesList= db.seriesList;
                                          });
                                        });
                                      }
                                  );
                                }
                                else if(picked1!=null && picked1.length ==1){
                                  setState(() {
                                    picked=picked1;
                                    selIndex=0;
                                  });
                                  db.DashBoardDbHit(context,
                                      "Diesel",
                                      DateFormat("yyyy-MM-dd").format(picked[0]!).toString(),
                                      DateFormat("yyyy-MM-dd").format(picked[0]!).toString(),
                                    voidCallback: (){
                                      Timer(Duration(milliseconds: 500), (){
                                        setState(() {
                                          seriesList= db.seriesList;
                                        });
                                      });
                                    }
                                  );
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: SvgPicture.asset("assets/svg/calender.svg",width: 25,height: 25,color: AppTheme.bgColor,),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 40,
                      width: 200,
                      decoration:BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Color(0xFFd7d7d7))
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Text(picked.length==1?"${DateFormat("dd/MM/yyyy").format(picked[0]!)}":
                      picked.length==2?"${DateFormat("dd/MM/yyyy").format(picked[0]!)} - ${DateFormat("dd/MM/yyyy").format(picked[1]!)}":"Today",
                        style: TextStyle(color:AppTheme.yellowColor,fontFamily: 'RM',fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: SizeConfig.screenWidth,
                    height: 235,
                   // color: Colors.red,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height:220,
                            width: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                /*BoxShadow(
                                  color: AppTheme.yellowColor.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(1, 13), // changes position of shadow
                                )*/
                              ]
                            ),
                            child: Stack(
                              children: [

                               /* Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height:180,
                                   child: charts.PieChart(
                                       db.seriesList,
                                       animate: true,
                                       defaultRenderer: new charts.ArcRendererConfig(
                                           arcWidth: 30, startAngle: 4 / 5 * pi, arcLength: 7 / 5 * pi)
                                   ),
                                   */
                                /* child: Transform.rotate(
                                      angle: 110,
                                      child: CircleProgressBar(
                                        extraStrokeWidth: 10,
                                        innerStrokeWidth: 10,
                                        backgroundColor: Color(0xFFd7d7d7),
                                        foregroundColor: AppTheme.yellowColor,
                                        value: (db.totalDiesel['TotalQuantity']??0.0)/5000.0,
                                      ),
                                    ),*//*
                                  ),
                                ),*/
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height:144,
                                    width: 144,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.yellowColor.withOpacity(0.4),
                                            spreadRadius: 1,
                                            blurRadius: 20,
                                            offset: Offset(5, 10), // changes position of shadow
                                          )
                                        ]
                                    ),
                                    child: LiquidCircularProgressIndicator(
                                      value:db.low,
                                      backgroundColor: Colors.white,
                                      valueColor: AlwaysStoppedAnimation(Color(0xFFF3C253).withOpacity(0.5)),
                                      borderColor: Colors.transparent,
                                      borderWidth: 0.0,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height:144,
                                    width: 144,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white
                                    ),
                                    child: LiquidCircularProgressIndicator(
                                      value:db.low,
                                      backgroundColor: Colors.transparent,
                                      valueColor: AlwaysStoppedAnimation(Color(0xFFF3C253)),
                                      borderColor: Colors.transparent,
                                      borderWidth: 0.0,
                                      center: Text("${db.totalDiesel['TotalQuantity']??0.0} Ltr", style:  TextStyle(fontSize: 18,color: Color(0xFF676767),fontFamily: 'RM'),
                                      ),
                                    ),
                                  ),
                                ),
                              /*  Align(
                                  alignment: Alignment.center,
                                  child:Container(
                                    height:220,
                                    child: charts.PieChart(
                                        seriesList,
                                        animate: true,
                                        defaultRenderer: new charts.ArcRendererConfig(
                                            arcWidth: 20, startAngle: 4 / 5 * pi, arcLength: 7 / 5 * pi)
                                    ),
                                  ),
                                ),*/
                              ],
                            )
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Container(
                                height:100,
                                width: 100,
                                child: Stack(
                                  children: [
                                    LiquidCircularProgressIndicator(
                                      value: (db.issueDiesel['IssuePercentage']??0)/100,
                                      backgroundColor: Colors.white,
                                      valueColor: AlwaysStoppedAnimation(AppTheme.yellowColor.withOpacity(0.5)),
                                      borderColor: Color(0xffe4e4e4),
                                      borderWidth: 1.0,
                                    ),
                                    LiquidCircularProgressIndicator(
                                      value: (db.issueDiesel['IssuePercentage']??0)/100,
                                      backgroundColor: Colors.transparent,
                                      valueColor: AlwaysStoppedAnimation(AppTheme.yellowColor),
                                      borderColor: Color(0xffe4e4e4),
                                      borderWidth: 1.0,
                                     center: FittedText(
                                       height: 16,
                                       width: 95,
                                       text: "${db.issueDiesel['IssuePercentage']??0.0}%",
                                       alignment: Alignment.center,
                                       textStyle: TextStyle(fontSize: 14,color: Color(0xFF676767),fontFamily: 'RM'),
                                     ),
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(height: 10,),
                            Text("Diesel Issue",style: TextStyle(fontFamily: 'RM',fontSize: 14,color: Color(0xFF78787A)),),
                            SizedBox(height: 5,),
                            Text("${db.issueDiesel['TotalQuantity']??0.0} Ltr",style: TextStyle(fontFamily: 'RR',fontSize: 12,color: Color(0xFF78787A)),),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                                height:100,
                                width: 100,
                                child: LiquidCircularProgressIndicator(
                                  value: (db.balanceDiesel['BalancePercentage']??0)/100,
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation(AppTheme.yellowColor),
                                  borderColor: Color(0xffe4e4e4),
                                  borderWidth: 1.0,
                                  center: FittedText(
                                    height: 16,
                                    width: 95,
                                    text: "${db.balanceDiesel['BalancePercentage']??0.0}%",
                                    alignment: Alignment.center,
                                    textStyle: TextStyle(fontSize: 14,color: Color(0xFF676767),fontFamily: 'RM'),
                                  ),
                                )
                            ),
                            SizedBox(height: 10,),
                            Text("Balance Diesel",style: TextStyle(fontFamily: 'RM',fontSize: 14,color: Color(0xFF78787A)),),
                            SizedBox(height: 5,),
                            Text("${db.balanceDiesel['BalanceQuantity']??0.0} Ltr",style: TextStyle(fontFamily: 'RR',fontSize: 12,color: Color(0xFF78787A)),),
                          ],
                        ),
                      ],
                    ),
                  ),



                ],
              ),
            ),


            Loader(
              isLoad: db.isLoad,
            )
          ],
        ),
      ),
    );
  }

}
