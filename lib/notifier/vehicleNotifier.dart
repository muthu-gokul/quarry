import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/vehicelDetailsModel/vehicleGridModel.dart';
import 'package:quarry/model/vehicelDetailsModel/vehicleTypeModel.dart';


import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';


class VehicleNotifier extends ChangeNotifier{


  List<String> VehicleGridCol=["Vehicle Number","Vehicle Type","Model","Empty Weight","Description"];
  List<VehicleGridModel> vehicleGridList=[];


  TextEditingController VehicleNo=new TextEditingController();
  TextEditingController VehicleDescript=new TextEditingController();
  TextEditingController VehicleModel=new TextEditingController();
  TextEditingController VehicleWeight=new TextEditingController();


  int selectedVehicleTypeId=null;
  var selectedVehicleTypeName=null;

  int editVehicleId=null;

  List<VehicleTypeModel> vehicleTypeList=[];
  List<VehicleTypeModel> filterVehicleTypeList=[];

  final call=ApiManager();

  Future<dynamic> vehicleDropDownValues(BuildContext context) async {
    updatevehicleLoader(true);
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
          "Value": "VehicleType"
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
        var parsed=json.decode(value);

        var t=parsed['Table'] as List;

        vehicleTypeList=t.map((e) => VehicleTypeModel.fromJson(e)).toList();
        filterVehicleTypeList=t.map((e) => VehicleTypeModel.fromJson(e)).toList();

        updatevehicleLoader(false);
      });
    }
    catch(e){
      updatevehicleLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }

  InsertVehicleTypeDbhit(BuildContext context,String vehicleTypeName) async {
    updatevehicleLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.insertVehicleType}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "VehicleTypeName",
          "Type": "String",
          "Value": vehicleTypeName
        },
        {
          "Key": "CompanyId",
          "Type": "int",
          "Value": 1
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
          selectedVehicleTypeId=t[0]['VehicleTypeId'];
          selectedVehicleTypeName=t[0]['VehicleTypeName'];
          vehicleTypeList.add(VehicleTypeModel(
              VehicleTypeId: selectedVehicleTypeId,
              VehicleTypeName: selectedVehicleTypeName
          ));
          filterVehicleTypeList=vehicleTypeList;
        }
        updatevehicleLoader(false);

      });
    }
    catch(e){
      updatevehicleLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertVehicleType}" , e.toString());
    }
  }


  searchVehicleType(String value){
    if(value.isEmpty){
      filterVehicleTypeList=vehicleTypeList;
    }
    else{
      filterVehicleTypeList=vehicleTypeList.where((element) => element.VehicleTypeName.toLowerCase().contains(value.toLowerCase())).toList();
    }
    notifyListeners();
  }


  InsertVehicleDbHit(BuildContext context)  async{
    updatevehicleLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isVehicleEdit?"${Sp.updateVehicleDetail}" :"${Sp.insertVehicleDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "VehicleNumber",
          "Type": "String",
          "Value": VehicleNo.text
        },
        {
          "Key": "VehicleId",
          "Type": "int",
          "Value": editVehicleId
        },
        {
          "Key": "VehicleDescription",
          "Type": "String",
          "Value": VehicleDescript.text
        },
        {
          "Key": "VehicleTypeId",
          "Type": "int",
          "Value": selectedVehicleTypeId
        },
        {
          "Key": "VehicleModel",
          "Type": "String",
          "Value": VehicleModel.text
        },
        {
          "Key": "EmptyWeightOfVehicle",
          "Type": "String",
          "Value": VehicleWeight.text
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
          clearVehicleDetailForm();
          Navigator.pop(context);
          GetVehicleDbHit(context,null);
        }



        updatevehicleLoader(false);
      });
    }catch(e){
      updatevehicleLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertVehicleDetail}" , e.toString());
    }


  }



  GetVehicleDbHit(BuildContext context,int vehicleId)  async{

    updatevehicleLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          //   "Value": "${Sp.getVehicleDetail}"
          "Value": "USP_GetVehicleDetail"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "VehicleId",
          "Type": "int",
          "Value": vehicleId
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
          print(parsed);


          if(vehicleId!=null){
            editVehicleId=t[0]['VehicleId'];
            VehicleNo.text=t[0]['VehicleNumber'];
            VehicleDescript.text=t[0]['VehicleDescription'];
            selectedVehicleTypeName=t[0]['VehicleTypeName'];
            selectedVehicleTypeId=t[0]['VehicleTypeId'];
            VehicleModel.text=t[0]['VehicleModel'];
            VehicleWeight.text=t[0]['EmptyWeightOfVehicle'];
          }
          else{
            vehicleGridList=t.map((e) => VehicleGridModel.fromJson(e)).toList();
          }

        }

        updatevehicleLoader(false);
      });
    }
    catch(e){
      updatevehicleLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getVehicleDetail}" , e.toString());
    }


  }



  bool isVehicleEdit=false;
  updateVehicleEdit(bool value){
    isVehicleEdit=value;
    notifyListeners();
  }
  bool vehicleLoader=false;
  updatevehicleLoader(bool value){
    vehicleLoader=value;
    notifyListeners();
  }

  clearVehicleDetailForm(){
    VehicleNo.clear();
    VehicleModel.clear();

    VehicleDescript.clear();
    VehicleWeight.clear();
    selectedVehicleTypeName=null;
    selectedVehicleTypeId=null;
  }

}


