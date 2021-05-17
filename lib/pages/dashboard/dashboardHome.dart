import 'dart:async';
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
import 'package:fl_chart/fl_chart.dart';
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
      body: Consumer<DashboardNotifier>(
          builder: (context,dsb,child)=> Stack(
            children: [



              Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                color: AppTheme.bgColor,
                child: Column(
                  children: [

                    Container(
                      width: double.maxFinite,
                      height:280,
                      child:LineChart(
                          mainData()
                      ),

                    ),





                  ],
                ),
              ),


              Container(
                height: SizeConfig.screenHeight,
                // color: Colors.transparent,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  child: Column(
                    children: [
                    //  SizedBox(height: 300,),
                      GestureDetector(
                        onVerticalDragUpdate: (details){

                          int sensitivity = 5;
                          if (details.delta.dy > sensitivity) {
                            scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                              if(isListScroll){
                                setState(() {
                                  isListScroll=false;
                                });
                              }
                            });

                          } else if(details.delta.dy < -sensitivity){
                            scrollController.animateTo(240, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

                              if(!isListScroll){
                                setState(() {
                                  isListScroll=true;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          height: SizeConfig.screenHeight-60,
                          width: SizeConfig.screenWidth,
                          margin: EdgeInsets.only(top: 300),

                          decoration: BoxDecoration(
                              color: AppTheme.gridbodyBgColor,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child:  NotificationListener<ScrollNotification>(
                            onNotification: (s){
                              //   print(ScrollStartNotification);
                              if(s is ScrollStartNotification){

                                if(listViewController.offset==0 && isListScroll && scrollController.offset==240 && listViewController.position.userScrollDirection==ScrollDirection.idle){

                                  Timer(Duration(milliseconds: 100), (){
                                    if(listViewController.position.userScrollDirection!=ScrollDirection.reverse){

                                      //if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
                                      if(listViewController.offset==0){

                                        scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value) {
                                          if(isListScroll){
                                            setState(() {
                                              isListScroll=false;
                                            });
                                          }
                                        });
                                      }

                                    }
                                  });
                                }
                              }
                            },
                            child: ListView(
                              controller: listViewController,
                              scrollDirection: Axis.vertical,
                              physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),

                              children: [
                                SizedBox(height: 40,),




                                SingleChildScrollView(
                                  child: Wrap(

                                    alignment: WrapAlignment.center,
                                      runSpacing: 40,
                                      spacing: 40,
                                      children: dsb.menu.asMap()
                                          .map((i, value) => MapEntry(i,
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            selectedIndex=i;
                                          });
                                        },
                                        child: Container(
                                          height: 150,
                                          width: SizeConfig.screenWidth*0.35,

                                          decoration: BoxDecoration(
                                            color:selectedIndex==i?AppTheme.yellowColor: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                                  BoxShadow(
                                                     color:selectedIndex==i? AppTheme.yellowColor.withOpacity(0.4):AppTheme.gridbodyBgColor.withOpacity(0.4),
                                                         spreadRadius: 1,
                                                          blurRadius: 15,
                                                        offset: Offset(0, 10), // changes position of shadow
                                                     )
                                            ]
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Container(
                                                height: 50,
                                                width: 50,

                                                child: Center(
                                                  child: SvgPicture.asset(value.image,height: 40,width: 40,
                                                    color:selectedIndex==i? AppTheme.bgColor.withOpacity(0.9):AppTheme.gridTextColor.withOpacity(0.5),),
                                                ),
                                              ),

                                              SizedBox(height: 5,),
                                              Text("${value.title}  ",
                                                style: TextStyle(color: selectedIndex==i?AppTheme.bgColor:AppTheme.gridTextColor,fontFamily: 'RR',fontSize: 14),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),

                                      )
                                      ).values.toList()
                                  ),
                                )


                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: SizeConfig.height60,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.drawerCallback,
                      child: NavBarIcon(),
                    ),
                    Text("DashBoard",
                      style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                    ),

                  ],
                ),
              ),



            ],
          )
      ),
    );
  }

  LineChartData mainData() {
    List<String> month=["Jan","Feb","Mar","Apr","May","June"];
    return
      LineChartData(
        minX: 0,
        maxX: 12,
        minY: 0,
        maxY: 6,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            getTitles: (value) {
              month.map((e) => value+1);
            },
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff67727d),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            getTitles: (value) {
              month.map((e) => value+1);
            },
            reservedSize: 35,
            margin: 12,
          ),
        ),

        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 1),
              FlSpot(1.5, 2),
              FlSpot(4.9, 3),

            ],
            isCurved: true,
            colors: gradientColors,
            barWidth: 5,
            //dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ],
      )
    ;
  }


}



/*
return Scaffold(
body: WebView(
initialUrl: 'https://www.google.com/',
javascriptMode: JavascriptMode.unrestricted,
),
);*/
