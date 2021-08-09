

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/pages/dashboard/saleDashBoard/salesDashBoard.dart';
import 'package:quarry/pages/dashboard/saleDashBoard/salesMatertial.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/animation/animePageRoutes.dart';
import 'package:quarry/widgets/arrowBack.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/charts/highChart/high_chart.dart';
import 'package:quarry/widgets/fittedText.dart';
import 'package:quarry/widgets/linearProgressBar.dart';
import 'package:quarry/widgets/loader.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;

class SalesDashBoard extends StatefulWidget {

  VoidCallback drawerCallback;
  SalesDashBoard({this.drawerCallback});
  @override
  _SalesDashBoardState createState() => _SalesDashBoardState();
}

class _SalesDashBoardState extends State<SalesDashBoard> {
  ScrollController silverController;
  double silverBodyTopMargin=0;

  int selIndex=-1;

  @override
  void initState() {
    Provider.of<DashboardNotifier>(context,listen: false).DashBoardDbHit(context,
        "Sale",
        DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 6))).toString(),
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
    );
    WidgetsBinding.instance.addPostFrameCallback((_){
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
List<DateTime> picked=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
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
                    backgroundColor: Color(0XFF353535),
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
                            Text("Sales DashBoard",style: AppTheme.TSWhite166,),
                            Spacer(),
                            GestureDetector(
                              onTap: () async{
                                final List<DateTime>  picked1 = await DateRagePicker.showDatePicker(
                                    context: context,
                                    initialFirstDate: new DateTime.now(),
                                    initialLastDate: (new DateTime.now()),
                                    firstDate: db.dateTime,
                                    lastDate: (new DateTime.now())
                                );
                                if (picked1 != null && picked1.length == 2) {
                                  setState(() {
                                    picked=picked1;
                                  });
                                  db.DashBoardDbHit(context,
                                      "Sale",
                                      DateFormat("yyyy-MM-dd").format(picked[0]).toString(),
                                      DateFormat("yyyy-MM-dd").format(picked[1]).toString()
                                  );
                                }
                                else if(picked1!=null && picked1.length ==1){
                                  setState(() {
                                    picked=picked1;
                                  });
                                  db.DashBoardDbHit(context,
                                      "Sale",
                                      DateFormat("yyyy-MM-dd").format(picked[0]).toString(),
                                      DateFormat("yyyy-MM-dd").format(picked[0]).toString()
                                  );
                                }
                             },
                            child: SvgPicture.asset("assets/svg/calender.svg",width: 25,height: 25,color: AppTheme.dashCalendar,)
                          ),
                          SizedBox(width: 20,)
                          ],
                        ),
                      ),
                    ],
                    expandedHeight: 300.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          width: SizeConfig.screenWidth,
                          margin:EdgeInsets.only(top: 55),
                          child: HighCharts(
                            data: db.salesApex,
                            isHighChart: false,
                            isLoad: db.isChartLoad,
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
                  color: Color(0xFFF6F7F9),
                ),
                child: ListView.builder(
                  itemCount: db.saleT2.length,
                  itemBuilder: (ctx,i){
                    return Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, rightLeftRoute(SalesMaterial(
                            materialName: db.saleT2[i]['MaterialName'],
                            materialPrice: db.saleT2[i]['TotalSale'],
                            materialQty: db.saleT2[i]['TotalQuantity'],
                            materialUnit: db.saleT2[i]['UnitName'],
                            weekList: db.saleMaterialWeeklyT3.where((element) => element['MaterialId']==db.saleT2[i]['MaterialId']).toList(),
                            monthList: db.saleMaterialMonthlyT4.where((element) => element['MaterialId']==db.saleT2[i]['MaterialId']).toList(),
                            yearList: db.saleMaterialYearT5.where((element) => element['MaterialId']==db.saleT2[i]['MaterialId']).toList(),
                          )));
                        },
                        child: Container(
                          height: 65,
                          width: SizeConfig.screenWidth*0.95,
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.only(left: 10,right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(1, 8), // changes position of shadow
                              )
                            ]
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.yellowColor
                                ),
                                alignment: Alignment.center,
                                child: Image.asset("assets/bottomIcons/add-material.png",height: 25,),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:(SizeConfig.screenWidth*0.95)-80,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("${db.saleT2[i]['MaterialName']} / ",style: TextStyle(fontFamily: 'RR',color: Color(0xFFBDBCBD),fontSize: 14),),
                                        Text("${formatCurrency.format(db.saleT2[i]['TotalSale']??0.0)}",style: TextStyle(fontFamily: 'RM',color: Color(0xFF999999),fontSize: 14),),
                                        Text("  ${db.saleT2[i]['TotalQuantity']} ${db.saleT2[i]['UnitName']}",style: TextStyle(fontFamily: 'RR',color: Color(0xFF999999),fontSize: 10),),
                                        Spacer(),
                                        FittedText(
                                          height: 18,
                                          width: 50,
                                          text: "${db.saleT2[i]['SalePercentage']} %",
                                          alignment: Alignment.bottomRight,
                                          textStyle: TextStyle(fontFamily: 'RR',color: Color(0xFF999999),fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  LinearPercentIndicator(
                                    width:(SizeConfig.screenWidth*0.95)-80,
                                    animation: true,
                                    lineHeight: 8.0,
                                    animationDuration: 1000,
                                    percent: (db.saleT2[i]['SalePercentage'])/100.0,
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                   padding: EdgeInsets.only(left: 0),
                                   // progressColor: AppTheme.yellowColor,
                                    backgroundColor: Color(0xFFEAEAEA),
                                    linearGradient: LinearGradient(colors: [Color(0xFFF9E6AA),AppTheme.yellowColor,],),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),


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


