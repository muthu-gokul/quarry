import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/paymentModel/paymentMappingModel.dart';
import 'package:quarry/model/productionDetailsModel/productionMaterialMappingListModel.dart';
import 'package:quarry/notifier/paymentNotifier.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/utils/utils.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';

class PaymentEditForm extends StatefulWidget {
  @override
  PaymentEditFormState createState() => PaymentEditFormState();
}

class PaymentEditFormState extends State<PaymentEditForm> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();


  ScrollController? scrollController;
  ScrollController? listViewController;

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
      resizeToAvoidBottomInset: false,
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
                        height:180,

                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/svg/gridHeader/paymentHeader.jpg",),
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
                          height: SizeConfig.screenHeight! - 60,
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
                              height: SizeConfig.screenHeight! - 100,
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
                                  physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                                  controller: listViewController,
                                  scrollDirection: Axis.vertical,

                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top:SizeConfig.height20!,),

                                      width: SizeConfig.screenWidth,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(


                                              padding: EdgeInsets.only(left:SizeConfig.width10!,),
                                              width: SizeConfig.screenWidthM40!*0.49,
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


                                              padding: EdgeInsets.only(left:SizeConfig.width10!,),
                                              width: SizeConfig.screenWidthM40!*0.49,
                                              height: 50,
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                  color: AppTheme.editDisableColor
                                              ),
                                              child:  Text(qn.EditInvoiceDate==null?"":"${DateFormat.yMMMd().add_jm().format(qn.EditInvoiceDate!)}",
                                                style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 14),
                                              )

                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(

                                        margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top:SizeConfig.height20!,),
                                        padding: EdgeInsets.only(left:SizeConfig.width10!,),
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

                                        margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top:SizeConfig.height20!,),
                                        padding: EdgeInsets.only(left:SizeConfig.width10!,right:SizeConfig.width10!,),
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
                                      clipBehavior: Clip.antiAlias,
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
                                        left: SizeConfig.width20!,
                                        right: SizeConfig.width20!,
                                        top: SizeConfig.height20!,),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: AppTheme.addNewTextFieldBorder)
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
                                                Container(width: SizeConfig.screenWidthM40!*0.30,child: Text("Amount")),
                                                Container( width: SizeConfig.screenWidthM40!*0.30,child: Text("Payment Type")),
                                                Container( width: SizeConfig.screenWidthM40!*0.25,child: Text("Terms")),

                                              ],

                                            ),
                                          ),

                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: qn.paymentMappingList.length,
                                              itemBuilder: (context, index) {
                                                return SlideTransition(
                                                  position: Tween<Offset>(begin: Offset(qn.paymentMappingList[index].isEdit! ? 0.0 :
                                                  qn.paymentMappingList[index].isDelete! ?1.0:0.0,
                                                      qn.paymentMappingList[index].isEdit! ? 0.0 :qn.paymentMappingList[index].isDelete! ?0.0: 1.0),
                                                      end:qn.paymentMappingList[index].isEdit! ?Offset(1, 0): Offset.zero)
                                                      .animate(qn.paymentMappingList[index].scaleController!),

                                                  child: FadeTransition(
                                                    opacity: Tween(begin: qn.paymentMappingList[index].isEdit! ? 1.0 : 0.0,
                                                        end: qn.paymentMappingList[index].isEdit! ? 0.0 : 1.0)
                                                        .animate(qn.paymentMappingList[index].scaleController!),
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
                                                                width: SizeConfig.screenWidthM40!*0.4,
                                                                height: 25,
                                                                alignment:Alignment.centerLeft,

                                                                child: FittedBox(
                                                                  fit: BoxFit.contain,
                                                                  child: Row(
                                                                    children: [
                                                                      Text("${qn.paymentMappingList[index].Amount}",
                                                                        style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),textAlign: TextAlign.left,
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets.only(left: 5),
                                                                alignment: Alignment.centerLeft,

                                                                width: SizeConfig.screenWidthM40!*0.20,
                                                                child: Text("${qn.paymentMappingList[index].PaymentCategoryName}",
                                                                  style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment.center,
                                                                width:SizeConfig.screenWidthM40!*0.25,
                                                              /*  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(25),
                                                                  color: Colors.grey[300]
                                                                ),*/

                                                                child: Text("${index+1} Payment",
                                                                  style: TextStyle(fontSize: 12, fontFamily: 'RR', color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              GestureDetector(
                                                                onTap: () {


                                                                  CustomAlert(
                                                                    callback: (){
                                                                      Navigator.pop(context);
                                                                      Timer(Duration(milliseconds: 200), (){
                                                                        print(qn.paymentMappingList[index].isEdit);
                                                                        if (qn.paymentMappingList[index].isEdit!) {
                                                                          qn.paymentMappingList[index].scaleController!.reverse().whenComplete(() {
                                                                              setState(() {
                                                                                qn.paymentMappingList.removeAt(index);
                                                                              });
                                                                              qn.balanceCalc();
                                                                          });
                                                                        }
                                                                        else {
                                                                          setState(() {
                                                                            qn.paymentMappingList[index].isDelete=true;
                                                                          });
                                                                          qn.paymentMappingList[index].scaleController!.reverse().whenComplete(() {


                                                                              setState(() {
                                                                                qn.paymentMappingList.removeAt(index);
                                                                              });
                                                                              qn.balanceCalc();

                                                                          });
                                                                        }
                                                                      });

                                                                    },
                                                                    Cancelcallback: (){
                                                                      Navigator.pop(context);
                                                                    }
                                                                  ).yesOrNoDialog(context, "", "Are you sure want to delete this Payment ?");




                                                                },
                                                                  child: Container(
                                                                      height: 20,
                                                                      width: 20,
                                                                      child: SvgPicture.asset("assets/svg/delete.svg",color: AppTheme.red)
                                                                  ),
                                                              ),

                                                            ],
                                                          ),
                                                          Text("${DateFormat.yMMMd().add_jm().format(qn.paymentMappingList[index].createdDate!)}",
                                                            style: TextStyle(fontSize: 10, fontFamily: 'RR', color: AppTheme.gridTextColor.withOpacity(0.5)),textAlign: TextAlign.left,
                                                          ),
                                                          qn.paymentMappingList[index].Comment!.isNotEmpty?Container(
                                                            margin: EdgeInsets.only(top: 5),
                                                            width: SizeConfig.screenWidthM40,
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.comment,color: AppTheme.yellowColor,size: 20,),
                                                                Container(

                                                                  width: SizeConfig.screenWidthM40!-45,
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
                                      margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top:SizeConfig.height20!,),
                                      width: SizeConfig.screenWidth,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Container(
                                            height: 50,
                                            width: SizeConfig.screenWidth!*0.42,

                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Container(
                                                    width: SizeConfig.screenWidth!*0.42,
                                                    height:50,
                                                    alignment: Alignment.center,
                                                    child: TextFormField(
                                                      onTap: (){
                                                        if(scrollController!.offset==0){
                                                          scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                        }
                                                        setState(() {
                                                          _keyboardVisible=true;
                                                          isListScroll=true;
                                                        });


                                                      },

                                                      scrollPadding: EdgeInsets.only(bottom: 450),
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
                                                        FilteringTextInputFormatter.allow(RegExp(decimalReg)),
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
                                                        else if(parseDouble(qn.amount.text)>qn.balanceAmount){
                                                          CustomAlert().commonErrorAlert(context, "Amount should be less than or Equal to Balance Amount", "");
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
                                                            listViewController!.animateTo(listViewController!.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeIn).then((value) {
                                                              qn.paymentMappingList[qn.paymentMappingList.length - 1].scaleController!.forward().then((value) {
                                                                listViewController!.animateTo(listViewController!.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                                qn.clearPaymentEntry();
                                                              });
                                                            });
                                                            qn.balanceCalc();
                                                          });
                                                        }
                                                      });




                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                     margin: EdgeInsets.only( right: SizeConfig.width5!),
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
                                              padding: EdgeInsets.only(left: SizeConfig.width5!, right: SizeConfig.width5!),
                                              height:50,
                                              width: SizeConfig.screenWidth!*0.42,
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                color: qn.paymentCategoryName == null ? AppTheme.disableColor:Colors.white,
                                                borderRadius: BorderRadius.circular(3),
                                                border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(qn.paymentCategoryName == null ? "Payment Type" : qn.paymentCategoryName!,
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
                                      scrollPadding: 400,
                                      textEditingController: qn.comment,
                                      regExp: '[A-Za-z0-9,. ]',
                                      ontap: (){
                                        setState(() {
                                          _keyboardVisible=true;
                                          isListScroll=true;
                                        });
                                        scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);

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


                                    Container(
                                      height: 50,
                                      width: SizeConfig.screenWidth,
                                      margin: EdgeInsets.only(top: 20),
                                      padding: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!),
                                      child: Row(
                                        children: [
                                          Visibility(
                                              visible:qn.isRightOff,
                                              child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                children: [
                                                  Text("Right Off Amount",style: ts14(AppTheme.addNewTextFieldText,fontfamily: 'RL'),),
                                                  SizedBox(height: 5,),
                                                  Text("${qn.rightOffAmount}",
                                                    style: TextStyle(fontFamily: 'RR', fontSize: 18,
                                                        color: AppTheme.addNewTextFieldText, letterSpacing: 0.2),
                                                  ),
                                                ],
                                              )
                                          ),
                                          Spacer(),
                                          Checkbox(
                                              fillColor: MaterialStateColor.resolveWith((states) => AppTheme.yellowColor),
                                              value: qn.isRightOff,
                                              onChanged: (v){
                                                setState(() {
                                                  qn.isRightOff=v!;
                                                });
                                                if(qn.isRightOff){
                                                  qn.rightOffAmount=qn.balanceAmount;
                                                }
                                                else{
                                                  qn.rightOffAmount=0.0;
                                                }
                                                qn.balanceCalc();
                                              }
                                          ),
                                          InkWell(
                                              onTap: (){

                                              },
                                              child: Text("Is Right Off ?", style:  TextStyle(fontFamily: 'RR',fontSize: 16,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),)
                                          ),
                                        ],
                                      ),
                                    ),

                                    Align(
                                        alignment: Alignment.center,
                                        child:qn.balanceAmount.toInt()==0?Container(): Container(

                                          width: SizeConfig.screenWidth,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(left: SizeConfig.screenWidth!*0.4),
                                          margin: EdgeInsets.only(top: 10),
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
                                    SizedBox(height:  _keyboardVisible ? SizeConfig.screenHeight! * 0.5 :SizeConfig.height100,)
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
                      CancelButton(
                        ontap: (){
                          qn.clearEditForm();
                          qn.clearInsertForm();
                          Navigator.pop(context);
                        },
                      ),

                      Text("${qn.EditInvoiceType} Payment / Edit",
                        style: TextStyle(fontFamily: 'RR',
                            color: AppTheme.bgColor,
                            fontSize: 16),
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
                            size: Size( SizeConfig.screenWidth!, 65),
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

                PopUpStatic(
                  title: "Select Payment Type",

                  isOpen: paymentCategoryOpen,
                  dataList: qn.paymentTypeList,
                  propertyKeyName:"PaymentCategoryName",
                  propertyKeyId: "PaymentCategoryId",
                  selectedId: qn.paymentCategoryId,
                  itemOnTap: (index){
                    setState(() {
                      paymentCategoryOpen=false;
                      qn.paymentCategoryId=qn.paymentTypeList[index].paymentCategoryId;
                      qn.paymentCategoryName=qn.paymentTypeList[index].paymentCategoryName;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      paymentCategoryOpen=false;
                    });
                  },
                ),


              ],
            ),
      ),
    );

  }
}

