import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';

import '../utils/utils.dart';

class ProfileNotifier extends ChangeNotifier{

  final call=ApiManager();

  int? UserId;
  String? selectedSalutation="Mr";
  String? UserGroupName="";
  TextEditingController firstName=new TextEditingController();
  TextEditingController lastName=new TextEditingController();
  TextEditingController contactNumber=new TextEditingController();
  TextEditingController email=new TextEditingController();
  TextEditingController password=new TextEditingController();


  var userLogoFileName;
  var userLogoFolderName="User";
  String userLogoUrl="";
  File? logoFile;


  UpdateUserProfileDetailDbHit(BuildContext context)  async{


    updateProfileLoader(true);
    if(logoFile!=null){
      userLogoFileName = await uploadFile(userLogoFolderName,logoFile!);
    }
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.updateUserProfileDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "UserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "UserSalutation",
          "Type": "String",
          "Value": selectedSalutation
        },
        {
          "Key": "UserFirstName",
          "Type": "String",
          "Value": firstName.text
        },
        {
          "Key": "UserLastName",
          "Type": "String",
          "Value": lastName.text
        },
        {
          "Key": "UserContactNumber",
          "Type": "String",
          "Value": contactNumber.text
        },
        {
          "Key": "UserEmail",
          "Type": "String",
          "Value": email.text
        },
        {
          "Key": "UserPassword",
          "Type": "String",
          "Value": password.text
        },
        {
          "Key": "UserImageFileName",
          "Type": "String",
          "Value": userLogoFileName
        },
        {
          "Key": "UserIMageFolderPath",
          "Type": "String",
          "Value": userLogoFolderName
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
        if(value!="null"){
          var parsed=json.decode(value);
          var t=parsed['Table'] as List?;
          GetUserDetailDbHit(context, Provider.of<QuarryNotifier>(context,listen: false).UserId);
        }

        updateProfileLoader(false);
      });
    }catch(e){
      updateProfileLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.updateUserProfileDetail}" , e.toString());
    }


  }

  List<ManageUserPlantModel> usersPlantList=[];




  GetUserDetailDbHit(BuildContext context,int? userId)  async{


    updateProfileLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getUserDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "UserId",
          "Type": "int",
          "Value": userId
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
          var t=parsed['Table'] as List?;


          if(userId!=null){
            var t1=parsed['Table1'] as List;
            print("GetUserDetailDbHit ${value}");
            UserId=t![0]['UserId'];
            selectedSalutation=t[0]['UserSalutation'];
            UserGroupName=t[0]['UserGroupName'];
            firstName.text=t[0]['UserFirstName'];
            lastName.text=t[0]['UserLastName'];
            contactNumber.text=t[0]['UserContactNumber'];
            email.text=t[0]['UserEmail'];
            password.text=t[0]['UserPassword'];

            usersPlantList=t1.map((e) => ManageUserPlantModel.fromJson(e)).toList();

            userLogoFileName= t[0]['UserImage'];
            userLogoUrl=ApiManager().attachmentUrl+userLogoFileName;

          }
          else{

          }
        }



        updateProfileLoader(false);
      });
    }catch(e){
      updateProfileLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getUserDetail}" , e.toString());
    }


  }





  bool ProfileLoader=false;
  updateProfileLoader(bool value){
    ProfileLoader=value;
    notifyListeners();
  }


 bool isProfileEdit=false;
 updateisProfileEdit(bool value){
   isProfileEdit=value;
   notifyListeners();
 }

}