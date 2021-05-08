import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialListModel.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialTripModel.dart';
import 'package:quarry/model/goodsReceivedModel/goodsOutGateModel.dart';
import 'package:quarry/model/goodsReceivedModel/goodsReceivedGridModel.dart';
import 'package:quarry/model/vehicelDetailsModel/vehicleTypeModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/goodsReceived/goodsMaterialsList.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';
import 'package:quarry/widgets/decimal.dart';

class GoodsReceivedNotifier extends ChangeNotifier{

  final call=ApiManager();



  List<VehicleTypeModel> vehicleTypeList=[];
  List<GoodsOutGateModel> outGateFormList=[];
  List<String> outGateFormVehiclesList=[];

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
        if(value!=null){
          var parsed=json.decode(value);

          var t=parsed['Table'] as List;
          var t1=parsed['Table1'] as List;

          print(parsed);



          vehicleTypeList=t.map((e) => VehicleTypeModel.fromJson(e)).toList();
          print(vehicleTypeList.length);
          outGateFormList=t1.map((e) => GoodsOutGateModel.fromJson(e)).toList();
          outGateFormVehiclesList.clear();
          outGateFormList.forEach((element) {
            outGateFormVehiclesList.add(element.vehicleNumber);
          });


        }



        updateGoodsLoader(false);
      });
    }
    catch(e){
      updateGoodsLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }



   // Materials List
  String ML_PorderNo=null;
  int ML_PorderId=null;
  int ML_GoodsorderId=null;
  String ML_Date=null;
  List<GoodsReceivedMaterialListModel> ML_Materials=[];

  ML_clear(){
    ML_Date=null;
    ML_Materials.clear();
    ML_PorderNo=null;
    ML_PorderId=null;
    ML_GoodsorderId=null;
    IGF_Materials.clear();
  }


  //InGateForm IGF
  TextEditingController vehicleNo=new TextEditingController();
  TextEditingController loadedWeight=new TextEditingController();
  int IGF_vehicleTypeId;
  int selectedVehicleTypeId=null;
  var selectedVehicleTypeName=null;
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

        if(value!=null){
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

        updateGoodsLoader(false);
      });
    }catch(e){
      updateGoodsLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertGoodsReceivedDetail}" , e.toString());
    }


  }




  /*Out Gate Form*/
  String OGF_vehicleNumber=null;
  int OGF_index=null;
  TextEditingController OGF_emptyWeightofVehicle=new TextEditingController();
  TextEditingController OGF_vehicleNumberController=new TextEditingController();
  String OGF_UnitName=null;
  double OGF_ExpectedQty;
  double OGF_ReceivedQty;
  double OGF_showReceivedQty;
  double OGF_dbReceivedQty;
  double OGF_BalanceQty;
  double OGF_InwardLoadedVehicleWeight;
  double OGF_OutwardEmptyVehicleWeight;
  double OGF_amount;

  double OGF_discountAmount;
  double OGF_taxAmount;
  double OGF_TotalAmount;
  double OGF_discountedSubTotal;

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
  }

  UpdateGoodsDbHit(BuildContext context,List insertMappingList,TickerProviderStateMixin tickerProviderStateMixin)  async{
    updateGoodsLoader(true);
    List js=[];
    if(insertMappingList==null){
      var ma={
        "GoodsReceivedMaterialMappingId":outGateFormList[OGF_index].GoodsReceivedMaterialMappingId,
        "GoodsReceivedId":  outGateFormList[OGF_index].goodsReceivedId,
        "MaterialId":  outGateFormList[OGF_index].materialId,
        "MaterialPrice":  outGateFormList[OGF_index].materialPrice,
        "ExpectedQuantity":  outGateFormList[OGF_index].expectedQuantity,
        "ReceivedQuantity": OGF_dbReceivedQty,
        "Amount":  OGF_amount,
        "VehicleTypeId":  outGateFormList[OGF_index].vehicleTypeId,
        "VehicleNumber": OGF_vehicleNumber,
        "InwardLoadedVehicleWeight":  outGateFormList[OGF_index].inwardLoadedVehicleWeight,
        "OutwardEmptyVehicleWeight": double.parse(OGF_emptyWeightofVehicle.text),
        "IsDiscount":  outGateFormList[OGF_index].isDiscount,
        "IsPercentage":  outGateFormList[OGF_index].isPercentage,
        "IsAmount":  outGateFormList[OGF_index].isAmount,
        "DiscountValue":  outGateFormList[OGF_index].discountValue,
        "DiscountAmount":  OGF_discountAmount,
        "TaxValue":  outGateFormList[OGF_index].taxValue,
        "TaxAmount":  OGF_taxAmount,
        "TotalAmount":  OGF_TotalAmount,
        "IsActive":1,


      };

      js.add(ma);
      print(js);
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
          "Value": insertMappingList==null?outGateFormList[OGF_index].goodsReceivedId:ML_GoodsorderId
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
          "Value": insertMappingList==null?outGateFormList[OGF_index].GoodsReceivedMaterialMappingId:null
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

        if(value!=null){
          var parsed=json.decode(value);
          GetGoodsDbHit(context, null,null,false,tickerProviderStateMixin);
          Navigator.pop(context);
          clearOGFform();
          IGF_clear();


        }

        updateGoodsLoader(false);
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

      OGF_showReceivedQty=double.parse((Decimal.parse(OGF_InwardLoadedVehicleWeight.toString())-Decimal.parse(OGF_emptyWeightofVehicle.text) + Decimal.parse(OGF_ReceivedQty.toString())).toString());
      OGF_dbReceivedQty=double.parse((Decimal.parse(OGF_InwardLoadedVehicleWeight.toString())-Decimal.parse(OGF_emptyWeightofVehicle.text)).toString());



      OGF_BalanceQty=double.parse((Decimal.parse(OGF_ExpectedQty.toString())- Decimal.parse(OGF_showReceivedQty.toString()) ).toString());


      if( outGateFormList[OGF_index].isDiscount==0){

        OGF_amount=Calculation().mul(OGF_showReceivedQty, outGateFormList[OGF_index].materialPrice);
        OGF_taxAmount=Calculation().taxAmount(taxValue:outGateFormList[OGF_index].taxValue, amount: OGF_amount, discountAmount: 0.0 );
        OGF_TotalAmount=Calculation().totalAmount(amount:OGF_amount, taxAmount: OGF_taxAmount, discountAmount: 0.0);

     //   purchaseOrdersMappingList[index].Amount=double.parse((Decimal.parse(purchaseQty)*Decimal.parse(purchaseOrdersMappingList[index].MaterialPrice.toString())).toString());
     //   purchaseOrdersMappingList[index].TaxAmount=double.parse(((Decimal.parse(purchaseOrdersMappingList[index].TaxValue.toString())*(Decimal.parse(purchaseOrdersMappingList[index].Amount.toString())-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())))/Decimal.parse("100")).toString());
     //   purchaseOrdersMappingList[index].TotalAmount=double.parse((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString())+Decimal.parse(purchaseOrdersMappingList[index].TaxAmount.toString())).toString());

      }
      else if(outGateFormList[OGF_index].isDiscount==1){

        if(outGateFormList[OGF_index].isPercentage==1){

          OGF_amount=Calculation().mul(OGF_showReceivedQty, outGateFormList[OGF_index].materialPrice);
          OGF_discountAmount=Calculation().discountAmount(discountValue: outGateFormList[OGF_index].discountValue, amount:  OGF_amount);
          OGF_taxAmount=Calculation().taxAmount(taxValue:outGateFormList[OGF_index].taxValue, amount: OGF_amount, discountAmount: OGF_discountAmount );
          OGF_TotalAmount=Calculation().totalAmount(amount: OGF_amount, taxAmount: OGF_taxAmount, discountAmount:  OGF_discountAmount);

         // purchaseOrdersMappingList[index].Amount=double.parse((Decimal.parse(purchaseQty)*Decimal.parse(purchaseOrdersMappingList[index].MaterialPrice.toString())).toString());
         // purchaseOrdersMappingList[index].DiscountAmount=double.parse(((Decimal.parse(purchaseOrdersMappingList[index].DiscountValue.toString())*Decimal.parse(purchaseOrdersMappingList[index].Amount.toString()))/Decimal.parse("100")).toString());

        //  purchaseOrdersMappingList[index].TaxAmount=double.parse(((((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString()))-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())) * Decimal.parse(purchaseOrdersMappingList[index].TaxValue.toString()) )/Decimal.parse("100")).toString());
         // purchaseOrdersMappingList[index].TotalAmount=double.parse((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString())+Decimal.parse(purchaseOrdersMappingList[index].TaxAmount.toString())-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())).toString());

        }
        else if(outGateFormList[OGF_index].isAmount==1){
          OGF_amount=Calculation().mul(OGF_showReceivedQty, outGateFormList[OGF_index].materialPrice);
          OGF_discountAmount=double.parse((Decimal.parse(outGateFormList[OGF_index].discountValue.toString())).toString());
          OGF_taxAmount=Calculation().taxAmount(taxValue:outGateFormList[OGF_index].taxValue, amount: OGF_amount, discountAmount: OGF_discountAmount );
          OGF_TotalAmount=Calculation().totalAmount(amount: OGF_amount, taxAmount: OGF_taxAmount, discountAmount:  OGF_discountAmount);
        //  purchaseOrdersMappingList[index].Amount=double.parse((Decimal.parse(purchaseQty)*Decimal.parse(purchaseOrdersMappingList[index].MaterialPrice.toString())).toString());


       //   purchaseOrdersMappingList[index].TaxAmount=double.parse(((((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString()))-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())) * Decimal.parse(purchaseOrdersMappingList[index].TaxValue.toString()) )/Decimal.parse("100")).toString());
         // purchaseOrdersMappingList[index].TotalAmount=double.parse((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString())+Decimal.parse(purchaseOrdersMappingList[index].TaxAmount.toString())-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())).toString());
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
  String GINV_PorderNo=null;
  int GINV_PorderId=null;
  int GINV_GoodsorderId=null;
  String GINV_Date=null;
  double GINV_invoiceAmount=0.0;
  List<GoodsReceivedMaterialListModel> GINV_Materials=[];
  List<GoodsOtherChargesModel> GINV_OtherChargesList=[];

  updateDriverCharge(int index,double otherChargeAmount){
    GINV_OtherChargesList[index].otherChargesAmount=otherChargeAmount;
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
    GINV_invoiceAmount=0.0;
  }

  // ToPurchase List (GPO)-Goods Purchase
  String GPO_PorderNo=null;
  int GPO_PorderId=null;
  int GPO_GoodsorderId=null;
  String GPO_Date=null;
  double GPO_purchaseAmount=0.0;
  List<GoodsReceivedMaterialListModel> GPO_Materials=[];

  GPO_clear(){
    GPO_Date=null;
    GPO_Materials.clear();
    GPO_PorderNo=null;
    GPO_PorderId=null;
    GPO_GoodsorderId=null;
    GPO_purchaseAmount=0.0;
  }

  GPO_assignValues(){
    GPO_Date=GINV_Date;
    GPO_PorderNo=GINV_PorderNo;
    GPO_PorderId=GINV_PorderId;
    GPO_GoodsorderId=GINV_GoodsorderId;

    GINV_Materials.forEach((element) {
      if(element.status=='Not Yet'){
        GPO_Materials.add(element);
        GPO_purchaseAmount=GPO_purchaseAmount+(element.amount);
      }
    });
    notifyListeners();
  }



  List<GoodsReceivedGridModel> goodsGridList=[];
  List<GoodsReceivedGridModel> filtergoodsGridList=[];
  List<GoodsMaterialExtraTripModel> GoodsMaterialExtraTripModelDetails=[];

  GetGoodsDbHit(BuildContext context,int goodsReceivedId,int purchaseOrderId,bool ToInvoice,TickerProviderStateMixin tickerProviderStateMixin)  async{

    print("GREC__${goodsReceivedId} ${purchaseOrderId} ${goodsReceivedId==0?null:goodsReceivedId}");
    updateGoodsLoader(true);

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
          var t=parsed['Table'] as List;
          if(goodsReceivedId!=null || purchaseOrderId!=null){

            if(ToInvoice){
              GINV_PorderNo=t[0]['PurchaseOrderNumber'];
              GINV_PorderId=t[0]['PurchaseOrderId'];
              GINV_GoodsorderId=t[0]['GoodsReceivedId'];
              GINV_Date=t[0]['Date'];
              var t1=parsed['Table1'] as List;
              var t4=parsed['Table4'] as List;

              GINV_Materials=t1.map((e) => GoodsReceivedMaterialListModel.fromJson(e)).toList();
              GINV_Materials.forEach((element) {
                if(element.status!='Completed'){
                  GINV_invoiceAmount=GINV_invoiceAmount+element.totalAmount;
                }
              });
              GINV_OtherChargesList=t4.map((e) => GoodsOtherChargesModel.fromJson(e,tickerProviderStateMixin)).toList();


            }
            else{
              print("t_$t");



              ML_PorderNo=t[0]['PurchaseOrderNumber'];
              ML_PorderId=t[0]['PurchaseOrderId'];
              ML_GoodsorderId=t[0]['GoodsReceivedId'];
              ML_Date=t[0]['Date'];
              print("ML_PorderId $ML_PorderId");
              var t1=parsed['Table1'] as List;
              print("t1_$t1");
              ML_Materials=t1.map((e) => GoodsReceivedMaterialListModel.fromJson(e)).toList();

              var t2=parsed['Table2'] as List;
              materialTripList=t2.map((e) => GoodsMaterialTripDetailsModel.fromJson(e)).toList();
              print("t2_$t2");
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
            goodsGridList=t.map((e) => GoodsReceivedGridModel.fromJson(e,tickerProviderStateMixin)).toList();
           // filtergoodsGridList=List.from(goodsGridList);
          }
        }

        updateGoodsLoader(false);
      });
    }catch(e){
      updateGoodsLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getGoodsReceivedDetail}" , e.toString());
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