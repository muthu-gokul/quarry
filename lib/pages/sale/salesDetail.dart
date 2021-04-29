import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/vendor/vendorLocAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/decimal.dart';
import 'package:quarry/widgets/searchdropdownSingleSelect.dart';

import 'saleAddNew.dart';




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
bool isPaymentTypeOpen=false;
bool isMaterialTypeOpen=false;
bool isCustomerDetaislOpen=false;
bool _keyboardVisible=false;


  @override
  void initState() {
    print("SALE -INIt");
    SystemChrome.setEnabledSystemUIOverlays([]);
   Provider.of<QuarryNotifier>(context,listen: false).initTabController(this,context,widget.fromsaleGrid);

    scrollController = new ScrollController();
    listViewController = new ScrollController();
    setState(() {

    });
    listViewController.addListener(() {
      if(listViewController.position.userScrollDirection == ScrollDirection.forward){
        print("Down");
      } else
      if(listViewController.position.userScrollDirection == ScrollDirection.reverse){
        print("Up");
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node=FocusScope.of(context);
    SizeConfig().init(context);
    String timestamp = formatter.format(now);
    String time = formatterTime.format(now);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
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
                                      height: SizeConfig.height200,

                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                "assets/images/saleFormheader.jpg",),
                                              fit: BoxFit.cover
                                          )

                                      ),
                                    ),


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
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                                        ),
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
                                            height: _keyboardVisible ? SizeConfig.screenHeight * 0.5 : SizeConfig.screenHeight,
                                          //  height:  SizeConfig.screenHeight ,
                                            width: SizeConfig.screenWidth,

                                            decoration: BoxDecoration(
                                                color: AppTheme.gridbodyBgColor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10))
                                            ),
                                            child: ListView(
                                              controller: listViewController,
                                              scrollDirection: Axis.vertical,

                                              children: [


                                                AddNewLabelTextField(
                                                  labelText: 'Vehicle Number',
                                                  textEditingController: qn.SS_vehicleNo,
                                                  ontap: () {
                                                    setState(() {
                                                      //_keyboardVisible=true;
                                                    });
                                                    scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                  },

                                                  onEditComplete: () {
                                                    node.unfocus();
                                                    Timer(Duration(milliseconds: 100), (){
                                                      setState(() {
                                                        // _keyboardVisible=false;
                                                      });
                                                    });
                                                  },
                                                ),

                                                GestureDetector(

                                                  onTap: () {
                                                    node.unfocus();
                                                    setState(() {
                                                     // _keyboardVisible=false;
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
                                                  textEditingController: qn.SS_emptyVehicleWeight,
                                                  textInputType: TextInputType.number,
                                                  ontap: () {
                                                    setState(() {
                                                      //_keyboardVisible=true;
                                                    });
                                                    scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                  },

                                                  onEditComplete: () {
                                                    node.unfocus();
                                                    Timer(Duration(milliseconds: 100), (){
                                                      setState(() {
                                                        // _keyboardVisible=false;
                                                      });
                                                    });
                                                  },
                                                ),


                                                GestureDetector(
                                                  onTap: () {
                                                    node.unfocus();
                                                    setState(() {
                                                    //  _keyboardVisible=false;
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

                                                GestureDetector(
                                                  onTap: (){
                                                    node.unfocus();
                                                    CustomAlert().commonErrorAlert(context, "Select Material Type", "");
                                                  },
                                                  child: AddNewLabelTextField(
                                                    labelText: 'Required Quantity',
                                                    textEditingController: qn.SS_customerNeedWeight,
                                                    textInputType: TextInputType.number,
                                                    isEnabled:qn.SS_selectedMaterialTypeId==null?false: true,
                                                    scrollPadding: 50,
                                                    ontap: () {
                                                      setState(() {
                                                        //_keyboardVisible=true;
                                                      });
                                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                    },
                                                    onChange: (v){
                                                      qn.weightToAmount();
                                                    },
                                                    onEditComplete: () {
                                                      node.unfocus();
                                                      Timer(Duration(milliseconds: 100), (){
                                                        setState(() {
                                                         // _keyboardVisible=false;
                                                        });
                                                      });
                                                    },
                                                    suffixIcon:qn.SS_Empty_ReqQtyUnit.isEmpty?Container(
                                                      height: SizeConfig.height50,
                                                      width: 100,
                                                    ): Container(
                                                        height: SizeConfig.height50,
                                                        width: 100,

                                                        child: Center(
                                                            child: Container(
                                                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(SizeConfig.height25),
                                                                    color: AppTheme.yellowColor
                                                                ),
                                                            child: Text("${qn.SS_Empty_ReqQtyUnit}",
                                                              style: TextStyle(fontFamily: 'RR',fontSize: 18,color: Colors.white),)
                                                        )
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
                                                    textEditingController: qn.SS_amount,
                                                    textInputType: TextInputType.number,
                                                   scrollPadding: 50,
                                                   isEnabled:qn.SS_selectedMaterialTypeId==null?false: true,

                                                    onChange: (v){
                                                      qn.amountToWeight();
                                                    },
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
                                                ),

                                                GestureDetector(
                                                  onTap: () {
                                                    node.unfocus();
                                                    setState(() {
                                                      //  _keyboardVisible=false;
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
                                                      //  _keyboardVisible=false;
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
                                                

                                                SizedBox(height: SizeConfig.height100,)
                                              ],
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
                                    IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                                      qn.clearEmptyForm();
                                      Navigator.pop(context);
                                    }),
                                    SizedBox(width: SizeConfig.width5,),
                                    Text("Sales",
                                      style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                                    ),
                                    Text(qn.tabController.index==0?" / In Gate":" / Out Gate",
                                      style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ),


/////////////////////////////////////////////////////LOADED /////

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
                                          height: SizeConfig.height200,

                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    "assets/images/saleFormheader.jpg",),
                                                  fit: BoxFit.cover
                                              )

                                          ),
                                        ),


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
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                                            ),
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
                                                height: _keyboardVisible ? SizeConfig.screenHeight * 0.5 : SizeConfig.screenHeight-SizeConfig.height100,
                                                //  height:  SizeConfig.screenHeight ,
                                                width: SizeConfig.screenWidth,

                                                decoration: BoxDecoration(
                                                    color: AppTheme.gridbodyBgColor,
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(10))
                                                ),
                                                child: ListView(
                                                  controller: listViewController,
                                                  scrollDirection: Axis.vertical,

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
                                                          qn.SS_PaymentCategoryName=qn.saleDetails[index].PaymentCategoryName;
                                                          qn.SS_PaymentTypeId=qn.saleDetails[index].PaymentCategoryId;
                                                          qn.SS_UpdateSaleId=qn.saleDetails[index].SaleId;
                                                          qn.SS_UpdateSaleNo=qn.saleDetails[index].SaleNumber;
                                                          qn.SS_selectCustomerId=qn.saleDetails[index].CustomerId;
                                                          qn.SS_TotalWeight=(Decimal.parse(qn.SS_EmptyWeightOfVehicle)+Decimal.parse((qn.SS_RequiredMaterialQty))).toString();
                                                          qn.SS_MaterialUnitPrice=qn.sale_materialList.where((element) => element.MaterialId==qn.saleDetails[index].MaterialId).toList()[0].MaterialUnitPrice;
                                                        });
                                                      },
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                                                      height:SizeConfig.height60,
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
                                                              height: SizeConfig.height60,
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
                                                      height:SizeConfig.height60,
                                                      width: SizeConfig.width320,
                                                      decoration: BoxDecoration(

                                                        // borderRadius: BorderRadius.circular(3),
                                                          border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                              right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom: BorderSide(color: AppTheme.addNewTextFieldBorder))

                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              padding: EdgeInsets.only(left: SizeConfig.width10),
                                                              width: SizeConfig.width140-2,
                                                              child: Text("Vehicle Type")
                                                          ),

                                                          Container(
                                                              height: SizeConfig.height60,
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
                                                      height:SizeConfig.height60,
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
                                                              height: SizeConfig.height60,
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
                                                      height:SizeConfig.height60,
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
                                                              height: SizeConfig.height60,
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
                                                      height:SizeConfig.height60,
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
                                                              height: SizeConfig.height60,
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
                                                    Container(
                                                      margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                                      height:SizeConfig.height60,
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
                                                              height: SizeConfig.height60,
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
                                                      height:SizeConfig.height60,
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
                                                              height: SizeConfig.height60,
                                                              width: 1,
                                                              color: AppTheme.addNewTextFieldBorder
                                                          ),

                                                          Container(
                                                              height:SizeConfig.height60,
                                                              padding: EdgeInsets.only(left: SizeConfig.width10),
                                                              width: SizeConfig.width140-1,
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(qn.SS_TotalWeight==null?"":"${qn.SS_TotalWeight + " Ton"??""}")),
                                                        ],
                                                      ),
                                                    ),
                                                    AddNewLabelTextField(
                                                      labelText: 'Outward Weight',
                                                      scrollPadding: 200,
                                                      textInputType: TextInputType.number,
                                                      textEditingController: qn.SS_DifferWeightController,
                                                      suffixIcon: Container(
                                                          height:SizeConfig.height60,
                                                          width: 50,
                                                          child: Center(child: Text("Ton",style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.addNewTextFieldText.withOpacity(0.7)),))
                                                      ),
                                                      onChange: (v){
                                                        qn.differWeight();
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
                                                          });
                                                        },


                                                    ),
                                                    SizedBox(height: SizeConfig.height20,),
                                                    Text(qn.msg,style: TextStyle(fontFamily: 'RR',fontSize: 16),),
                                                    SizedBox(height: SizeConfig.height20,),
                                                    qn.returnMoney.isNotEmpty?Container(
                                                      height: SizeConfig.height60,
                                                      width: double.maxFinite,
                                                      decoration: BoxDecoration(
                                                          color: qn.returnColor,
                                                          // color: double.parse(qn.returnMoney.toString()) > qn.SS_Amount? Colors.red :Colors.green ,
                                                          borderRadius: BorderRadius.circular(3)
                                                      ),

                                                      margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20),
                                                      child: Center(
                                                        child: Text(qn.returnMoney,style: TextStyle(fontFamily: 'RR',fontSize: 24,color: Colors.white
                                                          //color:double.parse(qn.returnMoney.toString()) > qn.SS_Amount? AppTheme.bgColor :Colors.white
                                                        )),
                                                      ),
                                                    ):Container(),


                                                    SizedBox(height: SizeConfig.height20,),



                                                    /*SizedBox(height: SizeConfig.height100,)*/
                                                  ],
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
                                        IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                                          qn.clearEmptyForm();
                                          qn.clearLoaderForm();
                                          Navigator.pop(context);
                                        }),
                                        SizedBox(width: SizeConfig.width5,),
                                        Text("Sales",
                                          style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                                        ),
                                        Text(qn.tabController.index==0?" / In Gate":" / Out Gate",
                                          style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            ),


                            /*Container(
                              height: SizeConfig.screenHeight-(SizeConfig.height70),
                              child: SingleChildScrollView(
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
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                                                Navigator.pop(context);
                                                qn.clearCustomerDetails();

                                              }),
                                              SizedBox(width: SizeConfig.width20,),
                                              Text("Sales Detail",
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
                                          //   // child: Row(
                                          //   //   children: [
                                          //   //     SizedBox(width: SizeConfig.width10,),
                                          //   //     Text("Order #",style: TextStyle(fontSize: 16,fontFamily: 'RR',color: Colors.white),),
                                          //   //     Spacer(),
                                          //   //     Text(timestamp,style: TextStyle(fontSize: 16,fontFamily: 'RR',color: Colors.white),),
                                          //   //     Text(time,style: TextStyle(fontSize: 16,fontFamily: 'RR',color: Colors.white),),
                                          //   //     SizedBox(width: SizeConfig.width10,),
                                          //   //   ],
                                          //   // ),
                                          // )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: SizeConfig.screenHeight-(SizeConfig.height270),
                                      child: SingleChildScrollView(
                                        child: Column(

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
                                                    qn.SS_PaymentCategoryName=qn.saleDetails[index].PaymentCategoryName;
                                                    qn.SS_PaymentTypeId=qn.saleDetails[index].PaymentCategoryId;
                                                    qn.SS_UpdateSaleId=qn.saleDetails[index].SaleId;
                                                    qn.SS_UpdateSaleNo=qn.saleDetails[index].SaleNumber;
                                                    qn.SS_selectCustomerId=qn.saleDetails[index].CustomerId;
                                                    qn.SS_TotalWeight=(Decimal.parse(qn.SS_EmptyWeightOfVehicle)+Decimal.parse((qn.SS_RequiredMaterialQty))).toString();
                                                    qn.SS_MaterialUnitPrice=qn.sale_materialList.where((element) => element.MaterialId==qn.saleDetails[index].MaterialId).toList()[0].MaterialUnitPrice;
                                                  });
                                              },
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                                              height:SizeConfig.height60,
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
                                                      height: SizeConfig.height60,
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
                                              height:SizeConfig.height60,
                                              width: SizeConfig.width320,
                                              decoration: BoxDecoration(

                                                  // borderRadius: BorderRadius.circular(3),
                                                border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                  right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom: BorderSide(color: AppTheme.addNewTextFieldBorder))

                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      padding: EdgeInsets.only(left: SizeConfig.width10),
                                                      width: SizeConfig.width140-2,
                                                      child: Text("Vehicle Type")
                                                  ),

                                                  Container(
                                                    height: SizeConfig.height60,
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
                                              height:SizeConfig.height60,
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
                                                    height: SizeConfig.height60,
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
                                              height:SizeConfig.height60,
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
                                                    height: SizeConfig.height60,
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
                                              height:SizeConfig.height60,
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
                                                    height: SizeConfig.height60,
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
                                            Container(
                                              margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                              height:SizeConfig.height60,
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
                                                    height: SizeConfig.height60,
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
                                              height:SizeConfig.height60,
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
                                                    height: SizeConfig.height60,
                                                    width: 1,
                                                    color: AppTheme.addNewTextFieldBorder
                                                  ),

                                                  Container(
                                                      height:SizeConfig.height60,
                                                      padding: EdgeInsets.only(left: SizeConfig.width10),
                                                      width: SizeConfig.width140-1,
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(qn.SS_TotalWeight==null?"":"${qn.SS_TotalWeight + " Ton"??""}")),
                                                ],
                                              ),
                                            ),
                                            AddNewLabelTextField(
                                              labelText: 'Outward Weight',
                                              scrollPadding: 200,
                                              textInputType: TextInputType.number,
                                              textEditingController: qn.SS_DifferWeightController,
                                              suffixIcon: Container(
                                                  height:SizeConfig.height60,
                                                  width: 50,
                                                  child: Center(child: Text("Ton",style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.addNewTextFieldText.withOpacity(0.7)),))
                                              ),
                                              onChange: (v){
                                                qn.differWeight();
                                              },


                                            ),
                                            SizedBox(height: SizeConfig.height20,),
                                            Text(qn.msg,style: TextStyle(fontFamily: 'RR',fontSize: 16),),
                                            SizedBox(height: SizeConfig.height20,),
                                            qn.returnMoney.isNotEmpty?Container(
                                              height: SizeConfig.height60,
                                              width: double.maxFinite,
                                              decoration: BoxDecoration(
                                                color: qn.returnColor,
                                                  // color: double.parse(qn.returnMoney.toString()) > qn.SS_Amount? Colors.red :Colors.green ,
                                                borderRadius: BorderRadius.circular(3)
                                              ),

                                              margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20),
                                              child: Center(
                                                child: Text(qn.returnMoney,style: TextStyle(fontFamily: 'RR',fontSize: 24,color: Colors.white
                                                    //color:double.parse(qn.returnMoney.toString()) > qn.SS_Amount? AppTheme.bgColor :Colors.white
                                                )),
                                              ),
                                            ):Container(),


                                            SizedBox(height: SizeConfig.height20,),



                                            GestureDetector(
                                              onTap: (){
                                                node.unfocus();
                                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                if(qn.searchVehicleNo.text.isEmpty){
                                                  CustomAlert().commonErrorAlert(context, "Enter Vehicle Number", "");
                                                }
                                               else if(qn.SS_DifferWeightController.text.isEmpty){
                                                  CustomAlert().commonErrorAlert(context, "Enter Vehicle Weight", "");
                                                }else{
                                                  qn.UpdateSaleDetailDbhit(context);
                                                }

                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(bottom: SizeConfig.height50),
                                                height: SizeConfig.height50,
                                                width: SizeConfig.width100,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: AppTheme.yellowColor
                                                ),
                                                child: Center(
                                                  child: Text("Save",style: TextStyle(fontFamily: 'RR',fontSize: 20,color: AppTheme.bgColor,letterSpacing: 0.1),),
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ),*/
                      ]
                      ),
                    ),


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
                                  if(qn.SS_vehicleNo.text.isEmpty){
                                    CustomAlert().commonErrorAlert(context, "Enter Vehicle Number", "");
                                  }
                                  else if(qn.SS_emptyVehicleWeight.text.isEmpty){
                                    CustomAlert().commonErrorAlert(context, "Enter Vehicle Weight", "");
                                  }
                                  else if(qn.SS_customerNeedWeight.text.isEmpty && qn.SS_customerNeedWeight.text!="0"){
                                    CustomAlert().commonErrorAlert(context, "Enter Customer Need Weight", "");
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
                                  }else{
                                    qn.UpdateSaleDetailDbhit(context);
                                  }
                                }







                              },
                              child: Container(

                                height: SizeConfig.width50,
                                width: SizeConfig.width50,
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
                                  child: Icon(Icons.add,size: SizeConfig.height30,color: AppTheme.bgColor,),
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

                                          },
                                          child: Container(
                                            width: 70,

                                            child:Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/images/Empty-vehicle-active.png",height: 40,width: 40,),
                                                Text('In Gate',style: TextStyle(fontFamily: 'RR',fontSize: 14),),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: (){
                                            qn.tabController.animateTo(1,duration: Duration(milliseconds: 300),curve: Curves.easeIn);

                                          },
                                          child: Container(
                                            width: 90,

                                            child:Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/images/Loaded-vehicle-active.png",height: 40,width: 40,),
                                                Text('Out Gate',style: TextStyle(fontFamily: 'RR',fontSize: 14),),

                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: SizeConfig.width10,),
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

                height: isTransportModeOpen || isPaymentTypeOpen || isCustomerDetaislOpen || isMaterialTypeOpen? SizeConfig.screenHeight:0,
                width: isTransportModeOpen || isPaymentTypeOpen || isCustomerDetaislOpen || isMaterialTypeOpen? SizeConfig.screenWidth:0,
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

///////////////////////////////// Transport Type /////////////////////////////////
                Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.antiAlias,

                  margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30,),
                  transform: Matrix4.translationValues(isTransportModeOpen?0:SizeConfig.screenWidth, 0, 0),
                  child: Stack(
                    children: [
                      Container(
                        height: SizeConfig.height70,
                        width: double.maxFinite,
                        color: Colors.white,
                        padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text('Select Vehicle Type',style: AppTheme.bgColorTS,),
                            Spacer(),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isTransportModeOpen=false;
                                });
                              },
                              child: Container(
                                height: SizeConfig.height30,
                                width: SizeConfig.height30,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.bgColor

                                ),
                                child: Center(
                                  child:  Icon(Icons.close,
                                    color: Colors.white,size: 20,),
                                ),
                              ),
                            )

                          ],
                        ),

                      ),
                      Positioned(
                        top: SizeConfig.height60,
                        child: Container(
                          height: SizeConfig.screenHeight*0.5- SizeConfig.height80,
                          width: SizeConfig.screenWidth-SizeConfig.width60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                          child: ListView.builder(
                              itemCount: qn.vehicleList.length,
                              itemBuilder: (context,index){
                           return GestureDetector(
                             onTap: (){

                               setState(() {
                                 isTransportModeOpen=false;
                                 qn.SS_selectedVehicleTypeId=qn.vehicleList[index].VehicleTypeId;
                                 qn.SS_selectedVehicleTypeName=qn.vehicleList[index].VehicleTypeName;
                               });
                             },
                             child: Container(
                                margin: EdgeInsets.only(left: SizeConfig.width50,right:  SizeConfig.width50,top: SizeConfig.height20),

                                height: SizeConfig.height50,
                                width: SizeConfig.screenWidth,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                    color: qn.SS_selectedVehicleTypeId==null ?Colors.white:qn.SS_selectedVehicleTypeId==qn.vehicleList[index].VehicleTypeId?AppTheme.bgColor:Colors.white

                                ),
                                child: Center(
                                  child: Text("${qn.vehicleList[index].VehicleTypeName}",style: TextStyle(fontFamily: 'RR',fontSize: 18,
                                      color: qn.SS_selectedVehicleTypeId==null ?AppTheme.bgColor:qn.SS_selectedVehicleTypeId==qn.vehicleList[index].VehicleTypeId?Colors.white:AppTheme.bgColor

                                  ),),
                                ),
                              ),
                           );
                          }),

                        ),
                      )

                    ],
                  ),
                ),
              ),



