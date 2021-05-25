import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/sale/salesMaterialLoadConfirmation.dart';
import 'package:quarry/pages/settings/customerDetails/customerAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/decimal.dart';
import 'package:quarry/widgets/searchdropdownSingleSelect.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithSearch.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';
import 'package:quarry/widgets/validationErrorText.dart';

import '../../notifier/quarryNotifier.dart';
import '../../styles/app_theme.dart';




class SalesDetail extends StatefulWidget {
  VoidCallback drawerCallback;
  bool fromsaleGrid;
  SalesDetail({this.drawerCallback,this.fromsaleGrid:false});
  @override
  _SalesDetailState createState() => _SalesDetailState();
}

class _SalesDetailState extends State<SalesDetail> with TickerProviderStateMixin{


  ScrollController scrollController;
  ScrollController listViewController;

  final now = DateTime.now();
  final formatter = DateFormat('dd/MM/yyyy');
  final formatterTime = DateFormat.jm();

  bool isTransportModeOpen=false;
  bool isAddTransportOpen=false;
  bool isPaymentTypeOpen=false;
  bool isMaterialTypeOpen=false;
  bool isCustomerDetaislOpen=false;
  bool _keyboardVisible=false;
  bool isListScroll=false;

  int reorderLevelIndex=-1;
  List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "X", "0", "."];
  String disValue="";
  bool discountValueError=false;
  TextEditingController customerSearchController =new TextEditingController();
  TextEditingController transportTypeSearchController =new TextEditingController();
  TextEditingController addTransportTypeController =new TextEditingController();

  Animation driverArrowAnimation;
  AnimationController driverArrowAnimationController;
  bool driverOpen=false;

  bool isPlantOpen=false;
  bool plant=false;

  @override
  void initState() {
    print("SALE -INIt");
    SystemChrome.setEnabledSystemUIOverlays([]);
    Provider.of<QuarryNotifier>(context,listen: false).initTabController(this,context,widget.fromsaleGrid);

    scrollController = new ScrollController();
    listViewController = new ScrollController();
    driverArrowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    driverArrowAnimation = Tween(begin: 0.0, end:-3.14).animate(driverArrowAnimationController);
    setState(() {

    });
/*    listViewController.addListener(() {
      if(listViewController.position.userScrollDirection == ScrollDirection.forward){
        print("Down");
      } else
      if(listViewController.position.userScrollDirection == ScrollDirection.reverse){
       // print("Up");
  //      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      }

      if(listViewController.offset>20){

    //    scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      }
      else if(listViewController.offset==0 && isListScroll){
        scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        setState(() {
          isListScroll=false;
        });
      }
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node=FocusScope.of(context);
    SizeConfig().init(context);
    String timestamp = formatter.format(now);
    String time = formatterTime.format(now);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(

      onWillPop: () async {


        setState(() {
          _keyboardVisible=false;
        });
        node.unfocus();
        Timer(Duration(milliseconds: 300),(){
          print("Fdsff");

        });



        return false;
      },
      child: Scaffold(
       resizeToAvoidBottomInset: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: AppTheme.yellowColor
          ),
          child: Consumer<QuarryNotifier>(
            builder: (context,qn,child)=>  Stack(
              children: [
                Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,

                  child: Column(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight-(SizeConfig.height70),
                        child: TabBarView(
                          //  physics: NeverScrollableScrollPhysics(),
                            controller: qn.tabController,
                            children: [
                              Container(
                                height: SizeConfig.screenHeight-(SizeConfig.height70),
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
                                            height: 170,

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


                                    //FORM
                                    Container(
                                      height: SizeConfig.screenHeight-(SizeConfig.height70),
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
                                                 // height: _keyboardVisible ? SizeConfig.screenHeight * 0.5 : SizeConfig.screenHeight,
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

                                                        GestureDetector(
                                                          onTap: (){


                                                              if(qn.plantCount!=1){
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
                                                            text: qn.PlantName==null? "Select Plant":qn.PlantName,
                                                            textColor: qn.PlantName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                                            iconColor: qn.PlantName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                                            bgColor: qn.PlantName==null? AppTheme.disableColor:Colors.white,

                                                          ),
                                                        ),
                                                        !plant?Container():ValidationErrorText(title: "* Select Plant"),

                                                        DropDownField(

                                                          add: (){
                                                          },
                                                          nodeFocus: (){
                                                            node.unfocus();
                                                          },
                                                          value: qn.SS_vehicleNo.text,
                                                          controller: qn.SS_vehicleNo,
                                                          reduceWidth: SizeConfig.width40,
                                                          // qtycontroller:qn.brandQtyController,
                                                          // unit: qn.MM_selectPrimaryUnit.toString(),

                                                          required: false,
                                                          // icon: Container(
                                                          //   height: 50,
                                                          //   width: 50,
                                                          //   margin: EdgeInsets.only(left: 20,right: 20),
                                                          //   decoration: BoxDecoration(
                                                          //       shape: BoxShape.circle,
                                                          //       color: Color(0xFFDEE2FE)
                                                          //   ),
                                                          // ),

                                                          hintText: 'Search Vehicle',
                                                          textStyle: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.addNewTextFieldText),
                                                          items: qn.filtersales_vehiclesList,
                                                          strict: false,
                                                          setter: (dynamic newValue) {
                                                            // print(newValue);
                                                            // qn.SS_LoadedVehicleNo=newValue;
                                                            // print(qn.SS_LoadedVehicleNo);
                                                            // qn.MM_selectBrand = newValue;
                                                          },
                                                          onValueChanged: (v){
                                                            node.unfocus();
                                                            setState(() {
                                                              qn.SS_vehicleNo.text=v;

                                                            });
                                                          },
                                                        ),



                                                        GestureDetector(

                                                          onTap: () {
                                                            node.unfocus();
                                                            setState(() {
                                                              _keyboardVisible=false;
                                                              isTransportModeOpen = true;
                                                            });

                                                          },
                                                          child: SidePopUpParent(
                                                            text: qn.SS_selectedVehicleTypeName == null ? "Select Vehicle Type " : qn.SS_selectedVehicleTypeName,
                                                            textColor: qn.SS_selectedVehicleTypeName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5)
                                                                : AppTheme.addNewTextFieldText,
                                                            iconColor: qn.SS_selectedVehicleTypeName == null ? AppTheme.addNewTextFieldText
                                                                : AppTheme.yellowColor,
                                                            bgColor: qn.SS_selectedVehicleTypeName == null ? AppTheme.disableColor
                                                                : Colors.white,
                                                          ),
                                                        ),

                                                        AddNewLabelTextField(
                                                          labelText: 'Empty Vehicle Weight',
                                                          regExp: decimalReg,
                                                          onChange: (v){},
                                                          textEditingController: qn.SS_emptyVehicleWeight,
                                                          textInputType: TextInputType.number,
                                                          ontap: () {
                                                            setState(() {
                                                              _keyboardVisible=false;
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
                                                          suffixIcon: Container(
                                                              height:30,
                                                              width: 50,
                                                              margin: EdgeInsets.all(13),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(SizeConfig.height25),
                                                                  color: AppTheme.yellowColor
                                                              ),
                                                              child: Center(
                                                                  child: Text("Ton",
                                                                    style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.white),)
                                                              )
                                                          ),
                                                        ),


                                                        GestureDetector(
                                                          onTap: () {
                                                            node.unfocus();
                                                            setState(() {
                                                              _keyboardVisible=false;
                                                              isMaterialTypeOpen = true;
                                                            });
                                                          },
                                                          child: SidePopUpParent(
                                                            text: qn.SS_selectedMaterialTypeName == null ? "Select Material"
                                                                : qn.SS_selectedMaterialTypeName,
                                                            textColor: qn.SS_selectedMaterialTypeName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5)
                                                                : AppTheme.addNewTextFieldText,
                                                            iconColor: qn.SS_selectedMaterialTypeName == null ? AppTheme.addNewTextFieldText
                                                                : AppTheme.yellowColor,
                                                            bgColor: qn.SS_selectedMaterialTypeName == null ? AppTheme.disableColor
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Container(
                                                          width: SizeConfig.screenWidth,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              SizedBox(
                                                                width: 25,
                                                                height: 25,
                                                                child: Checkbox(
                                                                  fillColor: MaterialStateColor.resolveWith((states) => AppTheme.yellowColor),
                                                                  value: qn.isCustomPrice,
                                                                  onChanged: (v){
                                                                    setState(() {
                                                                      qn.isCustomPrice=v;
                                                                      qn.customPriceController.clear();
                                                                      _keyboardVisible=false;
                                                                    });
                                                                    qn.weightToAmount();
                                                                  },
                                                                ),
                                                              ),

                                                              InkWell(
                                                                  onTap: (){
                                                                    setState(() {
                                                                      qn.isCustomPrice=!qn.isCustomPrice;
                                                                      qn.customPriceController.clear();
                                                                      _keyboardVisible=false;
                                                                    });
                                                                  },
                                                                  child: Text("Custom Price",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)),
                                                              SizedBox(width: SizeConfig.width20,)
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: qn.isCustomPrice? 10:0,),
                                                        AnimatedContainer(
                                                          duration: Duration(milliseconds: 300),
                                                          curve: Curves.easeIn,
                                                          height: qn.isCustomPrice?SizeConfig.height50:0,
                                                          width: SizeConfig.screenWidth,
                                                          margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,),
                                                          padding: EdgeInsets.only(left:SizeConfig.width10,),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                              borderRadius: BorderRadius.circular(3),
                                                              color:Colors.white
                                                          ),
                                                          child:qn.isCustomPrice? TextField(
                                                            scrollPadding: EdgeInsets.only(bottom: 500),
                                                            onTap: (){
                                                              if(scrollController.offset==0){
                                                                scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                              }
                                                              setState(() {
                                                                _keyboardVisible=true;
                                                                isListScroll=true;
                                                              });

                                                            },
                                                            style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                                            controller: qn.customPriceController,

                                                            decoration: InputDecoration(
                                                              fillColor:Colors.white,
                                                              hintText: 'Material Price',
                                                              hintStyle: TextStyle(fontFamily: 'RL',fontSize: 15,color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
                                                              border: InputBorder.none,
                                                              focusedBorder: InputBorder.none,
                                                              errorBorder: InputBorder.none,
                                                              enabledBorder: InputBorder.none,


                                                            ),
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter.allow(RegExp(decimalReg)),
                                                              ],

                                                            onChanged: (v){
                                                              qn.weightToAmount();
                                                            },
                                                            keyboardType: TextInputType.number,
                                                          ):Container(),
                                                        ),



                                                        GestureDetector(
                                                          onTap: (){
                                                            node.unfocus();
                                                            CustomAlert().commonErrorAlert(context, "Select Material Type", "");
                                                          },
                                                          child: AddNewLabelTextField(
                                                            labelText: 'Required Quantity',
                                                            regExp: decimalReg,

                                                            textEditingController: qn.SS_customerNeedWeight,
                                                            textInputType: TextInputType.number,
                                                            isEnabled:qn.SS_selectedMaterialTypeId==null?false: true,
                                                            scrollPadding: 500,
                                                            ontap: () {
                                                              if(scrollController.offset==0){
                                                                scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                              }


                                                              setState(() {
                                                                _keyboardVisible=true;
                                                                isListScroll=true;
                                                              });
                                                            },
                                                            onChange: (v){
                                                              qn.weightToAmount();
                                                            },
                                                            onEditComplete: () {
                                                              node.unfocus();
                                                              Timer(Duration(milliseconds: 100), (){
                                                                setState(() {
                                                                  _keyboardVisible=false;
                                                                });
                                                              });
                                                            },
                                                            suffixIcon:qn.SS_Empty_ReqQtyUnit.isEmpty?Container(
                                                                height:30,
                                                                width: 50,
                                                                margin: EdgeInsets.all(13),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(SizeConfig.height25),
                                                                    color: AppTheme.yellowColor
                                                                ),
                                                                child: Center(
                                                                    child: Text("Ton",
                                                                      style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.white),)
                                                                )
                                                            ): Container(
                                                                height:50,
                                                                width: 50,
                                                                margin: EdgeInsets.all(13),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(SizeConfig.height25),
                                                                    color: AppTheme.yellowColor
                                                                ),
                                                                child: Center(
                                                                    child: Text("${qn.SS_Empty_ReqQtyUnit}",
                                                                      style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Colors.white),)
                                                                )

                                                            ),
                                                          ),
                                                        ),

                                                        GestureDetector(
                                                          onTap: (){
                                                            node.unfocus();
                                                            CustomAlert().commonErrorAlert(context, "Select Material Type", "");
                                                          },
                                                          child: AddNewLabelTextField(
                                                            labelText: 'Amount',
                                                            regExp: decimalReg,
                                                            textEditingController: qn.SS_amount,
                                                            textInputType: TextInputType.number,
                                                            scrollPadding: 400,
                                                            isEnabled:qn.SS_selectedMaterialTypeId==null?false: true,

                                                            onChange: (v){
                                                              // qn.weightToAmount();
                                                              qn.amountToWeight();
                                                            },
                                                            ontap: () {
                                                              if(scrollController.offset==0){
                                                                scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                              }
                                                              setState(() {
                                                                _keyboardVisible=true;
                                                                isListScroll=true;
                                                              });

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
                                                            text: qn.SS_selectedPaymentTypeString == null ? "Select PaymentType"
                                                                : qn.SS_selectedPaymentTypeString,
                                                            textColor: qn.SS_selectedPaymentTypeString == null ? AppTheme.addNewTextFieldText.withOpacity(0.5)
                                                                : AppTheme.addNewTextFieldText,
                                                            iconColor: qn.SS_selectedPaymentTypeString == null ? AppTheme.addNewTextFieldText
                                                                : AppTheme.yellowColor,
                                                            bgColor: qn.SS_selectedPaymentTypeString == null ? AppTheme.disableColor
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            node.unfocus();
                                                            setState(() {
                                                              _keyboardVisible=false;
                                                              isCustomerDetaislOpen = true;
                                                            });
                                                          },
                                                          child: SidePopUpParent(
                                                            text: qn.SS_selectedCustomerName == null ? "Select Customer"
                                                                : qn.SS_selectedCustomerName,
                                                            textColor: qn.SS_selectedCustomerName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5)
                                                                : AppTheme.addNewTextFieldText,
                                                            iconColor: qn.SS_selectedCustomerName == null ? AppTheme.addNewTextFieldText
                                                                : AppTheme.yellowColor,
                                                            bgColor: qn.SS_selectedCustomerName == null ? AppTheme.disableColor
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(height:20,),

                                                        qn.SS_selectIsCreditCustomer?Column(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
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
                                                                      child: Text("Credit Limit",style: tableTextStyle,)
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
                                                                    child: FittedBox(child: Text("${qn.SS_selectCustomerCreditLimit}",

                                                                      style:tableTextStyle2,
                                                                    ),

                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,),
                                                              height:40,
                                                              width: SizeConfig.screenWidthM40,
                                                              decoration: BoxDecoration(
                                                                  color: tableColor,
                                                                  border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                                    right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom: BorderSide(color: AppTheme.addNewTextFieldBorder),

                                                                  )


                                                              ),
                                                              child:Row(
                                                                children: [
                                                                  Container(
                                                                      padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                      width: (SizeConfig.screenWidthM40*0.5)-2,
                                                                      child: Text("Used Amount",style: tableTextStyle,)
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
                                                                    child: FittedBox(child: Text("${qn.SS_selectUsedAmount}",

                                                                      style:tableTextStyle2,
                                                                    ),

                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,),
                                                              height:40,
                                                              width: SizeConfig.screenWidthM40,
                                                              decoration: BoxDecoration(
                                                                  color: tableColor,
                                                                  border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                                    right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom: BorderSide(color: AppTheme.addNewTextFieldBorder),

                                                                  )


                                                              ),
                                                              child:Row(
                                                                children: [
                                                                  Container(
                                                                      padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                      width: (SizeConfig.screenWidthM40*0.5)-2,
                                                                      child: Text("Balance Amount",style: tableTextStyle,)
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
                                                                    child: FittedBox(child: Text("${qn.SS_selectBalanceAmount}",

                                                                      style:tableTextStyle2,
                                                                    ),

                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height:20),
                                                          ],
                                                        ):Container(),
                                                        




                                                        Container(
                                                          height: SizeConfig.height30,
                                                          width: SizeConfig.screenWidth,
                                                          padding: EdgeInsets.only(left: SizeConfig.width10,right: SizeConfig.width20),
                                                          child: Row(
                                                            children: [
                                                              Checkbox(
                                                                  fillColor: MaterialStateColor.resolveWith((states) => AppTheme.yellowColor),
                                                                  value: qn.isDiscount,
                                                                  onChanged: (v){

                                                                    setState(() {
                                                                      qn.isDiscount=v;
                                                                    });

                                                                    if(qn.isDiscount){

                                                                      if(qn.DiscountValue.toInt()!=0){
                                                                        setState(() {
                                                                          disValue=qn.DiscountValue.toString();
                                                                        });
                                                                      }
                                                                      else{
                                                                        setState(() {
                                                                          disValue="";
                                                                        });
                                                                      }

                                                                      showDialog(context: context,
                                                                          // barrierDismissible: false,
                                                                          builder: (context){
                                                                            return StatefulBuilder(
                                                                              builder:(context,setState){
                                                                                return Consumer<QuarryNotifier>(
                                                                                  builder: (context,pn,child)=>Dialog(
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), ),

                                                                                    child: Container(
                                                                                      height: SizeConfig.screenHeight*0.85,
                                                                                      width: SizeConfig.screenWidth*0.9,
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          color: Colors.white
                                                                                      ),
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [

                                                                                          SizedBox(height: 15,),
                                                                                          /*  Text("{pn.purchaseOrdersMappingList[pn.purchaseOrdersMappingList.length-1].materialName??""}",
                                                                                        style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),*/
                                                                                          SizedBox(height: 10,),
                                                                                          Spacer(),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [

                                                                                              Text("${disValue.isEmpty?"0":disValue}",
                                                                                                style: TextStyle(fontFamily: 'RM',fontSize: 20,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),
                                                                                              SizedBox(width: 20,),
                                                                                              GestureDetector(
                                                                                                onTap: (){
                                                                                                  setState((){

                                                                                                    qn.isAmountDiscount=true;
                                                                                                    qn.isPercentageDiscount=false;

                                                                                                  });



                                                                                                },
                                                                                                child: AnimatedContainer(
                                                                                                  duration: Duration(milliseconds: 200),
                                                                                                  curve: Curves.easeIn,
                                                                                                  height: 35,
                                                                                                  width: 35,
                                                                                                  decoration: BoxDecoration(
                                                                                                      shape: BoxShape.circle,
                                                                                                      border: Border.all(color: pn.isAmountDiscount?Colors.transparent:AppTheme.addNewTextFieldBorder),
                                                                                                      color: pn.isAmountDiscount?AppTheme.addNewTextFieldFocusBorder:AppTheme.EFEFEF
                                                                                                  ),
                                                                                                  child: Center(
                                                                                                    child: Text("₹",style: pn.isAmountDiscount?AppTheme.discountactive:AppTheme.discountDeactive,),
                                                                                                  ),

                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(width: 10,),
                                                                                              GestureDetector(
                                                                                                onTap: (){
                                                                                                  setState((){
                                                                                                    qn.isAmountDiscount=false;
                                                                                                    qn.isPercentageDiscount=true;
                                                                                                    if(disValue.length>2){
                                                                                                      disValue=disValue.substring(0,2);
                                                                                                    }
                                                                                                  });

                                                                                                },
                                                                                                child: AnimatedContainer(
                                                                                                  duration: Duration(milliseconds: 200),
                                                                                                  curve: Curves.easeIn,
                                                                                                  height: 35,
                                                                                                  width: 35,
                                                                                                  decoration: BoxDecoration(
                                                                                                      shape: BoxShape.circle,
                                                                                                      border: Border.all(color: pn.isPercentageDiscount?Colors.transparent:AppTheme.addNewTextFieldBorder),
                                                                                                      color: pn.isPercentageDiscount?AppTheme.addNewTextFieldFocusBorder:AppTheme.EFEFEF
                                                                                                  ),
                                                                                                  child: Center(

                                                                                                    child: Text("%",style: pn.isPercentageDiscount?AppTheme.discountactive:AppTheme.discountDeactive,),
                                                                                                  ),

                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(height: 10,),
                                                                                          discountValueError?FittedBox(
                                                                                            fit: BoxFit.contain,
                                                                                            child: Text("* Discount Value should be less than 100%",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.red),
                                                                                            textAlign: TextAlign.center,),
                                                                                          ):Container(),
                                                                                          Spacer(),
                                                                                          Container(
                                                                                              margin: EdgeInsets.only(top: 20),
                                                                                              width: SizeConfig.screenWidth*0.8,
                                                                                              child: Wrap(
                                                                                                  spacing: 10,
                                                                                                  runSpacing: 10,
                                                                                                  direction: Axis.horizontal,
                                                                                                  alignment: WrapAlignment.center,
                                                                                                  children: numbers
                                                                                                      .asMap().map((i, element) => MapEntry(i,
                                                                                                      GestureDetector(
                                                                                                        onTap: () {
                                                                                                          setState(() {
                                                                                                            if (numbers[i] == 'X') {


                                                                                                              disValue = disValue.substring(0, disValue.length - 1);
                                                                                                              reorderLevelIndex=i;
                                                                                                            }
                                                                                                            else if (numbers[i] == '.') {
                                                                                                            /*  if(pn.isPercentageDiscount){
                                                                                                                if(disValue.length<2 && disValue.length>=1){
                                                                                                                  if(disValue.contains('.')){}
                                                                                                                  else{
                                                                                                                    setState(() {
                                                                                                                      disValue=disValue+'.';
                                                                                                                    });
                                                                                                                  }
                                                                                                                }
                                                                                                              }
                                                                                                              else{*/
                                                                                                                if(disValue.length<5 && disValue.length>=1){
                                                                                                                  if(disValue.contains('.')){}
                                                                                                                  else{
                                                                                                                    setState(() {
                                                                                                                      disValue=disValue+'.';
                                                                                                                    });
                                                                                                                  }
                                                                                                                }
                                                                                                             // }



                                                                                                              reorderLevelIndex=i;
                                                                                                            }
                                                                                                            else {



                                                                                                              if(disValue.isEmpty && numbers[i]=='0'){}
                                                                                                              else{
                                                                                                                setState(() {
                                                                                                                  reorderLevelIndex = i;
                                                                                                                });
                                                                                                              /*  if(pn.isPercentageDiscount){
                                                                                                                  if(disValue.length<2){
                                                                                                                    setState(() {
                                                                                                                      disValue=disValue+numbers[i];
                                                                                                                    });
                                                                                                                  }
                                                                                                                }
                                                                                                                else{*/

                                                                                                                  if(disValue.length<5){
                                                                                                                    setState(() {
                                                                                                                      disValue=disValue+numbers[i];
                                                                                                                    });
                                                                                                                  }
                                                                                                                //}
                                                                                                              }
                                                                                                             }

                                                                                                            Timer(Duration(milliseconds: 300), (){
                                                                                                              setState((){
                                                                                                                reorderLevelIndex=-1;
                                                                                                              });
                                                                                                            });

                                                                                                             });
                                                                                                          },
                                                                                                        child: AnimatedContainer(
                                                                                                            height: SizeConfig.screenWidth*0.19,
                                                                                                            width: SizeConfig.screenWidth*0.19,
                                                                                                            duration: Duration(milliseconds: 200),
                                                                                                            curve: Curves.easeIn,
                                                                                                            decoration: BoxDecoration(
                                                                                                              color: reorderLevelIndex == i?AppTheme.yellowColor:AppTheme.unitSelectColor,
                                                                                                              border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                                            ),
                                                                                                            child: Center(
                                                                                                                child: Text(numbers[i],
                                                                                                                  style: TextStyle(fontFamily: 'RR', color:reorderLevelIndex == i?Colors.white:AppTheme.gridTextColor, fontSize: 28,),
                                                                                                                  textAlign: TextAlign.center,
                                                                                                                )
                                                                                                            )
                                                                                                        ),
                                                                                                      )))
                                                                                                      .values
                                                                                                      .toList()
                                                                                              )
                                                                                          ),
                                                                                          SizedBox(height: 10,),
                                                                                          Spacer(),

                                                                                          GestureDetector(
                                                                                            onTap: (){

                                                                                              setState((){
                                                                                                if(qn.isPercentageDiscount){
                                                                                                     if(double.parse(disValue)<100){
                                                                                                       setState((){
                                                                                                         discountValueError=false;
                                                                                                       });
                                                                                                       qn.DiscountValue=double.parse(disValue);
                                                                                                       qn.weightToAmount();
                                                                                                       Navigator.pop(context);
                                                                                                     }
                                                                                                     else{
                                                                                                       setState((){
                                                                                                         discountValueError=true;
                                                                                                       });
                                                                                                     }

                                                                                                }
                                                                                                else if(qn.isAmountDiscount){
                                                                                                  setState((){
                                                                                                    discountValueError=false;
                                                                                                  });
                                                                                                  qn.DiscountValue=double.parse(disValue);
                                                                                                  qn.DiscountAmount=double.parse(disValue);
                                                                                                  qn.weightToAmount();
                                                                                                  Navigator.pop(context);
                                                                                                }
                                                                                              });



                                                                                            },
                                                                                            child: Container(
                                                                                              height: 50,
                                                                                              width: 150,
                                                                                              decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                  color: AppTheme.yellowColor
                                                                                              ),
                                                                                              child: Center(
                                                                                                child: Text("Done",style: AppTheme.TSWhite20,),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          GestureDetector(
                                                                                            onTap: (){
                                                                                              qn.updateisDiscount(false);
                                                                                              setState((){

                                                                                                qn.isPercentageDiscount=true;
                                                                                                qn.isAmountDiscount=false;
                                                                                                qn.DiscountAmount=0.0;
                                                                                                qn.DiscountValue=0.0;
                                                                                                qn.DiscountedSubTotal=0.0;
                                                                                                  discountValueError=false;
                                                                                                });
                                                                                              Navigator.pop(context);

                                                                                            },
                                                                                            child: Container(
                                                                                              height: 50,
                                                                                              width: 150,
                                                                                              child: Center(
                                                                                                child: Text("Cancel",style: TextStyle(fontFamily: 'RL',fontSize: 20,color: Color(0xFFA1A1A1))),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Spacer(),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          }
                                                                      );
                                                                    }
                                                                    else{

                                                                      setState((){
                                                                        qn.isDiscount=false;
                                                                        qn.isPercentageDiscount=true;
                                                                        qn.isAmountDiscount=false;
                                                                        qn.DiscountAmount=0.0;
                                                                        qn.DiscountValue=0.0;
                                                                        qn.DiscountedSubTotal=0.0;
                                                                      });
                                                                      qn.weightToAmount();
                                                                    }
                                                                  }),
                                                              InkWell(
                                                                  onTap: (){
                                                                    /*setState(() {
                                                                  qn.isDiscount=!qn.isDiscount;
                                                                });*/
                                                                  },
                                                                  child: Text("Is Discount?", style:  TextStyle(fontFamily: 'RR',fontSize: 16,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),)
                                                              ),

                                                              Spacer(),
                                                              Checkbox(
                                                                  fillColor: MaterialStateColor.resolveWith((states) => AppTheme.yellowColor),
                                                                  value: qn.isTax,
                                                                  onChanged: (v){
                                                                    setState(() {
                                                                      qn.isTax=v;
                                                                    });
                                                                    qn.weightToAmount();
                                                                  }
                                                              ),
                                                              InkWell(
                                                                  onTap: (){
                                                                    /*setState(() {
                                                                  qn.isDiscount=!qn.isDiscount;
                                                                });*/
                                                                  },
                                                                  child: Text("Is Tax?", style:  TextStyle(fontFamily: 'RR',fontSize: 16,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),)
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        GestureDetector(
                                                          onTap: (){
                                                            driverArrowAnimationController.isCompleted
                                                                ? driverArrowAnimationController.reverse()
                                                                : driverArrowAnimationController.forward();

                                                            setState(() {
                                                              driverOpen=!driverOpen;
                                                            });
                                                            if(driverOpen){
                                                              Timer(Duration(milliseconds: 300), (){
                                                                listViewController.animateTo(listViewController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                                                              });
                                                            }
                                                          },
                                                            child:Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Container(
                                                              height: 40,
                                                              width: SizeConfig.screenWidth*0.37,
                                                              margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: 20),
                                                              padding: EdgeInsets.only(left: SizeConfig.width10,right: SizeConfig.width10),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(25),
                                                                color: AppTheme.yellowColor,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Text("Driver Details",style:TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 14)),
                                                                  Spacer(),
                                                                  Container(
                                                                    height: 25,
                                                                    width: 25,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: AppTheme.bgColor
                                                                    ),
                                                                    child:  AnimatedBuilder(
                                                                      animation: driverArrowAnimationController,
                                                                      builder: (context, child) =>
                                                                          Transform.rotate(
                                                                            angle: driverArrowAnimation.value,
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
                                                          height: driverOpen? (150+SizeConfig.height60):0,
                                                        //  margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                                          child: Column(
                                                            children: [
                                                              AddNewLabelTextField(
                                                                labelText: 'Driver Name',
                                                                regExp: '[A-Za-z ]',
                                                                textEditingController: qn.driverName,
                                                                scrollPadding: 400,
                                                                onChange: (v){},
                                                                ontap: () {
                                                                  setState(() {
                                                                    _keyboardVisible=true;
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
                                                              AddNewLabelTextField(
                                                                labelText: 'Driver Contact Number',
                                                                regExp: '[0-9]',
                                                                textLength: phoneNoLength,
                                                                textInputType: TextInputType.number,
                                                                onChange: (v){},
                                                                textEditingController: qn.driverContactNumber,
                                                                scrollPadding: 400,
                                                                ontap: () {
                                                                  setState(() {
                                                                    _keyboardVisible=true;
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
                                                              AddNewLabelTextField(
                                                                labelText: 'Driver Beta',
                                                                regExp: decimalReg,
                                                                textInputType: TextInputType.number,
                                                                textEditingController: qn.driverBeta,
                                                                onChange: (v){},
                                                                scrollPadding: 400,
                                                                ontap: () {
                                                                  setState(() {
                                                                    _keyboardVisible=true;
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
                                                          ),
                                                        ),



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


                                    //Appbar
                                    Container(
                                      height: SizeConfig.height60,
                                      width: SizeConfig.screenWidth,
                                      child: Row(
                                        children: [
                                          CancelButton(ontap: (){
                                            qn.clearEmptyForm();

                                            Navigator.pop(context);
                                          },),

                                          Text("Sales",
                                            style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                                          ),
                                          Text(qn.tabController.index==0?" / In Gate":" / Out Gate",
                                            style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                              ),


/////////////////////////////////////////////////////LOADED FORM /////

                              Container(
                                height: SizeConfig.screenHeight-(SizeConfig.height70),
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
                                            height: 170,

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


                                    //FORM
                                    Container(
                                      height: SizeConfig.screenHeight-(SizeConfig.height70),
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
                                                 // height: _keyboardVisible ? SizeConfig.screenHeight * 0.5 : SizeConfig.screenHeight-SizeConfig.height100,
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
                                                          value: qn.SS_LoadedVehicleNo,
                                                          controller: qn.searchVehicleNo,
                                                          reduceWidth: SizeConfig.width40,
                                                          // qtycontroller:qn.brandQtyController,
                                                          // unit: qn.MM_selectPrimaryUnit.toString(),

                                                          required: false,
                                                          // icon: Container(
                                                          //   height: 50,
                                                          //   width: 50,
                                                          //   margin: EdgeInsets.only(left: 20,right: 20),
                                                          //   decoration: BoxDecoration(
                                                          //       shape: BoxShape.circle,
                                                          //       color: Color(0xFFDEE2FE)
                                                          //   ),
                                                          // ),

                                                          hintText: 'Search Vehicle',
                                                          textStyle: TextStyle(fontFamily: 'RR',fontSize: 20,color: AppTheme.addNewTextFieldText),
                                                          items: qn.saleVehicleNumberList,
                                                          strict: false,
                                                          setter: (dynamic newValue) {
                                                            // print(newValue);
                                                            // qn.SS_LoadedVehicleNo=newValue;
                                                            // print(qn.SS_LoadedVehicleNo);
                                                            // qn.MM_selectBrand = newValue;
                                                          },
                                                          onValueChanged: (v){
                                                            node.unfocus();
                                                            setState(() {
                                                              qn.SS_LoadedVehicleNo=v;
                                                              int index;
                                                              index=qn.saleDetails.indexWhere((element) => element.VehicleNumber.toLowerCase()==v.toString().toLowerCase()).toInt();
                                                              qn.SS_EmptyWeightOfVehicle=qn.saleDetails[index].EmptyWeightOfVehicle;
                                                              qn.SS_VehicleTypeName=qn.saleDetails[index].VehicleTypeName;
                                                              qn.SS_VehicleTypeId=qn.saleDetails[index].VehicleTypeId;
                                                              qn.SS_MaterialName=qn.saleDetails[index].MaterialName;
                                                              qn.SS_MaterialTypeId=qn.saleDetails[index].MaterialId;
                                                              qn.SS_RequiredMaterialQty=qn.saleDetails[index].RequiredMaterialQty;
                                                              qn.SS_RequiredMaterialQtyUnit=qn.saleDetails[index].UnitName;
                                                              qn.SS_Amount=qn.saleDetails[index].Amount;

                                                              qn.SS_DiscountAmount=qn.saleDetails[index].discountAmount;
                                                              qn.SS_DiscountedOutputQtyAmount=qn.saleDetails[index].DiscountedRequiredQtyAmount;
                                                              qn.SS_TaxAmount=qn.saleDetails[index].TaxAmount;
                                                              qn.SS_RoundOffAmount=qn.saleDetails[index].RoundOffAmount;
                                                              qn.SS_GrandTotalAmount=qn.saleDetails[index].TotalAmount;

                                                              qn.SS_PaymentCategoryName=qn.saleDetails[index].PaymentCategoryName;
                                                              qn.SS_PaymentTypeId=qn.saleDetails[index].PaymentCategoryId;
                                                              qn.SS_UpdateSaleId=qn.saleDetails[index].SaleId;
                                                              qn.SS_UpdateSaleNo=qn.saleDetails[index].SaleNumber;
                                                              qn.SS_selectCustomerId=qn.saleDetails[index].CustomerId;
                                                              qn.OG_discountValue=qn.saleDetails[index].discountValue;
                                                              qn.OG_TaxValue=qn.saleDetails[index].TaxPercentage;
                                                              qn.OG_isPercentage=qn.saleDetails[index].isPercentage;
                                                              qn.OG_isDiscount=qn.saleDetails[index].isDiscount;
                                                              qn.SS_TotalWeight=(Decimal.parse(qn.SS_EmptyWeightOfVehicle)+Decimal.parse((qn.SS_RequiredMaterialQty))).toString();
                                                              qn.SS_MaterialUnitPrice=qn.saleDetails[index].MaterialUnitPrice;
                                                              qn.OG_isTax=qn.saleDetails[index].TaxAmount>0?true:false;


                                                              print("qn.SS_DiscountedOutputQtyAmount${qn.SS_MaterialUnitPrice}");
                                                              print("qn.SS_DiscountedOutputQtyAmount${qn.SS_TaxAmount}");
                                                              print("qn.SS_GrandTotalAmount${qn.SS_GrandTotalAmount}");

                                                            });
                                                          },
                                                        ),


                                                        Container(
                                                          margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                                                          height:SizeConfig.height50,
                                                          width: SizeConfig.width320,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(3),
                                                              border: Border.all(color: AppTheme.addNewTextFieldBorder)

                                                          ),
                                                          child:Row(
                                                            children: [
                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-2,
                                                                  child: Text("Empty Vehicle Weight")
                                                              ),

                                                              Container(
                                                                  height: SizeConfig.height50,
                                                                  width: 1,
                                                                  color: AppTheme.addNewTextFieldBorder
                                                              ),

                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-1,
                                                                  child: Text(qn.SS_EmptyWeightOfVehicle==null?"":"${qn.SS_EmptyWeightOfVehicle+" Ton"}")),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                                          height:SizeConfig.height50,
                                                          width: SizeConfig.width320,
                                                          decoration: BoxDecoration(

                                                            // borderRadius: BorderRadius.circular(3),
                                                              border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                                  right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom: BorderSide(color: AppTheme.addNewTextFieldBorder)
                                                              )

                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-2,
                                                                  child: Text("Vehicle Type")
                                                              ),

                                                              Container(
                                                                  height: SizeConfig.height50,
                                                                  width: 1,
                                                                  color: AppTheme.addNewTextFieldBorder
                                                              ),

                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-1,
                                                                  child: Text("${qn.SS_VehicleTypeName??""}")),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                                          height:SizeConfig.height50,
                                                          width: SizeConfig.width320,
                                                          decoration: BoxDecoration(

                                                            // borderRadius: BorderRadius.circular(3),
                                                              border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                                  right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom:BorderSide(color: AppTheme.addNewTextFieldBorder))

                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-2,
                                                                  child: Text("Material Name")
                                                              ),

                                                              Container(
                                                                  height: SizeConfig.height50,
                                                                  width: 1,
                                                                  color: AppTheme.addNewTextFieldBorder
                                                              ),

                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-1,
                                                                  child: Text("${qn.SS_MaterialName??""}")),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                                          height:SizeConfig.height50,
                                                          width: SizeConfig.width320,
                                                          decoration: BoxDecoration(

                                                            // borderRadius: BorderRadius.circular(3),
                                                              border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                                  right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom:BorderSide(color: AppTheme.addNewTextFieldBorder))

                                                          ),
                                                          child: Row(
                                                            children: [

                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-2,
                                                                  child: Text("Required Qty")
                                                              ),

                                                              Container(
                                                                  height: SizeConfig.height50,
                                                                  width: 1,
                                                                  color: AppTheme.addNewTextFieldBorder
                                                              ),

                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-1,
                                                                  child: Text("${qn.SS_RequiredMaterialQty??""} ${qn.SS_RequiredMaterialQtyUnit??""}")),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                                          height:SizeConfig.height50,
                                                          width: SizeConfig.width320,
                                                          decoration: BoxDecoration(

                                                            // borderRadius: BorderRadius.circular(3),
                                                              border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                                  right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom:BorderSide(color: AppTheme.addNewTextFieldBorder))

                                                          ),
                                                          child: Row(
                                                            children: [

                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-2,
                                                                  child: Text("Amount")
                                                              ),

                                                              Container(
                                                                  height: SizeConfig.height50,
                                                                  width: 1,
                                                                  color: AppTheme.addNewTextFieldBorder
                                                              ),

                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-1,
                                                                  child: Text("${qn.SS_Amount??""}")),
                                                            ],
                                                          ),
                                                        ),
                                                        qn.OG_discountValue!=null?qn.OG_discountValue>0?Container(
                                                          margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                                          height:SizeConfig.height50,
                                                          width: SizeConfig.width320,
                                                          decoration: BoxDecoration(

                                                            // borderRadius: BorderRadius.circular(3),
                                                              border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                                  right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom:BorderSide(color: AppTheme.addNewTextFieldBorder))

                                                          ),
                                                          child: Row(
                                                            children: [

                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-2,
                                                                  child: Text("Discount")
                                                              ),

                                                              Container(
                                                                  height: SizeConfig.height50,
                                                                  width: 1,
                                                                  color: AppTheme.addNewTextFieldBorder
                                                              ),

                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-1,
                                                                  child: Text(qn.OG_discountValue!=null?"${qn.OG_discountValue??""} ${qn.OG_isPercentage==0?"Rs":"%"}":"")
                                                              ),
                                                            ],
                                                          ),
                                                        ):Container():Container(),
                                                        Container(
                                                          margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                                          height:SizeConfig.height50,
                                                          width: SizeConfig.width320,
                                                          decoration: BoxDecoration(

                                                            // borderRadius: BorderRadius.circular(3),
                                                              border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                                  right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom:BorderSide(color: AppTheme.addNewTextFieldBorder))

                                                          ),
                                                          child: Row(
                                                            children: [

                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-2,
                                                                  child: Text("Payment Type")
                                                              ),

                                                              Container(
                                                                  height: SizeConfig.height50,
                                                                  width: 1,
                                                                  color: AppTheme.addNewTextFieldBorder
                                                              ),

                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-1,
                                                                  child: Text("${qn.SS_PaymentCategoryName??""}")),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                                          height:SizeConfig.height50,
                                                          width: SizeConfig.width320,
                                                          decoration: BoxDecoration(

                                                            // borderRadius: BorderRadius.circular(3),
                                                              border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                                  right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom:BorderSide(color: AppTheme.addNewTextFieldBorder))

                                                          ),
                                                          child: Row(
                                                            children: [

                                                              Container(
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-2,
                                                                  child: Text("Total Weight")
                                                              ),

                                                              Container(
                                                                  height: SizeConfig.height50,
                                                                  width: 1,
                                                                  color: AppTheme.addNewTextFieldBorder
                                                              ),

                                                              Container(
                                                                  height:SizeConfig.height50,
                                                                  padding: EdgeInsets.only(left: SizeConfig.width10),
                                                                  width: SizeConfig.width140-1,
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(qn.SS_TotalWeight==null?"":"${qn.SS_TotalWeight + " Ton"??""}")),
                                                            ],
                                                          ),
                                                        ),




                                                        AddNewLabelTextField(
                                                          labelText: 'Outward Weight',
                                                          scrollPadding: 500,
                                                          regExp: decimalReg,
                                                          textInputType: TextInputType.number,
                                                          textEditingController: qn.SS_DifferWeightController,
                                                          suffixIcon: Container(
                                                              height:SizeConfig.height50,
                                                              width: 50,
                                                              child: Center(child: Text("Ton",style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.addNewTextFieldText.withOpacity(0.7)),))
                                                          ),
                                                          onChange: (v){
                                                            qn.differWeight(context);
                                                          },
                                                          onEditComplete: (){
                                                            node.unfocus();
                                                            setState(() {
                                                              _keyboardVisible=false;
                                                            });
                                                          },
                                                          ontap: (){
                                                            setState(() {
                                                              _keyboardVisible=true;
                                                              isListScroll=true;
                                                            });
                                                            scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);

                                                          },


                                                        ),
                                                        SizedBox(height: SizeConfig.height20,),
                                                        Text(qn.msg,style: TextStyle(fontFamily: 'RR',fontSize: 16),textAlign: TextAlign.center,),
                                                        SizedBox(height: SizeConfig.height20,),
                                                        qn.returnMoney.isNotEmpty?Container(
                                                          height: SizeConfig.height60,
                                                          width: SizeConfig.screenWidth,
                                                          decoration: BoxDecoration(
                                                              color: qn.returnColor,
                                                              // color: double.parse(qn.returnMoney.toString()) > qn.SS_Amount? Colors.red :Colors.green ,
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),

                                                          margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20),
                                                          child: Center(
                                                            child: Text(qn.returnMoney,style: TextStyle(fontFamily: 'RR',fontSize: 24,color: Colors.white
                                                              //color:double.parse(qn.returnMoney.toString()) > qn.SS_Amount? AppTheme.bgColor :Colors.white
                                                            ),textAlign: TextAlign.center,),
                                                          ),
                                                        ):Container(),


                                                        SizedBox(height: _keyboardVisible? SizeConfig.height430:SizeConfig.height200,),



                                                        /*SizedBox(height: SizeConfig.height100,)*/
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
                                      height: SizeConfig.height60,
                                      width: SizeConfig.screenWidth,
                                      child: Row(
                                        children: [
                                          CancelButton(ontap: (){
                                            qn.clearEmptyForm();
                                            qn.clearLoaderForm();
                                            Navigator.pop(context);
                                          },),

                                          Text("Sales",
                                            style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                                          ),
                                          Text(qn.tabController.index==0?" / In Gate":" / Out Gate",
                                            style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                              ),

                            ]
                        ),
                      ),
                      Spacer(),


                      //bottomNav
                      Container(
                        width: SizeConfig.screenWidth,
                        height: 70,

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
                                /*     boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.7),
                                  spreadRadius: 2,
                                  blurRadius: 15,
                                  offset: Offset(0, -20), // changes position of shadow
                                )
                              ]*/
                              ),
                              margin:EdgeInsets.only(top: 0),
                              child: CustomPaint(
                                size: Size( SizeConfig.screenWidth, 65),
                                //  painter: RPSCustomPainter(),
                                painter: RPSCustomPainter3(),
                              ),
                            ),
                            Center(
                              heightFactor: 0.5,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: (){
                                  node.unfocus();
                                  if(qn.tabController.index==0){
                                    if(qn.PlantId==null ){setState(() {plant=true;});}
                                    else{setState(() {plant=false;});}

                                    if(qn.SS_vehicleNo.text.isEmpty){
                                      CustomAlert().commonErrorAlert(context, "Enter Vehicle Number", "");
                                    }
                                    else if(qn.SS_emptyVehicleWeight.text.isEmpty){
                                      CustomAlert().commonErrorAlert(context, "Enter Vehicle Weight", "");
                                    }
                                    else if(qn.SS_customerNeedWeight.text.isEmpty && qn.SS_customerNeedWeight.text!="0"){
                                      CustomAlert().commonErrorAlert(context, "Enter Customer Need Weight", "");
                                    }
                                    else if(double.parse(qn.SS_customerNeedWeight.text)>qn.SS_selectedMaterialStock){
                                      CustomAlert().commonErrorAlert(context, "Out Of Stock", "Current Stock - ${qn.SS_selectedMaterialStock} Ton");
                                    }

                                    else{
                                      qn.InsertSaleDetailDbhit(context);
                                    }
                                  }
                                  else if(qn.tabController.index==1){
                                    if(qn.searchVehicleNo.text.isEmpty){
                                      CustomAlert().commonErrorAlert(context, "Enter Vehicle Number", "");
                                    }
                                    else if(qn.SS_DifferWeightController.text.isEmpty){
                                      CustomAlert().commonErrorAlert(context, "Enter Vehicle Weight", "");
                                    }else if(double.parse(qn.SS_DifferWeightController.text.toString())<double.parse(qn.SS_EmptyWeightOfVehicle)){
                                      CustomAlert().commonErrorAlert(context, "Outward Weight Should not be less than empty vehicle weight", "");
                                    } else{
                                      qn.UpdateSaleDetailDbhit(context,null,"");
                                    }
                                  }
                                },
                                  onLongPress: (){
                                  qn.GetSaleDetailDbhit(context);
                                  Navigator.push(context, _createRoute());
                                },
                                child: Container(

                                  height: 65,
                                  width: 65,
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
                              width:  SizeConfig.screenWidth,
                              height: 80,

                              child: Stack(

                                children: [

                                  Container(
                                      width: SizeConfig.screenWidth,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(width: SizeConfig.width20,),
                                          GestureDetector(
                                            onTap: (){
                                              qn.tabController.animateTo(0,duration: Duration(milliseconds: 300),curve: Curves.easeIn);
                                              qn.clearEmptyForm();
                                              qn.clearLoaderForm();
                                              setState(() {
                                                isListScroll=false;
                                                _keyboardVisible=false;
                                              });
                                              scrollController.jumpTo(0);
                                            },
                                            child: Container(
                                              width: 70,

                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.only(top: 10),
                                                    child: Opacity(
                                                        opacity:qn.tabController.index==0?1:0.7,
                                                      child: SvgPicture.asset(qn.tabController.index==0?"assets/bottomIcons/Lorry-in.svg":
                                                      "assets/bottomIcons/Lorry-in-inactive.svg"),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: (){
                                              qn.tabController.animateTo(1,duration: Duration(milliseconds: 300),curve: Curves.easeIn);
                                              qn.clearEmptyForm();
                                              qn.clearLoaderForm();
                                              setState(() {
                                                isListScroll=false;
                                                _keyboardVisible=false;
                                              });
                                              scrollController.jumpTo(0);
                                            },
                                            child: Container(
                                              width: 75,

                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.only(top: 10),
                                                    child: Opacity(
                                                      opacity:qn.tabController.index==1?1:0.7,
                                                      child: SvgPicture.asset(qn.tabController.index==1?"assets/bottomIcons/Lorry-out.svg":
                                                      "assets/bottomIcons/Lorry-out-inactive.svg"),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: SizeConfig.width20,),
                                        ],
                                      )
                                  )

                                ],
                              ),
                            )
                          ],
                        ),
                      ),


                    ],
                  ),
                ),



                Container(

                  height: isTransportModeOpen || isPaymentTypeOpen || isCustomerDetaislOpen || isMaterialTypeOpen || isAddTransportOpen || isPlantOpen? SizeConfig.screenHeight:0,
                  width: isTransportModeOpen || isPaymentTypeOpen || isCustomerDetaislOpen || isMaterialTypeOpen || isAddTransportOpen || isPlantOpen? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),

                ),





                ///////////////////////////////// Loader//////////////////////////////////
                Container(

                  height: qn.insertSaleLoader ||  qn.customerLoader? SizeConfig.screenHeight:0,
                  width:qn.insertSaleLoader  ||  qn.customerLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                  ),

                ),


///////////////////////////////////////   Plant List    ////////////////////////////////
                PopUpStatic(
                  title: "Select Plant",
                  isOpen: isPlantOpen,
                  dataList: qn.plantList,
                  propertyKeyName:"PlantName",
                  propertyKeyId: "PlantId",
                  selectedId:qn.PlantId,
                  itemOnTap: (index){
                    setState(() {
                      qn.PlantId=qn.plantList[index].plantId;
                      qn.PlantName=qn.plantList[index].plantName;
                      isPlantOpen=false;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isPlantOpen=false;
                    });
                  },
                ),




///////////////////////////////// Transport Type /////////////////////////////////

                PopUpSearch(
                  isOpen: isTransportModeOpen,
                  searchController: transportTypeSearchController,
                  searchHintText: "Search Vehicle Type",

                  dataList: qn.filterVehicleTypeList,
                  propertyKeyId: "VehicleTypeId",
                  propertyKeyName: "VehicleTypeName",
                  selectedId: qn.SS_selectedVehicleTypeId,

                  searchOnchange: (v){
                    qn.searchVehicleType(v);
                  },
                  itemOnTap: (index){
                    node.unfocus();
                    setState(() {
                      isTransportModeOpen=false;
                      qn.SS_selectedVehicleTypeId=qn.filterVehicleTypeList[index].VehicleTypeId;
                      qn.SS_selectedVehicleTypeName=qn.filterVehicleTypeList[index].VehicleTypeName;
                      qn.filterVehicleTypeList=qn.vehicleList;

                    });
                    transportTypeSearchController.clear();
                  },
                  closeOnTap: (){
                    node.unfocus();
                    setState(() {
                      isTransportModeOpen=false;
                    });
                    transportTypeSearchController.clear();
                    qn.filterVehicleTypeList=qn.vehicleList;
                  },
                  addNewOnTap: (){
                    setState(() {
                      isTransportModeOpen=false;
                      isAddTransportOpen=true;
                    });
                  },
                ),



/////////////////// add new transport Type //////
                Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      width: SizeConfig.screenWidth,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                      transform: Matrix4.translationValues(isAddTransportOpen?0:SizeConfig.screenWidth, 0, 0),

                      child:Container(
                        height:250,
                        width: SizeConfig.screenWidth,
                        color: Colors.white,
                        child:Column (
                            children: [
                              SizedBox(height: 40,),
                              Container(
                                height: 50,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child:Container(
                                        height: 50,
                                        width: SizeConfig.screenWidth,
                                        margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            /*      border: Border.all(color: AppTheme.addNewTextFieldBorder),*/
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 15,
                                                offset: Offset(0, 0), // changes position of shadow
                                              )
                                            ]
                                        ),
                                        child:Container(
                                          padding: EdgeInsets.only(left: 20),
                                          width: SizeConfig.screenWidth*0.52,
                                          child: TextField(
                                              controller: addTransportTypeController,
                                            scrollPadding: EdgeInsets.only(bottom: 500),
                                            style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                            decoration: InputDecoration(

                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                hintText: "Vehicle Type Name",
                                                hintStyle: AppTheme.hintText
                                            ),
                                            inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9 ]')),
                                            ],
                                            // keyboardType: otherChargesTextFieldOpen?TextInputType.number:TextInputType.text,
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 40,),
                              GestureDetector(
                                onTap: (){
                                  node.unfocus();
                                  qn.InsertVehicleTypeDbhit(context, addTransportTypeController.text);
                                 setState(() {
                                   isAddTransportOpen=false;
                                 });
                                  addTransportTypeController.clear();

                                },
                                child: Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: AppTheme.yellowColor
                                  ),
                                  child: Center(
                                    child: Text("Add",style:TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 18),),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  node.unfocus();
                                  setState(() {
                                    isAddTransportOpen=false;
                                  });
                                  addTransportTypeController.clear();


                                },
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  child: Center(
                                    child: Text("Cancel",style: TextStyle(fontFamily: 'RL',fontSize: 18,color: Color(0xFFA1A1A1))),
                                  ),
                                ),
                              ),




                            ]


                        ),
                      )
                  ),
                ),




