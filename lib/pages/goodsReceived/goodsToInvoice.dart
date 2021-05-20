
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialListModel.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/goodsReceived/goodsInGateForm.dart';
import 'package:quarry/pages/goodsReceived/goodsMaterialTripDetail.dart';
import 'package:quarry/pages/goodsReceived/goodsReceivedGrid.dart';
import 'package:quarry/pages/goodsReceived/goodsToPurchase.dart';
import 'package:quarry/pages/quarryMaster/plantDetailsAddNew.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';





class GoodsToInvoice extends StatefulWidget {

  @override
  GoodsToInvoiceState createState() => GoodsToInvoiceState();
}

class GoodsToInvoiceState extends State<GoodsToInvoice> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;

  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;

  double valueContainerWidth=100;
  double dataTableheight=400;
  double dataTableBodyheight=350;

  //for keyboard
  int reorderLevelIndex=-1;
  List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "X", "0", "."];
  String indentQty="";
  String disValue="";
  bool discountKeyPad=false;


  @override
  void initState() {
    isEdit=false;
    WidgetsBinding.instance.addPostFrameCallback((_){
      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });


      listViewController.addListener(() {
        if(listViewController.offset>10){
          if(scrollController.offset==0){
            scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          }

        }
        else if(listViewController.offset==0){
          scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });

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

    super.initState();
  }

  List<String> gridcol=["Material","Qty","Received Qty","Per Ton","Tax","Amount","Status"];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<GoodsReceivedNotifier>(
          builder: (context,gr,child)=> Stack(
            children: [



              Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: 200,

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
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(height: 160,),
                      Container(
                          height: SizeConfig.screenHeight-60,
                          width: SizeConfig.screenWidth,
                          padding: EdgeInsets.only(bottom: 60),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: ListView(
                            controller: listViewController,
                            children: [

                              /**********  DataTable  ********/
                              Container(
                                  height: dataTableheight,
                                  width: SizeConfig.screenWidth,
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.only(left:SizeConfig.screenWidth*0.02,right:SizeConfig.screenWidth*0.02,top: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.addNewTextFieldText.withOpacity(0.1),
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
                                                        children:gr.GINV_Materials.asMap().
                                                        map((index, value) => MapEntry(
                                                            index,InkWell(
                                                          onTap: (){
                                                           /* if(gr.ML_Materials[index].status!='Completed'){
                                                              setState(() {
                                                                gr.IGF_Materials.add(
                                                                    GoodsReceivedMaterialListModel(
                                                                      GoodsReceivedMaterialMappingId: gr.ML_Materials[index].GoodsReceivedMaterialMappingId,
                                                                      goodsReceivedId: gr.ML_Materials[index].goodsReceivedId,
                                                                      materialId: gr.ML_Materials[index].materialId,
                                                                      materialName: gr.ML_Materials[index].materialName,
                                                                      materialPrice: gr.ML_Materials[index].materialPrice,
                                                                      materialUnitId: gr.ML_Materials[index].materialUnitId,
                                                                      unitName: gr.ML_Materials[index].unitName,
                                                                      quantity: gr.ML_Materials[index].quantity,
                                                                      receivedQuantity: 0.0,
                                                                      amount: 0.0,
                                                                      vehicleNumber: null,
                                                                      vehicleTypeId: null,
                                                                      inwardLoadedVehicleWeight: 0.0,
                                                                      outwardEmptyVehicleWeight: 0.0,

                                                                    )
                                                                );
                                                              });
                                                              Navigator.push(context, _createRoute());
                                                            }
                                                            else{
                                                              Navigator.push(context, _createRouteTripList(gr.ML_Materials[index].materialId,
                                                                  gr.ML_Materials[index].materialName,gr.ML_Materials[index].unitName,gr.ML_Materials[index].quantity
                                                              ));
                                                            }*/
                                                          },
                                                          child: Container(

                                                            height: 60,
                                                            decoration: BoxDecoration(
                                                                border: Border(bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5)))
                                                            ),

                                                            child: Row(
                                                              children: [

                                                                Container(
                                                                  alignment: Alignment.center,
                                                                  // padding: EdgeInsets.only(left: 20,right: 20),
                                                                  width: valueContainerWidth,
                                                                  child: Text("${value.quantity}",
                                                                    style:AppTheme.ML_bgCT,
                                                                  ),

                                                                ),
                                                                Container(
                                                                  alignment: Alignment.center,
                                                                  width: valueContainerWidth,
                                                                  child: Text("${value.receivedQuantity}",
                                                                    style:AppTheme.ML_bgCT,
                                                                  ),
                                                                ),

                                                                Container(
                                                                  width: valueContainerWidth,
                                                                  alignment: Alignment.center,
                                                                  child: Text("${value.materialPrice}",
                                                                    style:AppTheme.ML_bgCT,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: valueContainerWidth,
                                                                  alignment: Alignment.center,
                                                                  child: Text("${value.taxAmount}",
                                                                    style:AppTheme.ML_bgCT,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: valueContainerWidth,
                                                                  alignment: Alignment.center,
                                                                  child: Text("${value.amount}",
                                                                    style:AppTheme.ML_bgCT,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: valueContainerWidth,
                                                                  alignment: Alignment.center,
                                                                  child: Text("${value.status}",
                                                                    style:TextStyle(fontFamily: 'RL',color:gr.GINV_Materials[index].status=='Not Yet'? AppTheme.bgColor:
                                                                    gr.GINV_Materials[index].status=='Completed'?Colors.green:AppTheme.red
                                                                        ,fontSize: 12),textAlign: TextAlign.center,
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
                                                      children: gr.GINV_Materials.asMap().
                                                      map((index, value) => MapEntry(
                                                          index,InkWell(
                                                        onTap: (){
                                                        /*  if(gr.ML_Materials[index].status!='Completed'){
                                                            setState(() {
                                                              gr.IGF_Materials.add(
                                                                  GoodsReceivedMaterialListModel(
                                                                    GoodsReceivedMaterialMappingId: gr.ML_Materials[index].GoodsReceivedMaterialMappingId,
                                                                    goodsReceivedId: gr.ML_Materials[index].goodsReceivedId,
                                                                    materialId: gr.ML_Materials[index].materialId,
                                                                    materialName: gr.ML_Materials[index].materialName,
                                                                    materialPrice: gr.ML_Materials[index].materialPrice,
                                                                    materialUnitId: gr.ML_Materials[index].materialUnitId,
                                                                    unitName: gr.ML_Materials[index].unitName,
                                                                    quantity: gr.ML_Materials[index].quantity,
                                                                    receivedQuantity: 0.0,
                                                                    amount: 0.0,
                                                                    vehicleNumber: null,
                                                                    vehicleTypeId: null,
                                                                    inwardLoadedVehicleWeight: 0.0,
                                                                    outwardEmptyVehicleWeight: 0.0,

                                                                  )
                                                              );
                                                            });
                                                            Navigator.push(context, _createRoute());
                                                          }
                                                          else{
                                                            Navigator.push(context, _createRouteTripList(gr.ML_Materials[index].materialId,
                                                                gr.ML_Materials[index].materialName,gr.ML_Materials[index].unitName,gr.ML_Materials[index].quantity
                                                            ));
                                                          }*/
                                                        },
                                                        child:  Container(
                                                          alignment: Alignment.center,
                                                          height: 60,
                                                          width: valueContainerWidth,
                                                          decoration: BoxDecoration(
                                                              border: Border(bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5)))
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




                                    ],
                                  )







                              ) ,

                              /////////////  OtherCharges Details List  /////////////////
                              Container(

                                height: gr.GINV_OtherChargesList.length== 0 ? 0 :
                                ( gr.GINV_OtherChargesList.length * 50.0)+40,
                            //    height: 100,
                                constraints: BoxConstraints(
                                    maxHeight: 300
                                ),
                                //  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),

                                width: SizeConfig.screenWidth,

                                margin: EdgeInsets.only(left:SizeConfig.screenWidth*0.02,right:SizeConfig.screenWidth*0.02,top: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                ),
                                child: Column(
                                  children: [

                                    Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5),),

                                        /* border: Border(
                                                    bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5))
                                                )*/
                                      ),
                                      child: Row(
                                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: SizeConfig.screenWidthM0_04*0.44,child: Text("Other Charge")),
                                          Container( alignment: Alignment.centerLeft,width: SizeConfig.screenWidthM0_04*0.23,child: Text("  Price")),
                                          Container(alignment: Alignment.center, width: SizeConfig.screenWidthM0_04*0.25,child: Text("Action")),

                                        ],

                                      ),
                                    ),

                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: gr.GINV_OtherChargesList.length,
                                        itemBuilder: (context, index) {
                                          return
                                            SlideTransition(
                                            position: Tween<Offset>(begin: Offset(0.0,0.0), end:Offset(1, 0))
                                                .animate(gr.GINV_OtherChargesList[index].animationController),

                                            child: FadeTransition(
                                              opacity: Tween(begin: 1.0, end: 0.0)
                                                  .animate(gr.GINV_OtherChargesList[index].animationController),
                                              child:
                                              Container(
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
                                                          width: SizeConfig.screenWidthM0_04*0.44,
                                                          height: 25,
                                                          alignment:Alignment.centerLeft,

                                                          child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Row(
                                                              children: [
                                                                Text("${gr.GINV_OtherChargesList[index].otherChargesName}",
                                                                  style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),textAlign: TextAlign.left,
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          
                                                          padding: EdgeInsets.only(left: 5),
                                                          alignment: Alignment.centerLeft,
                                                          width: SizeConfig.screenWidthM0_04*0.23,
                                                          child: GestureDetector(
                                                            onTap:!gr.GINV_OtherChargesList[index].isEdit?null: (){

                                                              setState(() {
                                                                indentQty=gr.GINV_OtherChargesList[index].otherChargesAmount.toString();
                                                              });

                                                              showDialog(context: context,
                                                                  barrierDismissible: false,

                                                                  builder: (context){
                                                                    return StatefulBuilder(
                                                                      builder:(context,setState){
                                                                        return Consumer<GoodsReceivedNotifier>(
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
                                                                                  SizedBox(height: 10,),
                                                                                  Text("Other Charges",
                                                                                    style: TextStyle(fontFamily: 'RM',fontSize: 18,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),
                                                                                  SizedBox(height: 15,),
                                                                                  Text("${pn.GINV_OtherChargesList[index].otherChargesName}",
                                                                                    style: TextStyle(fontFamily: 'RR',fontSize: 18,color: AppTheme.gridTextColor),textAlign: TextAlign.center,),
                                                                                  SizedBox(height: 10,),


                                                                                  Text(indentQty.isEmpty?"Rs.0":"Rs.$indentQty",
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
                                                                                  SizedBox(height: 25,),

                                                                                  GestureDetector(
                                                                                    onTap: (){
                                                                                      setState((){
                                                                                        if(indentQty.isNotEmpty){
                                                                                          pn.updateDriverCharge(index, double.parse(indentQty));
                                                                                          //pn.GINV_OtherChargesList[index].otherChargesAmount=double.parse(indentQty);
                                                                                        }

                                                                                      });
                                                                                      pn.updateDriverIsEdit(index,false);
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
                                                                                      pn.updateDriverIsEdit(index,false);
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
                                                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(50),
                                                                border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                                                color: gr.GINV_OtherChargesList[index].isEdit?Colors.white:AppTheme.disableColor
                                                              ),
                                                              child: Text("${gr.GINV_OtherChargesList[index].otherChargesAmount}",
                                                                style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width:SizeConfig.screenWidthM0_04*0.25,
                                                          height: 30,
                                                         // padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              GestureDetector(
                                                                  onTap:(){
                                                                    setState(() {
                                                                      gr.GINV_OtherChargesList[index].isEdit=!gr.GINV_OtherChargesList[index].isEdit;
                                                                    });
                                                                  },
                                                                  child: Icon(Icons.edit,size: 20,)),
                                                              SizedBox(width:SizeConfig.screenWidthM0_04*0.01,),
                                                              GestureDetector(
                                                                onTap: (){
                                                                  gr.GINV_OtherChargesList[index].animationController.forward().whenComplete((){
                                                                    setState(() {
                                                                      gr.GINV_OtherChargesList.removeAt(index);
                                                                    });

                                                                  });
                                                                },
                                                                  child: Icon(Icons.delete_outline,size: 20,)
                                                              ),
                                                            ],
                                                          )
                                                        ),
                                                      ],
                                                    ),


                                                  ],
                                                ),
                                              )
                                            )
                                            );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),
                              Align(
                                alignment: Alignment.center,
                                child: RichText(
                                    text: TextSpan(
                                    text: 'Do you want to raise Invoice for ',
                                    style: TextStyle(fontSize: 14,fontFamily: 'RR',color: AppTheme.addNewTextFieldText),
                                     children: <TextSpan>[
                                       TextSpan(text: '${gr.GINV_PorderNo}', style:TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 14)),
                                       ],
                                ),
                            ),
                              ),
                              SizedBox(height: 10,),
                              Text("Invoice Amount",
                              style: TextStyle(fontFamily: 'RL',color: AppTheme.red,fontSize: 14),textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 3,),
                              Text("${gr.GINV_invoiceAmount}",
                              style: TextStyle(fontFamily: 'RM',color: AppTheme.red,fontSize: 25),textAlign: TextAlign.center,
                              ),


                              SizedBox(height: 30,),



                            ],
                          )
                      )
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: 60,

                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.7),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: Offset(0, -20), // changes position of shadow
                        )
                      ]
                  ),
                  child: Stack(

                    children: [
                      CustomPaint(
                        size: Size( SizeConfig.screenWidth, 55),
                        painter: RPSCustomPainter(),
                      ),

                      Container(
                        width:  SizeConfig.screenWidth,
                        height: 80,
                        child: Stack(

                          children: [

                            Container(

                                width: SizeConfig.screenWidth,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [

                                    GestureDetector(
                                      onTap: (){

                                        gr.InsertInvoiceDbHit(context,GoodsReceivedGridState()).then((value){
                                          Navigator.pop(context);
                                           gr.GPO_assignValues().then((value){
                                             if(gr.GPO_Materials.isNotEmpty){
                                               Navigator.push(context, _createRouteGoodsToPurchase());
                                             }
                                           });

                                        });

                                      },
                                      child: Container(
                                        width: SizeConfig.screenWidth*0.4,
                                        child:Center(
                                          child: Image.asset("assets/goodsIcons/yes.jpg"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: SizeConfig.width20,),
                                    Spacer(),
                                    SizedBox(width: SizeConfig.width20,),
                                    GestureDetector(
                                      onTap: (){
                                        gr.GINV_clear();
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: SizeConfig.screenWidth*0.4,
                                        child:Center(
                                        child: Image.asset("assets/goodsIcons/no.jpg"),
                                      ),
                                      ),
                                    ),


                              ]
                            ),
                            )

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
                    gr.GINV_clear();

                    Navigator.pop(context);

                  },
                  image: "assets/svg/drawer/back-icon.svg",
                ),
              ),


              Container(
                height: SizeConfig.height60,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    CancelButton(
                      ontap: (){
                        gr.GINV_clear();

                        Navigator.pop(context);
                      },
                    ),

                    Text("Goods to Invoice",
                      style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),
                    ),

                    Spacer(),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text("${gr.GINV_PorderNo}",
                        style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),
                      ),
                    ),
                    SizedBox(width: SizeConfig.width10,),
                  ],
                ),
              ),


              Container(

                height: gr.GoodsLoader? SizeConfig.screenHeight:0,
                width: gr.GoodsLoader? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                ),
              ),
            ],
          )
      ),
    );
  }

  Route _createRouteGoodsToPurchase() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GoodsToPurchase(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
  Route _createRouteTripList(int materialId,String materialName,String unitName,double expectedQty) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GoodsMaterialTripList(materialId,materialName,unitName,expectedQty),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }

}

