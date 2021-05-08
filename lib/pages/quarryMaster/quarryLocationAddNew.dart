import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/plantDetailsGrid.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/autocompleteText.dart';
import 'package:quarry/widgets/customTextField.dart';

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


  bool isListScroll=false;

  bool _keyboardVisible = false;

  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {
        silverBodyTopMargin=0;
      });
    /*  silverController.addListener(() {
        if(silverController.offset>100){
          setState(() {
            silverBodyTopMargin=60-(-(silverController.offset-200));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController.offset<130){
          setState(() {
            silverBodyTopMargin=0;
          });
        }
      });*/
/*
      scrollController.addListener(() {

        if(scrollController.offset==100){
          setState(() {
            isListScroll=true;
          });
        }
        else{
          if(isListScroll){
            setState(() {
              isListScroll=false;
            });
          }

        }
*/
/*        print("isListScroll$isListScroll");*//*

      });

      listViewController.addListener(() {
         // print("List SCROLL--${listViewController.offset}");
 */
/*       if(listViewController.offset>20){

            scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);


        }*//*

        //else
          if(listViewController.offset==0){
          scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });
*/

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
      body: Consumer<QuarryNotifier>(
                 builder: (context,qn,child)=> Stack(
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
                           /*  child:
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                     IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                                     SizedBox(width: SizeConfig.width5,),
                                     Text("Company Detail",
                                       style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                                     ),
                                     Spacer(),

                                   ],
                                 ),
                                 Spacer(),
                                 // Image.asset("assets/images/saleFormheader.jpg",height: 100,),
                                 // Container(
                                 //   height: SizeConfig.height50,
                                 //   color: Color(0xFF753F03),
                                 //
                                 // ) // Container(
                                 //   height: SizeConfig.height50,
                                 //   color: Color(0xFF753F03),
                                 //
                                 // )
                               ],
                             ),*/
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
                                 //  print("DFSfddsf");
                                 int sensitivity = 5;

                                 if (details.delta.dy > sensitivity) {
                                   scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){
                                     if(isListScroll){
                                       // print("ISCROLLG");
                                       setState(() {
                                         isListScroll=false;
                                       });
                                     }
                                   });

                                 } else if(details.delta.dy < -sensitivity){
                                   scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((value){

                                     if(!isListScroll){
                                       //  print("THENN");
                                       setState(() {
                                         isListScroll=true;
                                       });
                                     }
                                     /*Timer(Duration(milliseconds: 100), (){

                               });*/

                                   });
                                 }
                               },


                              /* onVerticalDragDown: (v){

                                   if(scrollController.offset==0 && listViewController.offset==0){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                     }

                               },*/
                               child: Container(
                                 height: SizeConfig.screenHeight-60,
                                 width: SizeConfig.screenWidth,
                                 alignment: Alignment.topCenter,
                                 decoration: BoxDecoration(
                                     color: Colors.white,
                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                 ),
                                 child: NotificationListener<ScrollNotification>(
                                   onNotification: (s){
                                     if(s is ScrollStartNotification){
                                       if(listViewController.offset==0 && isListScroll && scrollController.offset==100 && listViewController.position.userScrollDirection==ScrollDirection.idle){

                                         Timer(Duration(milliseconds: 100), (){
                                           if(listViewController.position.userScrollDirection!=ScrollDirection.reverse){
                                             if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
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
                                       AddNewLabelTextField(
                                         ontap: (){
                                           scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                           setState(() {
                                             _keyboardVisible=true;
                                           });
                                         },
                                         labelText: 'Company Name',
                                         isEnabled: isEdit,
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

                                         // maxLines: 2,


                                       ),
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
                                       AddNewLabelTextField(
                                         labelText: 'City',
                                         isEnabled: isEdit,
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
                                         scrollPadding: 200,
                                         textEditingController: qn.CD_state,
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
                                         labelText: 'ZipCode',
                                         isEnabled: isEdit,
                                         textInputType: TextInputType.number,
                                         scrollPadding: 400,
                                         textEditingController: qn.CD_zipcode,
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
                                         scrollPadding: 500,
                                         labelText: 'Contact Number',
                                         isEnabled: isEdit,
                                         textInputType: TextInputType.number,
                                         textEditingController: qn.CD_contactNo,
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
                                       AddNewLabelTextField(
                                         labelText: 'Website',
                                         isEnabled: isEdit,
                                         textEditingController: qn.CD_website,
                                         scrollPadding: 500,
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
                                         labelText: 'GST No',
                                         isEnabled: isEdit,
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
                                       SizedBox(height: SizeConfig.height20,),

                                       Align(
                                         alignment: Alignment.center,
                                         child: Text("Upload Your Company Logo",
                                         style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.gridTextColor),
                                         ),
                                       ),
                                       SizedBox(height: SizeConfig.height10,),

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
                                           child: Icon(Icons.upload_rounded,color: AppTheme.yellowColor,),
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
                       height: SizeConfig.height60,
                       width: SizeConfig.screenWidth,
                       child: Row(
                         children: [
                           IconButton(icon: Icon(Icons.menu), onPressed: widget.drawerCallback),
                           SizedBox(width: SizeConfig.width5,),
                           Text("Company Detail",
                             style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                           ),
                           Spacer(),

                         ],
                       ),
                     ),

                     Positioned(
                       bottom: 0,
                       child: Container(
                         height: _keyboardVisible ? 0 : SizeConfig.height70,
                         width: SizeConfig.screenWidth,
                         color: AppTheme.grey,
                         child: Center(
                           child: GestureDetector(
                             onTap: (){
                               if(isEdit){
                                 setState(() {
                                   isEdit=false;
                                 });
                                 qn.UpdateQuarryDetailDbhit(context);
                               }
                               else{
                                 setState(() {
                                   isEdit=true;
                                 });
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
                                 child: Text(!isEdit?"Edit":"Update",style: AppTheme.TSWhite20,),
                               ),
                             ),
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

