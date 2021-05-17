import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/employeeModel/employeeBloodGroupModel.dart';
import 'package:quarry/model/employeeModel/employeeDesginationModel.dart';
import 'package:quarry/model/employeeModel/employeeGridModel.dart';
import 'package:quarry/model/employeeModel/employeeMartialStatusModel.dart';
import 'package:quarry/model/employeeModel/employeePaymentTypeModel.dart';
import 'package:quarry/model/employeeModel/employeeSalaryType.dart';
import 'package:quarry/model/employeeModel/employeeShiftModel.dart';
import 'package:quarry/model/employeeModel/employeeTypeModel.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/widgets/alertDialog.dart';

import 'quarryNotifier.dart';

class EmployeeNotifier extends ChangeNotifier{

  final call=ApiManager();



  List<PlantUserModel> plantList=[];
  int plantCount=0;
  Future<dynamic>  PlantUserDropDownValues(BuildContext context) async {

    plantCount=0;
    updateEmployeeLoader(true);
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
              if(!isEmployeeEdit){
               /* DP_PlantId=element.plantId;
                DP_PlantName=element.plantName;*/
              }
             
            }
          });

          if(!isEmployeeEdit){
            if(plantCount!=1){
              /*DP_PlantId=null;
              DP_PlantName=null;*/
              plantList=plantList.where((element) => element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId).toList();
            }
          }
         
          print("plantCount$plantCount");

        }
        updateEmployeeLoader(false);
      });
    }
    catch(e){
      updateEmployeeLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }

  List<EmployeeDesignationModel> employeeDesginationList=[];
  List<EmployeeTypeModel> employeeTypeList=[];
  List<EmployeeShiftModel> employeeShiftList=[];
  List<EmployeeSalaryTypeModel> employeeSalaryTypeList=[];
  List<EmployeeBloodGroupModel> employeeBloodGroupList=[];
  List<EmployeeMartialStatusModel> employeeMartialStatusList=[];
  List<EmployeePaymentTypeModel> employeePaymentTypeList=[];


  EmployeeDropDownValues(BuildContext context) async {
    updateEmployeeLoader(true);
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
          "Value": "Employee"
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

        var t2= parsed['Table2'] as List;

        var t3= parsed['Table3'] as List;

        var t4= parsed['Table4'] as List;

        var t5= parsed['Table5'] as List;

        var t6= parsed['Table6'] as List;
        var t7= parsed['Table7'] as List;



        employeeDesginationList=t.map((e) => EmployeeDesignationModel.fromJson(e)).toList();
        employeeTypeList=t1.map((e) => EmployeeTypeModel.fromJson(e)).toList();
        employeeShiftList=t2.map((e) => EmployeeShiftModel.fromJson(e)).toList();
        employeeSalaryTypeList=t3.map((e) => EmployeeSalaryTypeModel.fromJson(e)).toList();
        employeeBloodGroupList=t4.map((e) => EmployeeBloodGroupModel.fromJson(e)).toList();
        employeeMartialStatusList=t5.map((e) => EmployeeMartialStatusModel.fromJson(e)).toList();
        employeePaymentTypeList=t6.map((e) => EmployeePaymentTypeModel.fromJson(e)).toList();

        if(!isEmployeeEdit){
          selectSalaryTypeId=employeeSalaryTypeList[2].employeeSalaryTypeId;
          selectSalaryTypeName=employeeSalaryTypeList[2].employeeSalaryTypeName;
          EmployeePrefix=t7[0]['EmployeePrefix'];
          EmployeeCode=t7[0]['EmployeeCode'];
          print("EmployeeCode$EmployeeCode");

        }

        updateEmployeeLoader(false);
      });
    }
    catch (e) {
      updateEmployeeLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}", e.toString());
    }
  }

 /* insert Form */

  String EmployeePrefix="";
  String EmployeeCode="";

  int selectEmployeeDesignationId = null;
  String selectEmployeeDesignationName = null;

  int selectEmployeeTypeId = null;
  String selectEmployeeTypeName = null;

  int selectShiftId = null;
  String selectShiftName = null;

  int selectBloodGroupId = null;
  String selectBloodGroupName = null;

  int selectMartialStatusId = null;
  String selectMartialStatusName = null;

  int selectPaymentMethodId = null;
  String selectPaymentMethodName = null;

  int selectSalaryTypeId = null;
  String selectSalaryTypeName = null;


  String selectedSalutation="Mr";
  TextEditingController employeeFirstName=new TextEditingController();
  TextEditingController employeeLastName=new TextEditingController();
  TextEditingController employeeSalary=new TextEditingController();

  TextEditingController employeePhoneNumber=new TextEditingController();
  TextEditingController employeeEmail=new TextEditingController();
  TextEditingController employeeAddress=new TextEditingController();
  TextEditingController employeeCity=new TextEditingController();
  TextEditingController employeeState=new TextEditingController();
  TextEditingController employeeCountry=new TextEditingController();
  TextEditingController employeeZipcode=new TextEditingController();


  TextEditingController employeeReferredBy=new TextEditingController();
  TextEditingController employeeRemarks=new TextEditingController();
  TextEditingController employeeAadhaarNo=new TextEditingController();
  TextEditingController employeePanNo=new TextEditingController();

  TextEditingController employeeHolderName=new TextEditingController();
  TextEditingController employeeBankName=new TextEditingController();
  TextEditingController employeeAccNo=new TextEditingController();
  TextEditingController employeeBranchName=new TextEditingController();
  TextEditingController employeeIFSC=new TextEditingController();



  DateTime joiningDate;
  DateTime dob;

