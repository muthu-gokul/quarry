import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/customerDetailsModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';

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
  double usedAmount=0.0;
  double balanceAmount=0.0;

  bool isCreditCustomer = false;

  String customerLogoFileName;
  String customerLogoFolderName;


  int editCustomerId = null;
  final call = ApiManager();


  Future<dynamic> InsertCustomerDbHit(BuildContext context,bool fromSale) async {
    updatecustomerLoader(true);
    var body = {
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value":fromSale?"${Sp.insertCustomerDetail}": isCustomerEdit ? "${Sp.updateCustomerDetail}" : "${Sp.insertCustomerDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context, listen: false).UserId
        },

        {
          "Key": "CustomerId",
          "Type": "int",
          "Value": editCustomerId
        },

        {
          "Key": "CustomerName",
          "Type": "String",
          "Value": customerName.text
        },
        {
          "Key": "CustomerContactNumber",
          "Type": "String",
          "Value": customerContactNumber.text
        },
        {
          "Key": "CustomerEmail",
          "Type": "String",
          "Value": customerEmail.text
        },

        {
          "Key": "CustomerAddress",
          "Type": "String",
          "Value": customerAddress.text
        },
        {
          "Key": "CustomerCity",
          "Type": "String",
          "Value": customerCity.text
        },
        {
          "Key": "CustomerState",
          "Type": "String",
          "Value": customerState.text
        },
        {
          "Key": "CustomerCountry",
          "Type": "String",
          "Value": customerCountry.text
        },
        {
          "Key": "CustomerZipCode",
          "Type": "String",
          "Value": customerZipcode.text
        },


        {
          "Key": "CustomerGSTNumber",
          "Type": "String",
          "Value": customerGstNumber.text
        },
        {
          "Key": "IsCreditCustomer",
          "Type": "int",
          "Value": isCreditCustomer?1:0
        },
        {
          "Key": "CustomerCreditLimit",
          "Type": "String",
          "Value": customerCreditLimit.text.isNotEmpty?double.parse(customerCreditLimit.text):0.0
        },
        {
          "Key": "CustomerLogoFileName",
          "Type": "String",
          "Value": null
        },
        {
          "Key": "CustomerLogoFolderName",
          "Type": "String",
          "Value": null
        },


        {
          "Key": "database",
          "Type": "String",
          "Value": Provider.of<QuarryNotifier>(context, listen: false)
              .DataBaseName
        }
      ]
    };
    try {
      await call.ApiCallGetInvoke(body, context).then((value) {
        if (value != null) {
          var parsed = json.decode(value);
       ///   print(parsed);

          if(fromSale){
            var t=parsed['Table'] as List;
            print(t);
            Provider.of<QuarryNotifier>(context, listen: false).updateSelectCustomerFromAddNew(t[0]['CustomerId'],t[0]['CustomerName']);
          }
          clearCustomerDetails();
          Navigator.pop(context);
          GetCustomerDetailDbhit(context, null);
        }


        updatecustomerLoader(false);
      });
    } catch (e) {
      updatecustomerLoader(false);
      CustomAlert().commonErrorAlert(
          context, "${Sp.insertCustomerDetail}", e.toString());
    }
  }


  GetCustomerDetailDbhit(BuildContext context, int customerId) async {
    print(customerId);
    updatecustomerLoader(true);
    var body = {
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getCustomerDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider
              .of<QuarryNotifier>(context, listen: false)
              .UserId
        },
        {
          "Key": "CustomerId",
          "Type": "int",
          "Value": customerId
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": Provider
              .of<QuarryNotifier>(context, listen: false)
              .DataBaseName
        }
      ]
    };

    try {
      await call.ApiCallGetInvoke(body, context).then((value) {

        var parsed = json.decode(value);
        var t = parsed['Table'] as List;
        print(t);
        if(customerId!=null){
          editCustomerId=t[0]['CustomerId'];
          customerName.text=t[0]['CustomerName'];
          customerAddress.text=t[0]['CustomerAddress'];
          customerCity.text=t[0]['CustomerCity'];
          customerState.text=t[0]['CustomerState'];
          customerCountry.text=t[0]['CustomerCountry'];
          customerZipcode.text=t[0]['CustomerZipCode'];
          customerGstNumber.text=t[0]['CustomerGSTNumber'];
          customerContactNumber.text=t[0]['CustomerContactNumber'];
          customerEmail.text=t[0]['CustomerEmail'];
          customerCreditLimit.text=t[0]['CustomerCreditLimit'].toString();
          isCreditCustomer=t[0]['IsCreditCustomer']==0?false:true;
          if(isCreditCustomer){
            usedAmount=t[0]['UsedAmount'];
            balanceAmount=t[0]['BalanceAmount'];
          }

        }
        else{
          customerGridList = t.map((e) => CustomerDetails.fromJson(e)).toList();
        }




        updatecustomerLoader(false);
        notifyListeners();
      });
    }
    catch (e) {
      updatecustomerLoader(false);
      CustomAlert().commonErrorAlert(
          context, "${Sp.getCompanyDetail}", e.toString());
    }
  }






  bool isCustomerEdit = false;

  updateCustomerEdit(bool value) {
    isCustomerEdit = value;
    if(!isCustomerEdit){
      isCreditCustomer=false;
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
    usedAmount=0.0;
    balanceAmount=0.0;
  }
}
