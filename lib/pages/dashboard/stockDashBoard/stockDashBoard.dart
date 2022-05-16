

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
import 'package:syncfusion_flutter_charts/charts.dart';

class StockDashBoard extends StatefulWidget {

  VoidCallback? drawerCallback;
  StockDashBoard({this.drawerCallback});
  @override
  _StockDashBoardState createState() => _StockDashBoardState();
}

class _StockDashBoardState extends State<StockDashBoard> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;

  int selIndex=-1;
  List<dynamic> saleData=[];
  late Future stockFuture;
  getData(){
    saleData=Provider.of<DashboardNotifier>(context,listen: false).stockT1;
    return Future.value(saleData);
  }

  @override
  void initState() {
    stockFuture=getData();
    Provider.of<DashboardNotifier>(context,listen: false).DashBoardDbHit(context,
        "Stock",
        DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 6))).toString(),
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
    ).then((value){
      stockFuture=getData();
      /*Timer(Duration(milliseconds: 100),(){
        chartSeriesController?.animate();
      });*/
    });
    WidgetsBinding.instance.addPostFrameCallback((_){
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

  List<DateTime?> picked=[];
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
                           // Text("Stock DashBoard",style: AppTheme.TSWhite166,),
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
                                      Text("    Stock",style: TextStyle(fontFamily: 'RR',fontSize: 8,color: AppTheme.bgColor),),
                                      SizedBox(height: 2,),
                                      Text("    Material ${db.stockT['Material']??0}",style: TextStyle(fontFamily: 'RR',fontSize: 10,color: AppTheme.bgColor),),
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
                                        text: "${formatCurrency.format(db.stockT['StockAmount']??0.0)}",
                                        textStyle: TextStyle(fontFamily: 'RM',fontSize: 14,color: AppTheme.bgColor),
                                      ),
                                      // Text("${db.currentSaleT['TotalSale']}",style: TextStyle(fontFamily: 'RM',fontSize: 14,color: AppTheme.bgColor),),
                                      SizedBox(height: 2,),
                                      Text("${db.stockT['OverAllStock']} ton",style: TextStyle(fontFamily: 'RM',fontSize: 9,color: AppTheme.bgColor),),
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
                                    lastDate: (new DateTime.now()),

                                  );
                                  if (picked1 != null && picked1.length == 2) {
                                    setState(() {
                                      picked=picked1;
                                      //  db.saleData.clear();
                                    });

                                    db.DashBoardDbHit(context,
                                        "Stock",
                                        DateFormat("yyyy-MM-dd").format(picked[0]!).toString(),
                                        DateFormat("yyyy-MM-dd").format(picked[1]!).toString()
                                    ).then((value){
                                      stockFuture=getData();
                                    });
                                  }
                                  else if(picked1!=null && picked1.length ==1){
                                    setState(() {
                                      picked=picked1;
                                      //  db.saleData.clear();
                                    });

                                    db.DashBoardDbHit(context,
                                        "Stock",
                                        DateFormat("yyyy-MM-dd").format(picked[0]!).toString(),
                                        DateFormat("yyyy-MM-dd").format(picked[0]!).toString()
                                    ).then((value){
                                      stockFuture=getData();
                                    });
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
                          child: FutureBuilder<dynamic>(
                            future: stockFuture,
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                                     /* Positioned(
                                          left:80,
                                          child:saleData.isEmpty?Container(): Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Sale",style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.yellowColor,letterSpacing: 0.1),),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Total : ${formatCurrency.format(db.saleT!['TotalSale'])} / ',
                                                  style: AppTheme.saleChartTotal,
                                                  children: <TextSpan>[
                                                    TextSpan(text: '${db.saleT!['TotalQuantity']} ${db.saleT!['UnitName']}',
                                                      style: AppTheme.saleChartQty,
                                                    ),
                                                  ],
                                                ),
                                              ),


                                            ],
                                          )
                                      ),*/
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
                                            labelPlacement:saleData.length==1?LabelPlacement.betweenTicks: LabelPlacement.onTicks
                                        ),
                                        primaryYAxis: NumericAxis(
                                            numberFormat: NumberFormat.currency(locale: 'HI',name: "",decimalDigits: 1),
                                            axisLine: const AxisLine(width: 0),
                                            majorTickLines: const MajorTickLines(size: 0),
                                            majorGridLines: const MajorGridLines(width: 0),
                                            labelStyle: TextStyle(color: AppTheme.yAxisText)
                                        ),
                                        series:[
                                          SplineAreaSeries<dynamic, String>(
                                            animationDuration:2000,
                                            onRendererCreated: (ChartSeriesController c){
                                              chartSeriesController=c;
                                            },
                                            markerSettings: MarkerSettings(
                                                isVisible:saleData.length==1? true:false,
                                                color: AppTheme.yellowColor
                                            ),
                                            dataSource: saleData,
                                            borderColor: Color(0xFFFEBF10),
                                            borderWidth: 3,
                                            gradient: LinearGradient(
                                              colors: [Color(0xFF343434),Color(0xFFFEBF10).withOpacity(0.5)],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              //  stops: [0,30]
                                            ),
                                            name: 'Stock',
                                            xValueMapper: (dynamic sales, _) =>sales['MaterialName'],
                                            yValueMapper: (dynamic sales, _) => sales['Stock'],
                                          ),
                                        ],
                                        tooltipBehavior: TooltipBehavior(
                                            enable: true,
                                            duration: 10000,
                                            format: "point.x : point.y ton"
                                        ),
                                      ),
                                    ],
                                  );
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
                child: db.saleT2!.isEmpty?Container(
                  width: SizeConfig.screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                      SvgPicture.asset("assets/nodata.svg",height: 300,),
                      SizedBox(height: 30,),
                      Text("No Data",style: TextStyle(fontSize: 18,fontFamily:'RMI',color: AppTheme.addNewTextFieldText),),

                    ],
                  ),
                ): ListView.builder(
                  itemCount: db.saleT2!.length,
                  itemBuilder: (ctx,i){
                    return Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, rightLeftRoute(SalesMaterial(
                            materialName: db.saleT2![i]['MaterialName'],
                            materialPrice: db.saleT2![i]['TotalSale'],
                            materialQty: db.saleT2![i]['TotalQuantity'],
                            materialUnit: db.saleT2![i]['UnitName'],
                            weekList: db.saleMaterialWeeklyT3!.where((element) => element['MaterialId']==db.saleT2![i]['MaterialId']).toList(),
                            monthList: db.saleMaterialMonthlyT4!.where((element) => element['MaterialId']==db.saleT2![i]['MaterialId']).toList(),
                            yearList: db.saleMaterialYearT5!.where((element) => element['MaterialId']==db.saleT2![i]['MaterialId']).toList(),
                          )));
                        },
                        child: Container(
                          height: 65,
                          width: SizeConfig.screenWidth!*0.95,
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
                                    color: AppTheme.yellowColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.yellowColor.withOpacity(0.4),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(0, 6), // changes position of shadow
                                      )
                                    ]
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
                                    width:(SizeConfig.screenWidth!*0.95)-80,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("${db.saleT2![i]['MaterialName']} / ",style: TextStyle(fontFamily: 'RR',color: Color(0xFFBDBCBD),fontSize: 14),),
                                        Text("${formatCurrency.format(db.saleT2![i]['TotalSale']??0.0)}",style: TextStyle(fontFamily: 'RM',color: Color(0xFF999999),fontSize: 14),),
                                        Text("  ${db.saleT2![i]['TotalQuantity']} ${db.saleT2![i]['UnitName']}",style: TextStyle(fontFamily: 'RR',color: Color(0xFF999999),fontSize: 10),),
                                        Spacer(),
                                        FittedText(
                                          height: 18,
                                          width: 50,
                                          text: "${db.saleT2![i]['SalePercentage']} %",
                                          alignment: Alignment.bottomRight,
                                          textStyle: TextStyle(fontFamily: 'RR',color: Color(0xFF999999),fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  LinearPercentIndicator(
                                    width:(SizeConfig.screenWidth!*0.95)-80,
                                    animation: true,
                                    lineHeight: 8.0,
                                    animationDuration: 1000,
                                    percent: (db.saleT2![i]['SalePercentage'])/100.0,
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    padding: EdgeInsets.only(left: 0),
                                    // progressColor: AppTheme.yellowColor,
                                    backgroundColor: Color(0xFFEAEAEA),
                                    linearGradient: LinearGradient(colors: [Color(0xFFF9E6AA),AppTheme.yellowColor,],),
                                    leading: Container(),
                                    trailing: Container(),
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


