import 'dart:convert';

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



  Future<dynamic> DashBoardDbHit(BuildContext context,String typeName) async {

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
          print(parsed);

        }

      });
    }
    catch(e){

      CustomAlert().commonErrorAlert(context, "${Sp.getDashboard} $typeName" , e.toString());
    }
  }
}

class MenuModel{
  String title;
  String image;
  MenuModel({this.image="assets/svg/Planticon.svg",this.title});

}