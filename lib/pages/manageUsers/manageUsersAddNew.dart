import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/manageUsersModel/manageUsersPlantModel.dart';
import 'package:quarry/notifier/machineNotifier.dart';
import 'package:quarry/notifier/manageUsersNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/pages/manageUsers/manageUsersGrid.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/sidePopUp/sidePopupWithoutModelList.dart';
import 'package:quarry/widgets/validationErrorText.dart';

import '../../utils/widgetUtils.dart';
import '../../widgets/logoPicker.dart';

class ManageUsersAddNew extends StatefulWidget {
  VoidCallback? drawerCallback;
  ManageUsersAddNew({this.drawerCallback});
  @override
  ManageUsersAddNewState createState() => ManageUsersAddNewState();
}

class ManageUsersAddNewState extends State<ManageUsersAddNew> {
  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();


  ScrollController? scrollController;
  ScrollController? listViewController;
  bool _keyboardVisible = false;
  bool salutationOpen=false;
  bool passwordvisible=true;
  bool userGroupOpen=false;
  bool plantAccessOpen=false;


  bool emailValid=true;
  bool firstName=false;
  bool password=false;
  bool userGroup=false;
  bool plantAccess=false;

  @override
  void initState() {

    WidgetsBinding.instance!.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


      listViewController!.addListener(() {

        if(listViewController!.offset>20){

          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);


        }
        else if(listViewController!.offset==0){
          scrollController!.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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
        resizeToAvoidBottomInset: false,
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
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/saleFormheader.jpg",),
                                fit: BoxFit.cover
                            )

                        ),
                      ),
                    ]
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
                            SizedBox(height: 170,),
                            Container(
                              height: SizeConfig.screenHeight!-60,
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
                                    scrollController!.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                                  } else if(details.delta.dy < -sensitivity){
                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  }
                                },
                                child: Container(
                                  //height:_keyboardVisible?SizeConfig.screenHeight*0.5 :SizeConfig.screenHeight-100,
                                  height:SizeConfig.screenHeight!-100,
                                  width: SizeConfig.screenWidth,

                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                  ),
                                  child: ListView(
                                    controller: listViewController,
                                    scrollDirection: Axis.vertical,
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
                                            margin: EdgeInsets.only(right: SizeConfig.width20!,top: 10,bottom: 10),
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppTheme.yellowColor
                                            ),
                                            child: Center(
                                              child:  mun.isEdit?Icon(Icons.clear,color: AppTheme.bgColor,):
                                              SvgPicture.asset("assets/svg/edit.svg",width: 20,height: 20,),
                                            ),
                                          ),
                                        ),
                                      ):Container(
                                       margin: EdgeInsets.only(right: SizeConfig.width20!,top: 10,bottom: 10),
                                       height: 40,
                                       width: 40,
                                     ),


                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                        height: salutationOpen? 120:50,
                                        width: SizeConfig.screenWidth,
                                        alignment: Alignment.topCenter,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Container(

                                                margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!),
                                                padding: EdgeInsets.only(left:SizeConfig.width60!,),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                  color: mun.isEdit?Colors.white: Color(0xFFe8e8e8),
                                                ),
                                                width: SizeConfig.screenWidth,
                                                height: 50,
                                                alignment: Alignment.topCenter,
                                                child:  TextFormField(
                                                  controller: mun.firstName,
                                                  enabled: mun.isEdit,
                                                  onTap: (){
                                                    scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                    setState(() {
                                                      _keyboardVisible=true;
                                                    });

                                                  },

                                                  style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                                  decoration: InputDecoration(
                                                    fillColor:mun.isEdit?Colors.white: Color(0xFFe8e8e8),
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
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.allow(RegExp('[A-Za-z ]')),
                                                  ],
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
                                                height:salutationOpen? 120:30,
                                                width: 60,
                                                duration: Duration(milliseconds: 300),
                                                curve: Curves.easeIn,
                                                margin: EdgeInsets.only(left: SizeConfig.width30!),
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
                                                    InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                            salutationOpen=false;
                                                            mun.selectedSalutation="Mx";
                                                          });
                                                        },
                                                        child: Text("Mx",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.bgColor),)
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
                                      !firstName?Container():ValidationErrorText(title: "* Enter First Name",),
                                      AddNewLabelTextField(
                                        labelText: 'Last Name',
                                        isEnabled: mun.isEdit,
                                        regExp: '[A-Za-z ]',
                                        textEditingController: mun.lastName,
                                        ontap: (){
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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
                                        regExp: '[0-9]',
                                        textLength: 10,
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
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            _keyboardVisible=true;
                                          });

                                        },
                                      ),
                                      emailValid?Container():ValidationErrorText(title: "* Invalid Email Address",),
                                      AddNewLabelTextField(
                                        labelText: 'Password',
                                        isEnabled: mun.isEdit,
                                        textEditingController: mun.password,
                                        scrollPadding: 400,
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
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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
                                      !password?Container():ValidationErrorText(title: "* Enter Password",),

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
                                        child: SidePopUpParent(
                                          text:mun.userGroupName==null? "Select User Group":mun.userGroupName,
                                          textColor:mun.userGroupName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                          iconColor:mun.userGroupName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                          bgColor:mun.userGroupName==null? AppTheme.disableColor:mun.isEdit?Colors.white:AppTheme.disableColor,

                                        ),
                                      ),
                                      !userGroup?Container():ValidationErrorText(title: "* Select User Group",),
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
                                        child: SidePopUpParent(
                                          text:mun.plantMappingList.isEmpty? "Select Plant Access":mun.plantMappingList.length.toString(),
                                          textColor:mun.plantMappingList.isEmpty? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                          iconColor:mun.plantMappingList.isEmpty? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                          bgColor:mun.plantMappingList.isEmpty? AppTheme.disableColor:mun.isEdit?Colors.white:AppTheme.disableColor,

                                        ),
                                      ),
                                      !plantAccess?Container():ValidationErrorText(title: "* Select Plant Access",),
                                      




                                      SizedBox(height: _keyboardVisible?SizeConfig.screenHeight!*0.5: SizeConfig.height150,),
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
                            height: 120,
                            width: 120,
                            margin: EdgeInsets.only(top: 100),

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
                            child: Stack(
                              children: [
                                ProfileAvatar(
                                  imageUrl: mun.userLogoUrl,
                                  imageFile: mun.logoFile,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: (){
                                      if(mun.isEdit){
                                        getImage(
                                                (file){
                                              setState(() {
                                                mun.logoFile=file;
                                                mun.userLogoUrl="";
                                              });
                                            }
                                        );
                                      }

                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.yellowColor,
                                      ),
                                      child: Icon(Icons.camera_alt),
                                    ),
                                  ),
                                ),
                              ],
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
                      CancelButton(
                        ontap: (){
                          mun.clearForm();
                          Navigator.pop(context);
                        },
                      ),

                      Text("Add New Users",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                      ),
                      /* Text(qn.isMachineEdit?" / Edit":" / Add New",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                      ),*/


                    ],
                  ),
                ),

                //bottomNav
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    // height:_keyboardVisible?0:  70,
                    height: 65,

                    decoration: BoxDecoration(
                        color: AppTheme.gridbodyBgColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.gridbodyBgColor,
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: Offset(0, -20), // changes position of shadow
                          )
                        ]
                    ),
                    child: Stack(

                      children: [
                        Container(
                          decoration: BoxDecoration(

                          ),
                          margin:EdgeInsets.only(top: 0),
                          child: CustomPaint(
                            size: Size( SizeConfig.screenWidth!, 65),
                            painter: RPSCustomPainter3(),
                          ),
                        ),

                        Container(
                          width:  SizeConfig.screenWidth,
                          height: 80,
                          child: Stack(

                            children: [


                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //Add Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AddButton(
                    ontap: (){


                      setState(() {
                        emailValid=EmailValidation().validateEmail(mun.email.text);
                      });

                      if(mun.firstName.text.isEmpty){setState(() {firstName=true;});}
                      else{setState(() {firstName=false;});}

                      if(mun.password.text.isEmpty){setState(() {password=true;});}
                      else{setState(() {password=false;});}

                      if(mun.userGroupName==null){setState(() {userGroup=true;});}
                      else{setState(() {userGroup=false;});}


                     /* if(mun.plantMappingList.isEmpty){setState(() {plantAccess=true;});}
                      else{setState(() {plantAccess=false;});}*/

                      if(emailValid && !firstName && !password && !userGroup && !plantAccess){
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
                      }




                    },
                  )
                ),

                /*AnimatedPositioned(
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
                ),*/

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
                PopUpStatic2(
                  title: "Select User Group",
                  isOpen: userGroupOpen,
                  dataList: mun.userGroupList,
                  propertyKeyName:"UserGroupName",
                  propertyKeyId: "UserGroupId",
                  selectedId: mun.userGroupId,
                  itemOnTap: (index){
                    setState(() {
                      mun.userGroupId=mun.userGroupList![index]['UserGroupId'];
                      mun.userGroupName=mun.userGroupList![index]['UserGroupName'];

                      userGroupOpen=false;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      userGroupOpen=false;
                    });
                  },
                ),

                ///////////////////////////////////////   PLANT LIST ////////////////////////////////
                Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                    ),
                    clipBehavior: Clip.antiAlias,
                    padding: EdgeInsets.only(top: 20,bottom: 20,),
                    margin: EdgeInsets.only(left: SizeConfig.width25!,right: SizeConfig.width25!),
                    transform: Matrix4.translationValues(plantAccessOpen?0:SizeConfig.screenWidth!, 0, 0),
                    child: Stack(
                      children: [

                        Container(

                          /// height: SizeConfig.screenHeight*0.63,
                          height: (mun.plantList.length*60.0)+150,
                          constraints: BoxConstraints(
                              minHeight: 60,
                              maxHeight: SizeConfig.screenHeight!*0.63
                          ),
                          width: SizeConfig.screenWidth,
                          margin: EdgeInsets.only(left: SizeConfig.width16!,right: SizeConfig.width16!,top: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 5,left: 5),
                                margin: EdgeInsets.only(top: 50),
                                height:mun.plantList.length*60.0,
                                constraints: BoxConstraints(
                                    minHeight: 60,
                                    maxHeight: SizeConfig.screenHeight!*0.55-70
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                width: SizeConfig.screenWidth!-SizeConfig.width60!,

                                child: ListView.builder(
                                    itemCount: mun.plantList.length,
                                    physics: BouncingScrollPhysics(),

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
                                          margin: EdgeInsets.only(left: SizeConfig.width40!,right:  SizeConfig.width40!,top: 20),
                                          padding: EdgeInsets.only(left:5,right:5),

                                          height: 40,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                              color: mun.plantMappingList.any((element) => element.plantId==mun.plantList[index].plantId)?AppTheme.bgColor:Colors.white
                                          ),
                                          child: Center(
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text("${mun.plantList[index].plantName}",style: TextStyle(fontFamily: 'RR',fontSize: 14,
                                                  color:mun.plantMappingList.any((element) => element.plantId==mun.plantList[index].plantId)?Colors.white:AppTheme.bgColor

                                              ),),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),

                              Container(
                                height: 50,
                                width: SizeConfig.screenWidth,
                                //  margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20),
                                decoration: BoxDecoration(
                                    color: AppTheme.yellowColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.gridbodyBgColor,
                                        spreadRadius: 2,
                                        blurRadius: 15,
                                        offset: Offset(0, 20), // changes position of shadow
                                      )
                                    ]
                                ),
                                child: Center(
                                  child: Text('Select Plant Access',style: TextStyle(fontFamily: 'RM',fontSize: 16,color: AppTheme.bgColor),),
                                ),
                              ),

                              Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      plantAccessOpen=false;
                                    });
                                  },
                                  child: Container(
                                    width:120,
                                    height:50,
                                    margin: EdgeInsets.only(bottom: 20),
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
                              ),



                            ],
                          ),

                        ),
                        Positioned(
                          right: 8,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                plantAccessOpen=false;
                              });

                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.bgColor
                              ),
                              child: Center(
                                child: Icon(Icons.clear,color: AppTheme.yellowColor,size: 18,),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),


              ],
            )
        )

    );
  }
}
