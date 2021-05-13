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
                                  //   print(ScrollStartNotification);
                                  if(s is ScrollStartNotification){

                                    if(listViewController.offset==0 && isListScroll && scrollController.offset==100 && listViewController.position.userScrollDirection==ScrollDirection.idle){

                                      Timer(Duration(milliseconds: 100), (){
                                        if(listViewController.position.userScrollDirection!=ScrollDirection.reverse){

                                          //if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
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


                                    eal.selectedAmountType==null && eal.showEmpId!=null?Column(
                                      children: [
                                        SizedBox(height: 20,),
                                        Container(
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
                                        SizedBox(height: 20,),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text("${eal.showEmpName}",
                                            style: AppTheme.userNameTS,
                                          ),
                                        ),
                                        SizedBox(height: 3,),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text("${eal.showEmpDesg}",
                                            style:AppTheme.userDesgTS,
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text("Working Days: ${eal.showEmpWorkingDays}",
                                              style: TextStyle(fontSize: 16,fontFamily: 'RR',color:AppTheme.grey.withOpacity(0.5))
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text("Leave Days: ${eal.showEmpLeaveDays}",
                                              style: TextStyle(fontSize: 14,fontFamily: 'RR',color:AppTheme.red.withOpacity(0.9))
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Container(
                                          width: 150,
                                          height: 20,

                                          alignment: Alignment.centerLeft,
                                          child: Text("Net Pay",
                                              style: TextStyle(fontSize: 11
                                                  ,fontFamily: 'RR',color:Colors.green)
                                          ),
                                        ),
                                        Container(
                                          width: 150,
                                          height: 20,
                                          alignment: Alignment.centerLeft,
                                          child: Text("${eal.showEmpNetPay}",
                                              style: TextStyle(fontSize: 20
                                                  ,fontFamily: 'RM',color:Colors.green)
                                          ),
                                        ),

                                      ],
                                    ):
                                    eal.selectedAmountType=="Advance"?Column(
                                      children: [
                                        AddNewLabelTextField(
                                          labelText: 'Advance Amount',
                                          textInputType: TextInputType.number,
                                          textEditingController: eal.advanceAmountController,
                                          scrollPadding: 400,
                                          ontap: () {
                                            setState(() {
                                              _keyboardVisible=true;
                                              isListScroll=true;
                                            });
                                            scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          },

                                          onEditComplete: () {
                                            node.unfocus();
                                            Timer(Duration(milliseconds: 100), (){
                                              setState(() {
                                                _keyboardVisible=false;
                                              });
                                            });
                                          },
                                        ),
                                        advanceAmount?ValidationErrorText(title: "* Enter Advance Amount",):Container(),
                                        AddNewLabelTextField(
                                          labelText: 'Reason',
                                          textEditingController: eal.advanceReasonController,
                                          scrollPadding: 400,
                                          ontap: () {
                                            setState(() {
                                              _keyboardVisible=true;
                                              isListScroll=true;
                                            });
                                            scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          },

                                          onEditComplete: () {
                                            node.unfocus();
                                            Timer(Duration(milliseconds: 100), (){
                                              setState(() {
                                                _keyboardVisible=false;
                                              });
                                            });
                                          },
                                        ),
                                      ],
                                    ):
                                    eal.selectedAmountType=="Loan"?Column(
                                      children: [
                                        AddNewLabelTextField(
                                          labelText: 'Loan Amount',
                                          textInputType: TextInputType.number,
                                          textEditingController: eal.loanAmountController,
                                          scrollPadding: 400,
                                          ontap: () {
                                            setState(() {
                                              _keyboardVisible=true;
                                              isListScroll=true;
                                            });
                                            scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          },
                                          onChange: (v){
                                            eal.emiCalc();
                                          },

                                          onEditComplete: () {
                                            node.unfocus();
                                            Timer(Duration(milliseconds: 100), (){
                                              setState(() {
                                                _keyboardVisible=false;
                                              });
                                            });
                                          },
                                        ),
                                        loanAmount?ValidationErrorText(title: "* Enter Loan Amount",):Container(),

                                        GestureDetector(
                                          onTap: () {
                                            node.unfocus();
                                            setState(() {
                                              _keyboardVisible=false;
                                              isDueOpen=true;
                                            });
                                          },
                                          child: SidePopUpParent(
                                            text: eal.selectedMonthDue == null ? "Select Month Due" : eal.selectedMonthDue.toString(),
                                            textColor: eal.selectedMonthDue == null ? AppTheme.addNewTextFieldText.withOpacity(0.5) : AppTheme.addNewTextFieldText,
                                            iconColor: eal.selectedMonthDue == null ? AppTheme.addNewTextFieldText : AppTheme.yellowColor,
                                            bgColor: eal.selectedMonthDue == null ? AppTheme.disableColor  : Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        Container(
                                          height: 50,
                                          width: SizeConfig.screenWidth,
                                          padding: EdgeInsets.only(left: 10),
                                          margin: AppTheme.leftRightMargin20,
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                            border:Border.all(color: AppTheme.addNewTextFieldBorder),
                                            borderRadius: BorderRadius.circular(3),
                                            color: AppTheme.disableColor
                                          ),
                                          child: Text(eal.emiAmount>0?"${eal.emiAmount}":"EMI/Month",style: TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),),
                                        ),
                                        AddNewLabelTextField(
                                          labelText: 'Reason',
                                          textEditingController: eal.loanReasonController,
                                          scrollPadding: 500,
                                          ontap: () {
                                            setState(() {
                                              _keyboardVisible=true;
                                              isListScroll=true;
                                            });
                                            scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          },

                                          onEditComplete: () {
                                            node.unfocus();
                                            Timer(Duration(milliseconds: 100), (){
                                              setState(() {
                                                _keyboardVisible=false;
                                              });
                                            });
                                          },
                                        ),

                                      ],
                                    ):Container(),






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
                       if(eal.showEmpId==null){setState(() {employeeId=true;});}
                       else{setState(() {employeeId=false;});}

                       if(eal.selectedAmountType==null){setState(() {amountType=true;});}
                       else{setState(() {amountType=false;});}

                       if(eal.selectedAmountType=="Advance"){
                         if(eal.advanceAmountController.text.isEmpty){setState(() {advanceAmount=true;});}
                         else{setState(() {advanceAmount=false;});}

                         if(!employeeId && !amountType && !advanceAmount){
                           eal.InsertEmployeeLoanAttendanceDbHit(context);
                         }
                       }
                       else if(eal.selectedAmountType=="Loan"){
                         if(eal.loanAmountController.text.isEmpty){setState(() {loanAmount=true;});}
                         else{setState(() {loanAmount=false;});}

                         if(!employeeId && !amountType && !loanAmount){
                           eal.InsertEmployeeLoanAttendanceDbHit(context);
                         }
                       }


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
                ///////////Amount Type Open
                PopUpStatic2(
                  title: "Select Amount Type",

                  isOpen: isAmountTypeOpen,
                  dataList: eal.amountTypeList,
                  propertyKeyName:"AmountType",
                  propertyKeyId: "AmountType",
                  selectedId: eal.selectedAmountType,
                  itemOnTap: (index){
                    setState(() {
                      isAmountTypeOpen=false;
                      if(eal.selectedAmountType!=eal.amountTypeList[index]['AmountType']){
                        eal.clearAmount();
                      }
                      eal.selectedAmountType=eal.amountTypeList[index]['AmountType'];

                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isAmountTypeOpen=false;
                    });
                  },


                ),

                ////// Month Due
                PopUpStatic2(
                  title: "Select Month Due",

                  isOpen: isDueOpen,
                  dataList: eal.monthList,
                  propertyKeyName:"Due",
                  propertyKeyId: "Due",
                  selectedId: eal.selectedMonthDue,
                  itemOnTap: (index){
                    setState(() {
                      isDueOpen=false;
                      eal.selectedMonthDue=eal.monthList[index]['Due'];
                    });
                    eal.emiCalc();
                  },
                  closeOnTap: (){
                    setState(() {
                      isDueOpen=false;
                    });
                  },


                ),


              ],
            ),
          )
      ),
    );
  }
}
