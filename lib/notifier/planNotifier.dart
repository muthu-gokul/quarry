import 'dart:convert';

import 'package:get/get.dart';

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
      }catch(e){

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
      }catch(e){

      }
    }
  }


  insertPlan(var id,var planId,var days,String msg) async{
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
        if(value!="null"){
          CustomAlert().billSuccessAlert(Get.context!, "", msg, "", "");
        }
      });

    }
    catch(e){
      //CustomAlert().commonErrorAlert(Get.context!, "Error G01", "Contact Administration");
    }
  }

}