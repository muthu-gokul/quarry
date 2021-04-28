/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:quarry/widgets/reportpdf.dart';



class ProductionDetailsGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  ProductionDetailsGrid({this.drawerCallback});
  @override
  ProductionDetailsGridState createState() => ProductionDetailsGridState();
}

class ProductionDetailsGridState extends State<ProductionDetailsGrid> {
  // int selectedIndex=-1;
  bool isOpen=false;
  bool showEdit=false;




  @override
  void didChangeDependencies() {
    print("SALE IMIY DE");
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print("SALE IMIY");
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
          child: Consumer<ProductionNotifier>(
            builder: (context,qn,child)=>  Stack(
              children: [
                Container(
                    height: SizeConfig.height140,
                    width: SizeConfig.screenWidth,
                    color: AppTheme.yellowColor,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                            SizedBox(width: SizeConfig.width10,),
                            Text("Production",
                              style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                            ),
                            // Spacer(),

                          ],
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 5,right: 5,),

                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [


                                ProductionReportHeader(
                                  title: 'Total 12mm Stone',
                                  // qty: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].TotalSaleQuantity??0:0,
                                  unit: "Ton",

                                ),
                                ProductionReportHeader(
                                  title: 'Total 12mm Stone',
                                  // qty: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].MSandQuantity??0:0,
                                  // unit: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].MSandUnit??"":"",
                                ),
                                ProductionReportHeader(
                                  title: 'Total MSand',
                                  // qty: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].PSandQuantity??0:0,
                                  // unit: qn.saleGridReportList.isNotEmpty?qn.saleGridReportList[0].PSandUnit??"":"",
                                ),



                              ],
                            )
                        )

                      ],
                    )
                ),
                Container(
                  height: SizeConfig.screenHeight-(SizeConfig.height140+SizeConfig.height80),
                  // width: SizeConfig.screenWidth,
                  width: SizeConfig.screenWidth,
                  margin: EdgeInsets.only(top: SizeConfig.height140,bottom: SizeConfig.height100),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:DataTable(

                            headingRowColor:  MaterialStateColor.resolveWith((states) =>AppTheme.bgColor),
                            showBottomBorder: true,
                            columns: qn.saleDetailsGridCol.map((e) => DataColumn(
                              label:Text(e,style: TextStyle(fontFamily: 'RB',fontSize: 16,color: Colors.white),),
                            )).toList(),
                            rows: qn.saleDetailsGrid.asMap().map((i,e) => MapEntry(i, DataRow(
                                color: MaterialStateColor.resolveWith((states) =>qn.selectedIndex==i? AppTheme.bgColor.withOpacity(0.7):e.SaleStatus=='Open'?Colors.red.withOpacity(0.2):Colors.green.withOpacity(0.2)),
                                cells: [
                                  DataCell(Text(e.MachineName,style: TextStyle(fontFamily: 'RR',fontSize: 14,color:qn.selectedIndex==i?Colors.white: Colors.black),textAlign: TextAlign.center,),
                                      onTap: (){

                                        setState(() {
                                          if(qn.selectedIndex==-1 || qn.selectedIndex!=i){
                                            qn.selectedIndex=i;
                                            if(e.SaleStatus=='Open'){
                                              isOpen=true;
                                            }else{
                                              isOpen=false;
                                            }
                                          }
                                          else {
                                            qn.selectedIndex=-1;
                                          }
                                        });

                                      }
                                  ),
                                  DataCell(Text(e.InputMaterialName.toString(),style: TextStyle(fontFamily: 'RR',fontSize: 14,color:qn.selectedIndex==i?Colors.white: Colors.black),),
                                      onTap: (){
                                        setState(() {
                                          if(qn.selectedIndex==-1 || qn.selectedIndex!=i){
                                            qn.selectedIndex=i;
                                            if(e.SaleStatus=='Open'){
                                              isOpen=true;
                                            }else{
                                              isOpen=false;
                                            }
                                          }
                                          else {
                                            qn.selectedIndex=-1;
                                          }
                                        });
                                      }),
                                  DataCell(Text(e.InputMaterialQuantity??"",style: TextStyle(fontFamily: 'RR',fontSize: 14,color:qn.selectedIndex==i?Colors.white: Colors.black),textAlign: TextAlign.center,),
                                      onTap: (){
                                        setState(() {
                                          if(qn.selectedIndex==-1 || qn.selectedIndex!=i){
                                            qn.selectedIndex=i;
                                            if(e.SaleStatus=='Open'){
                                              isOpen=true;
                                            }else{
                                              isOpen=false;
                                            }
                                          }
                                          else {
                                            qn.selectedIndex=-1;
                                          }
                                        });
                                      }),
                                  DataCell(Text("${e.OutputMaterialCount??""}",style: TextStyle(fontFamily: 'RR',fontSize: 14,color:qn.selectedIndex==i?Colors.white: Colors.black),),
                                      onTap: (){
                                        setState(() {
                                          if(qn.selectedIndex==-1 || qn.selectedIndex!=i){
                                            qn.selectedIndex=i;
                                            if(e.SaleStatus=='Open'){
                                              isOpen=true;
                                            }else{
                                              isOpen=false;
                                            }
                                          }
                                          else {
                                            qn.selectedIndex=-1;
                                          }
                                        });
                                      }),
                                  DataCell(Text("${e.OutPutMaterialQuantity??"0"}",style: TextStyle(fontFamily: 'RR',fontSize: 14,color:qn.selectedIndex==i?Colors.white: Colors.black),),
                                      onTap: (){
                                        setState(() {
                                          if(qn.selectedIndex==-1 || qn.selectedIndex!=i){
                                            qn.selectedIndex=i;
                                            if(e.SaleStatus=='Open'){
                                              isOpen=true;
                                            }else{
                                              isOpen=false;
                                            }
                                          }
                                          else {
                                            qn.selectedIndex=-1;
                                          }
                                        });
                                      }),
                                  DataCell(Text("${e.InDustWastage??"0"}",style: TextStyle(fontFamily: 'RR',fontSize: 14,color:qn.selectedIndex==i?Colors.white: Colors.black),),
                                      onTap: (){
                                        setState(() {
                                          if(qn.selectedIndex==-1 || qn.selectedIndex!=i){
                                            qn.selectedIndex=i;
                                            if(e.SaleStatus=='Open'){
                                              isOpen=true;
                                            }else{
                                              isOpen=false;
                                            }
                                          }
                                          else {
                                            qn.selectedIndex=-1;
                                          }
                                        });
                                      }),
                                  DataCell(Text("${e.DustQuantity??"0"}",style: TextStyle(fontFamily: 'RR',fontSize: 14,color:qn.selectedIndex==i?Colors.white: Colors.black),),
                                      onTap: (){
                                        setState(() {
                                          if(qn.selectedIndex==-1 || qn.selectedIndex!=i){
                                            qn.selectedIndex=i;
                                            if(e.SaleStatus=='Open'){
                                              isOpen=true;
                                            }else{
                                              isOpen=false;
                                            }
                                          }
                                          else {
                                            qn.selectedIndex=-1;
                                          }
                                        });
                                      }),
                                  DataCell(Text("${e.WastageQuantity??"0"}",style: TextStyle(fontFamily: 'RR',fontSize: 14,color:qn.selectedIndex==i?Colors.white: Colors.black),),
                                      onTap: (){
                                        setState(() {
                                          if(qn.selectedIndex==-1 || qn.selectedIndex!=i){
                                            qn.selectedIndex=i;
                                            if(e.SaleStatus=='Open'){
                                              isOpen=true;
                                            }else{
                                              isOpen=false;
                                            }
                                          }
                                          else {
                                            qn.selectedIndex=-1;
                                          }
                                        });
                                      }),


                                ])
                            )
                            ).values.toList()
                        )

                    ),
                  ),
                ),

                Positioned(
                    bottom: SizeConfig.height70,
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
                Positioned(
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
                ),



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

class ProductionReportHeader extends StatelessWidget {
  String title;
  double qty;
  String unit;

  ProductionReportHeader({this.title,this.qty,this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.height80,
      width: SizeConfig.width100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppTheme.bgColor
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(" $title",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white,letterSpacing: 0.1),),
          Align(
            alignment: Alignment.bottomRight,
            child:Text(" $qty ${unit??""} ",style:TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.addNewTextFieldBorder),),

          )
        ],
      ),
    );
  }
}
*/
