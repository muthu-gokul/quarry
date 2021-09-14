
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/manageUsersNotifier.dart';

import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';

import 'manageUsersAddNew.dart';





class ManageUsersGrid extends StatefulWidget {
  VoidCallback? drawerCallback;
  ManageUsersGrid({this.drawerCallback});
  @override
  ManageUsersGridState createState() => ManageUsersGridState();
}

class ManageUsersGridState extends State<ManageUsersGrid> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController? scrollController;
  ScrollController? listViewController;
  bool isListScroll=false;

  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance!.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<ManageUsersNotifier>(
          builder: (context,mun,child)=> Stack(
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
                              fit: BoxFit.cover
                          )

                      ),
                    ),
                  ],
                ),
              ),


              Container(
                height: SizeConfig.screenHeight,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(height: 160,),
                      GestureDetector(
                        onVerticalDragUpdate: (details){

                          int sensitivity = 5;
                          if (details.delta.dy > sensitivity) {
                            scrollController!.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                              if(isListScroll){
                                setState(() {
                                  isListScroll=false;
                                });
                              }
                            });

                          } else if(details.delta.dy < -sensitivity){
                            scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

                              if(!isListScroll){
                                setState(() {
                                  isListScroll=true;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          height: SizeConfig.screenHeight!-60,
                          width: SizeConfig.screenWidth,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: NotificationListener<ScrollNotification>(
                                    onNotification: (s){
                                      if(s is ScrollStartNotification){

                                        if(listViewController!.offset==0 && isListScroll && scrollController!.offset==100 && listViewController!.position.userScrollDirection==ScrollDirection.idle){

                                          Timer(Duration(milliseconds: 100), (){
                                            if(listViewController!.position.userScrollDirection!=ScrollDirection.reverse){

                                              //if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
                                              if(listViewController!.offset==0){

                                                scrollController!.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value) {
                                                  if(isListScroll){
                                                    setState(() {
                                                      isListScroll=false;
                                                    });
                                                  }
                                                });
                                              }

                                            }
                                          });
                                        }
                                      }
                                      return true;
                                     } ,
                            child: ListView(
                              controller: listViewController,
                              scrollDirection: Axis.vertical,
                              physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: SizeConfig.screenWidth!*0.5,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                                        ),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: (){
                                              if(userAccessList[1].isHasAccess){
                                                mun.updateisManageUsersEdit(false);
                                                mun.updateisEdit(true);
                                                Navigator.push(context, _createRoute());
                                                mun.UserDropDownValues(context);
                                              }
                                              else{
                                                 CustomAlert().accessDenied(context);
                                              }
                                            },
                                            child: Container(
                                              height: 80,
                                              width: 80,
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
                                                child: SvgPicture.asset("assets/svg/plusIcon.svg",height: 35,width: 35,color: AppTheme.addNewTextFieldFocusBorder,),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      mun.usersList.isNotEmpty? GestureDetector(
                                        onTap: (){
                                          if(userAccessList[1].isHasAccess){
                                            mun.updateisManageUsersEdit(true);
                                            mun.updateisEdit(false);
                                            Navigator.push(context, _createRoute());
                                            mun.UserDropDownValues(context);
                                            mun.GetUserDetailDbHit(context,mun.usersList[0].userId);
                                          }
                                          else{
                                            CustomAlert().accessDenied(context);
                                          }




                                        },
                                        onLongPress: (){
                                          CustomAlert(
                                            callback: (){

                                            },
                                            Cancelcallback: (){
                                              Navigator.pop(context);
                                            }
                                          ).yesOrNoDialog(context, "", "Are you sure want to delete this user ?");
                                        },
                                        child: Container(
                                          height: 200,
                                          width: SizeConfig.screenWidth!*0.5,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(10))
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 50,),
                                              Container(
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: AppTheme.uploadColor,width: 2)
                                                ),
                                                child: Center(
                                                  child: Image.asset("assets/svg/drawer/avatar.png"),
                                                ),
                                              ),

                                              SizedBox(height: 20,),
                                              Text("${mun.usersList[0].userName}  ",
                                                style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RM',fontSize: 14),
                                              ),
                                              SizedBox(height: 3,),
                                              Text("${mun.usersList[0].userGroupName}  ",
                                                style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RR',fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ):Container(
                                        height: 200,
                                        width: SizeConfig.screenWidth!*0.5,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),



                                SingleChildScrollView(
                                  child: Wrap(
                                      children: mun.usersList.asMap()
                                          .map((i, value) => MapEntry(i,    i==0?Container():
                                      GestureDetector(
                                        onTap: (){
                                       //   Navigator.push(context, _createRoute());
                                        //  qn.GetplantDetailDbhit(context, qn.plantGridList[i].plantId);

                                        },
                                        child: Container(
                                          height: 200,
                                          width: SizeConfig.screenWidth!*0.5,
                                          color: Colors.white,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 50,),
                                              GestureDetector(
                                                onTap: (){
                                                  if(userAccessList[1].isHasAccess){
                                                    mun.updateisManageUsersEdit(true);
                                                    mun.updateisEdit(false);
                                                    Navigator.push(context, _createRoute());
                                                    mun.UserDropDownValues(context);
                                                    mun.GetUserDetailDbHit(context,mun.usersList[i].userId);
                                                  }
                                                  else{
                                                    CustomAlert().accessDenied(context);
                                                  }

                                                },
                                                onLongPress: (){
                                                  CustomAlert(
                                                      callback: (){

                                                      },
                                                      Cancelcallback: (){
                                                        Navigator.pop(context);
                                                      }
                                                  ).yesOrNoDialog(context, "", "Are you sure want to delete this user ?");
                                                },
                                                child: Container(
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: AppTheme.uploadColor,width: 2)
                                                  ),
                                                  child: Center(
                                                    child: Image.asset("assets/svg/drawer/avatar.png"),
                                                  ),
                                                ),

                                              ),

                                              SizedBox(height: 20,),
                                              Text("${mun.usersList[i].userName}  ",
                                                style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RM',fontSize: 14),
                                              ),
                                              SizedBox(height: 3,),
                                              Text("${mun.usersList[i].userGroupName}  ",
                                                style: TextStyle(color: AppTheme.bgColor,fontFamily: 'RR',fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      )
                                      ).values.toList()
                                  ),
                                )


                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: SizeConfig.height60,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    CancelButton(
                      ontap: (){
                        Navigator.pop(context);
                      },
                    ),
                    Text("Manage Users",
                      style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                    ),

                  ],
                ),
              ),


              Container(

                height: mun.ManageUsersLoader? SizeConfig.screenHeight:0,
                width: mun.ManageUsersLoader? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                  //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

                ),
              ),
            ],
          )
      ),
    );
  }
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ManageUsersAddNew(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}

