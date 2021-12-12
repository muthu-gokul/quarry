import 'dart:convert';
import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/employeeModel/employeeAttendance/employeeAttendanceGridModel.dart';
import 'package:quarry/model/parameterMode.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/styles/apiKeyConstants.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/widgets/alertDialog.dart';

import 'quarryNotifier.dart';

class EmployeeAttendanceNotifier extends ChangeNotifier{

  final call=ApiManager();



  List<PlantUserModel> plantList=[];
  int plantCount=0;
  Future<dynamic>  PlantUserDropDownValues(BuildContext context) async {
    plantCount=0;
    updateEmployeeAttendanceLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.MasterdropDown}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "TypeName", Type: "String", Value:"User"),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };
    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);

          var t=parsed[TABLE] as List?;
          var t1=parsed[TABLE1] as List;
          plantList=t1.map((e) => PlantUserModel.fromJson(e)).toList();
          plantList.forEach((element) {
            if(element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId){
              plantCount=plantCount+1;
           /*   if(!isEmployeeAttendanceEdit){
                *//* DP_PlantId=element.plantId;
                DP_PlantName=element.plantName;*//*
              }*/

            }
          });

        /*  if(!isEmployeeAttendanceEdit){
            if(plantCount!=1){
              *//*DP_PlantId=null;
              DP_PlantName=null;*//*
              plantList=plantList.where((element) => element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId).toList();
            }
          }*/

          print("plantCount$plantCount");

        }
        updateEmployeeAttendanceLoader(false);
      });
    }
    catch(e){
      updateEmployeeAttendanceLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }


  /* insert Form */
  var selectedEmployeeCode;
  TextEditingController employeeCodeController=new TextEditingController();


  String? showEmpName="";
  String? showEmpDesg="";
  String? showEmpLoginInTime="";
  int? showEmpId;

  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  String?  time;


  int? logoutAttendanceId=null;


  clearinsertForm(){
    selectedEmployeeCode=null;
    employeeCode.clear();
     showEmpName="";
     showEmpDesg="";
     showEmpLoginInTime="";
    employeeCodeController.clear();

    logoutAttendanceId=null;
  }

  insertForm(){
    selectedDate=DateTime.now();
    selectedTime=TimeOfDay.now();
    time = formatDate(
        DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
        [hh, ':', nn, " ", am]).toString();
  }


  InsertEmployeeAttendanceDbHit(BuildContext context)  async{
    updateEmployeeAttendanceLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: isEmployeeLogin?"${Sp.insertEmployeeAttendanceDetail}": "${Sp.updateEmployeeAttendanceDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "EmployeeId", Type: "int", Value:showEmpId),
      ParameterModel(Key: "EmployeeAttendanceDate", Type: "String", Value:DateFormat('yyyy-MM-dd').format(selectedDate)),
      ParameterModel(Key: "EmployeeInTime", Type: "String", Value:"${selectedTime.hour}:${selectedTime.minute}"),
      ParameterModel(Key: "EmployeeOutTime", Type: "String", Value:"${selectedTime.hour}:${selectedTime.minute}"),
      ParameterModel(Key: "EmployeeAttendanceId", Type: "int", Value:logoutAttendanceId),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!=null){
          var parsed=json.decode(value);


          Navigator.pop(context);
          GetEmployeeAttendanceIssueDbHit(context, null);
          clearinsertForm();

          //
        }

        updateEmployeeAttendanceLoader(false);
      });
    }catch(e){
      updateEmployeeAttendanceLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertEmployeeAttendanceDetail}" , e.toString());
    }


  }


  DateTime? reportDate=null;

  int totalEmployee=0;
  int totalPresent=0;
  int totalAbsent=0;

  List<EmployeeAttendanceGridModel> EmployeeAttendanceGridList=[];
  List<String> employeeCode=[];


  GetEmployeeAttendanceIssueDbHit(BuildContext context,int? EmployeeAttendanceId)  async{
  employeeCode.clear();
    updateEmployeeAttendanceLoader(true);
  parameters=[
    ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.getEmployeeAttendanceDetail}"),
    ParameterModel(Key: "LoginEmployeeId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
    ParameterModel(Key: "EmployeeId", Type: "int", Value:EmployeeAttendanceId),
    ParameterModel(Key: "Date", Type: "String", Value:reportDate==null?DateFormat("yyyy-MM-dd").format(DateTime.now()).toString():
    DateFormat("yyyy-MM-dd").format(reportDate!).toString()),
    ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
  ];
  log("${parameters.map((e) => e.toJson()).toList()}");
    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);
          var t=parsed[TABLE] as List?;
          log("$parsed");
          if(EmployeeAttendanceId!=null ){

          }
          else{
            EmployeeAttendanceGridList=t!.map((e) => EmployeeAttendanceGridModel.fromJson(e)).toList();
            totalEmployee=EmployeeAttendanceGridList.length;
            totalPresent=EmployeeAttendanceGridList.where((element) => element.status=='Present').toList().length;
            totalAbsent=EmployeeAttendanceGridList.where((element) => element.status=='Absent').toList().length;
            EmployeeAttendanceGridList.forEach((element) {
              employeeCode.add("${element.employeeName}  -  ${element.employeePrefix!+element.employeeCode!}");
            });
            print(employeeCode.length);
          }
        }

        updateEmployeeAttendanceLoader(false);
      });
    }catch(e){
      updateEmployeeAttendanceLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getEmployeeAttendanceDetail}" , e.toString());
    }


  }









  bool isEmployeeLogin=true;
  updateisEmployeeLogin(bool value){
    isEmployeeLogin=value;
    notifyListeners();
  }

  bool EmployeeAttendanceLoader=false;
  updateEmployeeAttendanceLoader(bool value){
    EmployeeAttendanceLoader=value;
    notifyListeners();
  }
}