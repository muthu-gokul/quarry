import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/customerDetailsModel.dart';
import 'package:quarry/model/parameterMode.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/widgets/alertDialog.dart';

import '../utils/utils.dart';

class CustomerNotifier extends ChangeNotifier {

  List<String>customerGridCol = ["Customer Name", "Location", "ContactNumber","Email", "CreditLimit"];
  List<CustomerDetails> customerGridList = [];

  TextEditingController customerName = new TextEditingController();
  TextEditingController customerAddress = new TextEditingController();
  TextEditingController customerCity = new TextEditingController();
  TextEditingController customerState = new TextEditingController();
  TextEditingController customerCountry = new TextEditingController();
  TextEditingController customerZipcode = new TextEditingController();
  TextEditingController customerContactNumber = new TextEditingController();
  TextEditingController customerEmail = new TextEditingController();
  TextEditingController customerGstNumber = new TextEditingController();
  TextEditingController customerType = new TextEditingController();
  TextEditingController customerCreditLimit = new TextEditingController();
  TextEditingController customerAdvanceAmount = new TextEditingController();
  double? usedAmount=0.0;
  double? balanceAmount=0.0;

  double? usedAdvanceAmount=0.0;
  double? balanceAdvanceAmount=0.0;

  bool? isCreditCustomer = false;
  bool? isAdvanceCustomer = false;

  var customerLogoFileName;
  var customerLogoFolderName="Customer";
  String customerLogoUrl="";
  File? logoFile;

  int? editCustomerId = null;
  final call = ApiManager();


