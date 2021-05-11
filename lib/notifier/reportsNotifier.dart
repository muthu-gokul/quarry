import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/dropDownValues.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/model/reportsModel/customerSaleModel/customerSaleReportGridModel.dart';
import 'package:quarry/model/reportsModel/inputMaterialModel.dart';
import 'package:quarry/model/reportsModel/invoiceReportModel/invoiceReportGridModel.dart';
import 'package:quarry/model/reportsModel/invoiceType.dart';
import 'package:quarry/model/reportsModel/locationModel.dart';
import 'package:quarry/model/reportsModel/machineModel.dart';
import 'package:quarry/model/reportsModel/materialModel.dart';
import 'package:quarry/model/reportsModel/outputMaterialModel.dart';
import 'package:quarry/model/reportsModel/partyNameModel.dart';
import 'package:quarry/model/reportsModel/paymentModel.dart';
import 'package:quarry/model/reportsModel/paymentStatusModel.dart';
import 'package:quarry/model/reportsModel/productionModel/productionReportGridModel.dart';
import 'package:quarry/model/reportsModel/purchase/purchaseReportGridModel.dart';
import 'package:quarry/model/reportsModel/salesReportModel/salesReportGridModel.dart';
import 'package:quarry/model/reportsModel/supplierModel.dart';
import 'package:quarry/model/reportsModel/supplierPurchase/supplierPurchaseGridModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';
import 'package:quarry/widgets/decimal.dart';
import 'package:quarry/widgets/staticColumnScroll/reportDataTable.dart';

class ReportsNotifier extends ChangeNotifier{
  final call=ApiManager();

  String TypeName="";

  /*Report Settings*/
  List<FilterDetailsModel> filtersList=[];

  DateTime dateTime=DateTime.parse('2021-01-01');
  List<DateTime> picked=[];



  List<PlantUserModel> plantList=[];
  List<MaterialModel> materialList=[];
  List<CustomerModel> customerList=[];
  List<SupplierModel> suppliersList=[];
  List<PaymentModel> paymentTypeList=[];
  List<LocationModel> locationModelList=[];
  List<MachineModel> machineList=[];
  List<InputMaterialModel> inputMaterialList=[];
  List<OutputMaterialModel> outputMaterialList=[];
  List<InvoiceTypeModel> invoiceTypeList=[];
  List<PartyName> partyNameList=[];
  List<PaymentStatus> paymentStatusList=[];

