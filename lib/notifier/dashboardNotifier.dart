import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/dashboard/dieselDashBoard/dieselDashBoard.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';

class DashboardNotifier extends ChangeNotifier{
  final call=ApiManager();
  String TypeName="";
  DateTime dateTime=DateTime.parse('2021-01-01');
  List<DateTime> picked=[];

  List<MenuModel> menu=[
  MenuModel(title:"Sale",image: "assets/svg/drawer/sales-form.svg"),
  MenuModel(title:"Purchase & Received",image: "assets/svg/drawer/purchase.svg"),
  MenuModel(title:"Production",image: "assets/svg/drawer/production.svg"),
  MenuModel(title:"Attendance",image: "assets/svg/drawer/employee/employeeAttendance.svg"),
  MenuModel(title:"Counters",image: "assets/svg/drawer/settings/customer.svg"),
  MenuModel(title:"Customer & Supplier",image: "assets/svg/drawer/settings/supplier.svg"),
  MenuModel(title:"Diesel Management",image: "assets/svg/drawer/diesel-mangement.svg"),
  MenuModel(title:"Invoice",image: "assets/svg/drawer/invoice.svg"),
  MenuModel(title:"Stock",image: "assets/svg/drawer/sales-form.svg")
  ];

  //Current Sales Dashboard
  Map? currentSaleT={};
  List<dynamic> currentSaleData=[];
  String currentSalesApex='';
  Future<dynamic> currentSaleDbHit(BuildContext context,String typeName,String fromDate,String toDate) async {
    updateisLoad(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getDashboard}"
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
        if(value!='F'){
          var parsed=json.decode(value);
          if(typeName=='Sale'){
            currentSaleT=parsed['Table'][0];
            currentSaleData=parsed['Table1'] as List;
            updateisLoad(false);
          }

        }
        else{
          updateisLoad(false);
        }
      });
    }
    catch(e,t){
      updateisLoad(false);
      CustomAlert().commonErrorAlert(context, "DashBoard Hit $typeName" , t.toString());
    }
  }


  Future<dynamic> DashBoardDbHit(BuildContext context,String typeName,String fromDate,String toDate, {VoidCallback? voidCallback}) async {
  updateisLoad(true);
 // saleData.clear();
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getDashboard}"
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

        if(value!='F'){
          var parsed=json.decode(value);
        //  log("$value");
          if(typeName=='Sale'){
            saleT=parsed['Table'][0];
            saleData=parsed['Table1'] as List;
            saleT2=parsed['Table2'] as List?;
            saleMaterialWeeklyT3=parsed['Table3'] as List?;
            saleMaterialMonthlyT4=parsed['Table4'] as List?;
            saleMaterialYearT5=parsed['Table5'] as List?;
            salePaymentCategoryT6=parsed['Table6'] as List?;
            salePaymentCustomerT7=parsed['Table7'] as List?;
            updateisLoad(false);
          }
          else if(typeName=='Purchase'){
            updateisLoad(false);
          }
          else if(typeName=='Production'){
            totalProductionQty=0.0;
            productionInputMaterialsT=parsed['Table'] as List?;
            productionOutPutMaterialsT1=parsed['Table1'] as List?;
            productionInputMaterialsT!.forEach((element) {
              totalProductionQty=Calculation().add(totalProductionQty, element['InputMaterialQuantity']);
            });
            if(productionInputMaterialsT!.isNotEmpty){
              getProduction(0);
              updateisLoad(false);
            }
            else{
              updateisLoad(false);
            }
          }
          else if(typeName=='Attendance'){
            totalAbsent=0;
            totalPresent=0;
            totalEmployee=1;
            totalEmployee=parsed['Table'][0]['TotalEmployee'];
            if(totalEmployee<=0){
              totalEmployee=1;
            }
            var t1=parsed['Table1'] as List;
            t1.forEach((element) {
              if(element['Status']==0){
                    totalAbsent=element['TotalCount'];
                }
              else if(element['Status']==1){
                totalPresent=element['TotalCount'];
              }
              });
            todayAttendanceListT2=parsed['Table2'] as List?;
            updateisLoad(false);
          }
          else if(typeName=='Counter'){
            counterList=parsed['Table'] as List?;
            updateisLoad(false);
          }
          else if(typeName=='Diesel'){
            var t3=parsed['Table3'] as List;
            var t4=parsed['Table4'] as List;
            var t5=parsed['Table5'] as List;
            if(t3.isNotEmpty){
              totalDiesel=t3[0];
            }else{
              totalDiesel={};
            }
            if(t4.isNotEmpty){
              issueDiesel=t4[0];
            }else{
              issueDiesel={};
            }
            if(t5.isNotEmpty){
              balanceDiesel=t5[0];
            }else{
              balanceDiesel={};
            }

           // updateSeriesList();
            updateisLoad(false);
            int d1 = DateTime.parse(fromDate).month;
            int d2 = DateTime.parse(toDate).month;
            int diff =  (d2-d1)+1;
            sl(voidCallback!,diff);
          }
          else{
            updateisLoad(false);
          }

        }
        else{
          updateisLoad(false);
        }
      });
    }
    catch(e,t){
      updateisLoad(false);
      CustomAlert().commonErrorAlert(context, "DashBoard Hit $typeName" , t.toString());
    }
  }


