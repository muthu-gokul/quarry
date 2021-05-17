import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/notifier/purchaseNotifier.dart';
import 'package:quarry/notifier/reportNotifier.dart';
import 'package:quarry/notifier/reportsNotifier.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/pages/productionDetails/productionDetailsAddNew.dart';
import 'package:quarry/pages/purchaseDetails/purchaseAddNew.dart';
import 'package:quarry/pages/reports/salesReport/checkPDF.dart';
import 'package:quarry/pages/reports/salesReport/salesSettings.dart';
import 'package:quarry/pages/sale/saleGrid.dart';
import 'package:quarry/pages/supplierDetail/supplierAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/staticColumnScroll/reportDataTable.dart';
import 'package:quarry/widgets/staticColumnScroll/reportDataTableWithoutModel.dart';

import 'reportSettings.dart';


class ReportGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  ReportGrid({this.drawerCallback});
  @override
  ReportGridState createState() => ReportGridState();
}

class ReportGridState extends State<ReportGrid> with TickerProviderStateMixin{

  bool showEdit=false;
  int selectedIndex;

  @override
  void initState() {
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
          child: Consumer<ReportNotifier>(
            builder: (context,rn,child)=>  Stack(
              children: [
                //Image
                Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  child: Column(
                    children: [
                      Opacity(
                        opacity:0.8,
                        child: Container(
                          width: double.maxFinite,
                          height: 170,


                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/svg/gridHeader/reportsHeader.jpg",),
                                  fit: BoxFit.cover
                              ),

                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: SizeConfig.screenWidth,
                //  color: AppTheme.yellowColor,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: widget.drawerCallback,
                        child: NavBarIcon(),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 20,
                        width: SizeConfig.screenWidth*0.38,
                        child: FittedBox(
                          child: Text("${rn.reportHeader}",
                            style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                          ),
                        ),
                      ),

                      Spacer(),



                      Container(
                        //height: 30,
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          //     color: Colors.white
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,color: AppTheme.bgColor,size: 14,),
                            SizedBox(width: 5,),
                            rn.picked.isNotEmpty?Text("${DateFormat('dd-MM-yyyy').format(rn.picked[0])} - ${DateFormat('dd-MM-yyyy').format(rn.picked[1])}",
                              style: TextStyle(fontFamily: 'RR',fontSize: 12,color: AppTheme.bgColor),
                            ):Container(),
                          ],
                        ),
                      ),

                      SizedBox(width: SizeConfig.width10,),


                    ],
                  ),
                ),


                Container(
                    margin: EdgeInsets.only(top: 50),
                    padding: EdgeInsets.only(left:5,bottom:25,right: 5),
                   // color: AppTheme.yellowColor,
                    height: 110,
                    alignment: Alignment.topCenter,

                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        ReportHeader(
                          title: '${rn.totalReportTitle}',
                          value:rn.totalReport,
                        ),
                        ReportHeader(
                          title: '${rn.totalReportQtyTitle}',
                          value:rn.totalReportQty,

                        ),
                        ReportHeader(
                          title: '${rn.totalReportAmountTitle}',
                          value: rn.totalReportAmount,
                        ),
                      ],
                    )
                ),


                //dataTable
                ReportDataTable2(
                  topMargin: 140,
                  gridBodyReduceHeight: 260,
                  selectedIndex: selectedIndex,
                  gridData: rn.reportsGridDataList,
                  gridDataRowList: rn.reportsGridColumnList,
                  func: (index){
                    if(selectedIndex==index){
                      setState(() {
                        selectedIndex=-1;
                        showEdit=false;
                      });

                    }
                    else{
                      setState(() {
                        selectedIndex=index;
                        showEdit=true;
                      });
                    }
                  },
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
                                  checkpdf(context,rn.reportHeader,DateFormat('dd-MM-yyyy').format(rn.picked[0]),DateFormat('dd-MM-yyyy').format(rn.picked[1]),rn.reportsGridColumnList,rn.reportsGridDataList);
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
                                        rn.ReportsDbHit(context, rn.TypeName);
                                      });
                                    }
                                    else if(picked1!=null && picked1.length ==1){
                                      setState(() {
                                        rn.picked=picked1;
                                        rn.picked.add(picked1[0]);
                                        rn.ReportsDbHit(context, rn.TypeName);
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
                                GestureDetector(onTap: ()async{
                                  var excel = Excel.createExcel();
                                  Sheet sheetObject = excel['${rn.reportHeader}'];

                                  List<String> dataList = ["${DateFormat('dd-MM-yyyy').format(rn.picked[0])} to ${DateFormat('dd-MM-yyyy').format(rn.picked[1])}",];

                                  sheetObject.insertRowIterables(dataList, 0,);
                                  /* CellStyle cellStyle = CellStyle(backgroundColorHex: "#1AFF1A", fontFamily : getFontFamily(FontFamily.Calibri));

                                 cellStyle.underline = Underline.Single; // or Underline.Double


                                 var cell = sheetObject.cell(CellIndex.indexByString("A1"));
                                 cell.value = 8; // dynamic values support provided;
                                 cell.cellStyle = cellStyle;*/
                                  List<String> header=[];
                                  rn.reportsGridColumnList.forEach((element) {
                                    if(element.isActive){
                                      header.add(element.columnName);
                                    }
                                  });
                                  sheetObject.insertRowIterables(header, 1,);

                                  List<String> body=[];
                                  for(int i=0;i<rn.reportsGridDataList.length;i++){
                                    body.clear();
                                    rn.reportsGridColumnList.forEach((element) {
                                      if(element.isActive){
                                        if(element.isDate){
                                          body.add(rn.reportsGridDataList[i][element.columnName]!=null?DateFormat('dd-MM-yyyy').format(DateTime.parse(rn.reportsGridDataList[i][element.columnName]))
                                          :"");
                                        }
                                        else{
                                          body.add(rn.reportsGridDataList[i][element.columnName].toString());
                                        }
                                      }
                                    });
                                    sheetObject.insertRowIterables(body, i+2,);
                                  }



                                  final String dirr ='/storage/emulated/0/quarry/reports';

                                  String filename="${rn.reportHeader}";
                                  await Directory('/storage/emulated/0/quarry/reports').create(recursive: true);
                                  final String path = '$dirr/$filename.xlsx';


                                  final File file = File(path);

                                  await file.writeAsBytes(await excel.encode()).then((value) async {
                                    CustomAlert().billSuccessAlert(context, "", "Successfully Downloaded @ \n\n Internal Storage/quarry/reports/$filename.xlsx", "", "");

                                  });
                                },
                                  child: SvgPicture.asset("assets/svg/excel.svg",width: 30,height: 30,),

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
      pageBuilder: (context, animation, secondaryAnimation) => ReportSettings(),
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
      height: 85,
      width: SizeConfig.screenWidth*0.31,
      padding: EdgeInsets.only(left: 5,right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppTheme.bgColor
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(child: Text(title??" ",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.white,letterSpacing: 0.1),)),
          SizedBox(height: 5,),
          FittedBox(
              fit: BoxFit.contain,
              child: Text("${value??" "}",style:TextStyle(fontFamily: 'RM',fontSize: 18,color: Colors.yellow),)),

        ],
      ),
    );
  }
}
