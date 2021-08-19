import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialListModel.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialTripModel.dart';
import 'package:quarry/model/goodsReceivedModel/goodsOutGateModel.dart';
import 'package:quarry/model/goodsReceivedModel/goodsReceivedGridModel.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/model/vehicelDetailsModel/vehicleTypeModel.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/goodsReceived/goodsMaterialsList.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';
import 'package:quarry/widgets/decimal.dart';

class GoodsReceivedNotifier extends ChangeNotifier{

  final call=ApiManager();

  List<ManageUserPlantModel> filterUsersPlantList=[];

  List<dynamic>? vehicleTypeList=[];
  List<dynamic>? filterVehicleTypeList=[];
  List<GoodsOutGateModel> outGateFormList=[];
  List<String?> outGateFormVehiclesList=[];

  List<dynamic>? supplierList=[];
  List<dynamic>? filterSupplierList=[];

  List<GoodsMaterialTripDetailsModel> materialTripList=[];

  GoodsDropDownValues(BuildContext context) async {
    updateGoodsLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.MasterdropDown}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "TypeName",
          "Type": "String",
          "Value": "Goods"
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).DataBaseName
        },
      ]
    };
    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!="null"){
          var parsed=json.decode(value);

          var t=parsed['Table'] as List?;
          var t1=parsed['Table1'] as List;
          var t2=parsed['Table2'] as List?;

          print("Dt1_$t1");



          vehicleTypeList=t;
          filterVehicleTypeList=t;

          outGateFormList=t1.map((e) => GoodsOutGateModel.fromJson(e)).toList();
          outGateFormVehiclesList.clear();
          outGateFormList.forEach((element) {
            outGateFormVehiclesList.add(element.vehicleNumber);
          });

          supplierList=t2;
          filterSupplierList=t2;


        }



        updateGoodsLoader(false);
      });
    }
    catch(e){
      updateGoodsLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }

  searchVehicleType(String v){
    if(v.isEmpty){
      filterVehicleTypeList=vehicleTypeList;
    }
    else{
      filterVehicleTypeList=vehicleTypeList!.where((element) => element['VehicleTypeName'].toString().toLowerCase().contains(v)).toList();
    }
    notifyListeners();
  }

  searchSupplier(String v){
    if(v.isEmpty){
      filterSupplierList=supplierList;
    }
    else{
      filterSupplierList=supplierList!.where((element) => element['SupplierName'].toString().toLowerCase().contains(v)).toList();
    }
    notifyListeners();
  }


   // Materials List
  String? ML_PorderNo=null;
  int? ML_PorderId=null;
  int? ML_GoodsorderId=null;
  String? ML_Date=null;
  String? ML_Status=null;
  bool? ML_isTax=false;
  int? ML_IsVehicleOutPending;
  List<GoodsReceivedMaterialListModel> ML_Materials=[];

  ML_clear(){
    ML_Date=null;
    ML_Materials.clear();
    ML_PorderNo=null;
    ML_PorderId=null;
    ML_GoodsorderId=null;
    ML_isTax=false;
    ML_Status=null;
    ML_IsVehicleOutPending=-1;
    IGF_Materials.clear();
    notifyListeners();
  }


  //InGateForm IGF
  TextEditingController vehicleNo=new TextEditingController();
  TextEditingController loadedWeight=new TextEditingController();
  int? IGF_vehicleTypeId;
  int? selectedVehicleTypeId=null;
  dynamic selectedVehicleTypeName=null;
  List<GoodsReceivedMaterialListModel> IGF_Materials=[];
  List<GoodsOtherChargesModel> IGf_OtherChargesList=[];


  IGF_clear(){
    vehicleNo.clear();
    loadedWeight.clear();
    IGF_vehicleTypeId=null;
    selectedVehicleTypeId=null;
    selectedVehicleTypeName=null;
    IGF_Materials.clear();
    IGf_OtherChargesList.clear();
    scanWeight="";
    notifyListeners();
  }




  InsertGoodsDbHit(BuildContext context,TickerProviderStateMixin tickerProviderStateMixin)  async{
    updateGoodsLoader(true);
    List js=[];
    js=IGF_Materials.map((e) => e.toJsonInWard(selectedVehicleTypeId,
        vehicleNo.text,
        double.parse(loadedWeight.text))
    ).toList();
    print("Insert-$js");
    print("ML_PorderId-$ML_PorderId");

    List os=[];
    os=IGf_OtherChargesList.map((e) => e.toJson()).toList();
    print("INSERT OS_$os");

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.insertGoodsReceivedDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },

        {
          "Key": "PurchaseOrderId",
          "Type": "int",
          "Value": ML_PorderId
        },
        {
          "Key": "IsTax",
          "Type": "int",
          "Value": ML_isTax!?1:0
        },
        {
          "Key": "Subtotal",
          "Type": "String",
          "Value": 0.0
        },
        {
          "Key": "DiscountAmount",
          "Type": "String",
          "Value": 0.0
        },
        {
          "Key": "DiscountedSubtotal",
          "Type": "String",
          "Value": 0.0
        },
        {
          "Key": "TaxAmount",
          "Type": "String",
          "Value": 0.0
        },
        {
          "Key": "GrandTotalAmount",
          "Type": "String",
          "Value": 0.0
        },
        {
          "Key": "GoodsReceivedMaterialMappingList",
          "Type": "datatable",
          "Value": js
        },
        {
          "Key": "GoodsReceivedOtherChargesMappingList",
          "Type": "datatable",
          "Value": os
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!="null"){
          var parsed=json.decode(value);
          print("INSERT SP_$parsed");
          var t=parsed['Table'] as List;
          ML_GoodsorderId=t[0]['GoodsReceivedId'];
         // GetGoodsDbHit(context, ML_GoodsorderId,ML_PorderId);
         GetGoodsDbHit(context, null,null,false,tickerProviderStateMixin);
          Navigator.pop(context);
          IGF_clear();
          print(GoodsMaterialsListState().mounted);
        //
        }
        else{
          updateGoodsLoader(false);
        }


      });
    }catch(e){
      updateGoodsLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertGoodsReceivedDetail}" , e.toString());
    }


  }




  /*Out Gate Form*/
  String? OGF_vehicleNumber=null;
  int? OGF_index=null;
  TextEditingController OGF_emptyWeightofVehicle=new TextEditingController();
  TextEditingController OGF_vehicleNumberController=new TextEditingController();
  String? OGF_UnitName=null;
  double? OGF_ExpectedQty;
  double? OGF_ReceivedQty;
  double? OGF_showReceivedQty;
  double? OGF_dbReceivedQty;
  double? OGF_BalanceQty;
  double? OGF_InwardLoadedVehicleWeight;
  double? OGF_OutwardEmptyVehicleWeight;
  double? OGF_amount;

  double? OGF_discountAmount;
  double? OGF_taxAmount;
  double? OGF_TotalAmount;
  double? OGF_discountedSubTotal;
  bool OGF_isTax=false;
  String scanWeight="";
  clearOGFform(){
     OGF_vehicleNumber=null;
     OGF_index=null;
     OGF_emptyWeightofVehicle.clear();
     OGF_vehicleNumberController.clear();
     OGF_UnitName=null;
     OGF_ExpectedQty=0.0;
     OGF_ReceivedQty=0.0;
     OGF_showReceivedQty=0.0;
     OGF_dbReceivedQty=0.0;
     OGF_BalanceQty=0.0;
     OGF_InwardLoadedVehicleWeight=0.0;
     OGF_OutwardEmptyVehicleWeight=0.0;

     OGF_amount=0.0;
     OGF_discountAmount=0.0;
     OGF_taxAmount=0.0;
     OGF_TotalAmount=0.0;
     OGF_discountedSubTotal=0.0;
     OGF_isTax=false;
     scanWeight="";
     notifyListeners();
  }

  UpdateGoodsDbHit(BuildContext context,List? insertMappingList,TickerProviderStateMixin tickerProviderStateMixin)  async{
    updateGoodsLoader(true);
    List js=[];
    if(insertMappingList==null){
      var ma={
        "GoodsReceivedMaterialMappingId":outGateFormList[OGF_index!].GoodsReceivedMaterialMappingId,
        "GoodsReceivedId":  outGateFormList[OGF_index!].goodsReceivedId,
        "MaterialId":  outGateFormList[OGF_index!].materialId,
        "MaterialPrice":  outGateFormList[OGF_index!].materialPrice,
        "ExpectedQuantity":  outGateFormList[OGF_index!].expectedQuantity,
        "ReceivedQuantity": OGF_dbReceivedQty,
        "BalanceQuantity": OGF_BalanceQty!>0?OGF_BalanceQty:0.0,
        "Amount":  OGF_amount,
        "VehicleTypeId":  outGateFormList[OGF_index!].vehicleTypeId,
        "VehicleNumber": OGF_vehicleNumber,
        "InwardLoadedVehicleWeight":  outGateFormList[OGF_index!].inwardLoadedVehicleWeight,
        "OutwardEmptyVehicleWeight": double.parse(OGF_emptyWeightofVehicle.text),
        "IsDiscount":  outGateFormList[OGF_index!].isDiscount,
        "IsPercentage":  outGateFormList[OGF_index!].isPercentage,
        "IsAmount":  outGateFormList[OGF_index!].isAmount,
        "DiscountValue":  outGateFormList[OGF_index!].discountValue,
        "DiscountAmount":  OGF_discountAmount,
        "TaxValue":  outGateFormList[OGF_index!].taxValue,
        "TaxAmount":  OGF_taxAmount,
        "TotalAmount":  OGF_TotalAmount,
        "IsActive":1,
      };

      js.add(ma);
      print("Update_$js");
    }


    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.updateGoodsReceivedDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },

        {
          "Key": "IsVehicleIn",
          "Type": "int",
          "Value": insertMappingList==null?0:1
        },
        {
          "Key": "GoodsReceivedId",
          "Type": "int",
          "Value": insertMappingList==null?outGateFormList[OGF_index!].goodsReceivedId:ML_GoodsorderId
        },
        {
          "Key": "Subtotal",
          "Type": "String",
          "Value": 0.0
        },
        {
          "Key": "DiscountAmount",
          "Type": "String",
          "Value": 0.0
        },
        {
          "Key": "DiscountedSubtotal",
          "Type": "String",
          "Value": 0.0
        },
        {
          "Key": "TaxAmount",
          "Type": "String",
          "Value": 0.0
        },
        {
          "Key": "GrandTotalAmount",
          "Type": "String",
          "Value": 0.0
        },
        {
          "Key": "GoodsReceivedMaterialMappingId",
          "Type": "int",
          "Value": insertMappingList==null?outGateFormList[OGF_index!].GoodsReceivedMaterialMappingId:null
        },
        {
          "Key": "GoodsReceivedMaterialMappingList",
          "Type": "datatable",
          "Value": insertMappingList==null?js:insertMappingList
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!="null"){
          var parsed=json.decode(value);
          GetGoodsDbHit(context, null,null,false,tickerProviderStateMixin);
          Navigator.pop(context);
          clearOGFform();
          IGF_clear();


        }
        else{
          updateGoodsLoader(false);
        }


      });
    }catch(e){
      updateGoodsLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertGoodsReceivedDetail}" , e.toString());
    }


  }
  calc(){
    OGF_showReceivedQty=0.0;
    OGF_dbReceivedQty=0.0;
    OGF_BalanceQty=0.0;
    OGF_amount=0.0;
    OGF_taxAmount=0.0;
    OGF_TotalAmount=0.0;
    OGF_discountAmount=0.0;

    if(OGF_emptyWeightofVehicle.text.isNotEmpty){


      print(OGF_ExpectedQty);
      print(OGF_ReceivedQty);
      print(OGF_InwardLoadedVehicleWeight);
      print(OGF_emptyWeightofVehicle.text);
      print(outGateFormList[OGF_index!].taxAmount);

      OGF_showReceivedQty=double.parse((Decimal.parse(OGF_InwardLoadedVehicleWeight.toString())-Decimal.parse(OGF_emptyWeightofVehicle.text) + Decimal.parse(OGF_ReceivedQty.toString())).toString());
      OGF_dbReceivedQty=double.parse((Decimal.parse(OGF_InwardLoadedVehicleWeight.toString())-Decimal.parse(OGF_emptyWeightofVehicle.text)).toString());



      OGF_BalanceQty=double.parse((Decimal.parse(OGF_ExpectedQty.toString())- Decimal.parse(OGF_showReceivedQty.toString()) ).toString());


      if( outGateFormList[OGF_index!].isDiscount==0){

        OGF_amount=Calculation().mul(OGF_dbReceivedQty, outGateFormList[OGF_index!].materialPrice);
        if(outGateFormList[OGF_index!].IsTax!){
          OGF_taxAmount=Calculation().taxAmount(taxValue:outGateFormList[OGF_index!].taxValue, amount: OGF_amount, discountAmount: 0.0 );
        }
        else{
          OGF_taxAmount=0.0;
        }
        OGF_TotalAmount=Calculation().totalAmount(amount:OGF_amount, taxAmount: OGF_taxAmount, discountAmount: 0.0);


      }
      else if(outGateFormList[OGF_index!].isDiscount==1){

        if(outGateFormList[OGF_index!].isPercentage==1){

          OGF_amount=Calculation().mul(OGF_dbReceivedQty, outGateFormList[OGF_index!].materialPrice);
          OGF_discountAmount=Calculation().discountAmount(discountValue: outGateFormList[OGF_index!].discountValue, amount:  OGF_amount);
          if(outGateFormList[OGF_index!].IsTax!){
            OGF_taxAmount=Calculation().taxAmount(taxValue:outGateFormList[OGF_index!].taxValue, amount: OGF_amount, discountAmount: OGF_discountAmount );
          }
          else{
            OGF_taxAmount=0.0;
          }
          OGF_TotalAmount=Calculation().totalAmount(amount: OGF_amount, taxAmount: OGF_taxAmount, discountAmount:  OGF_discountAmount);




        }
        else if(outGateFormList[OGF_index!].isAmount==1){
          OGF_amount=Calculation().mul(OGF_dbReceivedQty, outGateFormList[OGF_index!].materialPrice);
          OGF_discountAmount=double.parse((Decimal.parse(outGateFormList[OGF_index!].discountValue.toString())).toString());
          if(outGateFormList[OGF_index!].IsTax!){
            OGF_taxAmount=Calculation().taxAmount(taxValue:outGateFormList[OGF_index!].taxValue, amount: OGF_amount, discountAmount: OGF_discountAmount );
          }
          else{
            OGF_taxAmount=0.0;
          }
          OGF_TotalAmount=Calculation().totalAmount(amount: OGF_amount, taxAmount: OGF_taxAmount, discountAmount:  OGF_discountAmount);


        }

      }


    }
    else{
      OGF_showReceivedQty=0.0;
      OGF_BalanceQty=0.0;
      OGF_dbReceivedQty=0.0;
      OGF_amount=0.0;
      OGF_taxAmount=0.0;
      OGF_TotalAmount=0.0;
      OGF_discountAmount=0.0;
    }

   notifyListeners();
  }


  // ToInvoice List (GINV)-Goods Invoice
  String? GINV_PorderNo=null;
  int? GINV_PorderId=null;
  int? GINV_PlantId=null;
  int? GINV_SupplierId=null;
  int? GINV_GoodsorderId=null;
  String? GINV_Date=null;
  double GINV_invoiceAmount=0.0;
  bool? GINV_IsTax=false;
  List<GoodsReceivedMaterialListModel> GINV_Materials=[];
  List<GoodsOtherChargesModel> GINV_OtherChargesList=[];

  updateDriverCharge(int index,double otherChargeAmount){
    GINV_OtherChargesList[index].otherChargesAmount=otherChargeAmount;
    calcToInvoice();
    notifyListeners();
  }

  updateDriverIsEdit(int index,bool value){
    GINV_OtherChargesList[index].isEdit=value;
    notifyListeners();
  }

  GINV_clear(){
    GINV_Date=null;
    GINV_Materials.clear();
    GINV_PorderNo=null;
    GINV_PorderId=null;
    GINV_GoodsorderId=null;
    GINV_IsTax=false;
    GINV_invoiceAmount=0.0;
    GINV_Materials.clear();
    GINV_OtherChargesList.clear();
    notifyListeners();
  }

  // ToPurchase List (GPO)-Goods To Purchase
  String? GPO_PorderNo=null;
  int? GPO_PorderId=null;
  int? GPO_GoodsorderId=null;
  int? GPO_PlantId=null;
  int? GPO_SupplierId=null;
  String? GPO_SupplierType=null;
  String? GPO_Date=null;
  double GPO_purchaseAmount=0.0;
  bool? GPO_IsTax=false;
  List<GoodsReceivedMaterialListModel> GPO_Materials=[];

  GPO_clear(){
    GPO_Date=null;
    GPO_Materials.clear();
    GPO_PorderNo=null;
    GPO_PorderId=null;
    GPO_GoodsorderId=null;
    GPO_purchaseAmount=0.0;
    GPO_IsTax=false;
    notifyListeners();
  }

  Future<dynamic> GPO_assignValues() async{
    GPO_Date=GINV_Date;
    GPO_PorderNo=GINV_PorderNo;
    GPO_PorderId=GINV_PorderId;
    GPO_GoodsorderId=GINV_GoodsorderId;
    GPO_PlantId=GINV_PlantId;
    GPO_IsTax=GINV_IsTax;
    GPO_SupplierId=null;
    GPO_SupplierType=null;
    double balanceQuantity=0.0;
    double amount=0.0;
    double? discountAmount=0.0;
    double taxAmount=0.0;
    double totalAmount=0.0;

    print(GINV_Materials.length);
    GINV_Materials.forEach((element) {
      if(element.status!='Completed'){
        balanceQuantity=Calculation().sub(element.quantity, element.receivedQuantity);
        amount=Calculation().mul(balanceQuantity, element.materialPrice);

        if(element.isDiscount==1){
          if(element.isPercentage==1){
            discountAmount=Calculation().discountAmount(discountValue: element.discountValue,amount:amount );
          }else if(element.isAmount==1){
            discountAmount=element.discountValue;
          }
        }else{
          discountAmount=0.0;
        }
        if(GINV_IsTax!){
          taxAmount=Calculation().taxAmount(taxValue: element.taxValue,discountAmount: discountAmount,amount: amount);
        }else{
          taxAmount=0.0;
        }

        totalAmount=Calculation().totalAmount(amount: amount,discountAmount: discountAmount,taxAmount: taxAmount);

        GPO_Materials.add(GoodsReceivedMaterialListModel(
            materialId:element.materialId,
          materialName: element.materialName,
          unitName: element.unitName,
          materialPrice:element.materialPrice,
          quantity:balanceQuantity,
          amount: amount,
          isDiscount: element.isDiscount,
          isPercentage: element.isPercentage,
          isAmount: element.isAmount,
          discountValue: element.discountValue,
          discountAmount: discountAmount,
          taxValue: element.taxValue,
          taxAmount: taxAmount,
          totalAmount: totalAmount

        ));
        GPO_purchaseAmount=Calculation().add(GPO_purchaseAmount, totalAmount);
      }
    });

 
    print(GPO_Materials.map((e) => e.toPurchaseJson()));

    notifyListeners();
  }


  List<DateTime?> picked=[];


  List<GoodsReceivedGridModel> goodsGridList=[];
  List<GoodsReceivedGridModel> goodsAllGridList=[];
  List<GoodsReceivedGridModel> filterGoodsGridList=[];
  List<GoodsReceivedGridModel> filterGoodsAllGridList=[];

  List<GoodsMaterialExtraTripModel> GoodsMaterialExtraTripModelDetails=[];

  GetGoodsDbHit(BuildContext context,int? goodsReceivedId,int? purchaseOrderId,bool ToInvoice,TickerProviderStateMixin tickerProviderStateMixin)  async{

    print("GREC__${goodsReceivedId} ${purchaseOrderId} ${goodsReceivedId==0?null:goodsReceivedId}");
    updateGoodsLoader(true);
    String? fromDate,toDate;

    if(picked.isEmpty){
      fromDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      toDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    }
    else if(picked.length==1){
      fromDate=DateFormat("yyyy-MM-dd").format(picked[0]!).toString();
      toDate=DateFormat("yyyy-MM-dd").format(picked[0]!).toString();
    }
    else if(picked.length==2){
      fromDate=DateFormat("yyyy-MM-dd").format(picked[0]!).toString();
      toDate=DateFormat("yyyy-MM-dd").format(picked[1]!).toString();
    }
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getGoodsReceivedDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "GoodsReceivedId",
          "Type": "int",
          "Value": goodsReceivedId==0?null:goodsReceivedId
        },
        {
          "Key": "PurchaseOrderId",
          "Type": "int",
          "Value": purchaseOrderId
        },
        {
          "Key": "FromDate",
          "Type": "String",
          "Value": fromDate
        },
        {
          "Key": "ToDate",
          "Type": "String",
          "Value":toDate
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).DataBaseName
        }
      ]
    };

    try{

      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!="null"){

         // log(value);
          var parsed=json.decode(value);
          var t=parsed['Table'] as List?;
          if(goodsReceivedId!=null || purchaseOrderId!=null){
            if(filterUsersPlantList.isEmpty){

              Provider.of<ProfileNotifier>(context, listen: false).usersPlantList.forEach((element) {
                filterUsersPlantList.add(ManageUserPlantModel(
                  plantId: element.plantId,
                  plantName: element.plantName,
                  isActive: element.isActive,
                ));
              });

            }
            else if(filterUsersPlantList.length!=Provider.of<ProfileNotifier>(context, listen: false).usersPlantList.length){
              filterUsersPlantList.clear();

              Provider.of<ProfileNotifier>(context, listen: false).usersPlantList.forEach((element) {
                filterUsersPlantList.add(ManageUserPlantModel(
                  plantId: element.plantId,
                  plantName: element.plantName,
                  isActive: element.isActive,

                ));
              });
            }

            if(ToInvoice){
              GINV_PorderNo=t![0]['PurchaseOrderNumber'];
              GINV_PorderId=t[0]['PurchaseOrderId'];
              GINV_GoodsorderId=t[0]['GoodsReceivedId'];
              GINV_PlantId=t[0]['PlantId'];
              GINV_SupplierId=t[0]['SupplierId'];
              GINV_Date=t[0]['Date'];
              GINV_IsTax=t[0]['IsTax'];
              print("GINV_IsTax$GINV_IsTax");
              var t1=parsed['Table1'] as List;
              var t4=parsed['Table4'] as List;
              print(t1);
              print(parsed['Table2'] as List?);
              print(parsed['Table3'] as List?);
              print(t4);

              GINV_Materials=t1.map((e) => GoodsReceivedMaterialListModel.fromJson(e)).toList();
              print(GINV_Materials.length);
              GINV_Materials.forEach((element) {
                if(element.status=='Completed' || element.status=='Partially Received'){
               //   GINV_invoiceAmount=GINV_invoiceAmount+element.totalAmount;
                  GINV_invoiceAmount=Calculation().add(GINV_invoiceAmount, element.totalAmount);
                }
              });
              GINV_OtherChargesList=t4.map((e) => GoodsOtherChargesModel.fromJson(e,tickerProviderStateMixin)).toList();
              double otherCharges=0.0;
              GINV_OtherChargesList.forEach((element) {
                otherCharges=Calculation().add(otherCharges, element.otherChargesAmount);
              });
              GINV_invoiceAmount=Calculation().add(GINV_invoiceAmount, otherCharges);
              print(GINV_invoiceAmount);
            }
            else{
              print("GOODSt_$t");

              ML_PorderNo=t![0]['PurchaseOrderNumber'];
              ML_PorderId=t[0]['PurchaseOrderId'];
              ML_GoodsorderId=t[0]['GoodsReceivedId'];
              ML_Date=t[0]['Date'];
              ML_isTax=t[0]['IsTax'];
              ML_IsVehicleOutPending=t[0]['IsVehicleOutPending'];
              ML_Status=t[0]['Status'];
              print("ML_PorderId $ML_PorderId");
              var t1=parsed['Table1'] as List;
              print("t1_$t1");
              ML_Materials=t1.map((e) => GoodsReceivedMaterialListModel.fromJson(e)).toList();

              var t2=parsed['Table2'] as List;
              print("t2_$t2");
              materialTripList=t2.map((e) => GoodsMaterialTripDetailsModel.fromJson(e)).toList();

              var t3=parsed['Table3'] as List;
              GoodsMaterialExtraTripModelDetails =t3.map((e) => GoodsMaterialExtraTripModel.fromJson(e)).toList();
              print("t3_$t3");
              var t4=parsed['Table4'] as List;
              IGf_OtherChargesList =t4.map((e) => GoodsOtherChargesModel.fromJson(e,tickerProviderStateMixin)).toList();
              print("t4_$t4");


            }

            notifyListeners();
          }
          else{
            print(t);
            var t1=parsed['Table1'] as List;
            print("t1_$t1");
            filterGoodsGridList=t!.map((e) => GoodsReceivedGridModel.fromJson(e,tickerProviderStateMixin)).toList();
            filterGoodsAllGridList=t1.map((e) => GoodsReceivedGridModel.fromJson(e,tickerProviderStateMixin)).toList();
            filterGoodsGrid();
           // filtergoodsGridList=List.from(goodsGridList);
          }
        }

        updateGoodsLoader(false);
      });
    }catch(e,t){
      updateGoodsLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getGoodsReceivedDetail}" , t.toString());
    }
  }

  filterGoodsGrid(){
    goodsGridList.clear();
    goodsAllGridList.clear();
    filterUsersPlantList.forEach((element) {

      if(element.isActive!){
        goodsGridList=goodsGridList+filterGoodsGridList.where((ele) => ele.plantId==element.plantId).toList();
        goodsAllGridList=goodsAllGridList+filterGoodsAllGridList.where((ele) => ele.plantId==element.plantId).toList();
      }
    });
    goodsGridList.sort((a,b)=>a.purchaseOrderId!.compareTo(b.purchaseOrderId!));
    goodsAllGridList.sort((a,b)=>a.goodsReceivedId!.compareTo(b.goodsReceivedId!));
    notifyListeners();
  }


  calcToInvoice(){
    double otherCharges=0.0;
    GINV_invoiceAmount=0.0;
    GINV_Materials.forEach((element) {
      if(element.status=='Completed' || element.status=='Partially Received'){
        //   GINV_invoiceAmount=GINV_invoiceAmount+element.totalAmount;
        GINV_invoiceAmount=Calculation().add(GINV_invoiceAmount, element.totalAmount);
      }
    });
    GINV_OtherChargesList.forEach((element) {
      otherCharges=Calculation().add(otherCharges, element.otherChargesAmount);
    });
    GINV_invoiceAmount=Calculation().add(GINV_invoiceAmount, otherCharges);
    notifyListeners();
  }

 //To invoice Sp
 Future<dynamic>  InsertInvoiceDbHit(BuildContext context,TickerProviderStateMixin tickerProviderStateMixin)  async{
    updateGoodsLoader(true);
    List js=[];
    GINV_Materials.forEach((element) {
      if(element.status!='Not Yet'){
        js.add(element.toInvoiceJson());
      }
    });
    //   js=gr.GINV_Materials.map((e) => e.toInvoiceJson()).toList();
    print(js);
    List oa=[];
    oa=GINV_OtherChargesList.map((e) => e.toInvoiceJson()).toList();
    print(oa);

    double subtotal=0.0;
    double discountAmount=0.0;
    double discountedSubtotal=0.0;
    double taxAmount=0.0;
    double grandTotal=0.0;
    double otherCharges=0.0;

    js.forEach((element) {
      subtotal=Calculation().add(subtotal, element['Subtotal']);
      discountAmount=Calculation().add(discountAmount, element['DiscountAmount']);
      discountedSubtotal=Calculation().sub(subtotal, discountAmount);
    //  if(GINV_IsTax){
        taxAmount=Calculation().add(taxAmount, element['TaxAmount']);
    //  }


      grandTotal=Calculation().add(grandTotal, element['TotalAmount']);
    });

    oa.forEach((element) {
      otherCharges=Calculation().add(otherCharges, element['OtherChargesAmount']);
    });

    grandTotal=Calculation().add(grandTotal, otherCharges);
    print(subtotal);
    print(discountAmount);
    print(discountedSubtotal);
    print(taxAmount);
    print(grandTotal);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.insertInvoiceDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },


        {
          "Key": "PurchaseOrderId",
          "Type": "int",
          "Value": GINV_PorderId
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": GINV_PlantId
        },

        {
          "Key": "InvoiceType",
          "Type": "String",
          "Value": "Payable"
        },
        {
          "Key": "InvoiceDate",
          "Type": "String",
          "Value": DateFormat("yyyy-MM-dd").format(DateTime.now())
        },
        {
          "Key": "ExpectedDate",
          "Type": "String",
          "Value":null
        },
        {
          "Key": "Notes",
          "Type": "String",
          "Value": null
        },
        {
          "Key": "TermsandConditions",
          "Type": "String",
          "Value": null
        },
        {
          "Key": "PartyId",
          "Type": "int",
          "Value": GINV_SupplierId
        },
        {
          "Key": "IsTax",
          "Type": "int",
          "Value": GINV_IsTax!?1:0
        },
        {
          "Key": "Subtotal",
          "Type": "String",
          "Value": subtotal
        },
        {
          "Key": "DiscountAmount",
          "Type": "String",
          "Value": discountAmount
        },
        {
          "Key": "DiscountedSubtotal",
          "Type": "String",
          "Value": discountedSubtotal
        },
        {
          "Key": "TaxAmount",
          "Type": "String",
          "Value": taxAmount
        },
        {
          "Key": "GrandTotalAmount",
          "Type": "String",
          "Value": grandTotal
        },

        {
          "Key": "InvoiceMaterialMappingList",
          "Type": "datatable",
          "Value": js
        },
        {
          "Key": "InvoiceOtherChargesMappingList",
          "Type": "datatable",
          "Value": oa
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!=null){
       //   GetGoodsDbHit(context, null, null, false, tickerProviderStateMixin);
        }

        updateGoodsLoader(false);
      });
    }catch(e){
      updateGoodsLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertInvoiceDetail}" , e.toString());
    }


  }

