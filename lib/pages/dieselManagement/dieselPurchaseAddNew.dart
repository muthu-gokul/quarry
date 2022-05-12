
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/dieselNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/utils/widgetUtils.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/currentDateContainer.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/expectedDateContainer.dart';
import 'package:quarry/widgets/sidePopUp/noModel/sidePopUpSearchNoModel.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';
import 'package:quarry/widgets/singleDatePicker.dart';
import 'package:quarry/widgets/validationErrorText.dart';





class DieselPurchaseForm extends StatefulWidget {

  @override
  DieselPurchaseFormState createState() => DieselPurchaseFormState();
}

class DieselPurchaseFormState extends State<DieselPurchaseForm> with TickerProviderStateMixin{

  bool isEdit=false;

  bool isPlantOpen=false;
  bool isPurchaserOpen=false;
  bool isSupplierOpen=false;
  bool isVehicleOpen=false;


  var keyboardVisible=false.obs;
  bool plant=false;
  bool billNo=false;
  bool date=false;
  bool purchaser=false;
  bool supplier=false;
  bool vehicle=false;
  bool qty=false;
  bool price=false;

  TextEditingController vehicleSearchController = new TextEditingController();
  TextEditingController searchController=new TextEditingController();

  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance!.addPostFrameCallback((_){

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final node=FocusScope.of(context);
    keyboardVisible.value = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.bgColor,
      body: Consumer<DieselNotifier>(
          builder: (context,dn,child)=> Stack(
            children: [

              AddNewLayout(
                  child: ListView(
                    //controller: listViewController,
                    scrollDirection: Axis.vertical,
                   // physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),

                    children: [

                      CurrentDate(DateTime.now()),


                      GestureDetector(
                        onTap: (){

                          if(dn.plantCount!=1){
                            node.unfocus();
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
                      !plant?Container():ValidationErrorText(title: "* Select Plant"),

                      AddNewLabelTextField(
                        textEditingController: dn.DP_billno,
                        onChange: (v){},
                        labelText: "Bill Number",
                        regExp: '[A-Za-z0-9  ]',
                        ontap: (){

                        },
                        onEditComplete: (){
                          node.unfocus();
                        },

                      ),
                      !billNo?Container():ValidationErrorText(title: "* Enter Bill Number",),
                      GestureDetector(
                        onTap: () async{
                          final DateTime? picked = await showDatePicker2(
                              context: context,
                              initialDate:  dn.DP_billDate==null?DateTime.now():dn.DP_billDate!, // Refer step 1
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
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
                              dn.DP_billDate = picked;

                            });
                        },
                        child: ExpectedDateContainer(
                          //  text: DateFormat("yyyy-MM-dd").format(dn.DP_billDate)==DateFormat("yyyy-MM-dd").format(DateTime.now())?"Select Bill Date":"${DateFormat.yMMMd().format(dn.DP_billDate)}",
                          text:dn.DP_billDate==null?"Select Bill Date": "${DateFormat.yMMMd().format(dn.DP_billDate!)}",
                          textColor:AppTheme.addNewTextFieldText,
                          // textColor:DateFormat("yyyy-MM-dd").format(dn.DP_billDate)==DateFormat("yyyy-MM-dd").format(DateTime.now())? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                        ),
                      ),
                      !date?Container():ValidationErrorText(title: "* Select Bill Date"),
                      GestureDetector(
                        onTap: (){
                          node.unfocus();
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
                      !purchaser?Container():ValidationErrorText(title: "* Select Purchaser"),
                      GestureDetector(
                        onTap: (){


                          node.unfocus();
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
                      !supplier?Container():ValidationErrorText(title: "* Select Supplier"),

                      AddNewLabelTextField(
                        textEditingController: dn.DP_location,
                        labelText: "Location",
                        scrollPadding: 350,
                        onChange: (v){},
                        ontap: (){

                        },
                        onEditComplete: (){
                          node.unfocus();
                        },

                      ),
                      AddNewLabelTextField(
                        textEditingController: dn.DP_contactNo,
                        onChange: (v){},
                        labelText: "Contact Number",
                        regExp: '[0-9]',
                        textLength: phoneNoLength,
                        textInputType: TextInputType.number,
                        scrollPadding: 350,
                        ontap: (){},
                        onEditComplete: (){
                          node.unfocus();
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
                                  dn.DP_vehicleId=null;
                                  dn.DP_vehicleName=null;
                                  vehicle=false;;

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
                            height: dn.DP_isVehicle?50:0,
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
                      !vehicle?Container():ValidationErrorText(title: "* Select Vehicle",),

                      AddNewLabelTextField(
                        textEditingController: dn.DP_dieselQTY,
                        labelText: "Diesel Quantity",
                        regExp: decimalReg,
                        textInputType: TextInputType.number,
                        scrollPadding: 350,
                        ontap: (){},
                        onEditComplete: (){
                          node.unfocus();
                        },
                        onChange: (v){
                          dn.dieselCalc();
                        },
                        suffixIcon: Container(
                          height: 30,
                          width: 45,
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppTheme.yellowColor
                          ),
                          child: Center(
                            child: Text("Ltr",style: AppTheme.TSWhite166,),
                          ),
                        ),
                      ),
                      !qty?Container():ValidationErrorText(title: "* Enter Quantity",),
                      AddNewLabelTextField(
                        textEditingController: dn.DP_dieselPrice,
                        labelText: "Diesel Price",
                        regExp: decimalReg,
                        textInputType: TextInputType.number,
                        scrollPadding: 350,
                        ontap: (){},
                        onEditComplete: (){
                          node.unfocus();
                        },
                        onChange: (v){
                          dn.dieselCalc();
                        },

                      ),
                      !price?Container():ValidationErrorText(title: "* Enter Price",),

                      SizedBox(height: 20,),
                      Text("Total Amount",style: TextStyle(fontSize: 14,fontFamily: 'RR',color: AppTheme.hintColor),
                        textAlign: TextAlign.center,
                      ),
                      Text("${dn.totalAmount}",style: TextStyle(fontSize: 25,fontFamily: 'RB',color: AppTheme.addNewTextFieldText),
                        textAlign: TextAlign.center,
                      ),

                      Obx(()=>SizedBox(height: keyboardVisible.value?350: 120,))


                    ],
                  ),
                  actionWidget: Container(
                    height: 50,
                    width: SizeConfig.screenWidth,
                    child: Row(
                      children: [
                        CancelButton(
                          ontap: (){
                            Navigator.pop(context);
                            dn.clearDP_Form();
                          },
                        ),

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
                image: "assets/svg/gridHeader/DieselHeader.jpg",
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

              //add button
              Align(
                alignment: Alignment.bottomCenter,
                child: AddButton(
                  ontap: (){
                    node.unfocus();
                    if(dn.DP_PlantId==null){setState(() {plant=true;});}
                    else{setState(() {plant=false;});}

                    if(dn.DP_billno.text.isEmpty){setState(() {billNo=true;});}
                    else{setState(() {billNo=false;});}

                    if(dn.DP_billDate==null){setState(() {date=true;});}
                    else{setState(() {date=false;});}

                    if(dn.DP_purchaserId==null){setState(() {purchaser=true;});}
                    else{setState(() {purchaser=false;});}

                    if(dn.DP_supplierId==null){setState(() {supplier=true;});}
                    else{setState(() {supplier=false;});}

                    if(dn.DP_dieselQTY.text.isEmpty){setState(() {qty=true;});}
                    else{setState(() {qty=false;});}

                    if(dn.DP_dieselPrice.text.isEmpty){setState(() {price=true;});}
                    else{setState(() {price=false;});}


                    if(dn.DP_isVehicle){
                      if(dn.DP_vehicleId==null){setState(() {vehicle=true;});}
                      else{setState(() {vehicle=false;});}

                      if(!plant && !billNo && !date && !purchaser && !supplier && !qty && !price && !vehicle){
                        dn.InsertDieselPurchaseDbHit(context);
                      }
                    }
                    else{
                      if(!plant && !billNo && !date && !purchaser && !supplier && !qty && !price){
                        dn.InsertDieselPurchaseDbHit(context);
                      }
                    }








                  },
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

              PopUpStatic(
                title: "Select Plant",
                isOpen: isPlantOpen,
                dataList: dn.plantList,
                propertyKeyName:"PlantName",
                propertyKeyId: "PlantId",
                selectedId: dn.DP_PlantId,
                itemOnTap: (index){
                  setState(() {
                    dn.DP_PlantId=dn.plantList[index].plantId;
                    dn.DP_PlantName=dn.plantList[index].plantName;
                    isPlantOpen=false;
                  });
                },
                closeOnTap: (){
                  setState(() {
                    isPlantOpen=false;
                  });
                },
              ),



              ///////////////////////////////////////   Purchaser List    ////////////////////////////////

              PopUpSearchOnly2(
                isOpen: isPurchaserOpen,
                searchController: searchController,

                searchHintText:"Search Purchaser",

                dataList:dn.filterFuelPurchaserList,
                propertyKeyId:"EmployeeId",
                propertyKeyName: "EmployeeName",
                selectedId: dn.DP_purchaserId,

                searchOnchange: (v){
                  dn.searchFuelPurchaser(v);
                },
                itemOnTap: (index){
                  node.unfocus();
                  setState(() {


                    dn.DP_purchaserId=dn.filterFuelPurchaserList![index]['EmployeeId'];
                    dn.DP_purchaserName=dn.filterFuelPurchaserList![index]['EmployeeName'];
                    isPurchaserOpen=false;
                    dn.filterFuelPurchaserList=dn.fuelPurchaserList;

                  });
                  searchController.clear();
                },
                closeOnTap: (){
                  node.unfocus();
                  setState(() {
                    isPurchaserOpen=false;
                    dn.filterFuelPurchaserList=dn.fuelPurchaserList;
                  });
                  searchController.clear();
                },
              ),


              ///////////////////////////////////////   Supplier List    ////////////////////////////////

              PopUpSearchOnly2(
                isOpen: isSupplierOpen,
                searchController: searchController,

                searchHintText:"Search Supplier",

                dataList:dn.filterFuelSupplierList,
                propertyKeyId:"SupplierId",
                propertyKeyName: "SupplierName",
                selectedId: dn.DP_supplierId,

                searchOnchange: (v){
                  dn.searchFuelSupplier(v);
                },
                itemOnTap: (index){
                  node.unfocus();
                  setState(() {


                    dn.DP_supplierId=dn.filterFuelSupplierList![index]['SupplierId'];
                    dn.DP_supplierName=dn.filterFuelSupplierList![index]['SupplierName'];
                    isSupplierOpen=false;
                    dn.filterFuelSupplierList=dn.fuelSupplierList;

                  });
                  searchController.clear();
                },
                closeOnTap: (){
                  node.unfocus();
                  setState(() {
                    isSupplierOpen=false;
                    dn.filterFuelSupplierList=dn.fuelSupplierList;
                  });
                  searchController.clear();
                },
              ),


              ///////////////////////////////////////   Vehicle List    ////////////////////////////////



              PopUpSearchOnly2(
                isOpen: isVehicleOpen,
                searchController: vehicleSearchController,

                searchHintText:"Search Vehicle Number",

                dataList:dn.filterVehicleList,
                propertyKeyId: "VehicleId",
                propertyKeyName:  "VehicleNumber",
                selectedId: dn.DP_vehicleId,

                searchOnchange: (v){
                 dn.searchVehicle(v);
                },
                itemOnTap: (index){
                  node.unfocus();
                  setState(() {
                    dn.DP_vehicleId=dn.filterVehicleList![index]['VehicleId'];
                    dn.DP_vehicleName=dn.filterVehicleList![index]['VehicleNumber'];
                    isVehicleOpen=false;
                    dn.filterVehicleList=dn.vehicleList;
                  });
                  vehicleSearchController.clear();
                },
                closeOnTap: (){
                  node.unfocus();
                  setState(() {
                    isVehicleOpen=false;
                    dn.filterVehicleList=dn.vehicleList;

                  });
                  vehicleSearchController.clear();
                },
              ),


            ],
          )
      ),
    );
  }

}

