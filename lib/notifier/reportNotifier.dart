import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/reports/reportGrid.dart';
import 'package:quarry/styles/constants.dart';
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
  dynamic totalReportAmount=0.0;

  List<ReportGridStyleModel2> reportsGridColumnList=[];
  List<dynamic> reportsGridDataList=[];
  List<ReportCounterModel> counterList=[];

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
    print(context);
    TypeName=typeName;
   // dateTime=DateTime.parse('1999-01-01');
    filtersList.clear();
    reportsGridDataList.clear();
    updateReportLoader(true);

    if(typeName=="SaleReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> salesReportGridCol=[ReportGridStyleModel2(columnName: "Sales Number"),
        ReportGridStyleModel2(columnName: "Date",isDate: true,width: 130),ReportGridStyleModel2(columnName: "Material"),ReportGridStyleModel2(columnName:"Qty"),
        ReportGridStyleModel2(columnName: "Amount"),ReportGridStyleModel2(columnName: "Customer Name"),ReportGridStyleModel2(columnName: "Plant Name"),];
      reportHeader="Sales Report";
      totalReportTitle="Total Sale";
      totalReportQtyTitle="Sale Quantity";
      totalReportAmountTitle="Sale Amount";
      reportsGridColumnList=salesReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Sales",value: 0));
      counterList.add(ReportCounterModel(title: "Quantity",value: 0));
      counterList.add(ReportCounterModel(title: "GST Amount",value: 0.0));
      counterList.add(ReportCounterModel(title: "Discount Amount",value: 0.0));
      counterList.add(ReportCounterModel(title: "Grand Total",value: 0.0));
    }
    else if(typeName=="PurchaseReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> purchaseReportGridCol=[ReportGridStyleModel2(columnName: "Purchase No",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Date",isDate: true,width: 130),ReportGridStyleModel2(columnName: "Material"),ReportGridStyleModel2(columnName:"Qty"),
        ReportGridStyleModel2(columnName: "Amount"),ReportGridStyleModel2(columnName: "Supplier Name"),ReportGridStyleModel2(columnName: "Plant Name"),];
      reportHeader="Purchase Report";
      reportsGridColumnList=purchaseReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Purchase",value: 0));
      counterList.add(ReportCounterModel(title: "Purchase Quantity",value: "0.0 Ton"));
      counterList.add(ReportCounterModel(title: "Purchase Amount",value: 0.0));
    }
    else if(typeName=="CustomerSaleReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> customerSaleReportGridCol=[ReportGridStyleModel2(columnName: "Customer Name",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Sales Number",),ReportGridStyleModel2(columnName: "Date",isDate: true,width: 130),
        ReportGridStyleModel2(columnName: "Contact Number"),ReportGridStyleModel2(columnName: "Location"),ReportGridStyleModel2(columnName: "Vehicle No"),
        ReportGridStyleModel2(columnName:"Material"),
        ReportGridStyleModel2(columnName:"Qty"), ReportGridStyleModel2(columnName: "Amount"),ReportGridStyleModel2(columnName: "Payment Type"),
        ReportGridStyleModel2(columnName: "Plant Name"),];
      reportHeader="Customer Sale Report";
      reportsGridColumnList=customerSaleReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Customer",value: 0));
      counterList.add(ReportCounterModel(title: "Sales Quantity",value: "0.0 Ton"));
      counterList.add(ReportCounterModel(title: "Sales Amount",value: 0.0));
    }
    else if(typeName=="SupplierPurchaseReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> supplierPurchaseReportGridCol=[ReportGridStyleModel2(columnName: "Supplier Name",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Purchase No"),ReportGridStyleModel2(columnName: "Date",isDate: true,width: 130),ReportGridStyleModel2(columnName:"Location"),
        ReportGridStyleModel2(columnName: "Contact Number"),ReportGridStyleModel2(columnName: "Material"),ReportGridStyleModel2(columnName: "Qty"),
        ReportGridStyleModel2(columnName: "Amount"),ReportGridStyleModel2(columnName: "Plant Name"),

      ];
      reportHeader="Supplier Purchase Report";
      reportsGridColumnList=supplierPurchaseReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Suppliers",value: 0));
      counterList.add(ReportCounterModel(title: "Purchase Quantity",value: "0.0 Ton"));
      counterList.add(ReportCounterModel(title: "Purchase Amount",value: 0.0));
    }
    else if(typeName=="ProductionReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> productionReportGridCol=[ReportGridStyleModel2(columnName: "Production Date",isDate: true),
        ReportGridStyleModel2(columnName: "Machine Name"),ReportGridStyleModel2(columnName: "Input Material"),
        ReportGridStyleModel2(columnName: "Input Material Qty"),ReportGridStyleModel2(columnName: "Total Output Material",alignment: Alignment.center),
        ReportGridStyleModel2(columnName: "Output Material"),ReportGridStyleModel2(columnName: "Output Material Qty"),];
      reportHeader="Production Report";
      reportsGridColumnList=productionReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Production",value: 0));
      counterList.add(ReportCounterModel(title: "Input Material Qty",value: "0.0 Ton"));
      counterList.add(ReportCounterModel(title: "Output Material Qty",value: "0.0 Ton"));
    }
    else if(typeName=="InvoiceReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> invoiceReportGridCol=[ReportGridStyleModel2(columnName: "Invoice Number",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "InvoiceDate",isDate: true,width: 130),ReportGridStyleModel2(columnName: "Invoice Type"),ReportGridStyleModel2(columnName:"Party Name"),
        ReportGridStyleModel2(columnName: "Gross Amount"),ReportGridStyleModel2(columnName: "Paid/Received Amount"),ReportGridStyleModel2(columnName: "Payment Status"),
        ReportGridStyleModel2(columnName: "Plant Name"),

      ];
      reportHeader="Invoice Report";
      reportsGridColumnList=invoiceReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Invoices",value: 0));
      counterList.add(ReportCounterModel(title: "Total Payable Invoices",value: 0));
      counterList.add(ReportCounterModel(title: "Total Receivable Invoices",value: 0));
    }
    else if(typeName=="ReceivablePaymentReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> receivablePaymentReportReportGridCol=[ReportGridStyleModel2(columnName: "Payment Number",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Invoice Number"),ReportGridStyleModel2(columnName: "Last Payment Date",isDate: true,width: 130),ReportGridStyleModel2(columnName:"Customer Name"),
        ReportGridStyleModel2(columnName: "Grand Total"),ReportGridStyleModel2(columnName: "Received Amount"),ReportGridStyleModel2(columnName: "Balance Amount"),
        ReportGridStyleModel2(columnName: "No Of Dues"),ReportGridStyleModel2(columnName: "Payment Status"),ReportGridStyleModel2(columnName: "Plant Name"),

      ];
      reportHeader="Receivable Payment Report";
      reportsGridColumnList=receivablePaymentReportReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Payment",value: "0 / 0.0"));
      counterList.add(ReportCounterModel(title: "Received Amount",value: "0.0"));
      counterList.add(ReportCounterModel(title: "Balance Amount",value: "0.0"));
    }
    else if(typeName=="PayablePaymentReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> payablePaymentReportGridCol=[ReportGridStyleModel2(columnName: "Payment Number",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Invoice Number",),ReportGridStyleModel2(columnName: "Last Payment Date",isDate: true,width: 130),ReportGridStyleModel2(columnName:"Supplier Name"),
        ReportGridStyleModel2(columnName: "Grand Total"),ReportGridStyleModel2(columnName: "Paid Amount"),ReportGridStyleModel2(columnName: "Balance Amount"),
        ReportGridStyleModel2(columnName: "No Of Dues"),ReportGridStyleModel2(columnName: "Payment Status"),ReportGridStyleModel2(columnName: "Plant Name"),

      ];
      reportHeader="Payable Payment Report";
      reportsGridColumnList=payablePaymentReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Payment",value: "0 / 0.0"));
      counterList.add(ReportCounterModel(title: "Paid Amount",value: "0.0"));
      counterList.add(ReportCounterModel(title: "Balance Amount",value: "0.0"));
    }
    else if(typeName=="EmployeeReport"){
      reportsGridColumnList.clear();
      counterList.clear();
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
      counterList.clear();
      reportHeader="Attendance Report";
      totalReportTitle="Total Employees";
      totalReportQtyTitle=" ";
      totalReportAmountTitle=" ";
      reportsGridColumnList=attendanceReportGridCol;
    }
    else if(typeName=="DieselPurchaseReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> dieselPurchaseReportGridCol=[ReportGridStyleModel2(columnName: "BillNumber",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Purchaser Name"),ReportGridStyleModel2(columnName: "Location"),ReportGridStyleModel2(columnName:"Contact Number"),
        ReportGridStyleModel2(columnName: "Diesel Quantity"),ReportGridStyleModel2(columnName: "Diesel Rate"),ReportGridStyleModel2(columnName: "Amount"),
        ReportGridStyleModel2(columnName: "Date"),ReportGridStyleModel2(columnName: "Plant Name"),

      ];

      reportHeader="Diesel Purchase Report";

      reportsGridColumnList=dieselPurchaseReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Bill",value: 0));
      counterList.add(ReportCounterModel(title: "Total Quantity",value: "0.0 Ltr"));
      counterList.add(ReportCounterModel(title: "Total Amount",value: 0));
    }
    else if(typeName=="DieselIssueReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> dieselIssueReportGridCol=[ReportGridStyleModel2(columnName: "Date",edgeInsets: EdgeInsets.only(left: 10,right: 10),isDate: true),
        ReportGridStyleModel2(columnName: "Type"),ReportGridStyleModel2(columnName: "Machine/Vehicle"),ReportGridStyleModel2(columnName:"Diesel Quantity"),
        ReportGridStyleModel2(columnName: "Issued By"),ReportGridStyleModel2(columnName: "Fuel Reading"),
        ReportGridStyleModel2(columnName: "PlantName"),

      ];

      reportHeader="Diesel Issue Report";
      reportsGridColumnList=dieselIssueReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Issue",value: 0));
      counterList.add(ReportCounterModel(title: "Issued Qty",value: "0.0 Ltr"));
      counterList.add(ReportCounterModel(title: "Machine / Vehicle",value: "0.0 / 0.0 Ltr"));
    }
    else if(typeName=="MachineManagementReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> machineManagementReportGridCol=[ReportGridStyleModel2(columnName: "Machine Name",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Machine Model"),ReportGridStyleModel2(columnName: "Operator"),ReportGridStyleModel2(columnName:"Date",isDate: true,width: 130),
        ReportGridStyleModel2(columnName: "In Time"),ReportGridStyleModel2(columnName: "Out Time"),ReportGridStyleModel2(columnName: "Reason"),
        ReportGridStyleModel2(columnName: "Responsible"),ReportGridStyleModel2(columnName: "Plant Name"),

      ];
      reportHeader="Machine Management Report";
      reportsGridColumnList=machineManagementReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Machines",value: 0));
      counterList.add(ReportCounterModel(title: "Total Issues",value: 0));
    }
    else if(typeName=="SaleAuditReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> saleAuditReportGridCol=[ReportGridStyleModel2(columnName: "Sale Number",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "GST No"),ReportGridStyleModel2(columnName: "Customer Name"),ReportGridStyleModel2(columnName:"SubTotal"),
        ReportGridStyleModel2(columnName: "GST"),ReportGridStyleModel2(columnName: "Discount Amount"),ReportGridStyleModel2(columnName: "Grand Total"),
        ReportGridStyleModel2(columnName: "Plant Name"),

      ];

      reportHeader="Sale Audit Report";
      reportsGridColumnList=saleAuditReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Sales",value: 0));
      counterList.add(ReportCounterModel(title: "GST Amount",value: 0.0));
      counterList.add(ReportCounterModel(title: "Discount Amount",value: 0.0));
      counterList.add(ReportCounterModel(title: "Grand Total",value: 0.0));
    }
    else if(typeName=="PurchaseAuditReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> purchaseAuditReportGridCol=[ReportGridStyleModel2(columnName: "Purchase No",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "GST No"),ReportGridStyleModel2(columnName: "Supplier Name"),ReportGridStyleModel2(columnName:"GST"),
        ReportGridStyleModel2(columnName: "SubTotal"),ReportGridStyleModel2(columnName: "Discount Amount"),ReportGridStyleModel2(columnName: "Grand Total"),
        ReportGridStyleModel2(columnName: "Plant Name"),

      ];

      reportHeader="Purchase Audit Report";
      reportsGridColumnList=purchaseAuditReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Sales",value: 0));
      counterList.add(ReportCounterModel(title: "GST Amount",value: 0.0));
      counterList.add(ReportCounterModel(title: "Discount Amount",value: 0.0));
      counterList.add(ReportCounterModel(title: "Grand Total",value: 0.0));
    }
    else if(typeName=="VehicleMonitoringReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> vehicleMonitoringReportGridCol=[ReportGridStyleModel2(columnName: "Vehicle No",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Type"),ReportGridStyleModel2(columnName: "Vehicle Name"),ReportGridStyleModel2(columnName:"Date",width: 130),
        ReportGridStyleModel2(columnName: "In Time"),ReportGridStyleModel2(columnName: "Out Time"),ReportGridStyleModel2(columnName: "Material"),
        ReportGridStyleModel2(columnName: "Qty"), ReportGridStyleModel2(columnName: "Amount"),

      ];

      reportHeader="Vehicle Monitoring Report";
      reportsGridColumnList=vehicleMonitoringReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Vehicle",value: 0));
      counterList.add(ReportCounterModel(title: "Purchase",value: "0 / 0.0"));
      counterList.add(ReportCounterModel(title: "Sale",value: "0 / 0.0"));
    }

    else if(typeName=="StockReport"){
      reportsGridColumnList.clear();
      counterList.clear();
      List<ReportGridStyleModel2> stockReportGridCol=[ReportGridStyleModel2(columnName: "MaterialName",edgeInsets: EdgeInsets.only(left: 10,right: 10)),
        ReportGridStyleModel2(columnName: "Stock"),ReportGridStyleModel2(columnName: "Type"),ReportGridStyleModel2(columnName:"PlantName"),


      ];
      reportHeader="Stock Report";
      reportsGridColumnList=stockReportGridCol;
      counterList.add(ReportCounterModel(title: "Total Materials",value: 0));
      counterList.add(ReportCounterModel(title: "Total Input Stock",value: "0.0 Ton"));
      counterList.add(ReportCounterModel(title: "Total Output Stock",value: "0.0 Ton"));
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
           // filtersList.add(FilterDetailsModel(title:  "Payment Type Filter", list: paymentTypeList, instanceName: 'PaymentType'));
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
            //filtersList.add(FilterDetailsModel(title:  "Payment Type Filter", list: paymentTypeList, instanceName: 'PaymentType'));
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
         //   filtersList.add(FilterDetailsModel(title:  "Payment Type Filter", list: paymentTypeList, instanceName: 'PaymentType'));
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
            filtersList.add(FilterDetailsModel(title:  "Responsible Person Filter", list: employeeList, instanceName: 'EmployeeName'));
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
   print(context);

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
          print(parsed["Table"]);
          var t=parsed["Table"] as List;
          print("t.ltnht${t.length}");
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
         //   var t=parsed["Table"] as List;
            supplierPurchaseReportGridList=parsed["Table"] as List;
            filterSupplierPurchase();
          }
          else if(typeName=="ProductionReport"){
         //   var t=parsed["Table"] as List;
            productionReportGridList=parsed["Table"] as List;
            filterProduction();
          }
          else if(typeName=="InvoiceReport"){
         //   var t=parsed["Table"] as List;
            invoiceReportGridList=parsed["Table"] as List;
            filterInvoice();
          }
          else if(typeName=="ReceivablePaymentReport"){
          //  var t=parsed["Table"] as List;
            receivablePaymentReportReportGridList=parsed["Table"] as List;
            filterReceivablePaymentReport();
          }
          else if(typeName=="PayablePaymentReport"){
            //var t=parsed["Table"] as List;
            payablePaymentReportGridList=parsed["Table"] as List;
            filterPayablePaymentReport();
          }
          else if(typeName=="EmployeeReport"){
           // var t=parsed["Table"] as List;
            employeeReportGridList=parsed["Table"] as List;
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
          //  var t=parsed["Table"] as List;

            dieselPurchaseReportGridList=parsed["Table"] as List;
            filterDieselPurchaseReport();
          }
          else if(typeName=="DieselIssueReport"){
           // var t=parsed["Table"] as List;
            dieselIssueReportGridList=parsed["Table"] as List;
            filterDieselIssueReport(context);
          }
          else if(typeName=="MachineManagementReport"){
         //   var t=parsed["Table"] as List;
            machineManagementReportGridList=parsed["Table"] as List;
            filterMachineManagementReport();
          }
          else if(typeName=="SaleAuditReport"){
          //  var t=parsed["Table"] as List;
            saleAuditReportGridList=parsed["Table"] as List;
            filterSaleAuditReport();
          }
          else if(typeName=="PurchaseAuditReport"){
          //  var t=parsed["Table"] as List;
            purchaseAuditReportGridList=parsed["Table"] as List;
            filterPurchaseAuditReport();
          }
          else if(typeName=="VehicleMonitoringReport"){
           // var t=parsed["Table"] as List;
            vehicleMonitoringReportGridList=parsed["Table"] as List;
            filterVehicleMonitoringReport();
          }
          else if(typeName=="StockReport"){
            //var t=parsed["Table"] as List;
            stockReportGridList=parsed["Table"] as List;
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


    counterList[0].value=filterSalesReportGridList.length;
    counterList[1].value="${formatCurrency.format(totalReportQty)} Ton";
    counterList[4].value=formatCurrency.format(totalReportAmount);

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

    totalReport=inputQty.length;


    counterList[0].value=inputQty.length;
    counterList[1].value="${formatCurrency.format(totalReportQty)} Ton";
    counterList[2].value=formatCurrency.format(totalReportAmount);

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







    Map<dynamic,dynamic> customers={};
    double qty=0.0;
    double amount=0.0;

    totalReport=filterCustomerSaleReportGridList.length;
    filterCustomerSaleReportGridList.forEach((element) {

      if(!customers.containsKey(element['Customer Name'])){
        customers[element['Customer Name']]=element['Customer Name'];
      }
      qty=Calculation().add(qty, element['Qty']);
      amount=Calculation().add(amount, element['Amount']);
    });


    counterList[0].value=customers.length;
    counterList[1].value="${formatCurrency.format(qty)} Ton";
    counterList[2].value=formatCurrency.format(amount);



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


    Map<int,dynamic> inputQty={};
    filterSupplierPurchaseReportGridList.forEach((element) {
      if(!inputQty.containsKey(element['Supplier'])){
        inputQty[element['Supplier']]=element['Qty'];
      }
      totalReportQty=Calculation().add(totalReportQty, element['Qty']);
      totalReportAmount=Calculation().add(totalReportAmount, element['Amount']);
    });

    totalReport=inputQty.length;

   counterList[0].value=inputQty.length;
   counterList[1].value="${formatCurrency.format(totalReportQty)} Ton";
   counterList[2].value=formatCurrency.format(totalReportAmount);

    filterSupplierPurchaseReportGridList.sort((a,b)=>a['PurchaseOrderId'].compareTo(b['PurchaseOrderId']));

    reportsGridDataList=filterSupplierPurchaseReportGridList;
    notifyListeners();
  }
  searchSupplierPurchase(String v){
    if(v.isEmpty){
      reportsGridDataList=filterSupplierPurchaseReportGridList;
    }else{
      reportsGridDataList=filterSupplierPurchaseReportGridList.where((element) => element['Purchase No'].toString().toLowerCase().contains(v)||
          element['Material'].toString().toLowerCase().contains(v) ||
          element['Supplier Name'].toString().toLowerCase().contains(v) || element['Location'].toString().toLowerCase().contains(v)
      ).toList();
    }
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


    double inputqty=0.0;
    double outputQty=0.0;

    Map<int,dynamic> inputQty={};
    filterProductionReportGridList.forEach((element) {
      if(!inputQty.containsKey(element['ProductionId'])){
        inputQty[element['ProductionId']]=element['InputMaterialQuantity'];
      }

      outputQty=Calculation().add(outputQty, element['OutputMaterialQuantity']);

    });

    inputQty.forEach((key, value) {
      inputqty=Calculation().add(inputqty, value);
    });



    counterList[0].value=inputQty.length;
    counterList[1].value="${formatCurrency.format(inputqty)} Ton";
    counterList[2].value="${formatCurrency.format(outputQty)} Ton";

    filterProductionReportGridList.sort((a,b)=>a['ProductionId'].compareTo(b['ProductionId']));

    reportsGridDataList=filterProductionReportGridList;
    notifyListeners();
  }
  searchProduction(String v){
    if(v.isEmpty){
      reportsGridDataList=filterProductionReportGridList;
    }else{
      reportsGridDataList=filterProductionReportGridList.where((element) => element['Output Material'].toString().toLowerCase().contains(v)||
          element['Input Material'].toString().toLowerCase().contains(v) ||
          element['Machine Name'].toString().toLowerCase().contains(v)
      ).toList();
    }
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
        tempInvoiceTypeFilter=tempInvoiceTypeFilter+tempInvoicePlantFilter.where((ele) => ele['Invoice Type']==element['InvoiceType']).toList();
      }
    });

    partyNameList.forEach((element) {
      if(element['IsActive']==1){
        tempInvoicePartyNameFilter=tempInvoicePartyNameFilter+tempInvoiceTypeFilter.where((ele) => ele['Party Name']==element['PartyName']).toList();
      }
    });

    paymentStatusList.forEach((element) {
      if(element['IsActive']==1){
        filterInvoiceReportGridList=filterInvoiceReportGridList+tempInvoicePartyNameFilter.where((ele) => ele['Payment Status']==element['PaymentStatus']).toList();
     //   tempInvoicePaymentStatusFilter=tempInvoicePaymentStatusFilter+tempInvoicePartyNameFilter.where((ele) => ele['Payment Status']==element['PaymentStatus']).toList();
      }
    });


   /* paymentTypeList.forEach((element) {
      if(element['IsActive']==1){
        filterInvoiceReportGridList=filterInvoiceReportGridList+tempInvoicePaymentStatusFilter.where((ele) => ele['PaymentCategoryId']==element['PaymentCategoryId']).toList();
      }
    });*/




    counterList[0].value=filterInvoiceReportGridList.length;
    counterList[1].value=filterInvoiceReportGridList.where((element) => element['Invoice Type']=="Payable").toList().length;
    counterList[2].value=filterInvoiceReportGridList.where((element) => element['Invoice Type']=="Receivable").toList().length;

    filterInvoiceReportGridList.sort((a,b)=>a['InvoiceId'].compareTo(b['InvoiceId']));
    reportsGridDataList=filterInvoiceReportGridList;

    notifyListeners();
  }
  searchInvoice(String v){
    if(v.isEmpty){
      reportsGridDataList=filterInvoiceReportGridList;
    }else{
      reportsGridDataList=filterInvoiceReportGridList.where((element) => element['Invoice Number'].toString().toLowerCase().contains(v)||
          element['Party Name'].toString().toLowerCase().contains(v)
      ).toList();
    }
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
        filterReceivablePaymentReportReportGridList=filterReceivablePaymentReportReportGridList+tempReceivablePaymentReportPartyNameFilter.where((ele) => ele['Payment Status']==element['InvoiceType']).toList();
      }
    });


