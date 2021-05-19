import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/employeeAttendanceNotifier.dart';
import 'package:quarry/notifier/employeeSalaryNotifier.dart';
import 'package:quarry/notifier/machineManagementNotifier.dart';
import 'package:quarry/pages/employee/employeeSalary/employeeSalaryAddNew.dart';
import 'package:quarry/pages/machineManagement/machineManagementAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/editDelete.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable2.dart';
import 'package:quarry/widgets/dateRangePicker.dart' as DateRagePicker;
import 'package:quarry/widgets/staticColumnScroll/customDataTableWithoutModel.dart';




class MachineManagementGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  MachineManagementGrid({this.drawerCallback});

  @override
  _MachineManagementGridState createState() => _MachineManagementGridState();
}

class _MachineManagementGridState extends State<MachineManagementGrid> {

  bool showEdit=false;
  int selectedIndex;



  DateTime dateTime=DateTime.parse('2021-01-01');

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Scaffold(
      body:Consumer<MachineManagementNotifier>(
          builder: (context,mmn,child)=>
              Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      height: 70,
                      width: SizeConfig.screenWidth,
                      color: AppTheme.yellowColor,

                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: widget.drawerCallback,
                            child: NavBarIcon(),
                          ),
                          Text("Machine Management",
                              style: AppTheme.appBarTS
                          ),
                          Spacer(),
                          /*   Theme(
                            data: ThemeData(
                              accentColor: Colors.blue,
                            ),
                            child: GestureDetector(
                              onTap: () async {

                                final DateTime picked = await showDatePicker(
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
                          ),*/
                        ],
                      ),
                    ),


                    CustomDataTable3(
                      topMargin: 50,
                      gridBodyReduceHeight: 140,
                      selectedIndex: selectedIndex,

                      gridData: mmn.gridData,
                      gridDataRowList: mmn.gridDataRowList,
                      func: (index){

                           if(selectedIndex==index){
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
                              }
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
                                size: Size( SizeConfig.screenWidth, 65),
                                painter: RPSCustomPainter3(),
                              ),
                            ),

                            Container(
                              width:  SizeConfig.screenWidth,
                              height: 80,

                              child: Stack(

                                children: [


                                  EditDelete(
                                    showEdit: showEdit,
                                    editTap: (){
                                      mmn.updateMachineManagementEdit(true);
                                      mmn.PlantUserDropDownValues(context);
                                      mmn.MachineManagementDropDownValues(context);
                                      mmn.GetMachineManagementDbHit(context, mmn.gridData[selectedIndex]['MachineManagementId'], mmn.gridData[selectedIndex]['MachineId']);
                                      Navigator.push(context, _createRoute());

                                      setState(() {
                                        selectedIndex=-1;
                                        showEdit=false;
                                      });
                                    },
                                  ),

                                  /*AnimatedPositioned(
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
                                                mmn.updateMachineManagementEdit(true);
                                                mmn.PlantUserDropDownValues(context);
                                                mmn.MachineManagementDropDownValues(context);
                                                mmn.GetMachineManagementDbHit(context, mmn.gridData[selectedIndex]['MachineManagementId'], mmn.gridData[selectedIndex]['MachineId']);
                                                Navigator.push(context, _createRoute());

                                                setState(() {
                                                  selectedIndex=-1;
                                                  showEdit=false;
                                                });
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
                                  )*/

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
                      child: AddButton(
                        ontap: (){
                          mmn.updateMachineManagementEdit(false);
                          mmn.PlantUserDropDownValues(context);
                          mmn.MachineManagementDropDownValues(context);
                          Navigator.push(context, _createRoute());

                        },
                        image: "assets/svg/plusIcon.svg",
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
      pageBuilder: (context, animation, secondaryAnimation) => MachineManagementAddNew(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
