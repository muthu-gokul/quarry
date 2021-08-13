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

  @override
  void didUpdateWidget(covariant Sp oldWidget) {
    print("GDFGDFG");
    super.didUpdateWidget(oldWidget);
  }

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
                    //  minorGridLines: const MinorGridLines(width: 1,color: Colors.white),
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
                  SplineAreaSeries<dynamic, String>(
                    animationDuration:2000,
                    onRendererCreated: (ChartSeriesController c){
                      chartSeriesController=c;
                    },
                    dataSource: currentSaleData,
                    borderColor: Color(0xFFFEBF10),
                    borderWidth: 3,
                    gradient: LinearGradient(
                      colors: [Color(0xFF343434),Color(0xFFFEBF10).withOpacity(0.5)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      //  stops: [0,30]
                    ),
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
               currentSaleData= [{"Date":"2021-08-07T00:00:00","TotalSale":124628.00,"TotalQuantity":147.0,"UnitName":"Tons"},{"Date":"2021-08-08T00:00:00","TotalSale":30979.00,"TotalQuantity":40.0,"UnitName":"Tons"},{"Date":"2021-08-09T00:00:00","TotalSale":122305.00,"TotalQuantity":148.0,"UnitName":"Tons"},{"Date":"2021-08-10T00:00:00","TotalSale":81340.00,"TotalQuantity":102.0,"UnitName":"Tons"},{"Date":"2021-08-11T00:00:00","TotalSale":162623.00,"TotalQuantity":209.0,"UnitName":"Tons"},{"Date":"2021-08-12T00:00:00","TotalSale":58723.75,"TotalQuantity":81.0,"UnitName":"Tons"},{"Date":"2021-08-13T00:00:00","TotalSale":37775.00,"TotalQuantity":53.0,"UnitName":"Tons"}];
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
            RaisedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Page2()));
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


/*
class DeviceListViewWidget extends StatefulWidget {
  @override
  _DeviceListViewWidgetState createState() => _DeviceListViewWidgetState();
}

class _DeviceListViewWidgetState extends State<DeviceListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DeviceDetails>>(
      // Adding Data to List From Local DB
      future: DeviceDetailsDatabaseProvider.dbProvider.getAllDeviceDetails(),

      builder:
          (BuildContext context, AsyncSnapshot<List<DeviceDetails>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                // Showing Data in ListView
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  DeviceDetails item = snapshot.data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        elevation: 30.0,
                        child: Padding(
                          // Site List Creation
                          padding: const EdgeInsets.all(16.0),
                          child: new ListTile(
                              onTap: () {
                                // setState(() {});

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DeviceDetailss(
                                          // Moving to Details Screen
                                          item.id,
                                        )));
                              },
                              leading: new CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundColor: appTheme,
                                radius: 35,
                                child: Image.asset("images/device.png"),
                              ),
                              title: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${item.deviceName}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontStyle: FontStyle.normal),
                                        ),
                                        Text(
                                          "Job ID : ${item.jobId}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          "Site : ${item.site}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        )),
                  );
                },
              );
            } else {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        child: Image.asset(
                          "images/search.png",
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      Text(
                        'No Device Found',
                        style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
*/
