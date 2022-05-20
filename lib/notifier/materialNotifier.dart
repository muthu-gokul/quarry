import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/materialCategoryModel.dart';
import 'package:quarry/model/materialDetailsModel/materialGridModel.dart';
import 'package:quarry/model/parameterMode.dart';
import 'package:quarry/model/unitDetailModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/widgets/alertDialog.dart';

import '../utils/errorLog.dart';

class MaterialNotifier extends ChangeNotifier{



  String module="MaterialMaster";


  TextEditingController materialName=new TextEditingController();
  TextEditingController materialDescription=new TextEditingController();
  TextEditingController materialCode=new TextEditingController();
  TextEditingController materialHSNcode=new TextEditingController();
  TextEditingController materialPrice=new TextEditingController();
  TextEditingController materialGst=new TextEditingController();

  int? selectedMatCategoryId=null;
  dynamic selectedMatCategoryName=null;

  int? selectedUnitId=null;
  dynamic selectedUnitName=null;

  int? materialIdEdit=null;

  List<UnitDetailModel> materialUnits=[];
  List<MaterialCategoryModel> materialCategoryList=[];

  final call=ApiManager();

  Future<dynamic> materialDropDownValues(BuildContext context) async {

    updatematerialLoader(true);
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
          "Value": "Material"
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

          materialUnits=t.map((e) => UnitDetailModel.fromJson(e)).toList();
          materialCategoryList=t1.map((e) => MaterialCategoryModel.fromJson(e)).toList();
        clearForm();
        updatematerialLoader(false);
      });
    }
    catch(e,stackTrace){
      updatematerialLoader(false);
      errorLog("MM01 ${e.toString()}", stackTrace,"Error MM01",module,module, "${Sp.MasterdropDown}");
      //CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }







  InsertMaterialDbHit(BuildContext context)  async{
    updatematerialLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: isMaterialEdit?"${Sp.updateMaterialDetail}":"${Sp.insertMaterialDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "MaterialName", Type: "String", Value: materialName.text),
      ParameterModel(Key: "MaterialDescription", Type: "String", Value: materialDescription.text),
      ParameterModel(Key: "MaterialCode", Type: "String", Value: materialCode.text),
      ParameterModel(Key: "MaterialUnitPrice", Type: "String", Value: materialPrice.text),
      ParameterModel(Key: "MaterialHSNCode", Type: "String", Value: materialHSNcode.text),
      ParameterModel(Key: "TaxValue", Type: "String", Value: materialGst.text),

      ParameterModel(Key: "MaterialCategoryId", Type: "int", Value: selectedMatCategoryId),
      ParameterModel(Key: "MaterialUnitId", Type: "int", Value: selectedUnitId),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    if(isMaterialEdit){
      parameters.insert(2, ParameterModel(Key: "materialId", Type: "int", Value: materialIdEdit));
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
          GetMaterialDbHit(context, null);
        }
        else{
          updatematerialLoader(false);
        }


      });
    }catch(e,stackTrace){
      updatematerialLoader(false);
      errorLog("MM02 ${e.toString()}", stackTrace,"Error MM02",module,module, isMaterialEdit?"${Sp.updateMaterialDetail}":"${Sp.insertMaterialDetail}");

    }


  }



  List<String> materialGridCol=["Material Name","Unit","Price","GST","Category"];
  List<MaterialGridModel> materialGridList=[];


  GetMaterialDbHit(BuildContext context,int? materialId)  async{

    updatematerialLoader(true);

    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.getMaterialDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "MaterialId", Type: "int", Value: materialId),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
    };


    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        var parsed=json.decode(value);
        var t=parsed['Table'] as List?;


        if(materialId!=null){
          materialIdEdit=t![0]['MaterialId'];

          materialName.text=t[0]['MaterialName'];
          materialDescription.text=t[0]['MaterialDescription'];
          materialCode.text=t[0]['MaterialCode'];
          materialHSNcode.text=t[0]['MaterialHSNCode'];
          materialPrice.text=t[0]['MaterialUnitPrice'].toString();
          materialGst.text=t[0]['TaxValue'].toString();

          selectedMatCategoryId=t[0]['MaterialCategoryId'];
          selectedMatCategoryName=t[0]['MaterialCategoryName'];
          selectedUnitId=t[0]['MaterialUnitId'];
          selectedUnitName=t[0]['UnitName'];
        }
        else{
          materialGridList=t!.map((e) => MaterialGridModel.fromJson(e)).toList();
        }



        updatematerialLoader(false);
      });
    }catch(e,stackTrace){
      updatematerialLoader(false);
      errorLog("MM03 ${e.toString()}", stackTrace,"Error MM03",module,module,"${Sp.getMaterialDetail}");

    }


  }

  Future<dynamic> deleteById(int customerId) async {
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value:  "${Sp.deleteMaterialDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(Get.context!,listen: false).UserId),
      ParameterModel(Key: "MaterialId", Type: "String", Value: customerId),
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
          GetMaterialDbHit(Get.context!, null);
        }
      });
    } catch (e,stackTrace) {
      errorLog("MM04 ${e.toString()}", stackTrace,"Error MM04",module,module,"${Sp.deleteMaterialDetail}");
    }
  }

  updateEdit(int index){

  }


  clearForm(){
     selectedMatCategoryId=null;
     selectedMatCategoryName=null;
     selectedUnitId=null;
     selectedUnitName=null;
      materialIdEdit=null;
      materialName.clear() ;
      materialDescription.clear() ;
      materialCode.clear() ;
      materialHSNcode.clear();
      materialPrice.clear() ;
      materialGst.clear() ;
  }

  bool isMaterialEdit=false;
  updateMaterialEdit(bool value){
    isMaterialEdit=value;
    notifyListeners();
  }
  bool materialLoader=false;
  updatematerialLoader(bool value){
    materialLoader=value;
    notifyListeners();
  }

  clearAll(){
    clearForm();
    materialGridList.clear();
  }


}