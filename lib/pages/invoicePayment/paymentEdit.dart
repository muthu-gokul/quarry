import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/paymentModel/paymentMappingModel.dart';
import 'package:quarry/model/productionDetailsModel/productionMaterialMappingListModel.dart';
import 'package:quarry/notifier/paymentNotifier.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';

class PaymentEditForm extends StatefulWidget {
  @override
  PaymentEditFormState createState() => PaymentEditFormState();
}

class PaymentEditFormState extends State<PaymentEditForm> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;

  bool _keyboardVisible = false;

  bool isListScroll=false;
  bool paymentCategoryOpen=false;


  @override
  void initState() {
    print("init");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController = new ScrollController();
      listViewController = new ScrollController();
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    SizeConfig().init(context);

    return Scaffold(
      key: scaffoldkey,
      body: Consumer<PaymentNotifier>(
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
                        Container(
                          height: SizeConfig.screenHeight - 60,
                          width: SizeConfig.screenWidth,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                          ),
                          child: GestureDetector(
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
                                  /*Timer(Duration(milliseconds: 100), (){

                               });*/

                                });
                              }
                            },
                            child: Container(
                              height: _keyboardVisible ? SizeConfig.screenHeight * 0.5 : SizeConfig.screenHeight - 100,
                              width: SizeConfig.screenWidth,

                              decoration: BoxDecoration(
                                  color: AppTheme.gridbodyBgColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))
                              ),
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (s){
                                  if(s is ScrollStartNotification){
                                    print(listViewController.hasListeners);
                                    print(listViewController.position.userScrollDirection);
                                    //    print(listViewController.position);
                                    if(listViewController.offset==0 && isListScroll && scrollController.offset==100 && listViewController.position.userScrollDirection==ScrollDirection.idle){

                                      Timer(Duration(milliseconds: 100), (){
                                        if(listViewController.position.userScrollDirection!=ScrollDirection.reverse){
                                          if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
                                            //scroll end
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
                                  physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                                  controller: listViewController,
                                  scrollDirection: Axis.vertical,

                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),

                                      width: SizeConfig.screenWidth,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(


                                              padding: EdgeInsets.only(left:SizeConfig.width10,),
                                              width: SizeConfig.screenWidthM40*0.49,
                                              height: 50,
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                  color: AppTheme.editDisableColor
                                              ),
                                              child:  Text("${qn.EditInvoiceNumber}",
                                                style: AppTheme.bgColorTS,
                                              )

                                          ),
                                          Container(


                                              padding: EdgeInsets.only(left:SizeConfig.width10,),
                                              width: SizeConfig.screenWidthM40*0.49,
                                              height: 50,
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                  color: AppTheme.editDisableColor
                                              ),
                                              child:  Text("${DateFormat.yMMMd().add_jm().format(qn.EditInvoiceDate)}",
                                                style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 14),
                                              )

                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(

                                        margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                                        padding: EdgeInsets.only(left:SizeConfig.width10,),
                                        width: SizeConfig.screenWidth,
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                            color: AppTheme.editDisableColor
                                        ),
                                        child:  Text("${qn.EditPartyName}",
                                          style: AppTheme.bgColorTS,
                                        )

                                    ),
                                    Container(

                                        margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                                        padding: EdgeInsets.only(left:SizeConfig.width10,right:SizeConfig.width10,),
                                        width: SizeConfig.screenWidth,
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                            color: AppTheme.editDisableColor
                                        ),
                                        child:  Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${qn.EditGrandTotalAmount}",
                                              style: AppTheme.bgColorTS,
                                            ),
                                            Container(
                                              height: 25,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: Colors.grey.withOpacity(0.5)
                                              ),
                                              child: Center(
                                                child: Text("Rs",style: AppTheme.gridTextColorTS,),
                                              ),
                                            )


                                          ],
                                        )

                                    ),



                                    /////////////  Payment Details List  /////////////////
                                    Container(
                                      //  duration: Duration(milliseconds: 300),
                                      // curve: Curves.easeIn,
                                      height: qn.paymentMappingList.length == 0 ? 0 :
                                     ( qn.paymentMappingList.length * 50.0)+40,
                                    constraints: BoxConstraints(
                                      maxHeight: 300
                                    ),
                                    //  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),

                                      width: SizeConfig.screenWidth,

                                      margin: EdgeInsets.only(
                                        left: SizeConfig.width20,
                                        right: SizeConfig.width20,
                                        top: SizeConfig.height20,),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                        /*  boxShadow: [
                                            qn.productionMaterialMappingList.length == 0 ? BoxShadow() :
                                            BoxShadow(
                                              color: AppTheme.addNewTextFieldText
                                                  .withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 15,
                                              offset: Offset(0, 0), // changes position of shadow
                                            )
                                          ]*/
                                      ),
                                      child: Column(
                                        children: [

                                          Container(
                                            height: 40,
                                            width: SizeConfig.screenWidth,
                                            padding: EdgeInsets.only(left: 10,right: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5),),

                                               /* border: Border(
                                                    bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5))
                                                )*/
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(width: SizeConfig.screenWidthM40*0.30,child: Text("Amount")),
                                                Container( width: SizeConfig.screenWidthM40*0.25,child: Text("Payment Type")),
                                                Container( width: SizeConfig.screenWidthM40*0.25,child: Text("Terms")),

                                              ],

                                            ),
                                          ),

                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: qn.paymentMappingList.length,
                                              itemBuilder: (context, index) {
                                                return SlideTransition(
                                                  position: Tween<Offset>(begin: Offset(qn.paymentMappingList[index].isEdit ? 0.0 :
                                                  qn.paymentMappingList[index].isDelete ?1.0:0.0,
                                                      qn.paymentMappingList[index].isEdit ? 0.0 :qn.paymentMappingList[index].isDelete ?0.0: 1.0),
                                                      end:qn.paymentMappingList[index].isEdit ?Offset(1, 0): Offset.zero)
                                                      .animate(qn.paymentMappingList[index].scaleController),

                                                  child: FadeTransition(
                                                    opacity: Tween(begin: qn.paymentMappingList[index].isEdit ? 1.0 : 0.0,
                                                        end: qn.paymentMappingList[index].isEdit ? 0.0 : 1.0)
                                                        .animate(qn.paymentMappingList[index].scaleController),
                                                    child: Container(
                                                      padding: EdgeInsets.only(top: 5, bottom: 5,left: 10,right: 10),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5))
                                                          )
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [

                                                              Container(
                                                                width: SizeConfig.screenWidthM40*0.42,
                                                                height: 25,
                                                                alignment:Alignment.centerLeft,

                                                                child: FittedBox(
                                                                  fit: BoxFit.contain,
                                                                  child: Row(
                                                                    children: [
                                                                      Text("${qn.paymentMappingList[index].Amount}",
                                                                        style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),textAlign: TextAlign.left,
                                                                      ),
                                                                      Text("${DateFormat.yMMMd().add_jm().format(qn.paymentMappingList[index].createdDate)}",
                                                                        style: TextStyle(fontSize: 10, fontFamily: 'RR', color: AppTheme.gridTextColor.withOpacity(0.5)),textAlign: TextAlign.left,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets.only(left: 5),
                                                                alignment: Alignment.centerLeft,

                                                                width: SizeConfig.screenWidthM40*0.18,
                                                                child: Text("${qn.paymentMappingList[index].PaymentCategoryName}",
                                                                  style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment.center,
                                                                width:SizeConfig.screenWidthM40*0.25,
                                                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(25),
                                                                  color: Colors.grey[300]
                                                                ),

                                                                child: Text("${index+1} Payment",
                                                                  style: TextStyle(fontSize: 12, fontFamily: 'RR', color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              GestureDetector(
                                                                onTap: () {



                                                                  if (qn.paymentMappingList[index].isEdit) {
                                                                    qn.paymentMappingList[index].scaleController.forward().whenComplete(() {
                                                                      print("EIT");
                                                                      if (this.mounted) {
                                                                        setState(() {
                                                                          qn.paymentMappingList.removeAt(index);
                                                                        });
                                                                        qn.balanceCalc();
                                                                      }
                                                                    });

                                                                  }
                                                                  else {
                                                                    setState(() {
                                                                      qn.paymentMappingList[index].isDelete=true;
                                                                    });



                                                                      qn.paymentMappingList[index].scaleController.reverse().whenComplete(() {
                                                                        if (this.mounted) {

                                                                          setState(() {
                                                                            qn.paymentMappingList.removeAt(index);
                                                                          });
                                                                          qn.balanceCalc();
                                                                        }
                                                                      });



                                                                  }
                                                                },
                                                                child: Container(
                                                                    height: 25,
                                                                    width: 25,
                                                                    child: Icon(
                                                                        Icons.delete,
                                                                        color: Colors.red)
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                          qn.paymentMappingList[index].Comment.isNotEmpty?Container(
                                                            margin: EdgeInsets.only(top: 5),
                                                            width: SizeConfig.screenWidthM40,
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.comment,color: AppTheme.yellowColor,size: 20,),
                                                                Container(

                                                                  width: SizeConfig.screenWidthM40-45,
                                                                  child: Text("${qn.paymentMappingList[index].Comment}",
                                                                  style: TextStyle(fontSize: 12,fontFamily: 'RR',color: AppTheme.addNewTextFieldText.withOpacity(0.7)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ):
                                                              Container()

                                                        ],
                                                      ),

                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),


                                    Container(
                                      height: 50,
                                      margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                                      width: SizeConfig.screenWidth,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Container(
                                            height: 50,
                                            width: SizeConfig.screenWidth*0.4,

                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Container(
                                                    width: SizeConfig.screenWidth*0.4,
                                                    height:50,
                                                    alignment: Alignment.center,
                                                    child: TextFormField(
                                                      onTap: (){
                                                        setState(() {
                                                          _keyboardVisible=true;
                                                        });
                                                        scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);

                                                      },

                                                      scrollPadding: EdgeInsets.only(bottom: 100),
                                                      style: TextStyle(fontFamily: 'RR', fontSize: 15,
                                                          color: AppTheme.addNewTextFieldText, letterSpacing: 0.2),
                                                      controller: qn.amount,
                                                      decoration: InputDecoration(
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        hintStyle: TextStyle(fontFamily: 'RL', fontSize: 15, color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
                                                        border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)),
                                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)),
                                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.addNewTextFieldFocusBorder)
                                                        ),
                                                        hintText: "Amount",
                                                        contentPadding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),

                                                      ),
                                                      maxLines: null,
                                                      keyboardType: TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                      ],
                                                      textInputAction: TextInputAction.done,
                                                      onChanged: (v) {

                                                      },
                                                      onEditingComplete: (){
                                                        node.unfocus();
                                                        Timer(Duration(milliseconds: 100), (){
                                                          setState(() {
                                                            _keyboardVisible=false;
                                                          });
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      node.unfocus();
                                                      Timer(Duration(milliseconds: 100), (){
                                                        setState(() {
                                                          _keyboardVisible=false;
                                                        });

                                                        if(qn.paymentCategoryId==null){
                                                          CustomAlert().commonErrorAlert(context, "Select Payment Type", "");
                                                        }
                                                        else if(qn.amount.text.isEmpty){
                                                          CustomAlert().commonErrorAlert(context, "Enter Amount", "");
                                                        }
                                                        else{
                                                          Timer(Duration(milliseconds: 300), () {
                                                            setState(() {
                                                              qn.paymentMappingList.add(
                                                                  PaymentMappingModel(
                                                                      InvoicePaymentMappingId: null,
                                                                      InvoiceId: qn.EditinvoiceId,
                                                                      PaymentCategoryId: qn.paymentCategoryId,
                                                                      PaymentCategoryName: qn.paymentCategoryName,
                                                                      Amount: qn.amount.text.isEmpty?0.0:double.parse(qn.amount.text),
                                                                      PartyId: qn.EditPartyId,
                                                                      Comment: qn.comment.text,

                                                                      IsActive: 1,
                                                                      createdDate: DateTime.now(),
                                                                      scaleController: AnimationController(duration: Duration(milliseconds: 300), vsync: this),
                                                                      isEdit: false,
                                                                      isDelete: false
                                                                  )
                                                              );


                                                            });

                                                            listViewController.animateTo(listViewController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeIn).then((value) {
                                                              qn.paymentMappingList[qn.paymentMappingList.length - 1].scaleController.forward().then((value) {
                                                                listViewController.animateTo(listViewController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                                qn.clearPaymentEntry();
                                                              });
                                                            });
                                                            qn.balanceCalc();
                                                          });
                                                        }
                                                      });




                                                    },
                                                    child: Container(
                                                      height: SizeConfig.height40,
                                                      width: SizeConfig.height40,
                                                     margin: EdgeInsets.only( right: SizeConfig.width5),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppTheme.yellowColor,
                                                      ),
                                                      child: Center(
                                                        child: Icon(Icons.add, color: AppTheme.bgColor, size: 30,),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: () {
                                              node.unfocus();
                                              setState(() {
                                                _keyboardVisible=false;
                                                paymentCategoryOpen = true;
                                              });

                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(left: SizeConfig.width5, right: SizeConfig.width5),
                                              height:50,
                                              width: SizeConfig.screenWidth*0.4,
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                color: qn.paymentCategoryName == null ? AppTheme.disableColor:Colors.white,
                                                borderRadius: BorderRadius.circular(3),
                                                border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(qn.paymentCategoryName == null ? "Payment Type" : qn.paymentCategoryName,
                                                    style: TextStyle(fontFamily: 'RR', fontSize: 16,
                                                      color: qn.paymentCategoryName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5) : AppTheme.addNewTextFieldText,),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                      height: SizeConfig.height25,
                                                      width: SizeConfig.height25,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: qn.paymentCategoryName == null ? AppTheme.addNewTextFieldText : AppTheme.yellowColor,
                                                      ),

                                                      child: Center(child: Icon(
                                                        Icons.arrow_forward_ios_outlined, color: Colors.white, size: 14,)))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ),





                                    AddNewLabelTextField(
                                      labelText: "Comments",
                                      maxlines: 5,
                                      scrollPadding: 100,
                                      textEditingController: qn.comment,
                                      ontap: (){
                                        setState(() {
                                          _keyboardVisible=true;
                                        });
                                        scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);

                                      },
                                      onEditComplete: (){
                                        node.unfocus();
                                        Timer(Duration(milliseconds: 100), (){
                                          setState(() {
                                            _keyboardVisible=false;
                                          });
                                        });
                                      },
                                    ),


                                    Align(
                                        alignment: Alignment.center,
                                        child:qn.balanceAmount.toInt()==0?Container(): Container(

                                          width: SizeConfig.screenWidth,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(left: SizeConfig.screenWidth*0.4),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              Text("Balance Amount",style: TextStyle(fontFamily: 'RR',color: AppTheme.red,fontSize: 14),),
                                              SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text("${qn.balanceAmount}",
                                                    style: TextStyle(fontFamily: 'RR',color: AppTheme.red,fontSize: 30),
                                                  ),

                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                    SizedBox(height: SizeConfig.height50,)
                                  ],
                                ),
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
                      IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
                       qn.clearEditForm();
                        Navigator.pop(context);
                      }),
                      SizedBox(width: SizeConfig.width5,),
                      Text("${qn.EditInvoiceType}",
                        style: TextStyle(fontFamily: 'RR',
                            color: Colors.black,
                            fontSize: SizeConfig.width16),
                      ),

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
                            color: AppTheme.gridbodyBgColor.withOpacity(0.7),
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
                        Center(
                          heightFactor: 0.5,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){

                              if(qn.paymentMappingList.isEmpty){
                                CustomAlert().commonErrorAlert(context, "Add Payment", "");
                              }

                              else{
                                qn.UpdatePaymentDbHit(context,this);
                              }

                            },
                            child: Container(

                              height: SizeConfig.width50,
                              width: SizeConfig.width50,
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
                                child: Icon(Icons.done,size: SizeConfig.height30,color: AppTheme.bgColor,),
                              ),
                            ),
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


                Container(
                  height:  paymentCategoryOpen? SizeConfig.screenHeight : 0,
                  width:  paymentCategoryOpen? SizeConfig.screenWidth : 0,
                  color: Colors.black.withOpacity(0.5),
                ),
                Container(
                  height: qn.PaymentLoader ? SizeConfig.screenHeight : 0,
                  width: qn.PaymentLoader ? SizeConfig.screenWidth : 0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.yellowColor),),
                    //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

                  ),
                ),




                /////////////////////////////////// payment type /////////////////////////////////////////////////////
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
                      transform: Matrix4.translationValues(paymentCategoryOpen?0:SizeConfig.screenWidth, 0, 0),

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
                                          paymentCategoryOpen=false;
                                        });
                                      }),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text('Select Material',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.height10,),
                              Container(
                                height: SizeConfig.screenHeight*(300/720),
                                /*color: Colors.red,*/
                                margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                                child: ListView.builder(
                                  itemCount: qn.paymentTypeList.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                    
                                          setState(() {
                                            qn.paymentCategoryId=qn.paymentTypeList[index].paymentCategoryId;
                                            qn.paymentCategoryName=qn.paymentTypeList[index].paymentCategoryName;
                                            paymentCategoryOpen=false;
                                          });
                                       
                                        


                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            borderRadius:BorderRadius.circular(8),
                                            border: Border.all(color: qn.paymentCategoryId==null? AppTheme.addNewTextFieldBorder:qn.paymentCategoryId==qn.paymentTypeList[index].paymentCategoryId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                            color: qn.paymentCategoryId==null? Colors.white: qn.paymentCategoryId==qn.paymentTypeList[index].paymentCategoryId?AppTheme.popUpSelectedColor:Colors.white
                                        ),
                                        width:300,
                                        height:50,
                                        child: Text("${qn.paymentTypeList[index].paymentCategoryName}",
                                          style: TextStyle(color:qn.paymentCategoryId==null? AppTheme.grey:qn.paymentCategoryId==qn.paymentTypeList[index].paymentCategoryId?Colors.white:AppTheme.grey,
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

              ],
            ),
      ),
    );

  }
}
