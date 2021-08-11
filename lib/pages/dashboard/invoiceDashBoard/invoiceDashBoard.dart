
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/pages/dashboard/saleDashBoard/salesDashBoard.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/arrowBack.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/charts/highChart/high_chart.dart';
import 'package:quarry/widgets/circularProgress/circleProgressBar.dart';
import 'package:quarry/widgets/circularProgress/circleProgressBar2.dart';
import 'package:quarry/widgets/fittedText.dart';
import 'package:quarry/widgets/loader.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:charts_flutter/flutter.dart' as charts;
class InvoiceDashBoard extends StatefulWidget {

  VoidCallback drawerCallback;
  InvoiceDashBoard({this.drawerCallback});
  @override
  _InvoiceDashBoardState createState() => _InvoiceDashBoardState();
}

class _InvoiceDashBoardState extends State<InvoiceDashBoard> {
  ScrollController silverController;
  double silverBodyTopMargin=0;
  List<DateTime> picked=[];
  int selIndex=-1;
  @override
  void initState() {
   /* Provider.of<DashboardNotifier>(context,listen: false).DashBoardDbHit(context,
        "Attendance",
        DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 6))).toString(),
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
    );*/

    WidgetsBinding.instance.addPostFrameCallback((_){
      silverController=new ScrollController();

      setState(() {
        silverBodyTopMargin=0;
      });

      silverController.addListener(() {
        if(silverController.offset>150){
          setState(() {
            silverBodyTopMargin=50-(-(silverController.offset-200));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController.offset<170){
          setState(() {
            silverBodyTopMargin=0;
          });
        }
      });
    });
    super.initState();
  }
  double tabWidth;
  double position=5;


  static const highPiedonut='''
      Highcharts.setOptions({
     colors: ['#FDD002', '#88E0B0', '#FF5872',]
    });
    Highcharts.chart('chart', {
        chart: {
        
        height:300,
        
        type: 'pie',
        options3d: {
            enabled: true,
            alpha: 55,
            beta: 0
        },
        backgroundColor:'#F6F7F9',
    },
    title: {
        text: ''
    },
    accessibility: {
        point: {
            valueSuffix: '%'
        }
    },
    tooltip: {
        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    },
    plotOptions: {
        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            depth: 35,
            dataLabels: {
                enabled: true,
                format: '{point.name}'
            }
        }
    },
    series: [{
        type: 'pie',
        name: 'Income',
        data: [
            ['Partilly', 10],
            ['Paid', 65],
            ['UnPaid', 25]
        ]
    }]
});
  ''';

  @override
  Widget build(BuildContext context) {
    tabWidth=SizeConfig.screenWidth-40;
    return Scaffold(
      backgroundColor: AppTheme.yellowColor,
      bottomNavigationBar: Container(
        width: SizeConfig.screenWidth,
        height: 65,
        decoration: BoxDecoration(
            color: AppTheme.gridbodyBgColor,
            boxShadow: [
              BoxShadow(
                color: AppTheme.gridbodyBgColor,
                spreadRadius: 2,
                blurRadius: 15,
                offset: Offset(0, -10), // changes position of shadow
              )
            ]
        ),
        child: Stack(

          children: [
            Container(
              margin:EdgeInsets.only(top: 0),
              child: CustomPaint(
                size: Size( SizeConfig.screenWidth, 65),
                painter: RPSCustomPainter3(),
              ),
            ),
            Container(
              width:  SizeConfig.screenWidth,
              height: 65,
              child: Row(
                children: [

                ],
              ),
            ),
          ],
        ),
      ),
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
                            Text("Invoice",style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16,letterSpacing: 0.2)),
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
                                        "Attendance",
                                        DateFormat("yyyy-MM-dd").format(picked[0]).toString(),
                                        DateFormat("yyyy-MM-dd").format(picked[1]).toString()
                                    );
                                  }
                                  else if(picked1!=null && picked1.length ==1){
                                    setState(() {
                                      picked=picked1;
                                    });
                                    db.DashBoardDbHit(context,
                                        "Attendance",
                                        DateFormat("yyyy-MM-dd").format(picked[0]).toString(),
                                        DateFormat("yyyy-MM-dd").format(picked[0]).toString()
                                    );
                                  }

                                },
                                child: SvgPicture.asset("assets/svg/calender.svg",width: 27,height: 27,color: AppTheme.bgColor,)),
                            SizedBox(width: 20,)
                          ],
                        ),
                      ),
                    ],
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          color: Color(0XFF353535),
                          width: SizeConfig.screenWidth,
                          // margin:EdgeInsets.only(top: 55),
                          child:Image.asset("assets/images/saleFormheader.jpg",fit: BoxFit.cover,),
                        )
                    ),
                  ),
                ];
              },
              body: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(top: silverBodyTopMargin),
                // padding: EdgeInsets.only(top: 30,bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  color: Color(0xFFF6F7F9),
                ),
                child: PageView(
                  children: [
                      Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenHeight,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Text(formatCurrency.format(3424),style: TextStyle(fontFamily: 'RM',fontSize: 28,color: Color(0xFF525D73)),),
                            Container(
                              height: 40,
                              width: 200,
                              margin: EdgeInsets.only(top: 10),
                              decoration:BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: Color(0xFFd7d7d7))
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: Text(picked.length==1?"${DateFormat("dd/MM/yyyy").format(picked[0])}":
                              picked.length==2?"${DateFormat("dd/MM/yyyy").format(picked[0])} - ${DateFormat("dd/MM/yyyy").format(picked[1])}":"Today",
                                style: TextStyle(color:AppTheme.yellowColor,fontFamily: 'RM',fontSize: 14),
                              ),
                            ),
                            Container(
                              height: 300,
                              color: Colors.transparent,
                              child: HighCharts(
                                data: highPiedonut,
                                isHighChart: true,
                                isHighChartExtraParam: true,
                                isLoad: false,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(width: 40,),
                                Container(
                                  height:60,
                                  margin: EdgeInsets.only(bottom: 5),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent
                                  ),
                                  //  color: i==0?Colors.red:Colors.transparent,
                                  child: CircleProgressBar(
                                    extraStrokeWidth: -0.9,
                                    backgroundColor: Color(0xFFd7d7d7),
                                    foregroundColor: Color(0xFFAFAFAF),
                                    value: 0.6,
                                    center: Container(
                                        height: 50,
                                        width: 50,
                                        margin: EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            boxShadow: [

                                            ]
                                        ),
                                        child: Text("65%",textAlign: TextAlign.center,style: TextStyle(color: Color(0xFF7D7D7D),fontFamily: 'RB'),)),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text("Paid Invoice",textAlign: TextAlign.center,style: TextStyle(color: Color(0xFF525D73),fontFamily: 'RB'),),
                                  SizedBox(height: 3,),
                                  Text("245 invoice",textAlign: TextAlign.center,style: TextStyle(color: Color(0xFF7D7D7D).withOpacity(0.8),fontFamily: 'RR',fontSize: 11),),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  height: 25,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(0xFFAEAEAE),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFAEAEAE).withOpacity(0.4),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(5, 5), // changes position of shadow
                                      )
                                    ]
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("View all",style: TextStyle(color: Colors.white,fontFamily: 'RM',fontSize: 10),),
                                ),
                                SizedBox(width: 20,)
                              ],
                            ),
                          ],
                        ),
                      ),

                    Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight,
                      color: Colors.blue,
                    ),
                  ],
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


  counter(Color color,String title,dynamic value){
    return  Container(
      height: SizeConfig.screenWidth*0.4,
      width: SizeConfig.screenWidth*0.4,
      padding: EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(1, 8), // changes position of shadow
                  )
                ]
            ),
          ),
          //    SvgPicture.asset(value.image,height: 45,),
          SizedBox(height: 20,),
          Text("$value",style:TextStyle(fontFamily: 'RB',fontSize: 16,color: color),textAlign: TextAlign.center,),
          SizedBox(height: 7,),
          Text("$title",style:AppTheme.gridTextColor14,textAlign: TextAlign.center,)
        ],
      ),
    );
  }

}
