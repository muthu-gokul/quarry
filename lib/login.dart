import 'dart:convert';
import 'dart:developer';
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
import 'notifier/profileNotifier.dart';
import 'pages/homePage.dart';
import 'styles/app_theme.dart';
import 'styles/size.dart';
import 'styles/size.dart';





class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  TextEditingController jfdgj=new TextEditingController();

  late bool passwordvisible;
  late bool loginvalidation;
  late AnimationController shakecontroller;
  late Animation<double> offsetAnimation;
  bool isLoading=false;
  bool isVisible=false;
  bool isEmailInvalid=false;
  bool ispasswordInvalid=false;
  bool _keyboardVisible = false;

  bool passwordGlow=false;
  bool emailGlow=false;

  String? prefEmail;
  String? prefPassword;
  late SharedPreferences _Loginprefs;
  static const String useremail = 'email';
  static const String passwordd = 'password';

  void _loadCredentials() {

    setState(() {
      this.prefEmail = this._Loginprefs.getString(useremail) ?? "";
      this.prefPassword = this._Loginprefs.getString(passwordd) ?? "";
    });
    if(prefEmail!.isNotEmpty&&prefPassword!.isNotEmpty){
      setState(() {
        username.text=prefEmail!;
        password.text=prefPassword!;
      });
    }
    print(prefEmail!.isEmpty);
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
    SystemChrome.setEnabledSystemUIOverlays([]);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    var quarryNotifier=Provider.of<QuarryNotifier>(context, listen: false);
    var loginNotifier=Provider.of<LoginNotifier>(context, listen: false);
    // var inn=Provider.of<InternetNotifier>(context, listen: false);
    final node=FocusScope.of(context);



    SizeConfig().init(context);
    print(SizeConfig.screenHeight);
    print(SizeConfig.screenWidth);
    func() async {
      if(_loginFormKey.currentState!.validate() && !isEmailInvalid && !ispasswordInvalid){
        setState(() {
          isLoading=true;
        });
            var itemsUrl="http://183.82.32.76/restroApi///api/Mobile/GetInvoke";
          //  var itemsUrl="https://quarrydemoapi.herokuapp.com/api/users/login";
         //   var itemsUrl="https://spectacular-salty-meeting.glitch.me/api/users/login";
          //  var itemsUrl="http://10.0.2.2:8080/api/users/login";
        //var itemsUrl="http://117.247.181.35/restroApi///api/Mobile/GetInvoke";
       // var loginurl = 'http://183.82.32.76/restroApi///api/Mobile/GetInvokeforlogin';
        //var loginurl="http://117.247.181.35/restroApi///api/Mobile/GetInvokeforlogin";
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
            {
              "Key": "database",
              "Type": "String",
             // "Value": "TetroPOS_TestQMS" //live
            "Value": "TetroPos_QMSLocal"
           // "Value": "TetroPos_QMSTest1"
            // "Value": "QMS1"
            },

          ]
        };
        print(json.encode(body));

        final dynamic response = await http.post(
            Uri.parse(itemsUrl), headers: {"Content-Type": "application/json"},
            body: json.encode(body)
        ).then((value) async {
          var parsed = json.decode(value.body);
         // print(value.body);
          log("parsed ${value.body}");


          if (parsed["Table"] != null) {
            loginNotifier.fetchUserDetails(parsed);
            print(loginNotifier.userDetail.loginTblOutput![0].Status);

            if (loginNotifier.userDetail.loginTblOutput![0].Status) {
              if(prefEmail!.isEmpty && prefPassword!.isEmpty){
                _setCredentials(username.text, password.text);
              }else if(prefEmail!=username.text){
                _setCredentials(username.text, password.text);
              }
              quarryNotifier.initUserDetail(loginNotifier.userDetail.loginTable![0].UserId,
                  loginNotifier.userDetail.loginTable![0].UserName,
                  loginNotifier.userDetail.loginTable![0].DataBaseName,context);
              Provider.of<QuarryNotifier>(context,listen: false).GetQuarryDetailDbhit(context);
              Provider.of<QuarryNotifier>(context,listen: false).GetplantDetailDbhit(context,null,this);
              Provider.of<ProfileNotifier>(context, listen: false).GetUserDetailDbHit(context,loginNotifier.userDetail.loginTable![0].UserId);

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
            }
            else {
              setState(() {
                isLoading=false;
                loginvalidation = true;
                shakecontroller.forward(from: 0.0);
              });
            }
          }
          else {

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
    }

    return Scaffold(
      body: Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/svg/drawer/sidemenuBg.jpg"),
                fit: BoxFit.cover
            )
        ),

        child: Stack(

          children: [
            Container(
              height: _height,
              width: _width,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(height: _height * 0.15,),
                    SvgPicture.asset("assets/images/qms.svg",height: 100,),
                    SizedBox(height: 20,),
                    Form(
                        key: _loginFormKey,

                        child: AnimatedBuilder(
                            animation: offsetAnimation,
                            builder: (context, child) {
                              return Container(

                                padding: EdgeInsets.only(left: offsetAnimation.value + 30.0,
                                    right: 30.0 - offsetAnimation.value),
                                child: Stack(
                                  children: [

                                    GestureDetector(
                                      onTap:(){
                                         node.unfocus();
                                         func();
                                          },
                                      child: Container(
                                        height: 80,

                                        width: SizeConfig.screenWidth,
                                        alignment: Alignment.bottomCenter,
                                        margin: EdgeInsets.only(left: SizeConfig.width25!,right: SizeConfig.width25!,top: 280),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: AppTheme.yellowColor
                                        ),
                                        child: Padding(
                                          padding:  EdgeInsets.only(bottom: 15),
                                          child: Text("Login",style: TextStyle(fontSize: 20,fontFamily: 'RR',color: Colors.white),),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      height: 310,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppTheme.gridbodyBgColor
                                      ),

                                      // margin: EdgeInsets.only(top: _height * 0.28),
                                      child: Column(

                                        children: [
                                          loginvalidation?Text("Invalid Email Or Password",style: TextStyle(color: Colors.red,fontSize: 16,fontFamily: 'RR'),):Container(height: 20,width: 0,),
                                          SizedBox(height: 10,),
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:  EdgeInsets.only(left: SizeConfig.width30!,),
                                                child: Text("User Email",style: TextStyle(fontSize: 16,fontFamily: 'RR',color: AppTheme.grey),),
                                              )),
                                          Container(
                                            height: 50,
                                            width: SizeConfig.screenWidth,
                                            margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!,top: 10,bottom: 20),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color: Colors.white,
                                                border: Border.all(color: emailGlow?AppTheme.grey.withOpacity(0.7):Colors.transparent),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 15,
                                                    offset: Offset(0, 0), // changes position of shadow
                                                  )
                                                ]
                                            ),
                                            child: Container(
                                              width: SizeConfig.screenWidth!*0.45,
                                              padding: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                onTap: (){
                                                  setState(() {
                                                    passwordGlow=false;
                                                    emailGlow=true;
                                                  });
                                                },
                                                controller: username,
                                                scrollPadding: EdgeInsets.only(bottom: 400),
                                                style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    focusedErrorBorder: InputBorder.none,
                                                    enabledBorder: InputBorder.none,

                                                ),

                                                keyboardType: TextInputType.emailAddress,

                                                validator:(value){


                                                  Pattern pattern =
                                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                  RegExp regex = new RegExp(pattern as String);
                                                  if (!regex.hasMatch(value!)) {
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
                                                  setState(() {
                                                    passwordGlow=true;
                                                    emailGlow=false;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),

                                          isEmailInvalid?Container(
                                              margin: EdgeInsets.only(left:SizeConfig.width10!,right:SizeConfig.width10!,),
                                              alignment: Alignment.centerLeft,
                                              child: Text("* Email format is Invalid",style: TextStyle(color: Colors.red,fontSize: 18,fontFamily: 'RR'),textAlign: TextAlign.left,)
                                          ):Container(height: 0,width: 0,),

                                          SizedBox(height: 10,),
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:  EdgeInsets.only(left: SizeConfig.width30!,),
                                                child: Text("Password",style: TextStyle(fontSize: 16,fontFamily: 'RR',color: AppTheme.grey),),
                                              )
                                          ),
                                          Container(
                                            height: 50,
                                            width: SizeConfig.screenWidth,
                                            margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!,top: 10,bottom: 20),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                border: Border.all(color:passwordGlow? AppTheme.yellowColor:Colors.transparent),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:passwordGlow?AppTheme.yellowColor.withOpacity(0.2):  AppTheme.addNewTextFieldText.withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 15,
                                                    offset: Offset(0, 0), // changes position of shadow
                                                  )
                                                ]
                                            ),
                                            child: Container(
                                              width: SizeConfig.screenWidth!*0.45,
                                              padding: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                onTap: (){
                                                  setState(() {
                                                    emailGlow=false;
                                                    passwordGlow=true;
                                                  });
                                                },
                                                controller: password,
                                                obscureText: passwordvisible,
                                                obscuringCharacter: '*',
                                                scrollPadding: EdgeInsets.only(bottom: 500),
                                                style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  focusedErrorBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                    contentPadding: new EdgeInsets.only(top: 18),
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

                                                keyboardType: TextInputType.emailAddress,

                                                  validator:(value){
                                                    if(value!.isEmpty){
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
                                                    setState(() {
                                                      passwordGlow=false;
                                                    });
                                                    func();
                                                  }
                                              ),
                                            ),
                                          ),

                                          ispasswordInvalid?Container(
                                              margin: EdgeInsets.only(left:SizeConfig.width10!,right:SizeConfig.width10!,),
                                              alignment: Alignment.centerLeft,
                                              child: Text("* Password is required",style: TextStyle(color: Colors.red,fontSize: 18,fontFamily: 'RR'),textAlign: TextAlign.left,)
                                          ):Container(height: 0,width: 0,),
                                          SizedBox(height: 20,),

                                          InkWell(
                                            onTap: (){

                                            },
                                            child: Text("Forgot Password",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.grey,decoration: TextDecoration.underline),),
                                          ),
                                          SizedBox(height: 30,),


                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                    ),





                  ],
                ),
              ),
            ),
            Stack(
              children: [


                _keyboardVisible?Container():Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,

                      children: [
                        Text(
                          "@${DateFormat('yyyy').format(DateTime.now())}. All Rights Reserved. Designed by Scutisoft Pvt.Ltd",
                          style: TextStyle(fontFamily: 'RR',  color: AppTheme.grey,fontSize: 12 ),

                        ),

                      ],
                    ),
                  ),
                )
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
    );
  }
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);
    return (!regex.hasMatch(value)) ? false : true;
  }


}

