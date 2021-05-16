import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/employeeSalaryNotifier.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/searchdropdownSingleSelect.dart';


class EmployeeSalaryAddNew extends StatefulWidget {
  VoidCallback drawerCallback;
  bool fromsaleGrid;
  EmployeeSalaryAddNew({this.drawerCallback,this.fromsaleGrid:false});

  @override
  _EmployeeSalaryAddNewState createState() => _EmployeeSalaryAddNewState();
}

class _EmployeeSalaryAddNewState extends State<EmployeeSalaryAddNew> {

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
      body: Consumer<EmployeeSalaryNotifier>(
          builder: (context,esn,child)=> Container(
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
                        height: 170,

                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/svg/gridHeader/salary.jpg",),
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

                                        scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      },
                                      value: esn.employeeCodeController.text,
                                      controller: esn.employeeCodeController,
                                      reduceWidth: SizeConfig.width40,
                                      required: false,
                                      hintText: 'Search Employee Code',
                                      textStyle: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.addNewTextFieldText),
                                      items: esn.searchEmpList,
                                      strict: false,
                                      setter: (dynamic newValue) {},
                                      onValueChanged: (v){
                                        node.unfocus();
                                        setState(() {
                                          
                                          int index;
                                          index=esn.gridData.indexWhere((element) => "${element['Name']}  -  ${element['Employee Code']}"==v.toString()).toInt();
                                          esn.showEmpId=esn.gridData[index]['EmployeeId'];
                                          esn.showEmpName=esn.gridData[index]['Name'];
                                          esn.showEmpDesg=esn.gridData[index]['Designation'];
                                          esn.showEmpShift=esn.gridData[index]['Shift'];
                                          esn.showEmpMonthlySalary=esn.gridData[index]['Monthly Salary'].toString();
                                          esn.showEmpEarnedSalary=esn.gridData[index]['Earned Salary'].toString();
                                          esn.showEmpPresentDay=esn.gridData[index]['Present Days'];
                                          esn.TotalPresentDays=esn.gridData[index]['TotalPresentDays'];
                                          esn.showEmpOvertime=esn.gridData[index]['OT'].toString();
                                          esn.showEmpAdvanceAmount=esn.gridData[index]['Advance/Loan'].toString();
                                          esn.showEmpNetPay=esn.gridData[index]['NetPay'].toString();
                                          esn.showEmpEMI=esn.gridData[index]['LoanEMIAmount'].toString();
                                          esn.IsPaid=esn.gridData[index]['IsPaid'];
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
                             //       employeeId?ValidationErrorText(title: "* Select Employee",):Container(),


                                    SizedBox(height: 20,),
                                    Container(
                                      margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,),
                                      height:40,
                                      width: SizeConfig.screenWidthM40,
                                      decoration: BoxDecoration(
                                          color: tableColor,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(3),topRight: Radius.circular(3)),
                                          border: Border.all(color: AppTheme.addNewTextFieldBorder)

                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.only(left: SizeConfig.width10),
                                              width: (SizeConfig.screenWidthM40*0.5)-2,
                                              child: Text("Employee Name",style: tableTextStyle,)
                                          ),

                                          Container(
                                              height: 50,
                                              width: 1,
                                              color: AppTheme.addNewTextFieldBorder
                                          ),

                                          Container(
                                            padding: EdgeInsets.only(left: SizeConfig.width10),
                                            height: 16,
                                            alignment: Alignment.centerLeft,
                                            width: (SizeConfig.screenWidthM40*0.5)-1,

                                            child: FittedBox(child: Text("${esn.showEmpName??""}",

                                              style:tableTextStyle,textAlign: TextAlign.left,
                                            ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    for(int i=0;i<8;i++)
                                      Container(
                                        margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,),
                                        height:40,
                                        width: SizeConfig.screenWidthM40,
                                        decoration: BoxDecoration(
                                            color: tableColor,
                                            //   borderRadius: BorderRadius.circular(3),
                                            border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                              right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom: BorderSide(color: AppTheme.addNewTextFieldBorder),

                                            )

                                        ),
                                        child:Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.only(left: SizeConfig.width10),
                                                width: (SizeConfig.screenWidthM40*0.5)-2,
                                                child: Text(i==0?"Designation":i==1?"Shift":i==2?"Monthly Salary":i==3?"Present Day":
                                                            i==4?"Earned Salary":i==5?"Over Time":i==6?"Advance Amount":"Loan EMI/Month",
                                                  style: tableTextStyle,
                                                )
                                            ),

                                            Container(
                                                height: 50,
                                                width: 1,
                                                color: AppTheme.addNewTextFieldBorder
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(left: SizeConfig.width10),
                                              height: 16,
                                              alignment: Alignment.centerLeft,
                                            // width:200,
                                             width: (SizeConfig.screenWidthM40*0.5)-1,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text("${i==0?esn.showEmpDesg??"":i==1?esn.showEmpShift:i==2?esn.showEmpMonthlySalary:i==3?esn.showEmpPresentDay:
                                                              i==4?esn.showEmpEarnedSalary??"":i==5?esn.showEmpOvertime:i==6?esn.showEmpAdvanceAmount:esn.showEmpEMI}",
                                                  style: tableTextStyle,
                                                ),

                                              ),
                                            ),
                                          ],
                                        ),
                                      ),


                                    Container(
                                     width: SizeConfig.screenWidth,
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start ,
                                        children: [
                                          SizedBox(height: 20,),
                                          Container(
                                            //width: 150,
                                            height: 20,

                                           // alignment: Alignment.centerLeft,
                                            child: Text("Net Pay",
                                                style: TextStyle(fontSize: 11
                                                    ,fontFamily: 'RR',color:Colors.green)
                                            ),
                                          ),
                                          Container(
                                         //   width: 150,
                                            height: 20,
                                          //  alignment: Alignment.centerLeft,
                                            child: Text("${esn.showEmpNetPay}",
                                                style: TextStyle(fontSize: 20
                                                    ,fontFamily: 'RM',color:Colors.green)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),










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
                      CancelButton(
                        ontap: (){
                          esn.clearInsertForm();
                          Navigator.pop(context);
                        },
                      ),

                      Text("Add Employee Salary",
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
                  child: AddButton(
                    ontap: (){
                      node.unfocus();
                      if(esn.IsPaid!=null){
                        if(esn.IsPaid==0){
                          esn.InsertEmployeeSalaryDbHit(context);
                        }
                        else{
                          CustomAlert().commonErrorAlert(context, "Already Paid", "");
                        }
                      }


                    },
                  ),
                ),



                Container(

                  height: isAmountTypeOpen || isDueOpen? SizeConfig.screenHeight:0,
                  width: isAmountTypeOpen || isDueOpen ? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),

                ),



                ///////////////////////////////// Loader//////////////////////////////////
                Container(

                  height: esn.employeeSalaryLoader ? SizeConfig.screenHeight:0,
                  width:esn.employeeSalaryLoader? SizeConfig.screenWidth:0,
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
  TextStyle tableTextStyle=TextStyle(fontFamily: 'RR',color: AppTheme.bgColor);
  Color tableColor=AppTheme.disableColor.withOpacity(0.5);
}