// To purchase Sp
 Future<dynamic> InsertPurchaseDbHit(BuildContext context,TickerProviderStateMixin tickerProviderStateMixin)  async{
    updateGoodsLoader(true);
    List js=[];
    js=GPO_Materials.map((e) => e.toPurchaseJson()).toList();
    print(js);
    List oa=[];
    print(oa);
    double subtotal=0.0;
    double discountAmount=0.0;
    double discountedSubtotal=0.0;
    double taxAmount=0.0;
    double grandTotal=0.0;

    js.forEach((element) {
      subtotal=Calculation().add(subtotal, element['Amount']);
      discountAmount=Calculation().add(discountAmount, element['DiscountAmount']);
      discountedSubtotal=Calculation().sub(subtotal, discountAmount);
      taxAmount=Calculation().add(taxAmount, element['TaxAmount']);
      grandTotal=Calculation().add(grandTotal, element['TotalAmount']);
    });
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.insertPurchaseDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": GPO_PlantId
        },
        {
          "Key": "ExpectedDate",
          "Type": "String",
          "Value": DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 2)))
        },
        {
          "Key": "SupplierType",
          "Type": "String",
          "Value": GPO_SupplierType
        },
        {
          "Key": "Supplier",
          "Type": "int",
          "Value": GPO_SupplierId
        },
        {
          "Key": "IsTax",
          "Type": "int",
          "Value": GPO_IsTax!?1:0
        },
        {
          "Key": "Subtotal",
          "Type": "String",
          "Value": subtotal
        },
        {
          "Key": "DiscountAmount",
          "Type": "String",
          "Value": discountAmount
        },
        {
          "Key": "DiscountedSubtotal",
          "Type": "String",
          "Value": discountedSubtotal
        },
        {
          "Key": "TaxAmount",
          "Type": "String",
          "Value": taxAmount
        },
        {
          "Key": "GrandTotalAmount",
          "Type": "String",
          "Value": grandTotal
        },

        {
          "Key": "PurchaseOrderMaterialMappingList",
          "Type": "datatable",
          "Value": js
        },
        {
          "Key": "PurchaseOrderOtherChargesMappingList",
          "Type": "datatable",
          "Value": oa
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!=null){
          var parsed=json.decode(value);


          GetGoodsDbHit(context, null,null,false,tickerProviderStateMixin);
        }

        updateGoodsLoader(false);
      });
    }catch(e){
      updateGoodsLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertPurchaseDetail}" , e.toString());
    }


  }

  bool isGoodsEdit=false;
  updateGoodsEdit(bool value){
    isGoodsEdit=value;
    notifyListeners();
  }

  bool GoodsLoader=false;
  updateGoodsLoader(bool value){
    GoodsLoader=value;
    notifyListeners();
  }
}