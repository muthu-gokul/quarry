

import 'dart:io';

import 'package:http/http.dart' as http;
import '../api/ApiManager.dart';

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


parseDouble(var value){
  try{
    return double.parse(value.toString());
  }catch(e){}
  return 0.0;
}

getAttachmentUrl(String path){
  return ApiManager().attachmentUrl+path;
}