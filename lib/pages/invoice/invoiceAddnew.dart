import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/invoiceModel/invMaterialMappingModel.dart';
import 'package:quarry/model/invoiceModel/invOtherChargesMappingModel.dart';
import 'package:quarry/notifier/invoiceNotifier.dart';

import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';
import 'package:quarry/widgets/validationErrorText.dart';



class InvoiceOrdersAddNew extends StatefulWidget {
  @override
  InvoiceOrdersAddNewState createState() => InvoiceOrdersAddNewState();
}

class InvoiceOrdersAddNewState extends State<InvoiceOrdersAddNew> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();
  bool _keyboardVisible = false;
  bool isListScroll=false;
  bool discountValueError=false;

  ScrollController scrollController;
  ScrollController listViewController;

  bool isPlantOpen=false;
  bool supplierTypeOpen=false;
  bool suppliersListOpen=false;
  bool materialsListOpen=false;

  int reorderLevelIndex=-1;
  List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "X", "0", "."];
  String indentQty="";
  String disValue="";
  bool discountKeyPad=false;

  TextEditingController otherChargeName=new TextEditingController();
  TextEditingController otherChargeAmount=new TextEditingController();
  bool otherChargeAmountOpen=false;

  bool otherChargesTextFieldOpen=false;

  bool deleteOpen=false;
  int selectedMaterialIndex=-1;

  bool plant=false;
  bool invoiceType=false;
  bool party=false;


