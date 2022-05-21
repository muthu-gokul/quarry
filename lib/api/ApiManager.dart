import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:quarry/model/parameterMode.dart';
import 'package:quarry/widgets/alertDialog.dart';

//BuildContext context
class ApiManager{

 //  String baseUrl="http://192.168.1.102/QMS_Dev/";
 //  String attachmentUrl="http://192.168.1.102/QMS_Dev/AppAttachments/";
 // String invokeUrl="http://192.168.1.102/QMS_Dev/api/Mobile/GetInvoke";
 // String loginUrl="http://192.168.1.102/QMS_Dev/api/Mobile/GetInvokeforlogin";

  String baseUrl="http://45.126.252.78/QMS_UAT/";
  String attachmentUrl="http://45.126.252.78/QMS_UAT/AppAttachments/";
  String invokeUrl="http://45.126.252.78/QMS_UAT/api/Mobile/GetInvoke";
  String loginUrl="http://45.126.252.78/QMS_UAT/api/Mobile/GetInvokeforlogin";
  String deactivateUrl="http://45.126.252.78/QMS_UAT/api/LoginApi/DeactivatePlant";

  Future<String> ApiCallGetInvoke(var body,BuildContext context) async {

    try{
      final response = await http.post(Uri.parse(invokeUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(body)
      ).timeout(Duration(seconds: 15),onTimeout: (){
        return http.Response('{"Message":"Connection Issue. Check Your Internet Connection"}',500);
      }).onError((error, stackTrace){
        return http.Response('{"Message":"$error"}',500);
      });
      if(response.statusCode==200){
        return response.body;
      }
      else{
        var msg;
        msg=json.decode(response.body);
        print("MSG $msg");
         CustomAlert().commonErrorAlert2(Get.context!, "${msg["Message"]}", "");
         return "null";
        // return response.statusCode.toString();
      }
    }
    catch(e,t){
      print(t);
      return "null";
      print("NETWORK ISSUE--$e");
      // CustomAlert().commonErrorAlert(context, "Network Issue", "Your Internet Connectivity or Server is Slow..");
    }
  }

  Future<String> ApiCallGetInvokeFoLogin(var body) async {
    try{
      final response = await http.post(Uri.parse(loginUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(body)
      ).timeout(Duration(seconds: 15),onTimeout: (){
        return http.Response('{"Message":"Connection Issue. Check Your Internet Connection"}',500);
      }).onError((error, stackTrace){
        return http.Response('{"Message":"$error"}',500);
      });
      if(response.statusCode==200){
        return response.body;
      }
      else{
        var msg;
        msg=json.decode(response.body);
        print("MSG $msg");
         CustomAlert().commonErrorAlert2(Get.context!, "${msg["Message"]}", "");
         return "null";
        // return response.statusCode.toString();
      }
    }
    catch(e,t){
      print(t);
      return "null";
      print("NETWORK ISSUE--$e");
      // CustomAlert().commonErrorAlert(context, "Network Issue", "Your Internet Connectivity or Server is Slow..");
    }
  }

  Future<String> DeactivatePlant(List<ParameterModel> parameterList) async {
    try{
      var body = {
        "Fields": parameterList.map((e) => e.toJson()).toList()
      };
      final response = await http.post(Uri.parse(deactivateUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(body)
      ).timeout(Duration(seconds: 15),onTimeout: (){
        return http.Response('{"Message":"Connection Issue. Check Your Internet Connection"}',500);
      }).onError((error, stackTrace){
        return http.Response('{"Message":"$error"}',500);
      });
      if(response.statusCode==200){
        return response.body;
      }
      else{
        var msg;
        msg=json.decode(response.body);
        CustomAlert().commonErrorAlert2(Get.context!, "${msg["Message"]}", "");
        return "null";
        // return response.statusCode.toString();
      }
    }
    catch(e,t){
      print(t);
      return "null";
      print("NETWORK ISSUE--$e");
      // CustomAlert().commonErrorAlert(context, "Network Issue", "Your Internet Connectivity or Server is Slow..");
    }
  }
}
