import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/materialCategoryModel.dart';
import 'package:quarry/model/materialDetailsModel/materialGridModel.dart';
import 'package:quarry/model/supplierDetailModel/supplierGridModel.dart';
import 'package:quarry/model/unitDetailModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';

class SupplierNotifier extends ChangeNotifier{






  TextEditingController supplierName=new TextEditingController();
  TextEditingController supplierAddress=new TextEditingController();
  TextEditingController supplierCity=new TextEditingController();
  TextEditingController supplierState=new TextEditingController();
  TextEditingController supplierCountry=new TextEditingController();
  TextEditingController supplierZipcode=new TextEditingController();
  TextEditingController supplierContactNumber=new TextEditingController();
  TextEditingController supplierEmail=new TextEditingController();
  TextEditingController supplierGstNo=new TextEditingController();

  int supplierCategoryId=null;
  var supplierCategoryName=null;


  int supplierIdEdit=null;



  final call=ApiManager();

  SupplierDropDownValues(BuildContext context) async {

    updateSupplierLoader(true);
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
          "Value": "Supplier"
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
        var parsed=json.decode(value);

        var t=parsed['Table'] as List;
        var t1=parsed['Table1'] as List;

        clearForm();
        updateSupplierLoader(false);
      });
    }
    catch(e){
      updateSupplierLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


















  InsertSupplierDbHit(BuildContext context)  async{
    updateSupplierLoader(true);
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
          "Value": supplierIdEdit
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
          "Value": ""
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
          GetSupplierDbHit(context, null);
        }

        updateSupplierLoader(false);
      });
    }catch(e){
      updateSupplierLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertSupplierDetail}" , e.toString());
    }


  }



  List<String> supplierGridCol=["Supplier Name","Category","Location","Contact Number"];
  List<SupplierGridModel> supplierGridList=[];


  GetSupplierDbHit(BuildContext context,int materialId)  async{
    print(materialId);
    updateSupplierLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getSupplierDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "SupplierId",
          "Type": "int",
          "Value": materialId
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
          if(materialId!=null){

          }
          else{
            supplierGridList=t.map((e) => SupplierGridModel.fromJson(e)).toList();
          }
        }



        updateSupplierLoader(false);
      });
    }catch(e){
      updateSupplierLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getSupplierDetail}" , e.toString());
    }


  }



  updateEdit(int index){

  }


  clearForm(){
    supplierCategoryName=null;
    supplierCategoryId=null;
     supplierName.clear();
     supplierAddress.clear();
     supplierCity.clear();
     supplierState.clear();
     supplierCountry.clear();
     supplierZipcode.clear();
     supplierContactNumber.clear();
     supplierEmail.clear();
     supplierGstNo.clear();
  }

  bool isSupplierEdit=false;
  updateSupplierEdit(bool value){
    isSupplierEdit=value;
    notifyListeners();
  }

  bool SupplierLoader=false;
  updateSupplierLoader(bool value){
    SupplierLoader=value;
    notifyListeners();
  }



}