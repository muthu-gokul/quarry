import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/model/parameterMode.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/widgets/alertDialog.dart';

class UserAccessNotifier extends ChangeNotifier{
  final call=ApiManager();

  List<dynamic> moduleList=[];

  Future<dynamic> getUserAccess(BuildContext context) async {
    updateisLoad(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "USP_GetUserAccess"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };
    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!='F'){
          var parsed=json.decode(value);
          log("$parsed");
          moduleList=parsed['Table']  as List;
          updateisLoad(false);
          notifyListeners();
        }
        else{
          updateisLoad(false);
        }
      });
    }
    catch(e,t){
      updateisLoad(false);
      CustomAlert().commonErrorAlert(context, "Uer Access40" , t.toString());
    }
  }
  Future<dynamic> updateUserAccess(BuildContext context,int moduleId,int userGroupId,int isAccess) async {
    updateisLoad(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "USP_UpdateUserAccess"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "ModuleId", Type: "int", Value: moduleId),
      ParameterModel(Key: "UserGroupId", Type: "int", Value: userGroupId),
      ParameterModel(Key: "IsAccess", Type: "int", Value: isAccess==1?0:1),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };
    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!='F'){
          getUserAccess(context);
        }
        else{
          updateisLoad(false);
        }
      });
    }
    catch(e,t){
      updateisLoad(false);
      CustomAlert().commonErrorAlert(context, "Uer Access40" , t.toString());
    }
  }

bool isLoad=false;
  updateisLoad(bool value){
    isLoad=value;
    notifyListeners();
  }

}