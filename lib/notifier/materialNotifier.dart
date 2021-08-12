import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/materialCategoryModel.dart';
import 'package:quarry/model/materialDetailsModel/materialGridModel.dart';
import 'package:quarry/model/unitDetailModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';

class MaterialNotifier extends ChangeNotifier{






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
    catch(e){
      updatematerialLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }







  InsertMaterialDbHit(BuildContext context)  async{
    updatematerialLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isMaterialEdit?"${Sp.updateMaterialDetail}":"${Sp.insertMaterialDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "MaterialName",
          "Type": "String",
          "Value": materialName.text
        },
        {
          "Key": "materialId",
          "Type": "int",
          "Value": materialIdEdit
        },
        {
          "Key": "MaterialCategoryId",
          "Type": "int",
          "Value": selectedMatCategoryId
        },
        {
          "Key": "MaterialUnitId",
          "Type": "int",
          "Value": selectedUnitId
        },
        {
          "Key": "MaterialDescription",
          "Type": "String",
          "Value": materialDescription.text
        },
        {
          "Key": "MaterialCode",
          "Type": "String",
          "Value": materialCode.text
        },
        {
          "Key": "MaterialUnitPrice",
          "Type": "String",
          "Value": materialPrice.text
        },
        {
          "Key": "MaterialHSNCode",
          "Type": "String",
          "Value": materialHSNcode.text
        },
        {
          "Key": "TaxValue",
          "Type": "String",
          "Value": materialGst.text
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
          GetMaterialDbHit(context, null);
        }

        updatematerialLoader(false);
      });
    }catch(e){
      updatematerialLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertMaterialDetail}" , e.toString());
    }


  }



  List<String> materialGridCol=["Material Name","Unit","Price","GST","Category"];
  List<MaterialGridModel> materialGridList=[];


  GetMaterialDbHit(BuildContext context,int? materialId)  async{
    print(materialId);
    updatematerialLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getMaterialDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "MaterialId",
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
    }catch(e){
      updatematerialLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getMaterialDetail}" , e.toString());
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



}