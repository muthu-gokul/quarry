import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/model/productionDetailsModel/productionDetailGridModel.dart';
import 'package:quarry/model/productionDetailsModel/productionGridHeaderModel.dart';
import 'package:quarry/model/productionDetailsModel/productionInputTypeListModel.dart';
import 'package:quarry/model/productionDetailsModel/productionMachineListModel.dart';
import 'package:quarry/model/productionDetailsModel/productionMaterialListModel.dart';
import 'package:quarry/model/productionDetailsModel/productionMaterialMappingListModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';

import 'profileNotifier.dart';

class ProductionNotifier extends ChangeNotifier{

  List<PlantUserModel> plantList=[];
  int plantCount=0;
  Future<dynamic>  PlantUserDropDownValues(BuildContext context) async {

    print("USER ID ${Provider.of<QuarryNotifier>(context,listen: false).UserId}");
    plantCount=0;
    updateProductionLoader(true);
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
          "Value": "User"
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

          var t=parsed['Table'] as List?;
          var t1=parsed['Table1'] as List;
          plantList=t1.map((e) => PlantUserModel.fromJson(e)).toList();
          plantList.forEach((element) {
            if(element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId){
              plantCount=plantCount+1;
              if(!isProductionEdit){
                plantId=element.plantId;
                plantName=element.plantName;
              }

            }
          });

          if(!isProductionEdit){
            if(plantCount!=1){
              plantId=null;
              plantName=null;
              plantList=plantList.where((element) => element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId).toList();
            }
          }


        }
        updateProductionLoader(false);
      });
    }
    catch(e){
      updateProductionLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }



  int? plantId=null;
  String? plantName=null;


  TextEditingController materialQuantity=new TextEditingController();
  TextEditingController materialWeight=new TextEditingController();
  int? selectMachineId=null;
  dynamic selectMachineName=null;

  int? selectInputTypeId=null;
  dynamic selectInputTypeName=null;
  int? selectInputUnitId=null;
  dynamic selectInputUnitName=null;

  int? productionMaterialId=null;
  dynamic productionMaterialName=null;

  int? productionIdEdit=null;

  bool isWastage=false;

  double? dustQty=0.0;
  double? wastageQty=0.0;
  double totalOutputQty=0.0;

  double stock=0.0;

  List<ProductionMachineListModel> machineCategoryList=[];
  List<dynamic>? inputMaterialList=[];
  List<ProductionMaterialListModel> MaterialList=[];
  List<ProductionMaterialMappingListModel> productionMaterialMappingList=[];
  List<String> ProductionDetailsGridCol=['ProductionId','MachineId','MachineName','InputMaterialID','InputMaterialName','InputMaterialQuantity','OutputMaterialCount','IsDustWastage','DustQuantity','WastageQuantity'];

  final call=ApiManager();

  ProductionDropDownValues(BuildContext context) async {

     updateProductionLoader(true);
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
          "Value": "Production"
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
          print(parsed);
          var t=parsed['Table'] as List;
          var t1=parsed['Table1'] as List?;
          var t2=parsed['Table2'] as List;
          machineCategoryList=t.map((e) => ProductionMachineListModel.fromJson(e)).toList();
          inputMaterialList=t1;
          MaterialList=t2.map((e) => ProductionMaterialListModel.fromJson(e)).toList();
          print(MaterialList.length);
        }
        updateProductionLoader(false);
      });
    }
    catch(e){
      updateProductionLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


  wastageCalc(){
    double inputQty=0.0;
    double totalOutputQty=0.0;
    if(materialQuantity.text.isNotEmpty){
      inputQty=double.parse(materialQuantity.text);

      productionMaterialMappingList.forEach((element) {
        totalOutputQty=totalOutputQty+element.OutputMaterialQuantity!;
      });

    /*  if(isWastage){
        totalOutputQty=totalOutputQty-dustQty;
        print("true -$totalOutputQty");
      }
      else{
        totalOutputQty=totalOutputQty;
        print("Fale-$totalOutputQty");
      }
*/
      if(totalOutputQty>=inputQty){
        if(isWastage){
          wastageQty=dustQty;
        }else{
          wastageQty=0.0;
        }
      }
      else if(totalOutputQty<inputQty){
        if(isWastage){
          wastageQty=inputQty-totalOutputQty;
          wastageQty=wastageQty!+dustQty!;
        }
        else{
          wastageQty=inputQty-totalOutputQty;
        }

      }

    }
    notifyListeners();
  }



  InsertProductionDbHit(BuildContext context,TickerProviderStateMixin tickerProviderStateMixin)  async{
    updateProductionLoader(true);
    print(tickerProviderStateMixin);
    List js=[];
    js=productionMaterialMappingList.map((e) => e.toJson()).toList();
    print(js);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isProductionEdit?"${Sp.updateProductionDetail}":"${Sp.insertProductionDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },

        {
          "Key": "ProductionId",
          "Type": "int",
          "Value": productionIdEdit
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": plantId
        },
        {
          "Key": "MachineId",
          "Type": "int",
          "Value": selectMachineId
        },
        {
          "Key": "UnitId",
          "Type": "int",
          "Value": selectInputUnitId
        },
        {
          "Key": "InputMaterialId",
          "Type": "int",
          "Value": selectInputTypeId
        },
        {
          "Key": "InputMaterialQuantity",
          "Type": "String",
          "Value": double.parse(materialQuantity.text)
        },
        {
          "Key": "IsDustWastage",
          "Type": "int",
          "Value": isWastage?1:0
        },
        {
          "Key": "DustQuantity",
          "Type": "String",
          "Value": dustQty
        },
        {
          "Key": "WastageQuantity",
          "Type": "String",
          "Value": wastageQty
        },


        {
          "Key": "ProductionOutputMaterialMappingList",
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
          print(parsed);
          Navigator.pop(context);
          clearForm();
          GetProductionDbHit(context, null,tickerProviderStateMixin);
        }

        updateProductionLoader(false);
      });
    }catch(e){
      updateProductionLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertProductionDetail}" , e.toString());
    }


  }

  List<DateTime?> picked=[];
  List<ManageUserPlantModel> filterUsersPlantList=[];

  List<ProductionGridHeaderModel> gridOverAllHeader=[];
  List<String> productionGridCol=["Machine Name","Input Material","Input Material Qty","Output Material Count","Output Material Qty"];
  List<ProductionDetailGridModel> productionGridValues=[];
  List<ProductionDetailGridModel> filterProductionGridValues=[];

  GetProductionDbHit(BuildContext context,int? productionId,TickerProviderStateMixin tickerProviderStateMixin)  async{

    print(tickerProviderStateMixin);
    print(productionId);
    updateProductionLoader(true);
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
          "Value": "${Sp.getProductionDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "ProductionId",
          "Type": "int",
          "Value": productionId
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

   // try{
    updateProductionLoader(false);

    await call.ApiCallGetInvoke(body,context).then((value) {
      log(value);
        if(value!="null"){
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

          var parsed=json.decode(value);
          var t=parsed['Table'] as List?;

          print(t);
          if(productionId!=null){
            var t1=parsed['Table1'] as List;
            print(t1);


            productionIdEdit=t![0]['ProductionId'];
            plantId=t[0]['PlantId'];
            plantName=t[0]['PlantName'];
            selectMachineId=t[0]['MachineId'];
            selectMachineName=t[0]['MachineName'];
            selectInputTypeId=t[0]['InputMaterialId'];
            selectInputTypeName=t[0]['InputMaterialName'];
            materialQuantity.text=t[0]['InputMaterialQuantity'].toString()??"";
            selectInputUnitId=t[0]['UnitId'];
            selectInputUnitName=t[0]['UnitName'];
            isWastage=t[0]['IsDustWastage']==0?false:t[0]['IsDustWastage']==1?true:false;
            dustQty=t[0]['DustQuantity'];
            wastageQty=t[0]['WastageQuantity'];

            print(t[0]['IsDustWastage']);
            print(isWastage);

            productionMaterialMappingList=t1.map((e) => ProductionMaterialMappingListModel.fromJson(e,tickerProviderStateMixin)).toList();


            /*   notifyListeners();*/
          }
          else{
            var t1=parsed['Table1'] as List;
            print(t);
              gridOverAllHeader=t!.map((e) => ProductionGridHeaderModel.fromJson(e)).toList();
            filterProductionGridValues=t1.map((e) => ProductionDetailGridModel.fromJson(e)).toList();
            filterProductionGrid();
          }
        }



        updateProductionLoader(false);
      });
  /*  }catch(e){
      updateProductionLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getProductionDetail}" , e.toString());
    }*/
  }


  Map<String?,ProductionGridHeaderModel> gridCounter={};

  filterProductionGrid(){
    productionGridValues.clear();
    gridCounter.clear();

    filterUsersPlantList.forEach((element) {
      if(element.isActive!){
        productionGridValues=productionGridValues+filterProductionGridValues.where((ele) => ele.plantId==element.plantId).toList();

        gridOverAllHeader.forEach((element2) {
          print(element2.materialName);
          if(element2.PlantId==element.plantId){
            if(gridCounter.containsKey(element2.materialName)){
              gridCounter[element2.materialName]!.totalQuantity=Calculation().add(gridCounter[element2.materialName]!.totalQuantity, element2.totalQuantity);
            }else{

              gridCounter[element2.materialName]=ProductionGridHeaderModel(
                materialId: element2.materialId,
                materialName: element2.materialName,
                totalQuantity: element2.totalQuantity,
                unitName: element2.unitName,
                materialType: element2.materialType,
                PlantId: element2.PlantId
              );

            }
          }

        });
      }
    });

    notifyListeners();
  }

  updateEdit(int index){

  }

  clearMappingList(){
    productionMaterialId=null;
    productionMaterialName=null;
    materialWeight.clear();
    notifyListeners();
  }

  clearForm(){
     selectMachineId=null;
     selectMachineName=null;
     selectInputTypeId=null;
     selectInputTypeName=null;
     selectInputUnitId=null;
     selectInputUnitName=null;
     productionMaterialName=null;
     productionMaterialId=null;
     materialQuantity.clear();
     materialWeight.clear();

     wastageQty=0.0;
     dustQty=0.0;
     totalOutputQty=0.0;
     stock=0.0;
     isWastage=false;
     plantId=null;
     plantName=null;

    productionMaterialMappingList.clear();

  }


  bool isProductionEdit=false;
  updateProductionEdit(bool value){
    isProductionEdit=value;
    notifyListeners();
  }

  bool ProductionLoader=false;
  updateProductionLoader(bool value){
    ProductionLoader=value;
    notifyListeners();
  }


}