import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:quarry/widgets/alertDialog.dart';

//BuildContext context
class ApiManager{

  Future<String> ApiCallGetInvoke(var body,BuildContext context) async {
    try{
      var itemsUrl="http://183.82.32.76/restroApi///api/Mobile/GetInvoke";
    //  var itemsUrl="http://192.168.1.102//Quarry_Dev/QuarryApi_Dev///api/Mobile/GetInvoke";
     // var itemsUrl="https://quarrydemoapi.herokuapp.com/api/users/login";
    //  var itemsUrl="https://spectacular-salty-meeting.glitch.me/api/users/login";
    //  var itemsUrl="http://10.0.2.2:8080/api/users/login";
    //  var itemsUrl="http://117.247.181.35/restroApi///api/Mobile/GetInvoke";
      final response = await http.post(Uri.parse(itemsUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(body)
      );
      if(response.statusCode==200){
        return response.body;
      }
      // else if(response.statusCode==500){
      //    // return response.body;
      //   print(response.body);
      // }
      else{
        var msg;
        // print(msg);
         print(response.body);
        msg=json.decode(response.body);
     //   print(msg["Message"]['originalError']['info']['message']);
         CustomAlert().commonErrorAlert2(context, "${msg["Message"]}", "");
        return "null";
        // return response.statusCode.toString();
      }
    }
    catch(e){
      return "null";
      print("NETWORK ISSUE--$e");
      // CustomAlert().commonErrorAlert(context, "Network Issue", "Your Internet Connectivity or Server is Slow..");
    }
  }
}