  Future<dynamic> ReportsDropDownValues(BuildContext context,String typeName) async {
    TypeName=typeName;
    dateTime=DateTime.parse('1999-01-01');
    filtersList.clear();
    updateReportLoader(true);

    if(typeName=="SaleReport"){

      reportHeader="Sales Report";
      totalReportTitle="Total Sale";
      totalReportQtyTitle="Sale Quantity";
      totalReportAmountTitle="Sale Amount";
      reportsGridColumnList=salesReportGridCol;
    }
    else if(typeName=="PurchaseReport"){

      reportHeader="Purchase Report";
      totalReportTitle="Total Purchase";
      totalReportQtyTitle="Purchase Quantity";
      totalReportAmountTitle="Purchase Amount";
      reportsGridColumnList=purchaseReportGridCol;
    }
    else if(typeName=="CustomerSaleReport"){

      reportHeader="Customer Sale Report";
      totalReportTitle="Total Sale";
      totalReportQtyTitle="Sale Quantity";
      totalReportAmountTitle="Sale Amount";
      reportsGridColumnList=customerSaleReportGridCol;
    }
    else if(typeName=="ProductionReport"){

      reportHeader="Production Report";
      totalReportTitle="Total Production";
      totalReportQtyTitle="Input Material Qty";
      totalReportAmountTitle="Output Material Qty";
      reportsGridColumnList=productionReportGridCol;
    }
    else if(typeName=="SupplierPurchaseReport"){

      reportHeader="Supplier Purchase Report";
      totalReportTitle="Total Purchase";
      totalReportQtyTitle="Total Purchase Qty";
      totalReportAmountTitle="Total Amount";
      reportsGridColumnList=supplierPurchaseReportGridCol;
    }
    else if(typeName=="InvoiceReport"){

      reportHeader="Invoice Report";
      totalReportTitle="Total Invoices";
      totalReportQtyTitle="Total Payable Invoices";
      totalReportAmountTitle="Total Receivable Invoices";
      reportsGridColumnList=invoiceReportGridCol;
    }

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
          "Value": typeName
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

          if(typeName=="SaleReport"){

             var t=parsed["Table"] as List;
             var t1=parsed["Table1"] as List;
             var t2=parsed["Table2"] as List;
             plantList=t.map((e) => PlantUserModel.fromJson(e)).toList();
             materialList=t1.map((e) => MaterialModel.fromJson(e)).toList();
             customerList=t2.map((e) => CustomerModel.fromJson(e)).toList();
             filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
             filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
             filtersList.add(FilterDetailsModel(title:  "Customer Filter", list: customerList, instanceName: 'CustomerName'));

          }
          else if(typeName=="PurchaseReport"){

             var t=parsed["Table"] as List;
             var t1=parsed["Table1"] as List;
             var t2=parsed["Table2"] as List;
             plantList=t.map((e) => PlantUserModel.fromJson(e)).toList();
             materialList=t1.map((e) => MaterialModel.fromJson(e)).toList();
             suppliersList=t2.map((e) => SupplierModel.fromJson(e)).toList();
             filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
             filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
             filtersList.add(FilterDetailsModel(title:  "Supplier Filter", list: suppliersList, instanceName: 'SupplierName'));
          }
          else if(typeName=="CustomerSaleReport"){

             var t=parsed["Table"] as List;
             var t1=parsed["Table1"] as List;
             var t2=parsed["Table2"] as List;
             var t3=parsed["Table3"] as List;
             var t4=parsed["Table4"] as List;
             plantList=t.map((e) => PlantUserModel.fromJson(e)).toList();
             customerList=t1.map((e) => CustomerModel.fromJson(e)).toList();
             locationModelList=t2.map((e) => LocationModel.fromJson(e)).toList();
             materialList=t3.map((e) => MaterialModel.fromJson(e)).toList();
             paymentTypeList=t4.map((e) => PaymentModel.fromJson(e)).toList();
             filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
             filtersList.add(FilterDetailsModel(title:  "Customer Filter", list: customerList, instanceName: 'CustomerName'));
             filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
             filtersList.add(FilterDetailsModel(title:  "Payment Type Filter", list: paymentTypeList, instanceName: 'PaymentType'));
             filtersList.add(FilterDetailsModel(title:  "Location Filter", list: locationModelList, instanceName: 'Location'));
          }
          else if(typeName=="ProductionReport"){

             var t=parsed["Table"] as List;
             var t1=parsed["Table1"] as List;
             var t2=parsed["Table2"] as List;
             var t3=parsed["Table3"] as List;

             plantList=t.map((e) => PlantUserModel.fromJson(e)).toList();
             machineList=t1.map((e) => MachineModel.fromJson(e)).toList();
             inputMaterialList=t2.map((e) => InputMaterialModel.fromJson(e)).toList();
             outputMaterialList=t3.map((e) => OutputMaterialModel.fromJson(e)).toList();

             filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
             filtersList.add(FilterDetailsModel(title:  "Machine Filter", list: machineList, instanceName: 'MachineName'));
             filtersList.add(FilterDetailsModel(title:  "Input Material Filter", list: inputMaterialList, instanceName: 'InputMaterialName'));
             filtersList.add(FilterDetailsModel(title:  "Output Material Filter", list: outputMaterialList, instanceName: 'OutputMaterialName'));
          }
          else if(typeName=="SupplierPurchaseReport"){

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;
            plantList=t.map((e) => PlantUserModel.fromJson(e)).toList();
            materialList=t1.map((e) => MaterialModel.fromJson(e)).toList();
            suppliersList=t2.map((e) => SupplierModel.fromJson(e)).toList();
            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
            filtersList.add(FilterDetailsModel(title:  "Supplier Filter", list: suppliersList, instanceName: 'SupplierName'));
          }
          else if(typeName=="InvoiceReport"){

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;
            var t3=parsed["Table3"] as List;
            var t4=parsed["Table4"] as List;
            plantList=t.map((e) => PlantUserModel.fromJson(e)).toList();
            invoiceTypeList=t1.map((e) => InvoiceTypeModel.fromJson(e)).toList();
            partyNameList=t2.map((e) => PartyName.fromJson(e)).toList();
            paymentStatusList=t3.map((e) => PaymentStatus.fromJson(e)).toList();
            paymentTypeList=t4.map((e) => PaymentModel.fromJson(e)).toList();
            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Invoice Type Filter", list: invoiceTypeList, instanceName: 'InvoiceType'));
            filtersList.add(FilterDetailsModel(title:  "Party Name Filter", list: partyNameList, instanceName: 'PartyName'));
            filtersList.add(FilterDetailsModel(title:  "Payment Status Filter", list: paymentStatusList, instanceName: 'PaymentStatus'));
            filtersList.add(FilterDetailsModel(title:  "Payment Type Filter", list: paymentTypeList, instanceName: 'PaymentType'));
          }






        }
        updateReportLoader(false);
      });
    }
    catch(e){
      updateReportLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }



  Future<dynamic> ReportsDbHit(BuildContext context,String typeName) async {
    String fromDate,toDate;

    if(picked.isEmpty){
      fromDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      toDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      picked.add(DateTime.now());
      picked.add(DateTime.now());
    }
    else if(picked.length==1){
      fromDate=DateFormat("yyyy-MM-dd").format(picked[0]).toString();
      toDate=DateFormat("yyyy-MM-dd").format(picked[0]).toString();
    }
    else if(picked.length==2){
      fromDate=DateFormat("yyyy-MM-dd").format(picked[0]).toString();
      toDate=DateFormat("yyyy-MM-dd").format(picked[1]).toString();
    }

    updateReportLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getReport}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "FromDate",
          "Type": "String",
          "Value": fromDate
        },

        {
          "Key": "ToDate",
          "Type": "String",
          "Value": toDate
        },
        {
          "Key": "TypeName",
          "Type": "String",
          "Value": typeName
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

          if(typeName=="SaleReport"){
             var t=parsed["Table"] as List;
             salesReportGridList=t.map((e) => SaleReportGridModel.fromJson(e)).toList();
             filterSales();
          }
          else if(typeName=="PurchaseReport"){
             var t=parsed["Table"] as List;
             purchaseReportGridList=t.map((e) => PurchaseReportGridModel.fromJson(e)).toList();
             filterPurchase();
          }
          else if(typeName=="CustomerSaleReport"){
             var t=parsed["Table"] as List;
             customerSaleReportGridList=t.map((e) => CustomerSaleGridModel.fromJson(e)).toList();
             filterCustomerSale();
          }
          else if(typeName=="ProductionReport"){
             var t=parsed["Table"] as List;
             productionReportGridList=t.map((e) => ProductionReportGridModel.fromJson(e)).toList();
             filterProduction();
          }
          else if(typeName=="SupplierPurchaseReport"){
             var t=parsed["Table"] as List;
             supplierPurchaseReportGridList=t.map((e) => SupplierPurchaseReportGridModel.fromJson(e)).toList();
             filterSupplierPurchase();
          }
          else if(typeName=="InvoiceReport"){
             var t=parsed["Table"] as List;
             print(t);
             invoiceReportGridList=t.map((e) => InvoiceReportGridModel.fromJson(e)).toList();
             filterInvoice();
          }


        }
        updateReportLoader(false);
      });
    }
    catch(e){
      updateReportLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getReport} $typeName" , e.toString());
    }
  }

  /* Common Data in Report Page*/
  String reportHeader="";

  String totalReportTitle="";
  int totalReport=0;

  String totalReportQtyTitle="";
  double totalReportQty=0.0;

  String totalReportAmountTitle="";
  double totalReportAmount=0.0;

  List<ReportGridStyleModel> reportsGridColumnList=[];
  List<dynamic> reportsGridDataList=[];

  /* SALES REPORT  */
  List<ReportGridStyleModel> salesReportGridCol=[ReportGridStyleModel(columnName: "Sale Number"),
    ReportGridStyleModel(columnName: "Date"),ReportGridStyleModel(columnName: "Material Name"),ReportGridStyleModel(columnName:"Quantity"),
    ReportGridStyleModel(columnName: "Amount"),ReportGridStyleModel(columnName: "Customer Name"),ReportGridStyleModel(columnName: "Plant Name"),];



  List<SaleReportGridModel> salesReportGridList=[];
  List<SaleReportGridModel> filterSalesReportGridList=[];



  List<SaleReportGridModel> tempSalesPlantFilter=[];
  List<SaleReportGridModel> tempSalesMaterialFilter=[];
  List<SaleReportGridModel> tempSalesCustomerFilter=[];

  filterSales() async{

    filterSalesReportGridList.clear();
    reportsGridDataList.clear();

    tempSalesMaterialFilter.clear();
    tempSalesPlantFilter.clear();
    tempSalesCustomerFilter.clear();


    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;

    plantList.forEach((element) {
      if(element.isActive){
        tempSalesPlantFilter=tempSalesPlantFilter+salesReportGridList.where((ele) => ele.plantId==element.plantId).toList();
      }
    });


     materialList.forEach((element) {
       if(element.isActive){
         tempSalesMaterialFilter=tempSalesMaterialFilter+tempSalesPlantFilter.where((ele) => ele.materialId==element.materialId).toList();
       }
     });


     customerList.forEach((element) {
       if(element.isActive){
         filterSalesReportGridList=filterSalesReportGridList+tempSalesMaterialFilter.where((ele) => ele.customerId==element.customerId).toList();
       }
     });


    totalReport=filterSalesReportGridList.length;
     filterSalesReportGridList.forEach((element) {
       totalReportAmount=Calculation().add(totalReportAmount, element.outputQtyAmount);
       totalReportQty=Calculation().add(totalReportQty, element.outputMaterialQty);
     });

    reportsGridDataList=filterSalesReportGridList;
    notifyListeners();
  }

  /* PurchaseReport */
  List<ReportGridStyleModel> purchaseReportGridCol=[ReportGridStyleModel(columnName: "Purchase Number",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel(columnName: "Date"),ReportGridStyleModel(columnName: "Material"),ReportGridStyleModel(columnName:"Quantity"),
    ReportGridStyleModel(columnName: "Amount"),ReportGridStyleModel(columnName: "Supplier Name"),ReportGridStyleModel(columnName: "Plant Name"),];



  List<PurchaseReportGridModel> purchaseReportGridList=[];
  List<PurchaseReportGridModel> filterPurchaseReportGridList=[];

  List<PurchaseReportGridModel> tempPurchasePlantFilter=[];
  List<PurchaseReportGridModel> tempPurchaseMaterialFilter=[];
  List<PurchaseReportGridModel> tempPurchaseSupplierFilter=[];


  filterPurchase() async{

    filterPurchaseReportGridList.clear();
    reportsGridDataList.clear();

    tempPurchasePlantFilter.clear();
    tempPurchaseMaterialFilter.clear();
    tempPurchaseSupplierFilter.clear();


    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;

    plantList.forEach((element) {
      if(element.isActive){
        tempPurchasePlantFilter=tempPurchasePlantFilter+purchaseReportGridList.where((ele) => ele.plantId==element.plantId).toList();
      }
    });


    materialList.forEach((element) {
      if(element.isActive){
        tempPurchaseMaterialFilter=tempPurchaseMaterialFilter+tempPurchasePlantFilter.where((ele) => ele.materialId==element.materialId).toList();
      }
    });


    suppliersList.forEach((element) {
      if(element.isActive){
        filterPurchaseReportGridList=filterPurchaseReportGridList+tempPurchaseMaterialFilter.where((ele) => ele.supplier==element.supplierId).toList();
      }
    });


    totalReport=filterPurchaseReportGridList.length;
    filterPurchaseReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element.amount);
      totalReportQty=Calculation().add(totalReportQty, element.purchaseQuantity);
    });

    reportsGridDataList=filterPurchaseReportGridList;
    notifyListeners();
  }


  /* Customer Sale Report */
  List<ReportGridStyleModel> customerSaleReportGridCol=[ReportGridStyleModel(columnName: "Sale Number",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel(columnName: "Date"),ReportGridStyleModel(columnName: "Customer Name"),ReportGridStyleModel(columnName:"Material Name"),
    ReportGridStyleModel(columnName:"Quantity"), ReportGridStyleModel(columnName: "Amount"),ReportGridStyleModel(columnName: "Payment Type"),
    ReportGridStyleModel(columnName: "Vehicle Number"),ReportGridStyleModel(columnName: "Location"),ReportGridStyleModel(columnName: "Contact Number"),
    ReportGridStyleModel(columnName: "Plant Name"),];


  List<CustomerSaleGridModel> customerSaleReportGridList=[];
  List<CustomerSaleGridModel> filterCustomerSaleReportGridList=[];

  List<CustomerSaleGridModel> tempCustomerSalePlantFilter=[];
  List<CustomerSaleGridModel> tempCustomerSaleMaterialFilter=[];
  List<CustomerSaleGridModel> tempCustomerSaleCustomerFilter=[];
  List<CustomerSaleGridModel> tempCustomerSaleLocationFilter=[];
  List<CustomerSaleGridModel> tempCustomerSalePaymentTypeFilter=[];


  filterCustomerSale() async{

    filterCustomerSaleReportGridList.clear();
    reportsGridDataList.clear();

    tempCustomerSalePlantFilter.clear();
    tempCustomerSaleMaterialFilter.clear();
    tempCustomerSaleCustomerFilter.clear();
    tempCustomerSaleLocationFilter.clear();
    tempCustomerSalePaymentTypeFilter.clear();


    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;

    plantList.forEach((element) {
      if(element.isActive){
        tempCustomerSalePlantFilter=tempCustomerSalePlantFilter+customerSaleReportGridList.where((ele) => ele.plantId==element.plantId).toList();
      }
    });

    customerList.forEach((element) {
      if(element.isActive){
        tempCustomerSaleCustomerFilter=tempCustomerSaleCustomerFilter+tempCustomerSalePlantFilter.where((ele) => ele.customerId==element.customerId).toList();
      }
    });

    materialList.forEach((element) {
      if(element.isActive){
        tempCustomerSaleMaterialFilter=tempCustomerSaleMaterialFilter+tempCustomerSaleCustomerFilter.where((ele) => ele.materialId==element.materialId).toList();
      }
    });

    paymentTypeList.forEach((element) {
      if(element.isActive){
        tempCustomerSalePaymentTypeFilter=tempCustomerSalePaymentTypeFilter+tempCustomerSaleMaterialFilter.where((ele) => ele.paymentCategoryId==element.paymentCategoryId).toList();
      }
    });


    locationModelList.forEach((element) {
      if(element.isActive){
        filterCustomerSaleReportGridList=filterCustomerSaleReportGridList+tempCustomerSalePaymentTypeFilter.where((ele) => ele.location==element.location).toList();
      }
    });




    totalReport=filterCustomerSaleReportGridList.length;
    filterCustomerSaleReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element.amount);
      totalReportQty=Calculation().add(totalReportQty, element.quantity);
    });

    reportsGridDataList=filterCustomerSaleReportGridList;
    notifyListeners();
  }



  /* PRODUCTION REPORT  */
  List<ReportGridStyleModel> productionReportGridCol=[ReportGridStyleModel(columnName: "Date"),
    ReportGridStyleModel(columnName: "Machine Name"),ReportGridStyleModel(columnName: "Input Material Name"),
    ReportGridStyleModel(columnName: "Input Material Qty"),ReportGridStyleModel(columnName: "Total Output Material",alignment: Alignment.center),];


  List<ProductionReportGridModel> productionReportGridList=[];
  List<ProductionReportGridModel> filterProductionReportGridList=[];

  List<ProductionReportGridModel> tempProductionPlantFilter=[];
  List<ProductionReportGridModel> tempProductionMachineFilter=[];
  List<ProductionReportGridModel> tempProductionInputMaterialFilter=[];
  List<ProductionReportGridModel> tempProductionOutputMaterialFilter=[];


  filterProduction() async{

    filterProductionReportGridList.clear();
    reportsGridDataList.clear();

    tempProductionPlantFilter.clear();
    tempProductionMachineFilter.clear();
    tempProductionInputMaterialFilter.clear();
    tempProductionOutputMaterialFilter.clear();


    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;

    plantList.forEach((element) {
      if(element.isActive){
        tempProductionPlantFilter=tempProductionPlantFilter+productionReportGridList.where((ele) => ele.plantId==element.plantId).toList();
      }
    });


    machineList.forEach((element) {
      if(element.isActive){
        tempProductionMachineFilter=tempProductionMachineFilter+tempProductionPlantFilter.where((ele) => ele.machineId==element.machineId).toList();
      }
    });

    inputMaterialList.forEach((element) {
      if(element.isActive){
        tempProductionInputMaterialFilter=tempProductionInputMaterialFilter+tempProductionMachineFilter.where((ele) => ele.inputMaterialId==element.inputMaterialId).toList();
      }
    });


    outputMaterialList.forEach((element) {
      if(element.isActive){
        filterProductionReportGridList=filterProductionReportGridList+tempProductionInputMaterialFilter.where((ele) => ele.outputMaterialId==element.OutputMaterialId).toList();
      }
    });


    totalReport=filterProductionReportGridList.length;
    filterProductionReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element.totalOutputMaterialQuantity);
      totalReportQty=Calculation().add(totalReportQty, element.inputMaterialQuantity);
    });

    reportsGridDataList=filterProductionReportGridList;
    notifyListeners();
  }


  /*  Supplier  Purchase Report */
  List<ReportGridStyleModel> supplierPurchaseReportGridCol=[ReportGridStyleModel(columnName: "Purchase Number",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel(columnName: "Date"),ReportGridStyleModel(columnName: "Supplier Name"),ReportGridStyleModel(columnName:"Location"),
    ReportGridStyleModel(columnName: "Contact Number"),ReportGridStyleModel(columnName: "Material Name"),ReportGridStyleModel(columnName: "Quantity"),
    ReportGridStyleModel(columnName: "Amount"),ReportGridStyleModel(columnName: "Plant Name"),

  ];



  List<SupplierPurchaseReportGridModel> supplierPurchaseReportGridList=[];
  List<SupplierPurchaseReportGridModel> filterSupplierPurchaseReportGridList=[];

  List<SupplierPurchaseReportGridModel> tempSupplierPurchasePlantFilter=[];
  List<SupplierPurchaseReportGridModel> tempSupplierPurchaseMaterialFilter=[];
  List<SupplierPurchaseReportGridModel> tempSupplierPurchaseSupplierFilter=[];


  filterSupplierPurchase() async{

    filterSupplierPurchaseReportGridList.clear();
    reportsGridDataList.clear();

    tempSupplierPurchasePlantFilter.clear();
    tempSupplierPurchaseMaterialFilter.clear();
    tempSupplierPurchaseSupplierFilter.clear();


    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;

    plantList.forEach((element) {
      if(element.isActive){
        tempSupplierPurchasePlantFilter=tempSupplierPurchasePlantFilter+supplierPurchaseReportGridList.where((ele) => ele.plantId==element.plantId).toList();
      }
    });


    materialList.forEach((element) {
      if(element.isActive){
        tempSupplierPurchaseMaterialFilter=tempSupplierPurchaseMaterialFilter+tempSupplierPurchasePlantFilter.where((ele) => ele.materialId==element.materialId).toList();
      }
    });


    suppliersList.forEach((element) {
      if(element.isActive){
        filterSupplierPurchaseReportGridList=filterSupplierPurchaseReportGridList+tempSupplierPurchaseMaterialFilter.where((ele) => ele.supplier==element.supplierId).toList();
      }
    });


    totalReport=filterSupplierPurchaseReportGridList.length;
    filterSupplierPurchaseReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element.amount);
      totalReportQty=Calculation().add(totalReportQty, element.purchaseQuantity);
    });

    reportsGridDataList=filterSupplierPurchaseReportGridList;
    notifyListeners();
  }


  /*  Invoice Report */
  List<ReportGridStyleModel> invoiceReportGridCol=[ReportGridStyleModel(columnName: "Invoice Number",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel(columnName: "Date"),ReportGridStyleModel(columnName: "Invoice Type"),ReportGridStyleModel(columnName:"Party Name"),
    ReportGridStyleModel(columnName: "Gross Amount"),ReportGridStyleModel(columnName: "Paid/ReceivedAmount"),ReportGridStyleModel(columnName: "Payment Status"),
    ReportGridStyleModel(columnName: "Payment Type"),ReportGridStyleModel(columnName: "Plant Name"),

  ];



  List<InvoiceReportGridModel> invoiceReportGridList=[];
  List<InvoiceReportGridModel> filterInvoiceReportGridList=[];

  List<InvoiceReportGridModel> tempInvoicePlantFilter=[];
  List<InvoiceReportGridModel> tempInvoiceTypeFilter=[];
  List<InvoiceReportGridModel> tempInvoicePartyNameFilter=[];
  List<InvoiceReportGridModel> tempInvoicePaymentStatusFilter=[];
  List<InvoiceReportGridModel> tempInvoicePaymentTypeFilter=[];


  filterInvoice() async{
  print("fdf");
    filterInvoiceReportGridList.clear();
    reportsGridDataList.clear();

    tempInvoicePlantFilter.clear();
    tempInvoiceTypeFilter.clear();
    tempInvoicePartyNameFilter.clear();
    tempInvoicePaymentStatusFilter.clear();
    tempInvoicePaymentTypeFilter.clear();


    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;

    plantList.forEach((element) {
      if(element.isActive){
        tempInvoicePlantFilter=tempInvoicePlantFilter+invoiceReportGridList.where((ele) => ele.plantId==element.plantId).toList();
      }
    });


    invoiceTypeList.forEach((element) {
      if(element.isActive){
        tempInvoiceTypeFilter=tempInvoiceTypeFilter+tempInvoicePlantFilter.where((ele) => ele.invoiceType==element.invoiceType).toList();
      }
    });


    partyNameList.forEach((element) {
      if(element.isActive){
        tempInvoicePartyNameFilter=tempInvoicePartyNameFilter+tempInvoiceTypeFilter.where((ele) => ele.partyId==element.partyId).toList();
      }
    });


    paymentStatusList.forEach((element) {
      if(element.isActive){
        tempInvoicePaymentStatusFilter=tempInvoicePaymentStatusFilter+tempInvoicePartyNameFilter.where((ele) => ele.paymentStatus==element.paymentStatus).toList();
      }
    });


    paymentTypeList.forEach((element) {
      if(element.isActive){
        filterInvoiceReportGridList=filterInvoiceReportGridList+tempInvoicePaymentStatusFilter.where((ele) => ele.paymentCategoryId==element.paymentCategoryId).toList();
      }
    });


    totalReport=filterInvoiceReportGridList.length;
    totalReportQty=filterInvoiceReportGridList.where((element) => element.invoiceType=="Payable").toList().length.toDouble();
    totalReportAmount=filterInvoiceReportGridList.where((element) => element.invoiceType=="Receivable").toList().length.toDouble();


    reportsGridDataList=filterInvoiceReportGridList;
    notifyListeners();
  }



  bool ReportLoader=false;
  updateReportLoader(bool value){
    ReportLoader=value;
    notifyListeners();
  }

}


class FilterDetailsModel{
  String title;
  List<dynamic> list;
  String instanceName;

  FilterDetailsModel({this.title, this.list, this.instanceName});
}