///////////////////////////////// Material  Type //////////////////////////////////

                PopUpStatic(
                  title: "Select Material",
                  isAlwaysShown: true,
                  isOpen: isMaterialTypeOpen,
                  dataList: qn.sale_materialList,
                  propertyKeyName:"MaterialName",
                  propertyKeyId: "MaterialId",
                  selectedId: qn.SS_selectedMaterialTypeId,
                  itemOnTap: (index){
                    setState(() {
                      isMaterialTypeOpen=false;
                      qn.SS_selectedMaterialTypeId=qn.sale_materialList[index].MaterialId;
                      qn.SS_selectedMaterialTypeName=qn.sale_materialList[index].MaterialName;
                      qn.SS_selectedMaterialStock=qn.sale_materialList[index].Stock;
                      qn.SS_Empty_ReqQtyUnit=qn.sale_materialList[index].MaterialUnitName;
                    });
                    qn.weightToAmount();
                  },
                  closeOnTap: (){
                    setState(() {
                      isMaterialTypeOpen=false;
                    });
                  },
                ),




///////////////////////////////// Payment Type //////////////////////////////////

                PopUpStatic(
                  title: "Select Payment Type",

                  isOpen: isPaymentTypeOpen,
                  dataList: qn.sale_paymentList,
                    propertyKeyName:"PaymentCategoryName",
                  propertyKeyId: "PaymentCategoryId",
                  selectedId: qn.SS_selectedPaymentTypeId,
                  itemOnTap: (index){
                    setState(() {
                      isPaymentTypeOpen=false;
                      qn.SS_selectedPaymentTypeId=qn.sale_paymentList[index].PaymentCategoryId;
                      qn.SS_selectedPaymentTypeString=qn.sale_paymentList[index].PaymentCategoryName;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isPaymentTypeOpen=false;
                    });
                  },
                ),



