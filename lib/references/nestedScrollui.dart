import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/autocompleteText.dart';
import 'package:quarry/widgets/customTextField.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/enployeeAdvanceLoanNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/searchdropdownSingleSelect.dart';
import 'package:quarry/widgets/sidePopUp/sidePopupWithoutModelList.dart';
import 'package:quarry/widgets/validationErrorText.dart';





class PlantDetailsGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  PlantDetailsGrid({this.drawerCallback});
  @override
  PlantDetailsGridState createState() => PlantDetailsGridState();
}

class PlantDetailsGridState extends State<PlantDetailsGrid> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;
  bool _keyboardVisible = false;


  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


      listViewController.addListener(() {
        print("List SCROLL--${listViewController.offset}");
        if(listViewController.offset>20){

          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);


        }
        else if(listViewController.offset==0){
          scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<QuarryNotifier>(
          builder: (context,qn,child)=> Stack(
            children: [



              Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: SizeConfig.height200,

                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/saleFormheader.jpg",),
                              fit: BoxFit.cover
                          )

                      ),
                      /*  child:
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                     IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                                     SizedBox(width: SizeConfig.width5,),
                                     Text("Company Detail",
                                       style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                                     ),
                                     Spacer(),

                                   ],
                                 ),
                                 Spacer(),
                                 // Image.asset("assets/images/saleFormheader.jpg",height: 100,),
                                 // Container(
                                 //   height: SizeConfig.height50,
                                 //   color: Color(0xFF753F03),
                                 //
                                 // ) // Container(
                                 //   height: SizeConfig.height50,
                                 //   color: Color(0xFF753F03),
                                 //
                                 // )
                               ],
                             ),*/
                    ),





                  ],
                ),
              ),


              Container(
                height: SizeConfig.screenHeight,
                // color: Colors.transparent,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(height: 160,),
                      Container(
                        height: SizeConfig.screenHeight-60,
                        width: SizeConfig.screenWidth,

                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                        ),
                        child: ListView(
                          controller: listViewController,
                          scrollDirection: Axis.vertical,

                          children: [
                            Container(
                              height: 200,
                              child: Row(
                                children: [
                                  Container(
                                    height: 200,
                                    width: SizeConfig.screenWidth*0.5,
                                    color: Colors.white,
                                    child: Center(
                                      child: Container(
                                        height: 80,
                                        width: 80,
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
                                          child: Icon(Icons.add,color: Colors.white,size: 40,),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 200,
                                    width: SizeConfig.screenWidth*0.5,
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 50,),
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: AppTheme.uploadColor,width: 2)
                                          ),
                                        ),

                                        SizedBox(height: 20,),
                                        Text("${qn.plantGridList[0].plantName}  ",
                                          style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RM',fontSize: 14),
                                        ),
                                        SizedBox(height: 3,),
                                        Text("${qn.plantGridList[0].location}  ",
                                          style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RR',fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),


                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: SizeConfig.height60,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.clear,color: Colors.white,), onPressed: (){
                      Navigator.pop(context);
                    }),
                    SizedBox(width: SizeConfig.width5,),
                    Text("Our Plants",
                      style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                    ),

                  ],
                ),
              ),


              Container(

                height: qn.insertCompanyLoader? SizeConfig.screenHeight:0,
                width: qn.insertCompanyLoader? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                  //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

                ),
              ),
            ],
          )
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PlantDetailsGrid(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}

/*
onVerticalDragUpdate: (details){
int sensitivity = 5;

if (details.delta.dy > sensitivity) {
scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

} else if(details.delta.dy < -sensitivity){
scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
}
},*/

/*
NotificationListener<ScrollNotification>(
onNotification: (s){
if(s is ScrollStartNotification){
}
},*/



/* Navigator.of(context).push(
                                      PageRouteBuilder(
                                        transitionDuration: Duration(milliseconds: 1000),
                                        pageBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double> secondaryAnimation) {
                                          return SettingsPage();
                                        },
                                        transitionsBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double> secondaryAnimation,
                                            Widget child) {
                                          return Align(
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                      ),
                                    );*/






















class EmployeeAdvanceAddNew extends StatefulWidget {
  VoidCallback drawerCallback;
  bool fromsaleGrid;
  EmployeeAdvanceAddNew({this.drawerCallback,this.fromsaleGrid:false});

  @override
  _EmployeeAdvanceAddNewState createState() => _EmployeeAdvanceAddNewState();
}

class _EmployeeAdvanceAddNewState extends State<EmployeeAdvanceAddNew> {

  ScrollController scrollController;
  ScrollController listViewController;
  bool _keyboardVisible=false;
  bool isListScroll=false;
  bool isAmountTypeOpen=false;
  bool isDueOpen=false;

  //validations
  bool employeeId=false;
  bool amountType=false;
  bool advanceAmount=false;
  bool loanAmount=false;

