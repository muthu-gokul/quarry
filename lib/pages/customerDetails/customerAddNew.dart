import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/customerNotifier.dart';
import 'package:quarry/notifier/materialNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/quarryLocationAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';


class CustomerDetailAddNew extends StatefulWidget {
  bool fromSalePage;
  CustomerDetailAddNew(this.fromSalePage);
  @override
  CustomerDetailAddNewState createState() => CustomerDetailAddNewState();
}

class CustomerDetailAddNewState extends State<CustomerDetailAddNew> with TickerProviderStateMixin {

  GlobalKey <ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;

  bool _keyboardVisible = false;
  bool materialCategoryOpen = false;
  bool materialUnitOpen = false;

  bool isListScroll=false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController = new ScrollController();
      listViewController = new ScrollController();
      setState(() {

      });


/*      listViewController.addListener(() {
        if (listViewController.offset > 20) {
          scrollController.animateTo(
              100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
        else if (listViewController.offset == 0) {
          scrollController.animateTo(
              0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });*/
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    SizeConfig().init(context);
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        key: scaffoldkey,
        body: Consumer<CustomerNotifier>(
            builder: (context, qn, child) =>
                Stack(
                  children: [


                    //IMAGE
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
                                    image: AssetImage(
                                      "assets/images/saleFormheader.jpg",),
                                    fit: BoxFit.cover
                                )

                            ),
                          ),


                        ],
                      ),
                    ),




                    //FORM
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
                              child: Container(
                                height: SizeConfig.screenHeight - 60,
                                width: SizeConfig.screenWidth,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))
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
                                        labelText: 'Enter Customer Name',
                                        textEditingController: qn.customerName,
                                        onEditComplete: (){
                                          node.unfocus();
                                        },
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            isListScroll=true;
                                          });
                                        },
                                      ),

                                      AddNewLabelTextField(
                                        labelText: 'Address',
                                        textEditingController: qn.customerAddress,
                                        onEditComplete: (){
                                          node.unfocus();
                                        },
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            isListScroll=true;
                                          });
                                        },
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'City',
                                        textEditingController: qn.customerCity,
                                        onEditComplete: (){
                                          node.unfocus();
                                        },
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            isListScroll=true;
                                          });
                                        },
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'State',
                                        textEditingController: qn.customerState,
                                        onEditComplete: (){
                                          node.unfocus();
                                        },
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            isListScroll=true;
                                          });
                                        },
                                        scrollPadding: 100,
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'Country',
                                        textEditingController: qn.customerCountry,
                                        scrollPadding: 400,
                                        onEditComplete: (){
                                          node.unfocus();
                                        },
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            isListScroll=true;
                                          });
                                        },
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'ZipCode',
                                        textEditingController: qn.customerZipcode,
                                        scrollPadding: 400,
                                        onEditComplete: (){
                                          node.unfocus();
                                        },
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            isListScroll=true;
                                          });
                                        },
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'Enter Contact Number',
                                        textEditingController: qn.customerContactNumber,
                                        scrollPadding: 400,
                                        onEditComplete: (){
                                          node.unfocus();
                                          setState(() {
                                           // _keyboardVisible=false;
                                          });
                                        },
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            isListScroll=true;
                                           // _keyboardVisible=true;
                                          });
                                        },
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'Enter EmailId ',
                                        textEditingController: qn.customerEmail,
                                        scrollPadding: 600,
                                        onEditComplete: (){
                                          node.unfocus();
                                          setState(() {
                                           // _keyboardVisible=false;
                                          });
                                        },
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            isListScroll=true;
                                           // _keyboardVisible=true;
                                          });
                                        },
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'Enter GST No ',
                                        textEditingController: qn.customerGstNumber,
                                        scrollPadding: 400,
                                        onEditComplete: (){
                                          node.unfocus();
                                        },
                                        ontap: (){
                                          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            isListScroll=true;
                                          });
                                        },
                                      ),
                                      SizedBox(height: SizeConfig.height20,),
                                      Container(
                                        height: SizeConfig.height30,
                                        width: SizeConfig.screenWidth,
                                        padding: EdgeInsets.only(left: SizeConfig.width10),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                               fillColor: MaterialStateColor.resolveWith((states) => AppTheme.yellowColor),
                                                value: qn.isCreditCustomer,
                                                onChanged: (v){
                                                  setState(() {
                                                    qn.isCreditCustomer=v;
                                                  });

                                            }),
                                            InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    qn.isCreditCustomer=!qn.isCreditCustomer;
                                                  });
                                                },
                                                child: Text("IsCredit Customer", style:  TextStyle(fontFamily: 'RR',fontSize: 16,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),))
                                          ],
                                        ),
                                      ),


                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                        height: qn.isCreditCustomer?SizeConfig.height50:0,
                                        width: SizeConfig.screenWidth,
                                        margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                                        padding: EdgeInsets.only(left:SizeConfig.width10,),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child:qn.isCreditCustomer? TextField(
                                          scrollPadding: EdgeInsets.only(bottom: 400),
                                          onTap: (){
                                            scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                            setState(() {
                                              isListScroll=true;
                                            });
                                          },
                                          style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                          controller: qn.customerCreditLimit,
                                          decoration: InputDecoration(
                                            hintText: 'Customer Credit Limit',
                                            hintStyle: TextStyle(fontFamily: 'RL',fontSize: 15,color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,

                                          ),
                                          keyboardType: TextInputType.number,
                                        ):Container(),
                                      ),

                                      SizedBox(height:300,),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),


                    //Circle Image


                    //HEADER
                    Container(
                      height: SizeConfig.height60,
                      width: SizeConfig.screenWidth,
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.arrow_back), onPressed: () {
                            Navigator.pop(context);
                            qn.clearCustomerDetails();
                          }),
                          SizedBox(width: SizeConfig.width5,),
                          Text("Customer Detail",
                            style: TextStyle(fontFamily: 'RR',
                                color: Colors.black,
                                fontSize: SizeConfig.width16),
                          ),
                          Text(qn.isCustomerEdit ? " / Edit" : " / Add New",
                            style: TextStyle(fontFamily: 'RR',
                                color: Colors.black,
                                fontSize: SizeConfig.width16),
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
                        height:_keyboardVisible?0:  70,

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
                                size: Size( SizeConfig.screenWidth, 65),
                                painter: RPSCustomPainter3(),
                              ),
                            ),
                            Center(
                              heightFactor: 0.5,
                              child: FloatingActionButton(backgroundColor: AppTheme.yellowColor, child: Icon(Icons.save), elevation: 0.1, onPressed: () {
                                node.unfocus();
                                if(qn.customerName.text.isEmpty){
                                  CustomAlert().commonErrorAlert(context, "Enter Name", "");
                                }
                                else if(qn.customerContactNumber.text.isEmpty){
                                  CustomAlert().commonErrorAlert(context, "Enter Contact Number", "");
                                }
                                else{
                                  qn.InsertCustomerDbHit(context,widget.fromSalePage);
                                }

                              }),
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


                    Container(
                      height: qn.customerLoader ? SizeConfig.screenHeight : 0,
                      width: qn.customerLoader ? SizeConfig.screenWidth : 0,
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.yellowColor),),
                        //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)
                      ),
                    ),
                  ],
                )
        )
    );
  }
}



