import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/employeeAttendanceNotifier.dart';
import 'package:quarry/pages/reports/reportGrid.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/searchdropdownSingleSelect.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable2.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;


class EmployeeAttendanceLoginLogout extends StatefulWidget {
  VoidCallback drawerCallback;
  EmployeeAttendanceLoginLogout({this.drawerCallback});

  @override
  _EmployeeAttendanceLoginLogoutState createState() => _EmployeeAttendanceLoginLogoutState();
}

class _EmployeeAttendanceLoginLogoutState extends State<EmployeeAttendanceLoginLogout> {

  bool showEdit=false;
  int selectedIndex;

  PageController pageController;
  int pageIndex=0;







  DateTime dateTime=DateTime.parse('2021-01-01');
  List<GridStyleModel> gridDataRowList=[
    GridStyleModel(columnName: "Employee Code"),
    GridStyleModel(columnName: "Name"),
    GridStyleModel(columnName: "Designation"),
    GridStyleModel(columnName: "Shift"),
    GridStyleModel(columnName: "Date"),
    GridStyleModel(columnName: "In Time"),
    GridStyleModel(columnName: "Out Time"),
    GridStyleModel(columnName: "Over Time"),
    GridStyleModel(columnName: "Status"),
  ];

  @override
  void initState() {
    pageController=new PageController(initialPage: 0);
    setState(() {

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    final node=FocusScope.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Consumer<EmployeeAttendanceNotifier>(
          builder: (context,ean,child)=>
              Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Stack(
                  children: [


                    PageView(
                     // physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      onPageChanged: (i){
                        setState(() {
                          pageIndex=i;
                        });
                      },
                      children: [
                        //Login
                        Stack(
                          children: [
                            Container(
                              height: 50,
                              width: SizeConfig.screenWidth,
                              color: AppTheme.yellowColor,

                              child: Row(
                                children: [
                                  CancelButton(
                                    ontap: (){
                                      ean.clearinsertForm();
                                      Navigator.pop(context);
                                    },
                                  ),

                                  Text("Login",
                                      style: AppTheme.appBarTS
                                  ),
                                  Spacer(),

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
                            Container(
                              margin: EdgeInsets.only(top: 140),
                              height: SizeConfig.screenHeight,
                              width: SizeConfig.screenWidth,
                           //   padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppTheme.gridbodyBgColor
                              ),
                              child: ListView(

                                children: [

                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap:() async{
                                            final DateTime picked = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(), // Refer step 1
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                            );
                                            if (picked != null)
                                              setState(() {
                                               ean.selectedDate=picked;
                                              });
                                          },
                                          child: Container(
                                            height: 50,
                                            width:( SizeConfig.screenWidthM40*0.5)-10,
                                            padding: EdgeInsets.only(left: 10,right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                            ),
                                            child: Row(
                                              children: [
                                                Text("${DateFormat("dd-MM-yyyy").format(ean.selectedDate)}"),
                                                Spacer(),
                                                SvgPicture.asset("assets/svg/calender.svg",height: 25,width: 25,color: Colors.black ,)

                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async{
                                            final TimeOfDay picked = await showTimePicker(
                                              context: context,
                                              initialTime: ean.selectedTime==null?TimeOfDay.now():ean.selectedTime,

                                            );
                                            if (picked != null){
                                              print(picked);
                                            }
                                              setState(() {
                                                ean.selectedTime=picked;
                                                ean.time = formatDate(
                                                    DateTime(2019, 08, 1, ean.selectedTime.hour, ean.selectedTime.minute),
                                                    [hh, ':', nn, " ", am]).toString();
                                              });
                                          },
                                          child:Container(
                                            height: 50,
                                            width:( SizeConfig.screenWidthM40*0.5)-10,
                                            padding: EdgeInsets.only(left: 10,right: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                            ),
                                            child: Row(
                                              children: [
                                                Text(ean.time ??"Select Time"),
                                                Spacer(),
                                                Icon(Icons.timer)

                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  DropDownField(
                                    add: (){
                                    },
                                    nodeFocus: (){
                                      node.unfocus();
                                    },
                                    value: ean.selectedEmployeeCode,
                                    controller: ean.employeeCodeController,
                                    reduceWidth: SizeConfig.width40,
                                    required: false,
                                    hintText: 'Search Employee Code',
                                    textStyle: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.addNewTextFieldText),
                                    items: ean.employeeCode,
                                    strict: false,
                                    setter: (dynamic newValue) {},
                                    onValueChanged: (v){
                                      node.unfocus();
                                      setState(() {
                                        ean.selectedEmployeeCode=v;
                                        int index;
                                        index=ean.EmployeeAttendanceGridList.indexWhere((element) =>  "${element.employeeName}  -  ${element.employeePrefix+element.employeeCode}"==v.toString()).toInt();
                                        ean.showEmpName=ean.EmployeeAttendanceGridList[index].employeeName;
                                        ean.showEmpDesg=ean.EmployeeAttendanceGridList[index].employeeDesignationName;
                                        ean.showEmpId=ean.EmployeeAttendanceGridList[index].employeeId;
                                      });
                                    },
                                  ),


                                  SizedBox(height: 50,),

                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 100,
                                      width: 100,

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
                                          ]
                                      ),
                                      child: Center(
                                        child: Image.asset("assets/svg/drawer/avatar.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text("${ean.showEmpName}",
                                      style: AppTheme.userNameTS,
                                    ),
                                  ),
                                  SizedBox(height: 3,),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text("${ean.showEmpDesg}",
                                      style: AppTheme.userGroupTS,
                                    ),
                                  ),


                                ],
                              ),
                            )
                          ],
                        ),


                        //Logout
                        Stack(
                          children: [
                            Container(
                              height: 50,
                              width: SizeConfig.screenWidth,
                              color: AppTheme.yellowColor,

                              child: Row(
                                children: [
                                  CancelButton(
                                    ontap: (){
                                      ean.clearinsertForm();
                                      Navigator.pop(context);
                                    },
                                  ),

                                  Text("Logout",
                                      style: AppTheme.appBarTS
                                  ),
                                  Spacer(),

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
                            Container(
                              margin: EdgeInsets.only(top: 140),
                              height: SizeConfig.screenHeight,
                              width: SizeConfig.screenWidth,
                              //   padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppTheme.gridbodyBgColor
                              ),
                              child: ListView(

                                children: [

                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap:() async{
                                            final DateTime picked = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(), // Refer step 1
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                            );
                                            if (picked != null)
                                              setState(() {
                                                ean.selectedDate=picked;
                                              });
                                          },
                                          child: Container(
                                            height: 50,
                                            width:( SizeConfig.screenWidthM40*0.5)-10,
                                            padding: EdgeInsets.only(left: 10,right: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                            ),
                                            child: Row(
                                              children: [
                                                Text("${DateFormat("dd-MM-yyyy").format(ean.selectedDate)}"),
                                                Spacer(),
                                                SvgPicture.asset("assets/svg/calender.svg",height: 25,width: 25,color: Colors.black ,)

                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async{
                                            final TimeOfDay picked = await showTimePicker(
                                              context: context,
                                              initialTime: ean.selectedTime==null?TimeOfDay.now():ean.selectedTime,

                                            );
                                            if (picked != null){
                                              print(picked);
                                            }
                                            setState(() {
                                              ean.selectedTime=picked;
                                              ean.time = formatDate(
                                                  DateTime(2019, 08, 1, ean.selectedTime.hour, ean.selectedTime.minute),
                                                  [hh, ':', nn, " ", am]).toString();
                                            });
                                          },
                                          child:Container(
                                            height: 50,
                                            width:( SizeConfig.screenWidthM40*0.5)-10,
                                            padding: EdgeInsets.only(left: 10,right: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                            ),
                                            child: Row(
                                              children: [
                                                Text(ean.time ??"Select Time"),
                                                Spacer(),
                                                Icon(Icons.timer)

                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  DropDownField(
                                    add: (){
                                    },
                                    nodeFocus: (){
                                      node.unfocus();
                                    },
                                    value: ean.selectedEmployeeCode,
                                    controller: ean.employeeCodeController,
                                    reduceWidth: SizeConfig.width40,
                                    required: false,
                                    hintText: 'Search Employee Code',
                                    textStyle: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.addNewTextFieldText),
                                    items: ean.employeeCode,
                                    strict: false,
                                    setter: (dynamic newValue) {},
                                    onValueChanged: (v){
                                      node.unfocus();
                                      setState(() {
                                        ean.selectedEmployeeCode=v;
                                        int index;
                                        index=ean.EmployeeAttendanceGridList.indexWhere((element) =>  "${element.employeeName}  -  ${element.employeePrefix+element.employeeCode}"==v.toString()).toInt();
                                        ean.showEmpName=ean.EmployeeAttendanceGridList[index].employeeName;
                                        ean.showEmpDesg=ean.EmployeeAttendanceGridList[index].employeeDesignationName;
                                        ean.showEmpId=ean.EmployeeAttendanceGridList[index].employeeId;
                                        ean.logoutAttendanceId=ean.EmployeeAttendanceGridList[index].employeeAttendanceId;
                                        ean.showEmpLoginInTime=ean.EmployeeAttendanceGridList[index].employeeInTime;
                                      });
                                    },
                                  ),


                                  SizedBox(height: 50,),

                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 100,
                                      width: 100,

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
                                          ]
                                      ),
                                      child: Center(
                                        child: Image.asset("assets/svg/drawer/avatar.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text("${ean.showEmpName}",
                                      style: AppTheme.userNameTS,
                                    ),
                                  ),
                                  SizedBox(height: 3,),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text("${ean.showEmpDesg}",
                                      style: AppTheme.userGroupTS,
                                    ),
                                  ),
                                  SizedBox(height: 3,),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text("${ean.showEmpLoginInTime}",
                                      style: TextStyle(fontSize: 16,fontFamily: 'RR',color: Colors.green)
                                    ),
                                  ),


                                ],
                              ),
                            )
                          ],
                        ),
                      ],
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
                                size: Size( SizeConfig.screenWidth, 65),
                                painter: RPSCustomPainter3(),
                              ),
                            ),

                            Container(
                              width:  SizeConfig.screenWidth,
                              height: 80,

                              child: Stack(

                                children: [


                                  AnimatedPositioned(
                                    bottom:0,
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
                                                ean.updateisEmployeeLogin(true);
                                                ean.clearinsertForm();
                                                ean.insertForm();
                                                pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                                              },
                                              child: Container(
                                                width: 130,
                                                height: 50,
                                                alignment: Alignment.centerLeft,
                                                child:FittedBox(
                                                  child:Image.asset(pageIndex==0?"assets/bottomIcons/Login-text-icon.png":
                                                  "assets/bottomIcons/Login-text-icon-gray.png")
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: (){
                                                ean.GetEmployeeAttendanceIssueDbHit(context, null);
                                                ean.updateisEmployeeLogin(false);
                                                ean.clearinsertForm();
                                                ean.insertForm();
                                                pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                                              },
                                              child: Container(
                                                width: 130,
                                                height: 50,
                                                alignment: Alignment.centerRight,
                                                child:FittedBox(
                                                  child:Image.asset(pageIndex==1?"assets/bottomIcons/Logout-text-icon.png":
                                                  "assets/bottomIcons/Logout-text-icon-gray.png")
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: SizeConfig.width20,),
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: (){
                          if(ean.showEmpId==null){
                            CustomAlert().commonErrorAlert(context, "Select Employee Code", "");
                          }
                          else{
                            ean.InsertEmployeeAttendanceDbHit(context);
                          }
                        },
                        child: Container(

                          height: 65,
                          width: 65,
                          margin: EdgeInsets.only(bottom: 20),
                          decoration:BoxDecoration(
                            shape: BoxShape.circle,
                            color: ean.isEmployeeLogin? Colors.green:AppTheme.red,
                            boxShadow: [
                              BoxShadow(
                                color: ean.isEmployeeLogin?  Colors.green.withOpacity(0.4):AppTheme.red.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(1, 8), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon( ean.isEmployeeLogin? Icons.arrow_upward:Icons.power_settings_new_outlined,size: 40,color: Colors.white,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )

      ),
    );
  }
}
