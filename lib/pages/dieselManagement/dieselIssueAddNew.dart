
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

import 'package:quarry/widgets/currentDateContainer.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/expectedDateContainer.dart';





class DieselIssueForm extends StatefulWidget {

  @override
  DieselIssueFormState createState() => DieselIssueFormState();
}

class DieselIssueFormState extends State<DieselIssueForm> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;

  bool _keyboardVisible=false;
  bool isMachineOpen=false;
  bool isIssueOpen=false;
  bool isSupplierOpen=false;
  bool isVehicleOpen=false;
  bool isPlantOpen=false;


  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });
      listViewController.addListener(() {
        if(listViewController.position.userScrollDirection == ScrollDirection.forward){
          /*print("Down");*/
        } else
        if(listViewController.position.userScrollDirection == ScrollDirection.reverse){
          /*print("Up");*/
          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
        print("LISt-${listViewController.offset}");
        if(listViewController.offset>20){

          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);


        }
        else if(listViewController.offset==0){
          scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });

/*      listViewController.addListener(() {
        if(listViewController.offset>10){
          if(scrollController.offset==0){
            scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          }

        }
        else if(listViewController.offset==0){
          scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });*/

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final node=FocusScope.of(context);

    return Scaffold(
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
                              scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                            } else if(details.delta.dy < -sensitivity){
                              scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                            }
                          },
                          child: Container(
                            height:_keyboardVisible?SizeConfig.screenHeight*0.5 :SizeConfig.screenHeight-100,
                            width: SizeConfig.screenWidth,

                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                            ),
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (s){
                                if(s is ScrollStartNotification){

                                  print("Scroll Start");
                                  // if(scrollController.offset==100){
                                  //   scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  // }
                                }
                              },
                              child: ListView(
                                controller: listViewController,
                                scrollDirection: Axis.vertical,

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

                                  GestureDetector(
                                    onTap: (){


                                        node.unfocus();

                                        Timer(Duration(milliseconds: 50), (){
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        });
                                        setState(() {
                                          isMachineOpen=true;
                                        });



                                    },
                                    child: SidePopUpParent(
                                      text: dn.DI_machineName==null? "Select Machine":dn.DI_machineName,
                                      textColor: dn.DI_machineName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: dn.DI_machineName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                      bgColor: dn.DI_machineName==null? AppTheme.disableColor:Colors.white,

                                    ),
                                  ),

                                  AddNewLabelTextField(
                                    textEditingController: dn.DI_machineRunningMeter,
                                    labelText: "Machine Reading",
                                    textInputType: TextInputType.number,
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      setState(() {
                                        _keyboardVisible=true;
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
                                  AddNewLabelTextField(
                                    textEditingController: dn.DI_dieselQty,
                                    labelText: "Diesel Quantity",
                                    textInputType: TextInputType.number,
                                    scrollPadding: 100,
                                    ontap: (){
                                      //scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      scrollController.jumpTo(100);
                                      setState(() {
                                        _keyboardVisible=true;
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
                bottom: _keyboardVisible?-80:0,
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
                      Center(
                        heightFactor: 0.5,
                        child: FloatingActionButton(backgroundColor: AppTheme.yellowColor, child: Icon(Icons.done,color: AppTheme.bgColor,size: 30,), elevation: 0.1, onPressed: () {

                          dn.InsertDieselIssueDbHit(context);


                        }),
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
                height: isMachineOpen  || isIssueOpen || isPlantOpen  ? SizeConfig.screenHeight:0,
                width: isMachineOpen  || isIssueOpen|| isPlantOpen ? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
              ),


              ///////////////////////////////////////   Machine List    ////////////////////////////////
              Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    width: SizeConfig.screenWidth,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                    transform: Matrix4.translationValues(isMachineOpen?0:SizeConfig.screenWidth, 0, 0),

                    child:Container(
                      height: 400,
                      width: SizeConfig.screenWidth,
                      color: Colors.white,
                      //  padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),
                      child:Column (
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: SizeConfig.height50,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(icon: Icon(Icons.cancel), onPressed: (){
                                      setState(() {
                                        isMachineOpen=false;
                                      });
                                    }),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text('Select Machine',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.height10,),




                            Container(
                              height: SizeConfig.screenHeight*(300/720),

                              margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                              child: ListView.builder(
                                itemCount: dn.machineList.length,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        dn.DI_machineID=dn.machineList[index].machineId;
                                        dn.DI_machineName=dn.machineList[index].machineName;
                                        isMachineOpen=false;
                                      });

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      decoration:BoxDecoration(
                                          borderRadius:BorderRadius.circular(8),
                                          border: Border.all(color: dn.DI_machineID==null? AppTheme.addNewTextFieldBorder:dn.DI_machineID==dn.machineList[index].machineId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                          color: dn.DI_machineID==null? Colors.white: dn.DI_machineID==dn.machineList[index].machineId?AppTheme.popUpSelectedColor:Colors.white
                                      ),
                                      width:300,
                                      height:50,
                                      child: Text("${dn.machineList[index].machineName}",
                                        style: TextStyle(color:dn.DI_machineID==null? AppTheme.grey:dn.DI_machineID==dn.machineList[index].machineId?Colors.white:AppTheme.grey,
                                            fontSize:18,fontFamily: 'RR'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),


                          ]


                      ),
                    )
                ),
              ),



              ///////////////////////////////////////   Issued By List    ////////////////////////////////
              Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    width: SizeConfig.screenWidth,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                    transform: Matrix4.translationValues(isIssueOpen?0:SizeConfig.screenWidth, 0, 0),

                    child:Container(
                      height: 400,
                      width: SizeConfig.screenWidth,
                      color: Colors.white,
                      //  padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),
                      child:Column (
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: SizeConfig.height50,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(icon: Icon(Icons.cancel), onPressed: (){
                                      setState(() {
                                        isIssueOpen=false;
                                      });
                                    }),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text('Select Issued By',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.height10,),




                            Container(
                              height: SizeConfig.screenHeight*(300/720),

                              margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                              child: ListView.builder(
                                itemCount: dn.issuedByList.length,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        dn.DI_issueID=dn.issuedByList[index].employeeId;
                                        dn.DI_issueName=dn.issuedByList[index].employeeName;
                                        isIssueOpen=false;
                                      });

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      decoration:BoxDecoration(
                                          borderRadius:BorderRadius.circular(8),
                                          border: Border.all(color: dn.DI_issueID==null? AppTheme.addNewTextFieldBorder:dn.DI_issueID==dn.issuedByList[index].employeeId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                          color: dn.DI_issueID==null? Colors.white: dn.DI_issueID==dn.issuedByList[index].employeeId?AppTheme.popUpSelectedColor:Colors.white
                                      ),
                                      width:300,
                                      height:50,
                                      child: Text("${dn.issuedByList[index].employeeName}",
                                          style: TextStyle(color:dn.DI_issueID==null? AppTheme.grey:dn.DI_issueID==dn.issuedByList[index].employeeId?Colors.white:AppTheme.grey,
                                              fontSize:18,fontFamily: 'RR')
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),


                          ]


                      ),
                    )
                ),
              ),




              ///////////////////////////////////////   Plant List    ////////////////////////////////
              Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    width: SizeConfig.screenWidth,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                    transform: Matrix4.translationValues(isPlantOpen?0:SizeConfig.screenWidth, 0, 0),

                    child:Container(
                      height: 400,
                      width: SizeConfig.screenWidth,
                      color: Colors.white,
                      //  padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),
                      child:Column (
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: SizeConfig.height50,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(icon: Icon(Icons.cancel), onPressed: (){
                                      setState(() {
                                        isPlantOpen=false;
                                      });
                                    }),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text('Select Plant',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.height10,),




                            Container(
                              height: SizeConfig.screenHeight*(300/720),

                              margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                              child: ListView.builder(
                                itemCount: dn.plantList.length,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        dn.DI_plantID=dn.plantList[index].plantId;
                                        dn.DI_plantName=dn.plantList[index].plantName;
                                        isPlantOpen=false;
                                      });

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      decoration:BoxDecoration(
                                          borderRadius:BorderRadius.circular(8),
                                          border: Border.all(color: dn.DI_plantID==null? AppTheme.addNewTextFieldBorder:dn.DI_plantID==dn.plantList[index].plantId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                          color: dn.DI_plantID==null? Colors.white: dn.DI_plantID==dn.plantList[index].plantId?AppTheme.popUpSelectedColor:Colors.white
                                      ),
                                      width:300,
                                      height:50,
                                      child: Text("${dn.plantList[index].plantName}",
                                        style: TextStyle(color:dn.DI_plantID==null? AppTheme.grey:dn.DI_plantID==dn.plantList[index].plantId?Colors.white:AppTheme.grey,
                                            fontSize:18,fontFamily: 'RR'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),




                          ]


                      ),
                    )
                ),
              ),
            ],
          )
      ),
    );
  }

}

