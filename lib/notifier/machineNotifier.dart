import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/machineDetailsModel/machineGridModel.dart';
import 'package:quarry/model/parameterMode.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/widgets/alertDialog.dart';

class MachineNotifier extends ChangeNotifier{

  List<String>machineGridCol=["MachineName","Type","Model","Specification"];
  List< MachineGridModel> machineGridList=[];


  TextEditingController MachineName=new TextEditingController();
  TextEditingController MachineType=new TextEditingController();
  TextEditingController MachineModel=new TextEditingController();
  TextEditingController MachineSpecification=new TextEditingController();
  TextEditingController Capacity=new TextEditingController();
  TextEditingController MoterPower=new TextEditingController();


  int? editMachineId=null;

  final call=ApiManager();

  InsertVehicleDbHit(BuildContext context)  async{
    updatemachineLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: isMachineEdit?"${Sp.updateMachineDetail}" :"${Sp.insertMachineDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "MachineName", Type: "String", Value: MachineName.text),
      ParameterModel(Key: "MachineType", Type: "String", Value: MachineType.text),
      ParameterModel(Key: "MachineModel", Type: "String", Value: MachineModel.text),
      ParameterModel(Key: "Capacity", Type: "String", Value: Capacity.text),
      ParameterModel(Key: "MotorPower", Type: "String", Value: MoterPower.text),
      ParameterModel(Key: "MachineSpecification", Type: "String", Value: MachineSpecification.text),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    if(isMachineEdit){
      parameters.insert(2, ParameterModel(Key: "MachineId", Type: "int", Value: editMachineId));
    }
    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
    };
    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!="null"){
          var parsed=json.decode(value);
          print(parsed);
          clearMachineDetailForm();
          Navigator.pop(context);
          GetMachineDbHit(context,null);
        }
        else{
          updatemachineLoader(false);
        }




      });
    }catch(e){
      updatemachineLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertMachineDetail}" , e.toString());
    }


  }

  GetMachineDbHit(BuildContext context,int? machineId)  async{

    updatemachineLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.getMachineDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "MachineId", Type: "int", Value: machineId),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
    };


    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!="null"){
          var parsed=json.decode(value);
          var t=parsed['Table'] as List?;
          print(parsed);


          if(machineId!=null){
            editMachineId=t![0]['MachineId'];
            MachineName.text=t[0]['MachineName'];
            MachineType.text=t[0]['MachineType'];
            MachineModel.text=t[0]['MachineModel'];
            Capacity.text=t[0]['Capacity'].toString();
            MoterPower.text=t[0]['MotorPower'].toString();
            MachineSpecification.text=t[0]['MachineSpecification'].toString();

          }
          else{
            machineGridList=t!.map((e) =>  MachineGridModel.fromJson(e)).toList();
          }

        }

        updatemachineLoader(false);
      });
    }
    catch(e){
      updatemachineLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getMachineDetail}" , e.toString());
    }



  }

  bool isMachineEdit=false;
  updateMachineEdit(bool value){
    isMachineEdit=value;
    notifyListeners();
  }
  bool machineLoader=false;
  updatemachineLoader(bool value){
    machineLoader=value;
    notifyListeners();
  }

  clearMachineDetailForm(){
    MachineName.clear();
    MachineType.clear();
    MachineModel.clear();
    MachineSpecification.clear();
    Capacity.clear();
    MoterPower.clear();

  }

}