/*  For DataTable   */
  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();
  bool showShadow=false;
  double valueContainerWidth=100;
  double dataTableheight=300;
  double dataTableBodyheight=250;
  List<String> gridcol=["Material","Qty","Price","Tax","Total",];



  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


      header.addListener(() {
        if(body.offset!=header.offset){
          body.jumpTo(header.offset);
        }
        if(header.offset==0){
          setState(() {
            showShadow=false;
          });
        }
        else{
          if(!showShadow){
            setState(() {
              showShadow=true;
            });
          }
        }
      });

      body.addListener(() {
        if(header.offset!=body.offset){
          header.jumpTo(body.offset);
        }
      });

      verticalLeft.addListener(() {
        if(verticalRight.offset!=verticalLeft.offset){
          verticalRight.jumpTo(verticalLeft.offset);
        }
      });

      verticalRight.addListener(() {
        if(verticalLeft.offset!=verticalRight.offset){
          verticalLeft.jumpTo(verticalRight.offset);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
 //   _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final node=FocusScope.of(context);
    SizeConfig().init(context);
    return Scaffold(
        key: scaffoldkey,
        body: Consumer<InvoiceNotifier>(
            builder: (context,pn,child)=> Stack(
              children: [



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
                                image: AssetImage("assets/svg/gridHeader/invoiceHeader.jpg",),
                                fit: BoxFit.cover
                            )

                        ),
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
                        Container(
                          height: SizeConfig.screenHeight,
                          width: SizeConfig.screenWidth,

                          decoration: BoxDecoration(
                              color: AppTheme.gridbodyBgColor,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          alignment: Alignment.topCenter,
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
                                });
                              }
                            },
                            child: Container(
                              height:SizeConfig.screenHeight-100,
                              width: SizeConfig.screenWidth,

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
                                    Container(

                                        margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                                        padding: EdgeInsets.only(left:SizeConfig.width10,),
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                            color: AppTheme.editDisableColor
                                        ),
                                        child:  Text("${DateFormat.yMMMd().format(pn.invoiceCurrentDate)} / ${DateFormat().add_jm().format(pn.invoiceCurrentDate)}",
                                          style: AppTheme.bgColorTS,
                                        )

                                    ),

                                    GestureDetector(
                                      onTap: (){

                                        if(pn.plantCount!=1){
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
                                        text: pn.PlantName==null? "Select Plant":pn.PlantName,
                                        textColor: pn.PlantName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                        iconColor: pn.PlantName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                        bgColor: pn.PlantName==null? AppTheme.disableColor:Colors.white,

                                      ),
                                    ),
                                   !plant?Container():ValidationErrorText(title: "* Select Plant"),


                                    GestureDetector(
                                      onTap: (){
                                        node.unfocus();
                                        setState(() {
                                          supplierTypeOpen=true;
                                        });

                                      },
                                      child: SidePopUpParent(
                                        text: pn.selectedInvoiceType==null? "Select Invoice Type":pn.selectedInvoiceType,
                                        textColor: pn.selectedInvoiceType==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                        iconColor: pn.selectedInvoiceType==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                        bgColor: pn.selectedInvoiceType==null? AppTheme.disableColor:Colors.white,
                                      ),
                                    ),
                                    !invoiceType?Container():ValidationErrorText(title: "* Select Invoice Type"),
                                    GestureDetector(
                                      onTap: (){
                                        node.unfocus();
                                        if(pn.selectedInvoiceType==null){
                                          CustomAlert().commonErrorAlert(context, "Select Invoice Type", "");
                                        }
                                        else{
                                          setState(() {
                                            suppliersListOpen=true;
                                          });
                                        }


                                      },
                                      child: SidePopUpParent(
                                        text: pn.selectedPartyName==null? "Select Party Name":pn.selectedPartyName,
                                        textColor: pn.selectedPartyName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                        iconColor: pn.selectedPartyName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                        bgColor: pn.selectedPartyName==null? AppTheme.disableColor:Colors.white,

                                      ),
                                    ),
                                    !party?Container():ValidationErrorText(title: "* Select Party Name"),

                                    SizedBox(height: SizeConfig.height20,),


                                    //Material data table
                                    pn.invoiceMaterialMappingList.isEmpty? Column(
                                      children: [
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
                                          child: Text("Do you want to Add Material?",
                                            style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.gridTextColor),
                                          ),
                                        ),
                                        SizedBox(height: SizeConfig.height10,),
                                        GestureDetector(
                                          onTap: (){
                                            if(pn.selectedPartyId!=null){
                                              setState(() {
                                                materialsListOpen=true;
                                              });
                                            }
                                            else{
                                              CustomAlert().commonErrorAlert(context, "Select Party Name", "");
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
                                                child: Text("+ Add Material",style: TextStyle(color:AppTheme.bgColor,fontSize:16,fontFamily: 'RM'),
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ):
                                    Container(
                                        height: dataTableheight+150,
                                        width: SizeConfig.screenWidth,
                                        clipBehavior: Clip.antiAlias,
                                        margin: EdgeInsets.only(left:SizeConfig.screenWidth*0.02,right:SizeConfig.screenWidth*0.02),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 15,
                                                offset: Offset(0, 0), // changes position of shadow
                                              )
                                            ]
                                        ),
                                        child:Stack(
                                          children: [

                                            //Scrollable
                                            Positioned(
                                              left:99,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: SizeConfig.screenWidth-valueContainerWidth-SizeConfig.screenWidth*0.04,
                                                    color: showShadow? AppTheme.f737373.withOpacity(0.8):AppTheme.f737373,
                                                    child: SingleChildScrollView(
                                                      controller: header,
                                                      scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                          children: gridcol.asMap().
                                                          map((i, value) => MapEntry(i, i==0?Container():
                                                          Container(
                                                              alignment: Alignment.center,
                                                              //  padding: EdgeInsets.only(left: 20,right: 20),
                                                              width: valueContainerWidth,
                                                              child: Text(value,style: AppTheme.TSWhiteML,)
                                                          )
                                                          )).values.toList()
                                                      ),
                                                    ),

                                                  ),
                                                  Container(
                                                    height: dataTableBodyheight,
                                                    width: SizeConfig.screenWidth-valueContainerWidth-SizeConfig.screenWidth*0.04,
                                                    alignment: Alignment.topCenter,
                                                    color: Colors.white,
                                                    child: SingleChildScrollView(
                                                      controller: body,
                                                      scrollDirection: Axis.horizontal,
                                                      child: Container(
                                                        height: dataTableBodyheight,
                                                        alignment: Alignment.topCenter,
                                                        color:Colors.white,
                                                        child: SingleChildScrollView(
                                                          controller: verticalRight,
                                                          scrollDirection: Axis.vertical,
                                                          child:  Column(
                                                              children:pn.invoiceMaterialMappingList.asMap().
                                                              map((index, value) => MapEntry(
                                                                  index,InkWell(
                                                                onTap: (){
                                                                  setState(() {
                                                                    if(selectedMaterialIndex!=index){
                                                                      selectedMaterialIndex=index;
                                                                      deleteOpen=true;
                                                                    }else{
                                                                      selectedMaterialIndex=-1;
                                                                      deleteOpen=false;
                                                                    }
                                                                  });
                                                                },
                                                                child: Container(

                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5))),
                                                                    color:selectedMaterialIndex==index?AppTheme.red: Colors.white,
                                                                  ),

                                                                  child: Row(
                                                                    children: [


                                                                      Container(
                                                                        alignment: Alignment.center,
                                                                        width: valueContainerWidth,
                                                                        child: FittedBox(
                                                                          fit: BoxFit.contain,
                                                                          child: Center(
                                                                            child: GestureDetector(
                                                                              onTap: (){
                                                                                setState(() {
                                                                                  indentQty=value.purchaseQty.text;
                                                                                  disValue=value.DiscountValue>0?value.DiscountValue.toString():'';
                                                                                  discountKeyPad=false;
                                                                                  pn.isDiscountPercentage=value.IsDiscount==1?value.IsPercentage==1?true:false:true;

                                                                                });

                                                                                showDialog(context: context,
                                                                                    barrierDismissible: false,
                                                                                    builder: (context){
                                                                                      return StatefulBuilder(
                                                                                        builder:(context,setState){
                                                                                          return Consumer<InvoiceNotifier>(
                                                                                            builder: (context,pn,child)=>Dialog(
                                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), ),

                                                                                              child: Container(
                                                                                                height: SizeConfig.screenHeight*0.85,

                                                                                                width: SizeConfig.screenWidth*0.9,
                                                                                                decoration: BoxDecoration(
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                    color: Colors.white
                                                                                                ),
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    Spacer(),
                                                                                                    //  SizedBox(height: 15,),
                                                                                                    Text("${value.materialName??""}",
                                                                                                      style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),
                                                                                                    SizedBox(height: 10,),
                                                                                                    discountKeyPad?
                                                                                                    Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Text("${indentQty.isEmpty?"0":indentQty} ${value.unitName??""}",
                                                                                                          style: TextStyle(fontFamily: 'RL',fontSize: 16,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),
                                                                                                        SizedBox(width: 20,),

                                                                                                        Text("${disValue.isEmpty?"0":disValue}",
                                                                                                          style: TextStyle(fontFamily: 'RM',fontSize: 20,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),
                                                                                                        SizedBox(width: 20,),
                                                                                                        GestureDetector(
                                                                                                          onTap: (){
                                                                                                            pn.updateisDiscountPercentage(false);

                                                                                                          },
                                                                                                          child: AnimatedContainer(
                                                                                                            duration: Duration(milliseconds: 200),
                                                                                                            curve: Curves.easeIn,
                                                                                                            height: 35,
                                                                                                            width: 35,
                                                                                                            decoration: BoxDecoration(
                                                                                                                shape: BoxShape.circle,
                                                                                                                border: Border.all(color: pn.isDiscountPercentage?AppTheme.addNewTextFieldBorder:Colors.transparent),
                                                                                                                color: pn.isDiscountPercentage?AppTheme.EFEFEF:AppTheme.addNewTextFieldFocusBorder
                                                                                                            ),
                                                                                                            child: Center(
                                                                                                              child: Text("₹",style: pn.isDiscountPercentage?AppTheme.discountDeactive:AppTheme.discountactive,),
                                                                                                            ),

                                                                                                          ),
                                                                                                        ),
                                                                                                        SizedBox(width: 10,),
                                                                                                        GestureDetector(
                                                                                                          onTap: (){

                                                                                                            pn.updateisDiscountPercentage(true);

                                                                                                          },
                                                                                                          child: AnimatedContainer(
                                                                                                            duration: Duration(milliseconds: 200),
                                                                                                            curve: Curves.easeIn,
                                                                                                            height: 35,
                                                                                                            width: 35,
                                                                                                            decoration: BoxDecoration(
                                                                                                                shape: BoxShape.circle,
                                                                                                                border: Border.all(color: pn.isDiscountPercentage?Colors.transparent:AppTheme.addNewTextFieldBorder),
                                                                                                                color: pn.isDiscountPercentage?AppTheme.addNewTextFieldFocusBorder:AppTheme.EFEFEF
                                                                                                            ),
                                                                                                            child: Center(

                                                                                                              child: Text("%",style: pn.isDiscountPercentage?AppTheme.discountactive:AppTheme.discountDeactive,),
                                                                                                            ),

                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ):




                                                                                                    Text("${indentQty.isEmpty?"0":indentQty} ${value.unitName??""}",
                                                                                                      style: TextStyle(fontFamily: 'RM',fontSize: 20,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),

                                                                                                    SizedBox(height: 10,),
                                                                                                    discountValueError?FittedBox(
                                                                                                      fit: BoxFit.contain,
                                                                                                      child: Text("* Discount Value should be less than 100%",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.red),
                                                                                                        textAlign: TextAlign.center,),
                                                                                                    ):Container(),
                                                                                                    Container(
                                                                                                        margin: EdgeInsets.only(top: 20),
                                                                                                        width: SizeConfig.screenWidth*0.8,
                                                                                                        child: Wrap(
                                                                                                            spacing: 10,
                                                                                                            runSpacing: 10,
                                                                                                            direction: Axis.horizontal,
                                                                                                            alignment: WrapAlignment.center,
                                                                                                            children: numbers
                                                                                                                .asMap().map((i, element) => MapEntry(i,
                                                                                                                GestureDetector(
                                                                                                                  onTap: () {
                                                                                                                    setState(() {
                                                                                                                      if (numbers[i] == 'X') {

                                                                                                                        if(!discountKeyPad){
                                                                                                                          indentQty = indentQty.substring(0, indentQty.length - 1);
                                                                                                                        } else{
                                                                                                                          disValue = disValue.substring(0, disValue.length - 1);
                                                                                                                        }

                                                                                                                        reorderLevelIndex=i;
                                                                                                                      }
                                                                                                                      else if (numbers[i] == '.') {


                                                                                                                        if(!discountKeyPad){
                                                                                                                          if(indentQty.length<6 && indentQty.length>=1){
                                                                                                                            if(indentQty.contains('.')){}
                                                                                                                            else{
                                                                                                                              setState(() {
                                                                                                                                indentQty=indentQty+'.';
                                                                                                                              });
                                                                                                                            }
                                                                                                                          }
                                                                                                                        }
                                                                                                                        else{
                                                                                                                          if(disValue.length<5 && disValue.length>=1){
                                                                                                                            if(disValue.contains('.')){}
                                                                                                                            else{
                                                                                                                              setState(() {
                                                                                                                                disValue=disValue+'.';
                                                                                                                              });
                                                                                                                            }
                                                                                                                          }
                                                                                                                        }

                                                                                                                        reorderLevelIndex=i;
                                                                                                                      }
                                                                                                                      else {

                                                                                                                        if(!discountKeyPad){
                                                                                                                          if(indentQty.isEmpty && numbers[i]=='0'){}
                                                                                                                          else{
                                                                                                                            setState(() {
                                                                                                                              reorderLevelIndex = i;
                                                                                                                            });
                                                                                                                            if(indentQty.length<6){
                                                                                                                              setState(() {
                                                                                                                                indentQty=indentQty+numbers[i];
                                                                                                                              });
                                                                                                                            }
                                                                                                                          }
                                                                                                                        }
                                                                                                                        else{
                                                                                                                          if(disValue.isEmpty && numbers[i]=='0'){}
                                                                                                                          else{
                                                                                                                            setState(() {
                                                                                                                              reorderLevelIndex = i;
                                                                                                                            });
                                                                                                                            if(disValue.length<5){
                                                                                                                              setState(() {
                                                                                                                                disValue=disValue+numbers[i];
                                                                                                                              });
                                                                                                                            }
                                                                                                                          }
                                                                                                                        }


                                                                                                                      }
                                                                                                                    });
                                                                                                                    Timer(Duration(milliseconds: 300), (){
                                                                                                                      setState((){
                                                                                                                        reorderLevelIndex=-1;
                                                                                                                      });
                                                                                                                    });
                                                                                                                  },
                                                                                                                  child: AnimatedContainer(
                                                                                                                      height: SizeConfig.screenWidth*0.19,
                                                                                                                      width: SizeConfig.screenWidth*0.19,
                                                                                                                      duration: Duration(milliseconds: 200),
                                                                                                                      curve: Curves.easeIn,
                                                                                                                      decoration: BoxDecoration(
                                                                                                                        color: reorderLevelIndex == i?AppTheme.yellowColor:AppTheme.unitSelectColor,
                                                                                                                        border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                                      ),
                                                                                                                      child: Center(
                                                                                                                          child: Text(numbers[i],
                                                                                                                            style: TextStyle(fontFamily: 'RR', color:reorderLevelIndex == i?Colors.white:AppTheme.gridTextColor, fontSize: 28,),
                                                                                                                            textAlign: TextAlign.center,
                                                                                                                          )
                                                                                                                      )
                                                                                                                  ),
                                                                                                                )))
                                                                                                                .values
                                                                                                                .toList()
                                                                                                        )
                                                                                                    ),
                                                                                                    SizedBox(height: 10,),
                                                                                                    Row(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Checkbox(
                                                                                                            activeColor: AppTheme.addNewTextFieldFocusBorder,
                                                                                                            value: discountKeyPad,
                                                                                                            onChanged: (v){
                                                                                                              setState((){

                                                                                                                discountKeyPad=v;
                                                                                                              });
                                                                                                            }
                                                                                                        ),

                                                                                                        Text("Discount",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.addNewTextFieldFocusBorder))

                                                                                                      ],
                                                                                                    ),
                                                                                                    SizedBox(height: 10,),
                                                                                                    GestureDetector(
                                                                                                      onTap: (){
                                                                                                        print(disValue);
                                                                                                        if(pn.isDiscountPercentage){
                                                                                                          if(disValue.isNotEmpty){
                                                                                                            if(double.parse(disValue)<100){
                                                                                                              setState((){
                                                                                                                discountValueError=false;
                                                                                                              });
                                                                                                              pn.updateIsDiscountFromQtyShowDialog(index,disValue,indentQty);
                                                                                                              Navigator.pop(context);
                                                                                                            }
                                                                                                            else{
                                                                                                              setState((){
                                                                                                                discountValueError=true;
                                                                                                              });
                                                                                                            }
                                                                                                          }
                                                                                                          else{
                                                                                                            setState((){
                                                                                                              discountValueError=false;
                                                                                                            });
                                                                                                            pn.updateIsDiscountFromQtyShowDialog(index,disValue,indentQty);
                                                                                                            Navigator.pop(context);
                                                                                                          }

                                                                                                        }
                                                                                                        else {
                                                                                                          setState((){
                                                                                                            discountValueError=false;
                                                                                                          });
                                                                                                          pn.updateIsDiscountFromQtyShowDialog(index,disValue,indentQty);
                                                                                                          Navigator.pop(context);
                                                                                                        }
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        height: 50,
                                                                                                        width: 150,
                                                                                                        decoration: BoxDecoration(
                                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                                            color: AppTheme.yellowColor
                                                                                                        ),
                                                                                                        child: Center(
                                                                                                          child: Text("Done",style: AppTheme.TSWhite20,),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    GestureDetector(
                                                                                                      onTap: (){
                                                                                                        setState((){
                                                                                                          discountValueError=false;
                                                                                                        });

                                                                                                        Navigator.pop(context);

                                                                                                      },
                                                                                                      child: Container(
                                                                                                        height: 50,
                                                                                                        width: 150,
                                                                                                        child: Center(
                                                                                                          child: Text("Cancel",style: TextStyle(fontFamily: 'RL',fontSize: 20,color: Color(0xFFA1A1A1))),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Spacer(),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    }
                                                                                );
                                                                              },
                                                                              child: Container(
                                                                                width: valueContainerWidth-40,
                                                                                padding: EdgeInsets.only(top: 7,bottom: 7,left: 5,right: 5),
                                                                                decoration: BoxDecoration(
                                                                                    border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                                                    borderRadius: BorderRadius.circular(50),
                                                                                    color: Colors.white
                                                                                ),
                                                                                child: Center(
                                                                                  child: FittedBox(
                                                                                    fit: BoxFit.contain,
                                                                                    child: Text("${value.purchaseQty.text.toString()}",
                                                                                      //style:AppTheme.ML_bgCT,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),


                                                                      /*Container(
                                                                        alignment: Alignment.center,

                                                                        width: valueContainerWidth,
                                                                        child:  Container(
                                                                          height: 30,
                                                                          width: 65,

                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                                              borderRadius: BorderRadius.circular(15)
                                                                          ),
                                                                          child: TextField(
                                                                            style: selectedMaterialIndex==index?AppTheme.TSWhite166:AppTheme.gridTextColorTS,
                                                                            controller: value.purchaseQty,
                                                                            decoration: InputDecoration(
                                                                                hintText: "0",
                                                                                hintStyle: AppTheme.hintText,
                                                                                border: InputBorder.none,
                                                                                focusedBorder: InputBorder.none,
                                                                                enabledBorder: InputBorder.none,
                                                                                errorBorder: InputBorder.none,
                                                                                contentPadding: EdgeInsets.only(left: 10,bottom: 12)
                                                                            ),
                                                                            keyboardType: TextInputType.number,
                                                                            onChanged: (v){
                                                                              pn.purchaseOrdersCalc(index, v);
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),*/

                                                                      Container(
                                                                        alignment: Alignment.center,
                                                                        width: valueContainerWidth,
                                                                        child: Text("${value.Subtotal}",
                                                                          style:AppTheme.ML_bgCT,
                                                                        ),
                                                                      ),

                                                                      Container(
                                                                        width: valueContainerWidth,
                                                                        alignment: Alignment.center,
                                                                        child: Text("${value.TaxAmount}",
                                                                          style:AppTheme.ML_bgCT,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: valueContainerWidth,
                                                                        alignment: Alignment.center,
                                                                        child: Text("${value.TotalAmount}",
                                                                          style:AppTheme.ML_bgCT,
                                                                        ),
                                                                      ),



                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                              )
                                                              ).values.toList()
                                                          ),
                                                        ),


                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),


                                            //not Scrollable
                                            Positioned(
                                              left: 0,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: valueContainerWidth,
                                                    color: AppTheme.f737373,
                                                    alignment: Alignment.center,
                                                    child: Text("${gridcol[0]}",style: AppTheme.TSWhiteML,),

                                                  ),
                                                  Container(
                                                    height: dataTableBodyheight,
                                                    alignment: Alignment.topCenter,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          showShadow?  BoxShadow(
                                                            color: AppTheme.addNewTextFieldText.withOpacity(0.1),
                                                            spreadRadius: 0,
                                                            blurRadius: 15,
                                                            offset: Offset(0, -8), // changes position of shadow
                                                          ):BoxShadow(color: Colors.transparent)
                                                        ]
                                                    ),
                                                    child: Container(
                                                      height: dataTableBodyheight,
                                                      alignment: Alignment.topCenter,

                                                      child: SingleChildScrollView(
                                                        controller: verticalLeft,
                                                        scrollDirection: Axis.vertical,
                                                        child:  Column(
                                                            children: pn.invoiceMaterialMappingList.asMap().
                                                            map((index, value) => MapEntry(
                                                                index,InkWell(
                                                              onTap: (){
                                                                setState(() {
                                                                  if(selectedMaterialIndex!=index){
                                                                    selectedMaterialIndex=index;
                                                                    deleteOpen=true;
                                                                  }else{
                                                                    selectedMaterialIndex=-1;
                                                                    deleteOpen=false;
                                                                  }
                                                                });
                                                              },
                                                              child:  Container(
                                                                alignment: Alignment.center,
                                                                height: 60,
                                                                width: valueContainerWidth,
                                                                decoration: BoxDecoration(
                                                                    border: Border(bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5))),

                                                                  color:selectedMaterialIndex==index?AppTheme.red: Colors.white,
                                                                ),
                                                                child: Text("${value.materialName}",
                                                                  style: AppTheme.ML_bgCT,
                                                                ),
                                                              ),
                                                            )
                                                            )
                                                            ).values.toList()


                                                        ),
                                                      ),


                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),


                                            Positioned(
                                              bottom: 0,
                                              child: Container(
                                                height: 150,
                                                width: SizeConfig.screenWidth,
                                                padding: EdgeInsets.only(right: SizeConfig.screenWidth*0.04),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                    border: Border(top: BorderSide(color: AppTheme.gridTextColor.withOpacity(0.3)))
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                            height:25,
                                                            width: SizeConfig.screenWidth*0.6,
                                                            alignment: Alignment.centerRight,
                                                            child: Text("Subtotal: ",style: AppTheme.gridTextColorTS,)
                                                        ),
                                                        Spacer(),
                                                        Text("${pn.subtotal}  ",style: AppTheme.gridTextColorTS,)
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                            height:25,
                                                            width: SizeConfig.screenWidth*0.6,
                                                            alignment: Alignment.centerRight,
                                                            child: Text("Discount: ",style: AppTheme.gridTextColorTS,)
                                                        ),
                                                        Spacer(),
                                                        Text("-${pn.discountAmount}  ",style: AppTheme.gridTextColorTS,)
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                            height:25,
                                                            width: SizeConfig.screenWidth*0.6,
                                                            alignment: Alignment.centerRight,
                                                            child: Text("GST: ",style: AppTheme.gridTextColorTS,)
                                                        ),
                                                        Spacer(),
                                                        Text("${pn.taxAmount}  ",style: AppTheme.gridTextColorTS,)
                                                      ],
                                                    ),

                                                    Row(
                                                      children: [
                                                        Container(
                                                            height:25,
                                                            width: SizeConfig.screenWidth*0.6,
                                                            alignment: Alignment.centerRight,
                                                            child: Text("Other Charges: ",style: AppTheme.gridTextColorTS,)
                                                        ),
                                                        Spacer(),
                                                        Text("${pn.otherCharges}  ",style: AppTheme.gridTextColorTS,)
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                            height:25,
                                                            width: SizeConfig.screenWidth*0.6,
                                                            alignment: Alignment.centerRight,
                                                            child: Text("Total: ",style: AppTheme.bgColorTS,)
                                                        ),
                                                        Spacer(),
                                                        Text("${pn.grandTotal}  ",style: AppTheme.bgColorTS,)
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                              ),
                                            )




                                          ],
                                        )







                                    ),






                                    SizedBox(height: SizeConfig.height100,)
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
                          pn.clearForm();
                          Navigator.pop(context);
                        },
                      ),

                      Text("Invoice",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                      ),
                      Text(pn.isInvoiceEdit?" / Edit":" / Add New",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                      ),
                      Spacer(),
                      pn.isInvoiceEdit && pn.InvoiceEditNumber!=null?Container(
                        height: 25,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: pn.isInvoiceReceivable?Colors.green:AppTheme.red
                        ),
                        child: Center(
                          child: Text("${pn.InvoiceEditNumber??""}",style: TextStyle(fontFamily: 'RR',fontSize: 14,color:Colors.white),),
                        ),
                      ):Container(),
                      SizedBox(width: SizeConfig.width10,),
                    ],
                  ),
                ),



                //bottomNav
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: 70,

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
                            //  painter: RPSCustomPainter(),
                            painter: RPSCustomPainter3(),
                          ),
                        ),

                        Container(
                          width:  SizeConfig.screenWidth,
                          height: 80,
                          child: Stack(

                            children: [

                              pn.invoiceMaterialMappingList.isNotEmpty?Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          otherChargeAmountOpen=true;
                                        });
                                      },
                                      child: Text("  + Other Charges",style: AppTheme.bgColorTS,)
                                  )
                              ):Container(),

                              AnimatedPositioned(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.bounceInOut,
                                  bottom: deleteOpen? 10:-60,

                                  child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          deleteOpen=false;
                                        });
                                        CustomAlert(
                                            callback: (){
                                              Navigator.pop(context);
                                              setState(() {
                                                pn.invoiceMaterialMappingList.clear();
                                                selectedMaterialIndex=-1;
                                              });
                                            },
                                            Cancelcallback: (){
                                              Navigator.pop(context);
                                              setState(() {
                                                selectedMaterialIndex=-1;
                                              });
                                            }
                                        ).yesOrNoDialog(context, "", "Do you want to delete All Material?");
                                      },
                                      child: Container(
                                          height: 30,
                                          padding: EdgeInsets.only(left: 20,bottom: 5),
                                          alignment: Alignment.centerLeft,
                                          width: SizeConfig.screenWidth*0.35,
                                          color: Colors.white,
                                          child: Text("  Delete All",style: AppTheme.bgColorTS,)
                                      )
                                  )
                              ),

                              pn.invoiceMaterialMappingList.isNotEmpty?Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                      onTap: (){

                                        setState(() {
                                          materialsListOpen=true;
                                        });
                                      },
                                      child: Text("+ Add Material  ",style: AppTheme.bgColorTS)
                                  )
                              ):Container(),

                              AnimatedPositioned(
                                  bottom: deleteOpen? 10:-60,
                                  right: 0,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.bounceInOut,

                                  child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          deleteOpen=false;
                                        });
                                        CustomAlert(
                                            callback: (){
                                              Navigator.pop(context);
                                              setState(() {
                                                pn.invoiceMaterialMappingList.removeAt(selectedMaterialIndex);
                                                selectedMaterialIndex=-1;
                                              });
                                            },
                                            Cancelcallback: (){
                                              Navigator.pop(context);
                                              setState(() {
                                                selectedMaterialIndex=-1;
                                              });
                                            }
                                        ).yesOrNoDialog(context, "", "Do you want to delete Material?");
                                      },
                                      child: Container(
                                          height: 30,
                                          padding: EdgeInsets.only(right: 20,bottom: 5),
                                          alignment: Alignment.centerRight,
                                          width: SizeConfig.screenWidth*0.35,
                                          color: Colors.white,
                                          child: Text("Delete",style: AppTheme.bgColorTS,)
                                      )
                                  )
                              ),

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
                      if(pn.PlantId==null){setState(() {plant=true;});}
                      else{setState(() {plant=false;});}

                      if(pn.selectedInvoiceType==null){setState(() {invoiceType=true;});}
                      else{setState(() {invoiceType=false;});}

                      if(pn.selectedPartyId==null){setState(() {party=true;});}
                      else{setState(() {party=false;});}


                      if(pn.invoiceMaterialMappingList.isEmpty){
                        CustomAlert().commonErrorAlert(context, "Add Material", "Add materials to make purchase.");
                      }
                      if(!plant && !invoiceType && !party && pn.invoiceMaterialMappingList.isNotEmpty){
                        pn.InsertInvoiceDbHit(context);
                      }


                    },
                  ),
                ),






                Container(
                  height: suppliersListOpen || supplierTypeOpen || materialsListOpen || otherChargeAmountOpen || isPlantOpen? SizeConfig.screenHeight:0,
                  width: suppliersListOpen || supplierTypeOpen || materialsListOpen || otherChargeAmountOpen || isPlantOpen? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                ),
                Container(
                  height: pn.InvoiceLoader? SizeConfig.screenHeight:0,
                  width: pn.InvoiceLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                    //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

                  ),
                ),


                ///////////////////////////////////////   Plant List    ////////////////////////////////
                PopUpStatic(
                  title: "Select Plant",
                  isOpen: isPlantOpen,
                  dataList: pn.plantList,
                  propertyKeyName:"PlantName",
                  propertyKeyId: "PlantId",
                  selectedId:pn.PlantId,
                  itemOnTap: (index){
                    setState(() {
                      pn.PlantId=pn.plantList[index].plantId;
                      pn.PlantName=pn.plantList[index].plantName;
                      isPlantOpen=false;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isPlantOpen=false;
                    });
                  },
                ),

                /*Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      width: SizeConfig.screenWidth,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                      transform: Matrix4.translationValues(isPlantOpen?0:SizeConfig.screenWidth, 0, 0),

                      child:Container(
                        height: 400,
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
                                          isPlantOpen=false;
                                        });
                                      }),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text('Select Plant',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.height10,),




                              Container(
                                height: SizeConfig.screenHeight*(300/720),

                                margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                                child: ListView.builder(
                                  itemCount: pn.plantList.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          pn.PlantId=pn.plantList[index].plantId;
                                          pn.PlantName=pn.plantList[index].plantName;
                                          isPlantOpen=false;
                                        });

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            borderRadius:BorderRadius.circular(8),
                                            border: Border.all(color: pn.PlantId==null? AppTheme.addNewTextFieldBorder:pn.PlantId==pn.plantList[index].plantId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                            color: pn.PlantId==null? Colors.white: pn.PlantId==pn.plantList[index].plantId?AppTheme.popUpSelectedColor:Colors.white
                                        ),
                                        width:300,
                                        height:50,
                                        child: Text("${pn.plantList[index].plantName}",
                                          style: TextStyle(color:pn.PlantId==null? AppTheme.grey:pn.PlantId==pn.plantList[index].plantId?Colors.white:AppTheme.grey,
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
                ),*/