  @override
  void initState() {
    scrollController = new ScrollController();
    listViewController = new ScrollController();
    setState(() {

    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final node=FocusScope.of(context);
    SizeConfig().init(context);
    //node.unfocus();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<EmployeeAdvanceLoanNotifier>(
          builder: (context,eal,child)=> Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            child: Stack(
              children: [
                //Image
                Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: 200,

                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/saleFormheader.jpg",),
                                fit: BoxFit.cover
                            )

                        ),
                      )
                    ],
                  ),
                ),

                //Form
                Container(
                  height: SizeConfig.screenHeight-70,
                  // color: Colors.transparent,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      children: [
                        SizedBox(height: 160,),
                        Container(
                          height: SizeConfig.screenHeight,
                          width: SizeConfig.screenWidth,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                              color: AppTheme.gridbodyBgColor,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                          ),
                          child: GestureDetector(
                            onVerticalDragUpdate: (details){

                              int sensitivity = 5;
                              if (details.delta.dy > sensitivity) {
                                scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                                  if(isListScroll){
                                    setState(() {
                                      isListScroll=false;
                                    });
                                  }
                                });

                              } else if(details.delta.dy < -sensitivity){
                                scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

                                  if(!isListScroll){
                                    setState(() {
                                      isListScroll=true;
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                              height:  SizeConfig.screenHeight ,
                              width: SizeConfig.screenWidth,

                              decoration: BoxDecoration(
                                  color: AppTheme.gridbodyBgColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))
                              ),
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (s){
                                  if(s is ScrollStartNotification){

                                    if(listViewController.offset==0 && isListScroll && scrollController.offset==100 && listViewController.position.userScrollDirection==ScrollDirection.idle){
                                      Timer(Duration(milliseconds: 100), (){
                                        if(listViewController.position.userScrollDirection!=ScrollDirection.reverse){
                                          if(listViewController.offset==0){
                                            scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value) {
                                              if(isListScroll){
                                                setState(() {
                                                  isListScroll=false;
                                                });
                                              }
                                            });
                                          }
                                        }
                                      });
                                    }
                                  }
                                },
                                child: ListView(
                                  controller: listViewController,
                                  scrollDirection: Axis.vertical,
                                  physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                                  children: [

                                    DropDownField(
                                      add: (){
                                      },
                                      nodeFocus: (){
                                        node.unfocus();
                                      },
                                      ontap:(){
                                        setState(() {
                                          _keyboardVisible=true;
                                        });
                                        scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      },
                                      value: eal.employeeCodeController.text,
                                      controller: eal.employeeCodeController,
                                      reduceWidth: SizeConfig.width40,
                                      required: false,
                                      hintText: 'Search Employee Code',
                                      textStyle: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.addNewTextFieldText),
                                      items: eal.searchEmpList,
                                      strict: false,
                                      setter: (dynamic newValue) {},
                                      onValueChanged: (v){
                                        node.unfocus();
                                        setState(() {
                                          eal.selectedEmployeeCode=v;
                                          int index;
                                          index=eal.empList.indexWhere((element) => "${element.employeeName}  -  ${element.employeePrefix+element.employeeCode}"==v.toString()).toInt();
                                          eal.showEmpName=eal.empList[index].employeeName;
                                          eal.showEmpDesg=eal.empList[index].employeeDesignationName;
                                          eal.showEmpWorkingDays=eal.empList[index].workingDays;
                                          eal.showEmpLeaveDays=eal.empList[index].leaveDays;
                                          eal.showEmpNetPay=eal.empList[index].netPay;
                                          eal.showEmpId=eal.empList[index].employeeId;
                                          _keyboardVisible=false;
                                        });
                                      },
                                      onEditingcomplete: (){
                                        node.unfocus();
                                        Timer(Duration(milliseconds: 100), (){
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        });
                                      },
                                    ),
                                    employeeId?ValidationErrorText(title: "* Select Employee",):Container(),


                                    GestureDetector(
                                      onTap: () {
                                        node.unfocus();
                                        setState(() {
                                          _keyboardVisible=false;
                                          isAmountTypeOpen=true;
                                        });
                                      },
                                      child: SidePopUpParent(
                                        text: eal.selectedAmountType == null ? "Select Amount Type" : eal.selectedAmountType,
                                        textColor: eal.selectedAmountType == null ? AppTheme.addNewTextFieldText.withOpacity(0.5) : AppTheme.addNewTextFieldText,
                                        iconColor: eal.selectedAmountType == null ? AppTheme.addNewTextFieldText : AppTheme.yellowColor,
                                        bgColor: eal.selectedAmountType == null ? AppTheme.disableColor  : Colors.white,
                                      ),
                                    ),
                                    amountType?ValidationErrorText(title: "* Select Amount Type",):Container(),









                                    SizedBox(height: _keyboardVisible? SizeConfig.screenHeight*0.6:200,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                //Appbar
                Container(
                  height: 60,
                  width: SizeConfig.screenWidth,
                  child: Row(
                    children: [
                      IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                        eal.clearinsertForm();
                        eal.clearAmount();
                        Navigator.pop(context);
                      }),
                      SizedBox(width: SizeConfig.width5,),
                      Text("Add Advance Salary/Loan Entry",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                      ),
                    ],
                  ),
                ),



                //bottomNav
                Positioned(
                  bottom:_keyboardVisible? -70:0,
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


                    },
                    child: Container(

                      height:_keyboardVisible? 0:65,
                      width: 65,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration:BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.yellowColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.yellowColor.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(1, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon( Icons.done,size:_keyboardVisible? 0:40,color: AppTheme.bgColor,),
                      ),
                    ),
                  ),
                ),


                Container(

                  height: isAmountTypeOpen || isDueOpen? SizeConfig.screenHeight:0,
                  width: isAmountTypeOpen || isDueOpen ? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),

                ),



                ///////////////////////////////// Loader//////////////////////////////////
                Container(

                  height: eal.EmployeeAttendanceLoader ? SizeConfig.screenHeight:0,
                  width:eal.EmployeeAttendanceLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                  ),

                ),



              ],
            ),
          )
      ),
    );
  }
}