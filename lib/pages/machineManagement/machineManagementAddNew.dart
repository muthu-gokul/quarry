import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/enployeeAdvanceLoanNotifier.dart';
import 'package:quarry/notifier/machineManagementNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/expectedDateContainer.dart';
import 'package:quarry/widgets/searchdropdownSingleSelect.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';
import 'package:quarry/widgets/sidePopUp/sidePopupWithoutModelList.dart';
import 'package:quarry/widgets/validationErrorText.dart';


class MachineManagementAddNew extends StatefulWidget {
  VoidCallback? drawerCallback;
  bool fromsaleGrid;
  MachineManagementAddNew({this.drawerCallback,this.fromsaleGrid:false});

  @override
  _MachineManagementAddNewState createState() => _MachineManagementAddNewState();
}

class _MachineManagementAddNewState extends State<MachineManagementAddNew> {

  ScrollController? scrollController;
  ScrollController? listViewController;
  bool _keyboardVisible=false;
  bool isListScroll=false;

  bool isPlantOpen=false;
  bool isMachineOpen=false;
  bool isResponsiblePersonOpen=false;

  //validations
  bool intime=false;
  bool outtime=false;
  bool machine=false;
  bool loanAmount=false;
  bool plant=false;
  bool operatorName=false;
  bool operatorNo=false;

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
      body: Consumer<MachineManagementNotifier>(
          builder: (context,mmn,child)=> Container(
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
                        height: 180,

                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/svg/gridHeader/machineHeader.jpg",),
                                fit: BoxFit.cover
                            )

                        ),
                      )
                    ],
                  ),
                ),

                //Form
                Container(
                  height: SizeConfig.screenHeight!-70,
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
                                  if(s is ScrollStartNotification){

                                    if(listViewController!.offset==0 && isListScroll && scrollController!.offset==100 && listViewController!.position.userScrollDirection==ScrollDirection.idle){
                                      Timer(Duration(milliseconds: 100), (){
                                        if(listViewController!.position.userScrollDirection!=ScrollDirection.reverse){
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
                                } ,
                                child: ListView(
                                  controller: listViewController,
                                  scrollDirection: Axis.vertical,
                                  physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                                  children: [

                                    SizedBox(height: 20,),
                                    GestureDetector(
                                      onTap: (){

                                        if(mmn.plantCount!=1){
                                          node.unfocus();

                                          Timer(Duration(milliseconds: 50), (){
                                            setState(() {
                                              _keyboardVisible=false;
                                            });
                                          });
                                          setState(() {
                                            isPlantOpen=true;
                                          });
                                        }


                                      },
                                      child: SidePopUpParent(
                                        text: mmn.PlantName==null? "Select Plant":mmn.PlantName,
                                        textColor: mmn.PlantName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                        iconColor: mmn.PlantName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                        bgColor: mmn.PlantName==null? AppTheme.disableColor:Colors.white,

                                      ),
                                    ),
                                    plant?ValidationErrorText(title: "* Select Plant",):Container(),

                                    GestureDetector(
                                      onTap: () {
                                        node.unfocus();
                                        setState(() {
                                          _keyboardVisible=false;
                                          isMachineOpen=true;
                                        });
                                      },
                                      child: SidePopUpParent(
                                        text: mmn.selectedMachineId == null ? "Select Machine" : mmn.selectedMachineName ,
                                        textColor: mmn.selectedMachineId  == null ? AppTheme.addNewTextFieldText.withOpacity(0.5) : AppTheme.addNewTextFieldText,
                                        iconColor: mmn.selectedMachineId  == null ? AppTheme.addNewTextFieldText : AppTheme.yellowColor,
                                        bgColor: mmn.selectedMachineId  == null ? AppTheme.disableColor  : Colors.white,
                                      ),
                                    ),
                                    machine?ValidationErrorText(title:"* Select Machine"):Container(),

                                    SizedBox(height: 15,),
                                    Container(
                                      height: 50,
                                      margin: AppTheme.leftRightMargin20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                        color: AppTheme.disableColor
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(mmn.selectedMachineId==null?"Machine Model":"${mmn.selectedMachineModel}",
                                        style: TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                      ),
                                    ),
                                    AddNewLabelTextField(
                                      textEditingController: mmn.operatorName,
                                      labelText: "Operator Name",
                                      regExp: '[A-Za-z ]',
                                      scrollPadding: 550,
                                      ontap: (){
                                        scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                        setState(() {
                                          _keyboardVisible=true;
                                          isListScroll=true;
                                        });
                                      },
                                      onEditComplete: (){
                                        node.unfocus();
                                        Timer(Duration(milliseconds: 300), (){
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        });
                                      },
                                      onChange: (v){},

                                    ),
                                    operatorName?ValidationErrorText(title: "* Enter Operator Name",):Container(),
                                    AddNewLabelTextField(
                                      textEditingController: mmn.operatorNo,
                                      labelText: "Operator Contact Number",
                                      regExp: '[0-9]',
                                      textLength: phoneNoLength,
                                      textInputType: TextInputType.number,
                                      scrollPadding: 550,
                                      ontap: (){
                                        scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                        setState(() {
                                          _keyboardVisible=true;
                                          isListScroll=true;
                                        });
                                      },
                                      onEditComplete: (){
                                        node.unfocus();
                                        Timer(Duration(milliseconds: 300), (){
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        });
                                      },
                                      onChange: (v){},

                                    ),
                                    operatorNo?ValidationErrorText(title: "* Enter Operator Contact Number",):Container(),


                                    GestureDetector(
                                      onTap: () async{
                                        node.unfocus();
                                        final DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate:  mmn.MachineServicedate==null?DateTime.now():mmn.MachineServicedate!, // Refer step 1
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        );
                                        if (picked != null)
                                          setState(() {
                                            mmn.MachineServicedate = picked;
                                            print(mmn.MachineServicedate);
                                          });
                                      },
                                      child: ExpectedDateContainer(
                                        text:mmn.MachineServicedate==null?"${DateFormat("dd-MM-yyyy").format(DateTime.now())}" :"${DateFormat("dd-MM-yyyy").format(mmn.MachineServicedate!)}",
                                        textColor:AppTheme.addNewTextFieldText,
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!,top: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () async{
                                              node.unfocus();
                                              final TimeOfDay? picked = await showTimePicker(
                                                context: context,
                                                initialTime: mmn.InTime==null?TimeOfDay.now():mmn.InTime!,

                                              );
                                              if (picked != null){
                                                print(picked);
                                                setState(() {
                                                  mmn.InTime=picked;
                                                  mmn.inTime = formatDate(
                                                      DateTime(2019, 08, 1, mmn.InTime!.hour, mmn.InTime!.minute),
                                                      [hh, ':', nn, " ", am]).toString();
                                                });
                                              }

                                            },
                                            child:Container(
                                              height: 50,
                                              width:( SizeConfig.screenWidthM40!*0.5)-10,
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                color: Colors.white
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(mmn.inTime ??"Select InTime",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.bgColor),),
                                                  Spacer(),
                                                  Opacity(
                                                      opacity: 0.4,
                                                      child: SvgPicture.asset("assets/bottomIcons/time.svg",height: 30,width: 30,)
                                                  )


                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async{
                                              node.unfocus();
                                              final TimeOfDay? picked = await showTimePicker(
                                                context: context,
                                                initialTime: mmn.OutTime==null?TimeOfDay.now():mmn.OutTime!,

                                              );
                                              if (picked != null){

                                                setState(() {
                                                  mmn.OutTime=picked;
                                                  mmn.outTime = formatDate(
                                                      DateTime(2019, 08, 1, mmn.OutTime!.hour, mmn.OutTime!.minute),
                                                      [hh, ':', nn, " ", am]).toString();
                                                });
                                                print(mmn.OutTime!.minute);
                                              }

                                            },
                                            child:Container(
                                              height: 50,
                                              width:( SizeConfig.screenWidthM40!*0.5)-10,
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                  color: Colors.white
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(mmn.outTime ??"Select OutTime",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.bgColor),),
                                                  Spacer(),
                                                  Opacity(
                                                      opacity: 0.4,
                                                      child: SvgPicture.asset("assets/bottomIcons/time.svg",height: 30,width: 30,)
                                                  )


                                                ],
                                              ),
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                    Container(
                                     // margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                         intime?  ValidationErrorText(title: "* Select InTime",):Container(),
                                         outtime? ValidationErrorText(title: "* Select OutTime",):Container(),


                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        node.unfocus();
                                        setState(() {
                                          _keyboardVisible=false;
                                          isResponsiblePersonOpen=true;
                                        });
                                      },
                                      child: SidePopUpParent(
                                        text: mmn.selectedPersonName == null ? "Select Responsible Person" : mmn.selectedPersonName ,
                                        textColor: mmn.selectedPersonName  == null ? AppTheme.addNewTextFieldText.withOpacity(0.5) : AppTheme.addNewTextFieldText,
                                        iconColor: mmn.selectedPersonName  == null ? AppTheme.addNewTextFieldText : AppTheme.yellowColor,
                                        bgColor: mmn.selectedPersonName  == null ? AppTheme.disableColor  : Colors.white,
                                      ),
                                    ),

                                    AddNewLabelTextField(
                                      textEditingController: mmn.reason,
                                      labelText: "Reason",
                                      regExp: '[A-Za-z ]',
                                      scrollPadding: 550,
                                      ontap: (){
                                        scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                        setState(() {
                                          _keyboardVisible=true;
                                          isListScroll=true;
                                        });
                                      },
                                      onEditComplete: (){
                                        node.unfocus();
                                        Timer(Duration(milliseconds: 300), (){
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        });
                                      },
                                      onChange: (v){},

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
                          mmn.clearInsertForm();
                          Navigator.pop(context);
                        },
                      ),

                      Text("Machine Management",
                        style: AppTheme.appBarTS,
                      ),
                      Text(mmn.machineManagementEdit?" / Edit":" / Add New",
                        style: AppTheme.appBarTS
                      ),
                    ],
                  ),
                ),



                //bottomNav
                Positioned(
                 // bottom:_keyboardVisible? -70:0,
                  bottom:0,
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
                      if( mmn.PlantId==null) {setState(() {plant = true;});}
                      else{setState(() {plant=false;});}

                      if(mmn.selectedMachineId==null){setState(() {machine=true;});}
                      else{setState(() {machine=false;});}

                      if(mmn.InTime==null){setState(() {intime=true;});}
                      else{setState(() {intime=false;});}

                      if(mmn.operatorName.text.isEmpty){setState(() {operatorName=true;});}
                      else{setState(() {operatorName=false;});}

                      if(mmn.operatorNo.text.isEmpty){setState(() {operatorNo=true;});}
                      else{setState(() {operatorNo=false;});}

                      if(mmn.machineManagementEdit){
                        if(mmn.OutTime==null){setState(() {outtime=true;});}
                        else{setState(() {outtime=false;});}

                        if(!machine && !intime && !outtime && !operatorName && !operatorNo){
                          mmn.InsertMachineManagementDbHit(context);
                        }

                      }
                      else{
                        if(!machine && !intime && !plant && !operatorName && !operatorNo){
                          mmn.InsertMachineManagementDbHit(context);
                        }
                      }


                    },
                  ),
                ),



                Container(

                  height: isMachineOpen || isPlantOpen || isResponsiblePersonOpen? SizeConfig.screenHeight:0,
                  width: isMachineOpen || isPlantOpen || isResponsiblePersonOpen? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),

                ),



                ///////////////////////////////// Loader//////////////////////////////////
                Container(

                  height: mmn.machineManagementLoader ? SizeConfig.screenHeight:0,
                  width:mmn.machineManagementLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                  ),

                ),


                ///////////////////////////////////////   Plant List    ////////////////////////////////

                PopUpStatic(
                  title: "Select Plant",
                  isOpen: isPlantOpen,
                  dataList: mmn.plantList,
                  propertyKeyName:"PlantName",
                  propertyKeyId: "PlantId",
                  selectedId: mmn.PlantId,
                  itemOnTap: (index){
                    setState(() {
                      mmn.PlantId=mmn.plantList[index].plantId;
                      mmn.PlantName=mmn.plantList[index].plantName;
                      isPlantOpen=false;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isPlantOpen=false;
                    });
                  },
                ),

                ///////////MachineOpen
                PopUpStatic2(
                  title: "Select Machine",

                  isOpen: isMachineOpen,
                  dataList: mmn.machineList,
                  propertyKeyName:"MachineName",
                  propertyKeyId: "MachineId",
                  selectedId: mmn.selectedMachineId,
                  itemOnTap: (index){
                    setState(() {
                      isMachineOpen=false;

                      mmn.selectedMachineId=mmn.machineList![index]['MachineId'];
                      mmn.selectedMachineName=mmn.machineList![index]['MachineName'];
                      mmn.selectedMachineModel=mmn.machineList![index]['MachineModel'];

                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isMachineOpen=false;
                    });
                  },
                ),

                ///////////Person
                PopUpStatic2(
                  title: "Select Responsible Person",

                  isOpen: isResponsiblePersonOpen,
                  dataList: mmn.reponsiblePersonList,
                  propertyKeyName:"EmployeeName",
                  propertyKeyId: "EmployeeId",
                  selectedId: mmn.selectedPersonId,
                  itemOnTap: (index){
                    setState(() {
                      isResponsiblePersonOpen=false;

                      mmn.selectedPersonId=mmn.reponsiblePersonList![index]['EmployeeId'];
                      mmn.selectedPersonName=mmn.reponsiblePersonList![index]['EmployeeName'];


                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isResponsiblePersonOpen=false;
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