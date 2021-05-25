import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';

class ProfileNotifier extends ChangeNotifier{

  final call=ApiManager();

  int UserId;
  String selectedSalutation="Mr";
  String UserGroupName="";
  TextEditingController firstName=new TextEditingController();
  TextEditingController lastName=new TextEditingController();
  TextEditingController contactNumber=new TextEditingController();
  TextEditingController email=new TextEditingController();
  TextEditingController password=new TextEditingController();





  UpdateUserProfileDetailDbHit(BuildContext context)  async{


    updateProfileLoader(true);

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
          "Value": ""
        },
        {
          "Key": "UserIMageFolderPath",
          "Type": "String",
          "Value": ""
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
          var t=parsed['Table'] as List;
          print(parsed);
        }



        updateProfileLoader(false);
      });
    }catch(e){
      updateProfileLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.updateUserProfileDetail}" , e.toString());
    }


  }

  List<ManageUserPlantModel> usersPlantList=[];


  GetUserDetailDbHit(BuildContext context,int userId)  async{


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
          var t=parsed['Table'] as List;


          if(userId!=null){
            var t1=parsed['Table1'] as List;
            print(t);
            print("t1${t1}");
            UserId=t[0]['UserId'];
            selectedSalutation=t[0]['UserSalutation'];
            UserGroupName=t[0]['UserGroupName'];
            firstName.text=t[0]['UserFirstName'];
            lastName.text=t[0]['UserLastName'];
            contactNumber.text=t[0]['UserContactNumber'];
            email.text=t[0]['UserEmail'];
            password.text=t[0]['UserPassword'];

            usersPlantList=t1.map((e) => ManageUserPlantModel.fromJson(e)).toList();
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