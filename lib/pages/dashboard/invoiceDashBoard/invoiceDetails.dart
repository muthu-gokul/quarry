import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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



class InvoiceDetails extends StatefulWidget {
  String title;
  List<dynamic> list;
  InvoiceDetails({required this.title,required this.list});
  @override
  _InvoiceDetailsState createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {

  late double width;

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width-90;
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
                                  children: qn.customerInvCounterT1.
                                  map((key, value) => MapEntry(key,
                                      Container(
                                        height: 80,
                                        width: SizeConfig.screenWidth!*0.33,
                                        margin: EdgeInsets.only(right: SizeConfig.width10!),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: AppTheme.bgColor
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
                                            /*FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(" ₹ ${formatCurrency.format(value)}",
                                                  style:TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.yellowColor),)
                                            ),*/

                                          ],
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
                    child: ListView.builder(
                      itemCount: widget.list.length,
                      itemBuilder: (ctx,i){
                        return Container(
                          height: 80,
                          margin: EdgeInsets.only(left: 20,right: 20),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[300]!))
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white
                                ),
                              ),
                              SizedBox(width: 15,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: width*0.45,
                                    height: 20,
                                   // color: Colors.green,
                                    child: Text("${widget.list[i]['CustomerName']??""}",style: TextStyle(fontFamily: 'RM',fontSize: 14,color: Color(0xFF6B727D)),overflow: TextOverflow.ellipsis,),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
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

class SaleReportHeader extends StatelessWidget {
  String? title;
  double? value;
  double? qty;
  String? unit;

  SaleReportHeader({this.title,this.value,this.qty,this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: SizeConfig.screenWidth!*0.40,
      margin: EdgeInsets.only(right: SizeConfig.width10!),
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
              child: Text(" ₹ ${formatCurrency.format(value)}",style:TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.yellowColor),)),
          Align(
            alignment: Alignment.bottomRight,
            child:Text(" ${formatCurrency.format(qty)} ${unit??""} ",style:TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.addNewTextFieldBorder),),

          )
        ],
      ),
    );
  }
}

class SaleReportHeaderModel{
  String? title;
  double? value;
  double? qty;
  String? unit;

  SaleReportHeaderModel({this.title,this.value,this.qty,this.unit});
}