/*  insertForm(){
    joiningDate=DateTime.now();
    dob=DateTime.now();
  }*/


  int editEmployeeId;

  clearInsertForm(){
    editEmployeeId=null;
    selectedSalutation="Mr";
    employeeFirstName.clear();
    employeeLastName.clear();
    joiningDate=null;
    dob=null;
    employeeAddress.clear();
    employeeAadhaarNo.clear();
    employeePhoneNumber.clear();
    employeeSalary.clear();
    employeeIFSC.clear();
    employeeBranchName.clear();
    employeeAccNo.clear();
    employeeBranchName.clear();
    employeePanNo.clear();
    employeeRemarks.clear();
    employeeReferredBy.clear();
    employeeZipcode.clear();
    employeeState.clear();
    employeeCity.clear();
    employeeEmail.clear();
    employeeBankName.clear();
    employeeHolderName.clear();

     selectEmployeeDesignationId = null;
     selectEmployeeDesignationName = null;

     selectEmployeeTypeId = null;
     selectEmployeeTypeName = null;

     selectShiftId = null;
     selectShiftName = null;

     selectBloodGroupId = null;
     selectBloodGroupName = null;

     selectMartialStatusId = null;
     selectMartialStatusName = null;

     selectPaymentMethodId = null;
     selectPaymentMethodName = null;

     selectSalaryTypeId = null;
     selectSalaryTypeName = null;
  }

  InsertEmployeeDbHit(BuildContext context)  async{
    updateEmployeeLoader(true);


    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isEmployeeEdit?"${Sp.updateEmployeeDetail}": "${Sp.insertEmployeeDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "EmployeeId",
          "Type": "int",
          "Value": editEmployeeId
        },
        {
          "Key": "EmployeeCode",
          "Type": "String",
          "Value": EmployeeCode
        },
        {
          "Key": "EmployeeSalutation",
          "Type": "String",
          "Value": selectedSalutation
        },
        {
          "Key": "EmployeeFirstName",
          "Type": "String",
          "Value": employeeFirstName.text
        },
        {
          "Key": "EmployeeLastName",
          "Type": "String",
          "Value": employeeLastName.text
        },
        {
          "Key": "EmployeePassword",
          "Type": "String",
          "Value": ""
        },
        {
          "Key": "EmployeeDesignationId",
          "Type": "int",
          "Value": selectEmployeeDesignationId
        },
        {
          "Key": "EmployeeTypeId",
          "Type": "int",
          "Value": selectEmployeeTypeId
        },
        {
          "Key": "EmployeeShiftId",
          "Type": "int",
          "Value": selectShiftId
        },
        {
          "Key": "EmployeeDateOfJoin",
          "Type": "String",
          "Value": joiningDate!=null?DateFormat("yyyy-MM-dd").format(joiningDate):null
        },
        {
          "Key": "EmployeeSalary",
          "Type": "String",
          "Value": employeeSalary.text.isNotEmpty?double.parse(employeeSalary.text):0.0
        },
        {
          "Key": "EmployeeSalaryTypeId",
          "Type": "int",
          "Value": selectSalaryTypeId
        },
        {
          "Key": "EmployeeContactNumber",
          "Type": "String",
          "Value": employeePhoneNumber.text
        },
        {
          "Key": "EmployeeEmail",
          "Type": "String",
          "Value": employeeEmail.text
        },
        {
          "Key": "EmployeeAddress",
          "Type": "String",
          "Value": employeeAddress.text
        },
        {
          "Key": "EmployeeCity",
          "Type": "String",
          "Value": employeeCity.text
        },
        {
          "Key": "EmployeeState",
          "Type": "String",
          "Value": employeeState.text
        },
        {
          "Key": "EmployeeCountry",
          "Type": "String",
          "Value": employeeCountry.text
        },
        {
          "Key": "EmployeeZipcode",
          "Type": "String",
          "Value": employeeZipcode.text
        },

        {
          "Key": "EmployeeDateOfBirth",
          "Type": "String",
          "Value": dob!=null?DateFormat("yyyy-MM-dd").format(dob):null
        },
        {
          "Key": "EmployeeBloodGroupId",
          "Type": "int",
          "Value": selectBloodGroupId
        },
        {
          "Key": "EmployeeMaritalStatusId",
          "Type": "int",
          "Value": selectMartialStatusId
        },
        {
          "Key": "EmployeeReferredBy",
          "Type": "String",
          "Value": employeeReferredBy.text
        },
        {
          "Key": "EmployeeRemarks",
          "Type": "String",
          "Value": employeeRemarks.text
        },
        {
          "Key": "EmployeeAadhaarNumber",
          "Type": "String",
          "Value": employeeAadhaarNo.text
        },
        {
          "Key": "EmployeePanNumber",
          "Type": "String",
          "Value": employeePanNo.text
        },
        {
          "Key": "EmployeeSalaryModeId",
          "Type": "int",
          "Value": selectPaymentMethodId
        },
        {
          "Key": "BankAccountHolderName",
          "Type": "String",
          "Value": employeeHolderName.text
        },
        {
          "Key": "BankName",
          "Type": "String",
          "Value": employeeBankName.text
        },
        {
          "Key": "BankAccountNumber",
          "Type": "String",
          "Value": employeeAccNo.text
        },
        {
          "Key": "BankIFSCCode",
          "Type": "String",
          "Value": employeeIFSC.text
        },
        {
          "Key": "BankBranchName",
          "Type": "String",
          "Value": employeeBranchName.text
        },
        {
          "Key": "EmployeeImageFileName",
          "Type": "String",
          "Value": ""
        },
        {
          "Key": "EmployeeImageFolderName",
          "Type": "String",
          "Value": ""
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
          clearInsertForm();
          GetEmployeeIssueDbHit(context, null);

          //
        }

        updateEmployeeLoader(false);
      });
    }catch(e){
      updateEmployeeLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertEmployeeDetail}" , e.toString());
    }


  }



  List<EmployeeGridModel> employeeGridList=[];
  GetEmployeeIssueDbHit(BuildContext context,int EmployeeId)  async{

    updateEmployeeLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getEmployeeDetail}"
        },
        {
          "Key": "LoginEmployeeId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "EmployeeId",
          "Type": "int",
          "Value": EmployeeId
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
          if(EmployeeId!=null ){
            editEmployeeId=t[0]['EmployeeId'];
            EmployeePrefix=t[0]['EmployeePrefix'];
            EmployeeCode=t[0]['EmployeeCode'];
            selectedSalutation=t[0]['EmployeeSalutation'];
            employeeFirstName.text=t[0]['EmployeeFirstName'];
            employeeLastName.text=t[0]['EmployeeLastName'];
            selectEmployeeDesignationId=t[0]['EmployeeDesignationId'];
            selectEmployeeDesignationName=t[0]['EmployeeDesignationName'];
            selectEmployeeTypeId=t[0]['EmployeeTypeId'];
            selectEmployeeTypeName=t[0]['EmployeeTypeName'];
            selectShiftId=t[0]['EmployeeShiftId'];
            selectShiftName=t[0]['EmployeeShiftName'];
            joiningDate=t[0]['EmployeeDateOfJoin']!=null?DateTime.parse(t[0]['EmployeeDateOfJoin']):null;
            dob=t[0]['EmployeeDateOfBirth']!=null?DateTime.parse(t[0]['EmployeeDateOfBirth']):null;
            employeeSalary.text=t[0]['EmployeeSalary'].toString();
            selectSalaryTypeId=t[0]['EmployeeSalaryTypeId'];
            selectSalaryTypeName=t[0]['EmployeeSalaryTypeName'];
            employeePhoneNumber.text=t[0]['EmployeeContactNumber'];
            employeeEmail.text=t[0]['EmployeeEmail'];
            employeeAddress.text=t[0]['EmployeeAddress'];
            employeeCity.text=t[0]['EmployeeCity'];
            employeeState.text=t[0]['EmployeeState'];
            employeeZipcode.text=t[0]['EmployeeZipcode'];
            selectBloodGroupId=t[0]['EmployeeBloodGroupId'];
            selectBloodGroupName=t[0]['EmployeeBloodGroup'];
            selectMartialStatusId=t[0]['EmployeeMaritalStatusId'];
            selectMartialStatusName=t[0]['EmployeeMaritalStatus'];
            selectPaymentMethodId=t[0]['EmployeeSalaryModeId'];
            selectPaymentMethodName=t[0]['EmployeeSalaryMode'];
            selectSalaryTypeId=t[0]['EmployeeSalaryTypeId'];
            selectSalaryTypeName=t[0]['EmployeeSalaryTypeName'];
            employeeReferredBy.text=t[0]['EmployeeReferredBy'];
            employeeRemarks.text=t[0]['EmployeeRemarks'];
            employeeAadhaarNo.text=t[0]['EmployeeAadhaarNumber'];
            employeePanNo.text=t[0]['EmployeePanNumber'];
            employeeBankName.text=t[0]['BankName'];
            employeeHolderName.text=t[0]['BankAccountHolderName'];
            employeeBranchName.text=t[0]['BankBranchName'];
            employeeAccNo.text=t[0]['BankAccountNumber'];
            employeeIFSC.text=t[0]['BankIFSCCode'];

          }
          else{
            employeeGridList=t.map((e) => EmployeeGridModel.fromJson(e)).toList();
          }
        }

        updateEmployeeLoader(false);
      });
    }catch(e){
      updateEmployeeLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getEmployeeDetail}" , e.toString());
    }


  }









  bool isEmployeeEdit=false;
  updateEmployeeEdit(bool value){
    isEmployeeEdit=value;
    notifyListeners();
  }

  bool EmployeeLoader=false;
  updateEmployeeLoader(bool value){
    EmployeeLoader=value;
    notifyListeners();
  }
}