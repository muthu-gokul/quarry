import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';

class DashboardNotifier extends ChangeNotifier{
  final call=ApiManager();
  String TypeName="";
  DateTime dateTime=DateTime.parse('2021-01-01');
  List<DateTime> picked=[];

  List<MenuModel> menu=[MenuModel(title:"Sale"),
  MenuModel(title:"Purchase"),
  MenuModel(title:"Production"),
    MenuModel(title:"Attendance"),
  MenuModel(title:"Counters"),
  MenuModel(title:"Customer & Supplier"),
  MenuModel(title:"Diesel Management"),
  MenuModel(title:"Invoice"),
  MenuModel(title:"Stock")
  ];



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
       //   log("$value");
          saleData=parsed['Table1'] as List;
          getSaleDetail();
          print(saleData);
          print(saleData.map((e) => e['TotalSale'].toString()));
          print(saleData.map((e) => e['Date'].toString()).toList());
          print(json.encode(saleData.map((e) => e['Date']).toList()));
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
List<dynamic> saleData;
String salesApex='';
getSaleDetail(){
   salesApex='''
       var options = {
        series: [{
            name: 'Sales',
            data: ${saleData.map((e) => e['TotalSale']).toList()}
        }],
         title: {
              text: 'Sales',
              align: 'left',
              margin: 10,
              offsetX: 25,
              offsetY: 0,
              floating: false,
              style: {
                fontSize:  '14px',
                fontWeight:  'bold',
                color:  '#ffffff'
              },
          },
          subtitle: {
              text: 'fggdgdgd',
              align: 'left',
              offsetX: 25,
              offsetY: 25,
              floating: false,
              style: {
                fontSize:  '14px',
                color:  '#ffffff'
              },
          },
        chart: {
           
            background: 'transparent',
            type: 'area',
            foreColor: '#9a9797',
            height: 230,
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
/*  xaxis: {
  categories: ${saleData.map((e) => e['TotalSale']).toList()},
  },*/

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


}

class MenuModel{
  String title;
  String image;
  MenuModel({this.image="assets/svg/Planticon.svg",this.title});

}