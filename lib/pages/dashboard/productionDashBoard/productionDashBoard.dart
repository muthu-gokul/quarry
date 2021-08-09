
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

  List<dynamic> outputMaterials=[];
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
                          alignment: Alignment.center,
                          child: Text("Production",style: TextStyle(fontSize: 18,fontFamily: 'RR',),),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("09-89-=88",style: TextStyle(fontSize: 16,fontFamily: 'RR',),),
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
                 //   color: Colors.red,
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
                              outputMaterials=db.productionOutPutMaterialsT1.where((element) => element['InputMaterialId']==db.productionInputMaterialsT[i]['InputMaterialId']).toList();
                            });
                           // db.getProduction(selIndex);
                          },
                          child: Container(
                            height: 40,
                            decoration:selIndex==i? BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.grey)
                            ):BoxDecoration(
                              color: Colors.transparent
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 30,right: 30),
                            child: Text("${db.productionInputMaterialsT[i]['MaterialName']}"),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  db.productionInputMaterialsT.isEmpty?Container():Container(
                    width: SizeConfig.screenWidth,
                    height: 275,
             //       color: AppTheme.red,
                  //  margin:EdgeInsets.only(top: 55),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height:180,
                            child: CircleProgressBar(
                              backgroundColor: Color(0xFFd7d7d7),
                              foregroundColor: Color(0xFFF1B240),
                              value: (( db.productionInputMaterialsT[selIndex]['InputMaterialQuantity']/db.totalProductionQty)),
                            ),
                          ),
                        ),


                        /*CircularPercentIndicator(
                          addAutomaticKeepAlive: false,
                          animationDuration: 5000,
                          radius: 80.0,
                          lineWidth: 5.0,
                          animation: true,
                          percent: (( db.productionInputMaterialsT[selIndex]['InputMaterialQuantity']/db.totalProductionQty)),
                          center:Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent
                            ),
                            child: Center(
                              child: Text("${( db.productionInputMaterialsT[selIndex]['InputMaterialQuantity']/db.totalProductionQty)*100}"),
                              //  child: SvgPicture.asset("assets/feedbackIcons/${value['Img']}.svg",width: 40,height: 40,),
                            ),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor:Colors.red,
                        ),*/
                        /*Container(
                          height: 275,
                          child: HighCharts(
                            data: db.apexProduction,
                            isHighChart: false,
                            isLoad: db.isProductionChartLoad,
                          ),
                        ),*/
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
                          for(int i=0;i<outputMaterials.length;i++)
                            Container(
                              height:100,
                              child: CircleProgressBar(
                                backgroundColor: Color(0xFFd7d7d7),
                                foregroundColor: Color(0xFFF1B240),
                                value: (( outputMaterials[i]['OutputMaterialPercentage'])/100),
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
