import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/purchaseDetailsModel/PurchaseOrderOtherChargesMappingListModel.dart';
import 'package:quarry/model/purchaseDetailsModel/purchaseOrderMaterialMappingListModel.dart';
import 'package:quarry/model/supplierDetailModel/SupplierMaterialMappingListModel.dart';
import 'package:quarry/notifier/machineNotifier.dart';
import 'package:quarry/notifier/purchaseNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/pages/quarryMaster/quarryLocationAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/expectedDateContainer.dart';


class PurchaseOrdersAddNew extends StatefulWidget {
  @override
  PurchaseOrdersAddNewState createState() => PurchaseOrdersAddNewState();
}

class PurchaseOrdersAddNewState extends State<PurchaseOrdersAddNew> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();
  bool _keyboardVisible = false;

  ScrollController scrollController;
  ScrollController listViewController;
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

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


      scrollController.addListener(() {
/*         print("scrollController-${scrollController.offset}");*/
      });

      listViewController.addListener(() {
        if(listViewController.position.userScrollDirection == ScrollDirection.forward){
          print("Down");
        } else
        if(listViewController.position.userScrollDirection == ScrollDirection.reverse){
          print("Up");
          scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
        print("LISt-${listViewController.offset}");
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
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final node=FocusScope.of(context);
    SizeConfig().init(context);
    return Scaffold(
        key: scaffoldkey,
        body: Consumer<PurchaseNotifier>(
            builder: (context,pn,child)=> Stack(
              children: [



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
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          alignment: Alignment.topCenter,
                          child: Container(
                            height:_keyboardVisible?SizeConfig.screenHeight*0.5 :SizeConfig.screenHeight-100,
                            width: SizeConfig.screenWidth,

                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                            ),
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (s){
                                if(s is ScrollStartNotification){
                                }
                              },
                              child: ListView(
                                controller: listViewController,
                                scrollDirection: Axis.vertical,

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
                                    child:  Text("${DateFormat.yMMMd().format(pn.PurchaseDate)} / ${DateFormat().add_jm().format(pn.PurchaseDate)}",
                                    style: AppTheme.bgColorTS,
                                    )

                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      node.unfocus();
                                      setState(() {
                                        supplierTypeOpen=true;
                                      });

                                    },
                                    child: SidePopUpParent(
                                      text: pn.supplierType==null? "Select Supplier Type":pn.supplierType,
                                      textColor: pn.supplierType==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: pn.supplierType==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      node.unfocus();
                                      if(pn.supplierType==null){
                                        CustomAlert().commonErrorAlert(context, "Select Supplier Type", "");
                                      }
                                      else{
                                        setState(() {
                                          suppliersListOpen=true;
                                        });
                                      }


                                    },
                                    child: SidePopUpParent(
                                      text: pn.supplierName==null? "Select Supplier":pn.supplierName,
                                      textColor: pn.supplierName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: pn.supplierName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async{
                                      final DateTime picked = await showDatePicker(
                                        context: context,
                                        initialDate:  pn.ExpectedPurchaseDate, // Refer step 1
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null)
                                        setState(() {
                                          pn.ExpectedPurchaseDate = picked;
                                          print(pn.ExpectedPurchaseDate);
                                        });
                                    },
                                    child: ExpectedDateContainer(
                                      text: DateFormat("yyyy-MM-dd").format(pn.ExpectedPurchaseDate)==DateFormat("yyyy-MM-dd").format(DateTime.now())?"Expected Date":"${DateFormat.yMMMd().format(pn.ExpectedPurchaseDate)}",
                                      textColor:DateFormat("yyyy-MM-dd").format(pn.ExpectedPurchaseDate)==DateFormat("yyyy-MM-dd").format(DateTime.now())? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                    ),
                                  ),
                                  SizedBox(height: SizeConfig.height20,),

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
                                    height: 450,
                                    width: SizeConfig.screenWidth,

                                    margin: EdgeInsets.only(left:SizeConfig.screenWidth*0.06,right:SizeConfig.screenWidth*0.06),
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
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: SizeConfig.screenWidth,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                                            color: AppTheme.f737373,

                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: SizeConfig.screenWidth*0.23,
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.only(left: SizeConfig.width10),
                                                child: Text("Material",style: AppTheme.TSWhite166,),
                                              ),
                                              Container(
                                                width: SizeConfig.screenWidth*0.15,
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.only(left: SizeConfig.width10),

                                                child: Text("Qty",style: AppTheme.TSWhite166,),
                                              ),
                                              Container(
                                                width: SizeConfig.screenWidth*0.17,
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.only(left: SizeConfig.width10),

                                                child: Text("Price",style: AppTheme.TSWhite166,),
                                              ),
                                              Container(
                                                width: SizeConfig.screenWidth*0.16,
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.only(left: SizeConfig.width10),

                                                child: Text("GST",style: AppTheme.TSWhite166,),
                                              ),
                                              Container(
                                                width: SizeConfig.screenWidth*0.17,
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.only(left: SizeConfig.width10),

                                                child: Text("Total",style: AppTheme.TSWhite166,),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          height: 250,
                                          width: SizeConfig.screenWidth,
                                          decoration: BoxDecoration(
                                            border: Border(bottom: BorderSide(color: AppTheme.gridTextColor.withOpacity(0.3)))
                                          ),
                                          child: ListView.builder(
                                            itemCount: pn.purchaseOrdersMappingList.length,
                                            itemBuilder: (context,index){
                                              return GestureDetector(
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
                                                //  height: 50,
                                                  padding: EdgeInsets.only(top: 10,bottom: 10),
                                                  width: SizeConfig.screenWidth,
                                                  decoration: BoxDecoration(
                                                    color:selectedMaterialIndex==index?Colors.red: Colors.white,
                                                    border: Border(bottom: BorderSide(color: AppTheme.gridTextColor.withOpacity(0.3)))

                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: SizeConfig.screenWidth*0.23,
                                                        alignment: Alignment.centerLeft,
                                                        padding: EdgeInsets.only(left: SizeConfig.width10),
                                                        child: Text("${pn.purchaseOrdersMappingList[index].materialName}",
                                                          style: selectedMaterialIndex==index?AppTheme.TSWhite166: AppTheme.gridTextColorTS,),
                                                      ),
                                                      Container(
                                                        width: SizeConfig.screenWidth*0.15,
                                                        alignment: Alignment.centerLeft,
                                                        padding: EdgeInsets.only(left: SizeConfig.width10),

                                                        child: Container(
                                                          height: 30,

                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                            borderRadius: BorderRadius.circular(15)
                                                          ),
                                                          child: TextField(
                                                            style: selectedMaterialIndex==index?AppTheme.TSWhite166:AppTheme.gridTextColorTS,
                                                            controller: pn.purchaseOrdersMappingList[index].purchaseQty,
                                                            decoration: InputDecoration(
                                                              hintText: "0",
                                                              hintStyle: AppTheme.hintText,
                                                              border: InputBorder.none,
                                                              focusedBorder: InputBorder.none,
                                                              enabledBorder: InputBorder.none,
                                                              errorBorder: InputBorder.none,
                                                              contentPadding: EdgeInsets.only(left: 2,bottom: 12)
                                                            ),
                                                            keyboardType: TextInputType.number,
                                                            onChanged: (v){
                                                              pn.purchaseOrdersCalc(index, v);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: SizeConfig.screenWidth*0.17,
                                                        alignment: Alignment.centerLeft,
                                                        padding: EdgeInsets.only(left: SizeConfig.width10),

                                                        child: Text("${pn.purchaseOrdersMappingList[index].Amount}",
                                                          style:selectedMaterialIndex==index?AppTheme.TSWhite166: AppTheme.gridTextColorTS,),
                                                      ),
                                                      Container(
                                                        width: SizeConfig.screenWidth*0.16,
                                                        alignment: Alignment.centerLeft,
                                                        padding: EdgeInsets.only(left: SizeConfig.width10),

                                                        child: Text("${pn.purchaseOrdersMappingList[index].TaxAmount}",
                                                          style:selectedMaterialIndex==index?AppTheme.TSWhite166: AppTheme.gridTextColorTS,),
                                                      ),
                                                      Container(
                                                        width: SizeConfig.screenWidth*0.17,
                                                        alignment: Alignment.centerLeft,
                                                        padding: EdgeInsets.only(left: SizeConfig.width10),

                                                        child: Text("${pn.purchaseOrdersMappingList[index].TotalAmount}",
                                                          style: selectedMaterialIndex==index?AppTheme.TSWhite166:AppTheme.gridTextColorTS,),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Spacer(),

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
                                        Spacer(),
                                      ],
                                    ),
                                  ) ,




                                  SizedBox(height: SizeConfig.height100,)
                                ],
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
                      IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                        pn.clearForm();
                        Navigator.pop(context);
                      }),
                      SizedBox(width: SizeConfig.width5,),
                      Text("Purchase Orders",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                      ),
                      Text(pn.isPurchaseEdit?" / Edit":" / Add New",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                      ),
                    ],
                  ),
                ),
              /*  Positioned(
                  bottom: 0,
                  child: Container(
                    height:_keyboardVisible?0: SizeConfig.height70,
                    width: SizeConfig.screenWidth,
                    color: AppTheme.grey,
                    child: Center(
                      child: GestureDetector(
                        onTap: (){
                          node.unfocus();
                       *//*   if(qn.supplierName.text.isEmpty)
                          {
                            CustomAlert().commonErrorAlert(context, "Enter Supplier Name", "");

                          }
                          else if(qn.supplierCategoryId==null)
                          {
                            CustomAlert().commonErrorAlert(context, "Select Supplier Category", "");

                          }
                          else
                          {
                            qn.InsertSupplierDbHit(context,this);

                          }*//*

                        },
                        child: Container(
                          height: SizeConfig.height50,
                          width: SizeConfig.width120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(SizeConfig.height25),
                              color: AppTheme.bgColor
                          ),
                          child: Center(
                            child: Text(pn.isPurchaseEdit?"Update":"Save",style: AppTheme.TSWhite20,),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),*/
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: 60,
                    color: Colors.white,

                    // decoration: BoxDecoration(
                    //   border: Border.all(color: AppTheme.addNewTextFieldBorder),
                    //   color: Colors.white,
                    // ),
                    child: Stack(

                      children: [
                        CustomPaint(
                          size: Size( SizeConfig.screenWidth, 55),
                          painter: RPSCustomPainter(),
                        ),
                        Center(
                          heightFactor: 0.5,
                          child: FloatingActionButton(backgroundColor: AppTheme.yellowColor, child: Icon(Icons.save), elevation: 0.1, onPressed: () {
                          pn.InsertPurchaseDbHit(context);
                          }),
                        ),
                        Container(
                          width:  SizeConfig.screenWidth,
                          height: 80,
                          child: Stack(

                            children: [

                              pn.purchaseOrdersMappingList.isNotEmpty?Align(
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

                              pn.purchaseOrdersMappingList.isNotEmpty?Align(
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
                                            pn.purchaseOrdersMappingList.removeAt(selectedMaterialIndex);
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









                Container(
                  height: suppliersListOpen || supplierTypeOpen || materialsListOpen || otherChargeAmountOpen? SizeConfig.screenHeight:0,
                  width: suppliersListOpen || supplierTypeOpen || materialsListOpen || otherChargeAmountOpen? SizeConfig.screenWidth:0,
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






///////////////////////////////////////      SUPPLIER TYPE ////////////////////////////////
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
                      transform: Matrix4.translationValues(supplierTypeOpen?0:SizeConfig.screenWidth, 0, 0),

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
                                          supplierTypeOpen=false;
                                        });
                                      }),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text('Select Supplier Type',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.height10,),
                              Container(
                                height: SizeConfig.screenHeight*(300/720),
                                /*color: Colors.red,*/
                                margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                                child: ListView.builder(
                                  itemCount: pn.supplierTypeList.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          pn.supplierType= pn.supplierTypeList[index].supplierType;
                                          pn.filterSuppliersList=pn.suppliersList.where((element) => element.supplierType.toLowerCase()==pn.supplierType.toLowerCase()).toList();
                                          if(pn.supplierId!=null){
                                            pn.supplierId=null;
                                            pn.supplierName=null;
                                          }

                                          supplierTypeOpen=false;
                                        });

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            borderRadius:BorderRadius.circular(8),
                                            border: Border.all(color: pn.supplierType==null? AppTheme.addNewTextFieldBorder:pn.supplierType==pn.supplierTypeList[index].supplierType?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                            color: pn.supplierType==null? Colors.white: pn.supplierType==pn.supplierTypeList[index].supplierType?AppTheme.popUpSelectedColor:Colors.white
                                        ),
                                        width:300,
                                        height:50,
                                        child: Text("${pn.supplierTypeList[index].supplierType}",
                                          style: TextStyle(color:pn.supplierType==null? AppTheme.grey:pn.supplierType==pn.supplierTypeList[index].supplierType?Colors.white:AppTheme.grey,
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

///////////////////////////////////////      SUPPLIER LIST ////////////////////////////////
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
                      transform: Matrix4.translationValues(suppliersListOpen?0:SizeConfig.screenWidth, 0, 0),

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
                                          suppliersListOpen=false;
                                        });
                                      }),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text('Select Supplier',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.height10,),
                              Container(
                                height: SizeConfig.screenHeight*(300/720),
                                /*color: Colors.red,*/
                                margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                                child: ListView.builder(
                                  itemCount: pn.filterSuppliersList.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          pn.supplierId=pn.filterSuppliersList[index].supplierId;
                                          pn.supplierName=pn.filterSuppliersList[index].supplierName;
                                          if(pn.filterSuppliersList[index].supplierId!=null){
                                            pn.filterMaterialsList=pn.materialsList.where((element) => element.supplierId==pn.filterSuppliersList[index].supplierId).toList();
                                          }
                                          else{
                                            pn.filterMaterialsList=pn.materialsList.where((element) => element.supplierName==pn.filterSuppliersList[index].supplierName).toList();
                                          }
                                          suppliersListOpen=false;
                                        });

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            borderRadius:BorderRadius.circular(8),
                                            border: Border.all(color: pn.supplierId==null? AppTheme.addNewTextFieldBorder:pn.supplierId==pn.filterSuppliersList[index].supplierId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                            color: pn.supplierId==null? Colors.white: pn.supplierId==pn.filterSuppliersList[index].supplierId?AppTheme.popUpSelectedColor:Colors.white
                                        ),
                                        width:300,
                                        height:50,
                                        child: Text("${pn.filterSuppliersList[index].supplierName}",
                                          style: TextStyle(color:pn.supplierId==null? AppTheme.grey:pn.supplierId==pn.filterSuppliersList[index].supplierId?Colors.white:AppTheme.grey,
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
                                     itemCount: pn.filterMaterialsList.length,
                                     itemBuilder: (context,index){
                                       return GestureDetector(
                                         onTap: (){
                                           setState(() {
                                             indentQty='';
                                             disValue='';
                                             discountKeyPad=false;
                                             pn.isDiscountPercentage=true;
                                             pn.purchaseOrdersMappingList.add(
                                               PurchaseOrderMaterialMappingListModel(
                                                 PurchaseOrderMaterialMappingId:null,
                                                 PurchaseOrderId:null,
                                                 MaterialId:pn.filterMaterialsList[index].materialId,
                                                 materialName:pn.filterMaterialsList[index].materialName,
                                                 MaterialPrice:pn.filterMaterialsList[index].materialPrice,
                                                 PurchaseQuantity:0,
                                                 Amount:pn.filterMaterialsList[index].materialPrice,
                                                 IsDiscount:0,
                                                 IsPercentage:0,
                                                 IsAmount:0,
                                                 DiscountValue:0.0,
                                                 DiscountAmount:0.0,
                                                 TaxValue:pn.filterMaterialsList[index].taxValue,
                                                 TaxAmount:0.0,
                                                 TotalAmount:0.0,
                                                 IsActive:1,
                                                 materialUnitId:pn.filterMaterialsList[index].materialUnitId,
                                                 unitName:pn.filterMaterialsList[index].unitName,
                                                 purchaseQty: TextEditingController()..text=""
                                               )
                                             );
                                           });

                                           showDialog(context: context,
                                              // barrierDismissible: false,

                                               builder: (context){
                                                 return StatefulBuilder(
                                                   builder:(context,setState){
                                                     return Consumer<PurchaseNotifier>(
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
                                                               Text("${pn.purchaseOrdersMappingList[pn.purchaseOrdersMappingList.length-1].materialName??""}",
                                                                 style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),
                                                               SizedBox(height: 10,),
                                                               discountKeyPad?
                                                               Row(
                                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                                 children: [
                                                                   Text("${indentQty.isEmpty?"0":indentQty} ${pn.filterMaterialsList[pn.filterMaterialsList.length-1].unitName??""}",
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




                                                               Text("${indentQty.isEmpty?"0":indentQty} ${pn.purchaseOrdersMappingList[pn.purchaseOrdersMappingList.length-1].unitName??""}",
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
                                                                                 height: 70,
                                                                                 width: 70,
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
                                                                   pn.updateIsDiscountFromQtyShowDialog(pn.purchaseOrdersMappingList.length-1,disValue,indentQty);
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
                                           child: Text("${pn.filterMaterialsList[index].materialName}",
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





