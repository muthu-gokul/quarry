
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:quarry/notifier/dieselNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';

import 'package:quarry/widgets/currentDateContainer.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/expectedDateContainer.dart';
import 'package:quarry/widgets/sidePopUp/noModel/sidePopUpSearchNoModel.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';
import 'package:quarry/widgets/sidePopUp/sidePopupWithoutModelList.dart';
import 'package:quarry/widgets/validationErrorText.dart';





class DieselIssueForm extends StatefulWidget {

  @override
  DieselIssueFormState createState() => DieselIssueFormState();
}

class DieselIssueFormState extends State<DieselIssueForm> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;

  bool _keyboardVisible=false;
  bool isListScroll=false;

  bool isMachineOpen=false;
  bool isMachineTypeOpen=false;
  bool isIssueOpen=false;
  bool isSupplierOpen=false;
  bool isVehicleOpen=false;
  bool isPlantOpen=false;

  TextEditingController searchController=new TextEditingController();

  //validations
  bool plant=false;
  bool type=false;
  bool machine=false;
  bool machineReading=false;
  bool issuedBy=false;
  bool qty=false;


  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });



    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final node=FocusScope.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<DieselNotifier>(
          builder: (context,dn,child)=> Stack(
            children: [



              Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                color: Colors.white,
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
                    ),





                  ],
                ),
              ),


              Container(
                height: SizeConfig.screenHeight,
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
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                        ),
                        alignment: Alignment.topCenter,
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

                            height:SizeConfig.screenHeight-100,
                            width: SizeConfig.screenWidth,

                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                            ),
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (s){
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

                                  CurrentDate(DateTime.now()),


                                  GestureDetector(
                                    onTap: (){

                                      if(dn.plantCount!=1){
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
                                      text: dn.DI_plantName==null? "Select Plant":dn.DI_plantName,
                                      textColor: dn.DI_plantName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: dn.DI_plantName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                      bgColor: dn.DI_plantName==null? AppTheme.disableColor:Colors.white,

                                    ),
                                  ),
                                  plant?ValidationErrorText(title: "* Select Plant",):Container(),

                                  GestureDetector(
                                    onTap: (){


                                        node.unfocus();

                                        Timer(Duration(milliseconds: 50), (){
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        });
                                        setState(() {
                                          isMachineTypeOpen=true;
                                          dn.DI_machineID=null;
                                          dn.DI_machineName=null;
                                        });



                                    },
                                    child: SidePopUpParent(
                                      text: dn.DI_MachinType==null? "Select Type":dn.DI_MachinType,
                                      textColor: dn.DI_MachinType==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: dn.DI_MachinType==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                      bgColor: dn.DI_MachinType==null? AppTheme.disableColor:Colors.white,

                                    ),
                                  ),
                                  type?ValidationErrorText(title: "* Select Type",):Container(),

                                  GestureDetector(
                                    onTap: (){


                                        node.unfocus();

                                        Timer(Duration(milliseconds: 50), (){
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        });
                                        if(dn.DI_MachinType!=null){
                                          setState(() {
                                            isMachineOpen=true;

                                          });
                                        }
                                        else{
                                          CustomAlert().commonErrorAlert(context, "Select Type", "");
                                        }




                                    },
                                    child: SidePopUpParent(
                                      text: dn.DI_machineName==null? "Select Machine":dn.DI_machineName,
                                      textColor: dn.DI_machineName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: dn.DI_machineName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                      bgColor: dn.DI_machineName==null? AppTheme.disableColor:Colors.white,

                                    ),
                                  ),
                                  machine?ValidationErrorText(title: "* Select ${dn.isMachine?"Machine":"Vehicle"}",):Container(),

                                  AddNewLabelTextField(
                                    textEditingController: dn.DI_machineRunningMeter,
                                    labelText: "Machine Reading",
                                    textInputType: TextInputType.number,
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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

                                  ),
                                  machineReading?ValidationErrorText(title: "* Enter Reading",):Container(),

                                  GestureDetector(
                                    onTap: (){


                                      node.unfocus();

                                      Timer(Duration(milliseconds: 50), (){
                                        setState(() {
                                          _keyboardVisible=false;
                                        });
                                      });
                                      setState(() {
                                        isIssueOpen=true;
                                      });



                                    },
                                    child: SidePopUpParent(
                                      text: dn.DI_issueName==null? "Select Issued By":dn.DI_issueName,
                                      textColor: dn.DI_issueName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: dn.DI_issueName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                      bgColor: dn.DI_issueName==null? AppTheme.disableColor:Colors.white,

                                    ),
                                  ),
                                  issuedBy?ValidationErrorText(title: "* Select IssuedBy",):Container(),
                                  AddNewLabelTextField(
                                    textEditingController: dn.DI_dieselQty,
                                    labelText: "Diesel Quantity",
                                    textInputType: TextInputType.number,
                                    scrollPadding: 400,
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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
                                  ),
                                  qty?ValidationErrorText(title: "* Enter Diesel Quantity",):Container(),

                                  SizedBox(height: _keyboardVisible? SizeConfig.screenHeight*0.5:200,)
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




              //bottomNav
              AnimatedPositioned(
                duration: Duration(milliseconds: 100),
                curve: Curves.easeIn,
                bottom: 0,
                child: Container(
                  width: SizeConfig.screenWidth,
                  height:70,

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
                      CustomPaint(
                        size: Size( SizeConfig.screenWidth, 65),
                        painter: RPSCustomPainter3(),
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

                    if(dn.DI_plantID==null) {setState(() {plant = true;});}
                    else{setState(() {plant=false;});}

                    if(dn.DI_MachinType==null) {setState(() {type = true;});}
                    else{setState(() {type=false;});}

                    if(dn.DI_machineID==null) {setState(() {machine = true;});}
                    else{setState(() {machine=false;});}

                    if(dn.DI_machineRunningMeter.text.isEmpty) {setState(() {machineReading = true;});}
                    else{setState(() {machineReading=false;});}

                    if(dn.DI_issueID==null) {setState(() {issuedBy = true;});}
                    else{setState(() {issuedBy=false;});}

                    if(dn.DI_dieselQty.text.isEmpty) {setState(() {qty = true;});}
                    else{setState(() {qty=false;});}


                    if(!plant&& !type&& !machine&& !machineReading&& !issuedBy&& !qty){
                      dn.InsertDieselIssueDbHit(context);
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
                height: SizeConfig.height60,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.clear,color:AppTheme.bgColor,), onPressed:(){
                      Navigator.pop(context);
                      dn.clearDI_form();

                    }),
                    SizedBox(width: SizeConfig.width5,),
                    Text("Diesel Issue",
                      style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),
                    ),

                    Spacer(),
                    Container(
                      height: 30,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white
                      ),
                      child: Center(
                        child: Text("Diesel Issue",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.red),),
                      ),
                    ),
                    SizedBox(width: SizeConfig.width10,),
                  ],
                ),
              ),


              Container(

                height: dn.DieselLoader? SizeConfig.screenHeight:0,
                width: dn.DieselLoader? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                ),
              ),


              Container(
                height: isMachineOpen  || isIssueOpen || isPlantOpen  || isMachineTypeOpen  ? SizeConfig.screenHeight:0,
                width: isMachineOpen  || isIssueOpen|| isPlantOpen|| isMachineTypeOpen ? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
              ),



             /* PopUpStatic(
                title: "Select Machine",
                isAlwaysShown: true,
                isOpen: isMachineOpen,
                dataList: dn.machineList,
                propertyKeyName:"MachineName",
                propertyKeyId: "MachineId",
                selectedId: dn.DI_machineID,
                itemOnTap: (index){
                  setState(() {
                    dn.DI_machineID=dn.machineList[index].machineId;
                    dn.DI_machineName=dn.machineList[index].machineName;
                    isMachineOpen=false;
                  });
                },
                closeOnTap: (){
                  setState(() {
                    isMachineOpen=false;
                  });
                },
              ),*/

              ///////////////////////////////////////  TYPE LIST  ////////////////////////////////
              PopUpStatic2(
                title: "Select Type",
                isOpen: isMachineTypeOpen,
                dataList: dn.machineTypeList,
                propertyKeyName:"MachineType",
                propertyKeyId: "MachineType",
                selectedId: dn.DI_MachinType,
                itemOnTap: (index){
                  setState(() {
                    dn.DI_MachinType=dn.machineTypeList[index]['MachineType'];
                    if(dn.DI_MachinType=='Machine'){
                      dn.isVehicle=false;
                      dn.isMachine=true;
                    }
                    else if(dn.DI_MachinType=='Vehicle'){
                      dn.isVehicle=true;
                      dn.isMachine=false;
                    }

                    isMachineTypeOpen=false;
                  });
                },
                closeOnTap: (){
                  setState(() {
                    isMachineTypeOpen=false;
                  });
                },
              ),
              ///////////////////////////////////////   Machine List    ////////////////////////////////
              PopUpSearchOnly2(
                isOpen: isMachineOpen,
                searchController: searchController,

                searchHintText:dn.isVehicle? "Search Vehicle Number":"Search Machine",

                dataList:dn.isVehicle? dn.filterVehicleList:dn.filterMachineList,
                propertyKeyId: dn.isVehicle? "VehicleId":"MachineId",
                propertyKeyName: dn.isVehicle? "VehicleNumber":"MachineName",
                selectedId: dn.DI_machineID,

                searchOnchange: (v){
                  dn.isVehicle?  dn.searchVehicle(v):dn.searchMachine(v);
                },
                itemOnTap: (index){
                  node.unfocus();
                  setState(() {

                    if(dn.isVehicle){
                      dn.DI_machineID=dn.filterVehicleList[index]['VehicleId'];
                      dn.DI_machineName=dn.filterVehicleList[index]['VehicleNumber'];
                      isMachineOpen=false;
                      dn.filterVehicleList=dn.vehicleList;
                    }
                    else{
                      dn.DI_machineID=dn.filterMachineList[index]['MachineId'];
                      dn.DI_machineName=dn.filterMachineList[index]['MachineName'];
                      isMachineOpen=false;
                      dn.filterMachineList=dn.machineList;
                    }
                  });
                  searchController.clear();
                },
                closeOnTap: (){
                  node.unfocus();
                  setState(() {
                    isMachineOpen=false;
                    dn.filterVehicleList=dn.vehicleList;
                    dn.filterMachineList=dn.machineList;
                  });
                  searchController.clear();
                },
              ),


              ///////////////////////////////////////   Issued By List    ////////////////////////////////

              PopUpSearchOnly2(
                isOpen: isIssueOpen,
                searchController: searchController,

                searchHintText:"Search IssuedBy",

                dataList:dn.filterIssuedByList,
                propertyKeyId:"EmployeeId",
                propertyKeyName: "EmployeeName",
                selectedId: dn.DI_issueID,

                searchOnchange: (v){
                   dn.searchIssuedBy(v);
                },
                itemOnTap: (index){
                  node.unfocus();
                  setState(() {


                      dn.DI_issueID=dn.filterIssuedByList[index]['EmployeeId'];
                      dn.DI_issueName=dn.filterIssuedByList[index]['EmployeeName'];
                      isIssueOpen=false;
                      dn.filterIssuedByList=dn.issuedByList;

                  });
                  searchController.clear();
                },
                closeOnTap: (){
                  node.unfocus();
                  setState(() {
                    isIssueOpen=false;
                    dn.filterIssuedByList=dn.issuedByList;
                  });
                  searchController.clear();
                },
              ),




              ///////////////////////////////////////   Plant List    ////////////////////////////////
              PopUpStatic(
                title: "Select Plant",
                isOpen: isPlantOpen,
                dataList: dn.plantList,
                propertyKeyName:"PlantName",
                propertyKeyId: "PlantId",
                selectedId: dn.DI_plantID,
                itemOnTap: (index){
                  setState(() {
                    dn.DI_plantID=dn.plantList[index].plantId;
                    dn.DI_plantName=dn.plantList[index].plantName;
                    isPlantOpen=false;
                  });
                },
                closeOnTap: (){
                  setState(() {
                    isPlantOpen=false;
                  });
                },
              ),

            ],
          )
      ),
    );
  }

}

