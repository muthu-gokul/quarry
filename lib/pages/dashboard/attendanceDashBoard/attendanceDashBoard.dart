
import 'dart:async';
import 'dart:math';

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
import 'package:quarry/widgets/circularProgress/circleProgressBar.dart';
import 'package:quarry/widgets/circularProgress/circleProgressBar2.dart';
import 'package:quarry/widgets/fittedText.dart';
import 'package:quarry/widgets/loader.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:charts_flutter/flutter.dart' as charts;
class AttendanceDashBoard extends StatefulWidget {

  VoidCallback drawerCallback;
  AttendanceDashBoard({this.drawerCallback});
  @override
  _AttendanceDashBoardState createState() => _AttendanceDashBoardState();
}

class _AttendanceDashBoardState extends State<AttendanceDashBoard> {
  ScrollController silverController;
  double silverBodyTopMargin=0;
  List<DateTime> picked=[];
  int selIndex=-1;

  @override
  void initState() {
    Provider.of<DashboardNotifier>(context,listen: false).DashBoardDbHit(context,
        "Attendance",
        DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 6))).toString(),
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
    );

    WidgetsBinding.instance.addPostFrameCallback((_){
      silverController=new ScrollController();

      setState(() {
        silverBodyTopMargin=0;
      });

      silverController.addListener(() {
        if(silverController.offset>150){
          setState(() {
            silverBodyTopMargin=50-(-(silverController.offset-200));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController.offset<170){
          setState(() {
            silverBodyTopMargin=0;
          });
        }
      });
    });
    super.initState();
  }
  double tabWidth;
  double position=5;
  @override
  Widget build(BuildContext context) {
    tabWidth=SizeConfig.screenWidth-40;
    return Scaffold(
      backgroundColor: AppTheme.yellowColor,
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
                            Text("Attendance",style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16,letterSpacing: 0.2)),
                            Spacer(),
                            GestureDetector(
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
                                    });
                                    db.DashBoardDbHit(context,
                                        "Attendance",
                                        DateFormat("yyyy-MM-dd").format(picked[0]).toString(),
                                        DateFormat("yyyy-MM-dd").format(picked[1]).toString()
                                    );
                                  }
                                  else if(picked1!=null && picked1.length ==1){
                                    setState(() {
                                      picked=picked1;
                                    });
                                    db.DashBoardDbHit(context,
                                        "Attendance",
                                        DateFormat("yyyy-MM-dd").format(picked[0]).toString(),
                                        DateFormat("yyyy-MM-dd").format(picked[0]).toString()
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
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: tabWidth*0.99,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Color(0xFFE6E6E6)
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            left: position,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                            child: Container(
                              width: tabWidth*0.33,
                              height: 35,
                              margin: EdgeInsets.only(top: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                color: AppTheme.yellowColor,
                                boxShadow: [
                                  AppTheme.yellowShadow
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap:(){
                                  setState(() {
                                    position=5;
                                  });

                                },
                                child: Container(
                                  width: tabWidth*0.33,
                                  height: 50,
                                  color: Colors.transparent,
                                  child: Center(
                                      child: Text("Week",style: TextStyle(fontFamily: 'RR',fontSize: 14,color:position==5?AppTheme.bgColor: Colors.grey),)

                                  ),
                                ),
                              ),
                              InkWell(
                                onTap:(){
                                  setState(() {
                                    position=tabWidth*0.33;
                                  });

                                },
                                child: Container(
                                  width: tabWidth*0.33,
                                  height: 50,
                                  color: Colors.transparent,
                                  child: Center(
                                      child: Text("Month",style: TextStyle(fontFamily: 'RR',fontSize: 14,color:position==tabWidth*0.33?AppTheme.bgColor:  Colors.grey),)
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap:(){
                                  setState(() {
                                    position=tabWidth*0.66;
                                  });

                                },
                                child: Container(
                                  width: tabWidth*0.33,
                                  height: 50,
                                  color: Colors.transparent,
                                  child: Center(
                                      child: Text("Year",style: TextStyle(fontFamily: 'RR',fontSize: 14,color:position==tabWidth*0.66?AppTheme.bgColor: Colors.grey),)
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height:180,
                        child: CircleProgressBar2(
                          extraStrokeWidth: 4,
                          innerStrokeWidth: 4,
                          backgroundColor: Color(0xFFd7d7d7),
                        //  foregroundColor: Color(0xFFF1B240),
                          foregroundColor: Colors.red,
                    //    value: 0.00,
                     //   value2: 0.6,
                          value: (db.totalPresent/db.totalEmployee).toDouble(),
                          value2: (db.totalAbsent/db.totalEmployee).toDouble(),
                          center: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${db.totalEmployee} Staff",style: TextStyle(fontFamily: 'RM',color: AppTheme.attendanceDashText1,fontSize: 14),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),


                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: 'Present : ',
                          style: TextStyle(fontFamily:'RM',fontSize: 13,color: Color(0xFF9B9C9F)),
                          children: <TextSpan>[
                            TextSpan(text: '${db.totalPresent}', style: TextStyle(fontFamily:'RM',fontSize: 15,color: Color(0xFF51A17C))),
                            TextSpan(text: ' / Absent : ', style: TextStyle(fontFamily:'RM',fontSize: 13,color: Color(0xFF9B9C9F))),
                            TextSpan(text: '${db.totalAbsent}', style: TextStyle(fontFamily:'RM',fontSize: 15,color: Color(0xFFDA4F48))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                    //  height: (db.todayAttendanceListT2.length)*60.0,
                    //  width: double.maxFinite,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: db.todayAttendanceListT2.length,
                        itemBuilder: (ctx,i){
                          return Container(
                           // height: 50,
                            margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                            padding: EdgeInsets.only(left: 10,right: 10,top: 7,bottom: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                   //   color: Colors.red
                                  ),
                                  child: Image.asset("assets/svg/drawer/avatar.png",fit: BoxFit.cover),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width:(SizeConfig.screenWidth-40)*0.6,
                                        child: Text("${db.todayAttendanceListT2[i]['Employee']}",
                                          style: TextStyle(fontSize: 12,color: AppTheme.attendanceDashText1,fontFamily: 'RM'),
                                        )
                                    ),
                                    SizedBox(height: 3,),
                                    Row(
                                      children: [
                                        SvgPicture.asset("assets/svg/drawer/reports/receivablePayment.svg",height: 15,),
                                        Text("  ${db.todayAttendanceListT2[i]['PerdaySalary']}",
                                          style: TextStyle(fontSize: 12,color: AppTheme.attendanceDashText1,fontFamily: 'RR'),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),


           /* db.counterList.isEmpty?Container(
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
            ):Container(),*/
            Loader(
              isLoad: db.isLoad,
            )
          ],
        ),
      ),
    );
  }


  counter(Color color,String title,dynamic value){
    return  Container(
      height: SizeConfig.screenWidth*0.4,
      width: SizeConfig.screenWidth*0.4,
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
