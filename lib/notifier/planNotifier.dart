import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:quarry/utils/errorLog.dart';

import '../api/ApiManager.dart';
import '../api/sp.dart';
import '../model/parameterMode.dart';
import '../model/plantModel/plantUserModel.dart';
import '../styles/constants.dart';
import '../utils/utils.dart';
import '../widgets/alertDialog.dart';

class PlanNotifier extends GetxController{


  final call=ApiManager();


  var plantList=[].obs;
  var planList=[].obs;
  String page="ActivateRequest";
  String module="PlanDetail";
  var selectPlantId="".obs;
  var selectPlantName="".obs;
  var planId="".obs;
  var planName="".obs;
  var noOfDays="".obs;

  init(){
    getPlantList();
    getPlanList();
  }

  getPlantList() async{
    var response=await getMasterDrpWeb(page, "PlantId", null, null);
    print("getPlantList $response");
    if(response!="null" && response!=''){
      try{
        var parsed=jsonDecode(response);
        var table=parsed['Table'] as List;
        plantList.value=table;
        if(plantList.length>0){
          selectPlantId.value=plantList[0]['Id'].toString();
          selectPlantName.value=plantList[0]['Text'];
          getActivationDetail();
        }
      }catch(e,stackTrace){
        isLoad.value=false;
        errorLog("PL02 ${e.toString()}", stackTrace,"Error PL02",module,page,"getMasterDrpWeb_PlantId");
      }
    }
  }

  getPlanList() async{
    var response=await getMasterDrpWeb(page, "PlanId", null, null);
    print("getPlanList $response");
    if(response!="null" && response!=''){
      try{
        var parsed=jsonDecode(response);
        var table=parsed['Table'] as List;
        planList.value=table;

      }catch(e,stackTrace){
        isLoad.value=false;
        errorLog("PL03 ${e.toString()}", stackTrace,"Error PL03",module,page,"getMasterDrpWeb_PlanId");
      }
    }
  }


  insertPlan(var id,var planId,var days,String msg) async{
    isLoad.value=true;

    List parameters= await getParameterEssential();
    parameters.add(ParameterModel(Key: "SpName", Type: "string", Value: "USP_Web_InsertPlantActivationRequestDetail"));
    parameters.add(ParameterModel(Key: "PlantPlanActivationMappingId", Type: "String", Value: id));
    parameters.add(ParameterModel(Key: "PlantId", Type: "String", Value: selectPlantId.value));
    parameters.add(ParameterModel(Key: "PlanId", Type: "String", Value: planId));
    parameters.add(ParameterModel(Key: "NumberOfDays", Type: "String", Value: days));

    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
    };
    try{
      await ApiManager().ApiCallGetInvoke(body,Get.context!).then((value) {
        isLoad.value=false;
        if(value!="null"){
          CustomAlert().billSuccessAlert(Get.context!, "", msg, "", "");
          getActivationDetail();
        }
      });
    }
    catch(e,stackTrace){
      isLoad.value=false;
      errorLog("PL04 ${e.toString()}", stackTrace,"Error PL04",module,page,"USP_Web_InsertPlantActivationRequestDetail");
      //CustomAlert().commonErrorAlert(Get.context!, "Error G01", "Contact Administration");
    }
  }


  RxnString planName_T= RxnString();
  RxnString description_T= RxnString();
  RxnString startDate_T= RxnString();
  RxnString endDate_T= RxnString();
  RxnString status_T= RxnString();
  RxnString paymentDate_T= RxnString();
  RxnString paymentStatus_T= RxnString();
  RxnInt id_T= RxnInt();
  RxnInt planId_T= RxnInt();
  RxnString days_T= RxnString();

  clearTable(){
    planName_T.value="Plan Name";
    description_T.value="";
    startDate_T.value="";
    endDate_T.value="";
    status_T.value="";
    paymentDate_T.value="";
    paymentStatus_T.value="";
    id_T.value=null;
    planId_T.value=null;
    days_T.value="";
  }

  List<String> gridHeader=["Plan Name","No Of Days","Start Date","End Date","Payment Date","Payment Status","Status"];
  List<String> gridDataName=["PlanName","NumberOfDays","PlanStartDate","PlanEndDate","PaymentDate","PaymentStatus","Status"];
  var gridData=[].obs;

  getActivationDetail() async{
    isLoad.value=true;
    List parameters= await getParameterEssential();
    parameters.add(ParameterModel(Key: "SpName", Type: "string", Value: "USP_Web_GetPlantActivationDetail"));
    parameters.add(ParameterModel(Key: "PlantId", Type: "String", Value: selectPlantId.value));

    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
    };
    try{
      await ApiManager().ApiCallGetInvoke(body,Get.context!).then((value) {
        isLoad.value=false;
        if(value!="null"){
          print(value);
          var parsed=jsonDecode(value);
          var table =parsed['Table'] as List;
          var table1 =parsed['Table1'] as List;
          clearTable();
          if(table.length>0){
            planName_T.value=table[0]['PlanName'];
            description_T.value=table[0]['LicenseDescription'];
            startDate_T.value=table[0]['PlanStartDate'];
            endDate_T.value=table[0]['PlanEndDate'];
            status_T.value=table[0]['Status'];
            paymentDate_T.value=table[0]['PaymentDate'];
            paymentStatus_T.value=table[0]['PaymentStatus'];
            id_T.value=table[0]['PlantPlanActivationMappingId'];
            planId_T.value=table[0]['PlanId'];
            days_T.value=table[0]['NumberOfDays'].toString();
          }
          gridData.value=table1;
        }
      });
    }
    catch(e,stackTrace){
      errorLog("PL01 ${e.toString()}", stackTrace,"Error PL01",module,page,"USP_Web_GetPlantActivationDetail");
      isLoad.value=false;
    }
  }


  var isLoad=false.obs;



}