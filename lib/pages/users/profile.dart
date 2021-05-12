import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/machineNotifier.dart';
import 'package:quarry/notifier/manageUsersNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/pages/manageUsers/manageUsersGrid.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';

class ProfileScreen extends StatefulWidget {
  VoidCallback drawerCallback;
  ProfileScreen({this.drawerCallback});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;
  bool _keyboardVisible = false;
  bool salutationOpen=false;
  bool passwordvisible=true;

  bool isEdit=false;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


      /* scrollController.addListener(() {
        if(scrollController.offset>20){
          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);

        }
      });*/

      listViewController.addListener(() {

       /* if(listViewController.position.userScrollDirection == ScrollDirection.forward){
          print("Down");
        } else
        if(listViewController.position.userScrollDirection == ScrollDirection.reverse){
          print("Up");
          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }*/
        if(listViewController.offset>20){

          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);


        }
        else if(listViewController.offset==0){
          scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final node=FocusScope.of(context);
    SizeConfig().init(context);
   // _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        key: scaffoldkey,
        body: Consumer<ProfileNotifier>(
            builder: (context,pn,child)=> Stack(
              children: [



                Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: SizeConfig.height200,

                        decoration: BoxDecoration(
                            image: DecorationImage(
                               image: AssetImage("assets/images/saleFormheader.jpg",),
                                //image: AssetImage("assets/svg/gridHeader/companyDetailsHeader.jpg",),
                                fit: BoxFit.cover
                            )

                        ),
                      ),





                    ],
                  ),
                ),


                Container(
                  height: SizeConfig.screenHeight,
                  // color: Colors.transparent,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: scrollController,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 160,),
                            Container(
                              height: SizeConfig.screenHeight-60,
                              width: SizeConfig.screenWidth,
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                              ),
                              child: GestureDetector(
                                onVerticalDragUpdate: (details) {
                                  int sensitivity = 5;

                                  if (details.delta.dy > sensitivity) {
                                    scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                                  } else if(details.delta.dy < -sensitivity){
                                    scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  }
                                },
                               /* onVerticalDragDown: (v){
                                  if(scrollController.offset==100 && listViewController.offset==0){
                                    scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  }
                                  else if(scrollController.offset==0 && listViewController.offset==0){
                                    scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                                  }*/

                               // },
                                child: Container(
                                  height:_keyboardVisible?SizeConfig.screenHeight*0.5 :SizeConfig.screenHeight-100,
                                  width: SizeConfig.screenWidth,

                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                  ),
                                  child: ListView(
                                    controller: listViewController,
                                    scrollDirection: Axis.vertical,

                                    children: [
                                      Align(
                                         alignment:Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              isEdit=!isEdit;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: SizeConfig.width20,top: 10,bottom: 10),
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppTheme.yellowColor
                                            ),
                                            child: Center(
                                              child:  Icon(isEdit?Icons.clear:Icons.edit_outlined,color: AppTheme.bgColor,),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: SizeConfig.screenWidth,
                                          child: Column(
                                            children: [
                                              Text("${pn.selectedSalutation}.${pn.firstName.text}${pn.lastName.text}",
                                              style: AppTheme.userNameTS,
                                              ),
                                              SizedBox(height: 3,),
                                              Text("${pn.UserGroupName}",
                                                style: AppTheme.userGroupTS,
                                              ),
                                              SizedBox(height: 20,),
                                            ],
                                          )
                                      ),

                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                        height: salutationOpen? 100:50,
                                        width: SizeConfig.screenWidth,
                                        alignment: Alignment.topCenter,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Container(

                                                margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20),
                                                padding: EdgeInsets.only(left:SizeConfig.width60,),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                    color: isEdit?Colors.white: Color(0xFFF2F2F2),
                                                ),
                                                width: SizeConfig.screenWidth,
                                                height: 50,
                                                alignment: Alignment.topCenter,
                                                child:  TextFormField(
                                                  controller: pn.firstName,
                                                  enabled: isEdit,
                                                  onTap: (){
                                                    scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                    setState(() {
                                                      _keyboardVisible=true;
                                                    });

                                                  },

                                                  style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                                  decoration: InputDecoration(
                                                   fillColor:isEdit?Colors.white: Color(0xFFF2F2F2),
                                                      filled: true,
                                                      hintStyle: TextStyle(fontFamily: 'RL',fontSize: 15,color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
                                                      border:  InputBorder.none,
                                                      enabledBorder:   InputBorder.none,
                                                      focusedBorder:  InputBorder.none,
                                                      hintText:  'First Name',
                                                      /*contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),*/

                                                  ),
                                                  maxLines: null,
                                                  textInputAction: TextInputAction.done,

                                                  onEditingComplete: (){
                                                    node.unfocus();
                                                    Timer(Duration(milliseconds: 50), (){
                                                      setState(() {
                                                        _keyboardVisible=false;
                                                      });
                                                    });
                                                  },
                                                ),

                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: AnimatedContainer(
                                                height:salutationOpen? 100:30,
                                                width: 60,
                                                duration: Duration(milliseconds: 300),
                                                curve: Curves.easeIn,
                                                margin: EdgeInsets.only(left: SizeConfig.width30),
                                                decoration: BoxDecoration(
                                                    color: AppTheme.yellowColor,
                                                  borderRadius: BorderRadius.circular(10)
                                                ),
                                                child:salutationOpen? Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                            salutationOpen=false;
                                                            pn.selectedSalutation="Mr";
                                                          });
                                                        },
                                                        child: Text("Mr",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                    ),
                                                    InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                            salutationOpen=false;
                                                            pn.selectedSalutation="Mrs";
                                                          });
                                                        },
                                                        child: Text("Mrs",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                    ),
                                                    InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                            salutationOpen=false;
                                                            pn.selectedSalutation="Ms";
                                                          });
                                                        },
                                                        child: Text("Ms",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                    ),

                                                  ],
                                                )
                                                    :Center(
                                                  child: InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                          salutationOpen=true;
                                                        });

                                                      },
                                                      child: Text("${pn.selectedSalutation}",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                  ),
                                                ),
                                              ),
                                            )


                                          ],
                                        ),
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'Last Name',
                                        isEnabled: isEdit,
                                        textEditingController: pn.lastName,
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            _keyboardVisible=true;
                                          });

                                          },
                                        onEditComplete: (){
                                          node.unfocus();
                                          Timer(Duration(milliseconds: 50), (){
                                            setState(() {
                                              _keyboardVisible=false;
                                            });
                                          });
                                        },
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'Contact Number',
                                        isEnabled: isEdit,
                                        textEditingController: pn.contactNumber,
                                        textInputType: TextInputType.number,
                                        onEditComplete: (){
                                          node.unfocus();
                                          Timer(Duration(milliseconds: 50), (){
                                            setState(() {
                                              _keyboardVisible=false;
                                            });
                                          });
                                        },
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            _keyboardVisible=true;
                                          });

                                        },
                                      ),

                                      AddNewLabelTextField(
                                        labelText: 'Email',
                                        isEnabled: isEdit,
                                        textEditingController: pn.email,
                                        textInputType: TextInputType.emailAddress,
                                        scrollPadding: 100,
                                        onEditComplete: (){
                                          node.unfocus();
                                          Timer(Duration(milliseconds: 50), (){
                                            setState(() {
                                              _keyboardVisible=false;
                                            });
                                          });
                                        },
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            _keyboardVisible=true;
                                          });

                                        },
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'Password',
                                        isEnabled: isEdit,
                                        textEditingController: pn.password,
                                        scrollPadding: 100,
                                        isObscure: passwordvisible,
                                        maxlines: 1,
                                        onEditComplete: (){
                                          node.unfocus();
                                          Timer(Duration(milliseconds: 50), (){
                                            setState(() {
                                              _keyboardVisible=false;
                                            });
                                          });
                                        },
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            _keyboardVisible=true;
                                          });

                                        },
                                        suffixIcon:  IconButton(icon: Icon(passwordvisible?Icons.visibility_off:Icons.visibility,size: 30,color: Colors.grey,),
                                        onPressed: (){
                                      setState(() {
                                        passwordvisible=!passwordvisible;
                                      });
                                    }),
                                      ),
                                      SizedBox(height: SizeConfig.height20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, _createRoute());
                                              Provider.of<ManageUsersNotifier>(context,listen: false).GetUserDetailDbHit(context, null);
                                            },
                                            child: Container(
                                              width:SizeConfig.screenWidth*0.4,
                                              height:SizeConfig.height50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25.0),
                                                color: AppTheme.yellowColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTheme.yellowColor.withOpacity(0.4),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: Offset(1, 8), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                  child: Text("Manage Users",style: AppTheme.bgColorTS,
                                                  )
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width:SizeConfig.screenWidth*0.4,
                                            height:SizeConfig.height50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(25.0),
                                              color: AppTheme.yellowColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppTheme.yellowColor.withOpacity(0.4),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: Offset(1, 8), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                                child: Text("User Access",style: AppTheme.bgColorTS,
                                                )
                                            ),
                                          ),
                                        ],
                                      ),


                                      SizedBox(height: SizeConfig.height100,),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 110),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.yellowColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.yellowColor.withOpacity(0.4),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(1, 8), // changes position of shadow
                                  ),
                                ]
                            ),
                            child: Center(
                              child: Image.asset("assets/svg/drawer/avatar.png"),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                Container(
                  height: SizeConfig.height60,
                  width: SizeConfig.screenWidth,
                  child: Row(
                    children: [
                      IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                      SizedBox(width: SizeConfig.width5,),
                      Text("My Profile",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                      ),
                     /* Text(qn.isMachineEdit?" / Edit":" / Add New",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                      ),*/


                    ],
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  bottom:isEdit? 0:-80,
                  child: Container(
                    height:_keyboardVisible?0: SizeConfig.height70,
                    width: SizeConfig.screenWidth,
                    color: AppTheme.grey,
                    child: Center(
                      child: GestureDetector(
                        onTap: (){
                          node.unfocus();
                          if(isEdit){
                            pn.UpdateUserProfileDetailDbHit(context);
                            setState(() {
                              isEdit=false;
                            });
                          }

                       /*   if(qn.MachineName.text.isEmpty)
                          {
                            CustomAlert().commonErrorAlert(context, "Enter Machine Name", "");

                          }

                          else{
                            qn.InsertVehicleDbHit(context);

                          }*/

                        },
                        child: Container(
                          height: SizeConfig.height50,
                          width: SizeConfig.width120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(SizeConfig.height25),
                              color: AppTheme.bgColor
                          ),
                          child: Center(
                            child: Text(pn.isProfileEdit?"Update":"Save",style: AppTheme.TSWhite20,),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Container(

                  height: pn.ProfileLoader? SizeConfig.screenHeight:0,
                  width: pn.ProfileLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                    //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

                  ),
                ),
              ],
            )
        )

    );
  }
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ManageUsersGrid(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
