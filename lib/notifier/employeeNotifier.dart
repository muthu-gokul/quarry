import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
import 'package:quarry/model/parameterMode.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/widgets/alertDialog.dart';

import '../utils/errorLog.dart';
import '../utils/utils.dart';
import 'quarryNotifier.dart';

class EmployeeNotifier extends ChangeNotifier{

  final call=ApiManager();

  String module="Employee Master";

  List<PlantUserModel> plantList=[];
  int plantCount=0;
  Future<dynamic>  PlantUserDropDownValues(BuildContext context) async {

    plantCount=0;
    updateEmployeeLoader(true);
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
    catch(e,stackTrace){
      updateEmployeeLoader(false);
      errorLog("EMP05 ${e.toString()}", stackTrace,"Error EMP01",module,module, "${Sp.MasterdropDown}_GetPlant");
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
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.MasterdropDown}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "TypeName", Type: "String", Value:"Employee"),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
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
        var t7= parsed['Table7'] as List?;



        employeeDesginationList=t.map((e) => EmployeeDesignationModel.fromJson(e)).toList();
        employeeTypeList=t1.map((e) => EmployeeTypeModel.fromJson(e)).toList();
        employeeShiftList=t2.map((e) => EmployeeShiftModel.fromJson(e)).toList();
        employeeSalaryTypeList=t3.map((e) => EmployeeSalaryTypeModel.fromJson(e)).toList();
        employeeBloodGroupList=t4.map((e) => EmployeeBloodGroupModel.fromJson(e)).toList();
        employeeMartialStatusList=t5.map((e) => EmployeeMartialStatusModel.fromJson(e)).toList();
        employeePaymentTypeList=t6.map((e) => EmployeePaymentTypeModel.fromJson(e)).toList();

        if(!isEmployeeEdit){

          selectSalaryTypeId=employeeSalaryTypeList[0].employeeSalaryTypeId;
          selectSalaryTypeName=employeeSalaryTypeList[0].employeeSalaryTypeName;
          EmployeePrefix=t7![0]['EmployeePrefix'];
          EmployeeCode=t7[0]['EmployeeCode'];
          print("EmployeeCode$EmployeeCode");

        }

        updateEmployeeLoader(false);
      });
    }
    catch (e,stackTrace) {
      updateEmployeeLoader(false);
      errorLog("EMP06 ${e.toString()}", stackTrace,"Error EMP06",module,module, "${Sp.MasterdropDown}_EmpDrp");

    }
  }

 /* insert Form */

  String? EmployeePrefix="";
  String? EmployeeCode="";

  int? selectEmployeeDesignationId = null;
  String? selectEmployeeDesignationName = null;

  int? selectEmployeeTypeId = null;
  String? selectEmployeeTypeName = null;

  int? selectShiftId = null;
  String? selectShiftName = null;

  int? selectBloodGroupId = null;
  String? selectBloodGroupName = null;

  int? selectMartialStatusId = null;
  String? selectMartialStatusName = null;

  int? selectPaymentMethodId = null;
  String? selectPaymentMethodName = null;

  int? selectSalaryTypeId = null;
  String? selectSalaryTypeName = null;


  String? selectedSalutation="Mr";
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

  var employeeLogoFileName;
  var employeeLogoFolderName="Employee";
  String employeeLogoUrl="";
  File? logoFile;

  DateTime? joiningDate;
  DateTime? dob;

