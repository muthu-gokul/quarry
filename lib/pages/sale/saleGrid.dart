import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/material/processAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/pages/vendor/vendorLocAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/reportpdf.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable.dart';



class SaleGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  SaleGrid({this.drawerCallback});
  @override
  _SaleGridState createState() => _SaleGridState();
}

class _SaleGridState extends State<SaleGrid> {
  // int selectedIndex=-1;
  bool isOpen=false;


  bool showEdit=false;
  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;

  List<String> gridDataRowList=["SaleDate","SaleNumber","VehicleNumber","MaterialName","RoundedTotalAmount","CustomerName"];


  @override
  void didChangeDependencies() {
    print("SALE IMIY DE");
    super.didChangeDependencies();
  }

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
  DateTime dateTime=DateTime.parse('2021-01-01');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<QuarryNotifier>(
            builder: (context,qn,child)=>  Stack(
              children: [
                Container(
                  height: 160,
                  width: SizeConfig.screenWidth,
                   color: AppTheme.yellowColor,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: widget.drawerCallback,
                            child: NavBarIcon(),
                          ),
                          Text("Sales Detail",
                            style: AppTheme.appBarTS
                          ),
                          Spacer(),
                          Theme(
                            data: ThemeData(
                              accentColor: Colors.blue,
                            ),
                            child: GestureDetector(
                              onTap: () async {

                                final List<DateTime>  picked1 = await DateRagePicker.showDatePicker(
                                    context: context,
                                    initialFirstDate: new DateTime.now(),
                                    initialLastDate: (new DateTime.now()),
                                    firstDate: dateTime,
                                    lastDate: (new DateTime.now())
                                );
                                if (picked1 != null && picked1.length == 2) {
                                  setState(() {
                                    qn.picked=picked1;
                                    qn.GetSaleDetailDbhit(context);
                                    // rn.reportDbHit(widget.UserId.toString(), widget.OutletId, DateFormat("dd-MM-yyyy").format( picked[0]).toString(), DateFormat("dd-MM-yyyy").format( picked[1]).toString(),"Itemwise Report", context);
                                  });
                                }
                                else if(picked1!=null && picked1.length ==1){
                                  setState(() {
                                    qn.picked=picked1;
                                    qn.GetSaleDetailDbhit(context);
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
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5,right: 5,),

                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [


                                SaleReportHeader(
                                  title: 'Sales',
                                  value: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].Sale??0.00:0.00,
                                  qty: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].TotalSaleQuantity??0:0,
                                  unit: "Ton",

                                ),
                                SaleReportHeader(
                                  title: 'M Sand',
                                  value: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].MSand??0.00:0.00,
                                  qty: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].MSandQuantity??0:0,
                                  unit: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].MSandUnit??"":"",
                                ),
                              SaleReportHeader(
                                title: 'P Sand',
                                value: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].PSand??0.00:0.00,
                                qty: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].PSandQuantity??0:0,
                                unit: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].PSandUnit??"":"",
                              ),



                            ],
                          )
                      )

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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
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
                                width: SizeConfig.screenWidth-149,
                                color: showShadow? AppTheme.bgColor.withOpacity(0.8):AppTheme.bgColor,
                                child: SingleChildScrollView(
                                  controller: header,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: qn.saleDetailsGridCol.asMap().
                                      map((i, value) => MapEntry(i, i==0?Container():
                                      Container(
                                          alignment: Alignment.center,
                                          width: 150,
                                          child: Text(value,style: AppTheme.TSWhite166,)
                                      )
                                      )).values.toList()
                                  ),
                                ),

                              ),
                              Container(
                                height: SizeConfig.screenHeight-260,
                                width: SizeConfig.screenWidth-149,
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
                                          children:qn.saleDetailsGrid.asMap().
                                          map((i, value) => MapEntry(
                                              i,InkWell(
                                            onTap: (){

                                              setState(() {
                                                if(qn.selectedIndex==-1 || qn.selectedIndex!=i){
                                                  qn.selectedIndex=i;
                                                  if(qn.saleDetailsGrid[i].SaleStatus=='Open'){
                                                    isOpen=true;
                                                  }else{
                                                    isOpen=false;
                                                  }
                                                }
                                                else {
                                                  qn.selectedIndex=-1;
                                                }
                                              });


                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(bottom:i==qn.saleDetailsGrid.length-1?70: 0),
                                              decoration: BoxDecoration(
                                                border: AppTheme.gridBottomborder,
                                                color: qn.selectedIndex==i?AppTheme.yellowColor:value.SaleStatus=='Open'?Colors.red.withOpacity(0.2):Colors.green.withOpacity(0.2),
                                              ),
                                              height: 50,
                                              // padding: EdgeInsets.only(top: 20,bottom: 20),
                                              child: Row(
                                                children: [


                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 150,
                                                    child: Text("${value.SaleNumber}",
                                                      style: qn.selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                    ),
                                                  ),

                                                  Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    child: Text("${value.VehicleNumber}",
                                                      style: qn.selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    child: Text("${value.MaterialName}",
                                                      style: qn.selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                    ),
                                                  ),

                                                  Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    child: Text("${value.RoundedTotalAmount}",
                                                      style: qn.selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColor14,
                                                    ),
                                                  ),

                                                  Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    child: Text("${value.CustomerName??" "}",
                                                      style: qn.selectedIndex==i?AppTheme.bgColorTS:AppTheme.gridTextColor14,
                                                    ),
                                                  ),


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
                                child: Text("${qn.saleDetailsGridCol[0]}",style: AppTheme.TSWhite166,),

                              ),
                              Container(
                                height: SizeConfig.screenHeight-260,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                    color: AppTheme.gridbodyBgColor,
                                    boxShadow: [
                                      showShadow?  BoxShadow(
                                        color: AppTheme.addNewTextFieldText.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 15,
                                        offset: Offset(0, -8), // changes position of shadow
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
                                        children: qn.saleDetailsGrid.asMap().
                                        map((i, value) => MapEntry(
                                            i,InkWell(
                                          onTap: (){
                                            setState(() {
                                              if(qn.selectedIndex==-1 || qn.selectedIndex!=i){
                                                qn.selectedIndex=i;
                                                if(qn.saleDetailsGrid[i].SaleStatus=='Open'){
                                                  isOpen=true;
                                                }else{
                                                  isOpen=false;
                                                }
                                              }
                                              else {
                                                qn.selectedIndex=-1;
                                              }
                                            });
                                          },
                                          child:  Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(bottom:i==qn.saleDetailsGrid.length-1?70: 0),
                                            decoration: BoxDecoration(
                                              border: AppTheme.gridBottomborder,
                                              color:  qn.selectedIndex==i?AppTheme.yellowColor:value.SaleStatus=='Open'?Colors.red.withOpacity(0.2):Colors.green.withOpacity(0.2),
                                            ),
                                            height: 50,
                                            width: 150,
                                            child: Container(
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),

                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                //color:value.invoiceType=='Receivable'? Colors.green:AppTheme.red,
                                              ),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text("${value.SaleDate}",
                                                  //  style: qn.selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColorTS,
                                                  style: qn.selectedIndex==i?AppTheme.bgColorTS14:AppTheme.gridTextColor14,
                                                ),
                                              ),
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
                              painter: RPSCustomPainter3(),
                            ),
                          ),
                          Center(
                            heightFactor: 0.5,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: (){
                                qn.clearIsOpen();
                                qn.clearEmptyForm();
                                qn.UserDropDownValues(context);
                                qn.SalesDropDownValues(context);
                                Navigator.of(context).push(_createRouteFalse());
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
                                GestureDetector(
                                  onTap: (){

                                    if(qn.selectedIndex!=-1 && isOpen){
                                      print("EDit");
                                      Navigator.of(context).push(_createRoute());
                                      qn.editLoader();
                                      Timer(Duration(milliseconds: 300), (){
                                        qn.tabController.animateTo(1,duration: Duration(milliseconds: 300),curve: Curves.easeIn);
                                      });


                                    }


                                  },
                                  child: SvgPicture.asset("assets/svg/edit.svg",width: 30,height: 30,
                                    color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor:AppTheme.bgColor.withOpacity(0.5),),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    if(qn.selectedIndex!=-1 && !isOpen){
                                      print("pribt");
                                      qn.printClosedReport(context);
                                    }
                                  },
                                  child: SvgPicture.asset("assets/svg/print.svg",width: 30,height: 30,
                                    color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor.withOpacity(0.5):AppTheme.bgColor,),
                                ),


                                SizedBox(width: SizeConfig.width60,),
                                GestureDetector(
                                  onTap: (){
                                    if(qn.selectedIndex!=-1 && !isOpen){

                                      reportView(context, "muthugokul103031@gmail.com",qn.selectedIndex);
                                      print("pdf");
                                    }
                                  },
                                  child: SvgPicture.asset("assets/svg/pdf.svg",width: 30,height: 30,
                                    color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor.withOpacity(0.5):AppTheme.bgColor,),

                                ),
                                GestureDetector(
                                  onTap: (){
                                   /* if(qn.selectedIndex!=-1 && isOpen){
                                      print("delete");
                                      int saleid=qn.saleDetailsGrid[qn.selectedIndex].SaleId;
                                      setState(() {
                                        qn.selectedIndex=-1;
                                      });
                                      qn.DeleteSaleDetailDbhit(context, saleid).then((value){

                                      });
                                    }*/

                                  },
                                  child: SvgPicture.asset("assets/svg/delete.svg",width: 30,height: 30,color: AppTheme.bgColor.withOpacity(0.5),
                                //    color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor:AppTheme.bgColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]
                    ),
                  ),
                ),
                Positioned(
                    bottom: 70,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      child: Row(
                        children: [
                          Text("  Total Orders: ${qn.saleDetailsGrid.length}",style: TextStyle(fontSize: 16,color: AppTheme.bgColor,fontFamily: 'RR'),),
                          Spacer(),
                          Text("Open/Closed: ${qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].Open:"0"}/${qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].Closed:"0"}  ",
                            style: TextStyle(fontSize: 16,color: AppTheme.bgColor,fontFamily: 'RR'),),
                        ],
                      ),
                    )
                ),

             /*   Positioned(
                  bottom: 0,
                    child: Container(
                      height: SizeConfig.height60,
                      width: SizeConfig.screenWidth,

                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color:Colors.black.withOpacity(0.3),
                              offset: const Offset(0, -7.0),
                              blurRadius: 20.0,
                              spreadRadius: -10.0,
                            ),
                          ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                             GestureDetector(
                               onTap: (){

                                 if(qn.selectedIndex!=-1 && isOpen){
                                   print("EDit");
                                   Navigator.of(context).push(_createRoute());
                                   qn.editLoader();
                                   Timer(Duration(milliseconds: 300), (){
                                     qn.tabController.animateTo(1,duration: Duration(milliseconds: 300),curve: Curves.easeIn);
                                   });


                                 }


                               },
                               child: SvgPicture.asset("assets/svg/edit.svg",width: 30,height: 30,
                                 color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor:AppTheme.bgColor.withOpacity(0.5),),
                             ),
                             GestureDetector(
                               onTap: (){
                                 if(qn.selectedIndex!=-1 && !isOpen){
                                   print("pribt");
                                   qn.printClosedReport(context);
                                 }
                               },
                               child: SvgPicture.asset("assets/svg/print.svg",width: 30,height: 30,
                                 color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor.withOpacity(0.5):AppTheme.bgColor,),
                             ),


                          SizedBox(width: SizeConfig.width10,),
                          GestureDetector(
                            onTap: (){
                              if(qn.selectedIndex!=-1 && !isOpen){

                                reportView(context, "muthugokul103031@gmail.com",qn.selectedIndex);
                                print("pdf");
                              }
                            },
                            child: SvgPicture.asset("assets/svg/pdf.svg",width: 30,height: 30,
                              color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor.withOpacity(0.5):AppTheme.bgColor,),

                          ),
                          GestureDetector(
                            onTap: (){
                              if(qn.selectedIndex!=-1 && isOpen){
                                print("delete");
                                int saleid=qn.saleDetailsGrid[qn.selectedIndex].SaleId;
                                setState(() {
                                  qn.selectedIndex=-1;
                                });
                                qn.DeleteSaleDetailDbhit(context, saleid).then((value){

                                });
                              }

                            },
                            child: SvgPicture.asset("assets/svg/delete.svg",width: 30,height: 30,
                              color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor:AppTheme.bgColor.withOpacity(0.5),),
                          ),



                        ],
                      ),
                    )
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  // bottom: 20,
                  // right: 20,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      qn.clearIsOpen();
                      qn.clearEmptyForm();
                      qn.UserDropDownValues(context);
                      qn.SalesDropDownValues(context);
                      Navigator.of(context).push(_createRouteFalse());



                    },
                    child: Container(
                      margin: EdgeInsets.only(right: SizeConfig.width10,bottom: SizeConfig.height30),
                      height: SizeConfig.height70,
                      width: SizeConfig.height70,
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
                ),*/


                AnimatedPositioned(
                    bottom:showEdit? 0:-80,
                    child: Container(
                      height: 80,
                      width: SizeConfig.screenWidth,
                      color: AppTheme.bgColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: (){
                              // qn.updateCustomerEdit(true);
                              // setState(() {
                              //   showEdit=false;
                              //   qn.SS_selectCustomerId=qn.customersList[selectedIndex].CustomerId;
                              //   qn.customerName.text=qn.customersList[selectedIndex].CustomerName;
                              //   qn.customerContactNumber.text=qn.customersList[selectedIndex].CustomerContactNumber;
                              //   qn.customerGstNumber.text=qn.customersList[selectedIndex].CustomerGSTNumber;
                              //   qn.customerEmail.text=qn.customersList[selectedIndex].CustomerEmail;
                              //   qn.customerAddress.text=qn.customersList[selectedIndex].CustomerAddress;
                              //   qn.customerCity.text=qn.customersList[selectedIndex].CustomerCity;
                              //   qn.customerState.text=qn.customersList[selectedIndex].CustomerState;
                              //   qn.customerZipcode.text=qn.customersList[selectedIndex].CustomerZipCode;
                              // });
                              // Navigator.of(context).push(_createRoute());
                            },
                            child: Container(
                              height: 50,
                              width: SizeConfig.width150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppTheme.indicatorColor.withOpacity(0.3)
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset("assets/svg/edit.svg",height: 20,width: 20,color: AppTheme.yellowColor.withOpacity(0.3),),
                                    SizedBox(width: SizeConfig.width10,),
                                    Text("Edit",style: TextStyle(fontSize: 20,fontFamily: 'RR',color: Colors.white.withOpacity(0.3)),),


                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                showEdit=false;
                              });
                              CustomAlert(
                                  callback: (){
                                    Navigator.pop(context);
                                    qn.DeleteMasterDetailDbhit(context, qn.materialGridList[qn.selectedIndex].MaterialId);
                                  }

                              ).yesOrNoDialog(context, "", "Are you sure want to Delete?");
                            },
                            child: Container(
                              height: 50,
                              width: SizeConfig.width150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppTheme.indicatorColor
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Delete",style: TextStyle(fontSize: 20,fontFamily: 'RR',color: Colors.white),),
                                    SizedBox(width: SizeConfig.width10,),
                                    SvgPicture.asset("assets/svg/delete.svg",height: 20,width: 20,color: AppTheme.yellowColor,),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    curve: Curves.bounceOut,


                    duration: Duration(milliseconds:300)),


////////////////////////////////////// LOADER //////////////////////////
                Container(
                  height: qn.insertSaleLoader? SizeConfig.screenHeight:0,
                  width: qn.insertSaleLoader? SizeConfig.screenWidth:0,
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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SalesDetail(fromsaleGrid: true,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteFalse() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SalesDetail(fromsaleGrid: false,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}

class SaleReportHeader extends StatelessWidget {
  String title;
  double value;
  double qty;
  String unit;

  SaleReportHeader({this.title,this.value,this.qty,this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.height80,
      width: SizeConfig.screenWidth*0.31,
      /*argin: EdgeInsets.only(right: SizeConfig.width10),*/
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppTheme.bgColor
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(" $title",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white,letterSpacing: 0.1),),
          FittedBox(
              fit: BoxFit.contain,
              child: Text(" ₹ $value",style:TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.yellowColor),)),
          Align(
            alignment: Alignment.bottomRight,
            child:Text(" $qty ${unit??""} ",style:TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.addNewTextFieldBorder),),

          )
        ],
      ),
    );
  }
}