///////////////////////////////// Customer Details //////////////////////////////////

                PopUpSearch(
                  isOpen: isCustomerDetaislOpen,
                  searchController: customerSearchController,
                  searchHintText: "Search Customer Name",

                  dataList: qn.filterSale_customerList,
                  propertyKeyId: "CustomerId",
                  propertyKeyName: "CustomerName",
                  selectedId: qn.SS_selectCustomerId,

                  searchOnchange: (v){
                    qn.searchCustomer(v);
                  },
                  itemOnTap: (index){
                    node.unfocus();
                    setState(() {
                      isCustomerDetaislOpen=false;
                      qn.SS_selectCustomerId=qn.filterSale_customerList[index].customerId;
                      qn.SS_selectedCustomerName=qn.filterSale_customerList[index].customerName;
                      qn.SS_selectIsCreditCustomer=qn.filterSale_customerList[index].isCreditCustomer;
                      qn.SS_selectUsedAmount=qn.filterSale_customerList[index].usedAmount;
                      qn.SS_selectBalanceAmount=qn.filterSale_customerList[index].balanceAmount;
                      qn.SS_selectCustomerCreditLimit=qn.filterSale_customerList[index].customerCreditLimit;
                      qn.filterSale_customerList=qn.sale_customerList;
                    });
                    customerSearchController.clear();
                  },
                  closeOnTap: (){
                      node.unfocus();
                      setState(() {
                        isCustomerDetaislOpen=false;
                      });
                      customerSearchController.clear();
                      },
                  addNewOnTap: (){
                    setState(() {
                      isCustomerDetaislOpen=false;
                    });
                    Navigator.push(context, _createRouteCustomer());
                  },


                ),





              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SalesMaterialLoadConfirmation(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1,0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteCustomer() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CustomerDetailAddNew(true),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1,0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
  TextStyle tableTextStyle=TextStyle(fontFamily: 'RR',color: AppTheme.bgColor);
  TextStyle tableTextStyle2=TextStyle(fontFamily: 'RR',color: AppTheme.gridTextColor);
  Color tableColor=Colors.white;
}

