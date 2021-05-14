import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';
import 'package:quarry/widgets/staticColumnScroll/reportDataTableWithoutModel.dart';

class ReportNotifier extends ChangeNotifier{
  final call=ApiManager();

  String TypeName="";
  /*Report Settings*/
  List<FilterDetailsModel> filtersList=[];

  DateTime dateTime=DateTime.parse('2021-01-01');
  List<DateTime> picked=[];

  /* Common Data in Report Page*/
  String reportHeader="";

  String totalReportTitle="";
  int totalReport=0;

  String totalReportQtyTitle="";
  dynamic totalReportQty;

  String totalReportAmountTitle="";
  double totalReportAmount=0.0;

  List<ReportGridStyleModel2> reportsGridColumnList=[];
  List<dynamic> reportsGridDataList=[];

  List<dynamic> plantList=[];/*  {
            "PlantId": 1,
            "PlantName": "MahalakshmiRynoSands"
        }*/
  List<dynamic> materialList=[];/*{
            "MaterialId": 2,
            "MaterialName": "M Sand",
            "IsActive": 1
        }*/
  List<dynamic> customerList=[];/* {
            "CustomerId": null,
            "CustomerName": null,
            "IsActive": 1
        }*/
  List<dynamic> supplierList=[];/* {
            "SupplierId": 11,
            "SupplierName": "goks",
            "SupplierType": "External",
            "IsActive": 1
        }*/
 List<dynamic> locationList=[];/*{
            "Location": null
        }*/
 List<dynamic> paymentTypeList=[];/*{
            "PaymentCategoryId": 1,
            "PaymentType": "Cash"
        }*/
  List<dynamic> machineList=[];/* {
            "MachineId": 9,
            "MachineName": "dddd"
        }*/
  List<dynamic> inputMaterialList=[];/*{
            "InputMaterialId": 12,
            "InputMaterialName": "12mm Stone"
        }*/
  List<dynamic> outputMaterialList=[];/* {
            "OutputMaterialId": 2,
            "OutputMaterialName": "M Sand"
        }*/
 List<dynamic> invoiceTypeList=[];/*{
            "InvoiceType": "Payable"
        }*/
  List<dynamic> paymentStatusList=[];/*{
            "PaymentStatus": "Completed"
        }*/
  List<dynamic> partyNameList=[];/*{
            "PartyName": "vivek"
            PartyId
        }*/
 List<dynamic> employeeList=[];/* {
            "EmployeeId": 2,
            "EmployeeName": "Mr Raja R",
            "IsActive": 1
        }*/

