import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/autocompleteText.dart';
import 'package:quarry/widgets/customTextField.dart';

import '../qLocMaterials.dart';
import '../qLocPAyment.dart';





class QuaryAddNew extends StatefulWidget {
  VoidCallback drawerCallback;
  QuaryAddNew({this.drawerCallback});
  @override
  _QuaryAddNewState createState() => _QuaryAddNewState();
}

class _QuaryAddNewState extends State<QuaryAddNew> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;
  double silverBodyTopMargin=0;


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
      // scrollController.addListener(() {
      //   print("SCROLL--${scrollController.offset}");
      // });

      listViewController.addListener(() {
         print("List SCROLL--${listViewController.offset}");
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
    SizeConfig().init(context);
    return Consumer<QuarryNotifier>(
               builder: (context,qn,child)=> Stack(
                 children: [
                  /*NestedScrollView(
                      controller: silverController,
                      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            elevation: 0,
                            toolbarHeight: 60,
                          //  backgroundColor: Color(0XFF353535),
                            backgroundColor: AppTheme.yellowColor,
                            leading: Container(),
                            actions: [
                              Container(
                                height:80,
                                width: SizeConfig.screenWidth,
                                padding: EdgeInsets.only(top: 5),
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
                              )
                            ],

                            expandedHeight: 200.0,
                            floating: false,
                            pinned: true,

                            flexibleSpace: FlexibleSpaceBar(
                                background: Container(
                                  color: AppTheme.yellowColor,
                                  width: SizeConfig.screenWidth,

                                  child: Center(
                                    child: Image.asset(
                                      "assets/images/saleFormheader.jpg",height: 200,width: SizeConfig.screenWidth,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )),

                          ),

                        ];
                      },
                      body: Container(
                        width: double.maxFinite,

                        margin: EdgeInsets.only(top: silverBodyTopMargin),
                        decoration: BoxDecoration(
                            color: Colors.red,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                        ),
                      )
                  ),*/


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
                       controller: scrollController,
                       child: Column(
                         children: [
                           SizedBox(height: 160,),
                           Container(
                             height: SizeConfig.screenHeight-60,
                             width: SizeConfig.screenWidth,

                             decoration: BoxDecoration(
                                 color: Colors.white,
                               borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                             ),
                             child: ListView(
                               controller: listViewController,
                               scrollDirection: Axis.vertical,

                               children: [
                                 AddNewLabelTextField(
                                   labelText: 'Quarry Name',
                                   isEnabled: isEdit,
                                   textEditingController: qn.CD_quarryname,
                                   // maxLines: 2,


                                 ),
                                 AddNewLabelTextField(
                                   labelText: 'Contact Number',
                                   isEnabled: isEdit,
                                   textInputType: TextInputType.number,
                                   textEditingController: qn.CD_contactNo,
                                 ),
                                 AddNewLabelTextField(
                                   labelText: 'Email',
                                   isEnabled: isEdit,
                                   textInputType: TextInputType.emailAddress,
                                   textEditingController: qn.CD_email,
                                   scrollPadding: 100,
                                 ),
                                 AddNewLabelTextField(
                                   labelText: 'Address',
                                   isEnabled: isEdit,
                                   // maxLines: 3,
                                   textInputType: TextInputType.text,
                                   scrollPadding: 200,
                                   textEditingController: qn.CD_address,
                                 ),

                                 AddNewLabelTextField(
                                   labelText: 'City',
                                   isEnabled: isEdit,
                                   scrollPadding: 200,
                                   textEditingController: qn.CD_city,
                                 ),
                                 AddNewLabelTextField(
                                   labelText: 'State',
                                   isEnabled: isEdit,
                                   scrollPadding: 200,
                                   textEditingController: qn.CD_state,
                                 ),
                                 AddNewLabelTextField(
                                   labelText: 'ZipCode',
                                   isEnabled: isEdit,
                                   textInputType: TextInputType.number,
                                   scrollPadding: 200,
                                   textEditingController: qn.CD_zipcode,
                                 ),
                                 AddNewLabelTextField(
                                   labelText: 'GST No',
                                   isEnabled: isEdit,
                                   scrollPadding: 200,
                                   textEditingController: qn.CD_gstno,
                                 ),
                                 SizedBox(height: SizeConfig.height100,)
                               ],
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
                       height: SizeConfig.height70,
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
          );
  }
}

