import 'dart:async';

import 'package:flutter/material.dart';
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
import 'package:quarry/widgets/validationErrorText.dart';

import '../../../utils/widgetUtils.dart';
import '../../../widgets/alertDialog.dart';
import 'employeeMasterAddNew.dart';

class EmployeeMasterView extends StatefulWidget {
  const EmployeeMasterView({Key? key}) : super(key: key);

  @override
  _EmployeeMasterViewState createState() => _EmployeeMasterViewState();
}

class _EmployeeMasterViewState extends State<EmployeeMasterView> with TickerProviderStateMixin{
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


  Animation? contactArrowAnimation;
  late AnimationController contactArrowAnimationController;
  bool contactOpen=false;

  Animation? otherDetailsArrowAnimation;
  late AnimationController otherDetailsArrowAnimationController;
  bool otherDetailsOpen=false;

  Animation? BankDetailsArrowAnimation;
  late AnimationController BankDetailsArrowAnimationController;
  bool BankDetailsOpen=false;


  //validations
  bool firstName=false;
  bool designation=false;
  bool employeeType=false;
  bool salary=false;
  bool phoneNo=false;
  bool address=false;
  bool aadhaar=false;

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
                                  onNotification: (s){
                                    //   print(ScrollStartNotification);
                                    if(s is ScrollStartNotification){

                                      if(listViewController!.offset==0 && isListScroll && scrollController!.offset==100 && listViewController!.position.userScrollDirection==ScrollDirection.idle){

                                        Timer(Duration(milliseconds: 100), (){
                                          if(listViewController!.position.userScrollDirection!=ScrollDirection.reverse){

                                            //if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
                                            if(listViewController!.offset==0){

                                              scrollController!.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value) {
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
                                    return true;
                                  },
                                  child: ListView(
                                    controller: listViewController,
                                    scrollDirection: Axis.vertical,
                                    physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                                    children: [




                                      Align(
                                        alignment:Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: (){
                                            if(userAccessMap[32]){
                                              Navigator.pop(context);
                                              Navigator.push(context, _createRoute());
                                            }
                                            else{
                                              CustomAlert().accessDenied2();
                                            }

                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: SizeConfig.width20!,top: 10,bottom: 10),
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppTheme.yellowColor
                                            ),
                                            child: Center(
                                              child:  Icon(Icons.edit_outlined,color: AppTheme.bgColor,),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                          width: SizeConfig.screenWidth,
                                          child: Column(
                                            children: [
                                              Text("${en.selectedSalutation}.${en.employeeFirstName.text} ${en.employeeLastName.text}",
                                                style: AppTheme.userNameTS,
                                              ),
                                              SizedBox(height: 3,),
                                              Text("${en.selectEmployeeDesignationName}",
                                                style: AppTheme.userGroupTS,
                                              ),
                                              SizedBox(height: 20,),
                                            ],
                                          )
                                      ),


                                      Container(
                                          margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                                          color: tableColor,
                                          child: Table(
                                            border: tableBorder,
                                            children: [
                                              tableRow("Employee Code", "${en.EmployeePrefix}${en.EmployeeCode}"),
                                              tableRow("Employee Type", "${en.selectEmployeeTypeName??""}"),
                                              for(int i=0;i<3;i++)
                                                tableRow(i==0?"Shift":i==1?"Salary":"Date of Join",
                                                    "${i==0?en.selectShiftName??"":i==1?"${en.employeeSalary.text} / ${en.selectSalaryTypeName}":en.joiningDate!=null?DateFormat('dd-MM-yyyy').format(en.joiningDate!):""}"
                                                ),
                                            ],
                                          )
                                      ),

                                      //Contact Details
                                      SizedBox(height: 20,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(left:20,right:20,),
                                          child: Text("Contact Details",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.bgColor),),
                                        ),
                                      ),

                                      Container(
                                          margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                                          color: tableColor,
                                          child: Table(
                                            border: tableBorder,
                                            children: [
                                              tableRow("Phone", "${en.employeePhoneNumber.text}"),

                                              for(int i=0;i<4;i++)
                                                tableRow(i==0?"Email":i==1?"Address":i==2?"City":i==3?"State":"Zipcode",
                                                    "${i==0?en.employeeEmail.text:i==1?en.employeeAddress.text:i==2?en.employeeCity.text:en.employeeState.text}"
                                                ),
                                            ],
                                          )
                                      ),

                                      //Other Details
                                      SizedBox(height: 20,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 20,right: 20),
                                          child: Text("Other Details",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.bgColor),),
                                        ),
                                      ),


                                      Container(
                                          margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                                          color: tableColor,
                                          child: Table(
                                            border: tableBorder,
                                            children: [
                                              tableRow("Date of Birth", "${en.dob!=null?DateFormat('dd-MM-yyyy').format(en.dob!):""}"),
                                              for(int i=0;i<7;i++)
                                                tableRow(i==0?"Blood Group":i==1?"Marital Status":i==2?"Referred By":i==3?"Remarks":i==4?"Aadhaar Number":i==5?"Pan Number":"Payment Method",
                                                    "${i==0?en.selectBloodGroupName??"":i==1?en.selectMartialStatusName??"": i==2?en.employeeReferredBy.text:
                                                    i==3?en.employeeRemarks.text:i==4?en.employeeAadhaarNo.text:i==5?en.employeePanNo.text:en.selectPaymentMethodName??""}"
                                                ),
                                            ],
                                          )
                                      ),



                                      //Bank Details
                                      SizedBox(height: 20,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,),
                                          child: Text("Bank Details",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.bgColor),),
                                        ),
                                      ),

                                      Container(
                                          margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                                          color: tableColor,
                                          child: Table(
                                            border: tableBorder,
                                            children: [
                                              tableRow("Account Holder Name", "${en.employeeHolderName.text}"),
                                              for(int i=0;i<4;i++)
                                                tableRow(i==0?"Bank Name":i==1?"Account Number":i==2?"Branch":"IFSC Code",
                                                  "${i==0?en.employeeBankName.text:i==1?en.employeeAccNo.text:i==2?en.employeeBranchName.text:en.employeeIFSC.text}",
                                                ),
                                            ],
                                          )
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

                          margin: EdgeInsets.only(top: 110),
                          child: ProfileAvatar(imageUrl: en.employeeLogoUrl, imageFile: null),
                        ),
                      ),
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
                    Text("Employee Details",
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
                child: GestureDetector(
                  onTap: (){
                   Navigator.pop(context);

                  },
                  child: Container(

                    height: 65,
                    width: 65,
                    margin: EdgeInsets.only(bottom: 20),
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
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.arrow_back,size: SizeConfig.height30,color: AppTheme.bgColor,),
                    ),
                  ),
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

  TextStyle tableTextStyle=TextStyle(fontFamily: 'RR',color: AppTheme.gridTextColor);
  Color tableColor=Colors.white;
  TableRow tableRow(var title, var value){
    return  TableRow(
        children: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("$title",
                style: tableTextStyle,
              )
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("$value",
              style: tableTextStyle,
            ),
          ),
        ]
    );
  }
}