///////////////////////////////// Material  Type //////////////////////////////////
              Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.antiAlias,

                  margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30,),
                  transform: Matrix4.translationValues(isMaterialTypeOpen?0:SizeConfig.screenWidth, 0, 0),
                  child: Stack(
                    children: [
                      Container(
                        height: SizeConfig.height70,
                        width: double.maxFinite,
                        color: Colors.white,
                        padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text('Select Material Type',style: AppTheme.bgColorTS,),
                            Spacer(),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isMaterialTypeOpen=false;
                                });
                              },
                              child: Container(
                                height: SizeConfig.height30,
                                width: SizeConfig.height30,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.bgColor

                                ),
                                child: Center(
                                  child:  Icon(Icons.close,
                                    color: Colors.white,size: 20,),
                                ),
                              ),
                            )

                          ],
                        ),

                      ),
                      Positioned(
                        top: SizeConfig.height60,
                        child: Container(
                          height: SizeConfig.screenHeight*0.5- SizeConfig.height80,
                          width: SizeConfig.screenWidth-SizeConfig.width60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                          child: ListView.builder(
                              itemCount: qn.sale_materialList.length,
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){

                                    setState(() {
                                      isMaterialTypeOpen=false;
                                      qn.SS_selectedMaterialTypeId=qn.sale_materialList[index].MaterialId;
                                      qn.SS_selectedMaterialTypeName=qn.sale_materialList[index].MaterialName;
                                      qn.SS_Empty_ReqQtyUnit=qn.sale_materialList[index].MaterialUnitName;
                                    });
                                    qn.weightToAmount();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: SizeConfig.width50,right:  SizeConfig.width50,top: SizeConfig.height20),

                                    height: SizeConfig.height50,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                        //color: Colors.white
                                        color: qn.SS_selectedMaterialTypeId==null ?Colors.white:qn.SS_selectedMaterialTypeId==qn.sale_materialList[index].MaterialId?AppTheme.bgColor:Colors.white

                                    ),
                                    child: Center(
                                      child: Text("${qn.sale_materialList[index].MaterialName}",style: TextStyle(fontFamily: 'RR',fontSize: 18,
                                          color: qn.SS_selectedMaterialTypeId==null ?AppTheme.bgColor:qn.SS_selectedMaterialTypeId==qn.sale_materialList[index].MaterialId?Colors.white:AppTheme.bgColor

                                      ),),
                                    ),
                                  ),
                                );
                              }),

                        ),
                      )

                    ],
                  ),
                ),
              ),








