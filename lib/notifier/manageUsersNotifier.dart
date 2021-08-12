import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/manageUsersModel/manageUsersGridModel.dart';
import 'package:quarry/model/manageUsersModel/manageUsersGroupModel.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/widgets/alertDialog.dart';

class ManageUsersNotifier extends ChangeNotifier{
  final call=ApiManager();



  int? UserId=null;
  String? selectedSalutation="Mr";
  String UserGroupName="";
  TextEditingController firstName=new TextEditingController();
  TextEditingController lastName=new TextEditingController();
  TextEditingController contactNumber=new TextEditingController();
  TextEditingController email=new TextEditingController();
  TextEditingController password=new TextEditingController();

  int? userGroupId=null;
  String? userGroupName=null;



  List<ManageUserPlantModel> plantMappingList=[];

  List<dynamic>? userGroupList=[];
  List<ManageUserPlantModel> plantList=[];

  UserDropDownValues(BuildContext context) async {

    updateManageUsersLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.MasterdropDown}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": Provider.of<QuarryNotifier>(context,listen: false).UserId
        },
        {
          "Key": "TypeName",
          "Type": "String",
          "Value": "User"
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
          var t1=parsed['Table1'] as List?;
          var t2=parsed['Table2'] as List;

          userGroupList=t;
          plantList=t2.map((e) => ManageUserPlantModel.fromJson(e)).toList();
        }
        updateManageUsersLoader(false);
      });
    }
    catch(e){
      updateManageUsersLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }



  InsertUserDetailDbHit(BuildContext context)  async{


    updateManageUsersLoader(true);

     List js=[];
     js=plantMappingList.map((e) => e.toJson()).toList();
     print("JS$js");

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isManageUsersEdit?"${Sp.updateUserDetail}":"${Sp.insertUserDetail}"
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
          "Key": "UserGroupId",
          "Type": "int",
          "Value": userGroupId
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
          "Key": "UserPlantMappingList",
          "Type": "datatable",
          "Value": js
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
          print(parsed);
          Navigator.pop(context);
          clearForm();
          GetUserDetailDbHit(context, null);
          Provider.of<ProfileNotifier>(context, listen: false).GetUserDetailDbHit(context,UserId);


        }
        updateManageUsersLoader(false);
      });
    }catch(e){
      updateManageUsersLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.updateUserDetail}" , e.toString());
    }


  }

  List<ManageUsersGridModel> usersList=[];
  GetUserDetailDbHit(BuildContext context,int? userId)  async{
    updateManageUsersLoader(true);

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
          var t1=parsed['Table1'] as List?;
          print(value);


          if(userId!=null){
            UserId=t![0]['UserId'];
            selectedSalutation=t[0]['UserSalutation'];
            firstName.text=t[0]['UserFirstName'];
            lastName.text=t[0]['UserLastName'];
            contactNumber.text=t[0]['UserContactNumber'];
            email.text=t[0]['UserEmail'];
            password.text=t[0]['UserPassword'];
            userGroupId=t[0]['UserGroupId'];
            userGroupName=t[0]['UserGroupName'];

            plantMappingList=t1!.map((e) => ManageUserPlantModel.fromJson(e)).toList();
          }
          else{
            usersList=t!.map((e) => ManageUsersGridModel.fromJson(e)).toList();
          }
        }
        updateManageUsersLoader(false);
      });
    }catch(e){
      updateManageUsersLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getUserDetail}" , e.toString());
    }


  }



  clearForm(){
    UserId=null;
    selectedSalutation="Mr";
    UserGroupName="";
    firstName.clear();
    lastName.clear();
    contactNumber.clear();
    email.clear();
    password.clear();

    userGroupId=null;
    userGroupName=null;
    plantMappingList.clear();
  }



  bool ManageUsersLoader=false;
  updateManageUsersLoader(bool value){
    ManageUsersLoader=value;
    notifyListeners();
  }


  bool isManageUsersEdit=false;
  updateisManageUsersEdit(bool value){
    isManageUsersEdit=value;
    notifyListeners();
  }

  bool isEdit=false;
  updateisEdit(bool value){
    isEdit=value;
    notifyListeners();
  }

}