  Future<dynamic> InsertCustomerDbHit(BuildContext context,bool fromSale) async {
    updatecustomerLoader(true);
    if(logoFile!=null){
      customerLogoFileName=await uploadFile(customerLogoFolderName,logoFile!);
    }
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: fromSale?"${Sp.insertCustomerDetail}": isCustomerEdit ? "${Sp.updateCustomerDetail}" : "${Sp.insertCustomerDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
     // ParameterModel(Key: "CustomerId", Type: "int", Value: editCustomerId),
      ParameterModel(Key: "CustomerName", Type: "String", Value:customerName.text),
      ParameterModel(Key: "CustomerContactNumber", Type: "String", Value:customerContactNumber.text),
      ParameterModel(Key: "CustomerEmail", Type: "String", Value:customerEmail.text),
      ParameterModel(Key: "CustomerAddress", Type: "String", Value:customerAddress.text),
      ParameterModel(Key: "CustomerCity", Type: "String", Value:customerCity.text),
      ParameterModel(Key: "CustomerState", Type: "String", Value:customerState.text),
      ParameterModel(Key: "CustomerCountry", Type: "String", Value:customerCountry.text),
      ParameterModel(Key: "CustomerZipCode", Type: "String", Value:customerZipcode.text),
      ParameterModel(Key: "CustomerGSTNumber", Type: "String", Value:customerGstNumber.text),
      ParameterModel(Key: "IsCreditCustomer", Type: "int", Value:isCreditCustomer!?1:0),
      ParameterModel(Key: "CustomerCreditLimit", Type: "String", Value:parseDouble(customerCreditLimit.text)),
      ParameterModel(Key: "IsCustomerAdvance", Type: "int", Value:isAdvanceCustomer!?1:0),
      ParameterModel(Key: "CustomerAdvanceAmount", Type: "String", Value:parseDouble(customerAdvanceAmount.text)),
      ParameterModel(Key: "CustomerLogoFileName", Type: "String", Value:customerLogoFileName),
      ParameterModel(Key: "CustomerLogoFolderName", Type: "String", Value:customerLogoFolderName),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    if(isCustomerEdit){
      parameters.insert(2,ParameterModel(Key: "CustomerId", Type: "int", Value: editCustomerId));
    }

    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
    };
    try {
      await call.ApiCallGetInvoke(body, context).then((value) {
        if (value != "null") {
          var parsed = json.decode(value);
       ///   print(parsed);

          if(fromSale){
            var t=parsed['Table'] as List;
            print(t);
            Provider.of<QuarryNotifier>(context, listen: false).updateSelectCustomerFromAddNew(t[0]['CustomerId'],t[0]['CustomerName'],t[0]['IsCreditCustomer'],
              t[0]['CustomerCreditLimit'],t[0]['UsedAmount'],t[0]['BalanceAmount'],);
          }
          clearCustomerDetails();
          Navigator.pop(context);
          GetCustomerDetailDbhit(context, null);
        }
        else{
          updatecustomerLoader(false);
        }



      });
    } catch (e) {
      updatecustomerLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertCustomerDetail}", e.toString());
    }
  }


  GetCustomerDetailDbhit(BuildContext context, int? customerId) async {
    updatecustomerLoader(true);
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.getCustomerDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(context,listen: false).UserId),
      ParameterModel(Key: "CustomerId", Type: "int", Value: customerId),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(context,listen: false).DataBaseName),
    ];
    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
    };

    try {
      await call.ApiCallGetInvoke(body, context).then((value) {

        if(value!="null"){
          log(value);
          var parsed = json.decode(value);
          var t = parsed['Table'] as List?;
          if(customerId!=null){
            editCustomerId=t![0]['CustomerId'];
            customerName.text=t[0]['CustomerName']??"";
            customerAddress.text=t[0]['CustomerAddress']??"";
            customerCity.text=t[0]['CustomerCity']??"";
            customerState.text=t[0]['CustomerState']??"";
            customerCountry.text=t[0]['CustomerCountry']??"";
            customerZipcode.text=t[0]['CustomerZipCode']??"";
            customerGstNumber.text=t[0]['CustomerGSTNumber']??"";
            customerContactNumber.text=t[0]['CustomerContactNumber']??"";
            customerEmail.text=t[0]['CustomerEmail']??"";
            customerCreditLimit.text=t[0]['CustomerCreditLimit'].toString();
            isCreditCustomer=t[0]['IsCreditCustomer']==0?false:true;
            if(isCreditCustomer!){
              usedAmount=t[0]['UsedAmount'].toDouble();
              balanceAmount=t[0]['BalanceAmount'].toDouble();
            }
            isAdvanceCustomer=t[0]['IsCustomerAdvance']==0?false:true;
            customerAdvanceAmount.text=t[0]['CustomerAdvanceAmount'].toString();
            if(isAdvanceCustomer!){
              usedAdvanceAmount= parseDouble(t[0]['UsedAdvanceAmount']);
              balanceAdvanceAmount= parseDouble(t[0]['BalanceAdvanceAmount']);
            }
            customerLogoFileName= t[0]['CompanyLogo'];
            customerLogoUrl=ApiManager().attachmentUrl+customerLogoFileName;
          }
          else{
            customerGridList = t!.map((e) => CustomerDetails.fromJson(e)).toList();
          }
        }
        updatecustomerLoader(false);
      });
    }
    catch (e) {
      updatecustomerLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getCustomerDetail}", e.toString());
    }
  }



  Future<dynamic> deleteById(int id) async {
    parameters=[
      ParameterModel(Key: "SpName", Type: "String", Value:  "${Sp.deleteCustomerDetail}"),
      ParameterModel(Key: "LoginUserId", Type: "int", Value: Provider.of<QuarryNotifier>(Get.context!,listen: false).UserId),
      ParameterModel(Key: "CustomerId", Type: "String", Value: id),
      ParameterModel(Key: "database", Type: "String", Value:Provider.of<QuarryNotifier>(Get.context!,listen: false).DataBaseName),
    ];
    var body = {
      "Fields": parameters.map((e) => e.toJson()).toList()
    };
    try {
      await call.ApiCallGetInvoke(body, Get.context!).then((value) {
        if (value != "null") {
          //var parsed = json.decode(value);
          CustomAlert().deletePopUp();
          GetCustomerDetailDbhit(Get.context!, null);
        }
      });
    } catch (e) {

      CustomAlert().commonErrorAlert(Get.context!, "${Sp.deleteCustomerDetail}", e.toString());
    }
  }



  bool isCustomerEdit = false;

  updateCustomerEdit(bool value) {
    isCustomerEdit = value;
    if(!isCustomerEdit){
      isCreditCustomer=false;
      isAdvanceCustomer=false;
    }
    notifyListeners();
  }

  bool customerLoader = false;

  updatecustomerLoader(bool value) {
    customerLoader = value;
    notifyListeners();
  }


  clearCustomerDetails() {
    customerName.clear();
    customerAddress.clear();
    customerCity.clear();
    customerState.clear();
    customerCountry.clear();
    customerZipcode.clear();
    customerContactNumber.clear();
    customerEmail.clear();
    customerGstNumber.clear();
    customerCreditLimit.clear();
    customerAdvanceAmount.clear();
    usedAmount=0.0;
    balanceAmount=0.0;
    usedAdvanceAmount=0.0;
    balanceAdvanceAmount=0.0;
  }


  clearAll(){
    clearCustomerDetails();
    customerGridList=[];
  }

}
