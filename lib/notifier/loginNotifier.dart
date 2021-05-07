import 'package:flutter/material.dart';



class LoginTable {
  int UserId;
  String UserName;
  String DataBaseName;



  LoginTable({this.UserId,this.UserName,this.DataBaseName="TetroPOS_TestQMS"});

  factory LoginTable.fromJson(Map<dynamic, dynamic> json) {
    return new LoginTable(
        UserId: json['UserId'],
      UserName: json['UserFirstName'],
     // DataBaseName: json['DataBaseName'],
    );
  }


}

class LoginTblOutPut {

  String Status;
  String Message;


  LoginTblOutPut(
      {this.Status,this.Message});

  factory LoginTblOutPut.fromJson(Map<String, dynamic> json) {
    return new LoginTblOutPut(
      Status: json['@Status'],
      Message: json['@Message'],

    );
  }

  Map<String,dynamic> toJson(){
    var map = <String, dynamic>{
      'Status': Status,
      'Message':Message,


    };
    return map;
  }


}


class LoginModel{
  List<LoginTable> loginTable;
  List<LoginTable> allUsers;
  List<LoginTblOutPut> loginTblOutput;
  LoginModel({this.loginTable,this.loginTblOutput,this.allUsers});

  factory LoginModel.fromJson(Map<dynamic, dynamic> json) {
   var loginTableJson=json['Table1'] as List;

   var loginTblOutputJson=json['TblOutPut'] as List;
   List<LoginTable> _loginTable=loginTableJson.map((e) => LoginTable.fromJson(e)).toList();

   List<LoginTblOutPut> _loginTblOutput=loginTblOutputJson.map((e) => LoginTblOutPut.fromJson(e)).toList();
   return new LoginModel(
     loginTable: _loginTable,
     loginTblOutput: _loginTblOutput,

   );
  }
}


class LoginNotifier extends ChangeNotifier{
  LoginModel userDetail;
  bool loading=false;


  // void updateLoad(BuildContext context){
  //   loading=!loading;
  //   if(!loading){
  //     Navigator.of(context).push(PageRouteBuilder(
  //       pageBuilder: (context, animation, secondaryAnimation) => BillingMainPage(),
  //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //         var begin = Offset(0.0, -1.0);
  //         var end = Offset.zero;
  //         var curve = Curves.ease;
  //         animation = CurvedAnimation(
  //             curve:  Curves.easeIn, parent: animation);
  //         var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //         return FadeTransition(
  //           opacity: animation,
  //           child: child,
  //         );
  //       },
  //     )
  //     );
  //   }
  //   notifyListeners();
  // }


  void fetchUserDetails(var parsed){
    userDetail=LoginModel.fromJson(parsed);
    notifyListeners();
  }
}