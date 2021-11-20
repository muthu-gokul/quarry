import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/employeeNotifier.dart';
import 'package:quarry/pages/employee/employeeMaster/employeeView.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTable2.dart';

import 'employeeMasterAddNew.dart';

class EmployeeMasterGrid extends StatefulWidget {
  VoidCallback? drawerCallback;
  EmployeeMasterGrid({this.drawerCallback});


  @override
  _EmployeeMasterGridState createState() => _EmployeeMasterGridState();
}

class _EmployeeMasterGridState extends State<EmployeeMasterGrid> {
  bool showEdit=false;
  int? selectedIndex;
  List<GridStyleModel> gridDataRowListEmployee=[
    GridStyleModel(columnName: "Employee Code"),
    GridStyleModel(columnName: "Name"),
    GridStyleModel(columnName: "Designation"),
    GridStyleModel(columnName: "Phone Number"),
    GridStyleModel(columnName: "Email"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EmployeeNotifier>(
          builder: (context,en,child)=> Stack(
            children: [
              Container(
                height: 70,
                width: SizeConfig.screenWidth,
                color: AppTheme.yellowColor,
                padding: AppTheme.gridAppBarPadding,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.drawerCallback,
                      child: NavBarIcon(),
                    ),
                    /*SizedBox(width: SizeConfig.width10,),*/
                    Text("Employee Detail",
                      style: AppTheme.appBarTS,
                    ),
                  ],
                ),
              ),


          CustomDataTable2(
            topMargin: 50,
            gridBodyReduceHeight: 140,
            selectedIndex: selectedIndex,

            gridData: en.employeeGridList,
            gridDataRowList: gridDataRowListEmployee,
            func: (index){

              en.updateEmployeeEdit(true);
              en.EmployeeDropDownValues(context);
              en.GetEmployeeIssueDbHit(context, en.employeeGridList[index].employeeId);
              Navigator.push(context, _createRouteView());


              /*if(selectedIndex==index){
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
              Align(
                alignment: Alignment.bottomCenter,
                child: AddButton(
                  ontap: (){

                    en.updateEmployeeEdit(false);
                    en.EmployeeDropDownValues(context);
                    Navigator.push(context, _createRoute());
                  },
                  image: "assets/svg/plusIcon.svg",
                ),
              ),





          Container(

            height: en.EmployeeLoader? SizeConfig.screenHeight:0,
            width: en.EmployeeLoader? SizeConfig.screenWidth:0,
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
            ),
          )

            ],
          )
      ),
    );
  }
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EmployeeMasterAddNew(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteView() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EmployeeMasterView(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
