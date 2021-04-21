import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/vendor/vendorLocAddNew.dart';
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


  final now = DateTime.now();
  final formatter = DateFormat('dd/MM/yyyy');
  final formatterTime = DateFormat.jm();

bool isTransportModeOpen=false;
bool isPaymentTypeOpen=false;
bool isMaterialTypeOpen=false;
bool isCustomerDetaislOpen=false;


  @override
  void initState() {
    print("SALE -INIt");
    SystemChrome.setEnabledSystemUIOverlays([]);
   Provider.of<QuarryNotifier>(context,listen: false).initTabController(this,context,widget.fromsaleGrid);
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
        child: SafeArea(
          child: Consumer<QuarryNotifier>(
            builder: (context,qn,child)=>  SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: SizeConfig.screenHeight,
                    width: SizeConfig.screenWidth,

                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: SizeConfig.screenHeight-(SizeConfig.height70),
                            child: TabBarView(
                                controller: qn.tabController,
                                children: [
                                Container(
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
                                                IconButton(icon: Icon(Icons.arrow_back), onPressed:(){
                                                  Navigator.pop(context);
                                                  qn.clearCustomerDetails();
                                                }),

                                                // IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                                                SizedBox(width: SizeConfig.width20,),
                                                Text("Sales Detail",
                                                  style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                                                ),
                                                Spacer(),

                                              ],
                                            ),
                                            Spacer(),


                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: SizeConfig.screenHeight-(SizeConfig.height270),
                                        child: SingleChildScrollView(
                                          child: Column(

                                            children: [
                                              AddNewLabelTextField(
                                                labelText: 'Vehicle Number',
                                                textEditingController: qn.SS_vehicleNo,


                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                   node.unfocus();
                                                  setState(() {
                                                    isTransportModeOpen=true;
                                                  });

                                                },
                                                child:SidePopUpParent(text: qn.SS_selectedVehicleTypeId==null?'Vehicle Type':
                                                qn.vehicleList.where((element) => element.VehicleTypeId==qn.SS_selectedVehicleTypeId).toList()[0].VehicleTypeName
                                                  ,),
                                              ),
                                              AddNewLabelTextField(
                                                labelText: 'Empty Vehicle Weight',
                                                scrollPadding: 100,
                                                textInputType: TextInputType.number,
                                                textEditingController: qn.SS_emptyVehicleWeight,
                                                suffixIcon: Container(
                                                    height:SizeConfig.height60,
                                                    width: 50,
                                                    child: Center(child: Text("Ton",style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.addNewTextFieldText.withOpacity(0.7)),))
                                                ),

                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  node.unfocus();
                                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                  setState(() {
                                                    isMaterialTypeOpen=true;
                                                  });

                                                },
                                                child:SidePopUpParent(text:qn.SS_selectedMaterialTypeId==null? 'Select Material Type':
                                                  qn.sale_materialList.where((element) => element.MaterialId==qn.SS_selectedMaterialTypeId).toList()[0].MaterialName
                                                  ,),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  node.unfocus();
                                                  CustomAlert().commonErrorAlert(context, "Select Material Type", "");
                                                },
                                                child: AddNewLabelTextField(
                                                  ontap: (){

                                                  },
                                                  labelText: 'Required Quantity',
                                                  scrollPadding: 100,
                                                  textInputType: TextInputType.number,
                                                  textEditingController: qn.SS_customerNeedWeight,
                                                  onChange: (v){
                                                    qn.weightToAmount();
                                                  },
                                                  isEnabled:qn.SS_selectedMaterialTypeId==null?false: true,
                                                  suffixIcon: Container(
                                                    height: SizeConfig.height60,
                                                    width: 100,
                                                      child: Center(child: Text("${qn.SS_Empty_ReqQtyUnit}",style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.addNewTextFieldText.withOpacity(0.7)),))

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
                                                  scrollPadding: 100,
                                                  textInputType: TextInputType.number,
                                                  textEditingController: qn.SS_amount,
                                                  onChange: (v){
                                                    qn.amountToWeight();
                                                  },
                                                  isEnabled:qn.SS_selectedMaterialTypeId==null?false: true,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  node.unfocus();
                                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                  setState(() {
                                                    isPaymentTypeOpen=true;
                                                  });

                                                },
                                                child:SidePopUpParent(text: qn.SS_selectedPaymentTypeId==null?'Select Payment Type':
                                                qn.sale_paymentList.where((element) => element.PaymentCategoryId==qn.SS_selectedPaymentTypeId).toList()[0].PaymentCategoryName
                                                  ,),
                                              ),
                                              SizedBox(height: SizeConfig.height20,),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      isCustomerDetaislOpen=true;
                                                    });
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(right: SizeConfig.width20),
                                                    height: SizeConfig.height30,
                                                    width: SizeConfig.width150,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: AppTheme.bgColor
                                                    ),
                                                    child: Center(
                                                      child: Text("Customer Details",style: AppTheme.TSWhite16,),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: SizeConfig.height20,),
                                              GestureDetector(
                                                onTap: (){
                                                  node.unfocus();
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
                                              )

                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ),


