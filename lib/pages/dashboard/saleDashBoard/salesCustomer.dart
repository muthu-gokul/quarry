
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

class SalesCustomer extends StatefulWidget {

  List<dynamic>? customerList;
  double? totalAmount;
  String? paymentType;
  Color? color;
  SalesCustomer({this.customerList,this.paymentType,this.totalAmount,this.color});
  @override
  _SalesCustomerState createState() => _SalesCustomerState();
}

class _SalesCustomerState extends State<SalesCustomer> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;
  List<DateTime> picked=[];
  int selIndex=-1;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Consumer<DashboardNotifier>(
        builder:(ctx,db,c)=> Stack(
          children: [
            NestedScrollView(
              physics: NeverScrollableScrollPhysics(),
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
                             // width: SizeConfig.screenWidth*0.57,
                              padding:EdgeInsets.only(left: 10,right: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color:  widget.color
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
                                  SizedBox(width: 10,),
                                  Column(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Text("${formatCurrency.format(widget.totalAmount??0.0)}",
                                      style: TextStyle(fontFamily: 'RM',fontSize: 14,color: AppTheme.bgColor),
                                      ),
                                      SizedBox(height: 2,),
                                      Text("${widget.paymentType} Payment",style: TextStyle(fontFamily: 'RM',fontSize: 9,color: AppTheme.bgColor),),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 20,)
                          ],
                        ),
                      ),
                    ],
                 //   expandedHeight: 300.0,
                    floating: false,
                    pinned: true,
                  /*  flexibleSpace: FlexibleSpaceBar(
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
                    ),*/
                  ),
                ];
              },
              body: Container(
                width: SizeConfig.screenWidth,
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(top: 0),
                padding: EdgeInsets.only(top: 30,bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  color: Color(0xFFF6F7F9),
                ),
                child: ListView.builder(
                  itemCount: widget.customerList!.length,
                  itemBuilder: (ctx,i){
                    return Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                      ),
                      child: Row(
                        children: [
                          Text("${widget.customerList![i]['CustomerName']??""} / ",style: TextStyle(fontFamily: 'RR',color: Color(0xFFBDBCBD),fontSize: 14),),
                          Text("${formatCurrency.format(widget.customerList![i]['GrandTotalAmount']??0.0)}",style: TextStyle(fontFamily: 'RM',color: Color(0xFF999999),fontSize: 14),),
                        ],
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
