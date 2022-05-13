import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/notifier/employeeNotifier.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';
import 'package:quarry/widgets/singleDatePicker.dart';
import 'package:quarry/widgets/validationErrorText.dart';

import '../../../utils/widgetUtils.dart';
import '../../../widgets/logoPicker.dart';

class EmployeeMasterAddNew extends StatefulWidget {
  const EmployeeMasterAddNew({Key? key}) : super(key: key);

  @override
  _EmployeeMasterAddNewState createState() => _EmployeeMasterAddNewState();
}

class _EmployeeMasterAddNewState extends State<EmployeeMasterAddNew> with TickerProviderStateMixin{
  ScrollController? scrollController;
  ScrollController? listViewController;
  bool isListScroll=false;
  bool _keyboardVisible=false;
  bool salutationOpen=false;
  bool salaryTypeOpen=false;

  bool isDesignationOpen=false;
  bool isEmployeeTypeOpen=false;
  bool isShiftOpen=false;
  bool isBloodGroupOpen=false;
  bool isMaritalOpen=false;
  bool isPaymentTypeOpen=false;


  late Animation contactArrowAnimation;
  late AnimationController contactArrowAnimationController;
  bool contactOpen=false;

  late Animation otherDetailsArrowAnimation;
  late AnimationController otherDetailsArrowAnimationController;
  bool otherDetailsOpen=false;

  late Animation BankDetailsArrowAnimation;
  late AnimationController BankDetailsArrowAnimationController;
  bool BankDetailsOpen=false;


  //validations
  bool firstName=false;
  bool designation=false;
  bool employeeType=false;
  bool salary=false;
  bool dob=false;
  bool phoneNo=false;
  bool address=false;
  bool aadhaar=false;
  bool emailValid=true;

