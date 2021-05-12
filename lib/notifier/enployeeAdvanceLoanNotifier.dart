import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/employeeModel/empAdvanceLoan/empLoanAmountTypeModel.dart';
import 'package:quarry/model/employeeModel/empAdvanceLoan/empLoanEmployeeModel.dart';
import 'package:quarry/model/employeeModel/employeeAttendance/employeeAttendanceGridModel.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/widgets/alertDialog.dart';

import 'quarryNotifier.dart';

class EmployeeAdvanceLoanNotifier extends ChangeNotifier{

  final call=ApiManager();



  List<PlantUserModel> plantList=[];
  int plantCount=0;
  Future<dynamic>  PlantUserDropDownValues(BuildContext context) async {

    plantCount=0;
    updateEmployeeAttendanceLoader(true);
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

          var t=parsed['Table'] as List;
          var t1=parsed['Table1'] as List;
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


  List<EmpLoanEmployeeModel> empList=[];
  List<String> searchEmpList=[];
  List<EmpLoanAmountTypeModel> empAmountType=[];


  EmployeeDropDownValues(BuildContext context) async {
    updateEmployeeAttendanceLoader(true);
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
          "Value": "EmployeeAdvance"
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
        print(parsed);
        var t = parsed['Table'] as List;

        var t1= parsed['Table1'] as List;




        empList=t.map((e) => EmpLoanEmployeeModel.fromJson(e)).toList();
        empList.forEach((element) {
          searchEmpList.add(element.employeePrefix+element.employeeId);
        });



        updateEmployeeAttendanceLoader(false);
      });
    }
    catch (e) {
      updateEmployeeAttendanceLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}", e.toString());
    }
  }


  /* insert Form */
  var selectedEmployeeCode;
  TextEditingController employeeCodeController=new TextEditingController();


  String showEmpName="";
  String showEmpDesg="";
  String showEmpLoginInTime="";
  int showEmpId;

  DateTime selectedDate;
  TimeOfDay selectedTime;
  String  time;


  int logoutAttendanceId=null;


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

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isEmployeeLogin?"${Sp.insertEmployeeAttendanceDetail}": "${Sp.updateEmployeeAttendanceDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "EmployeeId",
          "Type": "int",
          "Value": showEmpId
        },
        {
          "Key": "EmployeeAttendanceDate",
          "Type": "String",
          "Value": DateFormat('yyyy-MM-dd').format(selectedDate)
        },
        {
          "Key": "EmployeeInTime",
          "Type": "String",
          "Value": "${selectedTime.hour}:${selectedTime.minute}"
        },
        {
          "Key": "EmployeeOutTime",
          "Type": "String",
          "Value": "${selectedTime.hour}:${selectedTime.minute}"
        },


        {
          "Key": "EmployeeAttendanceId",
          "Type": "int",
          "Value": logoutAttendanceId
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


  DateTime reportDate=null;

  int totalEmployee=0;
  int totalPresent=0;
  int totalAbsent=0;

  List<EmployeeAttendanceGridModel> EmployeeAttendanceGridList=[];
  List<String> employeeCode=[];


  GetEmployeeAttendanceIssueDbHit(BuildContext context,int EmployeeAttendanceId)  async{
    employeeCode.clear();
    updateEmployeeAttendanceLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getEmployeeAttendanceDetail}"
        },
        {
          "Key": "LoginEmployeeId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "EmployeeId",
          "Type": "int",
          "Value": EmployeeAttendanceId
        },
        {
          "Key": "Date",
          "Type": "String",
          "Value": reportDate==null?DateFormat("yyyy-MM-dd").format(DateTime.now()).toString():
          DateFormat("yyyy-MM-dd").format(reportDate).toString()
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
          if(EmployeeAttendanceId!=null ){

          }
          else{
            EmployeeAttendanceGridList=t.map((e) => EmployeeAttendanceGridModel.fromJson(e)).toList();
            totalEmployee=EmployeeAttendanceGridList.length;
            totalPresent=EmployeeAttendanceGridList.where((element) => element.status=='Present').toList().length;
            totalAbsent=EmployeeAttendanceGridList.where((element) => element.status=='Absent').toList().length;
            EmployeeAttendanceGridList.forEach((element) {
              employeeCode.add(element.employeePrefix+element.employeeCode);
            });
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