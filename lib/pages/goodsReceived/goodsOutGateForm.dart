
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/goodsReceivedModel/goodsMaterialListModel.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/pages/quarryMaster/plantDetailsAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/searchdropdownSingleSelect.dart';

import 'goodsReceivedGrid.dart';





class GoodsOutGateForm extends StatefulWidget {

  @override
  GoodsOutGateFormState createState() => GoodsOutGateFormState();
}

class GoodsOutGateFormState extends State<GoodsOutGateForm> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;

  bool _keyboardVisible=false;
  bool isVehicleTypeOpen=false;



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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final node=FocusScope.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(height: 160,),
                      Container(
                          height: SizeConfig.screenHeight-60,
                          width: SizeConfig.screenWidth,
                          padding: EdgeInsets.only(top: 20,bottom: 60),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: ListView(
                            controller: listViewController,
                            children: [
                              Image.asset("assets/images/inGate.jpg",height: 50,width: 100,),
                             gr.OGF_index!=null && gr.OGF_index!=-1? Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${gr.outGateFormList[gr.OGF_index].materialName} - ${gr.outGateFormList[gr.OGF_index].expectedQuantity}",
                                    style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(bottom: 2),
                                    child: Text(" ${gr.outGateFormList[gr.OGF_index].unitName}",
                                      style: TextStyle(fontFamily: 'RR',color: AppTheme.hintColor,fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ):Container(),
                              DropDownField(
                                ontap: (){
                                   scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                  setState(() {
                                    _keyboardVisible=true;
                                  });
                                },
                                onEditingcomplete: (){
                                  node.unfocus();
                                  Timer(Duration(milliseconds: 300), (){
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  });
                                  setState(() {
                                    gr.OGF_vehicleNumber=gr.OGF_vehicleNumberController.text;
                                    gr.OGF_index=gr.outGateFormList.indexWhere((element) => element.vehicleNumber.toLowerCase()==gr.OGF_vehicleNumber.toString().toLowerCase()).toInt();
                                    if(gr.OGF_index!=-1){
                                      gr.OGF_UnitName=gr.outGateFormList[gr.OGF_index].unitName;
                                      gr.OGF_ReceivedQty=gr.outGateFormList[gr.OGF_index].receivedQuantity;
                                      gr.OGF_InwardLoadedVehicleWeight=gr.outGateFormList[gr.OGF_index].inwardLoadedVehicleWeight;
                                      gr.OGF_OutwardEmptyVehicleWeight=gr.outGateFormList[gr.OGF_index].outwardEmptyVehicleWeight;
                                      gr.OGF_BalanceQty=0.0;
                                      gr.OGF_amount=0.0;
                                      gr.OGF_taxAmount=0.0;
                                      gr.OGF_TotalAmount=0.0;
                                      gr.OGF_discountAmount=0.0;
                                    }
                                  });
                                },
                                add: (){
                                },
                                nodeFocus: (){
                                  node.unfocus();
                                },
                                value: gr.OGF_vehicleNumber,
                                controller: gr.OGF_vehicleNumberController,
                                reduceWidth: SizeConfig.width40,
                                // qtycontroller:qn.brandQtyController,
                                // unit: qn.MM_selectPrimaryUnit.toString(),

                                required: false,
                                // icon: Container(
                                //   height: 50,
                                //   width: 50,
                                //   margin: EdgeInsets.only(left: 20,right: 20),
                                //   decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       color: Color(0xFFDEE2FE)
                                //   ),
                                // ),

                                hintText: 'Enter Vehicle Number',
                                textStyle: TextStyle(fontFamily: 'RR',fontSize: 20,color: AppTheme.addNewTextFieldText),
                                items: gr.outGateFormVehiclesList,
                                strict: false,
                                setter: (dynamic newValue) {
                                  // print(newValue);
                                  // qn.SS_LoadedVehicleNo=newValue;
                                  // print(qn.SS_LoadedVehicleNo);
                                  // qn.MM_selectBrand = newValue;
                                },
                                onValueChanged: (v){
                                  node.unfocus();
                                  setState(() {
                                    gr.OGF_vehicleNumber=v;
                                    gr.OGF_index=gr.outGateFormList.indexWhere((element) => element.vehicleNumber.toLowerCase()==v.toString().toLowerCase()).toInt();

                                    gr.OGF_UnitName=gr.outGateFormList[gr.OGF_index].unitName;
                                    gr.OGF_ExpectedQty=gr.outGateFormList[gr.OGF_index].expectedQuantity;
                                    gr.OGF_ReceivedQty=gr.outGateFormList[gr.OGF_index].receivedQuantity;
                                    gr.OGF_InwardLoadedVehicleWeight=gr.outGateFormList[gr.OGF_index].inwardLoadedVehicleWeight;
                                    gr.OGF_OutwardEmptyVehicleWeight=gr.outGateFormList[gr.OGF_index].outwardEmptyVehicleWeight;
                                    gr.OGF_BalanceQty=0.0;
                                    gr.OGF_showReceivedQty=0.0;
                                    _keyboardVisible=false;

                                  });
                                },

                              ),

                              AddNewLabelTextField(
                                textEditingController: gr.OGF_emptyWeightofVehicle,
                                labelText: "Empty Vehicle Weight",

                                ontap: (){
                                //  scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                  setState(() {
                                    _keyboardVisible=true;
                                  });
                                },
                                onEditComplete: (){
                                  node.unfocus();
                                  Timer(Duration(milliseconds: 300), (){
                                    setState(() {
                                      _keyboardVisible=false;
                                    });
                                  });
                                },
                                onChange: (v){
                                  if(v.isNotEmpty){
                                    if(int.parse(v.toString())<gr.OGF_InwardLoadedVehicleWeight){
                                      gr.calc();
                                    }
                                    else{
                                      setState(() {
                                        gr.OGF_emptyWeightofVehicle.clear();
                                      });
                                      gr.calc();
                                      CustomAlert().commonErrorAlert(context, "Over Weight", "Empty vehicle weight is higher than Inward Vehicle Weight");
                                    }
                                  }
                                  else{
                                    gr.calc();
                                  }
                                },
                                textInputType: TextInputType.number,
                              ),
                              SizedBox(height: 20,),

                              gr.OGF_showReceivedQty.toInt()>0 || gr.OGF_BalanceQty.toInt()>0?  Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 50,
                                  width: SizeConfig.screenWidth*0.8,
                                  decoration: BoxDecoration(
                                    color: AppTheme.red,
                                    borderRadius: BorderRadius.circular(25)
                                  ),
                                  child: Center(
                                    child:gr.OGF_BalanceQty>0? Text("${gr.OGF_showReceivedQty??0.0} ${gr.OGF_UnitName??""} Received, Balance ${gr.OGF_BalanceQty} ${gr.OGF_UnitName??""}",
                                    style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white),
                                    ):Text("${gr.OGF_showReceivedQty??0.0} ${gr.OGF_UnitName??""} Received, Extra ${-1*(gr.OGF_BalanceQty)} ${gr.OGF_UnitName??""}",
                                    style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white),
                                    ),
                                  ),
                                ),
                              ):Container()
                            ],
                          )
                      )
                    ],
                  ),
                ),
              ),

              //bottomNav
              AnimatedPositioned(
                duration: Duration(milliseconds: 100),
                curve: Curves.easeIn,
                bottom: 0,
                child: Container(
                  width: SizeConfig.screenWidth,
                  height:70,

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
                        size: Size( SizeConfig.screenWidth, 65),
                        painter: RPSCustomPainter3(),
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
                    if(gr.OGF_vehicleNumberController.text.isEmpty){
                      CustomAlert().commonErrorAlert(context, "Enter Vehicle Number", "");
                    }
                    else if(gr.OGF_emptyWeightofVehicle.text.isEmpty){
                      CustomAlert().commonErrorAlert(context, "Enter Empty Weight of Vehicle", "");
                    }
                    else{
                      gr.UpdateGoodsDbHit(context,null,GoodsReceivedGridState());
                    }


                  },
                ),
              ),


              Container(
                height: SizeConfig.height60,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    CancelButton(
                      ontap: (){
                        Navigator.pop(context);
                        gr.clearOGFform();
                      },
                    ),

                    Text("${gr.OGF_index!=null && gr.OGF_index!=-1? gr.outGateFormList[gr.OGF_index].purchaseOrderNumber:""} OutGate Form",
                      style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),
                    ),

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

}

