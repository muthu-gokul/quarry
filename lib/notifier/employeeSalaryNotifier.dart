import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';
import 'package:quarry/widgets/staticColumnScroll/customDataTableWithoutModel.dart';

class EmployeeSalaryNotifier extends ChangeNotifier{


  final call=ApiManager();



  List<PlantUserModel> plantList=[];
  int plantCount=0;
  Future<dynamic>  PlantUserDropDownValues(BuildContext context) async {

    plantCount=0;
    updateEmployeeSalaryLoader(true);
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
        updateEmployeeSalaryLoader(false);
      });
    }
    catch(e){
      updateEmployeeSalaryLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }

  TextEditingController employeeCodeController =new TextEditingController();
  List<String> searchEmpList=[];

  double totalSalary=0.0;
  int totalEmployees=0;
  double totalNetPay=0.0;

  int showEmpId=null;
  int showNumberOfWorkingDays=null;
  int TotalPresentDays=null;
  int IsPaid=null;
  String showEmpName="";
  String showEmpDesg="";
  String showEmpShift="";
  String showEmpMonthlySalary="";
  String showEmpPresentDay="";
  String showEmpEarnedSalary="";
  String showEmpOvertime="";
  String showEmpAdvanceAmount="";
  String showEmpEMI="";
  String showEmpNetPay="";



clearInsertForm(){
  employeeCodeController.clear();
   showEmpId=null;
   showNumberOfWorkingDays=null;
   TotalPresentDays=null;
   IsPaid=null;
   showEmpName="";
   showEmpDesg="";
   showEmpShift="";
   showEmpMonthlySalary="";
   showEmpPresentDay="";
   showEmpEarnedSalary="";
   showEmpOvertime="";
   showEmpAdvanceAmount="";
   showEmpEMI="";
   showEmpNetPay="";
}







  InsertEmployeeSalaryDbHit(BuildContext context)  async{
    updateEmployeeSalaryLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "USP_InsertEmployeeSalaryDetail"
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
          "Key": "NumberOfWorkingDays",
          "Type": "int",
          "Value": TotalPresentDays
        },
        {
          "Key": "EarnedSalary",
          "Type": "String",
          "Value": double.parse(showEmpEarnedSalary)
        },

        {
          "Key": "OverTimeSalary",
          "Type": "String",
          "Value": double.parse(showEmpOvertime)
        },
        {
          "Key": "AdvancedAmount",
          "Type": "String",
          "Value": double.parse(showEmpAdvanceAmount)
        },
        {
          "Key": "LoanEMI",
          "Type": "String",
          "Value": double.parse(showEmpEMI)
        },

        {
          "Key": "NetPay",
          "Type": "String",
          "Value": double.parse(showEmpNetPay)
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
          GetEmployeeSalaryDbHit(context, null);
          Navigator.pop(context);



          //
        }

        updateEmployeeSalaryLoader(false);
      });
    }catch(e){
      updateEmployeeSalaryLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertEmployeeAttendanceDetail}" , e.toString());
    }


  }
  


  List<GridStyleModel3> gridDataRowList=[
    GridStyleModel3(columnName: "Employee Code"),
    GridStyleModel3(columnName: "Name"),
    GridStyleModel3(columnName: "Designation"),
    GridStyleModel3(columnName: "Type"),
    GridStyleModel3(columnName: "Shift"),
    GridStyleModel3(columnName: "Monthly Salary"),
    GridStyleModel3(columnName: "Present Days"),
    GridStyleModel3(columnName: "Earned Salary"),
    GridStyleModel3(columnName: "OT"),
    GridStyleModel3(columnName: "Advance/Loan"),
    GridStyleModel3(columnName: "NetPay"),

  ];
  List<dynamic> gridData=[];
  GetEmployeeSalaryDbHit(BuildContext context,int EmployeeId)  async{

    totalSalary=0.0;
    totalEmployees=0;
    totalNetPay=0.0;
    searchEmpList.clear();
    updateEmployeeSalaryLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getEmployeeSalaryLoanDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "EmployeeId",
          "Type": "int",
          "Value": EmployeeId
        },
        {
          "Key": "FromDate",
          "Type": "String",
          "Value": "2021-05-06"
        },
        {
          "Key": "ToDate",
          "Type": "String",
          "Value":"2021-05-06"
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
          print(parsed['Table']);

          if(EmployeeId!=null ){
            showEmpId=t[0]['EmployeeId'];
            showEmpName=t[0]['Name'];
            showEmpDesg=t[0]['Designation'];
            showEmpShift=t[0]['Shift'];
            showEmpMonthlySalary=t[0]['Monthly Salary'].toString();
            showEmpEarnedSalary=t[0]['Earned Salary'].toString();
            showEmpPresentDay=t[0]['Present Days'];
            TotalPresentDays=t[0]['TotalPresentDays'];
            showEmpOvertime=t[0]['OT'].toString();
            showEmpAdvanceAmount=t[0]['Advance/Loan'].toString();
            showEmpNetPay=t[0]['NetPay'].toString();
            showEmpEMI=t[0]['LoanEMIAmount'].toString();
            IsPaid=t[0]['IsPaid'];
          }
          else{
            gridData=t;
            totalEmployees=gridData.length;
            gridData.forEach((element) { 
              totalSalary=Calculation().add(totalSalary, element['Monthly Salary']);
              totalNetPay=Calculation().add(totalNetPay, element['NetPay']);
              searchEmpList.add("${element['Name']}  -  ${element['Employee Code']}");
            });
          }
        }

        updateEmployeeSalaryLoader(false);
      });
    }catch(e){
      updateEmployeeSalaryLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getEmployeeSalaryLoanDetail}" , e.toString());
    }


  }



  bool employeeSalaryLoader=false;
  updateEmployeeSalaryLoader(bool value){
    employeeSalaryLoader=value;
    notifyListeners();
  }
}