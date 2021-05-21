import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<dynamic> employeeShift=[];
 List<dynamic>  dieselRateList=[];/*{
            "DieselRate": 0.00
        }*/
List<dynamic> vehicleTypeList=[];/* {
            "VehicleTypeId": 1,
            "VehicleTypeName": "Cargo",
            "IsActive": 1
        }*/


  List<int> filterAll=[];
  List<bool> columnFilterAll=[];

  Future<dynamic> ReportsDropDownValues(BuildContext context,String typeName) async {
    TypeName=typeName;
   // dateTime=DateTime.parse('1999-01-01');
    filtersList.clear();
    updateReportLoader(true);

    if(typeName=="SaleReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> salesReportGridCol=[ReportGridStyleModel2(columnName: "Sales Number"),
        ReportGridStyleModel2(columnName: "Date",isDate: true,width: 130),ReportGridStyleModel2(columnName: "Material"),ReportGridStyleModel2(columnName:"Qty"),
        ReportGridStyleModel2(columnName: "Amount"),ReportGridStyleModel2(columnName: "Customer Name"),ReportGridStyleModel2(columnName: "Plant Name"),];
      reportHeader="Sales Report";
      totalReportTitle="Total Sale";
      totalReportQtyTitle="Sale Quantity";
      totalReportAmountTitle="Sale Amount";
      reportsGridColumnList=salesReportGridCol;
    }
    else if(typeName=="PurchaseReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> purchaseReportGridCol=[ReportGridStyleModel2(columnName: "Purchase No",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Date",isDate: true,width: 130),ReportGridStyleModel2(columnName: "Material"),ReportGridStyleModel2(columnName:"Qty"),
        ReportGridStyleModel2(columnName: "Amount"),ReportGridStyleModel2(columnName: "Supplier Name"),ReportGridStyleModel2(columnName: "Plant Name"),];
      reportHeader="Purchase Report";
      totalReportTitle="Total Purchase";
      totalReportQtyTitle="Purchase Quantity";
      totalReportAmountTitle="Purchase Amount";
      reportsGridColumnList=purchaseReportGridCol;
    }
    else if(typeName=="CustomerSaleReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> customerSaleReportGridCol=[ReportGridStyleModel2(columnName: "Sales Number",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Date",isDate: true,width: 130),ReportGridStyleModel2(columnName: "Customer Name"),ReportGridStyleModel2(columnName:"Material"),
        ReportGridStyleModel2(columnName:"Qty"), ReportGridStyleModel2(columnName: "Amount"),ReportGridStyleModel2(columnName: "Payment Type"),
        ReportGridStyleModel2(columnName: "Vehicle No"),ReportGridStyleModel2(columnName: "Location"),ReportGridStyleModel2(columnName: "Contact Number"),
        ReportGridStyleModel2(columnName: "Plant Name"),];
      reportHeader="Customer Sale Report";
      totalReportTitle="Total Sale";
      totalReportQtyTitle="Sale Quantity";
      totalReportAmountTitle="Sale Amount";
      reportsGridColumnList=customerSaleReportGridCol;
    }
    else if(typeName=="SupplierPurchaseReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> supplierPurchaseReportGridCol=[ReportGridStyleModel2(columnName: "PurchaseOrderNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "CreatedDate",isDate: true),ReportGridStyleModel2(columnName: "SupplierName"),ReportGridStyleModel2(columnName:"Location"),
        ReportGridStyleModel2(columnName: "ContactNumber"),ReportGridStyleModel2(columnName: "MaterialName"),ReportGridStyleModel2(columnName: "PurchaseQuantity"),
        ReportGridStyleModel2(columnName: "Amount"),ReportGridStyleModel2(columnName: "PlantName"),

      ];
      reportHeader="Supplier Purchase Report";
      totalReportTitle="Total Purchase";
      totalReportQtyTitle="Total Purchase Qty";
      totalReportAmountTitle="Total Amount";
      reportsGridColumnList=supplierPurchaseReportGridCol;
    }
    else if(typeName=="ProductionReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> productionReportGridCol=[ReportGridStyleModel2(columnName: "ProductionDate",isDate: true),
        ReportGridStyleModel2(columnName: "MachineName"),ReportGridStyleModel2(columnName: "InputMaterialName"),
        ReportGridStyleModel2(columnName: "ShowInputMaterialQuantity"),ReportGridStyleModel2(columnName: "TotalOutputMaterial",alignment: Alignment.center),
        ReportGridStyleModel2(columnName: "OutputMaterialName"),ReportGridStyleModel2(columnName: "ShowOutputMaterialQuantity"),];
      reportHeader="Production Report";
      totalReportTitle="Total Production";
      totalReportQtyTitle="Input Material Qty";
      totalReportAmountTitle="Output Material Qty";
      reportsGridColumnList=productionReportGridCol;
    }
    else if(typeName=="InvoiceReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> invoiceReportGridCol=[ReportGridStyleModel2(columnName: "InvoiceNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "InvoiceDate",isDate: true),ReportGridStyleModel2(columnName: "InvoiceType"),ReportGridStyleModel2(columnName:"PartyName"),
        ReportGridStyleModel2(columnName: "GrandTotalAmount"),ReportGridStyleModel2(columnName: "PaidOrReceivedAmount"),ReportGridStyleModel2(columnName: "PaymentStatus"),
        ReportGridStyleModel2(columnName: "PaymentCategoryName"),ReportGridStyleModel2(columnName: "PlantName"),

      ];
      reportHeader="Invoice Report";
      totalReportTitle="Total Invoices";
      totalReportQtyTitle="Total Payable Invoices";
      totalReportAmountTitle="Total Receivable Invoices";
      reportsGridColumnList=invoiceReportGridCol;
    }
    else if(typeName=="ReceivablePaymentReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> receivablePaymentReportReportGridCol=[ReportGridStyleModel2(columnName: "InvoiceNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "InvoiceDate",isDate: true),ReportGridStyleModel2(columnName: "InvoiceType"),ReportGridStyleModel2(columnName:"PartyName"),
        ReportGridStyleModel2(columnName: "GrandTotalAmount"),ReportGridStyleModel2(columnName: "ReceivedAmount"),ReportGridStyleModel2(columnName: "BalanceAmount"),
        ReportGridStyleModel2(columnName: "PaymentStatus"),ReportGridStyleModel2(columnName: "PaymentCategoryName"),ReportGridStyleModel2(columnName: "PlantName"),

      ];
      reportHeader="Receivable Payment Report";
      totalReportTitle="Total Invoices";
      totalReportQtyTitle="Total Received Amount";
      totalReportAmountTitle="Total Balance Amount";
      reportsGridColumnList=receivablePaymentReportReportGridCol;
    }
    else if(typeName=="PayablePaymentReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> payablePaymentReportGridCol=[ReportGridStyleModel2(columnName: "InvoiceNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "InvoiceDate",isDate: true),ReportGridStyleModel2(columnName: "InvoiceType"),ReportGridStyleModel2(columnName:"PartyName"),
        ReportGridStyleModel2(columnName: "GrandTotalAmount"),ReportGridStyleModel2(columnName: "PaidAmount"),ReportGridStyleModel2(columnName: "BalanceAmount"),
        ReportGridStyleModel2(columnName: "PaymentStatus"),ReportGridStyleModel2(columnName: "PaymentCategoryName"),ReportGridStyleModel2(columnName: "PlantName"),

      ];
      reportHeader="Payable Payment Report";
      totalReportTitle="Total Invoices";
      totalReportQtyTitle="Total Paid Amount";
      totalReportAmountTitle="Total Balance Amount";
      reportsGridColumnList=payablePaymentReportGridCol;
    }
    else if(typeName=="EmployeeReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> employeeReportGridCol=[ReportGridStyleModel2(columnName: "EmployeeCode",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Name"),ReportGridStyleModel2(columnName: "Designation"),ReportGridStyleModel2(columnName:"Location"),
        ReportGridStyleModel2(columnName: "EmployeeDateOfBirth",isDate: true),ReportGridStyleModel2(columnName: "EmployeeDateOfJoin",isDate: true),ReportGridStyleModel2(columnName: "Shift"),
        ReportGridStyleModel2(columnName: "TotalWorkingDays"),ReportGridStyleModel2(columnName: "TotalLeave"),ReportGridStyleModel2(columnName: "MonthlySalary"),
        ReportGridStyleModel2(columnName: "OT"),ReportGridStyleModel2(columnName: "AdvanceLoan"),ReportGridStyleModel2(columnName: "NetPay"),

      ];
      reportHeader="Employee Report";
      totalReportTitle="Total Employees";
      totalReportQtyTitle="Total Salary";
      totalReportAmountTitle="Total Net Salary";
      reportsGridColumnList=employeeReportGridCol;
    }
    else if(typeName=="AttendanceReport"){
      reportsGridColumnList.clear();
      reportHeader="Attendance Report";
      totalReportTitle="Total Employees";
      totalReportQtyTitle=" ";
      totalReportAmountTitle=" ";
      reportsGridColumnList=attendanceReportGridCol;
    }
    else if(typeName=="DieselPurchaseReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> dieselPurchaseReportGridCol=[ReportGridStyleModel2(columnName: "BillNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "PurchaserName"),ReportGridStyleModel2(columnName: "DieselBunkLocation"),ReportGridStyleModel2(columnName:"DieselBunkContactNumber"),
        ReportGridStyleModel2(columnName: "DieselQuantity"),ReportGridStyleModel2(columnName: "DieselRate"),ReportGridStyleModel2(columnName: "TotalAmount"),
        ReportGridStyleModel2(columnName: "PurchasedDate"),ReportGridStyleModel2(columnName: "PlantName"),

      ];

      reportHeader="Diesel Purchase Report";
      totalReportTitle="Total Bill";
      totalReportQtyTitle="Total Quantity";
      totalReportAmountTitle="Total Amount";
      reportsGridColumnList=dieselPurchaseReportGridCol;
    }
    else if(typeName=="DieselIssueReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> dieselIssueReportGridCol=[ReportGridStyleModel2(columnName: "IssuedDate",edgeInsets: EdgeInsets.only(left: 10,right: 10),isDate: true),
        ReportGridStyleModel2(columnName: "Type"),ReportGridStyleModel2(columnName: "Machine/Vehicle"),ReportGridStyleModel2(columnName:"DieselIssuedQuantity"),
        ReportGridStyleModel2(columnName: "MachineFuelReadingQuantity"),ReportGridStyleModel2(columnName: "IssuedName"),
        ReportGridStyleModel2(columnName: "PlantName"),

      ];

      reportHeader="Diesel Issue Report";
      totalReportTitle="Total Issue";
      totalReportQtyTitle="Total Quantity";
      totalReportAmountTitle=" ";
      reportsGridColumnList=dieselIssueReportGridCol;
    }
    else if(typeName=="MachineManagementReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> machineManagementReportGridCol=[ReportGridStyleModel2(columnName: "MachineName",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "MachineModel"),ReportGridStyleModel2(columnName: "OperatorName"),ReportGridStyleModel2(columnName:"MachineServiceDate",isDate: true),
        ReportGridStyleModel2(columnName: "OperatorInTime"),ReportGridStyleModel2(columnName: "OperatorOutTime"),ReportGridStyleModel2(columnName: "Reason"),
        ReportGridStyleModel2(columnName: "ResponsiblePerson"),ReportGridStyleModel2(columnName: "PlantName"),

      ];
      reportHeader="Machine Management Report";
      totalReportTitle="Total Issues";
      totalReportQtyTitle="Total Machines";
      totalReportAmountTitle=" ";
      reportsGridColumnList=machineManagementReportGridCol;
    }
    else if(typeName=="SaleAuditReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> saleAuditReportGridCol=[ReportGridStyleModel2(columnName: "SaleNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "CustomerGSTNumber"),ReportGridStyleModel2(columnName: "CustomerName"),ReportGridStyleModel2(columnName:"CGST"),
        ReportGridStyleModel2(columnName: "SGST"),ReportGridStyleModel2(columnName: "DiscountAmount"),ReportGridStyleModel2(columnName: "GrossAmount"),
        ReportGridStyleModel2(columnName: "PlantName"),

      ];

      reportHeader="Sale Audit Report";
      totalReportTitle="Total Sales";
      totalReportQtyTitle="Total Amount";
      totalReportAmountTitle="Discount Amount";
      reportsGridColumnList=saleAuditReportGridCol;
    }
    else if(typeName=="PurchaseAuditReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> purchaseAuditReportGridCol=[ReportGridStyleModel2(columnName: "Purchase No",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "GST No"),ReportGridStyleModel2(columnName: "Supplier Name"),ReportGridStyleModel2(columnName:"CGST"),
        ReportGridStyleModel2(columnName: "SGST"),ReportGridStyleModel2(columnName: "DisCount"),ReportGridStyleModel2(columnName: "Grand Total"),
        ReportGridStyleModel2(columnName: "Plant Name"),

      ];

      reportHeader="Purchase Audit Report";
      totalReportTitle="Total Purchase";
      totalReportQtyTitle="Total Amount";
      totalReportAmountTitle="Discount Amount";
      reportsGridColumnList=purchaseAuditReportGridCol;
    }
    else if(typeName=="VehicleMonitoringReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> vehicleMonitoringReportGridCol=[ReportGridStyleModel2(columnName: "Date",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "VehicleTypeName"),ReportGridStyleModel2(columnName: "VehicleNumber"),ReportGridStyleModel2(columnName:"InTime"),
        ReportGridStyleModel2(columnName: "OutTime"),ReportGridStyleModel2(columnName: "MaterialName"),ReportGridStyleModel2(columnName: "Qty"),
        ReportGridStyleModel2(columnName: "Amount"),

      ];

      reportHeader="Vehicle Monitoring Report";
      totalReportTitle="Total Vehicle";
      totalReportQtyTitle="Total Amount";
      totalReportAmountTitle=" ";
      reportsGridColumnList=vehicleMonitoringReportGridCol;
    }

    else if(typeName=="StockReport"){
      reportsGridColumnList.clear();
      List<ReportGridStyleModel2> stockReportGridCol=[ReportGridStyleModel2(columnName: "MaterialName",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Stock"),ReportGridStyleModel2(columnName: "Type"),ReportGridStyleModel2(columnName:"PlantName"),


      ];
      reportHeader="Stock Report";
      totalReportTitle="Total Materials";
      totalReportQtyTitle="Total Input Stock";
      totalReportAmountTitle="Total Output Stock";
      reportsGridColumnList=stockReportGridCol;
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
            columnFilterAll.clear();
            columnFilterAll.add(true);

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;

            plantList=t;
            materialList=t1;
            customerList=t2;
            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
            filtersList.add(FilterDetailsModel(title:  "Customer Filter", list: customerList, instanceName: 'CustomerName'));

            filterAll=List.filled(filtersList.length, 1);



          }
          else if(typeName=="PurchaseReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);

            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;
            plantList=t;
            materialList=t1;
            supplierList=t2;
            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
            filtersList.add(FilterDetailsModel(title:  "Supplier Filter", list: supplierList, instanceName: 'SupplierName'));

            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="CustomerSaleReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);

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

            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="SupplierPurchaseReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;
            plantList=t;
            materialList=t1;
            supplierList=t2;
            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
            filtersList.add(FilterDetailsModel(title:  "Supplier Filter", list: supplierList, instanceName: 'SupplierName'));
            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="ProductionReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
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
            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="InvoiceReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
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
            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="ReceivablePaymentReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
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
            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="PayablePaymentReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
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
            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="EmployeeReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;


            employeeList=t;
            employeeShift=t1;

            filtersList.add(FilterDetailsModel(title:  "Designation Filter", list: employeeList, instanceName: 'EmployeeDesignationName'),);
            filtersList.add(FilterDetailsModel(title:  "Shift Filter", list: employeeShift, instanceName: 'EmployeeShiftName'));
            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="AttendanceReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;


            employeeList=t;
            employeeShift=t1;

            filtersList.add(FilterDetailsModel(title:  "Designation Filter", list: employeeList, instanceName: 'EmployeeDesignationName'),);
            filtersList.add(FilterDetailsModel(title:  "Shift Filter", list: employeeShift, instanceName: 'EmployeeShiftName'));
            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="DieselPurchaseReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
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
            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="DieselIssueReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;


            plantList=t;
            machineList=t1;
            employeeList=t2;


            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Type Filter", list: machineList, instanceName: 'MachineType'));
            filtersList.add(FilterDetailsModel(title:  "IssuedBy Filter", list: employeeList, instanceName: 'EmployeeName'));
            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="MachineManagementReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;


            plantList=t;
            machineList=t1;
            employeeList=t2;


            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Machine Filter", list: machineList, instanceName: 'MachineName'));
            filtersList.add(FilterDetailsModel(title:  "Employee Filter", list: employeeList, instanceName: 'EmployeeName'));
            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="SaleAuditReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;


            plantList=t;
            customerList =t1;


            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Customer Filter", list: customerList, instanceName: 'CustomerName'));
            filterAll=List.filled(filtersList.length, 1);

          }
          else if(typeName=="PurchaseAuditReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;

            plantList=t;
            supplierList=t1;

            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Supplier  Filter", list: supplierList, instanceName: 'SupplierName'));
            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="VehicleMonitoringReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;

            plantList=t;
            vehicleTypeList=t1;
            materialList=t2;

            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Vehicle Type Filter", list: vehicleTypeList, instanceName: 'VehicleTypeName'));
            filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
            filterAll=List.filled(filtersList.length, 1);
          }
          else if(typeName=="StockReport"){
            columnFilterAll.clear();
            columnFilterAll.add(true);
            var t=parsed["Table"] as List;
            var t1=parsed["Table1"] as List;
            var t2=parsed["Table2"] as List;

            plantList=t;
            materialList=t1;
            inputMaterialList=t2;

            filtersList.add(FilterDetailsModel(title:  "Plant Filter", list: plantList, instanceName: 'PlantName'),);
            filtersList.add(FilterDetailsModel(title:  "Material Filter", list: materialList, instanceName: 'MaterialName'));
            filtersList.add(FilterDetailsModel(title:  "Material Type Filter", list: inputMaterialList, instanceName: 'MaterialCategoryName'));
            filterAll=List.filled(filtersList.length, 1);
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

    print(fromDate);
    print(toDate);

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
            salesReportGridList.clear();
           // var t=parsed["Table"] as List;
            salesReportGridList=parsed["Table"] as List;
            filterSales();
          }
          else if(typeName=="PurchaseReport"){
        //    var t=parsed["Table"] as List;
            purchaseReportGridList=parsed["Table"] as List;
            filterPurchase();
          }
          else if(typeName=="CustomerSaleReport"){
          //  var t=parsed["Table"] as List;
          //  print(t);
            customerSaleReportGridList=parsed["Table"] as List;
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
          else if(typeName=="AttendanceReport"){
            attendanceReportGridCol.clear();
            var t=parsed["Table"] as List;
            for(int i=0;i<t.length;i++){
              attendanceReportGridCol.add(ReportGridStyleModel2(
                columnName: t[i]['DayNum']
              ));
            }
            var t1=parsed["Table1"] as List;
            attendanceReportGridList=t1;
            filterAttendanceReport();
          }
          else if(typeName=="DieselPurchaseReport"){
            var t=parsed["Table"] as List;

            dieselPurchaseReportGridList=t;
            filterDieselPurchaseReport();
          }
          else if(typeName=="DieselIssueReport"){
            var t=parsed["Table"] as List;
            dieselIssueReportGridList=t;
            filterDieselIssueReport();
          }
          else if(typeName=="MachineManagementReport"){
            var t=parsed["Table"] as List;
            machineManagementReportGridList=t;
            filterMachineManagementReport();
          }
          else if(typeName=="SaleAuditReport"){
            var t=parsed["Table"] as List;
            saleAuditReportGridList=t;
            filterSaleAuditReport();
          }
          else if(typeName=="PurchaseAuditReport"){
          //  var t=parsed["Table"] as List;
            purchaseAuditReportGridList=parsed["Table"] as List;
            filterPurchaseAuditReport();
          }
          else if(typeName=="VehicleMonitoringReport"){
            var t=parsed["Table"] as List;
            vehicleMonitoringReportGridList=t;
            filterVehicleMonitoringReport();
          }
          else if(typeName=="StockReport"){
            var t=parsed["Table"] as List;
            stockReportGridList=t;
            filterStockReport();
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
      totalReportAmount=Calculation().add(totalReportAmount, element['Amount']);
      totalReportQty=Calculation().add(totalReportQty, element['Qty']);
    });
    totalReportQty="${totalReportQty} Ton";
    filterSalesReportGridList.sort((a,b)=>a['SaleId'].compareTo(b['SaleId']));

    reportsGridDataList=filterSalesReportGridList;
    notifyListeners();
  }

  searchSales(String v){
    if(v.isEmpty){
      reportsGridDataList=filterSalesReportGridList;
    }else{
      reportsGridDataList=filterSalesReportGridList.where((element) => element['Sales Number'].toString().toLowerCase().contains(v)||
          element['Material'].toString().toLowerCase().contains(v)).toList();
    }
    notifyListeners();
  }


  /* PurchaseReport */




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



    Map<int,dynamic> inputQty={};
    filterPurchaseReportGridList.forEach((element) {
      if(!inputQty.containsKey(element['PurchaseOrderId'])){
        inputQty[element['PurchaseOrderId']]=element['Qty'];
      }
      totalReportQty=Calculation().add(totalReportQty, element['Qty']);
      totalReportAmount=Calculation().add(totalReportAmount, element['Amount']);
    });
    totalReportQty="${totalReportQty} Ton";
    totalReport=inputQty.length;

    filterPurchaseReportGridList.sort((a,b)=>a['PurchaseOrderId'].compareTo(b['PurchaseOrderId']));
    reportsGridDataList=filterPurchaseReportGridList;
    notifyListeners();

  }

  searchPurchase(String v){
    if(v.isEmpty){
      reportsGridDataList=filterPurchaseReportGridList;
    }else{
      reportsGridDataList=filterPurchaseReportGridList.where((element) => element['Purchase No'].toString().toLowerCase().contains(v)||
          element['Material'].toString().toLowerCase().contains(v)).toList();
    }
    notifyListeners();
  }

  /* Customer Sale Report */



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
        filterCustomerSaleReportGridList=filterCustomerSaleReportGridList+tempCustomerSalePaymentTypeFilter.where((ele) => ele['Location'].toString().toLowerCase()==element['Location'].toString().toLowerCase()).toList();
      }
    });




    totalReport=filterCustomerSaleReportGridList.length;
    filterCustomerSaleReportGridList.forEach((element) {
      totalReportAmount=Calculation().add(totalReportAmount, element['Amount']);
      totalReportQty=Calculation().add(totalReportQty, element['Qty']);
    });
    totalReportQty="${totalReportQty} Ton";
    print(customerSaleReportGridList);
    customerSaleReportGridList.forEach((element) {
      print(element['SaleId']);
    });

    filterCustomerSaleReportGridList.sort((a,b)=>a['SaleId'].compareTo(b['SaleId']));
    reportsGridDataList=filterCustomerSaleReportGridList;
    notifyListeners();
  }

  searchCustomerSale(String v){
    if(v.isEmpty){
      reportsGridDataList=filterCustomerSaleReportGridList;
    }else{
      reportsGridDataList=filterCustomerSaleReportGridList.where((element) => element['Sales Number'].toString().toLowerCase().contains(v)||
          element['Material'].toString().toLowerCase().contains(v) || element['Vehicle No'].toString().toLowerCase().contains(v) ||
          element['Customer Name'].toString().toLowerCase().contains(v) || element['Location'].toString().toLowerCase().contains(v)
      ).toList();
    }
    notifyListeners();
  }

  /*  Supplier  Purchase Report */


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



  List<dynamic> productionReportGridList=[];
  List<dynamic> filterProductionReportGridList=[];

  List<dynamic> tempProductionPlantFilter=[];
  List<dynamic> tempProductionMachineFilter=[];
  List<dynamic> tempProductionInputMaterialFilter=[];
  List<dynamic> tempProductionOutputMaterialFilter=[];


  filterProduction() async{
    print(productionReportGridList);

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



    Map<int,dynamic> inputQty={};
    filterProductionReportGridList.forEach((element) {
      if(!inputQty.containsKey(element['ProductionId'])){
        inputQty[element['ProductionId']]=element['InputMaterialQuantity'];
      }

      totalReportAmount=Calculation().add(totalReportAmount, element['OutputMaterialQuantity']);

    });
    totalReport=inputQty.length;
    inputQty.forEach((key, value) {
      totalReportQty=Calculation().add(totalReportQty, value);
    });

    reportsGridDataList=filterProductionReportGridList;
    notifyListeners();
  }




  /*  Invoice Report */

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





  List<dynamic> employeeReportGridList=[];
  List<dynamic> filterEmployeeReportGridList=[];

  List<dynamic> tempEmployeeReportDesignationFilter=[];

  filterEmployeeReport() async{

    filterEmployeeReportGridList.clear();
    reportsGridDataList.clear();


    tempEmployeeReportDesignationFilter.clear();




    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;







    employeeList.forEach((element) {
      if(element['IsActive']==1){
        tempEmployeeReportDesignationFilter=tempEmployeeReportDesignationFilter+employeeReportGridList.where((ele) => ele['EmployeeDesignationId']==element['EmployeeDesignationId']).toList();
      }
    });

    employeeShift.forEach((element) {
      if(element['IsActive']==1){
        filterEmployeeReportGridList=tempEmployeeReportDesignationFilter.where((ele) => ele['EmployeeShiftId']==element['EmployeeShiftId']).toList();
      }
    });


    totalReport=filterEmployeeReportGridList.length;

    filterEmployeeReportGridList.forEach((element) {
      totalReportQty=Calculation().add(totalReportQty, element['MonthlySalary']??"0.0");
      totalReportAmount=Calculation().add(totalReportAmount, element['NetPay']??"0.0");

    });




    reportsGridDataList=filterEmployeeReportGridList;
    notifyListeners();
  }



  /*  AttendanceReport Report */

  List<ReportGridStyleModel2> attendanceReportGridCol=[];



  List<dynamic> attendanceReportGridList=[];
  List<dynamic> filterAttendanceReportGridList=[];

  List<dynamic> tempAttendanceReportDesignationFilter=[];

  filterAttendanceReport() async{

    filterAttendanceReportGridList.clear();
    reportsGridDataList.clear();


    tempAttendanceReportDesignationFilter.clear();




    totalReport=0;
    totalReportQty=null;
    totalReportAmount=null;







    employeeList.forEach((element) {
      if(element['IsActive']==1){
        tempAttendanceReportDesignationFilter=tempAttendanceReportDesignationFilter+attendanceReportGridList.where((ele) => ele['EmployeeDesignationId']==element['EmployeeDesignationId']).toList();
      }
    });

    employeeShift.forEach((element) {
      if(element['IsActive']==1){
        filterAttendanceReportGridList=tempAttendanceReportDesignationFilter.where((ele) => ele['EmployeeShiftId']==element['EmployeeShiftId']).toList();
      }
    });


    totalReport=filterAttendanceReportGridList.length;


 /*   filterAttendanceReportGridList.forEach((element) {
      element.values.forEach((ele){
        print(ele);
      });

    });*/




    reportsGridDataList=filterAttendanceReportGridList;
    notifyListeners();
  }





  /*  DieselPurchaseReport Report */



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
        tempDieselPurchaseReportLocationFilter=tempDieselPurchaseReportLocationFilter+tempDieselPurchaseReportPurchaserFilter.where((ele) => ele['DieselBunkLocation'].toString().toLowerCase()==element['DieselBunkLocation'].toString().toLowerCase()).toList();
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




  /*  DieselIssueReport Report */



  List<dynamic> dieselIssueReportGridList=[];
  List<dynamic> filterDieselIssueReportGridList=[];

  List<dynamic> tempDieselIssueReportPlantFilter=[];
  List<dynamic> tempDieselIssueReportMachineTypeFilter=[];



  filterDieselIssueReport() async{

    filterDieselIssueReportGridList.clear();
    reportsGridDataList.clear();

    tempDieselIssueReportPlantFilter.clear();
    tempDieselIssueReportMachineTypeFilter.clear();


    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=null;

    plantList.forEach((element) {
      if(element['IsActive']==1){
        tempDieselIssueReportPlantFilter=tempDieselIssueReportPlantFilter+dieselIssueReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });

    machineList.forEach((element) {
      if(element['IsActive']==1){
        tempDieselIssueReportMachineTypeFilter=tempDieselIssueReportMachineTypeFilter+tempDieselIssueReportPlantFilter.where((ele) => ele['Type']==element['MachineType']).toList();
      }
    });

    employeeList.forEach((element) {
      if(element['IsActive']==1){
        filterDieselIssueReportGridList=filterDieselIssueReportGridList+tempDieselIssueReportMachineTypeFilter.where((ele) => ele['IssuedBy']==element['EmployeeId']).toList();
      }
    });







    totalReport=filterDieselIssueReportGridList.length;

    filterDieselIssueReportGridList.forEach((element) {
      totalReportQty=Calculation().add(totalReportQty, element['DieselIssuedQuantity']);
     // totalReportAmount=Calculation().add(totalReportAmount, element['TotalAmount']);

    });

    reportsGridDataList=filterDieselIssueReportGridList;
    notifyListeners();
  }



  /*  MachineManagementReport Report */




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


  /*  SaleAuditReport Report */



  List<dynamic> saleAuditReportGridList=[];
  List<dynamic> filterSaleAuditReportGridList=[];

  List<dynamic> tempSaleAuditReportPlantFilter=[];


  filterSaleAuditReport() async{

    filterSaleAuditReportGridList.clear();
    reportsGridDataList.clear();

    tempSaleAuditReportPlantFilter.clear();




    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;

    plantList.forEach((element) {
      if(element['IsActive']==1){
        tempSaleAuditReportPlantFilter=tempSaleAuditReportPlantFilter+saleAuditReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });



    customerList.forEach((element) {
      if(element['IsActive']==1){
        filterSaleAuditReportGridList=filterSaleAuditReportGridList+tempSaleAuditReportPlantFilter.where((ele) => ele['CustomerId']==element['CustomerId']).toList();
      }
    });





    totalReport=filterSaleAuditReportGridList.length;
    Map<int,dynamic> machinesTotal={};

    filterSaleAuditReportGridList.forEach((element) {
      totalReportQty=Calculation().add(totalReportQty, element['GrossAmount']??0.0);
      totalReportAmount=Calculation().add(totalReportAmount, element['DiscountAmount']??0.0);

    });



    reportsGridDataList=filterSaleAuditReportGridList;
    notifyListeners();
  }

  /*  PurchaseAuditReport Report */



  List<dynamic> purchaseAuditReportGridList=[];
  List<dynamic> filterPurchaseAuditReportGridList=[];

  List<dynamic> tempPurchaseAuditReportPlantFilter=[];


  filterPurchaseAuditReport() async{

    filterPurchaseAuditReportGridList.clear();
    reportsGridDataList.clear();

    tempPurchaseAuditReportPlantFilter.clear();




    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;

    plantList.forEach((element) {
      if(element['IsActive']==1){
        tempPurchaseAuditReportPlantFilter=tempPurchaseAuditReportPlantFilter+purchaseAuditReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });



    supplierList.forEach((element) {
      if(element['IsActive']==1){
        filterPurchaseAuditReportGridList=filterPurchaseAuditReportGridList+tempPurchaseAuditReportPlantFilter.where((ele) => ele['SupplierId']==element['SupplierId']).toList();
      }
    });





    totalReport=filterPurchaseAuditReportGridList.length;


    filterPurchaseAuditReportGridList.forEach((element) {
      totalReportQty=Calculation().add(totalReportQty, element['Grand Total']??0.0);
      totalReportAmount=Calculation().add(totalReportAmount, element['DisCount']??0.0);

    });

    filterPurchaseAuditReportGridList.sort((a,b)=>a['PurchaseOrderId'].compareTo(b['PurchaseOrderId']));

    reportsGridDataList=filterPurchaseAuditReportGridList;
    notifyListeners();
  }
  searchPurchaseAuditReport(String v){
    if(v.isEmpty){
      reportsGridDataList=filterPurchaseAuditReportGridList;
    }else{
      reportsGridDataList=filterPurchaseAuditReportGridList.where((element) => element['Purchase No'].toString().toLowerCase().contains(v)||
          element['Supplier Name'].toString().toLowerCase().contains(v)).toList();
    }
    notifyListeners();
  }



  /*  SaleAuditReport Report */



  List<dynamic> vehicleMonitoringReportGridList=[];
  List<dynamic> filterVehicleMonitoringReportGridList=[];

  List<dynamic> tempVehicleMonitoringReportPlantFilter=[];
  List<dynamic> tempVehicleMonitoringReportVehicleTypeFilter=[];


  filterVehicleMonitoringReport() async{

    filterVehicleMonitoringReportGridList.clear();
    reportsGridDataList.clear();

    tempVehicleMonitoringReportPlantFilter.clear();
    tempVehicleMonitoringReportVehicleTypeFilter.clear();




    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=null;

    plantList.forEach((element) {
      if(element['IsActive']==1){
        tempVehicleMonitoringReportPlantFilter=tempVehicleMonitoringReportPlantFilter+vehicleMonitoringReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });



    vehicleTypeList.forEach((element) {
      if(element['IsActive']==1){
        tempVehicleMonitoringReportVehicleTypeFilter=tempVehicleMonitoringReportVehicleTypeFilter+tempVehicleMonitoringReportPlantFilter.where((ele) => ele['VehicleTypeId']==element['VehicleTypeId']).toList();
      }
    });


    materialList.forEach((element) {
      if(element['IsActive']==1){
        filterVehicleMonitoringReportGridList=filterVehicleMonitoringReportGridList+tempVehicleMonitoringReportVehicleTypeFilter.where((ele) => ele['MaterialId']==element['MaterialId']).toList();
      }
    });





    totalReport=filterVehicleMonitoringReportGridList.length;
    Map<int,dynamic> machinesTotal={};

    filterVehicleMonitoringReportGridList.forEach((element) {
      totalReportQty=Calculation().add(totalReportQty, element['Amount']??0.0);
     // totalReportAmount=Calculation().add(totalReportAmount, element['DiscountAmount']??0.0);

    });



    reportsGridDataList=filterVehicleMonitoringReportGridList;
    notifyListeners();
  }




  /*  StockReport Report */




  List<dynamic> stockReportGridList=[];
  List<dynamic> filterStockReportGridList=[];

  List<dynamic> tempStockReportPlantFilter=[];
  List<dynamic> tempStockReportMaterialFilter=[];


  filterStockReport() async{

    filterStockReportGridList.clear();
    reportsGridDataList.clear();

    tempStockReportPlantFilter.clear();
    tempStockReportMaterialFilter.clear();




    totalReport=0;
    totalReportQty=0.0;
    totalReportAmount=0.0;

    plantList.forEach((element) {
      if(element['IsActive']==1){
        tempStockReportPlantFilter=tempStockReportPlantFilter+stockReportGridList.where((ele) => ele['PlantId']==element['PlantId']).toList();
      }
    });
    materialList.forEach((element) {
      if(element['IsActive']==1){
        tempStockReportMaterialFilter=tempStockReportMaterialFilter+tempStockReportPlantFilter.where((ele) => ele['MaterialId']==element['MaterialId']).toList();
      }
    });



    inputMaterialList.forEach((element) {
      if(element['IsActive']==1){
        filterStockReportGridList=filterStockReportGridList+tempStockReportMaterialFilter.where((ele) => ele['Type']==element['MaterialCategoryName']).toList();
      }
    });





    totalReport=filterStockReportGridList.length;


    filterStockReportGridList.forEach((element) {

      if(element['Type']=='InPut'){
        totalReportQty=Calculation().add(totalReportQty, element['Stock']??0.0);

      }
      else if(element['Type']=='OutPut'){
        totalReportAmount=Calculation().add(totalReportAmount, element['Stock']??0.0);
      }

    });
  //  print(totalReportQty);



    reportsGridDataList=filterStockReportGridList;
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