///////////////////////////////////////      INVOICE TYPE ////////////////////////////////
                PopUpStatic(
                  title: "Select Invoice Type",
                  isOpen: supplierTypeOpen,
                  dataList: pn.invoiceTypeList,
                  propertyKeyName:"InvoiceType",
                  propertyKeyId: "InvoiceType",
                  selectedId:pn.selectedInvoiceType,
                  itemOnTap: (index){
                    setState(() {
                      pn.selectedInvoiceType= pn.invoiceTypeList[index].invoiceType;
                      pn.filterInvoiceSupplierList=pn.invoiceSupplierList.where((element) => element.supplierType.toLowerCase()==pn.selectedInvoiceType.toLowerCase()).toList();
                      if(pn.selectedPartyId!=null){
                        pn.selectedPartyName=null;
                        pn.selectedPartyId=null;
                      }

                      supplierTypeOpen=false;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      supplierTypeOpen=false;
                    });
                  },
                ),


///////////////////////////////////////      SUPPLIER LIST ////////////////////////////////
                PopUpStatic(
                  title: "Select Party Name",
                  isOpen: suppliersListOpen,
                  isAlwaysShown: true,
                  dataList: pn.filterInvoiceSupplierList,
                  propertyKeyName:"SupplierName",
                  propertyKeyId: "SupplierId",
                  selectedId:pn.selectedPartyId,
                  itemOnTap: (index){
                    setState(() {
                      pn.selectedPartyId=pn.filterInvoiceSupplierList[index].supplierId;
                      pn.selectedPartyName=pn.filterInvoiceSupplierList[index].supplierName;



                      if(pn.filterInvoiceSupplierList[index].supplierType=='Payable'){
                        pn.filtermaterialList=pn.materialList.where((element) => element.supplierId==pn.filterInvoiceSupplierList[index].supplierId
                            && element.supplierType=='Payable'
                        ).toList();
                      }
                      else{
                        pn.filtermaterialList=pn.materialList.where((element) => element.supplierType=='Receivable').toList();
                      }

                      print(pn.filtermaterialList.length);
                      suppliersListOpen=false;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      suppliersListOpen=false;
                    });
                  },
                ),