/*  insertForm(){
    joiningDate=DateTime.now();
    dob=DateTime.now();
  }*/


  int? editEmployeeId;

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
    employeeLogoUrl="";
    employeeLogoFileName="";
    logoFile=null;
  }

  InsertEmployeeDbHit(BuildContext context)  async{
    updateEmployeeLoader(true);


    employeeLogoFileName="";
    if(logoFile!=null){
      employeeLogoFileName = await uploadFile(employeeLogoFolderName,logoFile!);
    }

    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: isEmployeeEdit?"${Sp.updateEmployeeDetail}": "${Sp.insertEmployeeDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "EmployeeCode", Type: "String", Value:EmployeeCode),
      ParameterModel(Key: "EmployeeSalutation", Type: "String", Value:selectedSalutation),
      ParameterModel(Key: "EmployeeFirstName", Type: "String", Value:employeeFirstName.text),
      ParameterModel(Key: "EmployeeLastName", Type: "String", Value:employeeLastName.text),
   //   ParameterModel(Key: "EmployeePassword", Type: "String", Value:""),
      ParameterModel(Key: "EmployeeDesignationId", Type: "int", Value:selectEmployeeDesignationId),
      ParameterModel(Key: "EmployeeTypeId", Type: "int", Value:selectEmployeeTypeId),
      ParameterModel(Key: "EmployeeShiftId", Type: "int", Value:selectShiftId),
      ParameterModel(Key: "EmployeeDateOfJoin", Type: "String", Value:joiningDate!=null?DateFormat("yyyy-MM-dd").format(joiningDate!):null),
      ParameterModel(Key: "EmployeeSalary", Type: "String", Value:employeeSalary.text.isNotEmpty?double.parse(employeeSalary.text):0.0),
      ParameterModel(Key: "EmployeeSalaryTypeId", Type: "int", Value:selectSalaryTypeId),
      ParameterModel(Key: "EmployeeContactNumber", Type: "String", Value:employeePhoneNumber.text),
      ParameterModel(Key: "EmployeeEmail", Type: "String", Value:employeeEmail.text),
      ParameterModel(Key: "EmployeeAddress", Type: "String", Value:employeeAddress.text),
      ParameterModel(Key: "EmployeeCity", Type: "String", Value:employeeCity.text),
      ParameterModel(Key: "EmployeeState", Type: "String", Value:employeeState.text),
      ParameterModel(Key: "EmployeeCountry", Type: "String", Value:employeeCountry.text),
      ParameterModel(Key: "EmployeeZipcode", Type: "String", Value:employeeZipcode.text),
      ParameterModel(Key: "EmployeeDateOfBirth", Type: "String", Value:dob!=null?DateFormat("yyyy-MM-dd").format(dob!):null),
      ParameterModel(Key: "EmployeeBloodGroupId", Type: "int", Value:selectBloodGroupId),
      ParameterModel(Key: "EmployeeMaritalStatusId", Type: "int", Value:selectMartialStatusId),
      ParameterModel(Key: "EmployeeReferredBy", Type: "String", Value:employeeReferredBy.text),
      ParameterModel(Key: "EmployeeRemarks", Type: "String", Value:employeeRemarks.text),
      ParameterModel(Key: "EmployeeAadhaarNumber", Type: "String", Value:employeeAadhaarNo.text),
      ParameterModel(Key: "EmployeePanNumber", Type: "String", Value:employeePanNo.text),
      ParameterModel(Key: "EmployeeSalaryModeId", Type: "int", Value:selectPaymentMethodId),
      ParameterModel(Key: "BankAccountHolderName", Type: "String", Value:employeeHolderName.text),
      ParameterModel(Key: "BankName", Type: "String", Value:employeeBankName.text),
      ParameterModel(Key: "BankAccountNumber", Type: "String", Value:employeeAccNo.text),
      ParameterModel(Key: "BankIFSCCode", Type: "String", Value:employeeIFSC.text),
      ParameterModel(Key: "BankBranchName", Type: "String", Value:employeeBranchName.text),
      ParameterModel(Key: "EmployeeImageFileName", Type: "String", Value:employeeLogoFileName),
      ParameterModel(Key: "EmployeeImageFolderName", Type: "String", Value:employeeLogoFolderName),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];

    if(isEmployeeEdit){
      parameters.insert(2, ParameterModel(Key: "EmployeeId", Type: "int", Value:editEmployeeId));
    }

    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        updateEmployeeLoader(false);
        if(value!="null"){
          var parsed=json.decode(value);


          Navigator.pop(context);
          clearInsertForm();
          GetEmployeeIssueDbHit(context, null);

          //
        }
        else{
          updateEmployeeLoader(false);
        }


      });
    }catch(e,stackTrace){
      updateEmployeeLoader(false);
      errorLog("EMP06 ${e.toString()}", stackTrace,"Error EMP06",module,module, isEmployeeEdit?"${Sp.updateEmployeeDetail}": "${Sp.insertEmployeeDetail}");

    }


  }



  List<EmployeeGridModel> employeeGridList=[];
  GetEmployeeIssueDbHit(BuildContext context,int? EmployeeId)  async{

    updateEmployeeLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.getEmployeeDetail}"),
      ParameterModel(Key: "LoginEmployeeId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "EmployeeId", Type: "int", Value:EmployeeId),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body={
      "Fields": parameters.map((e) => e.toJson()).toList()
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!="null"){
          var parsed=json.decode(value);
          var t=parsed['Table'] as List?;
          log("employee $t");
          if(EmployeeId!=null ){
            editEmployeeId=t![0]['EmployeeId'];
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
            employeeLogoFileName= t[0]['EmployeeImageFileName'];
            employeeLogoUrl=ApiManager().attachmentUrl+employeeLogoFileName;
            logoFile=null;
          }
          else{
            employeeGridList=t!.map((e) => EmployeeGridModel.fromJson(e)).toList();
          }
        }

        updateEmployeeLoader(false);
      });
    }catch(e,stackTrace){
      updateEmployeeLoader(false);
      errorLog("EMP07 ${e.toString()}", stackTrace,"Error EMP06",module,module, "${Sp.getEmployeeDetail}");
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


  clearAll(){
    clearInsertForm();
    employeeGridList.clear();
    employeeDesginationList.clear();
    employeeTypeList.clear();
    employeeShiftList.clear();
    employeeSalaryTypeList.clear();
    employeeBloodGroupList.clear();
    employeeMartialStatusList.clear();
    employeePaymentTypeList.clear();
  }

}