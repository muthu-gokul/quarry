import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/notifier/purchaseNotifier.dart';
import 'package:quarry/notifier/reportsNotifier.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/pages/productionDetails/productionDetailsAddNew.dart';
import 'package:quarry/pages/purchaseDetails/purchaseAddNew.dart';
import 'package:quarry/pages/reports/salesReport/salesSettings.dart';
import 'package:quarry/pages/sale/saleGrid.dart';
import 'package:quarry/pages/supplierDetail/supplierAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;


class SalesReportGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  SalesReportGrid({this.drawerCallback});
  @override
  SalesReportGridState createState() => SalesReportGridState();
}

class SalesReportGridState extends State<SalesReportGrid> with TickerProviderStateMixin{

  bool showEdit=false;
  int selectedIndex;


  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;

  @override
  void initState() {
    header.addListener(() {
      if(body.offset!=header.offset){
        body.jumpTo(header.offset);
      }
      if(header.offset==0){
        setState(() {
          showShadow=false;
        });
      }
      else{
        if(!showShadow){
          setState(() {
            showShadow=true;
          });
        }
      }
    });

    body.addListener(() {
      if(header.offset!=body.offset){
        header.jumpTo(body.offset);
      }
    });

    verticalLeft.addListener(() {
      if(verticalRight.offset!=verticalLeft.offset){
        verticalRight.jumpTo(verticalLeft.offset);
      }
    });

    verticalRight.addListener(() {
      if(verticalLeft.offset!=verticalRight.offset){
        verticalLeft.jumpTo(verticalRight.offset);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<ReportsNotifier>(
            builder: (context,rn,child)=>  Stack(
              children: [
                Container(
                  height: 50,
                  width: SizeConfig.screenWidth,
                  color: AppTheme.yellowColor,
                  child: Row(
                    children: [
                      IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                      SizedBox(width: SizeConfig.width20,),
                      Text("Sales Report",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                      ),


                    ],
                  ),
                ),


                Container(
                    margin: EdgeInsets.only(top: 50),
                    padding: EdgeInsets.only(left:5,bottom:25,right: 5),
                    color: AppTheme.yellowColor,
                    height: 110,
                    alignment: Alignment.topCenter,

                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [


                        ReportHeader(
                          title: 'Total Sale',
                          value:rn.totalSale,

                        ),
                        ReportHeader(
                          title: 'Sale Quantity',
                          value:rn.totalSaleQty,

                        ),
                        ReportHeader(
                          title: 'Sale Amount',
                          value: rn.totalSaleAmount,

                        ),



                      ],
                    )
                ),

                Container(
                    height: SizeConfig.screenHeight-140,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.only(top: 140),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: AppTheme.gridbodyBgColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                    ),
                    child: Stack(
                      children: [

                        //Scrollable
                        Positioned(
                          left:149,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: SizeConfig.screenWidth-150,
                                color: showShadow? AppTheme.bgColor.withOpacity(0.8):AppTheme.bgColor,
                                child: SingleChildScrollView(
                                  controller: header,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: rn.salesReportGridCol.asMap().
                                      map((i, value) => MapEntry(i, i==0?Container():
                                      value.isActive?Container(
                                          alignment: Alignment.center,
                                          width: 150,
                                          child: Text(value.columnName,style: AppTheme.TSWhite166,)
                                      ):Container()
                                      )).values.toList()
                                  ),
                                ),

                              ),
                              Container(
                                height: SizeConfig.screenHeight-260,
                                width: SizeConfig.screenWidth-150,
                                alignment: Alignment.topCenter,
                                color: AppTheme.gridbodyBgColor,
                                child: SingleChildScrollView(
                                  controller: body,
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    height: SizeConfig.screenHeight-260,
                                    alignment: Alignment.topCenter,
                                    color: AppTheme.gridbodyBgColor,
                                    child: SingleChildScrollView(
                                      controller: verticalRight,
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                          children:rn.filterSalesReportGridList.asMap().
                                          map((i, value) => MapEntry(
                                              i,InkWell(
                                            onTap: (){
                                              setState(() {

                                                if(selectedIndex==i){
                                                  selectedIndex=-1;
                                                  showEdit=false;
                                                } else{
                                                  selectedIndex=i;
                                                  showEdit=true;
                                                }


                                              });
                                            },
                                            child: Container(

                                              decoration: BoxDecoration(
                                                color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,
                                              ),
                                              height: 60,
                                              // padding: EdgeInsets.only(top: 20,bottom: 20),
                                              child: Row(
                                                children: [


                                                  rn.salesReportGridCol[1].isActive?Container(
                                                    alignment: Alignment.center,
                                                    // padding: EdgeInsets.only(left: 20,right: 20),
                                                    width: 150,
                                                    child: Text("${DateFormat("dd-MM-yyyy").format(value.createdDate)}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                    ),

                                                  ):Container(),
                                                  rn.salesReportGridCol[2].isActive?Container(
                                                    alignment: Alignment.center,
                                                    width: 150,
                                                    child: Text("${value.materialName}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                    ),
                                                  ):Container(),

                                                  rn.salesReportGridCol[3].isActive?Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    child: Text("${value.outputMaterialQty}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                    ),
                                                  ):Container(),
                                                  rn.salesReportGridCol[4].isActive?Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    child: Text("${value.outputQtyAmount??0.0}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                    ),
                                                  ):Container(),
                                                  rn.salesReportGridCol[5].isActive?Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    child: Text("${value.customerName}",
                                                      style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                    ),
                                                  ):Container(),
                                                  rn.salesReportGridCol[6].isActive?Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    child: FittedBox(
                                                      child: Text("${value.plantName}",
                                                        style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                                      ),
                                                    ),
                                                  ):Container(),


                                                ],
                                              ),
                                            ),
                                          )
                                          )
                                          ).values.toList()
                                      ),
                                    ),


                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                        //not Scrollable
                        Positioned(
                          left: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 150,
                                color: AppTheme.bgColor,
                                alignment: Alignment.center,
                                child: Text("${rn.salesReportGridCol[0].columnName}",style: AppTheme.TSWhite166,),

                              ),
                              Container(
                                height: SizeConfig.screenHeight-260,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                    color:AppTheme.gridbodyBgColor,
                                    boxShadow: [
                                      showShadow?  BoxShadow(
                                        color: AppTheme.addNewTextFieldText.withOpacity(0.3),
                                        spreadRadius: 0,
                                        blurRadius: 15,
                                        offset: Offset(-3, -8), // changes position of shadow
                                      ):BoxShadow(color: Colors.transparent)
                                    ]
                                ),
                                child: Container(
                                  height: SizeConfig.screenHeight-260,
                                  alignment: Alignment.topCenter,

                                  child: SingleChildScrollView(
                                    controller: verticalLeft,
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                        children: rn.filterSalesReportGridList.asMap().
                                        map((i, value) => MapEntry(
                                            i,InkWell(
                                          onTap: (){
                                            setState(() {

                                              if(selectedIndex==i){
                                                selectedIndex=-1;
                                                showEdit=false;
                                              } else{
                                                selectedIndex=i;
                                                showEdit=true;
                                              }


                                            });
                                          },
                                          child:  Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: selectedIndex==i?AppTheme.yellowColor:AppTheme.gridbodyBgColor,

                                            ),
                                            height: 60,
                                            //  padding: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 20),
                                            width: 150,
                                            child: Text("${value.saleNumber}",
                                              style:selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColorTS,
                                            ),
                                          ),
                                        )
                                        )
                                        ).values.toList()


                                    ),
                                  ),


                                ),
                              ),
                            ],
                          ),
                        ),




                      ],
                    )




                ),





                //bottomNav
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: 70,

                    decoration: BoxDecoration(
                        color: AppTheme.gridbodyBgColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.gridbodyBgColor,
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: Offset(0, -20), // changes position of shadow
                          )
                        ]
                    ),
                    child: Stack(

                      children: [
                        Container(
                          decoration: BoxDecoration(

                          ),
                          margin:EdgeInsets.only(top: 0),
                          child: CustomPaint(
                            size: Size( SizeConfig.screenWidth, 65),
                            //  painter: RPSCustomPainter(),
                            painter: RPSCustomPainter3(),
                          ),
                        ),
                        Center(
                          heightFactor: 0.5,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){

                            },
                            child: Container(

                              height: SizeConfig.width50,
                              width: SizeConfig.width50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.yellowColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.yellowColor.withOpacity(0.4),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(1, 8), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(Icons.add,size: SizeConfig.height30,color: AppTheme.bgColor,),
                              ),
                            ),
                          ),
                        ),
                  Container(
                    height: 80,
                    width: SizeConfig.screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(icon: Icon(Icons.picture_as_pdf,color: Colors.grey,), onPressed: (){

                        }),
                        GestureDetector(
                          onTap: () async {

                          final List<DateTime>  picked1 = await DateRagePicker.showDatePicker(
                          context: context,
                          initialFirstDate: new DateTime.now(),
                          initialLastDate: (new DateTime.now()),
                          firstDate: rn.dateTime,
                          lastDate: (new DateTime.now())
                           );
                          if (picked1 != null && picked1.length == 2) {
                                 setState(() {
                                 rn.picked=picked1;
                                  rn.ReportsDbHit(context, "SaleReport");
                        });
                      }
                      else if(picked1!=null && picked1.length ==1){
                        setState(() {
                          rn.picked=picked1;
                          rn.ReportsDbHit(context, "SaleReport");
                          // rn.reportDbHit(widget.UserId.toString(), widget.OutletId, DateFormat("dd-MM-yyyy").format( picked[0]).toString(), DateFormat("dd-MM-yyyy").format( picked[0]).toString(),"Itemwise Report", context);
                        });
                      }
                    },
                    child: Container(
                      height: SizeConfig.height50,
                      width: SizeConfig.height50,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color:Color(0xFF5E5E60),
                      ),
                      child: Center(
                        child: Icon(Icons.date_range_rounded),
                        // child:  SvgPicture.asset(
                        //   'assets/reportIcons/${rn.reportIcons[index]}.svg',
                        //   height:25,
                        //   width:25,
                        //   color: Colors.white,
                        // )
                      ),
                    ),
                  ),
                        SizedBox(width: SizeConfig.width80,),
                        IconButton(icon: Icon(Icons.settings,color: Colors.grey,), onPressed: (){
                          Navigator.push(context, _createRouteReportSettings());
                        }),
                        GestureDetector(
                          onTap: (){

                          },
                          child: IconButton(icon: Icon(Icons.share,color: Colors.grey,), onPressed: (){

                          }),
                        ),
                      ],
                    ),
                  )
                      ]
                    ),
                  ),
                ),




                Container(

                  height: rn.ReportLoader? SizeConfig.screenHeight:0,
                  width: rn.ReportLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                  ),

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Route _createRouteReportSettings() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SaleReportSettings(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ProductionDetailAddNew(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}

class ReportHeader extends StatelessWidget {
  String title;
  dynamic value;
/*  double qty;
  String unit;*/

  ReportHeader({this.title,this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.height80,
      width: SizeConfig.screenWidth*0.31,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppTheme.bgColor
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("$title",style: TextStyle(fontFamily: 'RR',fontSize: 12,color: Colors.white,letterSpacing: 0.1),),
          SizedBox(height: 5,),
          FittedBox(
              fit: BoxFit.contain,
              child: Text("$value",style:TextStyle(fontFamily: 'RM',fontSize: 20,color: Colors.yellow),)),

        ],
      ),
    );
  }
}
