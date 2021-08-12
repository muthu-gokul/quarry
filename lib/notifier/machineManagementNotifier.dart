import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTableWithoutModel.dart';

import 'profileNotifier.dart';

class MachineManagementNotifier extends ChangeNotifier{

  final call=ApiManager();



  List<PlantUserModel> plantList=[];
  int plantCount=0;
  Future<dynamic>  PlantUserDropDownValues(BuildContext context) async {

    plantCount=0;
    updateMachineManagementLoader(true);
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
                 if(!machineManagementEdit){
                 PlantId=element.plantId;
                 PlantName=element.plantName;
              }

            }
          });

            if(!machineManagementEdit){
            if(plantCount!=1){
              PlantId=null;
              PlantName=null;
              plantList=plantList.where((element) => element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId).toList();
            }
          }

          print("plantCount$plantCount");

        }
        updateMachineManagementLoader(false);
      });
    }
    catch(e){
      updateMachineManagementLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


  List<dynamic>? machineList=[];
  List<dynamic>? reponsiblePersonList=[];

  Future<dynamic> MachineManagementDropDownValues(BuildContext context) async {
    updateMachineManagementLoader(true);
    var body = {
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.MasterdropDown}"
        },

        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value":  Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "TypeName",
          "Type": "String",
          "Value": "MachineManagement"
        },
        {
          "Key": "database",
          "Type": "String",
          "Value":  Provider.of<QuarryNotifier>(context,listen: false).DataBaseName
        }
      ]
    };

    try {
      await call.ApiCallGetInvoke(body, context).then((value) {
        var parsed = json.decode(value);

        var t = parsed['Table'] as List?;

        var t1= parsed['Table1'] as List?;
        machineList=t;
        reponsiblePersonList=t1;

        updateMachineManagementLoader(false);
      });
    }
    catch (e) {
      updateMachineManagementLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}", e.toString());
    }
  }
  
  
  


  /*      inserrt form                */

  int? PlantId;
  String? PlantName;

  int? selectedMachineId=null;
  String? selectedMachineName=null;
  String? selectedMachineModel=null;

  int? selectedPersonId=null;
  String? selectedPersonName=null;

  TextEditingController operatorName =new TextEditingController();
  TextEditingController operatorNo =new TextEditingController();
  TextEditingController reason =new TextEditingController();
  DateTime? MachineServicedate;

  TimeOfDay? InTime;
  String? inTime;
  TimeOfDay? OutTime;
  String? outTime;

  int? editMachineManagementId;

  clearInsertForm(){
     selectedMachineId=null;
     selectedMachineName=null;
     selectedMachineModel=null;
      selectedPersonId=null;
      selectedPersonName=null;
     InTime=null;
     inTime=null;
     OutTime=null;
     outTime=null;

     operatorName.clear();
     operatorNo.clear();
     reason.clear();
  }

  InsertMachineManagementDbHit(BuildContext context)  async{
    updateMachineManagementLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": machineManagementEdit?"${Sp.updateMachineManagementDetail}":"${Sp.insertMachineManagementDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "MachineId",
          "Type": "int",
          "Value": selectedMachineId
        },
        {
          "Key": "MachineManagementId",
          "Type": "int",
          "Value": editMachineManagementId
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": PlantId
        },
        {
          "Key": "OperatorName",
          "Type": "String",
          "Value": operatorName.text
        },
        {
          "Key": "OperatorContactNumber",
          "Type": "String",
          "Value": operatorNo.text
        },
        {
          "Key": "MachineServicedate",
          "Type": "String",
          "Value":MachineServicedate==null?DateFormat("yyyy-MM-dd").format(DateTime.now()) :DateFormat("yyyy-MM-dd").format(MachineServicedate!)
        },
        {
          "Key": "OperatorInTime",
          "Type": "String",
          "Value": InTime!=null?"${InTime!.hour}:${InTime!.minute}":null
        },

        {
          "Key": "OperatorOutTime",
          "Type": "String",
          "Value": OutTime!=null?"${OutTime!.hour}:${OutTime!.minute}":null
        },
        {
          "Key": "Reason",
          "Type": "String",
          "Value": reason.text
        },
        {
          "Key": "ResponsibleEmployeeId",
          "Type": "int",
          "Value": selectedPersonId
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

          clearInsertForm();
   
          GetMachineManagementDbHit(context, null,null);
          Navigator.pop(context);



          //
        }

        updateMachineManagementLoader(false);
      });
    }catch(e){
      updateMachineManagementLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertEmployeeAttendanceDetail}" , e.toString());
    }


  }








  List<GridStyleModel3> gridDataRowList=[
    GridStyleModel3(columnName: "Machine Name"),
    GridStyleModel3(columnName: "Machine Model"),
    GridStyleModel3(columnName: "Operator Name"),
    GridStyleModel3(columnName: "Service Date"),
    GridStyleModel3(columnName: "Operator InTime"),
    GridStyleModel3(columnName: "Operator OutTime"),
    GridStyleModel3(columnName: "Reason"),
    GridStyleModel3(columnName: "Responsible Person"),


  ];
  List<dynamic> gridData=[];
  List<dynamic>? filterGridData=[];
  List<DateTime?> picked=[];
  List<ManageUserPlantModel> filterUsersPlantList=[];
  GetMachineManagementDbHit(BuildContext context,int? MachineManagementId,int? MachineId)  async{


    updateMachineManagementLoader(true);
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
          "Value": "${Sp.getMachineManagementDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "MachineManagementId",
          "Type": "int",
          "Value": MachineManagementId
        },
        {
          "Key": "MachineId",
          "Type": "int",
          "Value": MachineId
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

    try{

      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          if(filterUsersPlantList.isEmpty){

            Provider.of<ProfileNotifier>(context, listen: false).usersPlantList.forEach((element) {
              filterUsersPlantList.add(ManageUserPlantModel(
                plantId: element.plantId,
                plantName: element.plantName,
                isActive: element.isActive,
              ));
            });

          } else if(filterUsersPlantList.length!=Provider.of<ProfileNotifier>(context, listen: false).usersPlantList.length){
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

          if(MachineManagementId!=null && MachineId!=null ){
            PlantId=t![0]['PlantId'];
            PlantName=t[0]['PlantName'];
            editMachineManagementId=t[0]['MachineManagementId'];
            selectedMachineId=t[0]['MachineId'];
            selectedMachineName=t[0]['MachineName'];
            selectedMachineModel=t[0]['MachineModel'];
            selectedPersonId=t[0]['ResponsibleEmployeeId'];
            selectedPersonName=t[0]['ResponsiblePerson'];
            operatorName.text=t[0]['OperatorName'];
            operatorNo.text=t[0]['OperatorContactNumber']==null?"":t[0]['OperatorContactNumber'];
            reason.text=t[0]['Reason'];
            MachineServicedate=DateTime.parse(t[0]['MachineServiceDate']);
            InTime=TimeOfDay(hour: int.parse(t[0]['DBInTime'].split(":")[0]), minute: int.parse(t[0]['DBInTime'].split(":")[1]));
            inTime=t[0]['OperatorInTime'];
            if(t[0]['DBOutTime']!=null){
              OutTime=TimeOfDay(hour: int.parse(t[0]['DBOutTime'].split(":")[0]), minute: int.parse(t[0]['DBOutTime'].split(":")[1]));
              outTime=t[0]['OperatorOutTime'];
            }


          }
          else{
            filterGridData=t;
            filterMachineGrid();

          }
        }

        updateMachineManagementLoader(false);
      });
    }catch(e){
      updateMachineManagementLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getMachineManagementDetail}" , e.toString());
    }
  }

  filterMachineGrid(){
    gridData.clear();

    filterUsersPlantList.forEach((element) {
      if(element.isActive!){
        gridData=gridData+filterGridData!.where((ele) => ele['PlantId']==element.plantId).toList();
      }
    });

    notifyListeners();
  }
  
  
  
  
  

  bool machineManagementEdit=false;
  updateMachineManagementEdit(bool value){
    machineManagementEdit=value;
    notifyListeners();
  }


  bool machineManagementLoader=false;
  updateMachineManagementLoader(bool value){
    machineManagementLoader=value;
    notifyListeners();
  }
}