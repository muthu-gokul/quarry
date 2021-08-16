import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/sale/salePlantList.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:quarry/widgets/fittedText.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/reportpdf.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable.dart';



class InvoiceCustomerBillDetails extends StatefulWidget {
  String title;
  List<dynamic> list;
  List<dynamic> filterList;
 // String date;
  Color textColor;
  Color statusColor;
  Map counter;
  InvoiceCustomerBillDetails({required this.title,required this.list,required this.textColor,required this.statusColor,
  required this.counter,required this.filterList});
  @override
  _InvoiceCustomerBillDetailsState createState() => _InvoiceCustomerBillDetailsState();
}

class _InvoiceCustomerBillDetailsState extends State<InvoiceCustomerBillDetails> {

  late double width;
  String selKey="Total Invoice";
  ScrollController scrollController=new ScrollController();
  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width-30;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Consumer<DashboardNotifier>(
            builder: (context,qn,child)=>  Stack(
              children: [
                Opacity(
                  opacity: 0.8,
                  child: Container(
                    height: 160,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/svg/gridHeader/reportsHeader.jpg",),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),

                Container(
                    height: 160,
                    width: SizeConfig.screenWidth,
                    // color: AppTheme.yellowColor,


                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              CancelButton(
                                ontap: (){
                                  Navigator.pop(context);
                                },
                              ),
                              Text("${widget.title}",
                                  style: AppTheme.appBarTS
                              ),


                            ],
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 5,right: 5,),
                            alignment: Alignment.centerLeft,
                            child:SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: widget.counter.
                                  map((key, value) => MapEntry(key,
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            selKey=key;
                                            if(key=="Total Invoice"){
                                              widget.list=widget.filterList;
                                            }
                                            else if(key=='Paid Invoice'){
                                              widget.list=widget.filterList.where((ele)=>ele['Status']=='Paid').toList();
                                            }
                                            else if(key=='Unpaid Invoice'){
                                              widget.list=widget.filterList.where((ele)=>ele['Status']=='Unpaid').toList();
                                            }
                                            else if(key=='Partially Paid Invoice'){
                                              widget.list=widget.filterList.where((ele)=>ele['Status']=='Partially Paid').toList();
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 80,
                                          width: SizeConfig.screenWidth!*0.33,
                                          margin: EdgeInsets.only(right: SizeConfig.width10!),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color:selKey==key? AppTheme.bgColor.withOpacity(0.8): AppTheme.bgColor
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: 5,right: 5),
                                                child: FittedText(
                                                  text: key,
                                                  height: 16,
                                                  width: SizeConfig.screenWidth!*0.33,
                                                  alignment: Alignment.center,
                                                  textStyle: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white,letterSpacing: 0.1),
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text("$value",style: TextStyle(fontFamily: 'RB',fontSize: 20,color: Color(0xFFE8D24C),letterSpacing: 0.1),),
                                            ],
                                          ),
                                        ),
                                      )
                                  )
                                  ).values.toList()
                              ),
                            )
                        )
                      ],
                    )
                ),




                Container(
                    height: SizeConfig.screenHeight!-140,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.only(top: 140),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: AppTheme.gridbodyBgColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                    ),
                    child: RawScrollbar(
                      controller: scrollController,
                      isAlwaysShown: true,
                      radius: Radius.circular(5),
                      thickness: 5,
                      thumbColor: Colors.transparent,
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: widget.list.length,
                        itemBuilder: (ctx,i){
                          return GestureDetector(
                            onTap: (){

                            },
                            child: Container(
                              height: 80,
                              margin: EdgeInsets.only(left: 10,right: 10),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                                  color: Colors.transparent
                              ),
                              child: Row(
                                children: [
                                /*  Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Center(
                                      child: SvgPicture.asset("assets/svg/Planticon.svg",fit: BoxFit.cover,),
                                    ),
                                  ),
                                  SizedBox(width: 10,),*/
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width*0.45,
                                        height: 20,
                                        // color: Colors.green,
                                        child: Text("${widget.list[i]['InvoiceNumber']??"UnKnown"}",style: TextStyle(fontFamily: 'RM',fontSize: 14,color: Color(0xFF6B727D)),overflow: TextOverflow.ellipsis,),
                                      ),
                                      Container(
                                          width: width*0.45,
                                          height: 18,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.calendar_today_outlined,size: 10,color: Color(0xFFB4B4CD)),
                                              FittedText(
                                                text: " ${DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.list[i]['InvoiceDate']))}",
                                                textStyle: TextStyle(color: Color(0xFFB4B4CD),fontFamily: 'RR',fontSize: 12),
                                                alignment: Alignment.centerLeft,
                                                width: (width*0.45)-10,
                                                height: 14,
                                              )
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 5,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                    /*  Container(
                                        width: width*0.18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color: widget.statusColor,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("${widget.list[i]['Bill']} Bills",
                                          style: TextStyle(fontFamily: 'RB',fontSize: 10,color: widget.textColor),
                                        ),
                                      ),*/
                                     // SizedBox(height: 5,),
                                      FittedText(
                                        text: "${formatCurrency.format(widget.list[i]['GrandTotalAmount'])}",
                                        textStyle: TextStyle(color: Color(0xFFB4B4CD),fontFamily: 'RM',fontSize: 14),
                                        alignment: Alignment.centerLeft,
                                        width: (width*0.31),
                                        height: 16,
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: width*0.22,
                                          height: 20,
                                          child: FittedText(
                                            text: "Payment Status",
                                            textStyle: TextStyle(fontFamily: 'RM',fontSize: 11,color: Color(0xFF6B727D)),
                                            alignment: Alignment.centerLeft,
                                            width: (width*0.28),
                                            height: 16,
                                          )
                                      ),

                                      Container(
                                          width: width*0.22,
                                          height: 18,
                                          child: FittedText(
                                            text: "${widget.list[i]['Status']}",
                                            textStyle: TextStyle(fontFamily: 'RM',fontSize: 12,color:widget.list[i]['Status']=='Paid'?invPaidText:
                                            widget.list[i]['Status']=='Unpaid'?invUnPaidText:widget.list[i]['Status']=='Partially Paid'?invPartiallyPaidText:Colors.grey),
                                            alignment: Alignment.center,
                                            width: (width*0.28),
                                            height: 16,
                                          )
                                      ),


                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                ),


                widget.list.isEmpty?Container(
                  width: SizeConfig.screenWidth,
                  margin: EdgeInsets.only(top: 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //  SizedBox(height: 70,),

                      SvgPicture.asset("assets/nodata.svg",height: 350,),
                      SizedBox(height: 20,),
                      Text("No Data Found",style: TextStyle(fontSize: 18,fontFamily:'RMI',color: AppTheme.addNewTextFieldText),),

                    ],
                  ),
                ):Container()

              ],
            ),
          ),
        ),
      ),
    );
  }


}



