import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/paymentModel/paymentGridModel.dart';
import 'package:quarry/model/paymentModel/paymentMappingModel.dart';
import 'package:quarry/model/paymentModel/paymentPartyModel.dart';
import 'package:quarry/model/paymentModel/paymentTypeModel.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';

import 'invoiceNotifier.dart';

class PaymentNotifier extends ChangeNotifier{

  final call=ApiManager();


  int PlantId=null;
  String PlantName=null;

  List<PlantUserModel> plantList=[];
  int plantCount=0;
  Future<dynamic> PlantUserDropDownValues(BuildContext context) async {
    plantCount=0;
    updatePaymentLoader(true);
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
        }
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
              if(!isPaymentEdit){
                PlantId=element.plantId;
                PlantName=element.plantName;
              }

            }
          });


          if(!isPaymentEdit){
            if(plantCount!=1){
              PlantId=null;
              PlantName=null;
              plantList=plantList.where((element) => element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId).toList();

            }
          }

          if(isPaymentEdit){
            PlantId=null;
            PlantName=null;
            plantList=plantList.where((element) => element.userId==Provider.of<QuarryNotifier>(context,listen: false).UserId).toList();
          }



        }
        updatePaymentLoader(false);
      });
    }
    catch(e){
      updatePaymentLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }



  List<PaymentTypeModel> paymentTypeList=[];
  List<PaymentSupplierModel> paymentSupplierList=[];
  List<PaymentSupplierModel> filterPaymentSupplierList=[];
  Future<dynamic> PaymentDropDownValues(BuildContext context) async {
    updatePaymentLoader(true);
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
          "Value": "InvoicePayment"
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
          var t1=parsed['Table1'] as List;

          paymentTypeList=t.map((e) => PaymentTypeModel.fromJson(e)).toList();
          paymentSupplierList=t1.map((e) => PaymentSupplierModel.fromJson(e)).toList();
          filterPaymentSupplierList=t1.map((e) => PaymentSupplierModel.fromJson(e)).toList();

          if(isPaymentReceivable){
            filterPaymentSupplierList=paymentSupplierList.where((element) => element.supplierType=="Receivable").toList();
          }
          else{
            filterPaymentSupplierList=paymentSupplierList.where((element) => element.supplierType=="Payable").toList();
          }

        }
        updatePaymentLoader(false);
      });
    }
    catch(e){
      updatePaymentLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }




  List<String> gridCol=[];
  List<PaymentGridModel> gridPaymentList=[];
  List<PaymentGridModel> filterGridPaymentList=[];
  List<InvoiceCounterModel> counterList=[];


  int EditinvoiceId=null;
  String EditInvoiceNumber=null;
  DateTime EditInvoiceDate=null;
  int EditPlantId=null;
  String EditPlantName=null;
  String EditInvoiceType=null;
  int EditPartyId=null;
  String EditPartyName=null;
  double EditGrandTotalAmount=null;

  List<PaymentMappingModel> paymentMappingList=[];

  clearEditForm(){
     EditinvoiceId=null;
     EditInvoiceNumber=null;
     EditPlantId=null;
     EditPlantName=null;
     EditInvoiceType=null;
     EditPartyId=null;
     EditPartyName=null;
     EditGrandTotalAmount=null;
     paymentMappingList.clear();
     balanceAmount=0.0;
  }


  int paymentCategoryId=null;
  String paymentCategoryName=null;
  TextEditingController amount =new TextEditingController();
  TextEditingController comment =new TextEditingController();

  double balanceAmount=0.0;
  balanceCalc(){
    balanceAmount=0.0;
    double paidAmount=0.0;
    paymentMappingList.forEach((element) {
      paidAmount=paidAmount+element.Amount;
    });
    balanceAmount=EditGrandTotalAmount-paidAmount;
    notifyListeners();
  }

  clearPaymentEntry(){
     paymentCategoryId=null;
     paymentCategoryName=null;
     amount.clear();
     comment.clear();
     notifyListeners();
  }


  UpdatePaymentDbHit(BuildContext context,TickerProviderStateMixin tickerProviderStateMixin)  async{
    updatePaymentLoader(true);
    List js=[];
    js=paymentMappingList.map((e) => e.toJson()).toList();
    print(js);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.updatePaymentDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },

        {
          "Key": "InvoiceId",
          "Type": "int",
          "Value": EditinvoiceId
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": EditPlantId
        },

        {
          "Key": "InvoicePaymentMappingList",
          "Type": "datatable",
          "Value": js
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
          clearEditForm();
          clearInsertForm();
          GetPaymentDbHit(context, null,tickerProviderStateMixin);
        }

        updatePaymentLoader(false);
      });
    }catch(e){
      updatePaymentLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.updatePaymentDetail}" , e.toString());
    }


  }


  GetPaymentDbHit(BuildContext context,int invoiceId,TickerProviderStateMixin tickerProviderStateMixin)  async{


    updatePaymentLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getPaymentDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "InvoiceId",
          "Type": "int",
          "Value": invoiceId
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
          if(invoiceId!=null){
            var t1=parsed['Table1'] as List;

            EditinvoiceId=t[0]['InvoiceId'];
            EditInvoiceNumber=t[0]['InvoiceNumber'];
            EditInvoiceDate=DateTime.parse(t[0]['InvoiceDate']);
            EditPlantId=t[0]['PlantId'];
            EditPlantName=t[0]['PlantName'];
            EditInvoiceType=t[0]['InvoiceType'];
            EditPartyId=t[0]['PartyId'];
            EditPartyName=t[0]['PartyName'];
            EditGrandTotalAmount=t[0]['GrandTotalAmount'];

            paymentMappingList=t1.map((e) => PaymentMappingModel.fromJson(e, tickerProviderStateMixin)).toList();
            balanceCalc();




            notifyListeners();
          }
          else{
            print(t);
                gridPaymentList=t.map((e) => PaymentGridModel.fromJson(e)).toList();
                filterGridPaymentList=t.map((e) => PaymentGridModel.fromJson(e)).toList();
                filterGridValues();
          }
        }



        updatePaymentLoader(false);
      });
    }catch(e){
      updatePaymentLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getPaymentDetail}" , e.toString());
    }


  }

  filterGridValues(){

    double total=0.0;
    int paidCount=0;
    double totalPaid=0.0;
    int unpaidCount=0;
    double totalUnPaid=0.0;
    int partiallyCount=0;
    double totalpartiallyPaid=0.0;

    if(isPaymentReceivable){
      gridCol=["Payment No","Received On Date","Customer Name","Gross Amount","Received Amount","Balance Amount","Status"];
      filterGridPaymentList=gridPaymentList.where((element) => element.invoiceType=="Receivable").toList();

      filterGridPaymentList.forEach((element) {
        total=Calculation().add(total, element.grandTotalAmount);
        if(element.status=='Paid'){
          paidCount=paidCount+1;
          totalPaid=Calculation().add(totalPaid, element.grandTotalAmount);
        }
        else if(element.status=='Unpaid'){
          unpaidCount=unpaidCount+1;
          totalUnPaid=Calculation().add(totalUnPaid, element.grandTotalAmount);
        }
        else if(element.status=='Partially Paid'){
          partiallyCount=partiallyCount+1;
          totalpartiallyPaid=Calculation().add(totalpartiallyPaid, element.balanceAmount);
        }
      });

      counterList=[
        InvoiceCounterModel(name: "Receivable Payment",value: "${filterGridPaymentList.length} bill/Rs.$total"),
        InvoiceCounterModel(name: "Paid Payment",value: "$paidCount bill/Rs.$totalPaid"),
        InvoiceCounterModel(name: "UnPaid Payment",value: "$unpaidCount bill/Rs.$totalUnPaid"),
        InvoiceCounterModel(name: "Partially Paid Payment",value: "$partiallyCount bill/Rs.$totalpartiallyPaid"),
      ];
    }
    else{
      gridCol=["Payment No","Received On Date","Supplier Name","Gross Amount","Paid Amount","Balance Amount","Status"];
      filterGridPaymentList=gridPaymentList.where((element) => element.invoiceType=="Payable").toList();
      filterGridPaymentList.forEach((element) {
        total=Calculation().add(total, element.grandTotalAmount);
        if(element.status=='Paid'){
          paidCount=paidCount+1;
          totalPaid=Calculation().add(totalPaid, element.grandTotalAmount);
        }
        else if(element.status=='Unpaid'){
          unpaidCount=unpaidCount+1;
          totalUnPaid=Calculation().add(totalUnPaid, element.grandTotalAmount);
        }
        else if(element.status=='Partially Paid'){
          partiallyCount=partiallyCount+1;
          totalpartiallyPaid=Calculation().add(totalpartiallyPaid, element.balanceAmount);
        }
      });

      counterList=[
        InvoiceCounterModel(name: "Payable Payment",value: "${filterGridPaymentList.length} bill/Rs.$total"),
        InvoiceCounterModel(name: "Paid Payment",value: "$paidCount bill/Rs.$totalPaid"),
        InvoiceCounterModel(name: "UnPaid Payment",value: "$unpaidCount bill/Rs.$totalUnPaid"),
        InvoiceCounterModel(name: "Partially Paid Payment",value: "$partiallyCount bill/Rs.$totalpartiallyPaid"),
      ];
    }
    notifyListeners();
  }



