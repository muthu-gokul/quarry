
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
import 'package:quarry/widgets/fittedText.dart';
import 'package:quarry/widgets/loader.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;

class CounterDashBoard extends StatefulWidget {

  VoidCallback drawerCallback;
  CounterDashBoard({this.drawerCallback});
  @override
  _CounterDashBoardState createState() => _CounterDashBoardState();
}

class _CounterDashBoardState extends State<CounterDashBoard> {
  ScrollController silverController;
  double silverBodyTopMargin=0;
  List<DateTime> picked=[];
  int selIndex=-1;

  @override
  void initState() {
    Provider.of<DashboardNotifier>(context,listen: false).DashBoardDbHit(context,
        "Counter",
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

  @override
  Widget build(BuildContext context) {
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
                            Text("Counter",style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 16,letterSpacing: 0.2)),
                            Spacer(),
                            /*GestureDetector(
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
                                        "Counter",
                                        DateFormat("yyyy-MM-dd").format(picked[0]).toString(),
                                        DateFormat("yyyy-MM-dd").format(picked[1]).toString()
                                    );
                                  }
                                  else if(picked1!=null && picked1.length ==1){
                                    setState(() {
                                      picked=picked1;
                                    });
                                    db.DashBoardDbHit(context,
                                        "Counter",
                                        DateFormat("yyyy-MM-dd").format(picked[0]).toString(),
                                        DateFormat("yyyy-MM-dd").format(picked[0]).toString()
                                    );
                                  }

                                },
                                child: SvgPicture.asset("assets/svg/calender.svg",width: 27,height: 27,color: AppTheme.bgColor,)),*/
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
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(top: silverBodyTopMargin),
                padding: EdgeInsets.only(top: 30,bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  color: Color(0xFFF6F7F9),
                ),
                child:db.counterList.isEmpty?Container(): Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 30,
                  spacing: 30,
                  children: [
                    counter(Color(0xFF4E57DD),"Customers",db.counterList[0]['TotalCustomers']),
                    counter(Color(0xFFE35A87),"Employee",db.counterList[0]['TotalEmployee']),
                    counter(Color(0xFFE35A87),"Employee",db.counterList[0]['TotalEmployee']),
                    counter(AppTheme.yellowColor,"Machine",db.counterList[0]['TotalMachine']),
                    counter(Color(0xFFE35A87),"Input Material",db.counterList[0]['TotalInputMaterial']),
                    counter(Color(0xFFE35A87),"Output Material",db.counterList[0]['TotalOutputMaterial']),
                  ],
                ),
              ),
            ),
            db.counterList.isEmpty?Container(
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