 List<dynamic>  dieselRateList=[];/*{
            "DieselRate": 0.00
        }*/


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
    else if(typeName=="SupplierPurchaseReport"){

      reportHeader="Supplier Purchase Report";
      totalReportTitle="Total Purchase";
      totalReportQtyTitle="Total Purchase Qty";
      totalReportAmountTitle="Total Amount";
      reportsGridColumnList=supplierPurchaseReportGridCol;
    }
    else if(typeName=="ProductionReport"){

      reportHeader="Production Report";
      totalReportTitle="Total Production";
      totalReportQtyTitle="Input Material Qty";
      totalReportAmountTitle="Output Material Qty";
      reportsGridColumnList=productionReportGridCol;
    }
    else if(typeName=="InvoiceReport"){

      reportHeader="Invoice Report";
      totalReportTitle="Total Invoices";
      totalReportQtyTitle="Total Payable Invoices";
      totalReportAmountTitle="Total Receivable Invoices";
      reportsGridColumnList=invoiceReportGridCol;
    }
    else if(typeName=="ReceivablePaymentReport"){

      reportHeader="Receivable Payment Report";
      totalReportTitle="Total Invoices";
      totalReportQtyTitle="Total Received Amount";
      totalReportAmountTitle="Total Balance Amount";
      reportsGridColumnList=receivablePaymentReportReportGridCol;
    }
    else if(typeName=="PayablePaymentReport"){

      reportHeader="Payable Payment Report";
      totalReportTitle="Total Invoices";
      totalReportQtyTitle="Total Paid Amount";
      totalReportAmountTitle="Total Balance Amount";
      reportsGridColumnList=payablePaymentReportGridCol;
    }
    else if(typeName=="EmployeeReport"){

      reportHeader="Employee Report";
      totalReportTitle="Total Employees";
      totalReportQtyTitle="Total Salary";
      totalReportAmountTitle="Total Net Salary";
      reportsGridColumnList=employeeReportGridCol;
    }
    else if(typeName=="DieselPurchaseReport"){

      reportHeader="Diesel Purchase Report";
      totalReportTitle="Total Bill";
      totalReportQtyTitle="Total Quantity";
      totalReportAmountTitle="Total Amount";
      reportsGridColumnList=dieselPurchaseReportGridCol;
    }
    else if(typeName=="MachineManagementReport"){

      reportHeader="Machine Management Report";
      totalReportTitle="Total Issues";
      totalReportQtyTitle="Total Machines";
      totalReportAmountTitle=" ";
      reportsGridColumnList=machineManagementReportGridCol;
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

            plantList=t;
            materialList=t1;
            customerList=t2;
            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
            filtersList.add(FilterDetailsModel(title:  "Customer Filter", list: customerList, instanceName: 'CustomerName'));

          }
          else if(typeName=="PurchaseReport"){

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;
            plantList=t;
            materialList=t1;
            supplierList=t2;
            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
            filtersList.add(FilterDetailsModel(title:  "Supplier Filter", list: supplierList, instanceName: 'SupplierName'));
          }
          else if(typeName=="CustomerSaleReport"){

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;
            var t3=parsed["Table3"] as List;
            var t4=parsed["Table4"] as List;
            plantList=t;
            customerList=t1;
            locationList=t2;
            materialList=t3;
            paymentTypeList=t4;
            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Customer Filter", list: customerList, instanceName: 'CustomerName'));
            filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
            filtersList.add(FilterDetailsModel(title:  "Payment Type Filter", list: paymentTypeList, instanceName: 'PaymentType'));
            filtersList.add(FilterDetailsModel(title:  "Location Filter", list: locationList, instanceName: 'Location'));
          }
          else if(typeName=="SupplierPurchaseReport"){

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;
            plantList=t;
            materialList=t1;
            supplierList=t2;
            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
            filtersList.add(FilterDetailsModel(title:  "Supplier Filter", list: supplierList, instanceName: 'SupplierName'));
          }
          else if(typeName=="ProductionReport"){

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;
            var t3=parsed["Table3"] as List;

            plantList=t;
            machineList=t1;
            inputMaterialList=t2;
            outputMaterialList=t3;

            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Machine Filter", list: machineList, instanceName: 'MachineName'));
            filtersList.add(FilterDetailsModel(title:  "Input Material Filter", list: inputMaterialList, instanceName: 'InputMaterialName'));
            filtersList.add(FilterDetailsModel(title:  "Output Material Filter", list: outputMaterialList, instanceName: 'OutputMaterialName'));
          }
          else if(typeName=="InvoiceReport"){

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;
            var t3=parsed["Table3"] as List;
            var t4=parsed["Table4"] as List;
            plantList=t;
            invoiceTypeList=t1;
            partyNameList=t2;
            paymentStatusList=t3;
            paymentTypeList=t4;
            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Invoice Type Filter", list: invoiceTypeList, instanceName: 'InvoiceType'));
            filtersList.add(FilterDetailsModel(title:  "Party Name Filter", list: partyNameList, instanceName: 'PartyName'));
            filtersList.add(FilterDetailsModel(title:  "Payment Status Filter", list: paymentStatusList, instanceName: 'PaymentStatus'));
            filtersList.add(FilterDetailsModel(title:  "Payment Type Filter", list: paymentTypeList, instanceName: 'PaymentType'));
          }
          else if(typeName=="ReceivablePaymentReport"){

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;
            var t3=parsed["Table3"] as List;

            plantList=t;
            partyNameList=t1;
            invoiceTypeList=t2;
            paymentTypeList=t3;
            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Party Name Filter", list: partyNameList, instanceName: 'PartyName'));
            filtersList.add(FilterDetailsModel(title:  "Payment Status  Filter", list: invoiceTypeList, instanceName: 'InvoiceType'));
            filtersList.add(FilterDetailsModel(title:  "Payment Type Filter", list: paymentTypeList, instanceName: 'PaymentType'));
          }
          else if(typeName=="PayablePaymentReport"){

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;
            var t3=parsed["Table3"] as List;

            plantList=t;
            partyNameList=t1;
            invoiceTypeList=t2;
            paymentTypeList=t3;
            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Party Name Filter", list: partyNameList, instanceName: 'PartyName'));
            filtersList.add(FilterDetailsModel(title:  "Payment Status  Filter", list: invoiceTypeList, instanceName: 'InvoiceType'));
            filtersList.add(FilterDetailsModel(title:  "Payment Type Filter", list: paymentTypeList, instanceName: 'PaymentType'));
          }
          else if(typeName=="EmployeeReport"){

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;


            plantList=t;
            employeeList=t1;

            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Employee Filter", list: employeeList, instanceName: 'EmployeeName'));
          }
          else if(typeName=="DieselPurchaseReport"){

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;
            var t3=parsed["Table3"] as List;


            plantList=t;
            employeeList=t1;
            locationList=t2;
            dieselRateList=t3;

            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Purchaser Filter", list: employeeList, instanceName: 'PurchaserName'));
            filtersList.add(FilterDetailsModel(title:  "Bunk Location Filter", list: locationList, instanceName: 'DieselBunkLocation'));
            filtersList.add(FilterDetailsModel(title:  "Diesel Price Filter", list: dieselRateList, instanceName: 'DieselRate'));
          }
          else if(typeName=="MachineManagementReport"){

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;


            plantList=t;
            machineList=t1;
            employeeList=t2;


            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Machine Filter", list: machineList, instanceName: 'MachineName'));
            filtersList.add(FilterDetailsModel(title:  "Employee Filter", list: employeeList, instanceName: 'EmployeeName'));
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
            salesReportGridList=t;
            filterSales();
          }
          else if(typeName=="PurchaseReport"){
            var t=parsed["Table"] as List;
            purchaseReportGridList=t;
            filterPurchase();
          }
          else if(typeName=="CustomerSaleReport"){
            var t=parsed["Table"] as List;
            customerSaleReportGridList=t;
            filterCustomerSale();
          }
          else if(typeName=="SupplierPurchaseReport"){
            var t=parsed["Table"] as List;
            supplierPurchaseReportGridList=t;
            filterSupplierPurchase();
          }
          else if(typeName=="ProductionReport"){
            var t=parsed["Table"] as List;
            productionReportGridList=t;
            filterProduction();
          }
          else if(typeName=="InvoiceReport"){
            var t=parsed["Table"] as List;
            invoiceReportGridList=t;
            filterInvoice();
          }
          else if(typeName=="ReceivablePaymentReport"){
            var t=parsed["Table"] as List;
            receivablePaymentReportReportGridList=t;
            filterReceivablePaymentReport();
          }
          else if(typeName=="PayablePaymentReport"){
            var t=parsed["Table"] as List;
            payablePaymentReportGridList=t;
            filterPayablePaymentReport();
          }
          else if(typeName=="EmployeeReport"){
            var t=parsed["Table"] as List;
            employeeReportGridList=t;
            filterEmployeeReport();
          }
          else if(typeName=="DieselPurchaseReport"){
            var t=parsed["Table"] as List;
            dieselPurchaseReportGridList=t;
            filterDieselPurchaseReport();
          }
          else if(typeName=="MachineManagementReport"){
            var t=parsed["Table"] as List;
            machineManagementReportGridList=t;
            filterMachineManagementReport();
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



  /* SALES REPORT  */
  List<ReportGridStyleModel2> salesReportGridCol=[ReportGridStyleModel2(columnName: "SaleNumber"),
    ReportGridStyleModel2(columnName: "CreatedDate",isDate: true),ReportGridStyleModel2(columnName: "MaterialName"),ReportGridStyleModel2(columnName:"OutputMaterialQty"),
    ReportGridStyleModel2(columnName: "OutputQtyAmount"),ReportGridStyleModel2(columnName: "CustomerName"),ReportGridStyleModel2(columnName: "PlantName"),];



  List<dynamic> salesReportGridList=[];
  List<dynamic> filterSalesReportGridList=[];

  List<dynamic> tempSalesPlantFilter=[];
  List<dynamic> tempSalesMaterialFilter=[];
  List<dynamic> tempSalesCustomerFilter=[];

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
      if(element['IsActive']==1){
        tempSalesPlantFilter=tempSalesPlantFilter+salesReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });


