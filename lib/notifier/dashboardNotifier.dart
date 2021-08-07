import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/widgets/alertDialog.dart';

class DashboardNotifier extends ChangeNotifier{
  final call=ApiManager();
  String TypeName="";
  DateTime dateTime=DateTime.parse('2021-01-01');
  List<DateTime> picked=[];

  List<MenuModel> menu=[
  MenuModel(title:"Sale",image: "assets/svg/drawer/sales-form.svg"),
  MenuModel(title:"Purchase",image: "assets/svg/drawer/purchase.svg"),
  MenuModel(title:"Production",image: "assets/svg/drawer/production.svg"),
  MenuModel(title:"Attendance",image: "assets/svg/drawer/employee/employeeAttendance.svg"),
  MenuModel(title:"Counters",image: "assets/svg/drawer/settings/customer.svg"),
  MenuModel(title:"Customer & Supplier",image: "assets/svg/drawer/settings/supplier.svg"),
  MenuModel(title:"Diesel Management",image: "assets/svg/drawer/diesel-mangement.svg"),
  MenuModel(title:"Invoice",image: "assets/svg/drawer/invoice.svg"),
  MenuModel(title:"Stock",image: "assets/svg/drawer/sales-form.svg")
  ];

  //Current Sales Dashboard
  Map currentSaleT={};
  List<dynamic> currentSaleData;
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
        if(value!=null){
          var parsed=json.decode(value);
          if(typeName=='Sale'){
            currentSaleT=parsed['Table'][0];
            currentSaleData=parsed['Table1'] as List;
            currentSalesApex='''
       var options = {
        series: [{
            name: 'Sales',
            data: ${currentSaleData.map((e) => e['TotalSale']).toList()}
        }],
         title: {
              text: 'Sale',
              align: 'left',
              margin: 10,
              offsetY: 0,
              floating: false,
              style: {
                fontSize:  '18px',
                fontWeight:  '500',
                color:  '#FFC010'
              },
          },
          subtitle: {
              text: '${DateFormat("MMMd").format(DateTime.parse(currentSaleData[currentSaleData.length-1]['Date']))} : ${formatCurrency.format(currentSaleData[currentSaleData.length-1]['TotalSale']??0.0)} / ${currentSaleData[currentSaleData.length-1]['TotalQuantity']} ${currentSaleData[currentSaleData.length-1]['UnitName']}',
              align: 'left',
              offsetY: 25,
              floating: false,
              style: {
                fontSize:  '12px',
                color:  '#ffffff'
              },
          },
        chart: {
           
            background: '#343434',
            type: 'area',
            foreColor: '#9a9797',
            height: 250,
            width:'100%',
            toolbar: {
                show: false
            },
           
            zoom: {
                enabled: false
            },
            
            dropShadow: {
                enabled: false,
                top: 3,
                left: 14,
                blur: 4,
                opacity: 0.12,
                color: '#FEBF10',
            },
            sparkline: {
                enabled: false
            }
        },
        markers: {
            size: 0,
            colors: ["#FEBF10"],
            strokeColors: "#FEBF10",
            strokeWidth: 2,
            hover: {
                size: 7,
            }
        },
        plotOptions: {
            bar: {
                horizontal: false,
                columnWidth: '45%',
                endingShape: 'rounded'
            },
        },

        dataLabels: {
            enabled: false
        },
        stroke: {
            show: true,
            width: 3,
            curve: 'smooth'
        },
        fill: {
            type: 'gradient',
            gradient: {
                shade: 'light',
                type: 'vertical',
                shadeIntensity: 0.5,
                gradientToColors: ['#343434'],
                inverseColors: false,
                opacityFrom: 0.8,
                opacityTo: 0.5,
                stops: [0, 100]
            }
        },
        colors: ["#FEBF10"],
        grid: {
            show: false,
            borderColor: '#ededed',
            //strokeDashArray: 4,
         
        },
        yaxis: {
            labels: {
                formatter: function(value) {
                    return value;
                }
            },
        },
         xaxis: {
          categories: ${json.encode(currentSaleData.map((e) => DateFormat("MMMd").format(DateTime.parse(e['Date']))).toList())}
        },
       

        tooltip: {
            theme: 'dark',
            y: {
                formatter: function(val) {
                    return val
                }
            },
        
        }
    };
    var chart = new ApexCharts(document.querySelector("#chart"), options);
    chart.render();
  ''';
            updateisLoad(false);
            updateisChartLoad(true);
            Timer(Duration(milliseconds: 500), (){
              updateisChartLoad(false);
            });
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

  Future<dynamic> DashBoardDbHit(BuildContext context,String typeName,String fromDate,String toDate) async {
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
        if(value!=null){
          var parsed=json.decode(value);
          log("$value");
          if(typeName=='Sale'){
            saleT=parsed['Table'][0];
            saleData=parsed['Table1'] as List;
            saleT2=parsed['Table2'] as List;
            saleMaterialWeeklyT3=parsed['Table3'] as List;
            saleMaterialMonthlyT4=parsed['Table4'] as List;
            saleMaterialYearT5=parsed['Table5'] as List;
            getSaleDetail();
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
Map saleT={};
List<dynamic> saleData=[];
List<dynamic> saleT2=[];
List<dynamic> saleMaterialWeeklyT3=[];
List<dynamic> saleMaterialMonthlyT4=[];
List<dynamic> saleMaterialYearT5=[];
String salesApex='';
String salesMaterialApex='';
getSaleDetail(){
   salesApex='''
       var options = {
        series: [{
            name: 'Sales',
            data: ${saleData.map((e) => e['TotalSale']).toList()}
        }],
         title: {
              text: 'Sale',
              align: 'left',
              margin: 10,
              offsetY: 0,
              floating: false,
              style: {
                fontSize:  '18px',
                fontWeight:  '500',
                color:  '#FFC010'
              },
          },
          subtitle: {
              text: 'Total : ${formatCurrency.format(saleT['TotalSale']??0.0)} / ${saleT['TotalQuantity']} ${saleT['UnitName']}',
              align: 'left',
              offsetY: 25,
              floating: false,
              style: {
                fontSize:  '12px',
                color:  '#ffffff'
              },
          },
        chart: {
           
            background: '#343434',
            type: 'area',
            foreColor: '#9a9797',
            height: 250,
            width:'100%',
            toolbar: {
                show: false
            },
           
            zoom: {
                enabled: false
            },
            
            dropShadow: {
                enabled: false,
                top: 3,
                left: 14,
                blur: 4,
                opacity: 0.12,
                color: '#FEBF10',
            },
            sparkline: {
                enabled: false
            }
        },
        markers: {
            size: 0,
            colors: ["#FEBF10"],
            strokeColors: "#FEBF10",
            strokeWidth: 2,
            hover: {
                size: 7,
            }
        },
        plotOptions: {
            bar: {
                horizontal: false,
                columnWidth: '45%',
                endingShape: 'rounded'
            },
        },

        dataLabels: {
            enabled: false
        },
        stroke: {
            show: true,
            width: 3,
            curve: 'smooth'
        },
        fill: {
            type: 'gradient',
            gradient: {
                shade: 'light',
                type: 'vertical',
                shadeIntensity: 0.5,
                gradientToColors: ['#343434'],
                inverseColors: false,
                opacityFrom: 0.8,
                opacityTo: 0.5,
                stops: [0, 100]
            }
        },
        colors: ["#FEBF10"],
        grid: {
            show: false,
            borderColor: '#ededed',
            //strokeDashArray: 4,
         
        },
        yaxis: {
            labels: {
                formatter: function(value) {
                    return value;
                }
            },
        },
         xaxis: {
          categories: ${json.encode(saleData.map((e) => DateFormat("MMMd").format(DateTime.parse(e['Date']))).toList())}
        },
       

        tooltip: {
            theme: 'dark',
            y: {
                formatter: function(val) {
                    return val
                }
            },
        }
    };
    var chart = new ApexCharts(document.querySelector("#chart"), options);
    chart.render();
  ''';
   updateisLoad(false);
   updateisChartLoad(true);
   Timer(Duration(milliseconds: 500), (){
     updateisChartLoad(false);
   });

 }

getSaleMaterialDetail(List<dynamic> data,String date,){
  print(data);
  print(date);
  salesMaterialApex='''
  var options = {
          series: [{
          name: 'Sale',
          type: 'column',
          data: $data
        }, {
          name: 'Sale',
          type: 'line',
          data:  $data
        }],
        legend: {
            show: false
           },
        chart: {
            background: '#ffffff',
            type: 'area',
            foreColor: '#9a9797',
            height: 250,
            toolbar: {
                show: false,
            },
            
          zoom: {
              enabled: false
          },
          dropShadow: {
              enabled: false,
              top: 3,
              left: 14,
              blur: 4,
              opacity: 0.12,
              color: '#FEBF10',
            },
          sparkline: {
              enabled: false
           }
         },
        stroke: {
          width: [0, 4],
          curve:'smooth'
        },
        title: {
          text: ''
        },
        dataLabels: {
          enabled: false,
          enabledOnSeries: [1]
        },
        plotOptions: {
            bar: {
                horizontal: false,
                columnWidth: '45%',
                endingShape: 'rounded'
            },
        },
        fill: {
        type: 'gradient',
        gradient: {
            shade: 'light',
            type: 'vertical',
            shadeIntensity: 0.5,
            gradientToColors: ['#CACACA'],
            inverseColors: false,
            opacityFrom: 0.5,
            opacityTo: 0.7,
            stops: [0, 50],
            colorStops: []
          }
        },
       colors: ["#FEBF10"],
       grid: {
            show: false,
            borderColor: '#ededed',
            //strokeDashArray: 4,
        },
        labels: $date,
        xaxis: {
         
        },
        yaxis: [],
        tooltip: {
            theme: 'dark',
            y: {
                formatter: function(val) {
                    return val
                }
            },
        }
        };
    

        var chart = new ApexCharts(document.querySelector("#chart"), options);
        chart.render();
     
  ''';
  notifyListeners();
  updateisSaleMaterialChartLoad(true);
  Timer(Duration(milliseconds: 500), (){
    updateisSaleMaterialChartLoad(false);
  });
}


 bool isLoad=false;
 updateisLoad(bool value){
   isLoad=value;
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     notifyListeners();
   });

 }
 bool isChartLoad=false;
 updateisChartLoad(bool value){
   isChartLoad=value;
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     notifyListeners();
   });
 }

 bool isSaleMaterialChartLoad=false;
 updateisSaleMaterialChartLoad(bool value){
   isSaleMaterialChartLoad=value;
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     notifyListeners();
   });
 }


}

class MenuModel{
  String title;
  String image;
  MenuModel({this.image="assets/svg/Planticon.svg",this.title});

}