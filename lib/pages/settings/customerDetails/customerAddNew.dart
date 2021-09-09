import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/customerNotifier.dart';

import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';

import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/validationErrorText.dart';


class CustomerDetailAddNew extends StatefulWidget {
  bool fromSalePage;
  CustomerDetailAddNew(this.fromSalePage);
  @override
  CustomerDetailAddNewState createState() => CustomerDetailAddNewState();
}

class CustomerDetailAddNewState extends State<CustomerDetailAddNew> with TickerProviderStateMixin {

  GlobalKey <ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();


  ScrollController? scrollController;
  ScrollController? listViewController;

  bool _keyboardVisible = false;
  bool materialCategoryOpen = false;
  bool materialUnitOpen = false;

  bool isListScroll=false;
  bool emailValid=true;
  bool name=false;
  bool phoneNo=false;


  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
   // _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        key: scaffoldkey,
        resizeToAvoidBottomInset: false,
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
                            width: SizeConfig.screenWidth,
                            height: 205,
                            decoration: BoxDecoration(
                              color: AppTheme.yellowColor,
                              /* image: DecorationImage(
                                     image: AssetImage("assets/svg/gridHeader/companyDetailsHeader.jpg",),
                                   fit: BoxFit.cover
                                 )*/

                            ),
                            child: SvgPicture.asset("assets/svg/gridHeader/customerHeader.svg"),

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
                                height: SizeConfig.screenHeight! - 60,
                                width: SizeConfig.screenWidth,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                    color: AppTheme.gridbodyBgColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))
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
                                      AddNewLabelTextField(
                                        labelText: 'Customer Name',
                                        regExp: '[A-Za-z  ]',
                                        textEditingController: qn.customerName,
                                        onEditComplete: (){
                                          node.unfocus();
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        },
                                        onChange: (v){},
                                        ontap: (){
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            //isListScroll=true;
                                            _keyboardVisible=true;
                                          });
                                        },
                                      ),
                                      !name?Container():ValidationErrorText(title: "* Enter Name",),

                                      AddNewLabelTextField(
                                        labelText: 'Address',
                                        textEditingController: qn.customerAddress,
                                        maxlines: null,
                                        onEditComplete: (){
                                          node.unfocus();
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        },
                                        onChange: (v){},
                                        ontap: (){
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            _keyboardVisible=true;
                                           // isListScroll=true;
                                          });
                                        },
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'City',
                                        regExp: '[A-Za-z  ]',
                                        textEditingController: qn.customerCity,
                                        onEditComplete: (){
                                          node.unfocus();
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        },
                                        onChange: (v){},
                                        ontap: (){
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            _keyboardVisible=true;
                                            //isListScroll=true;
                                          });
                                        },
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'State',
                                        regExp: '[A-Za-z  ]',
                                        textEditingController: qn.customerState,
                                        onEditComplete: (){
                                          node.unfocus();
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        },
                                        onChange: (v){},
                                        ontap: (){
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            _keyboardVisible=true;
                                            //isListScroll=true;
                                          });
                                        },
                                        scrollPadding: 100,
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'Country',
                                        regExp: '[A-Za-z  ]',
                                        textEditingController: qn.customerCountry,
                                        scrollPadding: 400,
                                        onEditComplete: (){
                                          node.unfocus();
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        },
                                        onChange: (v){},
                                        ontap: (){
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                           // isListScroll=true;
                                            _keyboardVisible=true;
                                          });
                                        },
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'ZipCode',
                                        regExp: '[0-9]',
                                        textLength: 6,
                                        textInputType: TextInputType.number,
                                        textEditingController: qn.customerZipcode,
                                        scrollPadding: 400,
                                        onEditComplete: (){
                                          node.unfocus();
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        },
                                        onChange: (v){},
                                        ontap: (){
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            _keyboardVisible=true;
                                            isListScroll=true;
                                          });
                                        },
                                      ),
                                      AddNewLabelTextField(
                                        labelText: 'Contact Number',
                                        regExp: '[0-9]',
                                        textLength: 10,
                                        textInputType: TextInputType.number,
                                        textEditingController: qn.customerContactNumber,
                                        scrollPadding: 400,
                                        onEditComplete: (){
                                          node.unfocus();
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        },
                                        onChange: (v){},
                                        ontap: (){
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            isListScroll=true;
                                            _keyboardVisible=true;
                                          });
                                        },
                                      ),
                                      !phoneNo?Container():ValidationErrorText(title: "* Enter Contact Number",),
                                      AddNewLabelTextField(
                                        labelText: 'EmailId ',
                                        textEditingController: qn.customerEmail,
                                        textInputType: TextInputType.emailAddress,
                                        scrollPadding: 600,
                                        onEditComplete: (){
                                          node.unfocus();
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        },
                                        onChange: (v){},
                                        ontap: (){
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            isListScroll=true;
                                            _keyboardVisible=true;
                                          });
                                        },
                                      ),
                                      emailValid?Container():ValidationErrorText(title: "* Invalid Email Address",),
                                      AddNewLabelTextField(
                                        labelText: 'GST No ',
                                        textEditingController: qn.customerGstNumber,
                                        scrollPadding: 400,
                                        onEditComplete: (){
                                          node.unfocus();
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        },
                                        onChange: (v){},
                                        ontap: (){
                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                          setState(() {
                                            isListScroll=true;
                                            _keyboardVisible=true;
                                          });
                                        },
                                      ),
                                      SizedBox(height: SizeConfig.height20,),


                                      //Credit Customer
                                      Container(
                                        height: SizeConfig.height30,
                                        width: SizeConfig.screenWidth,
                                        padding: EdgeInsets.only(left: SizeConfig.width10!),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                               fillColor: MaterialStateColor.resolveWith((states) => AppTheme.yellowColor),
                                                value: qn.isCreditCustomer,
                                                onChanged: (v){
                                                  setState(() {
                                                    qn.isCreditCustomer=v;
                                                    qn.isAdvanceCustomer=false;
                                                    _keyboardVisible=false;
                                                  });

                                            }),
                                            InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    qn.isCreditCustomer=!qn.isCreditCustomer!;
                                                    _keyboardVisible=false;
                                                  });
                                                },
                                                child: Text("Is Credit Customer", style:  TextStyle(fontFamily: 'RR',fontSize: 16,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),))
                                          ],
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                        height: qn.isCreditCustomer!?160:0,
                                        width: SizeConfig.screenWidth,



                                        child:Column(
                                          children: [
                                            AddNewLabelTextField(
                                              textEditingController: qn.customerCreditLimit,
                                              labelText: "Credit Limit",
                                              textInputType: TextInputType.number,
                                              regExp: decimalReg,
                                              scrollPadding: 400,
                                              ontap: (){
                                                scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                setState(() {
                                                  isListScroll=true;
                                                  _keyboardVisible=true;
                                                });
                                              },
                                              onChange: (v){},
                                              onEditComplete: (){
                                                node.unfocus();
                                                setState(() {
                                                  _keyboardVisible=false;
                                                });
                                              },
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top: 10),
                                              height:40,
                                              width: SizeConfig.screenWidthM40,
                                              decoration: BoxDecoration(
                                                  color: tableColor,
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(3),topRight: Radius.circular(3)),
                                                  border: Border.all(color: AppTheme.addNewTextFieldBorder)

                                              ),
                                              child:Row(
                                                children: [
                                                  Container(
                                                      padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                      width: (SizeConfig.screenWidthM40!*0.5)-2,
                                                      child: Text("Used Amount",style: tableTextStyle,)
                                                  ),

                                                  Container(
                                                      height: 50,
                                                      width: 1,
                                                      color: AppTheme.addNewTextFieldBorder
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                    height: 16,
                                                    alignment: Alignment.centerLeft,
                                                    width: (SizeConfig.screenWidthM40!*0.5)-1,
                                                    child: FittedBox(child: Text("${qn.usedAmount}",

                                                      style:tableTextStyle2,
                                                    ),

                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,),
                                              height:40,
                                              width: SizeConfig.screenWidthM40,
                                              decoration: BoxDecoration(
                                                  color: tableColor,
                                                  border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                    right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom: BorderSide(color: AppTheme.addNewTextFieldBorder),

                                                  )


                                              ),
                                              child:Row(
                                                children: [
                                                  Container(
                                                      padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                      width: (SizeConfig.screenWidthM40!*0.5)-2,
                                                      child: Text("Balance Amount",style: tableTextStyle,)
                                                  ),

                                                  Container(
                                                      height: 50,
                                                      width: 1,
                                                      color: AppTheme.addNewTextFieldBorder
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                    height: 16,
                                                    alignment: Alignment.centerLeft,
                                                    width: (SizeConfig.screenWidthM40!*0.5)-1,
                                                    child: FittedBox(child: Text("${qn.balanceAmount}",

                                                      style:tableTextStyle2,
                                                    ),

                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),


                                      //Advance Customer
                                      Container(
                                        height: SizeConfig.height30,
                                        width: SizeConfig.screenWidth,
                                        padding: EdgeInsets.only(left: SizeConfig.width10!),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                                fillColor: MaterialStateColor.resolveWith((states) => AppTheme.yellowColor),
                                                value: qn.isAdvanceCustomer,
                                                onChanged: (v){
                                                  setState(() {
                                                    qn.isAdvanceCustomer=v;
                                                    qn.isCreditCustomer=false;
                                                    _keyboardVisible=false;
                                                  });

                                                }),
                                            InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    qn.isAdvanceCustomer=!qn.isAdvanceCustomer!;
                                                    _keyboardVisible=false;
                                                  });
                                                },
                                                child: Text("Is Advance Customer", style:  TextStyle(fontFamily: 'RR',fontSize: 16,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),))
                                          ],
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                        height: qn.isAdvanceCustomer!?160:0,
                                        width: SizeConfig.screenWidth,



                                        child:Column(
                                          children: [
                                            AddNewLabelTextField(
                                              textEditingController: qn.customerAdvanceAmount,
                                              labelText: "Advance Amount",
                                              textInputType: TextInputType.number,
                                              regExp: decimalReg,
                                              scrollPadding: 400,
                                              ontap: (){
                                                scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                setState(() {
                                                  isListScroll=true;
                                                  _keyboardVisible=true;
                                                });
                                              },
                                              onChange: (v){},
                                              onEditComplete: (){
                                                node.unfocus();
                                                setState(() {
                                                  _keyboardVisible=false;
                                                });
                                              },
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top: 10),
                                              height:40,
                                              width: SizeConfig.screenWidthM40,
                                              decoration: BoxDecoration(
                                                  color: tableColor,
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(3),topRight: Radius.circular(3)),
                                                  border: Border.all(color: AppTheme.addNewTextFieldBorder)

                                              ),
                                              child:Row(
                                                children: [
                                                  Container(
                                                      padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                      width: (SizeConfig.screenWidthM40!*0.5)-2,
                                                      child: Text("Used Amount",style: tableTextStyle,)
                                                  ),

                                                  Container(
                                                      height: 50,
                                                      width: 1,
                                                      color: AppTheme.addNewTextFieldBorder
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                    height: 16,
                                                    alignment: Alignment.centerLeft,
                                                    width: (SizeConfig.screenWidthM40!*0.5)-1,
                                                    child: FittedBox(child: Text("${qn.usedAdvanceAmount}",

                                                      style:tableTextStyle2,
                                                    ),

                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,),
                                              height:40,
                                              width: SizeConfig.screenWidthM40,
                                              decoration: BoxDecoration(
                                                  color: tableColor,
                                                  border: Border(left: BorderSide(color: AppTheme.addNewTextFieldBorder),
                                                    right: BorderSide(color: AppTheme.addNewTextFieldBorder),bottom: BorderSide(color: AppTheme.addNewTextFieldBorder),

                                                  )


                                              ),
                                              child:Row(
                                                children: [
                                                  Container(
                                                      padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                        width: (SizeConfig.screenWidthM40!*0.5)-2,
                                                      child: Text("Balance Amount",style: tableTextStyle,)
                                                  ),

                                                  Container(
                                                      height: 50,
                                                      width: 1,
                                                      color: AppTheme.addNewTextFieldBorder
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: SizeConfig.width10!),
                                                    height: 16,
                                                    alignment: Alignment.centerLeft,
                                                    width: (SizeConfig.screenWidthM40!*0.5)-1,
                                                    child: FittedBox(child: Text("${qn.balanceAdvanceAmount}",

                                                      style:tableTextStyle2,
                                                    ),

                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),


                                      SizedBox(height: 20,),
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
                                        child: Text("Upload Customer Logo",
                                          style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.gridTextColor),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(

                                        margin: EdgeInsets.only(left: SizeConfig.width90!,right:  SizeConfig.width90!,),
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

                                      SizedBox(height: _keyboardVisible? SizeConfig.screenHeight!*0.5:200,)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    //HEADER
                    Container(
                      height: SizeConfig.height60,
                      width: SizeConfig.screenWidth,
                      child: Row(
                        children: [
                          CancelButton(
                            ontap: (){
                              Navigator.pop(context);
                              qn.clearCustomerDetails();
                            },
                          ),

                          Text("Customer Detail",
                            style: TextStyle(fontFamily: 'RR',
                                color: Colors.black,
                                fontSize: 16),
                          ),
                          Text(qn.isCustomerEdit ? " / Edit" : " / Add New",
                            style: TextStyle(fontFamily: 'RR',
                                color: Colors.black,
                                fontSize: 16),
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
                    //addButton
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: AddButton(
                        ontap: (){
                          node.unfocus();

                          if(qn.customerEmail.text.isNotEmpty){
                            setState(() {
                              emailValid=EmailValidation().validateEmail(qn.customerEmail.text);
                            });
                          }

                          if(qn.customerName.text.isEmpty){setState(() {name=true;});}
                          else{setState(() {name=false;});}

                          if(qn.customerContactNumber.text.isEmpty){setState(() {phoneNo=true;});}
                          else{setState(() {phoneNo=false;});}

                          if(emailValid && !name && !phoneNo){
                            qn.InsertCustomerDbHit(context,widget.fromSalePage);
                          }



                        },
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
  TextStyle tableTextStyle=TextStyle(fontFamily: 'RR',color: AppTheme.bgColor);
  TextStyle tableTextStyle2=TextStyle(fontFamily: 'RR',color: AppTheme.gridTextColor);
  Color tableColor=Colors.white;
}



