import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/purchaseDetailsModel/PurchaseOrderOtherChargesMappingListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseOrderMaterialMappingListModel.dart';
import 'package:quarry/notifier/purchaseNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/utils/widgetUtils.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/expectedDateContainer.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpSearchOnly.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';
import 'package:quarry/widgets/singleDatePicker.dart';
import 'package:quarry/widgets/validationErrorText.dart';


class PurchaseOrdersAddNew extends StatefulWidget {
  @override
  PurchaseOrdersAddNewState createState() => PurchaseOrdersAddNewState();
}

class PurchaseOrdersAddNewState extends State<PurchaseOrdersAddNew> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();
  bool _keyboardVisible = false;


 // ScrollController? scrollController;
 // ScrollController? listViewController;

  bool isPlantOpen=false;
  bool supplierTypeOpen=false;
  bool suppliersListOpen=false;
  bool materialsListOpen=false;

  bool supplierType=false;
  bool supplierId=false;
  bool plant=false;

  //for keyboard
  int reorderLevelIndex=-1;
  List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "X", "0", "."];
  String indentQty="";
  String disValue="";
  bool? discountKeyPad=false;

  bool discountValueError=false;

  TextEditingController otherChargeName=new TextEditingController();
  TextEditingController otherChargeAmount=new TextEditingController();
  bool otherChargeAmountOpen=false;

  bool otherChargesTextFieldOpen=false;

  bool deleteOpen=false;
  int selectedMaterialIndex=-1;

  TextEditingController searchController=new TextEditingController();

  /*  For DataTable   */
  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();
  bool showShadow=false;
  double valueContainerWidth=100;
  double dataTableheight=300;
  double dataTableBodyheight=250;
  List<String> gridcol=["Material","Qty","Price","Sub Total","Tax","Total",];

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


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
    final node=FocusScope.of(context);
    SizeConfig().init(context);
    return Scaffold(
        key: scaffoldkey,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppTheme.yellowColor,
        body: Consumer<PurchaseNotifier>(
            builder: (context,pn,child)=> Stack(
              children: [

                AddNewLayout(
                  child:!pn.isPurchaseView? ListView(
                    //controller: listViewController,
                    scrollDirection: Axis.vertical,
                   // physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),

                    children: [
                      SizedBox(height: 20,),
                      Container(

                          margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,),
                          padding: EdgeInsets.only(left:SizeConfig.width10!,),
                          height: 50,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: AppTheme.addNewTextFieldBorder),
                              color: AppTheme.disableColor
                          ),
                          child:  Text("${DateFormat.yMMMd().format(pn.PurchaseDate)} / ${DateFormat().add_jm().format(pn.PurchaseDate)}",
                            style: AppTheme.bgColorTS,
                          )

                      ),
                      GestureDetector(
                        onTap: (){

                          if(!pn.isPurchaseEdit){
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
                          if(pn.purchaseOrdersMappingList.isEmpty){
                            setState(() {
                              supplierTypeOpen=true;
                            });
                          }
                          else{
                            CustomAlert(
                                callback: (){
                                  Navigator.pop(context);
                                  setState(() {
                                    pn.purchaseOrdersMappingList.clear();
                                    selectedMaterialIndex=-1;
                                    supplierTypeOpen=true;
                                  });
                                },
                                Cancelcallback: (){
                                  Navigator.pop(context);
                                  setState(() {
                                    selectedMaterialIndex=-1;
                                  });
                                }
                            ).yesOrNoDialog(context, "", "Do you want to delete All Material?");
                          }


                        },
                        child: SidePopUpParent(
                          text: pn.supplierType==null? "Select Supplier Type":pn.supplierType,
                          textColor: pn.supplierType==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                          iconColor: pn.supplierType==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                          bgColor: pn.supplierType==null? AppTheme.disableColor:Colors.white,
                        ),
                      ),
                      !supplierType?Container():ValidationErrorText(title: "* Select Supplier Type",),
                      GestureDetector(
                        onTap: (){
                          node.unfocus();
                          if(pn.supplierType==null){
                            CustomAlert().commonErrorAlert(context, "Select Supplier Type", "");
                          }
                          else{
                            if(pn.purchaseOrdersMappingList.isEmpty){
                              setState(() {
                                suppliersListOpen=true;
                              });
                            }
                            else{
                              CustomAlert(
                                  callback: (){
                                    Navigator.pop(context);
                                    setState(() {
                                      pn.purchaseOrdersMappingList.clear();
                                      selectedMaterialIndex=-1;
                                      suppliersListOpen=true;
                                    });
                                  },
                                  Cancelcallback: (){
                                    Navigator.pop(context);
                                    setState(() {
                                      selectedMaterialIndex=-1;
                                    });
                                  }
                              ).yesOrNoDialog(context, "", "Do you want to delete All Material?");
                            }
                          }


                        },
                        child: SidePopUpParent(
                          text: pn.supplierName==null? "Select Supplier":pn.supplierName,
                          textColor: pn.supplierName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                          iconColor: pn.supplierName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                          bgColor: pn.supplierName==null? AppTheme.disableColor:Colors.white,
                        ),
                      ),
                      !supplierId?Container():ValidationErrorText(title: "* Select Supplier",),
                      GestureDetector(
                        onTap: () async{
                          final DateTime? picked = await showDatePicker2(
                              context: context,
                              initialDate:  pn.ExpectedPurchaseDate==null?DateTime.now():pn.ExpectedPurchaseDate!, // Refer step 1
                              firstDate: DateTime.now(),
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
                              pn.ExpectedPurchaseDate = picked;
                            });
                        },
                        child: ExpectedDateContainer(
                          text: pn.ExpectedPurchaseDate==null?"Expected Date":"${DateFormat.yMMMd().format(pn.ExpectedPurchaseDate!)}",
                          textColor: pn.ExpectedPurchaseDate==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        height: 30,
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.only(left: SizeConfig.width10!,right: SizeConfig.width20!),
                        child: Row(
                          children: [


                            Spacer(),
                            Checkbox(
                                fillColor: MaterialStateColor.resolveWith((states) => AppTheme.yellowColor),
                                value: pn.isTax,
                                onChanged: (v){
                                  setState(() {
                                    pn.isTax=v;
                                  });
                                  for(int i=0;i<pn.purchaseOrdersMappingList.length;i++)
                                    pn.purchaseOrdersCalc(i, pn.purchaseOrdersMappingList[i].purchaseQty!.text);

                                }
                            ),
                            InkWell(
                                onTap: (){
                                  /*setState(() {
                                                                  qn.isDiscount=!qn.isDiscount;
                                                                });*/
                                },
                                child: Text("Is Tax?", style:  TextStyle(fontFamily: 'RR',fontSize: 16,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),)
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),

                      //Material Data Table
                      pn.purchaseOrdersMappingList.isEmpty? Column(
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
                              if(pn.supplierId!=null){
                                setState(() {
                                  materialsListOpen=true;
                                });
                              }
                              else{
                                CustomAlert().commonErrorAlert(context, "Select Supplier", "");
                              }

                            },
                            child: Container(
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
                          margin: EdgeInsets.only(left:SizeConfig.screenWidth!*0.02,right:SizeConfig.screenWidth!*0.02),
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
                                      width: SizeConfig.screenWidth!-valueContainerWidth-SizeConfig.screenWidth!*0.04,
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
                                      width: SizeConfig.screenWidth!-valueContainerWidth-SizeConfig.screenWidth!*0.04,
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
                                                children:pn.purchaseOrdersMappingList.asMap().
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
                                                                    indentQty=value.purchaseQty!.text;
                                                                    disValue=value.DiscountValue!>0?value.DiscountValue.toString():'';
                                                                    discountKeyPad=false;
                                                                    pn.isDiscountPercentage=value.IsDiscount==1?value.IsPercentage==1?true:false:true;

                                                                  });

                                                                  showDialog(context: context,
                                                                      barrierDismissible: false,
                                                                      builder: (context){
                                                                        return StatefulBuilder(
                                                                          builder:(context,setState){
                                                                            return Consumer<PurchaseNotifier>(
                                                                              builder: (context,pn,child)=>Dialog(
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), ),

                                                                                child: Container(
                                                                                  height: SizeConfig.screenHeight!*0.85,

                                                                                  width: SizeConfig.screenWidth!*0.9,
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
                                                                                      discountKeyPad!?
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
                                                                                          width: SizeConfig.screenWidth!*0.8,
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

                                                                                                          if(!discountKeyPad!){
                                                                                                            indentQty = indentQty.substring(0, indentQty.length - 1);
                                                                                                          } else{
                                                                                                            disValue = disValue.substring(0, disValue.length - 1);
                                                                                                          }

                                                                                                          reorderLevelIndex=i;
                                                                                                        }
                                                                                                        else if (numbers[i] == '.') {


                                                                                                          if(!discountKeyPad!){
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

                                                                                                          if(!discountKeyPad!){
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
                                                                                                        height: SizeConfig.screenWidth!*0.19,
                                                                                                        width: SizeConfig.screenWidth!*0.19,
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
                                                                      child: Text("${value.purchaseQty!.text.toString()}",
                                                                        //style:AppTheme.ML_bgCT,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: valueContainerWidth,
                                                          alignment: Alignment.center,
                                                          child: Text("${value.MaterialPrice}",
                                                            style:selectedMaterialIndex==index?AppTheme.TSWhite16:AppTheme.ML_bgCT,
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment.center,
                                                          width: valueContainerWidth,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text("${value.Amount}",
                                                                style:AppTheme.ML_bgCT,
                                                              ),
                                                              value.IsDiscount==1?SizedBox(height: 3,):Container(),
                                                              value.IsDiscount==1?Text("${value.DiscountValue} ${value.IsPercentage==1?"%":"Rs"}",
                                                                style:TextStyle(fontFamily: 'RR',fontSize: 12,color: AppTheme.addNewTextFieldText),
                                                              ):Container(),
                                                            ],
                                                          ),
                                                        ),

                                                        Container(
                                                          width: valueContainerWidth,
                                                          alignment: Alignment.center,
                                                          child: Text("${value.TaxAmount}",
                                                            style:selectedMaterialIndex==index?AppTheme.TSWhite16:AppTheme.ML_bgCT,
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
                                              color: AppTheme.addNewTextFieldText.withOpacity(0.2),
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
                                              children: pn.purchaseOrdersMappingList.asMap().
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
                                  padding: EdgeInsets.only(right: SizeConfig.screenWidth!*0.04),
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
                                              width: SizeConfig.screenWidth!*0.6,
                                              alignment: Alignment.centerRight,
                                              child: Text("Subtotal: ",style: AppTheme.gridTextColorTS,)
                                          ),
                                          Spacer(),
                                          Text("${formatCurrency.format(pn.subtotal)}  ",style: AppTheme.gridTextColorTS,)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              height:25,
                                              width: SizeConfig.screenWidth!*0.6,
                                              alignment: Alignment.centerRight,
                                              child: Text("Discount: ",style: AppTheme.gridTextColorTS,)
                                          ),
                                          Spacer(),
                                          Text("-${formatCurrency.format(pn.discountAmount)}  ",style: AppTheme.gridTextColorTS,)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              height:25,
                                              width: SizeConfig.screenWidth!*0.6,
                                              alignment: Alignment.centerRight,
                                              child: Text("GST: ",style: AppTheme.gridTextColorTS,)
                                          ),
                                          Spacer(),
                                          Text("${formatCurrency.format(pn.taxAmount)}  ",style: AppTheme.gridTextColorTS,)
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Container(
                                              height:25,
                                              width: SizeConfig.screenWidth!*0.6,
                                              alignment: Alignment.centerRight,
                                              child: Text("Other Charges: ",style: AppTheme.gridTextColorTS,)
                                          ),
                                          Spacer(),
                                          Text("${formatCurrency.format(pn.otherCharges)}  ",style: AppTheme.gridTextColorTS,)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              height:25,
                                              width: SizeConfig.screenWidth!*0.6,
                                              alignment: Alignment.centerRight,
                                              child: Text("Total: ",style: TextStyle(fontFamily: 'RR',fontSize: 20,color: Colors.green),)
                                          ),
                                          Spacer(),
                                          Text("${formatCurrency.format(pn.grandTotal)}  ",style: TextStyle(fontFamily: 'RR',fontSize: 20,color: Colors.green),)
                                        ],
                                      ),
                                    ],
                                  ),

                                ),
                              )




                            ],
                          )







                      ),

                      SizedBox(height: SizeConfig.height200,)
                    ],
                  ):
                  //VIEW
                  ListView(
                    // controller: listViewController,
                     scrollDirection: Axis.vertical,
                    // physics: isListScroll?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),

                    children: [
                      Container(

                          margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,),
                          padding: EdgeInsets.only(left:SizeConfig.width10!,),
                          height: 50,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: AppTheme.addNewTextFieldBorder),
                              color: AppTheme.disableColor
                          ),
                          child:  Text("${DateFormat.yMMMd().format(pn.PurchaseDate)} / ${DateFormat().add_jm().format(pn.PurchaseDate)}",
                            style: AppTheme.bgColorTS,
                          )

                      ),
                      GestureDetector(
                        onTap: (){





                        },
                        child: SidePopUpParent(
                          text: pn.PlantName==null? "Select Plant":pn.PlantName,
                          textColor: pn.PlantName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                          iconColor: pn.PlantName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                          bgColor: pn.PlantName==null? AppTheme.disableColor:Colors.white,

                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                        },
                        child: SidePopUpParent(
                          text: pn.supplierType==null? "Select Supplier Type":pn.supplierType,
                          textColor: pn.supplierType==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                          iconColor: pn.supplierType==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                          bgColor: pn.supplierType==null? AppTheme.disableColor:Colors.white,
                        ),
                      ),
                      !supplierType?Container():ValidationErrorText(title: "* Select Supplier Type",),
                      GestureDetector(
                        onTap: (){
                        },
                        child: SidePopUpParent(
                          text: pn.supplierName==null? "Select Supplier":pn.supplierName,
                          textColor: pn.supplierName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                          iconColor: pn.supplierName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                          bgColor: pn.supplierName==null? AppTheme.disableColor:Colors.white,
                        ),
                      ),
                      !supplierId?Container():ValidationErrorText(title: "* Select Supplier",),
                      GestureDetector(
                        onTap: () async{

                        },
                        child: ExpectedDateContainer(
                          text: pn.ExpectedPurchaseDate==null?"Expected Date":"${DateFormat.yMMMd().format(pn.ExpectedPurchaseDate!)}",
                          textColor: pn.ExpectedPurchaseDate==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                        ),
                      ),
                      SizedBox(height: SizeConfig.height20,),
                      Container(
                        height: SizeConfig.height30,
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.only(left: SizeConfig.width10!,right: SizeConfig.width20!),
                        child: Row(
                          children: [


                            Spacer(),
                            Checkbox(
                                fillColor: MaterialStateColor.resolveWith((states) => AppTheme.yellowColor),
                                value: pn.isTax,
                                onChanged: (v){

                                }
                            ),
                            InkWell(
                                onTap: (){
                                  /*setState(() {
                                                                  qn.isDiscount=!qn.isDiscount;
                                                                });*/
                                },
                                child: Text("Is Tax?", style:  TextStyle(fontFamily: 'RR',fontSize: 16,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),)
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.height20,),

                      //Material Data Table
                      pn.purchaseOrdersMappingList.isEmpty? Column(
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
                              if(pn.supplierId!=null){
                                setState(() {
                                  materialsListOpen=true;
                                });
                              }
                              else{
                                CustomAlert().commonErrorAlert(context, "Select Supplier", "");
                              }

                            },
                            child: Container(
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
                          margin: EdgeInsets.only(left:SizeConfig.screenWidth!*0.02,right:SizeConfig.screenWidth!*0.02),
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
                                      width: SizeConfig.screenWidth!-valueContainerWidth-SizeConfig.screenWidth!*0.04,
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
                                      width: SizeConfig.screenWidth!-valueContainerWidth-SizeConfig.screenWidth!*0.04,
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
                                                children:pn.purchaseOrdersMappingList.asMap().
                                                map((index, value) => MapEntry(
                                                    index,InkWell(
                                                  onTap: (){

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
                                                                      child: Text("${value.purchaseQty!.text.toString()}",
                                                                        //style:AppTheme.ML_bgCT,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: valueContainerWidth,
                                                          alignment: Alignment.center,
                                                          child: Text("${value.MaterialPrice}",
                                                            style:selectedMaterialIndex==index?AppTheme.TSWhite16:AppTheme.ML_bgCT,
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment.center,
                                                          width: valueContainerWidth,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text("${value.Amount}",
                                                                style:AppTheme.ML_bgCT,
                                                              ),
                                                              value.IsDiscount==1?SizedBox(height: 3,):Container(),
                                                              value.IsDiscount==1?Text("${value.DiscountValue} ${value.IsPercentage==1?"%":"Rs"}",
                                                                style:TextStyle(fontFamily: 'RR',fontSize: 12,color: AppTheme.addNewTextFieldText),
                                                              ):Container(),
                                                            ],
                                                          ),
                                                        ),

                                                        Container(
                                                          width: valueContainerWidth,
                                                          alignment: Alignment.center,
                                                          child: Text("${value.TaxAmount}",
                                                            style:selectedMaterialIndex==index?AppTheme.TSWhite16:AppTheme.ML_bgCT,
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
                                              color: AppTheme.addNewTextFieldText.withOpacity(0.2),
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
                                              children: pn.purchaseOrdersMappingList.asMap().
                                              map((index, value) => MapEntry(
                                                  index,InkWell(
                                                onTap: (){

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
                                  padding: EdgeInsets.only(right: SizeConfig.screenWidth!*0.04),
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
                                              width: SizeConfig.screenWidth!*0.6,
                                              alignment: Alignment.centerRight,
                                              child: Text("Subtotal: ",style: AppTheme.gridTextColorTS,)
                                          ),
                                          Spacer(),
                                          Text("${formatCurrency.format(pn.subtotal)}  ",style: AppTheme.gridTextColorTS,)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              height:25,
                                              width: SizeConfig.screenWidth!*0.6,
                                              alignment: Alignment.centerRight,
                                              child: Text("Discount: ",style: AppTheme.gridTextColorTS,)
                                          ),
                                          Spacer(),
                                          Text("-${formatCurrency.format(pn.discountAmount)}  ",style: AppTheme.gridTextColorTS,)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              height:25,
                                              width: SizeConfig.screenWidth!*0.6,
                                              alignment: Alignment.centerRight,
                                              child: Text("GST: ",style: AppTheme.gridTextColorTS,)
                                          ),
                                          Spacer(),
                                          Text("${formatCurrency.format(pn.taxAmount)}  ",style: AppTheme.gridTextColorTS,)
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Container(
                                              height:25,
                                              width: SizeConfig.screenWidth!*0.6,
                                              alignment: Alignment.centerRight,
                                              child: Text("Other Charges: ",style: AppTheme.gridTextColorTS,)
                                          ),
                                          Spacer(),
                                          Text("${formatCurrency.format(pn.otherCharges)}  ",style: AppTheme.gridTextColorTS,)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              height:25,
                                              width: SizeConfig.screenWidth!*0.6,
                                              alignment: Alignment.centerRight,
                                              child: Text("Total: ",style: TextStyle(fontFamily: 'RR',fontSize: 20,color: Colors.green),)
                                          ),
                                          Spacer(),
                                          Container(
                                              height:20,
                                              width: SizeConfig.screenWidth!*0.35,
                                              alignment: Alignment.centerRight,
                                              child: FittedBox(child: Text("${formatCurrency.format(pn.grandTotal)}  ",style: TextStyle(fontFamily: 'RR',fontSize: 20,color: Colors.green),)))
                                        ],
                                      ),
                                    ],
                                  ),

                                ),
                              )




                            ],
                          )







                      ),
                      SizedBox(height: SizeConfig.height200,)
                    ],
                  ),
                  actionWidget: Container(
                      height: 50,
                      width: SizeConfig.screenWidth,
                      child: Row(
                        children: [
                          CancelButton(
                            ontap: (){
                              pn.clearForm();
                              Navigator.pop(context);
                            },
                          ),

                          Text("Purchase Orders",
                            style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                          ),
                          pn.isPurchaseView? Text(" / View",
                            style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                          ):Text(pn.isPurchaseEdit?" / Edit":" / Add New",
                            style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                ),







                //bottomNav
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
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
                        CustomPaint(
                          size: Size( SizeConfig.screenWidth!, 65),
                          painter: RPSCustomPainter3(),
                        ),

                        Container(
                          width:  SizeConfig.screenWidth,
                          height: 80,
                          child:pn.isPurchaseView?Container(): Stack(

                            children: [

                              pn.purchaseOrdersMappingList.isNotEmpty?AnimatedPositioned(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.bounceOut,
                                left: 5,
                                bottom:deleteOpen? -60:3,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          otherChargeAmountOpen=true;
                                        });
                                      },
                                        child: Container(
                                          height: 50,
                                            width: 130,
                                            child: FittedBox(child: Image.asset("assets/bottomIcons/other-charges-text-icon.png")
                                            )
                                        )
                                    )
                                ),
                              ):Container(),

                              AnimatedPositioned(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.bounceInOut,
                                bottom: deleteOpen? 5:-60,

                                  child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          deleteOpen=false;
                                        });
                                        CustomAlert(
                                            callback: (){
                                              Navigator.pop(context);
                                              setState(() {
                                                pn.purchaseOrdersMappingList.clear();
                                                selectedMaterialIndex=-1;
                                              });
                                            },
                                            Cancelcallback: (){
                                              Navigator.pop(context);
                                              setState(() {
                                                selectedMaterialIndex=-1;
                                              });
                                            }
                                        ).yesOrNoDialog(context, "", "Do you want to Delete All Material?");
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 130,
                                          child: FittedBox(child: Image.asset("assets/bottomIcons/delete-all-text-icon.png"))
                                      )
                                  )
                              ),

                              pn.purchaseOrdersMappingList.isNotEmpty?AnimatedPositioned(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.bounceOut,
                                right: 5,
                                bottom:deleteOpen? -60:3,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                        onTap: (){

                                          setState(() {
                                            materialsListOpen=true;
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                            width: 130,
                                            child: FittedBox(child: Image.asset("assets/bottomIcons/add-meterial-text.png"))
                                        )
                                    )
                                ),
                              ):Container(),

                              AnimatedPositioned(
                                  bottom: deleteOpen? 5:-60,
                                  right: 0,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.bounceOut,

                                  child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          deleteOpen=false;
                                        });
                                        CustomAlert(
                                         callback: (){
                                           Navigator.pop(context);
                                          setState(() {
                                            pn.purchaseOrdersMappingList.removeAt(selectedMaterialIndex);
                                            selectedMaterialIndex=-1;
                                            pn.overAllTotalCalc();
                                          });
                                        },
                                        Cancelcallback: (){
                                          Navigator.pop(context);
                                          setState(() {
                                            selectedMaterialIndex=-1;
                                          });
                                        }
                                        ).yesOrNoDialog(context, "", "Do you want to Delete Material?");
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 130,
                                          child: FittedBox(child: Image.asset("assets/bottomIcons/delete-text-icon.png"))
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
                      if(!pn.isPurchaseView){
                        node.unfocus();
                        if(pn.PlantId==null || pn.EditPlantId==null){setState(() {plant=true;});}
                        else{setState(() {plant=false;});}

                        if(pn.supplierType==null){setState(() {supplierType=true;});}
                        else{setState(() {supplierType=false;});}

                        if(pn.supplierId==null){setState(() {supplierId=true;});}
                        else{setState(() {supplierId=false;});}

                        if(pn.purchaseOrdersMappingList.isEmpty){
                          CustomAlert().commonErrorAlert(context, "Add Material", "Add materials to make purchase.");
                        }
                        if(!supplierId && !supplierType && pn.purchaseOrdersMappingList.isNotEmpty){
                          pn.InsertPurchaseDbHit(context);
                        }
                      }
                      else{
                        pn.clearForm();
                        Navigator.pop(context);
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
                  height: pn.PurchaseLoader? SizeConfig.screenHeight:0,
                  width: pn.PurchaseLoader? SizeConfig.screenWidth:0,
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





///////////////////////////////////////      SUPPLIER TYPE ////////////////////////////////

                PopUpStatic(
                  title: "Select Supplier Type",
                  isOpen: supplierTypeOpen,
                  dataList: pn.supplierTypeList,
                  propertyKeyName:"SupplierType",
                  propertyKeyId: "SupplierType",
                  selectedId: pn.supplierType,
                  itemOnTap: (index){
                    setState(() {
                      pn.supplierType= pn.supplierTypeList[index].supplierType;
                      pn.filterSuppliersList=pn.suppliersList.where((element) => element.supplierType!.toLowerCase()==pn.supplierType!.toLowerCase()).toList();
                      pn.searchFilterSuppliersList=pn.filterSuppliersList;
                      if(pn.supplierId!=null){
                        pn.supplierId=null;
                        pn.supplierName=null;
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
                PopUpSearchOnly(

                  searchController: searchController,
                  searchHintText: "Search Supplier",
                //  title: "Select Supplier",
                  isOpen: suppliersListOpen,
                //  isAlwaysShown: true,
                  dataList: pn.searchFilterSuppliersList,
                  propertyKeyName:"SupplierName",
                  propertyKeyId: "SupplierId",
                  selectedId: pn.supplierId,
                  searchOnchange: (v){
                    pn.searchSupplier(v);
                  },
                  itemOnTap: (index){
                    node.unfocus();
                    setState(() {
                      pn.supplierId=pn.searchFilterSuppliersList[index].supplierId;
                      pn.supplierName=pn.searchFilterSuppliersList[index].supplierName;
                      if(pn.searchFilterSuppliersList[index].supplierType=='External'){
                        pn.filterMaterialsList=pn.materialsList.where((element) => element.supplierId==pn.searchFilterSuppliersList[index].supplierId
                            && element.SupplierType=='External'
                        ).toList();
                        pn.searchFilterMaterialsList=pn.filterMaterialsList;
                      }
                      else{
                        pn.filterMaterialsList=pn.materialsList.where((element) => element.SupplierType=='Internal').toList();
                        pn.searchFilterMaterialsList=pn.filterMaterialsList;
                      }
                      suppliersListOpen=false;
                      searchController.clear();
                      pn.searchFilterSuppliersList=pn.filterSuppliersList;
                    });
                  },
                  closeOnTap: (){
                    node.unfocus();
                    setState(() {
                      suppliersListOpen=false;
                      searchController.clear();
                    });
                    pn.searchFilterSuppliersList=pn.filterSuppliersList;
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
                      margin: EdgeInsets.only(left: SizeConfig.width25!,right: SizeConfig.width25!),
                      transform: Matrix4.translationValues(materialsListOpen?0:SizeConfig.screenWidth!, 0, 0),
                      alignment: Alignment.topCenter,
                      child:Stack(
                        children: [
                           Container(
                             height: 380,
                             width: SizeConfig.screenWidth,
                             margin: EdgeInsets.only(left: SizeConfig.width16!,right: SizeConfig.width16!,top: 10),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(20),
                               color: Colors.white,
                             ),
                             child: Column(
                               children: [
                                 Container(
                                   height: 50,
                                   width: SizeConfig.screenWidth,
                                   margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!,top: 20),
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
                                         width: SizeConfig.screenWidth!*0.45,
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

                                   margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!,top: 15),
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(3),
                                     color: Colors.white,
                                     border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                   ),
                                   child: ListView.builder(
                                    // itemCount: pn.filterMaterialsList.length,
                                     itemCount: pn.searchFilterMaterialsList.length,
                                     itemBuilder: (context,index){
                                       return GestureDetector(
                                         onTap: (){

                                           if(pn.purchaseOrdersMappingList.any((element) => element.materialName==pn.searchFilterMaterialsList[index].materialName)){
                                             CustomAlert().commonErrorAlert(context, "Material Exists", "");
                                           }
                                           else{
                                             setState(() {
                                               indentQty='';
                                               disValue='';
                                               discountKeyPad=false;
                                               pn.isDiscountPercentage=true;
                                               pn.purchaseOrdersMappingList.add(
                                                   PurchaseOrderMaterialMappingListModel(
                                                       PurchaseOrderMaterialMappingId:null,
                                                       PurchaseOrderId:null,
                                                       MaterialId:pn.searchFilterMaterialsList[index].materialId,
                                                       materialName:pn.searchFilterMaterialsList[index].materialName,
                                                       MaterialPrice:pn.searchFilterMaterialsList[index].materialPrice,
                                                       PurchaseQuantity:0,
                                                       Amount:pn.searchFilterMaterialsList[index].materialPrice,
                                                       IsDiscount:0,
                                                       IsPercentage:0,
                                                       IsAmount:0,
                                                       DiscountValue:0.0,
                                                       DiscountAmount:0.0,
                                                       TaxValue:pn.searchFilterMaterialsList[index].taxValue,
                                                       TaxAmount:0.0,
                                                       TotalAmount:0.0,
                                                       IsActive:1,
                                                       materialUnitId:pn.searchFilterMaterialsList[index].materialUnitId,
                                                       unitName:pn.searchFilterMaterialsList[index].unitName,
                                                       purchaseQty: TextEditingController()..text=""
                                                   )
                                               );
                                             });

                                             showDialog(context: context,
                                                 barrierDismissible: false,

                                                 builder: (context){
                                                   return StatefulBuilder(
                                                     builder:(context,setState){
                                                       return Consumer<PurchaseNotifier>(
                                                         builder: (context,pn,child)=>Dialog(
                                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), ),

                                                           child: Container(
                                                             height: SizeConfig.screenHeight!*0.85,

                                                             width: SizeConfig.screenWidth!*0.9,
                                                             decoration: BoxDecoration(
                                                                 borderRadius: BorderRadius.circular(10),
                                                                 color: Colors.white
                                                             ),
                                                             child: Column(
                                                               children: [
                                                                 Spacer(),
                                                                 //  SizedBox(height: 15,),
                                                                 Text("${pn.purchaseOrdersMappingList[pn.purchaseOrdersMappingList.length-1].materialName??""}",
                                                                   style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),
                                                                 SizedBox(height: 10,),
                                                                 discountKeyPad!?
                                                                 Row(
                                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                                   children: [
                                                                     Text("${indentQty.isEmpty?"0":indentQty} ${pn.purchaseOrdersMappingList[pn.purchaseOrdersMappingList.length-1].unitName??""}",
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




                                                                 Text("${indentQty.isEmpty?"0":indentQty} ${pn.purchaseOrdersMappingList[pn.purchaseOrdersMappingList.length-1].unitName??""}",
                                                                   style: TextStyle(fontFamily: 'RM',fontSize: 20,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),

                                                                 SizedBox(height: 10,),
                                                                 discountValueError?FittedBox(
                                                                   fit: BoxFit.contain,
                                                                   child: Text("* Discount Value should be less than 100%",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.red),
                                                                     textAlign: TextAlign.center,),
                                                                 ):Container(),
                                                                 Container(
                                                                     margin: EdgeInsets.only(top: 20),
                                                                     width: SizeConfig.screenWidth!*0.8,
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

                                                                                     if(!discountKeyPad!){
                                                                                       indentQty = indentQty.substring(0, indentQty.length - 1);
                                                                                     } else{
                                                                                       disValue = disValue.substring(0, disValue.length - 1);
                                                                                     }

                                                                                     reorderLevelIndex=i;
                                                                                   }
                                                                                   else if (numbers[i] == '.') {


                                                                                     if(!discountKeyPad!){
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

                                                                                     if(!discountKeyPad!){
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
                                                                                   height: SizeConfig.screenWidth!*0.19,
                                                                                   width: SizeConfig.screenWidth!*0.19,
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

                                                                     if(pn.isDiscountPercentage){
                                                                       if(disValue.isNotEmpty){
                                                                         if(double.parse(disValue)<100){
                                                                           setState((){
                                                                             discountValueError=false;
                                                                           });
                                                                           pn.updateIsDiscountFromQtyShowDialog(pn.purchaseOrdersMappingList.length-1,disValue,indentQty);
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
                                                                         pn.updateIsDiscountFromQtyShowDialog(pn.purchaseOrdersMappingList.length-1,disValue,indentQty);
                                                                         Navigator.pop(context);
                                                                       }

                                                                     }
                                                                     else {
                                                                       setState((){
                                                                         discountValueError=false;
                                                                       });
                                                                       pn.updateIsDiscountFromQtyShowDialog(pn.purchaseOrdersMappingList.length-1,disValue,indentQty);
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
                                                                     pn.removepurchaseOrdersMappingList(pn.purchaseOrdersMappingList.length-1);
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
                                           }



                                         },
                                         child: Container(
                                           height: 40,
                                           width: SizeConfig.screenWidth,
                                           alignment: Alignment.centerLeft,
                                           padding: EdgeInsets.only(left: SizeConfig.width10!),
                                           decoration: BoxDecoration(
                                             border: Border(bottom: BorderSide(color: AppTheme.addNewTextFieldBorder))
                                           ),
                                           child: Text("${pn.searchFilterMaterialsList[index].materialName}",
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
                              //  scrollController!.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                               // listViewController!.jumpTo(listViewController!.position.maxScrollExtent);
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
                                            child: Text("${pn.purchaseOrdersMappingList.length}",style: TextStyle(fontFamily: 'RR',color: Colors.white),),
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
                      margin: EdgeInsets.only(left: SizeConfig.width30!,right: SizeConfig.width30!),
                      transform: Matrix4.translationValues(otherChargeAmountOpen?0:SizeConfig.screenWidth!, 0, 0),

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
                                        margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!),
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
                                              width: SizeConfig.screenWidth!*0.52,
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
                                    pn.purchaseOrdersOtherChargesMappingList.add(
                                      PurchaseOrderOtherChargesMappingList(
                                        PurchaseOrderOtherChargesMappingId: null,
                                        PurchaseOrderId: null,
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






