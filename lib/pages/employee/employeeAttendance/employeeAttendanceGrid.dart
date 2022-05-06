import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/employeeAttendanceNotifier.dart';
import 'package:quarry/pages/reports/reportGrid.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable2.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;

import 'employeeAttendanceLoginLogout.dart';


class EmployeeAttendanceGrid extends StatefulWidget {
  VoidCallback? drawerCallback;
  EmployeeAttendanceGrid({this.drawerCallback});

  @override
  _EmployeeAttendanceGridState createState() => _EmployeeAttendanceGridState();
}

class _EmployeeAttendanceGridState extends State<EmployeeAttendanceGrid> {

  bool showEdit=false;
  int? selectedIndex;



  DateTime dateTime=DateTime.parse('2021-01-01');
  List<GridStyleModel> gridDataRowList=[
    GridStyleModel(columnName: "Employee Code"),
    GridStyleModel(columnName: "Name"),
    GridStyleModel(columnName: "Designation"),
    GridStyleModel(columnName: "Shift",width: 100),
    GridStyleModel(columnName: "Date",width: 100),
    GridStyleModel(columnName: "In Time",width: 100),
    GridStyleModel(columnName: "Out Time",width: 100),
    GridStyleModel(columnName: "Over Time",width: 100),
    GridStyleModel(columnName: "Status",alignment: Alignment.centerRight,edgeInsets: EdgeInsets.only(right: 20)),
  ];

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Scaffold(
      body:Consumer<EmployeeAttendanceNotifier>(
        builder: (context,ean,child)=>
         Container(
           height: SizeConfig.screenHeight,
           width: SizeConfig.screenWidth,
           child: Stack(
             children: [
               Container(
                 height: 50,
                 width: SizeConfig.screenWidth,
                 color: AppTheme.yellowColor,

                 child: Row(
                   children: [
                     GestureDetector(
                       onTap: widget.drawerCallback,
                       child: NavBarIcon(),
                     ),
                     Text("Employee Attendance",
                         style: AppTheme.appBarTS
                     ),
                     Spacer(),
                     Theme(
                       data: ThemeData(
                         accentColor: Colors.blue,
                       ),
                       child: GestureDetector(
                         onTap: () async {

                           final DateTime? picked = await showDatePicker(
                             context: context,
                             initialDate: DateTime.now(), // Refer step 1
                             firstDate: DateTime(2000),
                             lastDate: DateTime(2100),
                           );
                           if (picked != null)
                             setState(() {
                               ean.reportDate = picked;
                             });
                           ean.GetEmployeeAttendanceIssueDbHit(context, null);
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
               ),
               Container(
                   margin: EdgeInsets.only(top: 50),
                   padding: EdgeInsets.only(left:5,bottom:25,right: 5),
                   color: AppTheme.yellowColor,
                   height: 110,
                   alignment: Alignment.topCenter,

                   child:Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [

                       ReportHeader(
                         title: 'Total Employees',
                         value: ean.totalEmployee,
                       ),
                       ReportHeader(
                         title: 'Total Present',
                         value: ean.totalPresent,

                       ),
                       ReportHeader(
                         title: 'Total Absent',
                         value: ean.totalAbsent,
                       ),
                     ],
                   )
               ),
               CustomDataTable2(
                 topMargin: 140,
                 gridBodyReduceHeight: 260,
                 selectedIndex: selectedIndex,

                 gridData: ean.EmployeeAttendanceGridList,
                 gridDataRowList: gridDataRowList,
                 func: (index){
                 /*  if(selectedIndex==index){
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
                   }*/
                 },
               ),

               //bottomNav
               Positioned(
                 bottom: 0,
                 child: Container(
                   width: SizeConfig.screenWidth,
                   height: 65,

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
                         margin:EdgeInsets.only(top: 0),
                         child: CustomPaint(
                           size: Size( SizeConfig.screenWidth!, 65),
                           painter: RPSCustomPainter3(),
                         ),
                       ),

                       Container(
                         width:  SizeConfig.screenWidth,
                         height: 80,

                         child: Stack(

                           children: [

                             /*AnimatedPositioned(
                          bottom:showEdit?-60:0,
                          duration: Duration(milliseconds: 300,),
                          curve: Curves.bounceInOut,
                          child: Container(
                            height: 70,
                            width: SizeConfig.screenWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(icon: Icon(Icons.picture_as_pdf,color: Colors.grey,), onPressed: (){

                                }),
                                IconButton(icon: Icon(Icons.exit_to_app,color: Colors.grey,), onPressed: (){

                                }),
                                SizedBox(width: SizeConfig.width50,),
                                IconButton(icon: Icon(Icons.add_comment_sharp,color: Colors.grey,), onPressed: (){

                                }),
                                GestureDetector(
                                  onTap: (){

                                  },
                                  child: IconButton(icon: Icon(Icons.share,color: Colors.grey,), onPressed: (){

                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),*/

                             AnimatedPositioned(
                               bottom:showEdit?15:-60,
                               duration: Duration(milliseconds: 300,),
                               curve: Curves.bounceInOut,
                               child: Container(

                                   width: SizeConfig.screenWidth,
                                   child: Row(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       SizedBox(width: SizeConfig.width20,),
                                       GestureDetector(
                                         onTap: (){

                                         },
                                         child: Container(
                                           width: 70,
                                           decoration: BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: AppTheme.yellowColor.withOpacity(0.7),
                                                   spreadRadius: -3,
                                                   blurRadius: 15,
                                                   offset: Offset(0, 7), // changes position of shadow
                                                 )
                                               ]
                                           ),
                                           child:FittedBox(
                                             child: Row(
                                               children: [
                                                 SvgPicture.asset("assets/svg/edit.svg",height: 20,width: 20,color: AppTheme.yellowColor,),
                                                 SizedBox(width: SizeConfig.width10,),
                                                 Text("Edit",style: TextStyle(fontSize: 20,fontFamily: 'RR',color:Color(0xFFFF9D10)),),


                                               ],
                                             ),
                                           ),
                                         ),
                                       ),
                                       Spacer(),
                                       Container(
                                         width: 90,
                                         decoration: BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: AppTheme.red.withOpacity(0.5),
                                                 spreadRadius: -3,
                                                 blurRadius: 25,
                                                 offset: Offset(0, 7), // changes position of shadow
                                               )
                                             ]
                                         ),
                                         child:FittedBox(
                                           child: Row(
                                             children: [
                                               Text("Delete",style: TextStyle(fontSize: 18,fontFamily: 'RR',color:Colors.red),),
                                               SizedBox(width: SizeConfig.width10,),
                                               SvgPicture.asset("assets/svg/delete.svg",height: 20,width: 20,color: AppTheme.red,),




                                             ],
                                           ),
                                         ),
                                       ),
                                       SizedBox(width: SizeConfig.width10,),
                                     ],
                                   )
                               ),
                             )

                           ],
                         ),
                       )
                     ],
                   ),
                 ),
               ),
               //addButton
               //addButton
               Align(
                 alignment: Alignment.bottomCenter,
                 child: AddButton(
                   ontap: (){

                     setState(() {
                       ean.reportDate=DateTime.now();
                     });
                     ean.insertForm();
                     ean.updateisEmployeeLogin(true);
                     ean.GetEmployeeAttendanceIssueDbHit(context, null);
                     Navigator.push(context, _createRoute());
                   },
                   image: "assets/svg/plusIcon.svg",
                   hasAccess: userAccessMap[35],
                 ),
               ),

             ],
           ),
         )

      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EmployeeAttendanceLoginLogout(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