///////////////////////////////// Payment Type //////////////////////////////////
              Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.antiAlias,

                  margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30,),
                  transform: Matrix4.translationValues(isPaymentTypeOpen?0:SizeConfig.screenWidth, 0, 0),
                  child: Stack(
                    children: [
                      Container(
                        height: SizeConfig.height70,
                        width: double.maxFinite,
                        color: Colors.white,
                        padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text('Select Payment Type',style: AppTheme.bgColorTS,),
                            Spacer(),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isPaymentTypeOpen=false;
                                });
                              },
                              child: Container(
                                height: SizeConfig.height30,
                                width: SizeConfig.height30,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.bgColor

                                ),
                                child: Center(
                                  child:  Icon(Icons.close,
                                    color: Colors.white,size: 20,),
                                ),
                              ),
                            )

                          ],
                        ),

                      ),
                      Positioned(
                        top: SizeConfig.height60,
                        child: Container(
                          height: SizeConfig.screenHeight*0.5- SizeConfig.height80,
                          width: SizeConfig.screenWidth-SizeConfig.width60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                          child: ListView.builder(
                              itemCount: qn.sale_paymentList.length,
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      isPaymentTypeOpen=false;
                                      qn.SS_selectedPaymentTypeId=qn.sale_paymentList[index].PaymentCategoryId;
                                      qn.SS_selectedPaymentTypeString=qn.sale_paymentList[index].PaymentCategoryName;
                                    });

                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: SizeConfig.width50,right:  SizeConfig.width50,top: SizeConfig.height20),

                                    height: SizeConfig.height50,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                        color: qn.SS_selectedPaymentTypeId==null ?Colors.white:qn.SS_selectedPaymentTypeId==qn.sale_paymentList[index].PaymentCategoryId?AppTheme.bgColor:Colors.white
                                    ),
                                    child: Center(
                                      child: Text("${qn.sale_paymentList[index].PaymentCategoryName}",style: TextStyle(fontFamily: 'RR',fontSize: 18,
                                          color: qn.SS_selectedPaymentTypeId==null ?AppTheme.bgColor:qn.SS_selectedPaymentTypeId==qn.sale_paymentList[index].PaymentCategoryId?Colors.white:AppTheme.bgColor

                                      ),),
                                    ),
                                  ),
                                );
                              }),

                        ),
                      )

                    ],
                  ),
                ),
              ),








