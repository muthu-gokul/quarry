
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
import 'package:quarry/widgets/circleBar@.dart';
import 'package:quarry/widgets/circularBar.dart';
import 'package:quarry/widgets/fittedText.dart';
import 'package:quarry/widgets/loader.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;

class ProductionDashBoard extends StatefulWidget {

  VoidCallback drawerCallback;
  ProductionDashBoard({this.drawerCallback});
  @override
  _ProductionDashBoardState createState() => _ProductionDashBoardState();
}

class _ProductionDashBoardState extends State<ProductionDashBoard> {
  ScrollController silverController;
  double silverBodyTopMargin=0;
  List<DateTime> picked=[];
  int selIndex=0;

  @override
  void initState() {
    Provider.of<DashboardNotifier>(context,listen: false).DashBoardDbHit(context,
        "Production",
        DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 6))).toString(),
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Consumer<DashboardNotifier>(
        builder:(ctx,db,c)=> Stack(
          children: [
         Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              clipBehavior: Clip.antiAlias,
             // margin: EdgeInsets.only(top: silverBodyTopMargin),
              padding: EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
              //  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                color: AppTheme.gridbodyBgColor,
              ),
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: SizeConfig.screenWidth,
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CancelButton(
                            bgColor: AppTheme.bgColor,
                            iconColor: Colors.white,
                            ontap: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Production",style: TextStyle(fontSize: 18,fontFamily: 'RR',),),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(picked.length==1?"${DateFormat("dd/MM/yyyy").format(picked[0])}":
                          picked.length==2?"${DateFormat("dd/MM/yyyy").format(picked[0])} - ${DateFormat("dd/MM/yyyy").format(picked[1])}":"Today",
                            style: TextStyle(fontSize: 12,fontFamily: 'RR',color: Color(0xFF8E9090)),),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                              onTap: () async{
                                final List<DateTime>  picked1 = await DateRagePicker.showDatePicker(
                                    context: context,
                                    initialFirstDate: new DateTime.now(),
                                    initialLastDate: (new DateTime.now()),
                                    firstDate: db.dateTime,
                                    lastDate: (new DateTime.now())
                                );
                                if (picked1 != null && picked1.length == 2) {
                                  setState(() {
                                    picked=picked1;
                                    selIndex=0;
                                  });
                                  db.DashBoardDbHit(context,
                                      "Production",
                                      DateFormat("yyyy-MM-dd").format(picked[0]).toString(),
                                      DateFormat("yyyy-MM-dd").format(picked[1]).toString()
                                  );
                                }
                                else if(picked1!=null && picked1.length ==1){
                                  setState(() {
                                    picked=picked1;
                                    selIndex=0;
                                  });
                                  db.DashBoardDbHit(context,
                                      "Production",
                                      DateFormat("yyyy-MM-dd").format(picked[0]).toString(),
                                      DateFormat("yyyy-MM-dd").format(picked[0]).toString()
                                  );
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: SvgPicture.asset("assets/svg/calender.svg",width: 25,height: 25,color: AppTheme.bgColor,),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    width: SizeConfig.screenWidth,
                   margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 10,right: 10),
                    child: ListView.builder(
                      itemCount: db.productionInputMaterialsT.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx,i){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              selIndex=i;
                              db.getProduction(i);
                            });
                          },
                          child: Container(
                            height: 40,
                            decoration:selIndex==i? BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Color(0xFFd7d7d7))
                            ):BoxDecoration(
                              color: Colors.transparent
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 30,right: 30),
                            child: Text("${db.productionInputMaterialsT[i]['MaterialName']}",
                            style: TextStyle(color:selIndex==i?AppTheme.yellowColor: Color(0xFF8E9090),fontFamily: 'RR',fontSize: 14),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  db.productionInputMaterialsT.isEmpty?Container():Container(
                    width: SizeConfig.screenWidth,
                    height: 275,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height:180,
                            child: CircleProgressBar(
                              extraStrokeWidth: 4,
                              innerStrokeWidth: 4,
                              backgroundColor: Color(0xFFd7d7d7),
                              foregroundColor: Color(0xFFF1B240),
                              value: (( db.productionInputMaterialsT[selIndex]['InputMaterialQuantity']/db.totalProductionQty)),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 135,
                                height: 30,
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("${db.productionInputMaterialsT[selIndex]['InputMaterialQuantity']}",style: TextStyle(fontFamily: 'RM',color: Color(0xFF656565),fontSize: 25),),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 3),
                                      child: Text("  ${db.productionInputMaterialsT[selIndex]['UnitName']}",style: TextStyle(fontFamily: 'RR',color: Color(0xFF656565),fontSize: 10)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text("${db.productionInputMaterialsT[selIndex]['MaterialName']}",style: TextStyle(fontFamily: 'RR',color: Color(0xFF8E9090),fontSize: 14),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  db.productionInputMaterialsT.isEmpty?Container():Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: [
                          for(int i=0;i<db.outputMaterials.length;i++)
                            Container(
                              height:120,
                              width: 90,
                             // color: Colors.red,
                            //  margin: EdgeInsets.only(right: 20),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height:70,
                                        margin: EdgeInsets.only(bottom: 5),
                                      //  color: i==0?Colors.red:Colors.transparent,
                                        child: CircleProgressBar(
                                          extraStrokeWidth: -0.9,
                                          backgroundColor: Color(0xFFd7d7d7),
                                          foregroundColor: Color(0xFFF1B240),
                                          value: (( db.outputMaterials[i]['OutputMaterialPercentage'])/100),
                                        ),
                                      ),
                                      Positioned(
                                        right: 7,
                                        top: 6,
                                        child: Container(
                                            height:57,
                                            width: 57,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            alignment: Alignment.center,

                                            child: Text("${db.outputMaterials[i]['OutputMaterialPercentage']}%",style: TextStyle(fontSize: 12,fontFamily: 'RM',color: AppTheme.bgColor),textAlign: TextAlign.center,)),
                                      )
                                    ],
                                  ),
                                  Text("${db.outputMaterials[i]['MaterialName']}",style: TextStyle(fontSize: 12,fontFamily: 'RM',color: AppTheme.bgColor),textAlign: TextAlign.center,),
                                  SizedBox(height: 3,),
                                  Text("${db.outputMaterials[i]['OutputMaterialQuantity']} ${db.outputMaterials[i]['UnitName']}",
                                    style: TextStyle(fontSize: 10,fontFamily: 'RM',color: Color(0xFF8E9090)),textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )

                        ],
                      ),
                    )
                  )

                ],
              ),
            ),

            db.productionInputMaterialsT.isEmpty?Container(
              width: SizeConfig.screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 70,),

                  SvgPicture.asset("assets/nodata.svg",height: 350,),
                  SizedBox(height: 30,),
                  Text("No Data Found",style: TextStyle(fontSize: 18,fontFamily:'RMI',color: AppTheme.addNewTextFieldText),),

                ],
              ),
            ):Container(),
            Loader(
              isLoad: db.isLoad,
            )
          ],
        ),
      ),
    );
  }

}
