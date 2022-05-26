import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/utils/utils.dart';

import '../api/sp.dart';
import '../model/parameterMode.dart';
import '../styles/constants.dart';
import '../widgets/alertDialog.dart';

errorLog(var error,var stackTrace, var title,var module,var appPage,var spName,{bool fromLogin=false,bool showAlert=true}) async{
  if(showAlert){
      CustomAlert().commonErrorAlert(Get.context!, title, "Contact Administration");
  }
  FirebaseCrashlytics.instance.recordError(error, stackTrace);

  parameters=[
    ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.errorLog}"),
    ParameterModel(Key: "Module", Type: "String", Value: module),
    ParameterModel(Key: "AppPage", Type: "String", Value: appPage),
    ParameterModel(Key: "SPName", Type: "String", Value: spName),
    ParameterModel(Key: "ErrorCode", Type: "String", Value: title),
    ParameterModel(Key: "ErrorMessage", Type: "String", Value: "$error Description: $stackTrace"),
    ParameterModel(Key: "AppVersion", Type: "String", Value: appVersion),
    ParameterModel(Key: "IsMobile", Type: "int", Value: 1),
  ];
  parameters.addAll( await getParameterEssential());
  if(fromLogin){
    parameters[parameters.length-1].Value="Geomine_QMS";
  }
  parameters.addAll( await getDeviceInfoParam());
  var body={
    "Fields": parameters.map((e) => e.toJson()).toList()
  };
  print("errorLog $body");

    ApiManager().ApiCallGetInvoke(body, Get.context!);


}