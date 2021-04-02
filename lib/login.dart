import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:permission_handler/permission_handler.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/sp.dart';
import 'notifier/loginNotifier.dart';
import 'pages/homePage.dart';
import 'styles/app_theme.dart';
import 'styles/size.dart';
import 'widgets/springButton.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool passwordvisible;
  bool loginvalidation;
  AnimationController shakecontroller;
  Animation<double> offsetAnimation;
  bool isLoading=false;
  bool isVisible=false;
  bool isEmailInvalid=false;
  bool ispasswordInvalid=false;

  String prefEmail;
  String prefPassword;
  SharedPreferences _Loginprefs;
  static const String useremail = 'email';
  static const String passwordd = 'password';

  void _loadCredentials() {
    setState(() {
      this.prefEmail = this._Loginprefs.getString(useremail) ?? "";
      this.prefPassword = this._Loginprefs.getString(passwordd) ?? "";
    });
    if(prefEmail.isNotEmpty&&prefPassword.isNotEmpty){
      setState(() {
        username.text=prefEmail;
        password.text=prefPassword;
      });
    }
    print(prefEmail.isEmpty);
    print(prefPassword);

  }

  Future<Null> _setCredentials(String email,String pass) async {
    await this._Loginprefs.setString(useremail, email);
    await this._Loginprefs.setString(passwordd, pass);
    // _loadCredentials();
  }



  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    passwordvisible = true;
    loginvalidation=false;
    shakecontroller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    username.clear();
    password.clear();
     allowAccess();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._Loginprefs = prefs);

        _loadCredentials();
      });
    super.initState();
  }
   //
   allowAccess() async{
     var status = await Permission.storage.status;
     if (!status.isGranted) {
       await Permission.storage.request();
     }
     // final PermissionHandler _permissionHandler = PermissionHandler();
     // var result = await _permissionHandler.requestPermissions([PermissionGroup.storage]);
     // if(result[PermissionGroup.storage] == PermissionStatus.granted) {
     //   String dir = (await getApplicationDocumentsDirectory()).path;
     //   await Directory('$dir/images').create(recursive: true);
     // }

   }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    var quarryNotifier=Provider.of<QuarryNotifier>(context, listen: false);
    var loginNotifier=Provider.of<LoginNotifier>(context, listen: false);
     // var inn=Provider.of<InternetNotifier>(context, listen: false);
    final node=FocusScope.of(context);
     SizeConfig().init(context);

     SystemChrome.setEnabledSystemUIOverlays([]);
    offsetAnimation = Tween(begin: 0.0, end: 28.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(shakecontroller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              shakecontroller.reverse().whenComplete(() {
                setState(() {
                  loginvalidation=false;
                });
              });
            }
          });
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login-bg.jpg"),
            fit: BoxFit.fill
          ),

        ),

        child: Stack(
          children: [
            Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("  ${DateFormat.jm().format(DateTime.parse(DateTime.now().toString()))}",
                          style: TextStyle(fontSize: 14, color: Colors.white,fontFamily: 'RR'),
                        ),
                        // Container(
                        //   height: 15,
                        //   width: 30,
                        //   margin: EdgeInsets.only(right: 10),
                        //   decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.white, width: 2)),
                        //   child: Center(
                        //     child:    Consumer<BatteryNotifier>(
                        //       builder: (context,battery,child)=>
                        //           Text(
                        //             battery.binfo!=null? battery.binfo.toString():"1",
                        //             style: TextStyle(color: Colors.white, fontSize:14,fontFamily: 'RR'),
                        //           ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  SizedBox(height: _height * 0.15,),
                  SvgPicture.asset("assets/svg/logo.svg"),
                  Form(
                      key: _loginFormKey,
                      child: AnimatedBuilder(
                          animation: offsetAnimation,
                          builder: (context, child) {
                            return Container(

                              padding: EdgeInsets.only(
                                  left: offsetAnimation.value + 30.0,
                                  right: 30.0 - offsetAnimation.value),
                              child: Container(
                                // margin: EdgeInsets.only(top: _height * 0.28),
                                child: Column(

                                  children: [
                                    loginvalidation?Text("Invalid Email Or Password",style: TextStyle(color: Colors.red,fontSize: 18,fontFamily: 'RR'),):Container(height: 20,width: 0,),
                                    SizedBox(height: 10,),
                                    Container(

                                      height: _width > 420?68:60,
                                       width:double.maxFinite ,
                                    //  width:_width > 420? _width * 0.4:_width*0.8,
                                      margin: EdgeInsets.only(left:SizeConfig.width10,right:SizeConfig.width10,),
                                      padding: EdgeInsets.only(left:SizeConfig.width10,),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border:loginvalidation? Border.all(color: Colors.red,width: 2):Border.all(color: AppTheme.yellowColor),
                                          color: loginvalidation?Color(0xFF1C1F32):AppTheme.bgColor),
                                      child: TextFormField(

                                        scrollPadding: EdgeInsets.only(bottom:SizeConfig.height270),
                                        style: TextStyle(color:loginvalidation?Colors.red:Colors.white,fontSize:18,fontFamily: 'RR' ),
                                        //TextStyle(color: loginvalidation?Colors.red:Colors.black),
                                        controller: username,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText: "Enter User Email",
                                            hintStyle: TextStyle(color:loginvalidation?Colors.red: AppTheme.yellowColor,fontSize: 18,fontFamily: 'RL'),

                                            fillColor: loginvalidation?Color(0xFF1C1F32):Colors.white,
                                          contentPadding: new EdgeInsets.only(top: 10),

                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        validator:(value){

                                          Pattern pattern =
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                          RegExp regex = new RegExp(pattern);
                                          if (!regex.hasMatch(value)) {
                                            setState(() {
                                              isEmailInvalid=true;
                                            });
                                           // return 'Email format is invalid';
                                          } else {
                                            setState(() {
                                              isEmailInvalid=false;
                                            });
                                            // return null;
                                          }
                                        },
                                        onEditingComplete: (){
                                          node.nextFocus();
                                        },
                                      ),
                                    ),
                                    isEmailInvalid?Container(
                                        margin: EdgeInsets.only(left:SizeConfig.width10,right:SizeConfig.width10,),
                                        alignment: Alignment.centerLeft,
                                        child: Text("* Email format is Invalid",style: TextStyle(color: Colors.red,fontSize: 18,fontFamily: 'RR'),textAlign: TextAlign.left,)
                                    ):Container(height: 0,width: 0,),

                                    SizedBox(height: 20,),
                                    Container(
                                      height: _width > 420?68:60,
                                      width:double.maxFinite ,
                                      //  width:_width > 420? _width * 0.4:_width*0.8,
                                      margin: EdgeInsets.only(left:SizeConfig.width10,right:SizeConfig.width10,),
                                      padding: EdgeInsets.only(left:SizeConfig.width10,),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border:loginvalidation? Border.all(color: Colors.red,width: 2):Border.all(color: AppTheme.yellowColor),
                                          color:loginvalidation?Color(0xFF1C1F32): AppTheme.bgColor),
                                      child: TextFormField(
                                        // onTap: (){
                                        //   // if(username.text.isEmpty){
                                        //   //   _loginFormKey.currentState.reset();
                                        //   // }
                                        // },
                                        style:TextStyle(color:loginvalidation?Colors.red:Colors.white,fontSize:18,fontFamily: 'RR' ),
                                        controller: password,
                                        obscureText: passwordvisible,
                                        obscuringCharacter: '*',
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText: "Enter Password",
                                            hintStyle: TextStyle(color:loginvalidation?Colors.red: AppTheme.yellowColor,fontSize: 18,fontFamily: 'RL'),

                                            fillColor: loginvalidation?Color(0xFF1C1F32):Colors.white,
                                            contentPadding: new EdgeInsets.only(top: 20),
                                            suffixIconConstraints: BoxConstraints(
                                              minHeight: 55,
                                              maxWidth: 55
                                            ),
                                            suffixIcon: IconButton(icon: Icon(passwordvisible?Icons.visibility_off:Icons.visibility,size: 30,color: Colors.grey,),
                                                onPressed: (){
                                              setState(() {
                                                passwordvisible=!passwordvisible;
                                              });
                                          })
                                        ),
                                        validator:(value){
                                          if(value.isEmpty){
                                           setState(() {
                                             ispasswordInvalid=true;
                                           });
                                          }
                                          else{
                                            setState(() {
                                              ispasswordInvalid=false;
                                            });
                                          }
                                        },
                                        onEditingComplete: () async {
                                          node.unfocus();
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                          if(_loginFormKey.currentState.validate()){
                                            setState(() {
                                              isLoading=true;
                                            });

                                              var loginurl = 'http://183.82.32.76/restroApi///api/Mobile/GetInvokeforlogin';
                                              var body = {
                                                "Fields": [
                                                  {
                                                    "Key": "SpName",
                                                    "Type": "String",
                                                    "Value": "${Sp.LoginSp}"
                                                  },
                                                  {
                                                    "Key": "UserName",
                                                    "Type": "String",
                                                    "Value": "${username.text}"
                                                  },
                                                  {
                                                    "Key": "Password",
                                                    "Type": "String",
                                                    "Value": "${password.text}"
                                                  },

                                                ]
                                              };

                                              final response = await http.post(
                                                  Uri.parse(loginurl), headers: {"Content-Type": "application/json"},
                                                  body: json.encode(body)
                                              ).then((value) async {
                                                var parsed = json.decode(value.body);
                                                print(parsed);


                                                if (parsed["Table"] != null) {
                                                  loginNotifier.fetchUserDetails(parsed);

                                                  if (loginNotifier.userDetail.loginTblOutput[0].Status == 'True') {
                                                    if(prefEmail.isEmpty && prefPassword.isEmpty){
                                                      _setCredentials(username.text, password.text);
                                                    }
                                                    quarryNotifier.initUserDetail(loginNotifier.userDetail.loginTable[0].UserId,
                                                      loginNotifier.userDetail.loginTable[0].UserName,
                                                      loginNotifier.userDetail.loginTable[0].DataBaseName,context);
                                                      Provider.of<QuarryNotifier>(context,listen: false).GetQuarryDetailDbhit(context);

                                                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                                                      pageBuilder: (context, animation, secondaryAnimation) =>HomePage(),

                                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                        var begin = Offset(0.0, -1.0);
                                                        var end = Offset.zero;
                                                        var curve = Curves.ease;
                                                        animation = CurvedAnimation(curve: Curves.easeIn, parent: animation);

                                                        return FadeTransition(
                                                          opacity: animation,
                                                          child: child,
                                                        );
                                                      },
                                                    )
                                                    );




                                                    setState(() {
                                                      loginvalidation = false;

                                                      node.unfocus();
                                                      isLoading=false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isLoading=false;
                                                      loginvalidation = true;
                                                      shakecontroller.forward(from: 0.0);
                                                    });
                                                  }
                                                } else {

                                                  setState(() {
                                                    isLoading=false;
                                                    loginvalidation = true;
                                                    shakecontroller.forward(from: 0.0);
                                                  });
                                                }
                                              });

                                              // }catch(e){
                                              //   CustomAlert().showDialog2(context, e.toString(), "Internet OR Server Issue");
                                              // }
                                            }
                                            // else{
                                            //   setState(() {
                                            //     isLoading=false;
                                            //   });
                                            //   CustomAlert().commonErrorAlert(context, "No Internet", "");
                                            // }
                                          }

                                      ),
                                    ),
                                    ispasswordInvalid?Container(
                                        margin: EdgeInsets.only(left:SizeConfig.width10,right:SizeConfig.width10,),
                                        alignment: Alignment.centerLeft,
                                        child: Text("* Password is required",style: TextStyle(color: Colors.red,fontSize: 18,fontFamily: 'RR'),textAlign: TextAlign.left,)
                                    ):Container(height: 0,width: 0,),
                                    SizedBox(height: 30,),
                                    Consumer<LoginNotifier>(
                                      builder: (context,loginNotifier,child)=>  Container(
                                          width: _width > 420? 200:200,
                                          height: 80,
                                          child:
                                          //loginNotifier.loading?Center(child: CircularProgressIndicator()):
                                          SpringButton(
                                            SpringButtonType.OnlyScale,
                                              Padding(
                                                padding: EdgeInsets.all(12.5),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.yellowColor,
                                                    borderRadius: const BorderRadius.all(const Radius.circular(3.0)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Login",
                                                      style: const TextStyle(
                                                        fontFamily: 'RR',
                                                        color: AppTheme.bgColor,
                                                        fontSize:18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            onTap: () async{
                                              node.unfocus();
                                              if(_loginFormKey.currentState.validate() && !isEmailInvalid && !ispasswordInvalid){
                                                setState(() {
                                                  isLoading=true;
                                                });

                                                var loginurl = 'http://183.82.32.76/restroApi///api/Mobile/GetInvokeforlogin';
                                                var body = {
                                                  "Fields": [
                                                    {
                                                      "Key": "SpName",
                                                      "Type": "String",
                                                      "Value": "${Sp.LoginSp}"
                                                    },
                                                    {
                                                      "Key": "UserName",
                                                      "Type": "String",
                                                      "Value": "${username.text}"
                                                    },
                                                    {
                                                      "Key": "Password",
                                                      "Type": "String",
                                                      "Value": "${password.text}"
                                                    },

                                                  ]
                                                };

                                                final response = await http.post(
                                                    Uri.parse(loginurl), headers: {"Content-Type": "application/json"},
                                                    body: json.encode(body)
                                                ).then((value) async {
                                                  var parsed = json.decode(value.body);
                                                  print("DATA -$parsed");


                                                  if (parsed["Table"] != null) {
                                                    loginNotifier.fetchUserDetails(parsed);

                                                    if (loginNotifier.userDetail.loginTblOutput[0].Status == 'True') {

                                                      if(prefEmail.isEmpty && prefPassword.isEmpty){
                                                        _setCredentials(username.text, password.text);
                                                      }

                                                      print(loginNotifier.userDetail.loginTable[0].DataBaseName);

                                                      quarryNotifier.initUserDetail(loginNotifier.userDetail.loginTable[0].UserId,
                                                        loginNotifier.userDetail.loginTable[0].UserName,
                                                        loginNotifier.userDetail.loginTable[0].DataBaseName,context);
                                                      Provider.of<QuarryNotifier>(context,listen: false).GetQuarryDetailDbhit(context);

                                                      Navigator.of(context).pushReplacement(PageRouteBuilder(
                                                        pageBuilder: (context, animation, secondaryAnimation) =>HomePage(),

                                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                          var begin = Offset(0.0, -1.0);
                                                          var end = Offset.zero;
                                                          var curve = Curves.ease;
                                                          animation = CurvedAnimation(curve: Curves.easeIn, parent: animation);

                                                          return FadeTransition(
                                                            opacity: animation,
                                                            child: child,
                                                          );
                                                        },
                                                      )
                                                      );




                                                      setState(() {
                                                        loginvalidation = false;

                                                        node.unfocus();
                                                        isLoading=false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isLoading=false;
                                                        loginvalidation = true;
                                                        shakecontroller.forward(from: 0.0);
                                                      });
                                                    }
                                                  } else {

                                                    setState(() {
                                                      isLoading=false;
                                                      loginvalidation = true;
                                                      shakecontroller.forward(from: 0.0);
                                                    });
                                                  }
                                                });

                                                // }catch(e){
                                                //   CustomAlert().showDialog2(context, e.toString(), "Internet OR Server Issue");
                                                // }
                                              }


                                            },

                                          ),
                                        ),

                                    )
                                  ],
                                ),
                              ),
                            );
                          })),
                  Spacer(),
                  Stack(
                    children: [
                      // Align(
                      //     alignment: Alignment.bottomLeft,
                      //     child:
                      //     // Container(
                      //     //   margin: EdgeInsets.only(bottom: 5),
                      //     //   height: 50,
                      //     //   width: 50,
                      //     //   color: Colors.red,
                      //     // )
                      //     //Text("${Provider.of<BillingNotifier>(context,listen:false).deviceData['id']}"),
                      //   IconButton(icon: Icon(Icons.info_outline,color: Colors.white,),
                      //       onPressed:(){
                      //
                      //
                      //         showGeneralDialog(
                      //             barrierColor: Colors.black.withOpacity(0.5),
                      //             transitionBuilder: (context, a1, a2, widget) {
                      //              var scaleAnimation = new Tween(begin: 0.0, end: 1.0)
                      //                  .animate(new CurvedAnimation(parent: a1, curve: Curves.easeIn));
                      //               return Transform.scale(
                      //                 scale: scaleAnimation.value,
                      //                 child: Dialog(
                      //                   backgroundColor: Colors.white,
                      //                   shape: RoundedRectangleBorder(
                      //                       borderRadius: BorderRadius.circular(10.0)
                      //                   ),
                      //                   child: Container(
                      //                     height: 530,
                      //                     width: 560,
                      //                     decoration: BoxDecoration(
                      //                         borderRadius: BorderRadius.circular(10)
                      //                     ),
                      //                     child: Column(
                      //                       mainAxisAlignment: MainAxisAlignment.start,
                      //                       crossAxisAlignment: CrossAxisAlignment.center,
                      //
                      //                       children: [
                      //                         SvgPicture.asset(
                      //                           'assets/cliparts/device-info-clipart.svg',
                      //                           width: 230,
                      //                           height: 370,
                      //                         ),
                      //                         Text("Your Device Id",style: TextStyle(fontFamily: 'RL',fontSize: 20,color: Color(0xFF555555)),),
                      //                         SizedBox(height: 20,),
                      //                         Container(
                      //                           height: 50,
                      //                           width: 450,
                      //                           decoration: BoxDecoration(
                      //                               borderRadius: BorderRadius.circular(5),
                      //                               color: Color(0xFFF1F1F1)
                      //                           ),
                      //                           child: Center(
                      //                             child:Text("${Provider.of<InventoryNotifier>(context,listen:false).deviceData['id']}",
                      //                                 style: AppTheme.textStyle),
                      //                           ),
                      //                         ),
                      //
                      //                       ],
                      //                     ),
                      //                   ),
                      //
                      //                 ),
                      //               );
                      //             },
                      //             transitionDuration: Duration(milliseconds: 300),
                      //             barrierDismissible: true,
                      //             barrierLabel: '',
                      //             context: context,
                      //             pageBuilder: (context, animation1, animation2) {}
                      //             );
                      //
                      //       }
                      //     ),
                      // ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [
                              Text(
                                "@${DateFormat('yyyy').format(DateTime.now())}. All Rights Reserved. Designed by Tetrosoft",
                                style: TextStyle(fontFamily: 'RR',  color: AppTheme.grey,fontSize: 12 ),

                              ),
                              // Text("Ver: 1.0.1",
                              //   style: TextStyle(fontFamily: 'RR',color: Colors.white,fontWeight: FontWeight.normal,),
                              // ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            isLoading?Container(
              height: _height,
              width: _width,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                   // height: 100,
                   //  width: 100,
                   //  decoration: BoxDecoration(
                   //    shape: BoxShape.circle,
                   //  ),
                   // child: Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)
                    // child: Image.asset("assets/images/sucess.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)
                ),
              ),
            ):Container(width: 0,height: 0,)
          ],
        ),
        ),
      ),
    );
  }
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
}
