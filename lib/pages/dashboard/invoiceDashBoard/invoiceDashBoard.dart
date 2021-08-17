
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/pages/dashboard/invoiceDashBoard/invoiceDetails.dart';
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
class InvoiceDashBoard extends StatefulWidget {

  VoidCallback? drawerCallback;
  InvoiceDashBoard({this.drawerCallback});
  @override
  _InvoiceDashBoardState createState() => _InvoiceDashBoardState();
}

class _InvoiceDashBoardState extends State<InvoiceDashBoard> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;
  List<DateTime?> picked=[];
  int selIndex=-1;
  @override
  void initState() {
    Provider.of<DashboardNotifier>(context,listen: false).DashBoardDbHit(context,
        "Invoice",
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString(),
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
    );

    WidgetsBinding.instance!.addPostFrameCallback((_){
      silverController=new ScrollController();

      setState(() {
        silverBodyTopMargin=0;
      });

      silverController!.addListener(() {
        if(silverController!.offset>150){
          setState(() {
            silverBodyTopMargin=50-(-(silverController!.offset-200));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController!.offset<170){
          setState(() {
            silverBodyTopMargin=0;
          });
        }
      });
    });
    super.initState();
  }
  double? tabWidth;
  double position=5;

  PageController pageController=new PageController(initialPage: 0);
  int page=0;


  @override
  Widget build(BuildContext context) {
    tabWidth=SizeConfig.screenWidth!-40;
    return Stack(
      children: [
        Scaffold(
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
                    size: Size( SizeConfig.screenWidth!, 65),
                    painter: RPSCustomPainter3(),
                  ),
                ),
                Container(
                  width:  SizeConfig.screenWidth,
                  height: 65,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            page=0;
                          });
                          pageController.animateToPage(page, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                        },
                        child: Container(
                          width: SizeConfig.screenWidth!*0.3,
                          height: 60,
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: Text("Customer",style: TextStyle(fontFamily: 'RM',color: page==0?AppTheme.bgColor:AppTheme.bgColor.withOpacity(0.5),fontSize: 16),),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            page=1;
                          });
                          pageController.animateToPage(page, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                        },
                        child: Container(
                          width: SizeConfig.screenWidth!*0.3,
                          height: 60,
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: Text("Supplier",style: TextStyle(fontFamily: 'RM',color: page==1?AppTheme.bgColor:AppTheme.bgColor.withOpacity(0.5),fontSize: 16),),
                        ),
                      ),
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
                                            "Invoice",
                                            DateFormat("yyyy-MM-dd").format(picked[0]!).toString(),
                                            DateFormat("yyyy-MM-dd").format(picked[1]!).toString()
                                        );
                                      }
                                      else if(picked1!=null && picked1.length ==1){
                                        setState(() {
                                          picked=picked1;
                                        });
                                        db.DashBoardDbHit(context,
                                            "Invoice",
                                            DateFormat("yyyy-MM-dd").format(picked[0]!).toString(),
                                            DateFormat("yyyy-MM-dd").format(picked[0]!).toString()
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
                      controller: pageController,
                      onPageChanged: (i){
                        setState(() {
                          page=i;
                        });
                      },
                      children: [
                          Container(
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenHeight,
                            color: Colors.transparent,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),
                                  Text("${db.totalCustomerInv}",style: TextStyle(fontFamily: 'RM',fontSize: 28,color: Color(0xFF525D73)),),
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
                                    child: Text(picked.length==1?"${DateFormat("dd/MM/yyyy").format(picked[0]!)}":
                                    picked.length==2?"${DateFormat("dd/MM/yyyy").format(picked[0]!)} - ${DateFormat("dd/MM/yyyy").format(picked[1]!)}":"Today",
                                      style: TextStyle(color:AppTheme.yellowColor,fontFamily: 'RM',fontSize: 14),
                                    ),
                                  ),
                                  Container(
                                    height: 300,
                                    color: Colors.transparent,
                                    child: HighCharts(
                                      data: db.highPiedonut,
                                      isHighChart: true,
                                      isHighChartExtraParam: true,
                                      isLoad: db.isCustomerInvLoad,
                                    ),
                                  ),

                                  InvoiceList(value: db.customerInvPaidPer, totalInvoice: db.customerInvPaid, title: "Paid",ontap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>InvoiceDetails(title: "Customer Paid Invoice",
                                    list: db.customerInvListT2.where((element) => element['Status']=='Paid').toList(),
                                        date: picked.length==1?"${DateFormat("dd/MM/yyyy").format(picked[0]!)}":
                                        picked.length==2?"${DateFormat("dd/MM/yyyy").format(picked[0]!)} - ${DateFormat("dd/MM/yyyy").format(picked[1]!)}":"Today",
                                        textColor: Color(0xFF78AD97),
                                        statusColor: Color(0xFFC6E7DB),
                                        counter: db.customerInvCounterT1,
                                        name: 'CustomerName',
                                      )
                                     )
                                    );
                                  },),
                                  InvoiceList(value: db.customerInvUnPaidPer, totalInvoice: db.customerInvUnPaid, title: "Unpaid",ontap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>InvoiceDetails(title: "Customer Unpaid Invoice",
                                      list: db.customerInvListT2.where((element) => element['Status']=='Unpaid').toList(),
                                      date: picked.length==1?"${DateFormat("dd/MM/yyyy").format(picked[0]!)}":
                                      picked.length==2?"${DateFormat("dd/MM/yyyy").format(picked[0]!)} - ${DateFormat("dd/MM/yyyy").format(picked[1]!)}":"Today",
                                      textColor: Color(0xFFC27573),
                                      statusColor: Color(0xFFEFC2C3),
                                      counter: db.customerInvCounterT1,
                                      name: 'CustomerName',
                                    )
                                    )
                                    );
                                  },),
                                  InvoiceList(value: db.customerInvPartiallyPaidPer, totalInvoice: db.customerInvPartiallyPaid, title: "Partially",ontap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>InvoiceDetails(title: "Customer Partially Paid Invoice",
                                      list: db.customerInvListT2.where((element) => element['Status']=='Partially Paid').toList(),
                                      date: picked.length==1?"${DateFormat("dd/MM/yyyy").format(picked[0]!)}":
                                      picked.length==2?"${DateFormat("dd/MM/yyyy").format(picked[0]!)} - ${DateFormat("dd/MM/yyyy").format(picked[1]!)}":"Today",
                                      textColor: Color(0xFFF1AC42),
                                      statusColor: Color(0xFFF6D148).withOpacity(0.5),
                                      counter: db.customerInvCounterT1,
                                      name: 'CustomerName',
                                    )
                                    )
                                    );
                                  },),
                                ],
                              ),
                            ),
                          ),

                          //Supplier
                          Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.screenHeight,
                          color: Colors.transparent,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Text("${db.totalSupplierInv}",style: TextStyle(fontFamily: 'RM',fontSize: 28,color: Color(0xFF525D73)),),
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
                                  child: Text(picked.length==1?"${DateFormat("dd/MM/yyyy").format(picked[0]!)}":
                                  picked.length==2?"${DateFormat("dd/MM/yyyy").format(picked[0]!)} - ${DateFormat("dd/MM/yyyy").format(picked[1]!)}":"Today",
                                    style: TextStyle(color:AppTheme.yellowColor,fontFamily: 'RM',fontSize: 14),
                                  ),
                                ),
                                Container(
                                  height: 300,
                                  color: Colors.transparent,
                                  child: HighCharts(
                                    data: db.highPiedonut2,
                                    isHighChart: true,
                                    isHighChartExtraParam: true,
                                    isLoad: db.issupplierInvLoad,
                                  ),
                                ),

                                InvoiceList(value: db.supplierInvPaidPer, totalInvoice: db.supplierInvPaid, title: "Paid",ontap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>InvoiceDetails(title: "Supplier Paid Invoice",
                                    list: db.supplierInvListT6.where((element) => element['Status']=='Paid').toList(),
                                    date: picked.length==1?"${DateFormat("dd/MM/yyyy").format(picked[0]!)}":
                                    picked.length==2?"${DateFormat("dd/MM/yyyy").format(picked[0]!)} - ${DateFormat("dd/MM/yyyy").format(picked[1]!)}":"Today",
                                    textColor: Color(0xFF78AD97),
                                    statusColor: Color(0xFFC6E7DB),
                                    counter: db.supplierInvCounterT5,
                                    name: 'SupplierName',
                                  )
                                  )
                                  );
                                },),
                                InvoiceList(value: db.supplierInvUnPaidPer, totalInvoice: db.supplierInvUnPaid, title: "Unpaid",ontap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>InvoiceDetails(title: "Supplier Unpaid Invoice",
                                    list: db.supplierInvListT6.where((element) => element['Status']=='Unpaid').toList(),
                                    date: picked.length==1?"${DateFormat("dd/MM/yyyy").format(picked[0]!)}":
                                    picked.length==2?"${DateFormat("dd/MM/yyyy").format(picked[0]!)} - ${DateFormat("dd/MM/yyyy").format(picked[1]!)}":"Today",
                                    textColor: Color(0xFFC27573),
                                    statusColor: Color(0xFFEFC2C3),
                                    counter: db.supplierInvCounterT5,
                                    name: 'SupplierName',
                                  )
                                  )
                                  );
                                },),
                                InvoiceList(value: db.supplierInvPartiallyPaidPer, totalInvoice: db.supplierInvPartiallyPaid, title: "Partially",ontap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>InvoiceDetails(title: "Supplier Partially Paid Invoice",
                                    list: db.supplierInvListT6.where((element) => element['Status']=='Partially Paid').toList(),
                                    date: picked.length==1?"${DateFormat("dd/MM/yyyy").format(picked[0]!)}":
                                    picked.length==2?"${DateFormat("dd/MM/yyyy").format(picked[0]!)} - ${DateFormat("dd/MM/yyyy").format(picked[1]!)}":"Today",
                                    textColor: Color(0xFFF1AC42),
                                    statusColor: Color(0xFFF6D148).withOpacity(0.5),
                                    counter: db.supplierInvCounterT5,
                                    name: 'SupplierName',
                                  )
                                  )
                                  );
                                },),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),



              ],
            ),
          ),
        ),
        Consumer<DashboardNotifier>(
          builder:(ctx,db,i)=> Loader(
            isLoad: db.isLoad,
          ),
        )
      ],
    );
  }


  counter(Color color,String title,dynamic value){
    return  Container(
      height: SizeConfig.screenWidth!*0.4,
      width: SizeConfig.screenWidth!*0.4,
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


class InvoiceList extends StatelessWidget {
  double value;
  int totalInvoice;
  String title;
  VoidCallback ontap;
  InvoiceList({required this.value,required this.totalInvoice,required this.title,required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
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
              value: value/100,
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
                  child: Text("${value.toStringAsFixed(1)}%",textAlign: TextAlign.center,style: TextStyle(color: Color(0xFF7D7D7D),fontFamily: 'RB'),)),
            ),
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$title Invoice",textAlign: TextAlign.center,style: TextStyle(color: Color(0xFF525D73),fontFamily: 'RB'),),
              SizedBox(height: 3,),
              Text("$totalInvoice invoice",textAlign: TextAlign.center,style: TextStyle(color: Color(0xFF7D7D7D).withOpacity(0.8),fontFamily: 'RR',fontSize: 11),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: ontap,
            child: Container(
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
          ),
          SizedBox(width: 20,)
        ],
      ),
    );
  }
}