/*
    paymentTypeList.forEach((element) {
      if(element['IsActive']==1){
        filterReceivablePaymentReportReportGridList=filterReceivablePaymentReportReportGridList+tempReceivablePaymentReportPaymentStatusFilter.where((ele) => ele['PaymentCategoryId']==element['PaymentCategoryId']).toList();
      }
    });*/




    double grandTotal=0.0;
    double receivedAmount=0.0;
    double balanceAmount=0.0;

    filterReceivablePaymentReportReportGridList.forEach((element) {
      grandTotal=Calculation().add(grandTotal, element['Grand Total']);
      receivedAmount=Calculation().add(receivedAmount, element['Received Amount']);
      balanceAmount=Calculation().add(balanceAmount, element['Balance Amount']);
    });

    counterList[0].value="${filterReceivablePaymentReportReportGridList.length} / ${formatCurrency.format(grandTotal)}";
    counterList[1].value=formatCurrency.format(receivedAmount);
    counterList[2].value=formatCurrency.format(balanceAmount);
    filterReceivablePaymentReportReportGridList.sort((a,b)=>a['InvoiceId'].compareTo(b['InvoiceId']));

    reportsGridDataList=filterReceivablePaymentReportReportGridList;
    notifyListeners();
  }
  searchReceivablePaymentReport(String v){
    if(v.isEmpty){
      reportsGridDataList=filterReceivablePaymentReportReportGridList;
    }else{
      reportsGridDataList=filterReceivablePaymentReportReportGridList.where((element) => element['Invoice Number'].toString().toLowerCase().contains(v)||
          element['Payment Number'].toString().toLowerCase().contains(v) ||
          element['Customer Name'].toString().toLowerCase().contains(v)
      ).toList();
    }
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
        filterPayablePaymentReportGridList=filterPayablePaymentReportGridList+tempPayablePaymentReportPartyNameFilter.where((ele) => ele['Payment Status']==element['InvoiceType']).toList();
      }
    });



