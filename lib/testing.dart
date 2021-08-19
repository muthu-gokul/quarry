/*
import 'package:flutter/material.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRA Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircularRevealAnimation(
          minRadius: 0,
          maxRadius: 700,
          centerOffset: Offset(0, 0),
          child: Container(color: Colors.red),
          animation: animation,
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if (animationController.status == AnimationStatus.forward ||
            animationController.status == AnimationStatus.completed) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
      }),
    );
  }
}*/


import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Sp extends StatefulWidget {
  const Sp({Key? key}) : super(key: key);

  @override
  _SpState createState() => _SpState();
}

class _SpState extends State<Sp> {
  List<dynamic> currentSaleData=[];
  ChartSeriesController? chartSeriesController;
  bool load=false;

  @override
  void didUpdateWidget(covariant Sp oldWidget) {
    print("GDFGDFG");
    super.didUpdateWidget(oldWidget);
  }
var map={};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 300,
              child: SfCartesianChart(
                legend: Legend(isVisible: false, opacity: 0.7),
                title: ChartTitle(text: ''),
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(

                    interval: 1,
                    majorGridLines: const MajorGridLines(width: 0),
                    axisLine:const AxisLine(width: 1),
                    edgeLabelPlacement: EdgeLabelPlacement.shift
                ),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value}',
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: const MajorGridLines(width: 0),
                  //    minorGridLines: const MinorGridLines(width: 1,color: Colors.white),
                ),
                series:[
                  ColumnSeries<dynamic, String>(
                    animationDuration:2000,
                    onRendererCreated: (ChartSeriesController c){
                      chartSeriesController=c;
                    },
                    color: Color(0xFFEFC24A),
                    width: 0.06,
                    spacing: 0.4,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                      dataSource: currentSaleData,
                    name: 'Stock',
                    xValueMapper: (dynamic sales, _) =>DateFormat("MMMd").format(DateTime.parse(sales['Date'])),
                    yValueMapper: (dynamic sales, _) => sales['TotalSale']-5,
                  ),
                  ColumnSeries<dynamic, String>(
                    animationDuration:2000,
                    onRendererCreated: (ChartSeriesController c){
                      chartSeriesController=c;
                    },
                    color: Color(0xFF949393),
                    width: 0.06,
                    spacing: 0.4,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                   /* gradient: LinearGradient(
                      colors: [Color(0xFFD7D7D7),Color(0xFFFAFAFA)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.25,0.75]
                    ),*/
                      dataSource: currentSaleData,
                    name: 'Sales',
                    xValueMapper: (dynamic sales, _) =>DateFormat("MMMd").format(DateTime.parse(sales['Date'])),
                    yValueMapper: (dynamic sales, _) => sales['TotalSale'],
                  ),

                ],
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  duration: 2000,
                  format: "point.x : point.y",

                ),
              ),
            ),
            RaisedButton(onPressed: (){

             setState(() {
               currentSaleData= [{"Date":"2021-08-07T00:00:00","TotalSale":124628.00,"TotalQuantity":147.0,"UnitName":"Tons"}];
              // currentSaleData= [{"Date":"2021-08-07T00:00:00","TotalSale":124628.00,"TotalQuantity":147.0,"UnitName":"Tons"},{"Date":"2021-08-08T00:00:00","TotalSale":30979.00,"TotalQuantity":40.0,"UnitName":"Tons"},{"Date":"2021-08-09T00:00:00","TotalSale":122305.00,"TotalQuantity":148.0,"UnitName":"Tons"},{"Date":"2021-08-10T00:00:00","TotalSale":81340.00,"TotalQuantity":102.0,"UnitName":"Tons"},{"Date":"2021-08-11T00:00:00","TotalSale":162623.00,"TotalQuantity":209.0,"UnitName":"Tons"},{"Date":"2021-08-12T00:00:00","TotalSale":58723.75,"TotalQuantity":81.0,"UnitName":"Tons"},{"Date":"2021-08-13T00:00:00","TotalSale":37775.00,"TotalQuantity":53.0,"UnitName":"Tons"}];
             });
             Timer(Duration(milliseconds: 50), (){
               chartSeriesController?.animate();
             });


            }),
            RaisedButton(onPressed: (){
              setState(() {
                currentSaleData.clear();
              });
            }),
            load?CircularProgressIndicator():RaisedButton(onPressed: () async {
              setState(() {
                load=true;
              });
              try{
                var body = {
                  "Fields": [
                    {
                      "Key": "SpName",
                      "Type": "String",
                      "Value": "USP_UserSignInDetail"
                    },
                    {
                      "Key": "UserName",
                      "Type": "String",
                      "Value": "vivekmurugan@gmail.com"
                    },
                    {
                      "Key": "Password",
                      "Type": "String",
                      "Value": "QMS@123"
                    },
                    {
                      "Key": "database",
                      "Type": "String",
                      //"Value": "TetroPOS_TestQMS" //live
                      // "Value": "TetroPos_QMSLocal"
                       "Value": "TetroPos_QMSTest1"
                    },

                  ]
                };
              /*  var body = {
                  "Fields":  [
                    {"Key":"SpName","Type":"String","Value":"USP_DSB_GetTabDashBoard"},
                    {"Key":"LoginUserId","Type":"int","Value":1},
                    {"Key":"FromDate","Type":"String","Value":"2021-08-12"},
                    {"Key":"ToDate","Type":"String","Value":"2021-08-18"},
                    {"Key":"TypeName","Type":"String","Value":"Sale"},
                    {"Key":"database","Type":"String","Value":"TetroPOS_TestQMS"}
                    ]
                };*/
           //     print(json.encode(body));
                final  response = await http.post(
                    Uri.parse("http://10.0.2.2:8080/api/users/login"),
                    headers: {"Content-Type": "application/json"},
                    body: json.encode(body)
                   // body: {"userna":"raja@gmail.com","password":"Login@123"}
                );
                log(response.body);
                setState(() {
                  load=false;
                });
              }catch(e){
                setState(() {
                  load=false;
                });
              }


            //  Navigator.push(context, MaterialPageRoute(builder: (context)=>Page2()));
            }),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}


