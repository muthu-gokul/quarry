import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/dropDownValues.dart';
import 'package:quarry/model/plantModel/plantUserModel.dart';
import 'package:quarry/model/reportsModel/materialModel.dart';
import 'package:quarry/model/reportsModel/salesReportModel/salesOverAllHeaderModel.dart';
import 'package:quarry/model/reportsModel/salesReportModel/salesReportGridModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';
import 'package:quarry/widgets/decimal.dart';

class ReportsNotifier extends ChangeNotifier{
  final call=ApiManager();

  String TypeName="";
  /*Report Settings*/
  String settingsHeader="";

  DateTime dateTime=DateTime.parse('2021-01-01');
  List<DateTime> picked=[];



  List<PlantUserModel> plantList=[];
  List<MaterialModel> materialList=[];
  List<CustomerModel> customerList=[];

  Future<dynamic> ReportsDropDownValues(BuildContext context,String typeName) async {
    TypeName=typeName;
    dateTime=DateTime.parse('1999-01-01');
    updateReportLoader(true);
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
            settingsHeader="Sales Report";
             var t=parsed["Table"] as List;
             var t1=parsed["Table1"] as List;
             var t2=parsed["Table2"] as List;
             plantList=t.map((e) => PlantUserModel.fromJson(e)).toList();
             materialList=t1.map((e) => MaterialModel.fromJson(e)).toList();
             customerList=t2.map((e) => CustomerModel.fromJson(e)).toList();
          }
          else if(typeName=="PurchaseReport"){
            settingsHeader="Purchase Report";
             var t=parsed["Table"] as List;
             var t1=parsed["Table1"] as List;
             var t2=parsed["Table2"] as List;
             plantList=t.map((e) => PlantUserModel.fromJson(e)).toList();
             materialList=t1.map((e) => MaterialModel.fromJson(e)).toList();
             customerList=t2.map((e) => CustomerModel.fromJson(e)).toList();
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


 /* SALES REPORT  */
  List<ColumnFilterModel> salesReportGridCol=[ColumnFilterModel(columnName: "Sale Number"),
    ColumnFilterModel(columnName: "Date"),ColumnFilterModel(columnName: "MaterialName"),ColumnFilterModel(columnName:"Quantity"),
    ColumnFilterModel(columnName: "Amount"),ColumnFilterModel(columnName: "Customer Name"),ColumnFilterModel(columnName: "Plant Name"),];

  List<ColumnFilterModel> tempSalesCol=[ColumnFilterModel(columnName: "Sale Number"),
    ColumnFilterModel(columnName: "Date"),ColumnFilterModel(columnName: "MaterialName"),ColumnFilterModel(columnName:"Quantity"),
    ColumnFilterModel(columnName: "Amount"),ColumnFilterModel(columnName: "Customer Name"),ColumnFilterModel(columnName: "Plant Name"),];

  List<SaleReportTotalValuesModel> salesOverAllHeaderList=[];
  List<SaleReportGridModel> salesReportGridList=[];
  List<SaleReportGridModel> filterSalesReportGridList=[];

  int totalSale=0;
  double totalSaleQty=0.0;
  double totalSaleAmount=0.0;

  Future<dynamic> ReportsDbHit(BuildContext context,String typeName) async {
    String fromDate,toDate;

    if(picked.isEmpty){
      fromDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      toDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
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
             var t1=parsed["Table1"] as List;

             salesOverAllHeaderList=t.map((e) => SaleReportTotalValuesModel.fromJson(e)).toList();
             salesReportGridList=t1.map((e) => SaleReportGridModel.fromJson(e)).toList();
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

  List<SaleReportGridModel> tempSalesMaterialFilter=[];
  List<SaleReportGridModel> tempSalesPlantFilter=[];
  List<SaleReportGridModel> tempSalesCustomerFilter=[];
  filterSales() async{

    filterSalesReportGridList.clear();
    tempSalesMaterialFilter.clear();
    tempSalesPlantFilter.clear();
    tempSalesCustomerFilter.clear();

    totalSale=0;
    totalSaleAmount=0.0;
    totalSaleQty=0.0;

    plantList.forEach((element) {
      if(element.isActive){
        tempSalesPlantFilter=tempSalesPlantFilter+salesReportGridList.where((ele) => ele.plantId==element.plantId).toList();
      }
    });


     materialList.forEach((element) {
       if(element.isActive){
         tempSalesMaterialFilter=tempSalesMaterialFilter+tempSalesPlantFilter.where((ele) => ele.materialId==element.materialId).toList();
        // filterSalesReportGridList=filterSalesReportGridList+salesReportGridList.where((ele) => ele.materialId==element.materialId).toList();
       }
     });


     customerList.forEach((element) {
       if(element.isActive){
         filterSalesReportGridList=filterSalesReportGridList+tempSalesMaterialFilter.where((ele) => ele.customerId==element.customerId).toList();
       }
     });


     totalSale=filterSalesReportGridList.length;
     filterSalesReportGridList.forEach((element) {
       totalSaleAmount=Calculation().add(totalSaleAmount, element.outputQtyAmount);
       totalSaleQty=Calculation().add(totalSaleQty, element.outputMaterialQty);
     });

     notifyListeners();

  }

 

  bool ReportLoader=false;
  updateReportLoader(bool value){
    ReportLoader=value;
    notifyListeners();
  }

}


class ColumnFilterModel{
  String columnName;
  bool isActive;
  ColumnFilterModel({this.columnName, this.isActive=true});

  Map<String, dynamic> toJson() => {
    "ColumnName": columnName,

  };

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }

}