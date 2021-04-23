import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/materialCategoryModel.dart';
import 'package:quarry/model/materialDetailsModel/materialGridModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseDetailGridModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseMaterialListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseSupplierListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseSupplierTypeModel.dart';
import 'package:quarry/model/supplierDetailModel/SupplierMaterialMappingListModel.dart';
import 'package:quarry/model/supplierDetailModel/supplierCategoryModel.dart';
import 'package:quarry/model/supplierDetailModel/supplierGridModel.dart';
import 'package:quarry/model/supplierDetailModel/supplierMaterialModel.dart';
import 'package:quarry/model/unitDetailModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';

class PurchaseNotifier extends ChangeNotifier{




  String supplierType=null;

  int supplierId=null;
  var SelectedSupplierName=null;

  DateTime PurchaseDate;
  DateTime ExpectedPurchaseDate;

  int PurchaseEditId=null;


  List<PurchaseSupplierType> supplierTypeList=[];
  List<PurchaseSupplierList> suppliersList=[];
  List<PurchaseSupplierList> filterSuppliersList=[];

  List<PurchaseMaterialsListModel> materialsList=[];
  List<PurchaseMaterialsListModel> filterMaterialsList=[];


  final call=ApiManager();

  PurchaseDropDownValues(BuildContext context) async {

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

          clearForm();
        }
        updatePurchaseLoader(false);
      });
    }
    catch(e){
      updatePurchaseLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


















/*
  InsertPurchaseDbHit(BuildContext context,TickerProviderStateMixin tickerProviderStateMixin)  async{
    updateSupplierLoader(true);

    List js=[];
    js=supplierMaterialMappingList.map((e) => e.toJson()).toList();
    print(js);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isSupplierEdit?"${Sp.updateSupplierDetail}":"${Sp.insertSupplierDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },

        {
          "Key": "SupplierId",
          "Type": "int",
          "Value": supplierEditId
        },
        {
          "Key": "SupplierName",
          "Type": "String",
          "Value": supplierName.text
        },
        {
          "Key": "SupplierCategoryId",
          "Type": "int",
          "Value": supplierCategoryId
        },
        {
          "Key": "SupplierAddress",
          "Type": "String",
          "Value": supplierAddress.text
        },
        {
          "Key": "SupplierState",
          "Type": "String",
          "Value": supplierState.text
        },
        {
          "Key": "SupplierCity",
          "Type": "String",
          "Value": supplierCity.text
        },
        {
          "Key": "SupplierCountry",
          "Type": "String",
          "Value": supplierCountry.text
        },
        {
          "Key": "SupplierZipCode",
          "Type": "String",
          "Value": supplierZipcode.text
        },
        {
          "Key": "SupplierContactNumber",
          "Type": "String",
          "Value": supplierContactNumber.text
        },
        {
          "Key": "SupplierEmail",
          "Type": "String",
          "Value": supplierEmail.text
        },
        {
          "Key": "SupplierGSTNumber",
          "Type": "String",
          "Value": supplierGstNo.text
        },
        {
          "Key": "SupplierMaterialMappingList",
          "Type": "datatable",
          "Value": js
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
          GetSupplierDbHit(context, null,tickerProviderStateMixin);
        }

        updateSupplierLoader(false);
      });
    }catch(e){
      updateSupplierLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertSupplierDetail}" , e.toString());
    }


  }
*/



  List<String> purchaseGridCol=["Order Number","Expected Date","Material Name","Purchase Quantity","Tax Amount","Net Amount"];
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

          print(t);
          if(supplierId!=null){
            var t1=parsed['Table1'] as List;
            print(t1);



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
  }



  clearForm(){
    supplierType=null;

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