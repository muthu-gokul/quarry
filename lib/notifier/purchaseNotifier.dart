import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/purchaseDetailsModel/PurchaseOrderOtherChargesMappingListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseDetailGridModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseMaterialListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseOrderMaterialMappingListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseSupplierListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseSupplierTypeModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';
import '../widgets/decimal.dart';

class PurchaseNotifier extends ChangeNotifier{




  String supplierType=null;

  int supplierId=null;
  var supplierName=null;

  DateTime PurchaseDate;
  DateTime ExpectedPurchaseDate;

  int PurchaseEditId=null;


  List<PurchaseSupplierType> supplierTypeList=[];
  List<PurchaseSupplierList> suppliersList=[];
  List<PurchaseSupplierList> filterSuppliersList=[];

  List<PurchaseMaterialsListModel> materialsList=[];
  List<PurchaseMaterialsListModel> filterMaterialsList=[];


  final call=ApiManager();

  Future<dynamic> PurchaseDropDownValues(BuildContext context) async {

    updatePurchaseLoader(true);
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
          "Value": "Purchase"
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
          var t1=parsed['Table1'] as List;
          var t2=parsed['Table2'] as List;
          var t3=parsed['Table3'] as List;
          var t4=parsed['Table4'] as List;


          materialsList=t1.map((e) => PurchaseMaterialsListModel.fromJson(e)).toList();
          filterMaterialsList=materialsList;

          supplierTypeList=t2.map((e) => PurchaseSupplierType.fromJson(e)).toList();

          suppliersList =t3.map((e) => PurchaseSupplierList.fromJson(e)).toList();
          filterSuppliersList=suppliersList;

        }
        updatePurchaseLoader(false);
      });
    }
    catch(e){
      updatePurchaseLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


 TextEditingController searchController=new TextEditingController();

 searchMaterial(String value){
   if(value.isEmpty){
     filterMaterialsList=materialsList;
   }
   else{
     filterMaterialsList=materialsList.where((element) => element.materialName.toLowerCase().contains(value.toLowerCase())).toList();
   }
   notifyListeners();
 }



  List<PurchaseOrderMaterialMappingListModel> purchaseOrdersMappingList=[];
  List<PurchaseOrderOtherChargesMappingList> purchaseOrdersOtherChargesMappingList=[];

  bool isDiscountPercentage=true;
  updateisDiscountPercentage(bool value){
    isDiscountPercentage=value;
    notifyListeners();
  }


  removepurchaseOrdersMappingList(int index){
    purchaseOrdersMappingList.removeAt(index);
    notifyListeners();
  }


  updateIsDiscountFromQtyShowDialog(int index,String discountvalue,String purchaseqty){

    if(discountvalue.isEmpty){
      purchaseOrdersMappingList[index].IsDiscount=0;
      purchaseOrdersMappingList[index].IsAmount=0;
      purchaseOrdersMappingList[index].IsPercentage=0;
      purchaseOrdersMappingList[index].DiscountValue=0.0;
      purchaseOrdersMappingList[index].DiscountAmount=0.0;

      if(purchaseqty.isEmpty){
        purchaseOrdersMappingList[index].purchaseQty..text="";
        purchaseOrdersCalc(index,"0");
      }else{
        purchaseOrdersMappingList[index].purchaseQty..text=purchaseqty;
        purchaseOrdersCalc(index,purchaseqty);
      }

    }
    else{
      purchaseOrdersMappingList[index].IsDiscount=1;
      if(isDiscountPercentage){
        purchaseOrdersMappingList[index].IsPercentage=1;
        purchaseOrdersMappingList[index].IsAmount=0;
      }else{
        purchaseOrdersMappingList[index].IsPercentage=0;
        purchaseOrdersMappingList[index].IsAmount=1;
      }
      purchaseOrdersMappingList[index].DiscountValue=double.parse(discountvalue);
      purchaseOrdersMappingList[index].DiscountAmount=0.0;

      if(purchaseqty.isEmpty){
        purchaseOrdersMappingList[index].purchaseQty..text="";
        purchaseOrdersCalc(index,"0");
      }else{
        purchaseOrdersMappingList[index].purchaseQty..text=purchaseqty;
        purchaseOrdersCalc(index,purchaseqty);
      }


    }


    notifyListeners();
  }


  purchaseOrdersCalc(int index,String purchaseQty){
    print("purchaseQty1  $purchaseQty");

    if(purchaseQty.isEmpty){

      purchaseOrdersMappingList[index].TotalAmount=0.0;
      purchaseOrdersMappingList[index].Amount=0.0;
      purchaseOrdersMappingList[index].TaxAmount=0.0;
      purchaseOrdersMappingList[index].DiscountAmount=0.0;
      overAllTotalCalc();
    }
    else{


      if( purchaseOrdersMappingList[index].IsDiscount==0){
        purchaseOrdersMappingList[index].Amount=double.parse((Decimal.parse(purchaseQty)*Decimal.parse(purchaseOrdersMappingList[index].MaterialPrice.toString())).toString());
        purchaseOrdersMappingList[index].TaxAmount=double.parse(((Decimal.parse(purchaseOrdersMappingList[index].TaxValue.toString())*(Decimal.parse(purchaseOrdersMappingList[index].Amount.toString())-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())))/Decimal.parse("100")).toString());
        purchaseOrdersMappingList[index].TotalAmount=double.parse((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString())+Decimal.parse(purchaseOrdersMappingList[index].TaxAmount.toString())).toString());

      }
      else if(purchaseOrdersMappingList[index].IsDiscount==1){
        if(purchaseOrdersMappingList[index].IsPercentage==1){
          purchaseOrdersMappingList[index].Amount=double.parse((Decimal.parse(purchaseQty)*Decimal.parse(purchaseOrdersMappingList[index].MaterialPrice.toString())).toString());
          purchaseOrdersMappingList[index].DiscountAmount=double.parse(((Decimal.parse(purchaseOrdersMappingList[index].DiscountValue.toString())*Decimal.parse(purchaseOrdersMappingList[index].Amount.toString()))/Decimal.parse("100")).toString());

          purchaseOrdersMappingList[index].TaxAmount=double.parse(((((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString()))-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())) * Decimal.parse(purchaseOrdersMappingList[index].TaxValue.toString()) )/Decimal.parse("100")).toString());
          purchaseOrdersMappingList[index].TotalAmount=double.parse((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString())+Decimal.parse(purchaseOrdersMappingList[index].TaxAmount.toString())-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())).toString());

        }
        else if(purchaseOrdersMappingList[index].IsAmount==1){

          purchaseOrdersMappingList[index].Amount=double.parse((Decimal.parse(purchaseQty)*Decimal.parse(purchaseOrdersMappingList[index].MaterialPrice.toString())).toString());

          purchaseOrdersMappingList[index].DiscountAmount=double.parse((Decimal.parse(purchaseOrdersMappingList[index].DiscountValue.toString())).toString());

          purchaseOrdersMappingList[index].TaxAmount=double.parse(((((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString()))-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())) * Decimal.parse(purchaseOrdersMappingList[index].TaxValue.toString()) )/Decimal.parse("100")).toString());
          purchaseOrdersMappingList[index].TotalAmount=double.parse((Decimal.parse(purchaseOrdersMappingList[index].Amount.toString())+Decimal.parse(purchaseOrdersMappingList[index].TaxAmount.toString())-Decimal.parse(purchaseOrdersMappingList[index].DiscountAmount.toString())).toString());
        }

      }
      overAllTotalCalc();
    }
    notifyListeners();
  }
  


  double subtotal=0.0;
  double taxAmount=0.0;
  double discountAmount=0.0;
  double discountedSubtotal=0.0;
  double grandTotal=0.0;
  double otherCharges=0.0;


  overAllTotalCalc(){
    subtotal=0.0;
    taxAmount=0.0;
    discountAmount=0.0;
    discountedSubtotal=0.0;
    grandTotal=0.0;
    otherCharges=0.0;
    purchaseOrdersOtherChargesMappingList.forEach((element) {
      otherCharges=double.parse((Decimal.parse(otherCharges.toString()) + Decimal.parse(element.OtherChargesAmount.toString())).toString());
    });
    purchaseOrdersMappingList.forEach((element) {
      subtotal=double.parse((Decimal.parse(subtotal.toString()) + Decimal.parse(element.Amount.toString())).toString());
      taxAmount=double.parse((Decimal.parse(taxAmount.toString()) + Decimal.parse(element.TaxAmount.toString())).toString());
      discountAmount=double.parse((Decimal.parse(discountAmount.toString()) + Decimal.parse(element.DiscountAmount.toString())).toString());
      discountedSubtotal=double.parse((Decimal.parse(subtotal.toString()) - Decimal.parse(discountedSubtotal.toString())).toString());
      grandTotal=double.parse((Decimal.parse(grandTotal.toString()) + Decimal.parse(element.TotalAmount.toString()) + Decimal.parse(otherCharges.toString())).toString());
    });

    notifyListeners();
  }







  InsertPurchaseDbHit(BuildContext context)  async{
    updatePurchaseLoader(true);

    List js=[];
    js=purchaseOrdersMappingList.map((e) => e.toJson()).toList();
    print(js);
    List oa=[];
    oa=purchaseOrdersOtherChargesMappingList.map((e) => e.toJson()).toList();
    print(oa);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isPurchaseEdit?"${Sp.updatePurchaseDetail}":"${Sp.insertPurchaseDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },

        {
          "Key": "PurchaseOrderId",
          "Type": "int",
          "Value": PurchaseEditId
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": null
        },
        {
          "Key": "ExpectedDate",
          "Type": "String",
          "Value": DateFormat("yyyy-MM-dd").format(ExpectedPurchaseDate).toString()
        },
        {
          "Key": "SupplierType",
          "Type": "String",
          "Value": supplierType
        },
        {
          "Key": "Supplier",
          "Type": "int",
          "Value": supplierId
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
          Navigator.pop(context);
          clearForm();
          GetPurchaseDbHit(context, null,);
        }

        updatePurchaseLoader(false);
      });
    }catch(e){
      updatePurchaseLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertPurchaseDetail}" , e.toString());
    }


  }












  List<String> purchaseGridCol=["Order Number","Expected Date","No of Material","Purchase Quantity","Tax Amount","Sub Total","Net Amount"];
  List<PurchaseOrderGridModel> purchaseGridList=[];


  GetPurchaseDbHit(BuildContext context,int PurchaseOrderId)  async{
    updatePurchaseLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getPurchaseDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "PurchaseOrderId",
          "Type": "int",
          "Value": PurchaseOrderId
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
           print(value);
          print(t);
          if(PurchaseOrderId!=null){
            var t1=parsed['Table1'] as List;
            print(t1);
            var t2=parsed['Table2'] as List;
            print(t2);

            PurchaseEditId=t[0]['PurchaseOrderId'];
            supplierType=t[0]['SupplierType'];
            supplierId=t[0]['Supplier'];
            supplierName=t[0]['SupplierName'];

            filterSuppliersList=suppliersList.where((element) => element.supplierType.toLowerCase()==supplierType.toLowerCase()).toList();
            print(suppliersList.length);
            print(filterSuppliersList.length);
            if(supplierType=='External'){
              filterMaterialsList=materialsList.where((element) => element.supplierId==supplierId).toList();
            }
            else{
              filterMaterialsList=materialsList.where((element) => element.supplierName=='Supplier').toList();

            }

            PurchaseDate=DateTime.now();
            ExpectedPurchaseDate=t[0]['ExpectedDate']!=null?DateTime.parse(t[0]['ExpectedDate']):DateTime.now();
            print(ExpectedPurchaseDate);
            subtotal=t[0]['Subtotal'];
            taxAmount=t[0]['GST'];
            grandTotal=t[0]['Total'];
            discountAmount=t[0]['Discount']??0.0;

            purchaseOrdersMappingList=t1.map((e) => PurchaseOrderMaterialMappingListModel.fromJson(e)).toList();
            purchaseOrdersOtherChargesMappingList=t2.map((e) => PurchaseOrderOtherChargesMappingList.fromJson(e)).toList();


            notifyListeners();
          }
          else{
            purchaseGridList=t.map((e) => PurchaseOrderGridModel.fromJson(e)).toList();
          }
        }



        updatePurchaseLoader(false);
      });
    }catch(e){
      updatePurchaseLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getPurchaseDetail}" , e.toString());
    }


  }



  updateEdit(int index){

  }

  insertForm(){
    PurchaseDate=DateTime.now();
    ExpectedPurchaseDate=DateTime.now();
    notifyListeners();
  }



  clearForm(){
     supplierType=null;

     supplierId=null;
     supplierName=null;
     searchController.clear();
     purchaseOrdersMappingList.clear();
      subtotal=0.0;
      taxAmount=0.0;
      discountAmount=0.0;
      discountedSubtotal=0.0;
      grandTotal=0.0;
      otherCharges=0.0;
     purchaseOrdersOtherChargesMappingList.clear();
  }

  bool isPurchaseEdit=false;
  updatePurchaseEdit(bool value){
    isPurchaseEdit=value;
    notifyListeners();
  }

  bool PurchaseLoader=false;
  updatePurchaseLoader(bool value){
    PurchaseLoader=value;
    notifyListeners();
  }



}