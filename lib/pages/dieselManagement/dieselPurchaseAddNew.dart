
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialListModel.dart';
import 'package:quarry/notifier/dieselNotifier.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/plantDetailsAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/currentDateContainer.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/expectedDateContainer.dart';





class DieselPurchaseForm extends StatefulWidget {

  @override
  DieselPurchaseFormState createState() => DieselPurchaseFormState();
}

class DieselPurchaseFormState extends State<DieselPurchaseForm> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;


  bool isPlantOpen=false;
  bool isPurchaserOpen=false;
  bool isSupplierOpen=false;
  bool isVehicleOpen=false;

  bool _keyboardVisible=false;
  bool isListScroll=false;

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
                          //  height:_keyboardVisible?SizeConfig.screenHeight*0.5 :SizeConfig.screenHeight-100,
                            height:SizeConfig.screenHeight,
                            width: SizeConfig.screenWidth,

                            decoration: BoxDecoration(
                                color: AppTheme.gridbodyBgColor,
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
                                      text: dn.DP_PlantName==null? "Select Plant":dn.DP_PlantName,
                                      textColor: dn.DP_PlantName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: dn.DP_PlantName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                      bgColor: dn.DP_PlantName==null? AppTheme.disableColor:Colors.white,

                                    ),
                                  ),

                                  AddNewLabelTextField(
                                    textEditingController: dn.DP_billno,
                                    labelText: "Bill Number",
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
                                    onTap: () async{
                                      final DateTime picked = await showDatePicker(
                                        context: context,
                                        initialDate:  dn.DP_billDate, // Refer step 1
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null)
                                        setState(() {
                                          dn.DP_billDate = picked;
                                          print(dn.DP_billDate);
                                        });
                                    },
                                    child: ExpectedDateContainer(
                                    //  text: DateFormat("yyyy-MM-dd").format(dn.DP_billDate)==DateFormat("yyyy-MM-dd").format(DateTime.now())?"Select Bill Date":"${DateFormat.yMMMd().format(dn.DP_billDate)}",
                                      text: "${DateFormat.yMMMd().format(dn.DP_billDate)}",
                                      textColor:AppTheme.addNewTextFieldText,
                                     // textColor:DateFormat("yyyy-MM-dd").format(dn.DP_billDate)==DateFormat("yyyy-MM-dd").format(DateTime.now())? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
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
                                        isPurchaserOpen=true;
                                      });



                                    },
                                    child: SidePopUpParent(
                                      text: dn.DP_purchaserName==null? "Select Purchaser":dn.DP_purchaserName,
                                      textColor: dn.DP_purchaserName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: dn.DP_purchaserName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                      bgColor: dn.DP_purchaserName==null? AppTheme.disableColor:Colors.white,

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
                                        isSupplierOpen=true;
                                      });



                                    },
                                    child: SidePopUpParent(
                                      text: dn.DP_supplierName==null? "Select Supplier":dn.DP_supplierName,
                                      textColor: dn.DP_supplierName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: dn.DP_supplierName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                      bgColor: dn.DP_supplierName==null? AppTheme.disableColor:Colors.white,

                                    ),
                                  ),
                                  AddNewLabelTextField(
                                    textEditingController: dn.DP_location,
                                    labelText: "Location",
                                    scrollPadding: 450,
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
                                  AddNewLabelTextField(
                                    textEditingController: dn.DP_contactNo,
                                    labelText: "Contact Number",
                                    textInputType: TextInputType.number,
                                    scrollPadding: 500,
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

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Checkbox(

                                          fillColor:MaterialStateColor.resolveWith((states) => AppTheme.yellowColor),
                                          checkColor: AppTheme.bgColor.withOpacity(0.5),
                                          value: dn.DP_isVehicle,
                                          onChanged: (v){
                                            setState(() {
                                              dn.DP_isVehicle=!dn.DP_isVehicle;
                                            });
                                          }),
                                      Text("Is Vehicle",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.addNewTextFieldText),),
                                      SizedBox(width: SizeConfig.width20,),
                                    ],
                                  ),

                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        isVehicleOpen=true;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      height: dn.DP_isVehicle? SizeConfig.height50:0,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeIn,
                                     //   margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                     /* decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(color:AppTheme.addNewTextFieldBorder),
                                          color: Colors.transparent
                                      ),*/
                                      alignment: Alignment.topCenter,
                                      child: SidePopUpParentWithoutTopMargin(
                                        text: dn.DP_vehicleName==null? "Select Vehicle":dn.DP_vehicleName,
                                        textColor: dn.DP_vehicleName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                        iconColor: dn.DP_vehicleName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                        bgColor: dn.DP_vehicleName==null? AppTheme.disableColor:Colors.white,

                                      )
                                    ),
                                  ),


                                  AddNewLabelTextField(
                                    textEditingController: dn.DP_dieselQTY,
                                    labelText: "Diesel Quantity",
                                    textInputType: TextInputType.number,
                                    scrollPadding: 550,
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
                                    onChange: (v){
                                      dn.dieselCalc();
                                    },
                                  ),
                                  AddNewLabelTextField(
                                    textEditingController: dn.DP_dieselPrice,
                                    labelText: "Diesel Price",
                                    textInputType: TextInputType.number,
                                    scrollPadding: 550,
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
                                    onChange: (v){
                                      dn.dieselCalc();
                                    },

                                  ),

                                  SizedBox(height: 20,),
                                  Text("Total Amount",style: TextStyle(fontSize: 14,fontFamily: 'RR',color: AppTheme.hintColor),
                                  textAlign: TextAlign.center,
                                  ),
                                  Text("${dn.totalAmount}",style: TextStyle(fontSize: 25,fontFamily: 'RB',color: AppTheme.addNewTextFieldText),
                                    textAlign: TextAlign.center,
                                  ),

                                  SizedBox(height:_keyboardVisible?SizeConfig.screenHeight*0.5: SizeConfig.height250,)
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
                    node.unfocus();
                    dn.InsertDieselPurchaseDbHit(context);
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
                      child: Icon(Icons.done,size: SizeConfig.height30,color: AppTheme.bgColor,),
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
                      dn.clearDP_Form();

                    }),
                    SizedBox(width: SizeConfig.width5,),
                    Text("Diesel Purchase",
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
                        child: Text("Diesel Purchase",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.green),),
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
                height: isPlantOpen || isPurchaserOpen || isSupplierOpen || isVehicleOpen ? SizeConfig.screenHeight:0,
                width: isPlantOpen || isPurchaserOpen || isSupplierOpen || isVehicleOpen? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
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
                                        dn.DP_PlantId=dn.plantList[index].plantId;
                                        dn.DP_PlantName=dn.plantList[index].plantName;
                                        isPlantOpen=false;
                                      });

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      decoration:BoxDecoration(
                                          borderRadius:BorderRadius.circular(8),
                                          border: Border.all(color: dn.DP_PlantId==null? AppTheme.addNewTextFieldBorder:dn.DP_PlantId==dn.plantList[index].plantId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                          color: dn.DP_PlantId==null? Colors.white: dn.DP_PlantId==dn.plantList[index].plantId?AppTheme.popUpSelectedColor:Colors.white
                                      ),
                                      width:300,
                                      height:50,
                                      child: Text("${dn.plantList[index].plantName}",
                                        style: TextStyle(color:dn.DP_PlantId==null? AppTheme.grey:dn.DP_PlantId==dn.plantList[index].plantId?Colors.white:AppTheme.grey,
                                            fontSize:18,fontFamily: 'RR'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            /* Container(

                              width:150,
                              height:SizeConfig.height50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
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
                                  child: Text("+ Add New",style: TextStyle(color:Colors.black,fontSize:18,),
                                  )
                              ),


                            )*/



                          ]


                      ),
                    )
                ),
              ),

              ///////////////////////////////////////   Purchaser List    ////////////////////////////////
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
                    transform: Matrix4.translationValues(isPurchaserOpen?0:SizeConfig.screenWidth, 0, 0),

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
                                        isPurchaserOpen=false;
                                      });
                                    }),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text('Select Purchaser',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.height10,),




                            Container(
                              height: SizeConfig.screenHeight*(300/720),

                              margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                              child: ListView.builder(
                                itemCount: dn.fuelPurchaserList.length,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        dn.DP_purchaserId=dn.fuelPurchaserList[index].employeeId;
                                        dn.DP_purchaserName=dn.fuelPurchaserList[index].employeeName;
                                        isPurchaserOpen=false;
                                      });

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      decoration:BoxDecoration(
                                          borderRadius:BorderRadius.circular(8),
                                          border: Border.all(color: dn.DP_purchaserId==null? AppTheme.addNewTextFieldBorder:dn.DP_purchaserId==dn.fuelPurchaserList[index].employeeId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                          color: dn.DP_purchaserId==null? Colors.white: dn.DP_purchaserId==dn.fuelPurchaserList[index].employeeId?AppTheme.popUpSelectedColor:Colors.white
                                      ),
                                      width:300,
                                      height:50,
                                      child: Text("${dn.fuelPurchaserList[index].employeeName}",
                                        style: TextStyle(color:dn.DP_purchaserId==null? AppTheme.grey:dn.DP_purchaserId==dn.fuelPurchaserList[index].employeeId?Colors.white:AppTheme.grey,
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

              ///////////////////////////////////////   Supplier List    ////////////////////////////////
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
                    transform: Matrix4.translationValues(isSupplierOpen?0:SizeConfig.screenWidth, 0, 0),

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
                                        isSupplierOpen=false;
                                      });
                                    }),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text('Select Supplier',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.height10,),




                            Container(
                              height: SizeConfig.screenHeight*(300/720),

                              margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                              child: ListView.builder(
                                itemCount: dn.fuelSupplierList.length,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        dn.DP_supplierId=dn.fuelSupplierList[index].supplierId;
                                        dn.DP_supplierName=dn.fuelSupplierList[index].supplierName;
                                        isSupplierOpen=false;
                                      });

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      decoration:BoxDecoration(
                                          borderRadius:BorderRadius.circular(8),
                                          border: Border.all(color: dn.DP_supplierId==null? AppTheme.addNewTextFieldBorder:dn.DP_supplierId==dn.fuelSupplierList[index].supplierId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                          color: dn.DP_supplierId==null? Colors.white: dn.DP_supplierId==dn.fuelSupplierList[index].supplierId?AppTheme.popUpSelectedColor:Colors.white
                                      ),
                                      width:300,
                                      height:50,
                                      child: Text("${dn.fuelSupplierList[index].supplierName}",
                                        style: TextStyle(color:dn.DP_supplierId==null? AppTheme.grey:dn.DP_supplierId==dn.fuelSupplierList[index].supplierId?Colors.white:AppTheme.grey,
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

              ///////////////////////////////////////   Vehicle List    ////////////////////////////////
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
                    transform: Matrix4.translationValues(isVehicleOpen?0:SizeConfig.screenWidth, 0, 0),

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
                                        isVehicleOpen=false;
                                      });
                                    }),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text('Select Vehicle',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.height10,),




                            Container(
                              height: SizeConfig.screenHeight*(300/720),

                              margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                              child: ListView.builder(
                                itemCount: dn.vehicleList.length,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        dn.DP_vehicleId=dn.vehicleList[index].vehicleId;
                                        dn.DP_vehicleName=dn.vehicleList[index].vehicleNumber;
                                        isVehicleOpen=false;
                                      });

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      decoration:BoxDecoration(
                                          borderRadius:BorderRadius.circular(8),
                                          border: Border.all(color: dn.DP_vehicleId==null? AppTheme.addNewTextFieldBorder:dn.DP_vehicleId==dn.vehicleList[index].vehicleId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                          color: dn.DP_vehicleId==null? Colors.white: dn.DP_vehicleId==dn.vehicleList[index].vehicleId?AppTheme.popUpSelectedColor:Colors.white
                                      ),
                                      width:300,
                                      height:50,
                                      child: Text("${dn.vehicleList[index].vehicleNumber}",
                                        style: TextStyle(color:dn.DP_vehicleId==null? AppTheme.grey:dn.DP_vehicleId==dn.vehicleList[index].vehicleId?Colors.white:AppTheme.grey,
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

