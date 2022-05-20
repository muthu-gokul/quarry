import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/materialCategoryModel.dart';
import 'package:quarry/model/materialDetailsModel/materialGridModel.dart';
import 'package:quarry/model/parameterMode.dart';
import 'package:quarry/model/supplierDetailModel/SupplierMaterialMappingListModel.dart';
import 'package:quarry/model/supplierDetailModel/supplierCategoryModel.dart';
import 'package:quarry/model/supplierDetailModel/supplierGridModel.dart';
import 'package:quarry/model/supplierDetailModel/supplierMaterialModel.dart';
import 'package:quarry/model/unitDetailModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/widgets/alertDialog.dart';

import '../utils/errorLog.dart';
import '../utils/utils.dart';

class SupplierNotifier extends ChangeNotifier{



  String module="SupplierMaster";


  TextEditingController supplierName=new TextEditingController();
  TextEditingController supplierAddress=new TextEditingController();
  TextEditingController supplierCity=new TextEditingController();
  TextEditingController supplierState=new TextEditingController();
  TextEditingController supplierCountry=new TextEditingController();
  TextEditingController supplierZipcode=new TextEditingController();
  TextEditingController supplierContactNumber=new TextEditingController();
  TextEditingController supplierEmail=new TextEditingController();
  TextEditingController supplierGstNo=new TextEditingController();

  int? supplierCategoryId=null;
  dynamic supplierCategoryName=null;

  int? supplierMaterialId=null;
  dynamic supplierMaterialName=null;
  dynamic supplierMaterialUnitName=null;

  TextEditingController materialPrice=new TextEditingController();

  List<SupplierCategoryModel> supplierCategoryList=[];
  List<SupplierMaterialModel> supplierMaterialList=[];
  List<SupplierMaterialMappingListModel> supplierMaterialMappingList=[];

  var supplierLogoFileName;
  var supplierLogoFolderName="Supplier";
  String supplierLogoUrl="";
  File? logoFile;


  int? supplierEditId=null;



  final call=ApiManager();

