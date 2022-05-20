

import 'dart:convert';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/ApiManager.dart';
import '../api/sp.dart';
import '../model/parameterMode.dart';
import '../notifier/quarryNotifier.dart';
import '../widgets/alertDialog.dart';
import 'errorLog.dart';

uploadFile(String folderName, File file) async{
  final postUri = Uri.parse("${ApiManager().baseUrl}api/Common/Upload?BaseFolder="+folderName);
  http.MultipartRequest request = http.MultipartRequest('POST', postUri);
  List files=[file];
  for(int i=0;i<1;i++){
    File imageFile = files[i];
    var stream = new http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = new http.MultipartFile("file", stream, length,
        filename: imageFile.path.split('/').last);
    request.files.add(multipartFile);
  }
  var response = await request.send();
  final res = await http.Response.fromStream(response);
  return res.body.replaceAll('"', '');
}

Future<void> requestDownload(String _url, String _name) async {

  String savePath = '/storage/emulated/0/Download/$_name';
  if (await File(savePath).exists()) {
    print("File exists");
    await File(savePath).delete();
  }

  String? _taskid = await FlutterDownloader.enqueue(
    url: _url,
    fileName: _name,
    savedDir: "/storage/emulated/0/Download",
    showNotification: true,
    openFileFromNotification: true,
  );

}



parseDouble(var value){
  try{
    return double.parse(value.toString());
  }catch(e){}
  return 0.0;
}

getAttachmentUrl(String path){
  return ApiManager().attachmentUrl+path;
}



getParameterEssential() async{
  return [
    ParameterModel(Key: "LoginUserId", Type: "int", Value: await getLoginId()),
    ParameterModel(Key: "IsMobile", Type: "int", Value: 1),
    ParameterModel(Key: "database", Type: "String", Value: await getDatabase()),
  ];
}

getDeviceInfoParam() async{
  SharedPreferences sp=await SharedPreferences.getInstance();
  return [
    ParameterModel(Key: "DeviceId", Type: "String", Value: sp.getString("deviceId")),
    ParameterModel(Key: "DeviceId", Type: "String", Value: sp.getString("deviceInfo")),
  ];
}

getLoginId() async{
  //SharedPreferences sp=await SharedPreferences.getInstance();
 // return sp.getInt("LoginUserId");
  return Provider.of<QuarryNotifier>(Get.context!,listen: false).UserId;
}

getDatabase() async{
//  SharedPreferences sp=await SharedPreferences.getInstance();
//  return sp.getString("DatabaseName");
  return Provider.of<QuarryNotifier>(Get.context!,listen: false).DataBaseName;
}

Future<List> getMasterDrp(String page,String typeName, dynamic refId,  dynamic hiraricalId) async {

  List parameters= await getParameterEssential();
  parameters.add(ParameterModel(Key: "SpName", Type: "String", Value: "${Sp.mobileMasterdropDown}"));
  parameters.add(ParameterModel(Key: "TypeName", Type: "String", Value: typeName));
  parameters.add(ParameterModel(Key: "Page", Type: "String", Value: page));
  parameters.add(ParameterModel(Key: "RefId", Type: "String", Value: refId));
  parameters.add(ParameterModel(Key: "RefTypeName", Type: "String", Value: typeName));
  parameters.add(ParameterModel(Key: "HiraricalId", Type: "String", Value: hiraricalId));

  var body={
    "Fields": parameters.map((e) => e.toJson()).toList()
  };
  var result=[];
  try{
    await ApiManager().ApiCallGetInvoke(body,Get.context!).then((value) {

      if(value != "null" && value!=''){
        var parsed=jsonDecode(value);
        var table=parsed['Table'] as List;
        if(table.length>0){
          result=table;
        }
      }
    });
    return result;
  }
  catch(e,stackTrace){
    errorLog("UTI01 ${e.toString()}", stackTrace,"Error UTI01",page,page, "${Sp.mobileMasterdropDown}");
    return result;
    //CustomAlert().commonErrorAlert(Get.context!, "Error G01", "Contact Administration");
  }
}

Future<String> getMasterDrpWeb(String page,String typeName, dynamic refId,  dynamic hiraricalId) async {

  List parameters= await getParameterEssential();
  parameters.add(ParameterModel(Key: "SpName", Type: "String", Value: "USP_Web_GetMasterDetail"));
  parameters.add(ParameterModel(Key: "TypeName", Type: "String", Value: typeName));
  parameters.add(ParameterModel(Key: "Page", Type: "String", Value: page));
  parameters.add(ParameterModel(Key: "RefId", Type: "String", Value: refId));
  parameters.add(ParameterModel(Key: "RefTypeName", Type: "String", Value: typeName));
  parameters.add(ParameterModel(Key: "HiraricalId", Type: "String", Value: hiraricalId));

  var body={
    "Fields": parameters.map((e) => e.toJson()).toList()
  };
  var result="";
  try{
    await ApiManager().ApiCallGetInvoke(body,Get.context!).then((value) {
      result=value;
    });
    return result;
  }
  catch(e,stackTrace){
    errorLog("UTI02 ${e.toString()}", stackTrace,"Error UTI02",page,page, "USP_Web_GetMasterDetail");
    return result;
    //CustomAlert().commonErrorAlert(Get.context!, "Error G01", "Contact Administration");
  }
}