//Sales Dashboard
Map? saleT={};
List<dynamic> saleData=[];
List<dynamic>? saleT2=[];
List<dynamic>? saleMaterialWeeklyT3=[];
List<dynamic>? saleMaterialMonthlyT4=[];
List<dynamic>? saleMaterialYearT5=[];
List<dynamic>? salePaymentCategoryT6=[];
List<dynamic>? salePaymentCustomerT7=[];




//Production DashBoard
List<dynamic>? productionInputMaterialsT=[];
List<dynamic>? productionOutPutMaterialsT1=[];
List<dynamic> filterProductionOutPutMaterialsT=[];
double totalProductionQty=0.0;

  List<dynamic> outputMaterials=[];
  getProduction(int i){
    outputMaterials=productionOutPutMaterialsT1!.where((element) => element['InputMaterialId']==productionInputMaterialsT![i]['InputMaterialId']).toList();
    notifyListeners();
  }


  //Counter DashBoard
  List<dynamic>? counterList=[];

//Diesel DashBoard
Map issueDiesel={};
Map balanceDiesel={};
Map totalDiesel={};


  List<ChartData> chartData=[];
  double low=0,high=0;
  int spike=0;
  sl(VoidCallback voidCallback,int month){
     low= ((totalDiesel['TotalQuantity']??0.0)/(month*5000.0));
     high=1-low;
    if(high<0){
      double? temp=low;
      low=-1*high;
      high=temp;
    }
   // print((totalDiesel['TotalQuantity']??0.0)/5000.0);
 /*   print(low);
    print(high);
    print((low+high)/7);
    print((low/((low+high)/7)).round());*/
    spike=(low/((low+high)/7)).round();
     chartData = [
       ChartData('Low', low,Color(0xFFF1AC3D)),
       ChartData('high', high,Color(0xFFDFE8E8)),
     ];
    voidCallback();
  }

//Attendance DashBoard
  int totalEmployee=1;
  int  totalPresent=0,totalAbsent=0;
  List<dynamic>? todayAttendanceListT2=[];


 bool isLoad=false;
 updateisLoad(bool value){
   isLoad=value;
   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
     notifyListeners();
   });

 }
 bool isChartLoad=false;
 updateisChartLoad(bool value){
   isChartLoad=value;
   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
     notifyListeners();
   });
 }

 bool isSaleMaterialChartLoad=false;
 updateisSaleMaterialChartLoad(bool value){
   isSaleMaterialChartLoad=value;
   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
     notifyListeners();
   });
 }



}

class MenuModel{
  String? title;
  String image;
  MenuModel({this.image="assets/svg/Planticon.svg",this.title});

}


class GaugeSegment {
  final String segment;
  final double? size;
  String hex;

  GaugeSegment(this.segment, this.size,this.hex);
}
class LinearSales {
  final int year;
  final int sales;
  String hex;

  LinearSales(this.year, this.sales,this.hex);
}