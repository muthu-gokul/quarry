/*import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';

import 'package:webview_flutter/webview_flutter.dart';


class DashBoardHome extends StatefulWidget {
  VoidCallback drawerCallback;
  DashBoardHome({this.drawerCallback});

  @override
  _DashBoardHomeState createState() => _DashBoardHomeState();
}

class _DashBoardHomeState extends State<DashBoardHome> with TickerProviderStateMixin{
  bool isEdit=false;
  bool isListScroll=false;


  ScrollController scrollController;
  ScrollController listViewController;

  int selectedIndex=-1;


  List<Color> gradientColors = [
    const Color(0xFFFFC010),
    const Color(0xFFc99e28),
  ];


  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });
      if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();




    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

return Scaffold(
        body: WebView(
        initialUrl: 'https://s3.amazonaws.com/qmsadminpanel.com/Quarry/Views/Dashboard/dashboard.html',
        javascriptMode: JavascriptMode.unrestricted,
        ),
        );
  }
}*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/pages/dashboard/attendanceDashBoard/attendanceDashBoard.dart';
import 'package:quarry/pages/dashboard/counterDashBoard/counterDashBoard.dart';
import 'package:quarry/pages/dashboard/invoiceDashBoard/invoiceDashBoard.dart';
import 'package:quarry/pages/dashboard/productionDashBoard/productionDashBoard.dart';
import 'package:quarry/pages/dashboard/purchaseDashBoard/purchaseDashBoard.dart';
import 'package:quarry/pages/dashboard/saleDashBoard/salesDashBoard.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/animation/animePageRoutes.dart';
import 'package:quarry/widgets/charts/highChart/high_chart.dart';
import 'package:quarry/widgets/fittedText.dart';
import 'package:quarry/widgets/loader.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;

import 'dieselDashBoard/dieselDashBoard.dart';

class DashBoardHome extends StatefulWidget {

  VoidCallback drawerCallback;
  DashBoardHome({this.drawerCallback});
  @override
  _DashBoardHomeState createState() => _DashBoardHomeState();
}

class _DashBoardHomeState extends State<DashBoardHome> {
  ScrollController silverController;
  double silverBodyTopMargin=0;

  int selIndex=-1;

  @override
  void didChangeDependencies() {
    Provider.of<DashboardNotifier>(context,listen: false).currentSaleDbHit(context,
        "Sale",
        DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 6))).toString(),
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
    );
    super.didChangeDependencies();
  }

  @override
  void initState() {

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
                            GestureDetector(
                              onTap: widget.drawerCallback,
                              child: Container(
                                height: 25,
                                width: 22,
                                color: Colors.transparent,
                                margin: EdgeInsets.only(left: 20,right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 6,),
                                    Container(
                                      height: 2.2,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.white
                                      ),
                                    ),
                                    SizedBox(height: 2,),
                                    Container(
                                      height: 2.2,
                                      width: 17,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: AppTheme.grey
                                      ),
                                    ),
                                    SizedBox(height: 2,),
                                    Container(
                                      height: 2.2,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.white
                                      ),
                                    ),
                                    SizedBox(height: 2,),
                                    Container(
                                      height: 2.2,
                                      width: 17,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: AppTheme.grey
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: SizeConfig.screenWidth*0.6,
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
                                    child: Center(
                                      child: SvgPicture.asset("assets/svg/drawer/sales-form.svg"),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Text("    LAST 7 DAYS",style: TextStyle(fontFamily: 'RR',fontSize: 8,color: AppTheme.bgColor),),
                                      SizedBox(height: 2,),
                                      Text("    All Product Sale",style: TextStyle(fontFamily: 'RR',fontSize: 10,color: AppTheme.bgColor),),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    crossAxisAlignment:CrossAxisAlignment.end,
                                    children: [
                                      FittedText(
                                        height: 15,
                                        width: SizeConfig.screenWidth*0.23,
                                        alignment: Alignment.centerRight,
                                        text: "${formatCurrency.format(db.currentSaleT['TotalSale']??0.0)}",
                                        textStyle: TextStyle(fontFamily: 'RM',fontSize: 14,color: AppTheme.bgColor),
                                      ),
                                     // Text("${db.currentSaleT['TotalSale']}",style: TextStyle(fontFamily: 'RM',fontSize: 14,color: AppTheme.bgColor),),
                                      SizedBox(height: 2,),
                                      Text("${db.currentSaleT['TotalQuantity']} ${db.currentSaleT['UnitName']}",style: TextStyle(fontFamily: 'RM',fontSize: 9,color: AppTheme.bgColor),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            IconButton(onPressed: (){
                              db.currentSaleDbHit(context,
                                  "Sale",
                                  DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 6))).toString(),
                                  DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
                              );
                            }, icon: Icon(Icons.refresh,color: AppTheme.dashCalendar,)),
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
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 20,
                    spacing: 20,
                    children: db.menu.asMap().map((i, value) => MapEntry(i, GestureDetector(
                      onTap:selIndex==i?null: (){
                        setState(() {
                          selIndex=i;
                        });
                        Timer(Duration(milliseconds: 500), (){
                          setState(() {
                            selIndex=-1;
                          });
                        });
                        if(i==0){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesDashBoard()));
                        }
                        else if(i==1){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PurchaseDashBoard()));
                        }
                        else if(i==2){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductionDashBoard()));
                        }
                        else if(i==3){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendanceDashBoard()));
                        }
                        else if(i==4){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CounterDashBoard()));
                        }
                        else if(i==5){
                     //     Navigator.push(context, MaterialPageRoute(builder: (context)=>CounterDashBoard()));
                        }
                        else if(i==6){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DieselDashBoard()));
                        }
                        else if(i==7){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>InvoiceDashBoard()));
                        }

                      },
                      child: Container(
                        height: SizeConfig.screenWidth*0.27,
                        width: SizeConfig.screenWidth*0.27,
                        padding: EdgeInsets.only(left: 10,right: 10),
                        decoration: selIndex==i? BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:selIndex==i?AppTheme.yellowColor: Colors.white,
                          boxShadow: [
                            AppTheme.yellowShadow
                          ]
                        ):BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.yellowColor
                                ),
                                child: SvgPicture.asset(value.image,height: 45,)
                            ),
                            SizedBox(height: 10,),
                            Text("${value.title}",style:selIndex==i? AppTheme.bgColorTS14:TextStyle(fontFamily: 'RR',color: AppTheme.gridTextColor,fontSize: 13),textAlign: TextAlign.center,)
                          ],
                        ),
                      ),
                    ))).values.toList(),
                  ),
                )

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
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SalesDashBoard(),
      //pageBuilder: (context, animation, secondaryAnimation) => QuaryAddNew(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
