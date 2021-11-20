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
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/currentDateContainer.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/expectedDateContainer.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';
import 'package:quarry/widgets/singleDatePicker.dart';
import 'package:quarry/widgets/validationErrorText.dart';

class PaymentAddNewForm extends StatefulWidget {
  @override
  PaymentAddNewFormState createState() => PaymentAddNewFormState();
}

class PaymentAddNewFormState extends State<PaymentAddNewForm> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();


  ScrollController? scrollController;
  ScrollController? listViewController;

  bool _keyboardVisible = false;

  bool isListScroll=false;
  bool paymentCategoryOpen=false;
  bool suppliersListOpen=false;
  bool isPlantOpen=false;

  bool plant=false;
  bool material=false;
  bool amount=false;
  bool party=false;

  @override
  void initState() {

    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
                        height: 180,

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
                                  /*Timer(Duration(milliseconds: 100), (){

                               });*/

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
                                    print(listViewController!.hasListeners);
                                    print(listViewController!.position.userScrollDirection);
                                    //    print(listViewController.position);
                                    if(listViewController!.offset==0 && isListScroll && scrollController!.offset==100 && listViewController!.position.userScrollDirection==ScrollDirection.idle){

                                      Timer(Duration(milliseconds: 100), (){
                                        if(listViewController!.position.userScrollDirection!=ScrollDirection.reverse){
                                          if(scrollController!.position.pixels == scrollController!.position.maxScrollExtent){
                                            //scroll end
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
                                    GestureDetector(
                                      onTap: () async{
                                        final DateTime? picked = await showDatePicker2(
                                            context: context,
                                            initialDate:  qn.paymentDate==null?DateTime.now():qn.paymentDate!, // Refer step 1
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100),
                                            builder: (BuildContext context,Widget? child){
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme: ColorScheme.light(
                                                    primary: AppTheme.yellowColor, // header background color
                                                    onPrimary: AppTheme.bgColor, // header text color
                                                    onSurface: AppTheme.addNewTextFieldText, // body text color
                                                  ),

                                                ),
                                                child: child!,
                                              );
                                            });
                                        if (picked != null)
                                          setState(() {
                                            qn.paymentDate = picked;
                                          });
                                      },
                                      child: ExpectedDateContainer(
                                        text: qn.paymentDate==null?"Date":"${DateFormat.yMMMd().format(qn.paymentDate!)}",
                                        textColor: qn.paymentDate==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      ),
                                    ),

                                    AddNewLabelTextField(
                                      labelText: 'Material Name',
                                      regExp: '[A-Za-z  ]',
                                      textEditingController: qn.materialName,
                                      ontap: (){
                                        setState(() {
                                          _keyboardVisible=true;
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
                                    !material?Container():ValidationErrorText(title: "* Enter Material",),

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
                                   !plant?Container():ValidationErrorText(title: "* Select Plant"),

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
                                    !party?Container():ValidationErrorText(title: "* Select Party Name"),

                                    AddNewLabelTextField(
                                      labelText: 'Amount',
                                      regExp: '[0-9.]',
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
                                    !amount?Container():ValidationErrorText(title: "* Enter Amount",),

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







                                    SizedBox(height:_keyboardVisible ? SizeConfig.screenHeight! * 0.5 :  SizeConfig.height50,)
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
                          qn.clearInsertForm();
                          Navigator.pop(context);
                        },
                      ),

                      Text(qn.isPaymentReceivable?"Add New Receivable":"Add New Payable",
                        style: AppTheme.appBarTS,
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
                //add button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AddButton(
                    ontap: (){
                      node.unfocus();
                      if(qn.amount.text.isEmpty){setState(() {amount=true;});}
                      else{setState(() {amount=false;});}

                      if(qn.materialName.text.isEmpty){setState(() {material=true;});}
                      else{setState(() {material=false;});}

                      if(qn.PlantId==null){setState(() {plant=true;});}
                      else{setState(() {plant=false;});}

                      if(qn.selectedPartyId==null){setState(() {party=true;});}
                      else{setState(() {party=false;});}

                      if(!amount && !material && !plant && !party){
                        qn.InsertPaymentDbHit(context,this);
                      }

                    },
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
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),
                    ),
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

