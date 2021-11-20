
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
import 'package:quarry/pages/dashboard/stockDashBoard/stockDashBoard.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/animation/animePageRoutes.dart';
import 'package:quarry/widgets/charts/highChart/high_chart.dart';
import 'package:quarry/widgets/fittedText.dart';
import 'package:quarry/widgets/loader.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dieselDashBoard/dieselDashBoard.dart';

class DashBoardHome extends StatefulWidget {

  VoidCallback? drawerCallback;
  DashBoardHome({this.drawerCallback});
  @override
  _DashBoardHomeState createState() => _DashBoardHomeState();
}

class _DashBoardHomeState extends State<DashBoardHome> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;

  int selIndex=-1;

  @override
  void didChangeDependencies() {
    Provider.of<DashboardNotifier>(context,listen: false).currentSaleDbHit(context,
        "Sale",
        DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 6))).toString(),
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
    ).then((value){
      /*setState(() {
        currentSaleData=Provider.of<DashboardNotifier>(context,listen: false).currentSaleData;
      });
      Timer(Duration(milliseconds: 600),(){
        chartSeriesController?.animate();
      });*/
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
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
  ChartSeriesController? chartSeriesController;


  getData(){
    currentSaleData=Provider.of<DashboardNotifier>(context,listen: false).currentSaleData;
    return Future.value(currentSaleData);
  }

  @override
  void didUpdateWidget(covariant DashBoardHome oldWidget) {
    //print("DID UPDATE WIDGet");
/*    setState(() {
      currentSaleData=Provider.of<DashboardNotifier>(context,listen: false).currentSaleData;
    });
    Timer(Duration(milliseconds: 600),(){
      chartSeriesController?.animate();
    });*/
    /*Timer(Duration(milliseconds: 300),(){
      chartSeriesController?.animate();
    });*/
   // super.didUpdateWidget(oldWidget);
  }
  List<dynamic> currentSaleData=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body:
      Consumer<DashboardNotifier>(
        builder:(ctx,db,c)=>
            Stack(
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
                              child: NavBarIcon(),
                            ),
                            Container(
                              height: 40,
                              width: SizeConfig.screenWidth!*0.6,
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
                                      Text("    LAST 7 DAYS",style: TextStyle(fontFamily: 'RR',fontSize: 8,color: AppTheme.textColor),),
                                      SizedBox(height: 2,),
                                      Text("    All Product Sale",style: TextStyle(fontFamily: 'RR',fontSize: 10,color: AppTheme.textColor),),
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
                                        textStyle: TextStyle(fontFamily: 'RM',fontSize: 14,color: AppTheme.textColor),
                                      ),
                                     // Text("${db.currentSaleT['TotalSale']}",style: TextStyle(fontFamily: 'RM',fontSize: 14,color: AppTheme.bgColor),),
                                      SizedBox(height: 2,),
                                      Text("${db.currentSaleT!['TotalQuantity']} ${db.currentSaleT!['UnitName']}",style: TextStyle(fontFamily: 'RM',fontSize: 9,color: AppTheme.textColor),),
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
                              ).then((value){
                               /* setState(() {
                                  currentSaleData=Provider.of<DashboardNotifier>(context,listen: false).currentSaleData;
                                });
                                Timer(Duration(milliseconds: 100),(){
                                  chartSeriesController?.animate();
                                });*/
                              });
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
                          child: FutureBuilder<dynamic>(
                            future: getData(), // function where you call your api
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  // AsyncSnapshot<Your object type>
                              if( snapshot.connectionState == ConnectionState.waiting){
                                return Container();
                               // return  Center(child: Text('Please wait its loading...'));
                              }
                              else{
                                if (snapshot.hasError)
                                  return Center(child: Text('Error: ${snapshot.error}',style: AppTheme.TSWhite16,));
                                else
                                  return  Stack(
                                    children: [
                                      Positioned(
                                          left:80,
                                          child:currentSaleData.isEmpty?Container(): Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Sale",style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.yellowColor,letterSpacing: 0.1),),
                                              RichText(
                                                text: TextSpan(
                                                  text: '${DateFormat("MMMd").format(DateTime.parse(currentSaleData[currentSaleData.length-1]['Date']))} : ${formatCurrency.format(currentSaleData[currentSaleData.length-1]['TotalSale']??0.0)} / ',
                                                  style: AppTheme.saleChartTotal,
                                                  children: <TextSpan>[
                                                    TextSpan(text: '${currentSaleData[currentSaleData.length-1]['TotalQuantity']} ${currentSaleData[currentSaleData.length-1]['UnitName']}',
                                                        style:AppTheme.saleChartQty
                                                    ),
                                                  ],
                                                ),
                                              ),


                                            ],
                                          )
                                      ),
                                      SfCartesianChart(
                                        legend: Legend(isVisible: false, opacity: 0.7),
                                        title: ChartTitle(text: ''),
                                        plotAreaBorderWidth: 0,
                                        primaryXAxis: CategoryAxis(
                                            interval: 1,
                                            majorGridLines: const MajorGridLines(width: 0),
                                            //  minorGridLines: const MinorGridLines(width: 1,color: Colors.white),
                                            axisLine:const AxisLine(width: 1),
                                            edgeLabelPlacement: EdgeLabelPlacement.none,
                                            labelPlacement:snapshot.data.length==1?LabelPlacement.betweenTicks: LabelPlacement.onTicks,


                                        ),
                                        primaryYAxis: NumericAxis(
                                          numberFormat: NumberFormat.currency(locale: 'HI',name: "",decimalDigits: 1),
                                          axisLine: const AxisLine(width: 0),
                                          majorTickLines: const MajorTickLines(size: 0),
                                          majorGridLines: const MajorGridLines(width: 0),
                                          labelStyle: TextStyle(color: AppTheme.yAxisText)
                                          //    minorGridLines: const MinorGridLines(width: 1,color: Colors.white),
                                        ),
                                        series:[
                                          SplineAreaSeries<dynamic, String>(
                                            animationDuration:2000,
                                            onRendererCreated: (ChartSeriesController c){
                                              chartSeriesController=c;
                                            },
                                            dataSource: snapshot.data,
                                            borderColor: AppTheme.yellowColor,
                                            borderWidth: 3,
                                            gradient: LinearGradient(
                                              colors: [Color(0xFF343434),AppTheme.yellowColor.withOpacity(0.5)],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              //  stops: [0,30]
                                            ),
                                            markerSettings: MarkerSettings(
                                                isVisible:snapshot.data.length==1? true:false,
                                                color: AppTheme.yellowColor
                                            ),
                                            name: 'Sales',
                                            xValueMapper: (dynamic sales, _) =>DateFormat("MMMd").format(DateTime.parse(sales['Date'])),
                                            yValueMapper: (dynamic sales, _) => sales['TotalSale'],
                                          ),
                                        ],
                                        tooltipBehavior: TooltipBehavior(
                                          enable: true,
                                          duration: 10000,
                                          format: "point.x: point.y",
                                        ),
                                      ),
                                    ],
                                  );  // snapshot.data  :- get your object which is pass from your downloadData() function
                              }
                            },
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
                        // else if(i==1){
                        //   Navigator.push(context, MaterialPageRoute(builder: (context)=>PurchaseDashBoard()));
                        // }
                        else if(i==1){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductionDashBoard()));
                        }
                        else if(i==2){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendanceDashBoard()));
                        }
                        else if(i==3){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CounterDashBoard()));
                        }
                        else if(i==4){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DieselDashBoard()));
                        }
                        else if(i==5){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>InvoiceDashBoard()));
                        }
                        else if(i==6){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>StockDashBoard()));
                        }
                      },
                      child:Container(
                        height: SizeConfig.screenWidth!*0.27,
                        width: SizeConfig.screenWidth!*0.27,
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
                                child: SvgPicture.asset(value.image,height: 45,color: AppTheme.drawerIconColor,)
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

}