/*          INSERT          */
  int selectedPartyId=null;
  String selectedPartyName=null;
  TextEditingController materialName=new TextEditingController();
  DateTime paymentDate;


  InsertPaymentDbHit(BuildContext context,TickerProviderStateMixin tickerProviderStateMixin)  async{
    updatePaymentLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.insertPaymentDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },

        {
          "Key": "MaterialName",
          "Type": "String",
          "Value": materialName.text
        },
        {
          "Key": "Date",
          "Type": "String",
          "Value": DateFormat('yyyy-MM-dd').format(paymentDate)
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": PlantId
        },
        {
          "Key": "PartyId",
          "Type": "int",
          "Value": selectedPartyId
        },
        {
          "Key": "PaymentCategoryId",
          "Type": "int",
          "Value": paymentCategoryId
        },
        {
          "Key": "Amount",
          "Type": "String",
          "Value": double.parse(amount.text)
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

          Navigator.pop(context);
          clearEditForm();
          clearInsertForm();
          GetPaymentDbHit(context, null,tickerProviderStateMixin);
        }

        updatePaymentLoader(false);
      });
    }catch(e){
      updatePaymentLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertPaymentDetail}" , e.toString());
    }


  }

  clearInsertForm(){
    selectedPartyId=null;
    selectedPartyName=null;
    paymentCategoryId=null;
    paymentCategoryName=null;
    amount.clear();
    materialName.clear();
    paymentDate=null;
  }




  bool isPaymentReceivable=true;
  updatePaymentReceivable(bool value){
    isPaymentReceivable=value;
    notifyListeners();
  }


  bool isPaymentEdit=false;
  updatePaymentEdit(bool value){
    isPaymentEdit=value;
    notifyListeners();
  }

  bool PaymentLoader=false;
  updatePaymentLoader(bool value){
    PaymentLoader=value;
    notifyListeners();
  }
  
}