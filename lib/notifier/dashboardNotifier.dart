import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/constants.dart';
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

            updateisChartLoad(true);
            Timer(Duration(milliseconds: 500), (){
              updateisChartLoad(false);
              updateisLoad(false);
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

  Future<dynamic> DashBoardDbHit(BuildContext context,String typeName,String fromDate,String toDate, {VoidCallback voidCallback}) async {
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
         // log("$value");
          if(typeName=='Sale'){
            saleT=parsed['Table'][0];
            saleData=parsed['Table1'] as List;
            saleT2=parsed['Table2'] as List;
            saleMaterialWeeklyT3=parsed['Table3'] as List;
            saleMaterialMonthlyT4=parsed['Table4'] as List;
            saleMaterialYearT5=parsed['Table5'] as List;
            salePaymentCategoryT6=parsed['Table6'] as List;
            salePaymentCustomerT7=parsed['Table7'] as List;
            getSaleDetail();
          }
          else if(typeName=='Purchase'){
            updateisLoad(false);
          }
          else if(typeName=='Production'){
            totalProductionQty=0.0;
            productionInputMaterialsT=parsed['Table'] as List;
            productionOutPutMaterialsT1=parsed['Table1'] as List;
            productionInputMaterialsT.forEach((element) {
              totalProductionQty=Calculation().add(totalProductionQty, element['InputMaterialQuantity']);
            });
            if(productionInputMaterialsT.isNotEmpty){
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
            todayAttendanceListT2=parsed['Table2'] as List;
            updateisLoad(false);
          }
          else if(typeName=='Counter'){
            counterList=parsed['Table'] as List;
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
            sl(voidCallback);
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
List<dynamic> salePaymentCategoryT6=[];
List<dynamic> salePaymentCustomerT7=[];
String salesApex='';
String salesMaterialHighChart='';
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
   updateisChartLoad(true);

   Timer(Duration(milliseconds: 500), (){
     updateisChartLoad(false);
     updateisLoad(false);
   });

 }

getSaleMaterialDetail(List<dynamic> data,String date,BuildContext context){
 // print(data);
 // print(date);
   try{
    salesMaterialHighChart='''

      {
    chart:{
      height:250,
    },
    title: {
        text: ''
    },
    xAxis: {
        categories: $date,
        gridLineWidth: 0,
    },
      yAxis: {
        gridLineWidth: 0,
            gridLineColor: 'transparent',
            gridTextColor: '#ffffff',
            lineColor: 'transparent',
            tickColor: 'transparent',
            showEmpty: false,
            title:{
                text:'',
            }
    },
   
    labels: {
        items: [{
            html: '',
            style: {
                left: '50px',
                top: '18px',
                color: ( // theme
                    Highcharts.defaultOptions.title.style &&
                    Highcharts.defaultOptions.title.style.color
                ) || 'black'
            }
        }]
    },
    
    legend: {
            enabled: false
        },
       
        plotOptions: {
          
            column: {
                borderRadiusTopLeft: 10,
            	borderRadiusTopRight: 10,
                grouping: false,
            },
        
        },
         tooltip: {
        pointFormat: '<span style="color:#F8C85A">\u25CF</span> {series.name}: <b>{point.y}</b><br/>',
        useHTML: true,
        backgroundColor: '#000000',
        style:{color:'#ffffff'},
        borderWidth: 0,
        shadow: false,
    },
    series: [{
        type: 'column',
        name: 'Sales',
        data: $data,
        color: {
                    linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                    stops: [
                        [0, '#FAFAFA'],
                        [1, '#D7D7D7']
                    ]
                }
      } ,
     {
        type: 'spline',
        name: 'Sales',
        data: $data,
         color: '#F8C85A',
        marker: {
            lineWidth: 2,
            lineColor: Highcharts.getOptions().colors[3],
            fillColor: 'white'
        }
    },  ]
}

     
  ''';
    updateisSaleMaterialChartLoad(true);
    Timer(Duration(milliseconds: 500), (){
      updateisSaleMaterialChartLoad(false);
    });
  }
  catch(e,t){

    /* updateisSaleMaterialChartLoad(true);
     Timer(Duration(milliseconds: 500), (){
       updateisSaleMaterialChartLoad(false);
     });
    CustomAlert().commonErrorAlert2(context, e, t.toString());*/
  }


}




//Production DashBoard
List<dynamic> productionInputMaterialsT=[];
List<dynamic> productionOutPutMaterialsT1=[];
List<dynamic> filterProductionOutPutMaterialsT=[];
double totalProductionQty=0.0;

  List<dynamic> outputMaterials=[];
  getProduction(int i){
    outputMaterials=productionOutPutMaterialsT1.where((element) => element['InputMaterialId']==productionInputMaterialsT[i]['InputMaterialId']).toList();
    notifyListeners();
  }


  //Counter DashBoard
  List<dynamic> counterList=[];

//Diesel DashBoard
Map issueDiesel={};
Map balanceDiesel={};
Map totalDiesel={};

  List<charts.Series> seriesList=[];
  double low,high;
  sl(VoidCallback voidCallback){
     low= ((totalDiesel['TotalQuantity']??0.0)/5000.0);
     high=1-low;
    if(high<0){
      double temp=low;
      low=-1*high;
      high=temp;
    }
 /*   print((totalDiesel['TotalQuantity']??0.0)/5000.0);
    print(low);
    print(high);*/
    seriesList= [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        colorFn: (GaugeSegment sales, _) => charts.Color.fromHex(code: sales.hex),
        data:  [
          //F3C253
          new GaugeSegment('Low', low,'#F1AC3D'),
          new GaugeSegment('high', high,'#CACACA'),

        ],
      )
    ];
    voidCallback();
  }

//Attendance DashBoard
  int totalEmployee=1;
  int  totalPresent,totalAbsent=0;
  List<dynamic> todayAttendanceListT2=[];


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


class GaugeSegment {
  final String segment;
  final double size;
  String hex;

  GaugeSegment(this.segment, this.size,this.hex);
}
class LinearSales {
  final int year;
  final int sales;
  String hex;

  LinearSales(this.year, this.sales,this.hex);
}