  @override
  void initState() {
    scrollController = new ScrollController();
    listViewController = new ScrollController();

    contactArrowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    otherDetailsArrowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    BankDetailsArrowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    contactArrowAnimation = Tween(begin: 0.0, end:-3.14).animate(contactArrowAnimationController);
    otherDetailsArrowAnimation = Tween(begin: 0.0, end:-3.14).animate(otherDetailsArrowAnimationController);
    BankDetailsArrowAnimation = Tween(begin: 0.0, end:-3.14).animate(BankDetailsArrowAnimationController);
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node=FocusScope.of(context);
    SizeConfig().init(context);
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<EmployeeNotifier>(
          builder: (context,en,child)=>  Container(
            height: SizeConfig.screenHeight,
            child: Stack(
              children: [
                //IMAGE
                Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: 180,

                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/svg/gridHeader/Employeemaster.jpg",),
                                fit: BoxFit.cover
                            )

                        ),
                      ),


                    ],
                  ),
                ),


                //FORM
                Container(
                  height: SizeConfig.screenHeight!-(65),
                  // color: Colors.transparent,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: scrollController,
                    child: Stack(
                      children: [
                        Column(
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
                                    scrollController!.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                                      if(isListScroll){
                                        setState(() {
                                          isListScroll=false;
                                        });
                                      }
                                    });

                                  } else if(details.delta.dy < -sensitivity){
                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

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
                                    onNotification: (s) {
                                      //   print(ScrollStartNotification);
                                      if (s is ScrollStartNotification) {
                                        if (listViewController!.offset == 0 &&
                                            isListScroll &&
                                            scrollController!.offset == 100 &&
                                            listViewController!.position
                                                .userScrollDirection ==
                                                ScrollDirection.idle) {
                                          Timer(
                                              Duration(milliseconds: 100), () {
                                            if (listViewController!.position
                                                .userScrollDirection !=
                                                ScrollDirection.reverse) {
                                              //if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
                                              if (listViewController!.offset ==
                                                  0) {
                                                scrollController!.animateTo(0,
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeIn).then((
                                                    value) {
                                                  if (isListScroll) {
                                                    setState(() {
                                                      isListScroll = false;
                                                    });
                                                  }
                                                });
                                              }
                                            }
                                          });
                                        }
                                      }
                                      return true;
                                    },
                                    child: ListView(
                                      controller: listViewController,
                                      scrollDirection: Axis.vertical,
                                      physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                                      children: [


                                        SizedBox(height: 70,),
                                         Align(
                                           alignment: Alignment.center,
                                           child: Text("${en.EmployeePrefix}${en.EmployeeCode}",
                                              style: AppTheme.userNameTS,
                                            ),
                                         ),
                                         Align(
                                           alignment: Alignment.center,
                                           child: Text("Employee Code",
                                             style: AppTheme.userGroupTS,
                                            ),
                                         ),
                                        SizedBox(height: 20,),

                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn,
                                          height: salutationOpen? 120:50,
                                          width: SizeConfig.screenWidth,
                                          alignment: Alignment.topCenter,
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(

                                                  margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!),
                                                  padding: EdgeInsets.only(left:SizeConfig.width60!,),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                    color: Colors.white,
                                                  ),
                                                  width: SizeConfig.screenWidth,
                                                  height: 50,
                                                  alignment: Alignment.topCenter,
                                                  child:  TextFormField(
                                                    controller: en.employeeFirstName,
                                                    onTap: (){
                                                      scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                      setState(() {
                                                        _keyboardVisible=true;
                                                      });

                                                    },
                                                    style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                                    decoration: InputDecoration(
                                                      fillColor:Colors.white,
                                                      filled: true,
                                                      hintStyle: TextStyle(fontFamily: 'RL',fontSize: 15,color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
                                                      border:  InputBorder.none,
                                                      enabledBorder:   InputBorder.none,
                                                      focusedBorder:  InputBorder.none,
                                                      hintText:  'First Name',
                                                      /*contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),*/

                                                    ),
                                                    maxLines: null,
                                                    textInputAction: TextInputAction.done,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp('[A-Za-z ]')),
                                                    ],

                                                    onEditingComplete: (){
                                                      node.unfocus();
                                                      Timer(Duration(milliseconds: 50), (){
                                                        setState(() {
                                                          _keyboardVisible=false;
                                                        });
                                                      });
                                                    },
                                                  ),

                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: AnimatedContainer(
                                                  height:salutationOpen? 120:30,
                                                  width: 60,
                                                  duration: Duration(milliseconds: 300),
                                                  curve: Curves.easeIn,
                                                  margin: EdgeInsets.only(left: SizeConfig.width30!),
                                                  decoration: BoxDecoration(
                                                      color: AppTheme.yellowColor,
                                                      borderRadius: BorderRadius.circular(salutationOpen?5:15)
                                                  ),
                                                  child:salutationOpen? Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      InkWell(
                                                          onTap: (){
                                                            setState(() {
                                                              salutationOpen=false;
                                                              en.selectedSalutation="Mr";
                                                            });
                                                          },
                                                          child: Text("Mr",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                      ),
                                                      InkWell(
                                                          onTap: (){
                                                            setState(() {
                                                              salutationOpen=false;
                                                              en.selectedSalutation="Mrs";
                                                            });
                                                          },
                                                          child: Text("Mrs",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                      ),
                                                      InkWell(
                                                          onTap: (){
                                                            setState(() {
                                                              salutationOpen=false;
                                                              en.selectedSalutation="Ms";
                                                            });
                                                          },
                                                          child: Text("Ms",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                      ),
                                                      InkWell(
                                                          onTap: (){
                                                            setState(() {
                                                              salutationOpen=false;
                                                              en.selectedSalutation="Mx";
                                                            });
                                                          },
                                                          child: Text("Mx",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                      ),

                                                    ],
                                                  )
                                                      :Center(
                                                    child: InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                            salutationOpen=true;
                                                          });

                                                        },
                                                    child: Text("${en.selectedSalutation}",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                    ),
                                                  ),
                                                ),
                                              )


                                            ],
                                          ),
                                        ),
                                        firstName?ValidationErrorText(title:"* Enter First Name" ,):Container(),




                                        AddNewLabelTextField(
                                          labelText: 'Last Name',
                                          textEditingController: en.employeeLastName,
                                          regExp: '[A-Za-z  ]',
                                          ontap: () {
                                            setState(() {
                                              _keyboardVisible=true;
                                              isListScroll=true;
                                            });
                                            scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          },

                                          onEditComplete: () {
                                            node.unfocus();
                                            Timer(Duration(milliseconds: 100), (){
                                              setState(() {
                                                _keyboardVisible=false;
                                              });
                                            });
                                          },
                                          onChange: (v){},
                                        ),

                                        GestureDetector(

                                          onTap: () {
                                            node.unfocus();
                                            setState(() {
                                              _keyboardVisible=false;
                                              isDesignationOpen = true;
                                            });

                                          },
                                          child: SidePopUpParent(
                                            text: en.selectEmployeeDesignationName == null ? "Select Employee Designation " : en.selectEmployeeDesignationName,
                                            textColor: en.selectEmployeeDesignationName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5) : AppTheme.addNewTextFieldText,
                                            iconColor: en.selectEmployeeDesignationName == null ? AppTheme.addNewTextFieldText : AppTheme.yellowColor,
                                            bgColor: en.selectEmployeeDesignationName== null ? AppTheme.disableColor : Colors.white,
                                          ),
                                        ),
                                        designation?ValidationErrorText(title:"* Select Employee Designation" ,):Container(),
                                        GestureDetector(

                                          onTap: () {
                                            node.unfocus();
                                            setState(() {
                                              _keyboardVisible=false;
                                              isEmployeeTypeOpen = true;
                                            });

                                          },
                                          child: SidePopUpParent(
                                            text: en.selectEmployeeTypeName == null ? "Select Employee Type " : en.selectEmployeeTypeName,
                                            textColor: en.selectEmployeeTypeName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5) : AppTheme.addNewTextFieldText,
                                            iconColor: en.selectEmployeeTypeName == null ? AppTheme.addNewTextFieldText : AppTheme.yellowColor,
                                            bgColor: en.selectEmployeeTypeName== null ? AppTheme.disableColor : Colors.white,
                                          ),
                                        ),
                                        employeeType?ValidationErrorText(title:"* Select Employee Type" ,):Container(),
                                        GestureDetector(

                                          onTap: () {
                                            node.unfocus();
                                            setState(() {
                                              _keyboardVisible=false;
                                              isShiftOpen = true;
                                            });

                                          },
                                          child: SidePopUpParent(
                                            text: en.selectShiftName == null ? "Select Shift" : en.selectShiftName,
                                            textColor: en.selectShiftName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5) : AppTheme.addNewTextFieldText,
                                            iconColor: en.selectShiftName == null ? AppTheme.addNewTextFieldText : AppTheme.yellowColor,
                                            bgColor: en.selectShiftName== null ? AppTheme.disableColor : Colors.white,
                                          ),
                                        ),

                                        SizedBox(height: 15,),
                                        //salary type
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn,
                                          height: salaryTypeOpen? 100:50,
                                          width: SizeConfig.screenWidth,
                                          alignment: Alignment.topCenter,
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(

                                                  margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!),
                                                 // padding: EdgeInsets.only(left:SizeConfig.width20,),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                    color: Colors.white,
                                                  ),
                                                  width: SizeConfig.screenWidth,
                                                  height: 50,
                                                  alignment: Alignment.topCenter,
                                                  child:  TextFormField(
                                                    controller: en.employeeSalary,
                                                    scrollPadding: EdgeInsets.only(bottom: 400),
                                                    onTap: (){
                                                      scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                      setState(() {
                                                        _keyboardVisible=true;
                                                        isListScroll=true;
                                                      });

                                                    },
                                                    style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                                    decoration: InputDecoration(
                                                      fillColor:Colors.white,
                                                      filled: true,
                                                      hintStyle: TextStyle(fontFamily: 'RL',fontSize: 15,color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
                                                      border:  InputBorder.none,
                                                      enabledBorder:   InputBorder.none,
                                                      focusedBorder:  InputBorder.none,
                                                      hintText:  'Enter Salary',
                                                      /*contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),*/

                                                    ),
                                                    maxLines: null,
                                                    textInputAction: TextInputAction.done,
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp(decimalReg)),
                                                    ],

                                                    onEditingComplete: (){
                                                      node.unfocus();
                                                      Timer(Duration(milliseconds: 50), (){
                                                        setState(() {
                                                          _keyboardVisible=false;
                                                        });
                                                      });
                                                    },
                                                  ),

                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: AnimatedContainer(
                                                  height:salaryTypeOpen? 100:30,
                                                  width: 60,
                                                  duration: Duration(milliseconds: 300),
                                                  curve: Curves.easeIn,
                                                  margin: EdgeInsets.only(right: SizeConfig.width30!),
                                                  decoration: BoxDecoration(
                                                      color: AppTheme.yellowColor,
                                                      borderRadius: BorderRadius.circular(salaryTypeOpen?5:15)
                                                  ),
                                                  child:salaryTypeOpen? Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: en.employeeSalaryTypeList.asMap().map((i, value) =>
                                                        MapEntry(
                                                          i, InkWell(
                                                              onTap: (){
                                                                setState(() {

                                                                  en.selectSalaryTypeId=value.employeeSalaryTypeId;
                                                                  en.selectSalaryTypeName=value.employeeSalaryTypeName;
                                                                  salaryTypeOpen=false;
                                                                });
                                                              },
                                                              child: Text("${value.employeeSalaryTypeName}",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                          ),
                                                        )

                                                    ).values.toList()
                                                     /* InkWell(
                                                          onTap: (){
                                                            setState(() {
                                                              salutationOpen=false;
                                                              en.selectedSalutation="Mr";
                                                            });
                                                          },
                                                          child: Text("Mr",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                      ),*/



                                                  )
                                                      :Center(
                                                    child: InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                            salaryTypeOpen=true;
                                                          });

                                                        },
                                                        child: Text("${en.selectSalaryTypeName??""}",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                    ),
                                                  ),
                                                ),
                                              )


                                            ],
                                          ),
                                        ),
                                        salary?ValidationErrorText(title:"* Enter Salary" ,):Container(),

                                        GestureDetector(
                                          onTap: () async{
                                            node.unfocus();
                                            final DateTime? picked = await showDatePicker2(
                                                context: context,
                                                initialDate:  en.joiningDate==null?DateTime.now():en.joiningDate!, // Refer step 1
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime(2100),
                                                builder: (BuildContext context,Widget? child){
                                                  return Theme(
                                                    data: Theme.of(context).copyWith(
                                                      colorScheme: ColorScheme.light(
                                                        primary: AppTheme.yellowColor, // header background color
                                                        onPrimary: AppTheme.bgColor, // header text color
                                                        onSurface: AppTheme.addNewTextFieldText, // body text color
                                                      ),

                                                    ),
                                                    child: child!,
                                                  );
                                                });
                                            if (picked != null)
                                              setState(() {
                                                en.joiningDate = picked;
                                              });

                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top:15,),
                                            padding: EdgeInsets.only(left:SizeConfig.width10!,right:SizeConfig.width10!),
                                            height:50,
                                            width: double.maxFinite,
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                color: Colors.white
                                            ),
                                            child: Row(
                                              children: [
                                                Text(en.joiningDate==null?"Date of joining":DateFormat("dd-MM-yyyy").format(en.joiningDate!),
                                                  style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.hintColor),),
                                                Spacer(),
                                                Icon(Icons.calendar_today,color:Colors.grey ,size: 20,),
                                              ],
                                            ),
                                          ),
                                        ),


                                        //Contact details
                                        GestureDetector(
                                          onTap: (){
                                            contactArrowAnimationController.isCompleted
                                                ? contactArrowAnimationController.reverse()
                                                : contactArrowAnimationController.forward();

                                            setState(() {
                                              contactOpen=!contactOpen;
                                            });
                                            if(contactOpen){
                                              Timer(Duration(milliseconds: 300), (){
                                                listViewController!.animateTo(listViewController!.offset+ 350, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                                              });
                                            }
                                          },
                                          child:Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              height: 40,
                                              width: SizeConfig.screenWidth!*0.40,
                                              margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!,top: 20),
                                              padding: EdgeInsets.only(left: SizeConfig.width10!,right: SizeConfig.width10!),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: AppTheme.yellowColor,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text("Contact Details",style:TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 14)),
                                                  Spacer(),
                                                  Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppTheme.bgColor
                                                    ),
                                                    child:  AnimatedBuilder(
                                                      animation: contactArrowAnimationController,
                                                      builder: (context, child) =>
                                                          Transform.rotate(
                                                            angle: contactArrowAnimation.value,
                                                            child: Icon(
                                                              Icons.keyboard_arrow_up_rounded,
                                                              size: 25.0,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn,
                                          width: SizeConfig.screenWidth,
                                          height: contactOpen? (410+80.0):0,
                                          //  margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                          child: Column(
                                            children: [
                                              AddNewLabelTextField(
                                                labelText: 'Phone Number',
                                                textInputType: TextInputType.number,
                                                textLength: 10,
                                                regExp: '[0-9]',
                                                textEditingController: en.employeePhoneNumber,
                                                scrollPadding: 500,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },

                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                                onChange: (v){},
                                              ),
                                              phoneNo?ValidationErrorText(title:"* Enter Phone Number" ,):Container(),
                                              AddNewLabelTextField(
                                                labelText: 'Email Id',
                                                textInputType: TextInputType.emailAddress,
                                                textEditingController: en.employeeEmail,
                                                scrollPadding: 500,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },

                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                                onChange: (v){},
                                              ),
                                              emailValid?Container():ValidationErrorText(title: "* Invalid Email Address",),
                                              AddNewLabelTextField(
                                                labelText: 'Address',
                                               maxlines: null,
                                                textEditingController: en.employeeAddress,
                                                scrollPadding: 600,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },

                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                                onChange: (v){},
                                              ),
                                              address?ValidationErrorText(title:"* Enter Address" ,):Container(),
                                              AddNewLabelTextField(
                                                labelText: 'City',
                                                regExp: '[A-Za-z  ]',
                                                textEditingController: en.employeeCity,
                                                scrollPadding: 600,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },

                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                                onChange: (v){},
                                              ),
                                              AddNewLabelTextField(
                                                labelText: 'State',
                                                regExp: '[A-Za-z  ]',
                                                textInputType: TextInputType.emailAddress,
                                                textEditingController: en.employeeState,
                                                scrollPadding: 600,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },
                                                onChange: (v){},
                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                              ),
                                              AddNewLabelTextField(
                                                labelText: 'Country',
                                                regExp: '[A-Za-z  ]',
                                                textEditingController: en.employeeCountry,
                                                scrollPadding: 600,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },
                                                onChange: (v){},
                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                              ),
                                              AddNewLabelTextField(
                                                labelText: 'Zipcode',
                                                textInputType: TextInputType.number,
                                                textEditingController: en.employeeZipcode,
                                                scrollPadding: 600,
                                                textLength: 6,
                                                regExp: '[0-9]',
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },
                                                onChange: (v){},
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
                                          ),
                                        ),

                                        //Other details
                                        GestureDetector(
                                          onTap: (){
                                            otherDetailsArrowAnimationController.isCompleted
                                                ? otherDetailsArrowAnimationController.reverse()
                                                : otherDetailsArrowAnimationController.forward();

                                            setState(() {
                                              otherDetailsOpen=!otherDetailsOpen;
                                            });
                                            if(otherDetailsOpen){
                                              Timer(Duration(milliseconds: 300), (){
                                                listViewController!.animateTo(listViewController!.offset+ 450, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                                              });
                                            }
                                          },
                                          child:Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              height: 40,
                                              width: SizeConfig.screenWidth!*0.37,
                                              margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!,top: 20),
                                              padding: EdgeInsets.only(left: SizeConfig.width10!,right: SizeConfig.width10!),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: AppTheme.yellowColor,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text("Other Details",style:TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 14)),
                                                  Spacer(),
                                                  Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppTheme.bgColor
                                                    ),
                                                    child:  AnimatedBuilder(
                                                      animation: otherDetailsArrowAnimationController,
                                                      builder: (context, child) =>
                                                          Transform.rotate(
                                                            angle: otherDetailsArrowAnimation.value,
                                                            child: Icon(
                                                              Icons.keyboard_arrow_up_rounded,
                                                              size: 25.0,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn,
                                          width: SizeConfig.screenWidth,
                                          height: otherDetailsOpen? (475+80.0):0,
                                          //  margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () async{
                                                  final DateTime? picked = await showDatePicker2(
                                                      context: context,
                                                      initialDate: en.dob==null?DateTime.now():en.dob!,
                                                      firstDate: DateTime(1950),
                                                      lastDate: DateTime(2100),
                                                      builder: (BuildContext context,Widget? child){
                                                        return Theme(
                                                          data: Theme.of(context).copyWith(
                                                            colorScheme: ColorScheme.light(
                                                              primary: AppTheme.yellowColor, // header background color
                                                              onPrimary: AppTheme.bgColor, // header text color
                                                              onSurface: AppTheme.addNewTextFieldText, // body text color
                                                            ),

                                                          ),
                                                          child: child!,
                                                        );
                                                      });
                                                  if (picked != null)
                                                    setState(() {
                                                      en.dob = picked;
                                                    });

                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top:15,),
                                                  padding: EdgeInsets.only(left:SizeConfig.width10!,right:SizeConfig.width10!),
                                                  height:50,
                                                  width: double.maxFinite,
                                                  alignment: Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(3),
                                                      border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                      color: Colors.white
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(en.dob==null?"Date of Birth":DateFormat("dd-MM-yyyy").format(en.dob!),
                                                        style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.hintColor),),
                                                      Spacer(),
                                                      Icon(Icons.calendar_today,color:Colors.grey ,size: 20,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              dob?ValidationErrorText(title:"* Select Date of Birth" ,):Container(),

                                              GestureDetector(

                                                onTap: () {
                                                  node.unfocus();
                                                  setState(() {
                                                    _keyboardVisible=false;
                                                    isBloodGroupOpen = true;
                                                  });

                                                },
                                                child: SidePopUpParent(
                                                  text: en.selectBloodGroupName == null ? "Select Blood Group" : en.selectBloodGroupName,
                                                  textColor: en.selectBloodGroupName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5) : AppTheme.addNewTextFieldText,
                                                  iconColor: en.selectBloodGroupName == null ? AppTheme.addNewTextFieldText : AppTheme.yellowColor,
                                                  bgColor: en.selectBloodGroupName== null ? AppTheme.disableColor : Colors.white,
                                                ),
                                              ),
                                              GestureDetector(

                                                onTap: () {
                                                  node.unfocus();
                                                  setState(() {
                                                    _keyboardVisible=false;
                                                    isMaritalOpen = true;
                                                  });

                                                },
                                                child: SidePopUpParent(
                                                  text: en.selectMartialStatusName == null ? "Select Marital Status" : en.selectMartialStatusName,
                                                  textColor: en.selectMartialStatusName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5) : AppTheme.addNewTextFieldText,
                                                  iconColor: en.selectMartialStatusName == null ? AppTheme.addNewTextFieldText : AppTheme.yellowColor,
                                                  bgColor: en.selectMartialStatusName== null ? AppTheme.disableColor : Colors.white,
                                                ),
                                              ),

                                              AddNewLabelTextField(
                                                labelText: 'Referred By',
                                                textEditingController: en.employeeReferredBy,
                                                scrollPadding: 600,
                                                regExp: '[A-Za-z  ]',
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },
                                                onChange: (v){},
                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                              ),
                                              AddNewLabelTextField(
                                                labelText: 'Remarks',
                                                textEditingController: en.employeeRemarks,
                                                regExp: '[A-Za-z  ]',
                                                scrollPadding: 600,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },
                                                onChange: (v){},
                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                              ),
                                              AddNewLabelTextField(
                                                labelText: 'Aadhaar Number',
                                                textLength: 12,
                                                regExp: '[0-9]',
                                                textInputType: TextInputType.number,
                                                textEditingController: en.employeeAadhaarNo,
                                                scrollPadding: 600,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },
                                                onChange: (v){},
                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                              ),
                                              aadhaar?ValidationErrorText(title:"* Enter Aadhaar Number" ,):Container(),
                                              AddNewLabelTextField(
                                                labelText: 'Pan No',
                                                regExp: '[A-Za-z0-9]',
                                                textEditingController: en.employeePanNo,
                                                textLength: 10,
                                                scrollPadding: 750,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },
                                                onChange: (v){},
                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                              ),
                                              GestureDetector(

                                                onTap: () {
                                                  node.unfocus();
                                                  setState(() {
                                                    _keyboardVisible=false;
                                                    isPaymentTypeOpen = true;
                                                  });

                                                },
                                                child: SidePopUpParent(
                                                  text: en.selectPaymentMethodName == null ? "Select Payment Type" : en.selectPaymentMethodName,
                                                  textColor: en.selectPaymentMethodName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5) : AppTheme.addNewTextFieldText,
                                                  iconColor: en.selectPaymentMethodName == null ? AppTheme.addNewTextFieldText : AppTheme.yellowColor,
                                                  bgColor: en.selectPaymentMethodName== null ? AppTheme.disableColor : Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),


                                        //Bank details
                                        en.selectPaymentMethodName=="Bank"?GestureDetector(
                                          onTap: (){
                                            BankDetailsArrowAnimationController.isCompleted
                                                ? BankDetailsArrowAnimationController.reverse()
                                                : BankDetailsArrowAnimationController.forward();

                                            setState(() {
                                              BankDetailsOpen=!BankDetailsOpen;
                                            });
                                            if(BankDetailsOpen){
                                              Timer(Duration(milliseconds: 300), (){
                                                listViewController!.animateTo(listViewController!.offset+ 350, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                                              });
                                            }
                                          },
                                          child:Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              height: 40,
                                              width: SizeConfig.screenWidth!*0.37,
                                              margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!,top: 20),
                                              padding: EdgeInsets.only(left: SizeConfig.width10!,right: SizeConfig.width10!),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: AppTheme.yellowColor,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text("Bank Details",style:TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 14)),
                                                  Spacer(),
                                                  Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppTheme.bgColor
                                                    ),
                                                    child:  AnimatedBuilder(
                                                      animation: BankDetailsArrowAnimationController,
                                                      builder: (context, child) =>
                                                          Transform.rotate(
                                                            angle: BankDetailsArrowAnimation.value,
                                                            child: Icon(
                                                              Icons.keyboard_arrow_up_rounded,
                                                              size: 25.0,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ):Container(),

                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn,
                                          width: SizeConfig.screenWidth,
                                          height: BankDetailsOpen? (320+80.0):0,
                                          //  margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                          child: Column(
                                            children: [
                                              AddNewLabelTextField(
                                                labelText: 'Account Holder Name',
                                                textEditingController: en.employeeHolderName,
                                                scrollPadding: 700,
                                                regExp: '[A-Za-z  ]',
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },
                                                onChange: (v){},
                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                              ),
                                              AddNewLabelTextField(
                                                labelText: 'Bank Name',
                                                regExp: '[A-Za-z  ]',
                                                textEditingController: en.employeeBankName,
                                                scrollPadding: 500,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },
                                                onChange: (v){},
                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                              ),
                                              AddNewLabelTextField(
                                                labelText: 'Account Number',
                                                regExp: '[0-9]',
                                                textInputType: TextInputType.number,
                                                textEditingController: en.employeeAccNo,
                                                scrollPadding: 600,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },
                                                onChange: (v){},
                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                              ),
                                              AddNewLabelTextField(
                                                labelText: 'Branch Name',
                                                regExp: '[A-Za-z  ]',
                                                textEditingController: en.employeeBranchName,
                                                scrollPadding: 700,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },
                                                onChange: (v){},
                                                onEditComplete: () {
                                                  node.unfocus();
                                                  Timer(Duration(milliseconds: 100), (){
                                                    setState(() {
                                                      _keyboardVisible=false;
                                                    });
                                                  });
                                                },
                                              ),
                                              AddNewLabelTextField(
                                                labelText: 'IFSC Code',
                                                textEditingController: en.employeeIFSC,
                                                regExp: '[A-Za-z0-9]',
                                                scrollPadding: 750,
                                                ontap: () {
                                                  setState(() {
                                                    _keyboardVisible=true;
                                                  });
                                                  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                },
                                                onChange: (v){},
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
                                          ),
                                        ),

                                        SizedBox(height: _keyboardVisible? SizeConfig.screenHeight!*0.6:200,)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),



                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 120,
                            width: 120,
                            margin: EdgeInsets.only(top: 100),

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
                            child: Stack(
                              children: [
                                ProfileAvatar(
                                  imageUrl: en.employeeLogoUrl,
                                  imageFile: en.logoFile,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: (){
                                      getImage(
                                              (file){
                                            setState(() {
                                              en.logoFile=file;
                                              en.employeeLogoUrl="";
                                            });
                                          }
                                      );

                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.yellowColor,
                                      ),
                                      child: Icon(Icons.camera_alt),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        /*Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 110),
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
                        ),*/
                      ],
                    ),
                  ),
                ),


                //Appbar
                Container(
                  height: SizeConfig.height60,
                  width: SizeConfig.screenWidth,
                  child: Row(
                    children: [
                      CancelButton(
                        ontap: (){
                          en.clearInsertForm();
                          Navigator.pop(context);
                        },
                      ),

                      Text("Employee",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                      ),
                      Text(!en.isEmployeeEdit?" / Add New":" / Edit",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                      ),
                      Spacer(),



                      SizedBox(width: SizeConfig.width10,)
                    ],
                  ),
                ),


                //bottomNav
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    // height:_keyboardVisible?0:  70,
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
                          decoration: BoxDecoration(

                          ),
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
                      if(en.employeeEmail.text.isNotEmpty){
                        setState(() {
                          emailValid=EmailValidation().validateEmail(en.employeeEmail.text);
                        });
                      }

                      if(en.employeeFirstName.text.isEmpty){setState(() {firstName=true;});}
                      else{setState(() {firstName=false;});}

                      if(en.selectEmployeeDesignationId==null){setState(() {designation=true;});}
                      else{setState(() {designation=false;});}

                      if(en.selectEmployeeTypeId==null){setState(() {employeeType=true;});}
                      else{setState(() {employeeType=false;});}

                      if(en.dob==null){setState(() {dob=true;});}
                      else{setState(() {dob=false;});}

                      if(en.employeeSalary.text.isEmpty){setState(() {salary=true;});}
                      else{setState(() {salary=false;});}

                      if(en.employeePhoneNumber.text.isEmpty){setState(() {phoneNo=true;contactOpen=true;contactArrowAnimationController.forward();});}
                      else{setState(() {phoneNo=false;});}

                      if(en.employeeAddress.text.isEmpty){setState(() {address=true;contactOpen=true;contactArrowAnimationController.forward();});}
                      else{setState(() {address=false;});}

                      if(en.employeeAadhaarNo.text.isEmpty){setState(() {aadhaar=true;otherDetailsOpen=true;otherDetailsArrowAnimationController.forward();});}
                      else{setState(() {aadhaar=false;});}

                      if(emailValid && !firstName && !designation && !employeeType && !salary && !phoneNo && !address && !aadhaar && !dob){
                        en.InsertEmployeeDbHit(context);
                      }



                    },
                  ),
                ),


                //blur
                Container(

                  height: isDesignationOpen || isEmployeeTypeOpen || isShiftOpen || isBloodGroupOpen || isMaritalOpen || isPaymentTypeOpen? SizeConfig.screenHeight:0,
                  width: isDesignationOpen || isEmployeeTypeOpen || isShiftOpen || isBloodGroupOpen || isMaritalOpen || isPaymentTypeOpen? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),

                ),


                //Loader
                Container(

                  height: en.EmployeeLoader? SizeConfig.screenHeight:0,
                  width: en.EmployeeLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                  ),
                ),


               /*********************************      Side PopUps       *****************************************/

                //////////////////// Designation/////////////
                PopUpStatic(
                  title: "Select Designation",

                  isOpen: isDesignationOpen,
                  dataList: en.employeeDesginationList,
                  propertyKeyName:"EmployeeDesignationName",
                  propertyKeyId: "EmployeeDesignationId",
                  selectedId: en.selectEmployeeDesignationId,
                  itemOnTap: (index){
                    setState(() {
                      isDesignationOpen=false;
                      en.selectEmployeeDesignationId=en.employeeDesginationList[index].employeeDesginationId;
                      en.selectEmployeeDesignationName=en.employeeDesginationList[index].employeeDesginationName;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isDesignationOpen=false;
                    });
                  },


                ),


                //////////////////// TYPE   /////////////
                PopUpStatic(
                  title: "Select Employee Type",

                  isOpen: isEmployeeTypeOpen,
                  dataList: en.employeeTypeList,
                  propertyKeyName:"EmployeeTypeName",
                  propertyKeyId: "EmployeeTypeId",
                  selectedId: en.selectEmployeeTypeId,
                  itemOnTap: (index){
                    setState(() {
                      isEmployeeTypeOpen=false;
                      en.selectEmployeeTypeId=en.employeeTypeList[index].employeeTypeId;
                      en.selectEmployeeTypeName=en.employeeTypeList[index].employeeTypeName;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isEmployeeTypeOpen=false;
                    });
                  },


                ),

                //////////////////// SHIFT  /////////////
                PopUpStatic(
                  title: "Select Shift",

                  isOpen: isShiftOpen,
                  dataList: en.employeeShiftList,
                  propertyKeyName:"EmployeeShiftName",
                  propertyKeyId: "EmployeeShiftId",
                  selectedId: en.selectShiftId,
                  itemOnTap: (index){
                    setState(() {
                      isShiftOpen=false;
                      en.selectShiftId=en.employeeShiftList[index].employeeShiftId;
                      en.selectShiftName=en.employeeShiftList[index].employeeShiftName;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isShiftOpen=false;
                    });
                  },


                ),

                //////////////////// Blood Group  /////////////
                PopUpStatic(
                  title: "Select Blood Group",
                  isAlwaysShown: true,
                  isOpen: isBloodGroupOpen,
                  dataList: en.employeeBloodGroupList,
                  propertyKeyName:"EmployeeBloodGroup",
                  propertyKeyId: "EmployeeBloodGroupId",
                  selectedId: en.selectBloodGroupId,
                  itemOnTap: (index){
                    setState(() {
                      isBloodGroupOpen=false;
                      en.selectBloodGroupId=en.employeeBloodGroupList[index].employeeBloodGroupId;
                      en.selectBloodGroupName=en.employeeBloodGroupList[index].employeeBloodGroupName;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isBloodGroupOpen=false;
                    });
                  },
                ),

                //////////////////// Marital Status  /////////////
                PopUpStatic(
                  title: "Select Marital Status",

                  isOpen: isMaritalOpen,
                  dataList: en.employeeMartialStatusList,
                  propertyKeyName:"EmployeeMaritalStatus",
                  propertyKeyId: "EmployeeMaritalStatusId",
                  selectedId: en.selectMartialStatusId,
                  itemOnTap: (index){
                    setState(() {
                      isMaritalOpen=false;
                      en.selectMartialStatusId=en.employeeMartialStatusList[index].employeeMartialStatusId;
                      en.selectMartialStatusName=en.employeeMartialStatusList[index].employeeMartialStatusName;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isMaritalOpen=false;
                    });
                  },
                ),

                //////////////////// Payment Type  /////////////
                PopUpStatic(
                  title: "Select Payment Type",

                  isOpen: isPaymentTypeOpen,
                  dataList: en.employeePaymentTypeList,
                  propertyKeyName:"EmployeeSalaryMode",
                  propertyKeyId: "EmployeeSalaryModeId",
                  selectedId: en.selectPaymentMethodId,
                  itemOnTap: (index){
                    setState(() {
                      isPaymentTypeOpen=false;
                      en.selectPaymentMethodId=en.employeePaymentTypeList[index].employeePaymentTypeId;
                      en.selectPaymentMethodName=en.employeePaymentTypeList[index].employeePaymentTypeName;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isPaymentTypeOpen=false;
                    });
                  },
                ),




              ],
            ),

          ),

      ),
    );
  }
}
