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
import 'package:quarry/widgets/currentDateContainer.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';

class PaymentAddNewForm extends StatefulWidget {
  @override
  PaymentAddNewFormState createState() => PaymentAddNewFormState();
}

class PaymentAddNewFormState extends State<PaymentAddNewForm> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;

  bool _keyboardVisible = false;

  bool isListScroll=false;
  bool paymentCategoryOpen=false;
  bool suppliersListOpen=false;
  bool isPlantOpen=false;

  @override
  void initState() {

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
      resizeToAvoidBottomInset: false,
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
                              height: SizeConfig.screenHeight - 100,
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
                                    CurrentDate(DateTime.now()),

                                    AddNewLabelTextField(
                                      labelText: 'Material Name',
                                      textEditingController: qn.materialName,
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

                                    GestureDetector(
                                      onTap: (){

                                        if(qn.plantCount!=1){
                                          node.unfocus();

                                          Timer(Duration(milliseconds: 50), (){
                                            setState(() {
                                              _keyboardVisible=false;
                                            });
                                          });
                                          setState(() {
                                            isPlantOpen=true;
                                          });
                                        }


                                      },
                                      child: SidePopUpParent(
                                        text: qn.PlantName==null? "Select Plant":qn.PlantName,
                                        textColor: qn.PlantName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                        iconColor: qn.PlantName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                        bgColor: qn.PlantName==null? AppTheme.disableColor:Colors.white,

                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: (){
                                        node.unfocus();

                                        setState(() {
                                          suppliersListOpen=true;
                                          _keyboardVisible=false;
                                        });



                                      },
                                      child: SidePopUpParent(
                                        text: qn.selectedPartyName==null? "Select Party Name":qn.selectedPartyName,
                                        textColor: qn.selectedPartyName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                        iconColor: qn.selectedPartyName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                        bgColor: qn.selectedPartyName==null? AppTheme.disableColor:Colors.white,

                                      ),
                                    ),

                                    AddNewLabelTextField(
                                      labelText: 'Amount',
                                      scrollPadding: 100,
                                      textEditingController: qn.amount,
                                      textInputType: TextInputType.number,
                                      suffixIcon:  Container(
                                        margin: EdgeInsets.all(10),
                              height: 15,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppTheme.yellowColor
                              ),
                              child: Center(
                                child: Text("Rs",style: AppTheme.TSWhite16,),
                              ),
                            ),
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

                                    GestureDetector(
                                      onTap: (){
                                        node.unfocus();


                                        setState(() {
                                          paymentCategoryOpen=true;
                                          _keyboardVisible=false;
                                        });



                                      },
                                      child: SidePopUpParent(
                                        text: qn.paymentCategoryName==null? "Mode of Payment":qn.paymentCategoryName,
                                        textColor: qn.paymentCategoryName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                        iconColor: qn.paymentCategoryName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                        bgColor: qn.paymentCategoryName==null? AppTheme.disableColor:Colors.white,

                                      ),
                                    ),







                                    SizedBox(height:_keyboardVisible ? SizeConfig.screenHeight * 0.5 :  SizeConfig.height50,)
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
                        qn.clearInsertForm();
                        Navigator.pop(context);
                      }),
                      SizedBox(width: SizeConfig.width5,),
                      Text(qn.isPaymentReceivable?"Add New Receivable":"Add New Payable",
                        style: TextStyle(fontFamily: 'RR',
                            color: Colors.black,
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
                    height:70,

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

                              if(qn.amount.text.isEmpty){
                                CustomAlert().commonErrorAlert(context, "Add Amount", "");
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
                  height:  paymentCategoryOpen || isPlantOpen|| suppliersListOpen? SizeConfig.screenHeight : 0,
                  width:  paymentCategoryOpen || isPlantOpen || suppliersListOpen? SizeConfig.screenWidth : 0,
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
                  selectedId:qn.paymentCategoryId,
                  itemOnTap: (index){
                    setState(() {
                      qn.paymentCategoryId=qn.paymentTypeList[index].paymentCategoryId;
                      qn.paymentCategoryName=qn.paymentTypeList[index].paymentCategoryName;
                      paymentCategoryOpen=false;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      paymentCategoryOpen=false;
                    });
                  },
                ),



                ///////////////////////////////////////   Plant List    ////////////////////////////////
                PopUpStatic(
                  title: "Select Plant",
                  isOpen: isPlantOpen,
                  dataList: qn.plantList,
                  propertyKeyName:"PlantName",
                  propertyKeyId: "PlantId",
                  selectedId:qn.PlantId,
                  itemOnTap: (index){
                    setState(() {
                      qn.PlantId=qn.plantList[index].plantId;
                      qn.PlantName=qn.plantList[index].plantName;
                      isPlantOpen=false;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isPlantOpen=false;
                    });
                  },
                ),
                

                ///////////////////////////////////////      SUPPLIER LIST ////////////////////////////////
                PopUpStatic(
                  title: "Select Party Name",
                  isOpen: suppliersListOpen,
                  isAlwaysShown: true,
                  dataList: qn.filterPaymentSupplierList,
                  propertyKeyName:"SupplierName",
                  propertyKeyId: "SupplierId",
                  selectedId:qn.selectedPartyId,
                  itemOnTap: (index){

                    setState(() {
                      qn.selectedPartyId=qn.filterPaymentSupplierList[index].supplierId;
                      qn.selectedPartyName=qn.filterPaymentSupplierList[index].supplierName;



                      suppliersListOpen=false;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      suppliersListOpen=false;
                    });
                  },
                ),

              ],
            ),
      ),
    );

  }
}

