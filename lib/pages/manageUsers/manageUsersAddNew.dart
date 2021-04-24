import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/notifier/machineNotifier.dart';
import 'package:quarry/notifier/manageUsersNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/pages/manageUsers/manageUsersGrid.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';

class ManageUsersAddNew extends StatefulWidget {
  VoidCallback drawerCallback;
  ManageUsersAddNew({this.drawerCallback});
  @override
  ManageUsersAddNewState createState() => ManageUsersAddNewState();
}

class ManageUsersAddNewState extends State<ManageUsersAddNew> {
  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;
  bool _keyboardVisible = false;
  bool salutationOpen=false;
  bool passwordvisible=true;
  bool userGroupOpen=false;
  bool plantAccessOpen=false;



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
                                  print(details);
                                  int sensitivity = 8;

                                  if (details.delta.dy > sensitivity) {
                                    scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                                  } else if(details.delta.dy < -sensitivity){
                                    print("UP");
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

                                   /* physics: NeverScrollableScrollPhysics(),*/

                                    children: [
                                     mun.isManageUsersEdit? Align(
                                        alignment:Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              mun.isEdit=!mun.isEdit;
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
                                              child:  Icon(mun.isEdit?Icons.clear:Icons.edit_outlined,color: AppTheme.bgColor,),
                                            ),
                                          ),
                                        ),
                                      ):Container(
                                       margin: EdgeInsets.only(right: SizeConfig.width20,top: 10,bottom: 10),
                                       height: 40,
                                       width: 40,
                                     ),
                                     /* Container(
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
                                      ),*/

                                      Container(
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
                                                  color: mun.isEdit?Colors.white: Color(0xFFF2F2F2),
                                                ),
                                                width: SizeConfig.screenWidth,
                                                height: 50,
                                                alignment: Alignment.topCenter,
                                                child:  TextFormField(
                                                  controller: mun.firstName,
                                                  enabled: mun.isEdit,
                                                  onTap: (){
                                                    scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                    setState(() {
                                                      _keyboardVisible=true;
                                                    });

                                                  },

                                                  style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                                  decoration: InputDecoration(
                                                    fillColor:mun.isEdit?Colors.white: Color(0xFFF2F2F2),
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
                                                            mun.selectedSalutation="Mr";
                                                          });
                                                        },
                                                        child: Text("Mr",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                    ),
                                                    InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                            salutationOpen=false;
                                                            mun.selectedSalutation="Mrs";
                                                          });
                                                        },
                                                        child: Text("Mrs",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                    ),
                                                    InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                            salutationOpen=false;
                                                            mun.selectedSalutation="Ms";
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
                                                      child: Text("${mun.selectedSalutation}",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
                                                  ),
                                                ),
                                              ),
                                            )


                                          ],
                                        ),
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'Last Name',
                                        isEnabled: mun.isEdit,
                                        textEditingController: mun.lastName,
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
                                        isEnabled: mun.isEdit,
                                        textEditingController: mun.contactNumber,
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
                                        isEnabled: mun.isEdit,
                                        textEditingController: mun.email,
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
                                        isEnabled: mun.isEdit,
                                        textEditingController: mun.password,
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
                                      GestureDetector(
                                        onTap: (){
                                          node.unfocus();
                                          if(mun.isEdit){
                                            setState(() {
                                              userGroupOpen=true;
                                              _keyboardVisible=false;
                                            });
                                          }


                                        },
                                        child:Container(
                                          margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width10,top:SizeConfig.height20,),
                                          padding: EdgeInsets.only(left:SizeConfig.width5,right:SizeConfig.width5),
                                          height: SizeConfig.height50,
                                          width: SizeConfig.width140,
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                            color: mun.isEdit?Colors.white:AppTheme.editDisableColor
                                          ),
                                          child: Row(
                                            children: [
                                              Text(mun.userGroupName==null? "Select User Group":mun.userGroupName,
                                                style: TextStyle(fontFamily: 'RR',fontSize: 16,
                                                  color: mun.userGroupName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,),
                                              ),
                                              Spacer(),
                                              Container(
                                                  height: SizeConfig.height25,
                                                  width: SizeConfig.height25,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: mun.userGroupName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                                  ),

                                                  child: Center(child: Icon(Icons.arrow_forward_ios_outlined,color:Colors.white ,size: 14,)))
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          node.unfocus();
                                          if(mun.isEdit){
                                            setState(() {
                                              plantAccessOpen=true;
                                              _keyboardVisible=false;
                                            });
                                          }


                                        },
                                        child:Container(
                                          margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width10,top:SizeConfig.height20,),
                                          padding: EdgeInsets.only(left:SizeConfig.width5,right:SizeConfig.width5),
                                          height: SizeConfig.height50,
                                          width: SizeConfig.width140,
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                              color: mun.isEdit?Colors.white:AppTheme.editDisableColor
                                          ),
                                          child: Row(
                                            children: [
                                              Text("Select Plant Access",
                                                style: TextStyle(fontFamily: 'RR',fontSize: 16,
                                                  color:  AppTheme.addNewTextFieldText.withOpacity(0.5),
                                                  //color: mun.userGroupName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                  height: SizeConfig.height25,
                                                  width: SizeConfig.height25,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: mun.plantMappingList.isEmpty? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                                  ),

                                                  child: Center(child: Icon(Icons.arrow_forward_ios_outlined,color:Colors.white ,size: 14,)))
                                            ],
                                          ),
                                        ),
                                      ),


                                      SizedBox(height: SizeConfig.height150,),
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
                      IconButton(icon: Icon(Icons.clear,color: Colors.white,), onPressed: (){
                        mun.clearForm();
                        Navigator.pop(context);
                      }),
                      SizedBox(width: SizeConfig.width5,),
                      Text("Add New Users",
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
                  bottom:mun.isEdit? 0:-80,
                  child: Container(
                    height:_keyboardVisible?0: SizeConfig.height70,
                    width: SizeConfig.screenWidth,
                    color: AppTheme.grey,
                    child: Center(
                      child: GestureDetector(
                        onTap: (){
                          node.unfocus();

                          if(mun.isManageUsersEdit){
                            if(mun.isEdit){
                              setState(() {
                                mun.isEdit=false;
                              });
                              mun.InsertUserDetailDbHit(context);
                            }
                          }
                          else{
                            mun.InsertUserDetailDbHit(context);
                          }




                        },
                        child: Container(
                          height: SizeConfig.height50,
                          width: SizeConfig.width120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(SizeConfig.height25),
                              color: AppTheme.bgColor
                          ),
                          child: Center(
                            child: Text(mun.isManageUsersEdit?"Update":"Save",style: AppTheme.TSWhite20,),
                          ),
                        ),
                      ),
                    ),
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

                Container(

                  height: userGroupOpen || plantAccessOpen? SizeConfig.screenHeight:0,
                  width: userGroupOpen || plantAccessOpen? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),

                ),


                ///////////////////////////////////////   USER  GROUP ////////////////////////////////
                Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.height430,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                      transform: Matrix4.translationValues(userGroupOpen?0:SizeConfig.screenWidth, 0, 0),

                      child:Container(
                        height: SizeConfig.height430,
                        width: SizeConfig.screenWidth,
                        color: Colors.white,
                        //  padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),
                        child:Column (
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: SizeConfig.height50,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(icon: Icon(Icons.cancel), onPressed: (){
                                        setState(() {
                                          userGroupOpen=false;
                                        });
                                      }),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text('Select User Group',style:AppTheme.bgColorTS,)),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.height10,),
                              Container(
                                height: SizeConfig.screenHeight*(300/720),
                                /*color: Colors.red,*/
                                margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                                child: ListView.builder(
                                  itemCount: mun.userGroupList.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          mun.userGroupId=mun.userGroupList[index].userGroupId;
                                          mun.userGroupName=mun.userGroupList[index].userGroupName;

                                          userGroupOpen=false;
                                        });

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            borderRadius:BorderRadius.circular(8),
                                            border: Border.all(color: mun.userGroupId==null? AppTheme.addNewTextFieldBorder:mun.userGroupId==mun.userGroupList[index].userGroupId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                            color: mun.userGroupId==null? Colors.white: mun.userGroupId==mun.userGroupList[index].userGroupId?AppTheme.popUpSelectedColor:Colors.white
                                        ),
                                        width:300,
                                        height:50,
                                        child: Text("${mun.userGroupList[index].userGroupName}",
                                          style: TextStyle(color:mun.userGroupId==null? AppTheme.grey:mun.userGroupId==mun.userGroupList[index].userGroupId?Colors.white:AppTheme.grey,
                                              fontSize:18,fontFamily: 'RR'),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),




                            ]


                        ),
                      )
                  ),
                ),
                ///////////////////////////////////////   PLANT LIST ////////////////////////////////
                Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.height430,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                      transform: Matrix4.translationValues(plantAccessOpen?0:SizeConfig.screenWidth, 0, 0),

                      child:Container(
                        height: SizeConfig.height430,
                        width: SizeConfig.screenWidth,
                        color: Colors.white,
                        //  padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),
                        child:Column (
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: SizeConfig.height50,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(icon: Icon(Icons.cancel), onPressed: (){
                                        print("fdf");
                                        setState(() {
                                          plantAccessOpen=false;
                                        });
                                      }),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text('Select Plant Access',style:AppTheme.bgColorTS,)),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.height10,),
                              Container(
                                height: SizeConfig.screenHeight*(280/720),
                                /*color: Colors.red,*/
                                margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30,bottom: 10),

                                child: RawScrollbar(
                                  radius: Radius.circular(4),
                                  thickness: 4,
                                  isAlwaysShown: true,
                                  thumbColor: AppTheme.addNewTextFieldBorder,
                                  child: ListView.builder(
                                    itemCount: mun.plantList.length,
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: (){
                                          setState(() {

                                            if(mun.plantMappingList.any((element) => element.plantId==mun.plantList[index].plantId)){
                                              mun.plantMappingList.removeWhere((element) => element.plantId==mun.plantList[index].plantId);
                                            }
                                            else{
                                              mun.plantMappingList.add(ManageUserPlantModel(
                                                UserPlantMappingId: null,
                                                UserId: mun.UserId,
                                                plantId: mun.plantList[index].plantId,
                                                plantName: mun.plantList[index].plantName,
                                              )
                                              );
                                            }





                                          });

                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 20,right: 10,),
                                          alignment: Alignment.center,
                                          decoration:BoxDecoration(
                                              borderRadius:BorderRadius.circular(8),
                                              border: Border.all(color: mun.plantMappingList.any((element) => element.plantId==mun.plantList[index].plantId)?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                              color: mun.plantMappingList.any((element) => element.plantId==mun.plantList[index].plantId)?AppTheme.popUpSelectedColor:Colors.white
                                          ),
                                          width:300,
                                          height:50,
                                          child: Text("${mun.plantList[index].plantName}",
                                            style: TextStyle(color:mun.plantMappingList.any((element) => element.plantId==mun.plantList[index].plantId)?Colors.white:AppTheme.grey,
                                                fontSize:18,fontFamily: 'RR'),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    plantAccessOpen=false;
                                  });
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
                                      child: Text("Done",style: AppTheme.bgColorTS,
                                      )
                                  ),
                                ),
                              ),



                            ]


                        ),
                      )
                  ),
                ),

              ],
            )
        )

    );
  }
}
