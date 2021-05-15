import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/plantDetailsGrid.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/autocompleteText.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/navigationBarIcon.dart';
import 'package:quarry/widgets/validationErrorText.dart';

import '../qLocMaterials.dart';
import '../qLocPAyment.dart';
import 'plantDetailsAddNew.dart';





class QuaryAddNew extends StatefulWidget {
  VoidCallback drawerCallback;
  QuaryAddNew({this.drawerCallback});
  @override
  _QuaryAddNewState createState() => _QuaryAddNewState();
}

class _QuaryAddNewState extends State<QuaryAddNew> with TickerProviderStateMixin{

  bool isEdit=false;

  GlobalKey <ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController;
  ScrollController listViewController;
  double silverBodyTopMargin=0;


  bool _keyboardVisible=false;
  bool isListScroll=false;

  bool emailValid=true;
  bool companyName=false;
  bool address=false;
  bool contactNo=false;
  bool gstNo=false;

  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {
        silverBodyTopMargin=0;
      });


    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
   // _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final node = FocusScope.of(context);

    return Scaffold(
      key: scaffoldkey,
      resizeToAvoidBottomInset: false,
      body: Consumer<QuarryNotifier>(
                 builder: (context,qn,child)=> Stack(
                   children: [


                     Container(
                       height: SizeConfig.screenHeight,
                       width: SizeConfig.screenWidth,
                       child: Column(
                         children: [
                           Container(
                             width: SizeConfig.screenWidth,
                             height: 205,
                             decoration: BoxDecoration(
                               color: AppTheme.yellowColor,
                                /* image: DecorationImage(
                                     image: AssetImage("assets/svg/gridHeader/companyDetailsHeader.jpg",),
                                   fit: BoxFit.cover
                                 )*/

                             ),
                           child: SvgPicture.asset("assets/svg/gridHeader/companyDetailsHeader.svg"),

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
                         child: Column(
                           children: [
                             SizedBox(height: 160,),
                             GestureDetector(
                               onVerticalDragUpdate: (details){

                                 int sensitivity = 5;
                                 if (details.delta.dy > sensitivity) {
                                   scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                                     if(isListScroll){
                                       setState(() {
                                         isListScroll=false;
                                       });
                                     }
                                   });

                                 } else if(details.delta.dy < -sensitivity){
                                   scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

                                     if(!isListScroll){
                                       setState(() {
                                         isListScroll=true;
                                       });
                                     }
                                   });
                                 }
                               },


                               onVerticalDragDown: (v){

                                 if(scrollController.offset==0 && listViewController.offset==0){
                                   scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                 }

                               },
                               child: Container(
                                 height: SizeConfig.screenHeight-60,
                                 width: SizeConfig.screenWidth,
                                 alignment: Alignment.topCenter,
                                 decoration: BoxDecoration(
                                     color: AppTheme.gridbodyBgColor,
                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                 ),
                                 child: NotificationListener<ScrollNotification>(
                                   onNotification: (s){
                                     if(s is ScrollStartNotification){

                                       if(listViewController.offset==0 && isListScroll && scrollController.offset==100 && listViewController.position.userScrollDirection==ScrollDirection.idle){

                                         Timer(Duration(milliseconds: 100), (){
                                           if(listViewController.position.userScrollDirection!=ScrollDirection.reverse){

                                             //if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
                                             if(listViewController.offset==0){

                                               scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value) {
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
                                   },
                                   child: ListView(
                                     controller: listViewController,
                                     scrollDirection: Axis.vertical,
                                     physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),

                                     children: [
                                       SizedBox(height:15,),
                                       AddNewLabelTextField(
                                         ontap: (){
                                           scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                           });
                                         },
                                         labelText: 'Company Name',
                                         isEnabled: isEdit,
                                         regExp: '[A-Za-z  ]',
                                         textEditingController: qn.CD_quarryname,
                                         maxlines: null,
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                             });
                                           });
                                         },
                                       ),
                                       !companyName?Container():ValidationErrorText(title: "* Enter Company Name",),
                                       AddNewLabelTextField(
                                         labelText: 'Address',
                                         isEnabled: isEdit,
                                         maxlines: null,
                                         textInputType: TextInputType.text,
                                         scrollPadding: 200,
                                         textEditingController: qn.CD_address,
                                         ontap: (){
                                           scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
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
                                       !address?Container():ValidationErrorText(title: "* Enter Address",),
                                       AddNewLabelTextField(
                                         labelText: 'City',
                                         isEnabled: isEdit,
                                         regExp: '[A-Za-z  ]',
                                         scrollPadding: 200,
                                         textEditingController: qn.CD_city,
                                         ontap: (){
                                           scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
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
                                         labelText: 'State',
                                         isEnabled: isEdit,
                                         regExp: '[A-Za-z  ]',
                                         scrollPadding: 200,
                                         textEditingController: qn.CD_state,
                                         ontap: (){
                                           scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                             isListScroll=true;
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
                                         labelText: 'ZipCode',
                                         textLength: 6,
                                         regExp: '[0-9]',
                                         isEnabled: isEdit,
                                         textInputType: TextInputType.number,
                                         scrollPadding: 400,
                                         textEditingController: qn.CD_zipcode,
                                         ontap: (){
                                           scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                             isListScroll=true;
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
                                         scrollPadding: 500,
                                         textLength: 10,
                                         labelText: 'Contact Number',
                                         regExp: '[0-9]',
                                         isEnabled: isEdit,
                                         textInputType: TextInputType.number,
                                         textEditingController: qn.CD_contactNo,
                                         ontap: (){
                                           scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                             isListScroll=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                               isListScroll=true;
                                             });
                                           });
                                         },
                                       ),
                                       !contactNo?Container():ValidationErrorText(title: "* Enter Contact Number",),
                                       AddNewLabelTextField(
                                         labelText: 'Email',
                                         isEnabled: isEdit,
                                         textInputType: TextInputType.emailAddress,
                                         textEditingController: qn.CD_email,
                                         scrollPadding: 500,
                                         ontap: (){
                                           scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                             isListScroll=true;
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
                                       emailValid?Container():ValidationErrorText(title: "* Invalid Email Address",),
                                       AddNewLabelTextField(
                                         labelText: 'Website',
                                         isEnabled: isEdit,
                                         textEditingController: qn.CD_website,
                                         scrollPadding: 500,
                                         ontap: (){
                                           scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                             isListScroll=true;
                                           });
                                         },
                                         onEditComplete: (){
                                           node.unfocus();
                                           Timer(Duration(milliseconds: 50), (){
                                             setState(() {
                                               _keyboardVisible=false;
                                               isListScroll=true;
                                             });
                                           });
                                         },
                                       ),

                                       AddNewLabelTextField(
                                         labelText: 'GST No',
                                         isEnabled: isEdit,
                                         regExp: '[A-Za-z0-9]',
                                         scrollPadding: 500,
                                         textEditingController: qn.CD_gstno,
                                         ontap: (){
                                           scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
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
                                       !gstNo?Container():ValidationErrorText(title: "* Enter GST Number",),
                                       AddNewLabelTextField(
                                         labelText: 'PAN No',
                                         isEnabled: isEdit,
                                         scrollPadding: 500,
                                         textEditingController: qn.CD_Panno,
                                         ontap: (){
                                           scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
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
                                         labelText: 'CIN No',
                                         isEnabled: isEdit,
                                         regExp: '[A-Za-z0-9]',
                                         scrollPadding: 500,
                                         textEditingController: qn.CD_Cinno,
                                         ontap: (){
                                           scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
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

                                       SizedBox(height: SizeConfig.height20,),

                                       Container(
                                         height: SizeConfig.height70,
                                         width: SizeConfig.height70,
                                         decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                             border: Border.all(color: AppTheme.uploadColor,width: 2)
                                         ),
                                         child: Center(
                                           child: Icon(Icons.upload_rounded,color: AppTheme.yellowColor,),
                                         ),
                                       ),
                                       SizedBox(height: 20,),
                                       Align(
                                         alignment: Alignment.center,
                                         child: Text("Upload Your Company Logo",
                                           style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.gridTextColor),
                                         ),
                                       ),
                                       SizedBox(height: 10,),
                                       Container(

                                         margin: EdgeInsets.only(left: SizeConfig.width90,right:  SizeConfig.width90,),
                                         height:45,
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
                                             child: Text("Choose File",style: TextStyle(color:AppTheme.bgColor,fontSize:16,fontFamily: 'RM'),
                                             )
                                         ),


                                       ),

                                       SizedBox(height: 70),


                                       Container(
                                         height: SizeConfig.height70,
                                         width: SizeConfig.height70,
                                         decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                             border: Border.all(color: AppTheme.uploadColor,width: 2)
                                         ),
                                         child: Center(
                                           child: SvgPicture.asset("assets/svg/Planticon.svg",height: 40,width: 40,),
                                         ),
                                       ),
                                       SizedBox(height: SizeConfig.height20,),
                                       Align(
                                         alignment: Alignment.center,
                                         child: Text("Do you want to add Plant?",
                                           style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.gridTextColor),
                                         ),
                                       ),
                                       SizedBox(height: SizeConfig.height10,),

                                       GestureDetector(
                                         onTap: (){
                                           if(qn.plantGridList.isEmpty){
                                             Navigator.push(context, _createRoutePlantDetailsAddNew());
                                           }
                                           else{
                                             Navigator.push(context, _createRoute());
                                           }
                                         },
                                         child: Container(
                                           margin: EdgeInsets.only(left: SizeConfig.width90,right:  SizeConfig.width90,),
                                           height:45,
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
                                               child: Text(qn.plantGridList.isEmpty?"+ Add Plant":"Plants",
                                                 style: TextStyle(color:AppTheme.bgColor,fontSize:16,fontFamily: 'RM'),
                                               )
                                           ),


                                         ),
                                       ),


                                       SizedBox(height: SizeConfig.height100,)
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
                       height: 60,
                       width: SizeConfig.screenWidth,
                       child: Row(
                         children: [
                           GestureDetector(
                             onTap: widget.drawerCallback,
                             child: NavBarIcon(),
                           ),

                           Text("Company Detail",
                             style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                           ),
                           Spacer(),

                         ],
                       ),
                     ),


                     //bottomNav
                     Positioned(
                       bottom: 0,
                       child: Container(
                         width: SizeConfig.screenWidth,
                         height:_keyboardVisible?0: 70,

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
                               margin:EdgeInsets.only(top: 0),
                               child: CustomPaint(
                                 size: Size( SizeConfig.screenWidth, 65),
                                 painter: RPSCustomPainter3(),
                               ),
                             ),

                             Container(
                               width:  SizeConfig.screenWidth,
                               height: 80,

                               child: Stack(

                                 children: [



                                   AnimatedPositioned(
                                     bottom:isEdit?20:-60,
                                     duration: Duration(milliseconds: 300,),
                                     curve: Curves.bounceInOut,
                                     child: Container(

                                         width: SizeConfig.screenWidth,
                                         child: Row(
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           children: [
                                             SizedBox(width: SizeConfig.width20,),
                                             GestureDetector(
                                               onTap: (){

                                                 setState(() {
                                                   emailValid=EmailValidation().validateEmail(qn.CD_email.text);
                                                 });

                                                 if(qn.CD_quarryname.text.isEmpty){setState(() {companyName=true;});}
                                                 else{setState(() {companyName=false;});}

                                                 if(qn.CD_address.text.isEmpty){setState(() {address=true;});}
                                                 else{setState(() {address=false;});}

                                                 if(qn.CD_contactNo.text.isEmpty){setState(() {contactNo=true;});}
                                                 else{setState(() {contactNo=false;});}

                                                 if(qn.CD_gstno.text.isEmpty){setState(() {gstNo=true;});}
                                                 else{setState(() {gstNo=false;});}

                                                 if(emailValid && !companyName && !address && !contactNo && !gstNo){
                                                   node.unfocus();

                                                   setState(() {
                                                     isEdit=false;
                                                   });
                                                   qn.UpdateQuarryDetailDbhit(context);

                                                 }

                                               },
                                               child: Container(
                                                 width: 90,
                                                 decoration: BoxDecoration(
                                                     boxShadow: [
                                                       BoxShadow(
                                                         color: AppTheme.yellowColor.withOpacity(0.7),
                                                         spreadRadius: -3,
                                                         blurRadius: 15,
                                                         offset: Offset(0, 7), // changes position of shadow
                                                       )
                                                     ]
                                                 ),
                                                 child:FittedBox(
                                                   child: Row(
                                                     children: [
                                                       SvgPicture.asset("assets/svg/tick.svg",height: 20,width: 20,color: AppTheme.yellowColor,),
                                                       SizedBox(width: SizeConfig.width10,),
                                                       Text("Update",style: TextStyle(fontSize: 20,fontFamily: 'RR',color:Color(0xFFFF9D10)),),


                                                     ],
                                                   ),
                                                 ),
                                               ),
                                             ),
                                             Spacer(),
                                             GestureDetector(
                                               onTap: (){
                                                 setState(() {
                                                   isEdit=false;
                                                    emailValid=true;
                                                    companyName=false;
                                                    address=false;
                                                    contactNo=false;
                                                    gstNo=false;
                                                 });
                                                 qn.GetQuarryDetailDbhit(context);
                                               },
                                               child: Container(
                                                 width: 90,
                                                 decoration: BoxDecoration(
                                                     boxShadow: [
                                                       BoxShadow(
                                                         color: AppTheme.red.withOpacity(0.5),
                                                         spreadRadius: -3,
                                                         blurRadius: 25,
                                                         offset: Offset(0, 7), // changes position of shadow
                                                       )
                                                     ]
                                                 ),
                                                 child:FittedBox(
                                                   child: Row(
                                                     children: [
                                                       Text("Cancel",style: TextStyle(fontSize: 18,fontFamily: 'RR',color:Colors.red),),
                                                       SizedBox(width: SizeConfig.width10,),
                                                       SvgPicture.asset("assets/svg/delete.svg",height: 20,width: 20,color: AppTheme.red,),




                                                     ],
                                                   ),
                                                 ),
                                               ),
                                             ),
                                             SizedBox(width: SizeConfig.width10,),
                                           ],
                                         )
                                     ),
                                   )

                                 ],
                               ),
                             )
                           ],
                         ),
                       ),
                     ),
                     //addButton
                     Align(
                       alignment: Alignment.bottomCenter,
                       child: GestureDetector(
                         onTap: (){
                             setState(() {
                               isEdit=true;
                             });
                         },
                         child: Container(

                           height:_keyboardVisible?0: 65,
                           width: 65,
                           margin: EdgeInsets.only(bottom: 20),
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
                             ],
                           ),
                           child: Center(
                             child:_keyboardVisible?Container(): SvgPicture.asset("assets/svg/edit.svg",color: AppTheme.bgColor,height: 30,width: 30,),
                           ),
                         ),
                       ),
                     ),



                     Container(

                       height: qn.insertCompanyLoader? SizeConfig.screenHeight:0,
                       width: qn.insertCompanyLoader? SizeConfig.screenWidth:0,
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
      pageBuilder: (context, animation, secondaryAnimation) => PlantDetailsGrid(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRoutePlantDetailsAddNew() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PlantDetailsAddNew(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}

