import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/paymentNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/utils/widgetUtils.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
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

  var keyboardVisible=false.obs;
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    keyboardVisible.value = MediaQuery.of(context).viewInsets.bottom != 0;
    SizeConfig().init(context);

    return Scaffold(
      key: scaffoldkey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.yellowColor,
      body: Consumer<PaymentNotifier>(
        builder: (context, qn, child) =>
            Stack(
              children: [

                AddNewLayout(
                  child: ListView(

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


                        },
                        onEditComplete: (){
                          node.unfocus();

                        },
                        onChange: (v){},
                      ),
                      !material?Container():ValidationErrorText(title: "* Enter Material",),

                      GestureDetector(
                        onTap: (){

                          if(qn.plantCount!=1){
                            node.unfocus();
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
                        scrollPadding: 350,
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
                        ontap: (){},
                        onChange: (v){},
                        onEditComplete: (){
                          node.unfocus();

                        },

                      ),
                      !amount?Container():ValidationErrorText(title: "* Enter Amount",),

                      GestureDetector(
                        onTap: (){
                          node.unfocus();
                          setState(() {
                            paymentCategoryOpen=true;
                          });
                        },
                        child: SidePopUpParent(
                          text: qn.paymentCategoryName==null? "Mode of Payment":qn.paymentCategoryName,
                          textColor: qn.paymentCategoryName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                          iconColor: qn.paymentCategoryName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                          bgColor: qn.paymentCategoryName==null? AppTheme.disableColor:Colors.white,

                        ),
                      ),

                      Obx(()=>SizedBox(height: keyboardVisible.value?350: 120,))
                    ],
                  ),
                  actionWidget: Container(
                    height: 50,
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
                          style: TextStyle(fontFamily: 'RR',
                              color: Colors.black,
                              fontSize: 16),
                        ),

                      ],
                    ),
                  ),
                  image: "assets/svg/gridHeader/paymentHeader.jpg",
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

