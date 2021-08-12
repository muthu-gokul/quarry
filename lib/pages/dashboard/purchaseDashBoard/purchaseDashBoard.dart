
import 'dart:async';

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
import 'package:quarry/widgets/fittedText.dart';
import 'package:quarry/widgets/loader.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;

class PurchaseDashBoard extends StatefulWidget {

  VoidCallback? drawerCallback;
  PurchaseDashBoard({this.drawerCallback});
  @override
  _PurchaseDashBoardState createState() => _PurchaseDashBoardState();
}

class _PurchaseDashBoardState extends State<PurchaseDashBoard> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;
  List<DateTime?> picked=[];
  int selIndex=-1;

  @override
  void initState() {
    Provider.of<DashboardNotifier>(context,listen: false).DashBoardDbHit(context,
        "Purchase",
        DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 90))).toString(),
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
    );
    WidgetsBinding.instance!.addPostFrameCallback((_){
      silverController=new ScrollController();

      setState(() {
        silverBodyTopMargin=0;
      });

      silverController!.addListener(() {
        if(silverController!.offset>250){
          setState(() {
            silverBodyTopMargin=50-(-(silverController!.offset-300));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController!.offset<270){
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

                            Container(
                              height: 40,
                              width: SizeConfig.screenWidth!*0.57,
                              padding:EdgeInsets.only(left: 10,right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppTheme.yellowColor
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Column(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Text("Purchase & \nReceived",style: TextStyle(fontFamily: 'RM',fontSize: 10,color: AppTheme.bgColor),),
                                     // SizedBox(height: 2,),
                                     // Text("    All Product Sale",style: TextStyle(fontFamily: 'RR',fontSize: 10,color: AppTheme.bgColor),),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    crossAxisAlignment:CrossAxisAlignment.end,
                                    children: [
                                      FittedText(
                                        height: 15,
                                        width: SizeConfig.screenWidth!*0.23,
                                        alignment: Alignment.centerRight,
                                        text: "${formatCurrency.format(db.currentSaleT!['TotalSale']??0.0)}",
                                        textStyle: TextStyle(fontFamily: 'RM',fontSize: 14,color: AppTheme.bgColor),
                                      ),
                                      // Text("${db.currentSaleT['TotalSale']}",style: TextStyle(fontFamily: 'RM',fontSize: 14,color: AppTheme.bgColor),),
                                      SizedBox(height: 2,),
                                      Text("${db.currentSaleT!['TotalQuantity']} ${db.currentSaleT!['UnitName']}",style: TextStyle(fontFamily: 'RM',fontSize: 9,color: AppTheme.bgColor),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
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
                                    });
                                    db.DashBoardDbHit(context,
                                        "Purchase",
                                        DateFormat("yyyy-MM-dd").format(picked[0]!).toString(),
                                        DateFormat("yyyy-MM-dd").format(picked[1]!).toString()
                                    );
                                  }
                                  else if(picked1!=null && picked1.length ==1){
                                    setState(() {
                                      picked=picked1;
                                    });
                                    db.DashBoardDbHit(context,
                                        "Purchase",
                                        DateFormat("yyyy-MM-dd").format(picked[0]!).toString(),
                                        DateFormat("yyyy-MM-dd").format(picked[0]!).toString()
                                    );
                                  }

                                },
                                child: SvgPicture.asset("assets/svg/calender.svg",width: 27,height: 27,color: AppTheme.dashCalendar,)),
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
                          color: Color(0XFF353535),
                          width: SizeConfig.screenWidth,
                          margin:EdgeInsets.only(top: 55),
                          child: HighCharts(
                            data: db.currentSalesApex,
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