  Future<dynamic> SupplierDropDownValues(BuildContext context) async {

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
          "Value": "SupplierCategory"
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
          var t=parsed['Table'] as List;
          var t1=parsed['Table1'] as List;
          supplierCategoryList=t.map((e) => SupplierCategoryModel.fromJson(e)).toList();
          supplierMaterialList=t1.map((e) => SupplierMaterialModel.fromJson(e)).toList();
        }
        updateSupplierLoader(false);
      });
    }
    catch(e,stackTrace){
      updateSupplierLoader(false);
      errorLog("SPM01 ${e.toString()}", stackTrace,"Error SPM01",module,module, "${Sp.MasterdropDown}");

    }
  }

  InsertSupplierDbHit(BuildContext context,TickerProviderStateMixin tickerProviderStateMixin)  async{
    updateSupplierLoader(true);

    List js=[];
    js=supplierMaterialMappingList.map((e) => e.toJson()).toList();
    supplierLogoFileName="";
    if(logoFile!=null){
      supplierLogoFileName=await uploadFile(supplierLogoFolderName,logoFile!);
    }
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: isSupplierEdit?"${Sp.updateSupplierDetail}":"${Sp.insertSupplierDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "SupplierName", Type: "String", Value: supplierName.text),
      ParameterModel(Key: "SupplierAddress", Type: "String", Value: supplierAddress.text),
      ParameterModel(Key: "SupplierState", Type: "String", Value: supplierState.text),
      ParameterModel(Key: "SupplierCity", Type: "String", Value: supplierCity.text),
      ParameterModel(Key: "SupplierCountry", Type: "String", Value: supplierCountry.text),
      ParameterModel(Key: "SupplierZipCode", Type: "String", Value: supplierZipcode.text),
      ParameterModel(Key: "SupplierContactNumber", Type: "String", Value: supplierContactNumber.text),
      ParameterModel(Key: "SupplierEmail", Type: "String", Value: supplierEmail.text),
      ParameterModel(Key: "SupplierGSTNumber", Type: "String", Value: supplierGstNo.text),
      ParameterModel(Key: "SupplierLogoFileName", Type: "String", Value: supplierLogoFileName),
      ParameterModel(Key: "SupplierMaterialMappingList", Type: "datatable", Value: js),
      ParameterModel(Key: "SupplierCategoryId", Type: "int", Value: supplierCategoryId),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];

    if(isSupplierEdit){
      parameters.insert(2,ParameterModel(Key: "SupplierId", Type: "int", Value: supplierEditId));
    }

    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
    };


    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!="null"){
          var parsed=json.decode(value);
          Navigator.pop(context);
          clearForm();
          GetSupplierDbHit(context, null,tickerProviderStateMixin);
        }
        else{
          updateSupplierLoader(false);
        }


      });
    }catch(e,stackTrace){
      updateSupplierLoader(false);
      errorLog("SPM02 ${e.toString()}", stackTrace,"Error SPM02",module,module, "${Sp.insertSupplierDetail}");

    }


  }



  List<String> supplierGridCol=["Supplier Name","Category","Location","Contact Number"];
  List<SupplierGridModel> supplierGridList=[];


  GetSupplierDbHit(BuildContext context,int? supplierId,TickerProviderStateMixin tickerProviderStateMixin)  async{

    updateSupplierLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.getSupplierDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "SupplierId", Type: "int", Value: supplierId),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
    };


    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        log("suppplier $value");
        if(value!="null"){
          var parsed=json.decode(value);
          var t=parsed['Table'] as List?;

          if(supplierId!=null){
            var t1=parsed['Table1'] as List;


            supplierCategoryName=t![0]['SupplierCategoryName'];
            supplierCategoryId=t[0]['SupplierCategoryId'];
            supplierEditId=t[0]['SupplierId'];
            supplierMaterialId=null;
            supplierMaterialName=null;
            supplierName.text=t[0]['SupplierName']??"";
            supplierAddress.text=t[0]['SupplierAddress']??"";
            supplierCity.text=t[0]['SupplierCity']??"";
            supplierState.text=t[0]['SupplierState']??"";
            supplierCountry.text=t[0]['SupplierCountry']??"";
            supplierZipcode.text=t[0]['SupplierZipCode']??"";
            supplierContactNumber.text=t[0]['SupplierContactNumber']??"";
            supplierEmail.text=t[0]['SupplierEmail']??"";
            supplierGstNo.text=t[0]['SupplierGSTNumber']??"";

            supplierMaterialMappingList=t1.map((e) => SupplierMaterialMappingListModel.fromJson(e,tickerProviderStateMixin)).toList();
            supplierLogoFileName= t[0]['SupplierLogo'];
            supplierLogoUrl=ApiManager().attachmentUrl+supplierLogoFileName;
            logoFile=null;
         /*   notifyListeners();*/
          }
          else{
            supplierGridList=t!.map((e) => SupplierGridModel.fromJson(e)).toList();
          }
        }



        updateSupplierLoader(false);
      });
    }catch(e,stackTrace){
      updateSupplierLoader(false);
      errorLog("SPM03 ${e.toString()}", stackTrace,"Error SPM03",module,module, "${Sp.getSupplierDetail}");

    }


  }

  Future<dynamic> deleteById(int id,TickerProviderStateMixin tickerProviderStateMixin) async {
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value:  "${Sp.deleteSupplierDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(Get.context!,listen: false).UserId),
      ParameterModel(Key: "SupplierId", Type: "String", Value: id),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(Get.context!,listen: false).DataBaseName),
    ];
    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
    };
    try {
      await call.ApiCallGetInvoke(body, Get.context!).then((value) {
        if (value != "null") {
          //var parsed = json.decode(value);
          CustomAlert().deletePopUp();
          GetSupplierDbHit(Get.context!, null,tickerProviderStateMixin);
        }
      });
    } catch (e) {

      CustomAlert().commonErrorAlert(Get.context!, "${Sp.deleteSupplierDetail}", e.toString());
    }
  }

  updateEdit(int index){

  }

  clearMappingList(){
    supplierMaterialId=null;
    supplierMaterialName=null;
    materialPrice.clear();
    notifyListeners();
  }

  clearForm(){
    supplierCategoryName=null;
    supplierCategoryId=null;
    supplierMaterialId=null;
    supplierMaterialName=null;
     supplierName.clear();
     supplierAddress.clear();
     supplierCity.clear();
     supplierState.clear();
     supplierCountry.clear();
     supplierZipcode.clear();
     supplierContactNumber.clear();
     supplierEmail.clear();
     supplierGstNo.clear();
     supplierMaterialMappingList.clear();
     supplierLogoUrl="";
     logoFile=null;
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


  clearAll(){
    clearForm();
    supplierGridList.clear();
  }


}