class SidePopUpParent extends StatelessWidget {
  String text;
  Color textColor;
  Color iconColor;
  Color bgColor;
  SidePopUpParent({this.text,this.textColor,this.iconColor,this.bgColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:15,),
      padding: EdgeInsets.only(left:SizeConfig.width10,right:SizeConfig.width10),
     // height: SizeConfig.height50,
      height: 50,
      width: double.maxFinite,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: AppTheme.addNewTextFieldBorder),
          color: bgColor

      ),
      child: Row(
        children: [
          Text(text,style: TextStyle(fontFamily: 'RR',fontSize: 16,color: textColor),),
          Spacer(),
          Container(
              height: SizeConfig.height25,
              width: SizeConfig.height25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor
              ),

              child: Center(child: Icon(Icons.arrow_forward_ios_outlined,color:Colors.white ,size: 14,)))
        ],
      ),
    );
  }
}
class SidePopUpParentWithoutTopMargin extends StatelessWidget {
  String text;
  Color textColor;
  Color iconColor;
  Color bgColor;
  SidePopUpParentWithoutTopMargin({this.text,this.textColor,this.iconColor,this.bgColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,),
      padding: EdgeInsets.only(left:SizeConfig.width10,right:SizeConfig.width10),
      height: SizeConfig.height50,
      width: double.maxFinite,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: AppTheme.addNewTextFieldBorder),
          color: bgColor

      ),
      child: Row(
        children: [
          Text(text,style: TextStyle(fontFamily: 'RR',fontSize: 16,color: textColor),),
          Spacer(),
          Container(
              height: SizeConfig.height25,
              width: SizeConfig.height25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor
              ),

              child: Center(child: Icon(Icons.arrow_forward_ios_outlined,color:Colors.white ,size: 14,)))
        ],
      ),
    );
  }
}
