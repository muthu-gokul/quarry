import 'dart:convert';

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
  double totalReportQty=0.0;

  String totalReportAmountTitle="";
  double totalReportAmount=0.0;

  List<ReportGridStyleModel2> reportsGridColumnList=[];
  List<dynamic> reportsGridDataList=[];

  List<dynamic> plantList=[];
  List<dynamic> materialList=[];
  List<dynamic> customerList=[];

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