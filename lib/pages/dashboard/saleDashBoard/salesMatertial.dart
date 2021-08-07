

import 'dart:async';
import 'dart:convert';

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
import 'package:quarry/widgets/linearProgressBar.dart';
import 'package:quarry/widgets/loader.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;

class SalesMaterial extends StatefulWidget {

  String materialName;
  double materialPrice;
  double materialQty;
  String materialUnit;
  List<dynamic> weekList;
  List<dynamic> monthList;
  List<dynamic> yearList;
  SalesMaterial({this.materialName,this.materialPrice,this.materialQty,this.materialUnit,this.weekList,this.monthList,this.yearList});
  @override
  _SalesMaterialState createState() => _SalesMaterialState();
}

class _SalesMaterialState extends State<SalesMaterial> {
  ScrollController silverController;
  double silverBodyTopMargin=0;

  int selIndex=-1;

  @override
  void initState() {
    Provider.of<DashboardNotifier>(context,listen: false).getSaleMaterialDetail(
        widget.weekList.map((e) => e['TotalSale']).toList(),
        json.encode(widget.weekList.map((e) => e['WeekDay']).toList()),
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
  double tabWidth;
  double position=5;

  @override
  Widget build(BuildContext context) {
    tabWidth=SizeConfig.screenWidth-40;
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
                            Text("Material ",style: AppTheme.TSWhite166,),
                            Spacer(),
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
                padding: EdgeInsets.only(top: 10,bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  color: Color(0xFFF6F7F9),
                ),
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(width: 15,),
                        Image.asset("assets/bottomIcons/add-material.png",height: 25,),
                        SizedBox(width: 5,),
                        Text("${widget.materialName} / ",style: TextStyle(fontFamily: 'RM',color:AppTheme.bgColor,fontSize: 15),),
                        Text("${formatCurrency.format(widget.materialPrice??0.0)}",style: TextStyle(fontFamily: 'RB',color: AppTheme.bgColor,fontSize: 15),),
                        Text("  ${widget.materialQty} ${widget.materialUnit}",style: TextStyle(fontFamily: 'RR',color: Color(0xFF999999),fontSize: 12),),

                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: tabWidth*0.99,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Color(0xFFE6E6E6)
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            left: position,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                            child: Container(
                              width: tabWidth*0.33,
                              height: 35,
                              margin: EdgeInsets.only(top: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                color: AppTheme.yellowColor,
                                boxShadow: [
                                  AppTheme.yellowShadow
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap:(){
                                  setState(() {
                                    position=5;
                                  });
                                  db.getSaleMaterialDetail(
                                    widget.weekList.map((e) => e['TotalSale']).toList(),
                                    json.encode(widget.weekList.map((e) => e['WeekDay']).toList()),
                                  );
                                },
                                child: Container(
                                  width: tabWidth*0.33,
                                  height: 50,
                                  child: Center(
                                      child: Text("Week",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.grey),)

                                  ),
                                ),
                              ),
                              InkWell(
                                onTap:(){

                                  setState(() {
                                    position=tabWidth*0.33;
                                  });
                                  db.getSaleMaterialDetail(
                                    widget.monthList.map((e) => e['TotalSale']).toList(),
                                    json.encode(widget.monthList.map((e) => e['MName']).toList()),
                                  );
                                },
                                child: Container(
                                  width: tabWidth*0.33,
                                  height: 50,
                                  child: Center(
                                      child: Text("Month",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.grey),)
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap:(){

                                  setState(() {

                                    position=tabWidth*0.66;
                                  });
                                  db.getSaleMaterialDetail(
                                    widget.yearList.map((e) => e['TotalSale']).toList(),
                                    json.encode(widget.yearList.map((e) => e['Year']).toList()),
                                  );
                                },
                                child: Container(
                                  width: tabWidth*0.33,
                                  height: 50,
                                  child: Center(
                                      child: Text("Year",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.grey),)
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      height: 250,
                      color: Color(0XFFFFFFFF),
                      width: SizeConfig.screenWidth,
                      margin:EdgeInsets.only(top: 55),
                      child: HighCharts(
                        data: db.salesMaterialApex,
                        isHighChart: false,
                        isLoad: db.isSaleMaterialChartLoad,
                      ),
                    )
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
}