/*    paymentTypeList.forEach((element) {
      if(element['IsActive']==1){
        filterPayablePaymentReportGridList=filterPayablePaymentReportGridList+tempPayablePaymentReportPaymentStatusFilter.where((ele) => ele['PaymentCategoryId']==element['PaymentCategoryId']).toList();
      }
    });*/
    double grandTotal=0.0;
    double paidAmount=0.0;
    double balanceAmount=0.0;

    totalReport=filterPayablePaymentReportGridList.length;

    filterPayablePaymentReportGridList.forEach((element) {
      grandTotal=Calculation().add(grandTotal, element['Grand Total']);
      paidAmount=Calculation().add(paidAmount, element['Paid Amount']);
      balanceAmount=Calculation().add(balanceAmount, element['Balance Amount']);
    });



    counterList[0].value="${filterPayablePaymentReportGridList.length} / ${formatCurrency.format(grandTotal)}";
    counterList[1].value=formatCurrency.format(paidAmount);
    counterList[2].value=formatCurrency.format(balanceAmount);
    filterPayablePaymentReportGridList.sort((a,b)=>a['InvoiceId'].compareTo(b['InvoiceId']));


    reportsGridDataList=filterPayablePaymentReportGridList;
    notifyListeners();
  }
  searchPayablePaymentReport(String v){
    if(v.isEmpty){
      reportsGridDataList=filterPayablePaymentReportGridList;
    }else{
      reportsGridDataList=filterPayablePaymentReportGridList.where((element) => element['Invoice Number'].toString().toLowerCase().contains(v)||
          element['Payment Number'].toString().toLowerCase().contains(v) ||
          element['Supplier Name'].toString().toLowerCase().contains(v)
      ).toList();
    }
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
        tempDieselPurchaseReportLocationFilter=tempDieselPurchaseReportLocationFilter+tempDieselPurchaseReportPurchaserFilter.where((ele) => ele['Location'].toString().toLowerCase()==element['DieselBunkLocation'].toString().toLowerCase()).toList();
      }
    });


    dieselRateList.forEach((element) {
      if(element['IsActive']==1){
        filterDieselPurchaseReportGridList=filterDieselPurchaseReportGridList+tempDieselPurchaseReportLocationFilter.where((ele) => ele['Diesel Rate']==element['DieselRate']).toList();
      }
    });


   double qty=0.0;
   double amount=0.0;


    totalReport=filterDieselPurchaseReportGridList.length;

    filterDieselPurchaseReportGridList.forEach((element) {
      qty=Calculation().add(qty, element['Diesel Quantity']);
      amount=Calculation().add(amount, element['Amount']);

    });

    counterList[0].value=filterDieselPurchaseReportGridList.length;
    counterList[1].value="${formatCurrency.format(qty)} Ltr";
    counterList[2].value="${formatCurrency.format(amount)}";
    filterDieselPurchaseReportGridList.sort((a,b)=>b['Date'].compareTo(a['Date']));
    reportsGridDataList=filterDieselPurchaseReportGridList;
    notifyListeners();
  }
  searchDieselPurchaseReport(String v){
    if(v.isEmpty){
      reportsGridDataList=filterDieselPurchaseReportGridList;
    }else{
      reportsGridDataList=filterDieselPurchaseReportGridList.where((element) => element['BillNumber'].toString().toLowerCase().contains(v)||
          element['Purchaser Name'].toString().toLowerCase().contains(v) ||
          element['Location'].toString().toLowerCase().contains(v)
      ).toList();
    }
    notifyListeners();
  }



  /*  DieselIssueReport Report */



  List<dynamic> dieselIssueReportGridList=[];
  List<dynamic> filterDieselIssueReportGridList=[];

  List<dynamic> tempDieselIssueReportPlantFilter=[];
  List<dynamic> tempDieselIssueReportMachineTypeFilter=[];



  filterDieselIssueReport(BuildContext context) async{

    try{
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

     double issuedQty=0.0;
     double issuedMachine=0.0;
     double issuedVehicle=0.0;

      filterDieselIssueReportGridList.forEach((element) {
        issuedQty=Calculation().add(issuedQty, element['Diesel Quantity']);
        if(element['IsMachine']){
          issuedMachine=Calculation().add(issuedMachine, element['Diesel Quantity']);
        }else{
          issuedVehicle=Calculation().add(issuedVehicle, element['Diesel Quantity']);
        }

      });

      counterList[0].value=filterDieselIssueReportGridList.length;
      counterList[1].value="${formatCurrency.format(issuedQty)} Ltr";
      counterList[2].value="${formatCurrency.format(issuedMachine)} / ${formatCurrency.format(issuedVehicle)} Ltr";
      filterDieselIssueReportGridList.sort((a,b)=>b['Date'].compareTo(a['Date']));
      reportsGridDataList=filterDieselIssueReportGridList;
      notifyListeners();
    }catch(e,s){

      CustomAlert().commonErrorAlert(context, e.toString(), s.toString());
    }
  }
  searchDieselIssueReport(String v){
    if(v.isEmpty){
      reportsGridDataList=filterDieselIssueReportGridList;
    }else{
      reportsGridDataList=filterDieselIssueReportGridList.where((element) => element['Machine/Vehicle'].toString().toLowerCase().contains(v)||
          element['Issued By'].toString().toLowerCase().contains(v)
      ).toList();
    }
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

    counterList[0].value=machinesTotal.length;
    counterList[1].value=filterMachineManagementReportGridList.length;


    reportsGridDataList=filterMachineManagementReportGridList;
    notifyListeners();
  }
  searchMachineManagement(String v){
    if(v.isEmpty){
      reportsGridDataList=filterMachineManagementReportGridList;
    }else{
      reportsGridDataList=filterMachineManagementReportGridList.where((element) => element['Responsible'].toString().toLowerCase().contains(v)||
          element['Operator'].toString().toLowerCase().contains(v)||
          element['Machine Name'].toString().toLowerCase().contains(v)).toList();
    }
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


    double gst=0.0;
    double discount=0.0;
    double grandTotal=0.0;


    filterSaleAuditReportGridList.forEach((element) {
      grandTotal=Calculation().add(grandTotal, element['Grand Total']??0.0);
      discount=Calculation().add(discount, element['Discount Amount']??0.0);
      gst=Calculation().add(gst, element['GST']??0.0);


    });



    counterList[0].value=filterSaleAuditReportGridList.length;
    counterList[1].value=formatCurrency.format(gst);
    counterList[2].value=formatCurrency.format(discount);
    counterList[3].value=formatCurrency.format(grandTotal);


    filterSaleAuditReportGridList.sort((a,b)=>a['SaleId'].compareTo(b['SaleId']));
    reportsGridDataList=filterSaleAuditReportGridList;
    notifyListeners();
  }
  searchSaleAuditReport(String v){
    if(v.isEmpty){
      reportsGridDataList=filterSaleAuditReportGridList;
    }else{
      reportsGridDataList=filterSaleAuditReportGridList.where((element) => element['Sale Number'].toString().toLowerCase().contains(v)||
          element['Customer Name'].toString().toLowerCase().contains(v)).toList();
    }
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

    double gst=0.0;
    double discount=0.0;
    double grandTotal=0.0;

    filterPurchaseAuditReportGridList.forEach((element) {
      grandTotal=Calculation().add(grandTotal, element['Grand Total']??0.0);
      discount=Calculation().add(discount, element['Discount Amount']??0.0);
      gst=Calculation().add(gst, element['GST']??0.0);

    });

    filterPurchaseAuditReportGridList.sort((a,b)=>a['PurchaseOrderId'].compareTo(b['PurchaseOrderId']));

    counterList[0].value=filterPurchaseAuditReportGridList.length;
    counterList[1].value=formatCurrency.format(gst);
    counterList[2].value=formatCurrency.format(discount);
    counterList[3].value=formatCurrency.format(grandTotal);

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



  /*  Vehicle Monitoring Report */



  List<dynamic> vehicleMonitoringReportGridList=[];
  List<dynamic> filterVehicleMonitoringReportGridList=[];

  List<dynamic> tempVehicleMonitoringReportPlantFilter=[];
  List<dynamic> tempVehicleMonitoringReportVehicleTypeFilter=[];


  filterVehicleMonitoringReport() async{

    filterVehicleMonitoringReportGridList.clear();
    reportsGridDataList.clear();

    tempVehicleMonitoringReportPlantFilter.clear();
    tempVehicleMonitoringReportVehicleTypeFilter.clear();


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



    int purchaseCount=0;
    int saleCount=0;
    double purchaseAmount=0;
    double saleAmount=0;


    totalReport=filterVehicleMonitoringReportGridList.length;
    Map<int,dynamic> machinesTotal={};

    filterVehicleMonitoringReportGridList.forEach((element) {

      if(element['Type']=='Sale'){
        saleCount=saleCount+1;
        saleAmount=Calculation().add(saleAmount, element['Amount']);
      }else if(element['Type']=='Purchase'){
        purchaseCount=purchaseCount+1;
        purchaseAmount=Calculation().add(purchaseAmount, element['Amount']);
      }
    });

    counterList[0].value=filterVehicleMonitoringReportGridList.length;
    counterList[1].value="$purchaseCount / ${formatCurrency.format(purchaseAmount)}";
    counterList[2].value="$saleCount / ${formatCurrency.format(saleAmount)}";

    reportsGridDataList=filterVehicleMonitoringReportGridList;
    notifyListeners();
  }
  searchVehicleMonitoring(String v){
    if(v.isEmpty){
      reportsGridDataList=filterVehicleMonitoringReportGridList;
    }else{
      reportsGridDataList=filterVehicleMonitoringReportGridList.where((element) => element['Vehicle No'].toString().toLowerCase().contains(v)||
          element['Material'].toString().toLowerCase().contains(v)).toList();
    }
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

    double inputStock=0.0;
    double outputStock=0.0;


    filterStockReportGridList.forEach((element) {

      if(element['Type']=='InPut'){
        inputStock=Calculation().add(inputStock, element['Stock']??0.0);

      }
      else if(element['Type']=='OutPut'){
        outputStock=Calculation().add(outputStock, element['Stock']??0.0);
      }
    });


    counterList[0].value=filterStockReportGridList.length;
    counterList[1].value="${formatCurrency.format(inputStock)} Ton";
    counterList[2].value="${formatCurrency.format(outputStock)} Ton";



    reportsGridDataList=filterStockReportGridList;
    notifyListeners();
  }
  searchStockReport(String v){
    if(v.isEmpty){
      reportsGridDataList=filterStockReportGridList;
    }else{
      reportsGridDataList=filterStockReportGridList.where((element) => element['MaterialName'].toString().toLowerCase().contains(v)).toList();
    }
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


class ReportCounterModel{
  String title;
  dynamic value;
  ReportCounterModel({this.value,this.title});
}