import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/charts/highChart/high_chart.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:quarry/widgets/loader.dart';
class SalesDashBoard extends StatefulWidget {

  @override
  _SalesDashBoardState createState() => _SalesDashBoardState();
}

class _SalesDashBoardState extends State<SalesDashBoard> {

  List<DateTime> picked=[];
  @override
  void initState() {
    Provider.of<DashboardNotifier>(context,listen: false).DashBoardDbHit(context,
        "Sale",
        DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 7))).toString(),
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DashboardNotifier>(
        builder:(ctx,db,c)=> Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Stack(
            children: [
              Container(
                height: 50,
                child: Row(
                  children: [

                    Text("Sales Dashboard",
                    //    style: AppTheme.appBarTS
                    ),
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
                              "Sale",
                              DateFormat("yyyy-MM-dd").format(picked[0]).toString(),
                              DateFormat("yyyy-MM-dd").format(picked[1]).toString()
                          );
                        }
                        else if(picked1!=null && picked1.length ==1){
                          setState(() {
                            picked=picked1;
                          });
                          db.DashBoardDbHit(context,
                              "Sale",
                              DateFormat("yyyy-MM-dd").format(picked[0]).toString(),
                              DateFormat("yyyy-MM-dd").format(picked[0]).toString()
                          );
                        }

                      },
                      child: SvgPicture.asset("assets/svg/calender.svg",width: 27,height: 27,color: AppTheme.bgColor,
                        //    color: qn.selectedIndex==-1? AppTheme.bgColor.withOpacity(0.5):isOpen?AppTheme.bgColor:AppTheme.bgColor.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(width: 20,)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                height: 270,
                width:SizeConfig.screenWidth,

                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Color(0xff343434),
                ),

                child: HighCharts(
                  data: db.salesApex,
                  isHighChart: false,
                  isLoad: db.isChartLoad,
                ),
              ),

              Loader(
                isLoad: db.isLoad,
              )
            ],
          ),
        ),
      ),
    );
  }
}
