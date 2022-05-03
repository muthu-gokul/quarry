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
import 'package:quarry/model/parameterMode.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTableWithoutModel.dart';

import 'quarryNotifier.dart';

class EmployeeAdvanceLoanNotifier extends ChangeNotifier{

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

          var t=parsed['Table'] as List?;
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

  List<dynamic> amountTypeList=[];
  Future<dynamic> EmployeeAdvanceDropDownValues(BuildContext context) async {
    updateEmployeeAttendanceLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.MasterdropDown}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "TypeName", Type: "String", Value:"EmployeeAdvance"),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
    };

    try {
      await call.ApiCallGetInvoke(body, context).then((value) {
        var parsed = json.decode(value);

        var t = parsed['Table'] as List;

        var t1= parsed['Table1'] as List;


        t1.forEach((element) {
          element["isActive"]=true;
        });
        print(t1);
        
        amountTypeList=t1;




        empList=t.map((e) => EmpLoanEmployeeModel.fromJson(e)).toList();
        empList.forEach((element) {
          searchEmpList.add("${element.employeeName}  -  ${element.employeePrefix!+element.employeeCode!}");
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
  TextEditingController advanceAmountController=new TextEditingController();
  TextEditingController advanceReasonController=new TextEditingController();

  TextEditingController loanReasonController=new TextEditingController();
  TextEditingController loanAmountController=new TextEditingController();
  int? selectedMonthDue=null;
  double? emiAmount=0.0;

  List<dynamic> monthList=[{"Due":2},{"Due":3},{"Due":4},{"Due":5},{"Due":6},{"Due":7},{"Due":8},{"Due":9},{"Due":10},{"Due":11},{"Due":12}];

  clearAmount(){
    advanceAmountController.clear();
    advanceReasonController.clear();
    loanReasonController.clear();
    loanAmountController.clear();
    selectedMonthDue=null;
    emiAmount=0.0;
  }

  emiCalc(){
    if(loanAmountController.text.isEmpty){
      emiAmount=0.0;
    }
    else{
      if(selectedMonthDue==null){
        emiAmount=double.parse(loanAmountController.text);
      }else{
        emiAmount=Calculation().div(loanAmountController.text, selectedMonthDue);
      }
    }
    notifyListeners();
  }


  String? showEmpName="";
  String? showEmpDesg="";
  String showEmpLoginInTime="";
  String? showEmpWorkingDays="";
  String? showEmpLeaveDays="";
  double? showEmpNetPay=0.0;
  int? showEmpId;

  DateTime? selectedDate;
  late TimeOfDay selectedTime;
  String?  time;


  int? logoutAttendanceId=null;

  String? selectedAmountType=null;

  clearinsertForm(){
    selectedEmployeeCode=null;
    showEmpName="";
    showEmpDesg="";
    showEmpLoginInTime="";
     showEmpWorkingDays="";
     showEmpLeaveDays="";
     showEmpNetPay=0.0;
    employeeCodeController.clear();
    selectedAmountType=null;
    showEmpId=null;

    logoutAttendanceId=null;
    notifyListeners();
  }

  insertForm(){
    selectedDate=DateTime.now();
    selectedTime=TimeOfDay.now();
    time = formatDate(
        DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
        [hh, ':', nn, " ", am]).toString();
  }


  InsertEmployeeLoanAttendanceDbHit(BuildContext context)  async{
    updateEmployeeAttendanceLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: !isEdit?"${Sp.insertEmployeeAdvanceLoanDetail}": "${Sp.updateEmployeeAdvanceLoanDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "EmployeeId", Type: "int", Value:showEmpId),
      ParameterModel(Key: "AmountType", Type: "String", Value:selectedAmountType),
      ParameterModel(Key: "IsAdvance", Type: "int", Value:selectedAmountType=="Advance"?1:0),
      ParameterModel(Key: "AdvanceAmount", Type: "String", Value:advanceAmountController.text.isNotEmpty?double.parse(advanceAmountController.text):0.0),
      ParameterModel(Key: "IsLoan", Type: "int", Value:selectedAmountType=="Loan"?1:0),
      ParameterModel(Key: "LoanAmount", Type: "String", Value:loanAmountController.text.isNotEmpty?double.parse(loanAmountController.text):0.0),
      ParameterModel(Key: "LoanDueMonth", Type: "String", Value:selectedMonthDue),
      ParameterModel(Key: "LoanEMIAmount", Type: "String", Value:emiAmount),
      ParameterModel(Key: "Reason", Type: "String", Value:selectedAmountType=="Advance"?advanceReasonController.text:loanReasonController.text),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!=null){
          var parsed=json.decode(value);

          clearinsertForm();
          clearAmount();
          GetEmployeeAttendanceLoanDbHit(context, null);
          Navigator.pop(context);



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


  List<GridStyleModel3> gridDataRowList=[
    GridStyleModel3(columnName: "Date"),
    GridStyleModel3(columnName: "Employee Code"),
    GridStyleModel3(columnName: "Name"),
    GridStyleModel3(columnName: "Designation"),
    GridStyleModel3(columnName: "AmountType"),
    GridStyleModel3(columnName: "Amount",edgeInsets: EdgeInsets.only(left: 0),width: 180),
  ];
  List<dynamic>? gridData=[];

  GetEmployeeAttendanceLoanDbHit(BuildContext context,int? EmployeeId)  async{

    updateEmployeeAttendanceLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.getEmployeeAdvanceLoanDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "EmployeeId", Type: "int", Value:EmployeeId),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);
          var t=parsed['Table'] as List?;

          if(EmployeeId!=null ){
            showEmpId=t![0]['EmployeeId'];
            selectedEmployeeCode="${t[0]['Name']} - ${t[0]['Employee Code']}";
            employeeCodeController.text="${t[0]['Name']} - ${t[0]['Employee Code']}";
            showEmpDesg=t[0]['Designation'];
            selectedAmountType=t[0]['AmountType'];
            if(t[0]['IsAdvance']==1){
              advanceReasonController.text=t[0]['Reason'];
              advanceAmountController.text=t[0]['Amount'].toString();
            }
            if(t[0]['IsLoan']==1){
              loanReasonController.text=t[0]['Reason'];
              loanAmountController.text=t[0]['LoanAmount'].toString();
              selectedMonthDue=t[0]['DueMonth'];
              emiAmount=t[0]['LoanEMI/Month'];
            }





          }
          else{
            gridData=t;
          }
        }

        updateEmployeeAttendanceLoader(false);
      });
    }catch(e){
      updateEmployeeAttendanceLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getEmployeeAdvanceLoanDetail}" , e.toString());
    }


  }









  bool isEdit=false;
  updateisEdit(bool value){
    isEdit=value;
    notifyListeners();
  }

  bool EmployeeAttendanceLoader=false;
  updateEmployeeAttendanceLoader(bool value){
    EmployeeAttendanceLoader=value;
    notifyListeners();
  }


  clearAll(){
    clearinsertForm();
    gridData=[];
    empList=[];
    searchEmpList=[];
    empAmountType=[];
    amountTypeList=[];
  }

}