/////////////////////////////////////////////////////LOADED /////
                                  Container(
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

                                                        // if(qn.brandNameController.text.isEmpty){
                                                        //   CustomAlert().commonErrorAlert(context, "Select Branch", "");
                                                        // }
                                                        // else if(qn.brandQtyController.text.isEmpty){
                                                        //   CustomAlert().commonErrorAlert(context, "Enter Quantity", "");
                                                        // }
                                                        // else{
                                                        //   qn.InsertMaterialBrandMasterDetailsDbHit(context,qn.brandNameController.text);
                                                        // }

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
                                                  )

                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ),
                            ]
                            ),
                          ),


                          Container(
                            height: SizeConfig.height70,
                            color: AppTheme.bgColor,
                            child: TabBar(
                                controller: qn.tabController,
                                indicatorPadding: EdgeInsets.only(top: SizeConfig.height10,bottom: SizeConfig.height10),

                                indicator: BoxDecoration(
                                  color: Color(0xFF1C1C1C),
                                borderRadius: BorderRadius.circular(SizeConfig.height25)
                                // border: Border.all(color: Color(0xFF1C1C1C),)
                                ),
                                tabs: [
                              Tab(
                                child: Row(
                                  children: [
                                    Image.asset("assets/images/Empty-vehicle-active.png",height: 40,width: 40,),
                                    Text('  Empty Vehicle'),
                                  ],
                                ),
                              ),
                                  Tab(
                                    child: Row(
                                      children: [
                                        Text('Loaded Vehicle  '),
                                        Image.asset("assets/images/Loaded-vehicle-active.png",height: 40,width: 40,),
                                      ],
                                    ),
                                  ),
                            ]
                            ),
                          )
                        ],
                      ),
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