///////////////////////////////// Customer Details //////////////////////////////////
              Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.antiAlias,

                  margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30,),
                  transform: Matrix4.translationValues(isCustomerDetaislOpen?0:SizeConfig.screenWidth, 0, 0),
                  child: Stack(
                    children: [
                      Container(
                        height: SizeConfig.height70,
                        width: double.maxFinite,
                        color: Colors.white,
                        padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text('Select Customer',style: AppTheme.bgColorTS,),
                            Spacer(),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isCustomerDetaislOpen=false;
                                });
                              },
                              child: Container(
                                height: SizeConfig.height30,
                                width: SizeConfig.height30,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.bgColor

                                ),
                                child: Center(
                                  child:  Icon(Icons.close,
                                    color: Colors.white,size: 20,),
                                ),
                              ),
                            )

                          ],
                        ),

                      ),
                      Positioned(
                        top: SizeConfig.height60,
                        child: Container(
                          height: SizeConfig.screenHeight*0.5- SizeConfig.height80,
                          width: SizeConfig.screenWidth-SizeConfig.width60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                          child: ListView.builder(
                              itemCount: qn.sale_customerList.length,
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      isCustomerDetaislOpen=false;
                                      qn.SS_selectCustomerId=qn.sale_customerList[index].customerId;
                                      qn.SS_selectedCustomerName=qn.sale_customerList[index].customerName;
                                    });

                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: SizeConfig.width50,right:  SizeConfig.width50,top: SizeConfig.height20),

                                    height: SizeConfig.height50,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                        color: qn.SS_selectCustomerId==null ?Colors.white:qn.SS_selectCustomerId==qn.sale_customerList[index].customerId?AppTheme.bgColor:Colors.white
                                    ),
                                    child: Center(
                                      child: Text("${qn.sale_customerList[index].customerName}",style: TextStyle(fontFamily: 'RR',fontSize: 18,
                                          color: qn.SS_selectCustomerId==null ?AppTheme.bgColor:qn.SS_selectCustomerId==qn.sale_customerList[index].customerId?Colors.white:AppTheme.bgColor

                                      ),),
                                    ),
                                  ),
                                );
                              }),

                        ),
                      )

                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SaleAddNew(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
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
      margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
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