    materialList.forEach((element) {
      if(element['IsActive']==1){
        tempSalesMaterialFilter=tempSalesMaterialFilter+tempSalesPlantFilter.where((ele) => ele['MaterialId']==element['MaterialId']).toList();
      }
    });


    customerList.forEach((element) {
      if(element['IsActive']==1){
        filterSalesReportGridList=filterSalesReportGridList+tempSalesMaterialFilter.where((ele) => ele['CustomerId']==element['CustomerId']).toList();
      }
    });


    totalReport=filterSalesReportGridList.length;
    filterSalesReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element['OutputQtyAmount']);
      totalReportQty=Calculation().add(totalReportQty, element['OutputMaterialQty']);
    });

    reportsGridDataList=filterSalesReportGridList;
    notifyListeners();
  }


  /* PurchaseReport */
  List<ReportGridStyleModel2> purchaseReportGridCol=[ReportGridStyleModel2(columnName: "PurchaseOrderNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel2(columnName: "CreatedDate",isDate: true),ReportGridStyleModel2(columnName: "MaterialName"),ReportGridStyleModel2(columnName:"PurchaseQuantity"),
    ReportGridStyleModel2(columnName: "Amount"),ReportGridStyleModel2(columnName: "SupplierName"),ReportGridStyleModel2(columnName: "PlantName"),];



  List<dynamic> purchaseReportGridList=[];
  List<dynamic> filterPurchaseReportGridList=[];

  List<dynamic> tempPurchasePlantFilter=[];
  List<dynamic> tempPurchaseMaterialFilter=[];
  List<dynamic> tempPurchaseSupplierFilter=[];


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
      if(element['IsActive']==1){
        tempPurchasePlantFilter=tempPurchasePlantFilter+purchaseReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });


    materialList.forEach((element) {
      if(element['IsActive']==1){
        tempPurchaseMaterialFilter=tempPurchaseMaterialFilter+tempPurchasePlantFilter.where((ele) => ele['MaterialId']==element['MaterialId']).toList();
      }
    });


    supplierList.forEach((element) {
      if(element['IsActive']==1){
        filterPurchaseReportGridList=filterPurchaseReportGridList+tempPurchaseMaterialFilter.where((ele) => ele['Supplier']==element['SupplierId']).toList();
      }
    });


    totalReport=filterPurchaseReportGridList.length;
    filterPurchaseReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element['Amount']);
      totalReportQty=Calculation().add(totalReportQty, element['PurchaseQuantity']);
    });

    reportsGridDataList=filterPurchaseReportGridList;
    notifyListeners();
  }

  /* Customer Sale Report */
  List<ReportGridStyleModel2> customerSaleReportGridCol=[ReportGridStyleModel2(columnName: "SaleNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel2(columnName: "CreatedDate",isDate: true),ReportGridStyleModel2(columnName: "CustomerName"),ReportGridStyleModel2(columnName:"MaterialName"),
    ReportGridStyleModel2(columnName:"Quantity"), ReportGridStyleModel2(columnName: "Amount"),ReportGridStyleModel2(columnName: "PaymentCategoryName"),
    ReportGridStyleModel2(columnName: "VehicleNumber"),ReportGridStyleModel2(columnName: "Location"),ReportGridStyleModel2(columnName: "CustomerContactNumber"),
    ReportGridStyleModel2(columnName: "PlantName"),];


  List<dynamic> customerSaleReportGridList=[];
  List<dynamic> filterCustomerSaleReportGridList=[];

  List<dynamic> tempCustomerSalePlantFilter=[];
  List<dynamic> tempCustomerSaleMaterialFilter=[];
  List<dynamic> tempCustomerSaleCustomerFilter=[];
  List<dynamic> tempCustomerSaleLocationFilter=[];
  List<dynamic> tempCustomerSalePaymentTypeFilter=[];


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
      if(element['IsActive']==1){
        tempCustomerSalePlantFilter=tempCustomerSalePlantFilter+customerSaleReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });

    customerList.forEach((element) {
      if(element['IsActive']==1){
        tempCustomerSaleCustomerFilter=tempCustomerSaleCustomerFilter+tempCustomerSalePlantFilter.where((ele) => ele['CustomerId']==element['CustomerId']).toList();
      }
    });

    materialList.forEach((element) {
      if(element['IsActive']==1){
        tempCustomerSaleMaterialFilter=tempCustomerSaleMaterialFilter+tempCustomerSaleCustomerFilter.where((ele) => ele['MaterialId']==element['MaterialId']).toList();
      }
    });

    paymentTypeList.forEach((element) {
      if(element['IsActive']==1){
        tempCustomerSalePaymentTypeFilter=tempCustomerSalePaymentTypeFilter+tempCustomerSaleMaterialFilter.where((ele) => ele['PaymentCategoryId']==element['PaymentCategoryId']).toList();
      }
    });


    locationList.forEach((element) {
      if(element['IsActive']==1){
        filterCustomerSaleReportGridList=filterCustomerSaleReportGridList+tempCustomerSalePaymentTypeFilter.where((ele) => ele['Location']==element['Location']).toList();
      }
    });




    totalReport=filterCustomerSaleReportGridList.length;
    filterCustomerSaleReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element['Amount']);
      totalReportQty=Calculation().add(totalReportQty, element['Quantity']);
    });

    reportsGridDataList=filterCustomerSaleReportGridList;
    notifyListeners();
  }

  /*  Supplier  Purchase Report */
  List<ReportGridStyleModel2> supplierPurchaseReportGridCol=[ReportGridStyleModel2(columnName: "PurchaseOrderNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel2(columnName: "CreatedDate",isDate: true),ReportGridStyleModel2(columnName: "SupplierName"),ReportGridStyleModel2(columnName:"Location"),
    ReportGridStyleModel2(columnName: "ContactNumber"),ReportGridStyleModel2(columnName: "MaterialName"),ReportGridStyleModel2(columnName: "PurchaseQuantity"),
    ReportGridStyleModel2(columnName: "Amount"),ReportGridStyleModel2(columnName: "PlantName"),

  ];



  List<dynamic> supplierPurchaseReportGridList=[];
  List<dynamic> filterSupplierPurchaseReportGridList=[];

  List<dynamic> tempSupplierPurchasePlantFilter=[];
  List<dynamic> tempSupplierPurchaseMaterialFilter=[];
  List<dynamic> tempSupplierPurchaseSupplierFilter=[];


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
      if(element['IsActive']==1){
        tempSupplierPurchasePlantFilter=tempSupplierPurchasePlantFilter+supplierPurchaseReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });


    materialList.forEach((element) {
      if(element['IsActive']==1){
        tempSupplierPurchaseMaterialFilter=tempSupplierPurchaseMaterialFilter+tempSupplierPurchasePlantFilter.where((ele) => ele['MaterialId']==element['MaterialId']).toList();
      }
    });


    supplierList.forEach((element) {
      if(element['IsActive']==1){
        filterSupplierPurchaseReportGridList=filterSupplierPurchaseReportGridList+tempSupplierPurchaseMaterialFilter.where((ele) => ele['Supplier']==element['SupplierId']).toList();
      }
    });


    totalReport=filterSupplierPurchaseReportGridList.length;
    filterSupplierPurchaseReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element['Amount']);
      totalReportQty=Calculation().add(totalReportQty, element['PurchaseQuantity']);
    });

    reportsGridDataList=filterSupplierPurchaseReportGridList;
    notifyListeners();
  }


  /* PRODUCTION REPORT  */
  List<ReportGridStyleModel2> productionReportGridCol=[ReportGridStyleModel2(columnName: "ProductionDate",isDate: true),
    ReportGridStyleModel2(columnName: "MachineName"),ReportGridStyleModel2(columnName: "InputMaterialName"),
    ReportGridStyleModel2(columnName: "ShowInputMaterialQuantity"),ReportGridStyleModel2(columnName: "TotalOutputMaterial",alignment: Alignment.center),
    ReportGridStyleModel2(columnName: "OutputMaterialName"),ReportGridStyleModel2(columnName: "ShowOutputMaterialQuantity"),];


  List<dynamic> productionReportGridList=[];
  List<dynamic> filterProductionReportGridList=[];

  List<dynamic> tempProductionPlantFilter=[];
  List<dynamic> tempProductionMachineFilter=[];
  List<dynamic> tempProductionInputMaterialFilter=[];
  List<dynamic> tempProductionOutputMaterialFilter=[];


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
      if(element['IsActive']==1){
        tempProductionPlantFilter=tempProductionPlantFilter+productionReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });


    machineList.forEach((element) {
      if(element['IsActive']==1){
        tempProductionMachineFilter=tempProductionMachineFilter+tempProductionPlantFilter.where((ele) => ele['MachineId']==element['MachineId']).toList();
      }
    });

    inputMaterialList.forEach((element) {
      if(element['IsActive']==1){
        tempProductionInputMaterialFilter=tempProductionInputMaterialFilter+tempProductionMachineFilter.where((ele) => ele['InputMaterialId']==element['InputMaterialId']).toList();
      }
    });


    outputMaterialList.forEach((element) {
      if(element['IsActive']==1){
        filterProductionReportGridList=filterProductionReportGridList+tempProductionInputMaterialFilter.where((ele) => ele['OutputMaterialId']==element['OutputMaterialId']).toList();
      }
    });


    totalReport=filterProductionReportGridList.length;
    filterProductionReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element['OutputMaterialQuantity']);
      totalReportQty=Calculation().add(totalReportQty, element['InputMaterialQuantity']);
    });

    reportsGridDataList=filterProductionReportGridList;
    notifyListeners();
  }




  /*  Invoice Report */
  List<ReportGridStyleModel2> invoiceReportGridCol=[ReportGridStyleModel2(columnName: "InvoiceNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel2(columnName: "InvoiceDate",isDate: true),ReportGridStyleModel2(columnName: "InvoiceType"),ReportGridStyleModel2(columnName:"PartyName"),
    ReportGridStyleModel2(columnName: "GrandTotalAmount"),ReportGridStyleModel2(columnName: "PaidOrReceivedAmount"),ReportGridStyleModel2(columnName: "PaymentStatus"),
    ReportGridStyleModel2(columnName: "PaymentCategoryName"),ReportGridStyleModel2(columnName: "PlantName"),

  ];



  List<dynamic> invoiceReportGridList=[];
  List<dynamic> filterInvoiceReportGridList=[];

  List<dynamic> tempInvoicePlantFilter=[];
  List<dynamic> tempInvoiceTypeFilter=[];
  List<dynamic> tempInvoicePartyNameFilter=[];
  List<dynamic> tempInvoicePaymentStatusFilter=[];
  List<dynamic> tempInvoicePaymentTypeFilter=[];


  filterInvoice() async{

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
      if(element['IsActive']==1){
        tempInvoicePlantFilter=tempInvoicePlantFilter+invoiceReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });


    invoiceTypeList.forEach((element) {
      if(element['IsActive']==1){
        tempInvoiceTypeFilter=tempInvoiceTypeFilter+tempInvoicePlantFilter.where((ele) => ele['InvoiceType']==element['InvoiceType']).toList();
      }
    });


    partyNameList.forEach((element) {
      if(element['IsActive']==1){
        tempInvoicePartyNameFilter=tempInvoicePartyNameFilter+tempInvoiceTypeFilter.where((ele) => ele['PartyId']==element['PartyId']).toList();
      }
    });


    paymentStatusList.forEach((element) {
      if(element['IsActive']==1){
        tempInvoicePaymentStatusFilter=tempInvoicePaymentStatusFilter+tempInvoicePartyNameFilter.where((ele) => ele['PaymentStatus']==element['PaymentStatus']).toList();
      }
    });


    paymentTypeList.forEach((element) {
      if(element['IsActive']==1){
        filterInvoiceReportGridList=filterInvoiceReportGridList+tempInvoicePaymentStatusFilter.where((ele) => ele['PaymentCategoryId']==element['PaymentCategoryId']).toList();
      }
    });


    totalReport=filterInvoiceReportGridList.length;
    totalReportQty=filterInvoiceReportGridList.where((element) => element['InvoiceType']=="Payable").toList().length.toDouble();
    totalReportAmount=filterInvoiceReportGridList.where((element) => element['InvoiceType']=="Receivable").toList().length.toDouble();


    reportsGridDataList=filterInvoiceReportGridList;
    notifyListeners();
  }


  /*  ReceivablePaymentReport Report */
  List<ReportGridStyleModel2> receivablePaymentReportReportGridCol=[ReportGridStyleModel2(columnName: "InvoiceNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel2(columnName: "InvoiceDate",isDate: true),ReportGridStyleModel2(columnName: "InvoiceType"),ReportGridStyleModel2(columnName:"PartyName"),
    ReportGridStyleModel2(columnName: "GrandTotalAmount"),ReportGridStyleModel2(columnName: "ReceivedAmount"),ReportGridStyleModel2(columnName: "BalanceAmount"),
    ReportGridStyleModel2(columnName: "PaymentStatus"),ReportGridStyleModel2(columnName: "PaymentCategoryName"),ReportGridStyleModel2(columnName: "PlantName"),

  ];



  List<dynamic> receivablePaymentReportReportGridList=[];
  List<dynamic> filterReceivablePaymentReportReportGridList=[];

  List<dynamic> tempReceivablePaymentReportPlantFilter=[];
  List<dynamic> tempReceivablePaymentReportPartyNameFilter=[];
  List<dynamic> tempReceivablePaymentReportPaymentStatusFilter=[];
  List<dynamic> tempReceivablePaymentReportPaymentTypeFilter=[];


  filterReceivablePaymentReport() async{

    filterReceivablePaymentReportReportGridList.clear();
    reportsGridDataList.clear();

    tempReceivablePaymentReportPlantFilter.clear();
    tempReceivablePaymentReportPartyNameFilter.clear();
    tempReceivablePaymentReportPaymentStatusFilter.clear();
    tempReceivablePaymentReportPaymentTypeFilter.clear();



    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;

    plantList.forEach((element) {
      if(element['IsActive']==1){
        tempReceivablePaymentReportPlantFilter=tempReceivablePaymentReportPlantFilter+receivablePaymentReportReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });


    partyNameList.forEach((element) {
      if(element['IsActive']==1){
        tempReceivablePaymentReportPartyNameFilter=tempReceivablePaymentReportPartyNameFilter+tempReceivablePaymentReportPlantFilter.where((ele) => ele['PartyId']==element['PartyId']).toList();
      }
    });


    invoiceTypeList.forEach((element) {
      if(element['IsActive']==1){
        tempReceivablePaymentReportPaymentStatusFilter=tempReceivablePaymentReportPaymentStatusFilter+tempReceivablePaymentReportPartyNameFilter.where((ele) => ele['PaymentStatus']==element['InvoiceType']).toList();
      }
    });



    paymentTypeList.forEach((element) {
      if(element['IsActive']==1){
        filterReceivablePaymentReportReportGridList=filterReceivablePaymentReportReportGridList+tempReceivablePaymentReportPaymentStatusFilter.where((ele) => ele['PaymentCategoryId']==element['PaymentCategoryId']).toList();
      }
    });


    totalReport=filterReceivablePaymentReportReportGridList.length;

    filterReceivablePaymentReportReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element['ReceivedAmount']);
      totalReportQty=Calculation().add(totalReportQty, element['BalanceAmount']);
    });




    reportsGridDataList=filterReceivablePaymentReportReportGridList;
    notifyListeners();
  }

  /*  PayablePaymentReport Report */
  List<ReportGridStyleModel2> payablePaymentReportGridCol=[ReportGridStyleModel2(columnName: "InvoiceNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel2(columnName: "InvoiceDate",isDate: true),ReportGridStyleModel2(columnName: "InvoiceType"),ReportGridStyleModel2(columnName:"PartyName"),
    ReportGridStyleModel2(columnName: "GrandTotalAmount"),ReportGridStyleModel2(columnName: "PaidAmount"),ReportGridStyleModel2(columnName: "BalanceAmount"),
    ReportGridStyleModel2(columnName: "PaymentStatus"),ReportGridStyleModel2(columnName: "PaymentCategoryName"),ReportGridStyleModel2(columnName: "PlantName"),

  ];



  List<dynamic> payablePaymentReportGridList=[];
  List<dynamic> filterPayablePaymentReportGridList=[];

  List<dynamic> tempPayablePaymentReportPlantFilter=[];
  List<dynamic> tempPayablePaymentReportPartyNameFilter=[];
  List<dynamic> tempPayablePaymentReportPaymentStatusFilter=[];
  List<dynamic> tempPayablePaymentReportPaymentTypeFilter=[];


  filterPayablePaymentReport() async{

    filterPayablePaymentReportGridList.clear();
    reportsGridDataList.clear();

    tempPayablePaymentReportPlantFilter.clear();
    tempPayablePaymentReportPartyNameFilter.clear();
    tempPayablePaymentReportPaymentStatusFilter.clear();
    tempPayablePaymentReportPaymentTypeFilter.clear();



    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;

    plantList.forEach((element) {
      if(element['IsActive']==1){
        tempPayablePaymentReportPlantFilter=tempPayablePaymentReportPlantFilter+payablePaymentReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });


    partyNameList.forEach((element) {
      if(element['IsActive']==1){
        tempPayablePaymentReportPartyNameFilter=tempPayablePaymentReportPartyNameFilter+tempPayablePaymentReportPlantFilter.where((ele) => ele['PartyId']==element['SupplierId']).toList();
      }
    });


    invoiceTypeList.forEach((element) {
      if(element['IsActive']==1){
        tempPayablePaymentReportPaymentStatusFilter=tempPayablePaymentReportPaymentStatusFilter+tempPayablePaymentReportPartyNameFilter.where((ele) => ele['PaymentStatus']==element['InvoiceType']).toList();
      }
    });



    paymentTypeList.forEach((element) {
      if(element['IsActive']==1){
        filterPayablePaymentReportGridList=filterPayablePaymentReportGridList+tempPayablePaymentReportPaymentStatusFilter.where((ele) => ele['PaymentCategoryId']==element['PaymentCategoryId']).toList();
      }
    });


    totalReport=filterPayablePaymentReportGridList.length;

    filterPayablePaymentReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element['PaidAmount']);
      totalReportQty=Calculation().add(totalReportQty, element['BalanceAmount']);
    });




    reportsGridDataList=filterPayablePaymentReportGridList;
    notifyListeners();
  }



  /*  EmployeeReport Report */

  List<ReportGridStyleModel2> employeeReportGridCol=[ReportGridStyleModel2(columnName: "InvoiceNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel2(columnName: "InvoiceDate",isDate: true),ReportGridStyleModel2(columnName: "InvoiceType"),ReportGridStyleModel2(columnName:"PartyName"),
    ReportGridStyleModel2(columnName: "GrandTotalAmount"),ReportGridStyleModel2(columnName: "PaidAmount"),ReportGridStyleModel2(columnName: "BalanceAmount"),
    ReportGridStyleModel2(columnName: "PaymentStatus"),ReportGridStyleModel2(columnName: "PaymentCategoryName"),ReportGridStyleModel2(columnName: "PlantName"),

  ];



  List<dynamic> employeeReportGridList=[];
  List<dynamic> filterEmployeeReportGridList=[];

  List<dynamic> tempEmployeeReportPlantFilter=[];
  List<dynamic> tempEmployeeReportPartyNameFilter=[];



  filterEmployeeReport() async{

    filterEmployeeReportGridList.clear();
    reportsGridDataList.clear();


    tempEmployeeReportPartyNameFilter.clear();




    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;







    employeeList.forEach((element) {
      if(element['IsActive']==1){
        filterEmployeeReportGridList=employeeReportGridList.where((ele) => ele['EmployeeId']==element['EmployeeId']).toList();
      }
    });


    totalReport=filterEmployeeReportGridList.length;

    filterEmployeeReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element['PaidAmount']);
      totalReportQty=Calculation().add(totalReportQty, element['BalanceAmount']);
    });




    reportsGridDataList=filterEmployeeReportGridList;
    notifyListeners();
  }




  /*  DieselPurchaseReport Report */
  List<ReportGridStyleModel2> dieselPurchaseReportGridCol=[ReportGridStyleModel2(columnName: "BillNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel2(columnName: "PurchaserName"),ReportGridStyleModel2(columnName: "DieselBunkLocation"),ReportGridStyleModel2(columnName:"DieselBunkContactNumber"),
    ReportGridStyleModel2(columnName: "DieselQuantity"),ReportGridStyleModel2(columnName: "DieselRate"),ReportGridStyleModel2(columnName: "TotalAmount"),
    ReportGridStyleModel2(columnName: "PurchasedDate"),ReportGridStyleModel2(columnName: "PlantName"),

  ];



  List<dynamic> dieselPurchaseReportGridList=[];
  List<dynamic> filterDieselPurchaseReportGridList=[];

  List<dynamic> tempDieselPurchaseReportPlantFilter=[];
  List<dynamic> tempDieselPurchaseReportPurchaserFilter=[];
  List<dynamic> tempDieselPurchaseReportLocationFilter=[];
  List<dynamic> tempDieselPurchaseReportDieselRateFilter=[];


  filterDieselPurchaseReport() async{

    filterDieselPurchaseReportGridList.clear();
    reportsGridDataList.clear();

    tempDieselPurchaseReportPlantFilter.clear();
    tempDieselPurchaseReportPurchaserFilter.clear();
    tempDieselPurchaseReportLocationFilter.clear();
    tempDieselPurchaseReportDieselRateFilter.clear();


    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;

    plantList.forEach((element) {
      if(element['IsActive']==1){
        tempDieselPurchaseReportPlantFilter=tempDieselPurchaseReportPlantFilter+dieselPurchaseReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });


    employeeList.forEach((element) {
      if(element['IsActive']==1){
        tempDieselPurchaseReportPurchaserFilter=tempDieselPurchaseReportPurchaserFilter+tempDieselPurchaseReportPlantFilter.where((ele) => ele['EmployeeId']==element['EmployeeId']).toList();
      }
    });


    locationList.forEach((element) {
      if(element['IsActive']==1){
        tempDieselPurchaseReportLocationFilter=tempDieselPurchaseReportLocationFilter+tempDieselPurchaseReportPurchaserFilter.where((ele) => ele['DieselBunkLocation']==element['DieselBunkLocation']).toList();
      }
    });


    dieselRateList.forEach((element) {
      if(element['IsActive']==1){
        filterDieselPurchaseReportGridList=filterDieselPurchaseReportGridList+tempDieselPurchaseReportLocationFilter.where((ele) => ele['DieselRate']==element['DieselRate']).toList();
      }
    });





    totalReport=filterDieselPurchaseReportGridList.length;

    filterDieselPurchaseReportGridList.forEach((element) {
      totalReportQty=Calculation().add(totalReportQty, element['DieselQuantity']);
      totalReportAmount=Calculation().add(totalReportAmount, element['TotalAmount']);

    });

    reportsGridDataList=filterDieselPurchaseReportGridList;
    notifyListeners();
  }



  /*  MachineManagementReport Report */
  List<ReportGridStyleModel2> machineManagementReportGridCol=[ReportGridStyleModel2(columnName: "MachineName",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
    ReportGridStyleModel2(columnName: "MachineModel"),ReportGridStyleModel2(columnName: "OperatorName"),ReportGridStyleModel2(columnName:"MachineServiceDate",isDate: true),
    ReportGridStyleModel2(columnName: "OperatorInTime"),ReportGridStyleModel2(columnName: "OperatorOutTime"),ReportGridStyleModel2(columnName: "Reason"),
    ReportGridStyleModel2(columnName: "ResponsiblePerson"),ReportGridStyleModel2(columnName: "PlantName"),

  ];



  List<dynamic> machineManagementReportGridList=[];
  List<dynamic> filterMachineManagementReportGridList=[];

  List<dynamic> tempMachineManagementReportPlantFilter=[];
  List<dynamic> tempMachineManagementReportMachineFilter=[];
  List<dynamic> tempMachineManagementReportEmployeeFilter=[];


  filterMachineManagementReport() async{

    filterMachineManagementReportGridList.clear();
    reportsGridDataList.clear();

    tempMachineManagementReportPlantFilter.clear();
    tempMachineManagementReportMachineFilter.clear();
    tempMachineManagementReportEmployeeFilter.clear();



    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=null;

    plantList.forEach((element) {
      if(element['IsActive']==1){
        tempMachineManagementReportPlantFilter=tempMachineManagementReportPlantFilter+machineManagementReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });


    machineList.forEach((element) {
      if(element['IsActive']==1){
        tempMachineManagementReportMachineFilter=tempMachineManagementReportMachineFilter+tempMachineManagementReportPlantFilter.where((ele) => ele['MachineId']==element['MachineId']).toList();
      }
    });



    employeeList.forEach((element) {
      if(element['IsActive']==1){
        filterMachineManagementReportGridList=filterMachineManagementReportGridList+tempMachineManagementReportMachineFilter.where((ele) => ele['ResponsibleEmployeeId']==element['EmployeeId']).toList();
      }
    });





    totalReport=filterMachineManagementReportGridList.length;
    Map<int,dynamic> machinesTotal={};

    filterMachineManagementReportGridList.forEach((element) {

      if(!machinesTotal.containsKey(element['MachineId'])){
        machinesTotal[element['MachineId']]=element['MachineName'];
      }

    });

    totalReportQty=machinesTotal.length;

    reportsGridDataList=filterMachineManagementReportGridList;
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