///////////////////////////////// Transport Type //////////////////////////////////
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight*0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,

                    margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: SizeConfig.screenHeight*0.1),
                    transform: Matrix4.translationValues(isTransportModeOpen?0:SizeConfig.screenWidth, 0, 0),
                    child: Stack(
                      children: [
                        Container(
                          height: SizeConfig.height70,
                          width: double.maxFinite,
                          color: Color(0xFF6769F0),
                          padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Vehicle Type',style: AppTheme.TSWhite20,),
                              Spacer(),
                              GestureDetector(
                                onTap: (){
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  setState(() {
                                    isTransportModeOpen=false;
                                  });
                                },
                                child: Container(
                                  height: SizeConfig.height30,
                                  width: SizeConfig.height30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white

                                  ),
                                  child: Center(
                                    child:  Icon(Icons.close,
                                      color: Color(0xFF6769F0),size: 28,),
                                  ),
                                ),
                              )

                            ],
                          ),

                        ),
                        Positioned(
                          top: SizeConfig.height60,
                          child: Container(
                            height: SizeConfig.screenHeight- SizeConfig.screenHeight*(200/1280),
                            width: SizeConfig.screenWidth-SizeConfig.width40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFF2F4FA)
                            ),
                            child: ListView.builder(
                                itemCount: qn.vehicleList.length,
                                itemBuilder: (context,index){
                             return GestureDetector(
                               onTap: (){

                                 setState(() {
                                   isTransportModeOpen=false;
                                   qn.SS_selectedVehicleTypeId=qn.vehicleList[index].VehicleTypeId;
                                 });
                               },
                               child: Container(
                                  margin: EdgeInsets.only(left: SizeConfig.width50,right:  SizeConfig.width50,top: SizeConfig.height20),

                                  height: SizeConfig.height50,
                                  width: double.maxFinite,
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



///////////////////////////////// Material  Type //////////////////////////////////
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight*0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,

                    margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: SizeConfig.screenHeight*0.1),
                    transform: Matrix4.translationValues(isMaterialTypeOpen?0:SizeConfig.screenWidth, 0, 0),
                    child: Stack(
                      children: [
                        Container(
                          height: SizeConfig.height70,
                          width: double.maxFinite,
                          color: Color(0xFF6769F0),
                          padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Material Type',style: AppTheme.TSWhite20,),
                              Spacer(),
                              GestureDetector(
                                onTap: (){
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  setState(() {
                                    isMaterialTypeOpen=false;
                                  });
                                },
                                child: Container(
                                  height: SizeConfig.height30,
                                  width: SizeConfig.height30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white

                                  ),
                                  child: Center(
                                    child:  Icon(Icons.close,
                                      color: Color(0xFF6769F0),size: 28,),
                                  ),
                                ),
                              )

                            ],
                          ),

                        ),
                        Positioned(
                          top: SizeConfig.height60,
                          child: Container(
                            height: SizeConfig.screenHeight- SizeConfig.screenHeight*(200/1280),
                            width: SizeConfig.screenWidth-SizeConfig.width40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFF2F4FA)
                            ),
                            child: ListView.builder(
                                itemCount: qn.sale_materialList.length,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){

                                      setState(() {
                                        isMaterialTypeOpen=false;
                                        qn.SS_selectedMaterialTypeId=qn.sale_materialList[index].MaterialId;
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


///////////////////////////////// Payment Type //////////////////////////////////
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight*0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,

                    margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: SizeConfig.screenHeight*0.1),
                    transform: Matrix4.translationValues(isPaymentTypeOpen?0:SizeConfig.screenWidth, 0, 0),
                    child: Stack(
                      children: [
                        Container(
                          height: SizeConfig.height70,
                          width: double.maxFinite,
                          color: Color(0xFF6769F0),
                          padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Payment Type',style: AppTheme.TSWhite20,),
                              Spacer(),
                              GestureDetector(
                                onTap: (){
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  setState(() {
                                    isPaymentTypeOpen=false;
                                  });
                                },
                                child: Container(
                                  height: SizeConfig.height30,
                                  width: SizeConfig.height30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white

                                  ),
                                  child: Center(
                                    child:  Icon(Icons.close,
                                      color: Color(0xFF6769F0),size: 28,),
                                  ),
                                ),
                              )

                            ],
                          ),

                        ),
                        Positioned(
                          top: SizeConfig.height60,
                          child: Container(
                            height: SizeConfig.screenHeight- SizeConfig.screenHeight*(200/1280),
                            width: SizeConfig.screenWidth-SizeConfig.width40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFF2F4FA)
                            ),
                            child: ListView.builder(
                                itemCount: qn.sale_paymentList.length,
                                itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      isPaymentTypeOpen=false;
                                      qn.SS_selectedPaymentTypeId=qn.sale_paymentList[index].PaymentCategoryId;
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


///////////////////////////////// Customer Details //////////////////////////////////
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight*0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,

                    margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: SizeConfig.screenHeight*0.1),
                    transform: Matrix4.translationValues(isCustomerDetaislOpen?0:SizeConfig.screenWidth, 0, 0),
                    child: Stack(
                      children: [
                        Container(
                          height: SizeConfig.height70,
                          width: double.maxFinite,
                          color: Color(0xFF6769F0),
                          padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Customer Details',style: AppTheme.TSWhite20,),
                              Spacer(),
                              GestureDetector(
                                onTap: (){
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  setState(() {
                                    isCustomerDetaislOpen=false;
                                  });
                                },
                                child: Container(
                                  height: SizeConfig.height30,
                                  width: SizeConfig.height30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white

                                  ),
                                  child: Center(
                                    child:  Icon(Icons.close,
                                      color: Color(0xFF6769F0),size: 28,),
                                  ),
                                ),
                              )

                            ],
                          ),

                        ),
                        Positioned(
                          top: SizeConfig.height60,
                          child: Container(
                            height: (SizeConfig.screenHeight*0.8)-((SizeConfig.screenHeight*(100/1280))),
                            width: SizeConfig.screenWidth-SizeConfig.width40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFF2F4FA)
                            ),
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                children: [
                                  Container(
                                    height: SizeConfig.height80,
                                    child: TabBar(

                                        unselectedLabelColor: AppTheme.addNewTextFieldBorder,
                                        labelColor: AppTheme.addNewTextFieldText,
                                        indicator: BoxDecoration(
                                            color: Color(0xFF42425E),
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                                        ),
                                        indicatorPadding: EdgeInsets.only(bottom: SizeConfig.height70,),
                                        indicatorSize: TabBarIndicatorSize.label,

                                        unselectedLabelStyle: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.addNewTextFieldBorder),

                                        tabs: [
                                          Tab(
                                            child: Text("Customer Information",
                                              style: TextStyle(fontFamily: 'RR',fontSize: 16,),textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Tab(
                                            child: Text("Other Information",
                                              style: TextStyle(fontFamily: 'RR',fontSize: 16),textAlign: TextAlign.center
                                            ),

                                          ),
                                        ]
                                    ),
                                  ),


                                  Container(
                                    height: (SizeConfig.screenHeight*0.8)-((SizeConfig.screenHeight*(420/1280))),
                                    width: SizeConfig.screenWidth-SizeConfig.width40,
                                    child: TabBarView(
                                        children: [
                                          Container(
                                            height: (SizeConfig.screenHeight*0.8)-((SizeConfig.screenHeight*(420/1280))),
                                            width: SizeConfig.screenWidth-SizeConfig.width40,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  DropDownField(

                                                    add: (){
                                                      setState(() {
                                                        qn.SS_selectCustomerId=null;
                                                        print("SS_selectCustomerId--${qn.SS_selectCustomerId}");
                                                        qn.customerContactNumber.clear();
                                                        qn.customerGstNumber.clear();
                                                        qn.customerEmail.clear();
                                                        qn.customerAddress.clear();
                                                        qn.customerCity.clear();
                                                        qn.customerState.clear();
                                                        qn.customerZipcode.clear();
                                                      });
                                                      }
                                                    ,
                                                    nodeFocus: (){
                                                      node.unfocus();
                                                    },
                                                    value: qn.SS_CustomerName,
                                                    controller: qn.customerName,
                                                    reduceWidth: SizeConfig.width80,

                                                    required: false,


                                                    hintText: 'Company/Customer Name',
                                                    textStyle: TextStyle(fontFamily: 'RR',fontSize: 20,color: AppTheme.addNewTextFieldText),
                                                    items: qn.customerNameList,
                                                    strict: false,
                                                    setter: (dynamic newValue) {
                                                    },
                                                    onValueChanged: (v){
                                                      node.unfocus();
                                                      setState(() {
                                                        qn.SS_CustomerName=v;
                                                        int index;
                                                        index=qn.customersList.indexWhere((element) => element.CustomerName.toLowerCase()==v.toString().toLowerCase()).toInt();

                                                        qn.SS_selectCustomerId=qn.customersList[index].CustomerId;
                                                        print("SS_selectCustomerId--${qn.SS_selectCustomerId}");
                                                        qn.customerContactNumber.text=qn.customersList[index].CustomerContactNumber;
                                                        qn.customerGstNumber.text=qn.customersList[index].CustomerGSTNumber;
                                                        qn.customerEmail.text=qn.customersList[index].CustomerEmail;
                                                        qn.customerAddress.text=qn.customersList[index].CustomerAddress;
                                                        qn.customerCity.text=qn.customersList[index].CustomerCity;
                                                        qn.customerState.text=qn.customersList[index].CustomerState;
                                                        qn.customerZipcode.text=qn.customersList[index].CustomerZipCode;


                                                      });
                                                    },
                                                  ),
                                                  AddNewLabelTextField(
                                                    labelText: 'Contact Number',
                                                    textEditingController: qn.customerContactNumber,
                                                    textInputType: TextInputType.number,

                                                  ),
                                                  AddNewLabelTextField(
                                                    labelText: 'GST No',
                                                    textEditingController: qn.customerGstNumber,
                                                    scrollPadding: 100,
                                                  ),
                                                  AddNewLabelTextField(
                                                    labelText: 'Email',
                                                    textEditingController: qn.customerEmail,
                                                    textInputType: TextInputType.emailAddress,
                                                    scrollPadding: 100,
                                                  ),
                                                  AddNewLabelTextField(
                                                    labelText: 'Address',
                                                    // maxLines: 2,
                                                    textEditingController: qn.customerAddress,
                                                    scrollPadding: 150,
                                                  ),
                                                  AddNewLabelTextField(
                                                    labelText: 'City',
                                                    textEditingController: qn.customerCity,
                                                    scrollPadding: 200,
                                                  ),
                                                  AddNewLabelTextField(
                                                    labelText: 'State',
                                                    textEditingController: qn.customerState,
                                                    scrollPadding: 200,
                                                  ),
                                                  AddNewLabelTextField(
                                                    labelText: 'ZipCode',
                                                    textEditingController: qn.customerZipcode,
                                                    textInputType: TextInputType.number,
                                                    scrollPadding: 250,

                                                  ),
                                                  SizedBox(height: SizeConfig.height50,)
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: (SizeConfig.screenHeight*0.8)-((SizeConfig.screenHeight*(420/1280))),
                                            width: SizeConfig.screenWidth-SizeConfig.width40,
                                            child: Column(
                                              children: [
                                                AddNewLabelTextField(
                                                  labelText: 'Driver Name',
                                                  textEditingController: qn.driverName,
                                                  scrollPadding: 100,
                                                ),
                                                AddNewLabelTextField(
                                                  labelText: 'Driver Contact No',
                                                  textEditingController: qn.driverContactNumber,
                                                  textInputType: TextInputType.number,
                                                  scrollPadding: 100,
                                                ),
                                              ],
                                            ),
                                          ),
                                    ]
                                    ),
                                  ),



                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        isCustomerDetaislOpen=false;
                                      });
                                      if(qn.SS_selectCustomerId==null){
                                        qn.InsertCustomerDetailDbhit(context);
                                      }else{
                                        qn.UpdateCustomerDetailDbhit(context);
                                      }


                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: SizeConfig.height20,bottom: SizeConfig.height30),
                                      height: SizeConfig.height50,
                                      width: SizeConfig.width100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppTheme.yellowColor
                                      ),
                                      child: Center(
                                        child: Text("Done",style: TextStyle(fontFamily: 'RR',fontSize: 20,color: AppTheme.bgColor,letterSpacing: 0.1),),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )

                          ),
                        )

                      ],
                    ),
                  ),


                ],
              ),
            ),
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
  SidePopUpParent({this.text,this.textColor,this.iconColor});
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
          border: Border.all(color: AppTheme.addNewTextFieldBorder)
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
