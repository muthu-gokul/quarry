import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
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

  Future<String> ApiCallGetInvoke(var body,BuildContext context) async {

    try{
      final response = await http.post(Uri.parse(invokeUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(body)
      ).timeout(Duration(seconds: 15),);
      if(response.statusCode==200){
        return response.body;
      }
      // else if(response.statusCode==500){
      //    // return response.body;
      //   print(response.body);
      // }
      else{
        print("ll");
        var msg;
        // print(msg);
         print(response.body);
        msg=json.decode(response.body);
        print("MSG $msg");

         CustomAlert().commonErrorAlert2(context, "${msg["Message"]}", "");
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