///////////////////////////////////////      MATERIALS LIST ////////////////////////////////
                Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      width: SizeConfig.screenWidth,
                      height: 430,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(left: SizeConfig.width25,right: SizeConfig.width25),
                      transform: Matrix4.translationValues(materialsListOpen?0:SizeConfig.screenWidth, 0, 0),
                      alignment: Alignment.topCenter,
                      child:Stack(
                        children: [
                          Container(
                            height: 380,
                            width: SizeConfig.screenWidth,
                            margin: EdgeInsets.only(left: SizeConfig.width16,right: SizeConfig.width16,top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: SizeConfig.screenWidth,
                                  margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 15,
                                          offset: Offset(0, 0), // changes position of shadow
                                        )
                                      ]
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: SizeConfig.width10,),
                                      Icon(Icons.search,color: AppTheme.hintColor,),
                                      SizedBox(width: SizeConfig.width10,),
                                      Container(
                                        width: SizeConfig.screenWidth*0.45,
                                        child: TextField(
                                          style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              focusedErrorBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              hintText: "Search",
                                              hintStyle: AppTheme.hintText
                                          ),
                                          onChanged: (v){
                                            pn.searchMaterial(v);

                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 250,
                                  width: SizeConfig.screenWidth,

                                  margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,top: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.white,
                                      border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                  ),
                                  child: ListView.builder(
                                    itemCount: pn.filtermaterialList.length,
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            indentQty='';
                                            disValue='';
                                            discountKeyPad=false;
                                            pn.isDiscountPercentage=true;
                                            pn.invoiceMaterialMappingList.add(
                                                InvoiceMaterialMappingListModel(
                                                    InvoiceMaterialMappingId:null,
                                                    InvoiceId:null,
                                                    MaterialId:pn.filtermaterialList[index].materialId,
                                                    materialName:pn.filtermaterialList[index].materialName,
                                                    MaterialPrice:pn.filtermaterialList[index].materialPrice,
                                                    PurchaseQuantity:0,
                                                    Subtotal:0.0,
                                                    IsDiscount:0,
                                                    IsPercentage:0,
                                                    IsAmount:0,
                                                    DiscountValue:0.0,
                                                    DiscountAmount:0.0,
                                                    TaxValue:pn.filtermaterialList[index].taxValue,
                                                    TaxAmount:0.0,
                                                    TotalAmount:0.0,
                                                    IsActive:1,
                                                    materialUnitId:pn.filtermaterialList[index].materialUnitId,
                                                    unitName:pn.filtermaterialList[index].unitName,
                                                    purchaseQty: TextEditingController()..text=""
                                                )
                                            );
                                          });

                                          showDialog(context: context,
                                              // barrierDismissible: false,

                                              builder: (context){
                                                return StatefulBuilder(
                                                  builder:(context,setState){
                                                    return Consumer<InvoiceNotifier>(
                                                      builder: (context,pn,child)=>Dialog(
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), ),

                                                        child: Container(
                                                          height: SizeConfig.screenHeight*0.85,
                                                          width: SizeConfig.screenWidth*0.9,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Colors.white
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: 15,),
                                                              Text("${pn.invoiceMaterialMappingList[pn.invoiceMaterialMappingList.length-1].materialName??""}",
                                                                style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),
                                                              SizedBox(height: 10,),
                                                              discountKeyPad?
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text("${indentQty.isEmpty?"0":indentQty} ${pn.invoiceMaterialMappingList[pn.invoiceMaterialMappingList.length-1].unitName??""}",
                                                                    style: TextStyle(fontFamily: 'RL',fontSize: 16,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),
                                                                  SizedBox(width: 20,),

                                                                  Text("${disValue.isEmpty?"0":disValue}",
                                                                    style: TextStyle(fontFamily: 'RM',fontSize: 20,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),
                                                                  SizedBox(width: 20,),
                                                                  GestureDetector(
                                                                    onTap: (){
                                                                      pn.updateisDiscountPercentage(false);

                                                                    },
                                                                    child: AnimatedContainer(
                                                                      duration: Duration(milliseconds: 200),
                                                                      curve: Curves.easeIn,
                                                                      height: 35,
                                                                      width: 35,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          border: Border.all(color: pn.isDiscountPercentage?AppTheme.addNewTextFieldBorder:Colors.transparent),
                                                                          color: pn.isDiscountPercentage?AppTheme.EFEFEF:AppTheme.addNewTextFieldFocusBorder
                                                                      ),
                                                                      child: Center(
                                                                        child: Text("₹",style: pn.isDiscountPercentage?AppTheme.discountDeactive:AppTheme.discountactive,),
                                                                      ),

                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 10,),
                                                                  GestureDetector(
                                                                    onTap: (){
                                                                      pn.updateisDiscountPercentage(true);
                                                                      /* if(discountCont.text.isEmpty){
                                                                                                In.vendorMaterialDiscountCalc(key,"");
                                                                                              }
                                                                                              else{
                                                                                                In.vendorMaterialDiscountCalc(key,discountCont.text);
                                                                                              }*/

                                                                    },
                                                                    child: AnimatedContainer(
                                                                      duration: Duration(milliseconds: 200),
                                                                      curve: Curves.easeIn,
                                                                      height: 35,
                                                                      width: 35,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          border: Border.all(color: pn.isDiscountPercentage?Colors.transparent:AppTheme.addNewTextFieldBorder),
                                                                          color: pn.isDiscountPercentage?AppTheme.addNewTextFieldFocusBorder:AppTheme.EFEFEF
                                                                      ),
                                                                      child: Center(

                                                                        child: Text("%",style: pn.isDiscountPercentage?AppTheme.discountactive:AppTheme.discountDeactive,),
                                                                      ),

                                                                    ),
                                                                  ),
                                                                ],
                                                              ):




                                                              Text("${indentQty.isEmpty?"0":indentQty} ${pn.invoiceMaterialMappingList[pn.invoiceMaterialMappingList.length-1].unitName??""}",
                                                                style: TextStyle(fontFamily: 'RM',fontSize: 20,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),

                                                              Container(
                                                                  margin: EdgeInsets.only(top: 20),
                                                                  width: SizeConfig.screenWidth*0.8,
                                                                  child: Wrap(
                                                                      spacing: 10,
                                                                      runSpacing: 10,
                                                                      direction: Axis.horizontal,
                                                                      alignment: WrapAlignment.center,
                                                                      children: numbers
                                                                          .asMap().map((i, element) => MapEntry(i,
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                              setState(() {
                                                                                if (numbers[i] == 'X') {

                                                                                  if(!discountKeyPad){
                                                                                    indentQty = indentQty.substring(0, indentQty.length - 1);
                                                                                  } else{
                                                                                    disValue = disValue.substring(0, disValue.length - 1);
                                                                                  }

                                                                                  reorderLevelIndex=i;
                                                                                }
                                                                                else if (numbers[i] == '.') {


                                                                                  if(!discountKeyPad){
                                                                                    if(indentQty.length<6 && indentQty.length>=1){
                                                                                      if(indentQty.contains('.')){}
                                                                                      else{
                                                                                        setState(() {
                                                                                          indentQty=indentQty+'.';
                                                                                        });
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                  else{
                                                                                    if(disValue.length<4 && disValue.length>=1){
                                                                                      if(disValue.contains('.')){}
                                                                                      else{
                                                                                        setState(() {
                                                                                          disValue=disValue+'.';
                                                                                        });
                                                                                      }
                                                                                    }
                                                                                  }

                                                                                  reorderLevelIndex=i;
                                                                                }
                                                                                else {

                                                                                  if(!discountKeyPad){
                                                                                    if(indentQty.isEmpty && numbers[i]=='0'){}
                                                                                    else{
                                                                                      setState(() {
                                                                                        reorderLevelIndex = i;
                                                                                      });
                                                                                      if(indentQty.length<6){
                                                                                        setState(() {
                                                                                          indentQty=indentQty+numbers[i];
                                                                                        });
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                  else{
                                                                                    if(disValue.isEmpty && numbers[i]=='0'){}
                                                                                    else{
                                                                                      setState(() {
                                                                                        reorderLevelIndex = i;
                                                                                      });
                                                                                      if(disValue.length<4){
                                                                                        setState(() {
                                                                                          disValue=disValue+numbers[i];
                                                                                        });
                                                                                      }
                                                                                    }
                                                                                  }


                                                                                }
                                                                              });
                                                                              Timer(Duration(milliseconds: 300), (){
                                                                                setState((){
                                                                                  reorderLevelIndex=-1;
                                                                                });
                                                                              });
                                                                            },
                                                                            child: AnimatedContainer(
                                                                                height: SizeConfig.screenWidth*0.19,
                                                                                width: SizeConfig.screenWidth*0.19,
                                                                                duration: Duration(milliseconds: 200),
                                                                                curve: Curves.easeIn,
                                                                                decoration: BoxDecoration(
                                                                                  color: reorderLevelIndex == i?AppTheme.yellowColor:AppTheme.unitSelectColor,
                                                                                  border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                child: Center(
                                                                                    child: Text(numbers[i],
                                                                                      style: TextStyle(fontFamily: 'RR', color:reorderLevelIndex == i?Colors.white:AppTheme.gridTextColor, fontSize: 28,),
                                                                                      textAlign: TextAlign.center,
                                                                                    )
                                                                                )
                                                                            ),
                                                                          )))
                                                                          .values
                                                                          .toList()
                                                                  )
                                                              ),
                                                              SizedBox(height: 10,),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Checkbox(
                                                                      activeColor: AppTheme.addNewTextFieldFocusBorder,
                                                                      value: discountKeyPad,
                                                                      // value: qn.PO_purchaseList[qn.PO_purchaseList.length-1].isDiscount==0?false:true,
                                                                      onChanged: (v){
                                                                        setState((){

                                                                          discountKeyPad=v;
                                                                        });
                                                                        // if(v){
                                                                        //   qn.PO_updateIsDiscountFromQtyDialog(qn.PO_purchaseList.length-1,1,disValue,indentQty);
                                                                        // }else{
                                                                        //   qn.PO_updateIsDiscountFromQtyDialog(qn.PO_purchaseList.length-1,0,'0',indentQty);
                                                                        // }

                                                                      }
                                                                  ),

                                                                  Text("Discount",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.addNewTextFieldFocusBorder))

                                                                ],
                                                              ),
                                                              SizedBox(height: 10,),
                                                              GestureDetector(
                                                                onTap: (){
                                                                  pn.updateIsDiscountFromQtyShowDialog(pn.invoiceMaterialMappingList.length-1,disValue,indentQty);
                                                                  //  qn.PO_updateIsDiscountFromQtyDialog(qn.PO_purchaseList.length-1,disValue,indentQty);

                                                                  // if(indentQty.isNotEmpty){
                                                                  //   qn.PO_updateIsDiscountFromQtyDialog(qn.PO_purchaseList.length-1,disValue,indentQty);
                                                                  //  // qn.updatePO_purchaseListFromQuantityDialog(qn.PO_purchaseList.length-1,indentQty);
                                                                  // }

                                                                  Navigator.pop(context);

                                                                },
                                                                child: Container(
                                                                  height: 50,
                                                                  width: 150,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      color: AppTheme.yellowColor
                                                                  ),
                                                                  child: Center(
                                                                    child: Text("Done",style: AppTheme.TSWhite20,),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: (){
                                                                  pn.removepurchaseOrdersMappingList(pn.invoiceMaterialMappingList.length-1);
                                                                  Navigator.pop(context);

                                                                },
                                                                child: Container(
                                                                  height: 50,
                                                                  width: 150,
                                                                  child: Center(
                                                                    child: Text("Cancel",style: TextStyle(fontFamily: 'RL',fontSize: 20,color: Color(0xFFA1A1A1))),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                          );

                                        },
                                        child: Container(
                                          height: 40,
                                          width: SizeConfig.screenWidth,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: SizeConfig.width10),
                                          decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(color: AppTheme.addNewTextFieldBorder))
                                          ),
                                          child: Text("${pn.filtermaterialList[index].materialName}",
                                            style: TextStyle(fontFamily: 'RR',fontSize: 16,color: AppTheme.addNewTextFieldText.withOpacity(0.5)),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),

                          Positioned(
                            right: 8,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  materialsListOpen=false;
                                });
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.yellowColor
                                ),
                                child: Center(
                                  child: Icon(Icons.clear,color: AppTheme.bgColor,),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  materialsListOpen=false;
                                });
                                listViewController.jumpTo(listViewController.position.maxScrollExtent);
                              },
                              child: Container(
                                height: 70,
                                width: 70,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.yellowColor
                                ),
                                child:Stack(
                                  children: [
                                    Align(
                                        alignment:Alignment.center,
                                        child: Icon(Icons.shopping_cart,color: Colors.white,size: 30,)
                                    ),
                                    Positioned(
                                        top: 10,
                                        right: 10,
                                        child: Container(
                                          // width: 20,
                                          // height: 20,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red
                                          ),
                                          child: Center(
                                            child: Text("${pn.invoiceMaterialMappingList.length}",style: TextStyle(fontFamily: 'RR',color: Colors.white),),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),


///////////////////////////////////////      OTHER CHARGES  ////////////////////////////////
                Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      width: SizeConfig.screenWidth,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                      transform: Matrix4.translationValues(otherChargeAmountOpen?0:SizeConfig.screenWidth, 0, 0),

                      child:Container(
                        height:250,
                        width: SizeConfig.screenWidth,
                        color: Colors.white,
                        //  padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),
                        child:Column (
                            children: [
                              SizedBox(height: 40,),
                              Container(
                                height: 50,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child:Container(
                                        height: 50,
                                        width: SizeConfig.screenWidth,
                                        margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            /*      border: Border.all(color: AppTheme.addNewTextFieldBorder),*/
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 15,
                                                offset: Offset(0, 0), // changes position of shadow
                                              )
                                            ]
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(left: 20),
                                              width: SizeConfig.screenWidth*0.52,
                                              child: TextField(
                                                controller: otherChargesTextFieldOpen?otherChargeAmount:otherChargeName,
                                                style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    focusedErrorBorder: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                    hintText: otherChargesTextFieldOpen?"Charge Amount":"Charge Name",
                                                    hintStyle: AppTheme.hintText
                                                ),
                                                inputFormatters: [
                                                  if(otherChargesTextFieldOpen)
                                                    FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                // keyboardType: otherChargesTextFieldOpen?TextInputType.number:TextInputType.text,
                                              ),
                                            ),
                                            SizedBox(width: SizeConfig.width10,),
                                            GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  otherChargesTextFieldOpen=!otherChargesTextFieldOpen;
                                                });
                                              },
                                              child: Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppTheme.yellowColor
                                                ),
                                                child: Center(
                                                  child:otherChargesTextFieldOpen?Icon(Icons.clear,color: AppTheme.bgColor,size: 20,):
                                                  Text("₹",style: AppTheme.bgColorTS,),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: SizeConfig.width10,),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 30,),
                              GestureDetector(
                                onTap: (){
                                  node.unfocus();

                                  setState(() {
                                    pn.invoiceOtherChargesMappingList.add(
                                        InvoiceOtherChargesMappingList(
                                            InvoiceOtherChargesMappingId: null,
                                            InvoiceId: null,
                                            OtherChargesName: otherChargeName.text,
                                            OtherChargesAmount: otherChargeAmount.text.isEmpty?0.0:double.parse(otherChargeAmount.text),
                                            IsActive: 1
                                        )
                                    );
                                  });
                                  pn.overAllTotalCalc();

                                  Timer(Duration(milliseconds: 100), (){
                                    setState(() {
                                      otherChargeAmountOpen=false;
                                      otherChargesTextFieldOpen=false;
                                      otherChargeAmount.clear();
                                      otherChargeName.clear();
                                    });
                                  });


                                },
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: AppTheme.yellowColor
                                  ),
                                  child: Center(
                                    child: Text("Done",style:TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 20),),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  node.unfocus();
                                  Timer(Duration(milliseconds: 100), (){
                                    setState(() {
                                      otherChargeAmountOpen=false;
                                      otherChargesTextFieldOpen=false;
                                      otherChargeAmount.clear();
                                      otherChargeName.clear();
                                    });
                                  });


                                },
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  child: Center(
                                    child: Text("Cancel",style: TextStyle(fontFamily: 'RL',fontSize: 20,color: Color(0xFFA1A1A1))),
                                  ),
                                ),
                              ),




                            ]


                        ),
                      )
                  ),
                ),

              ],
            )
        )

    );
  }
}






