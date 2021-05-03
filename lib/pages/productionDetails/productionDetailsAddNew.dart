import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/productionDetailsModel/productionMaterialMappingListModel.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/customTextField.dart';


class ProductionDetailAddNew extends StatefulWidget {
  @override
  ProductionDetailAddNewState createState() => ProductionDetailAddNewState();
}

class ProductionDetailAddNewState extends State<ProductionDetailAddNew> with TickerProviderStateMixin {

  GlobalKey <ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();


  ScrollController scrollController;
  ScrollController listViewController;

  bool _keyboardVisible = false;

  bool machineCategoryOpen = false;
  bool inputMaterialOpen = false;
  bool productionMaterailOpen=false;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController = new ScrollController();
      listViewController = new ScrollController();
      setState(() {

      });


    /*  listViewController.addListener(() {
        if (listViewController.offset > 20) {
          scrollController.animateTo(
              100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
        else if (listViewController.offset == 0) {
          scrollController.animateTo(
              0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      });*/

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
    final node = FocusScope.of(context);

    SizeConfig().init(context);

    return Scaffold(
      key: scaffoldkey,
      body: Consumer<ProductionNotifier>(
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
                                scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                              } else if(details.delta.dy < -sensitivity){
                                scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                              }
                            },
                            child: Container(
                              height: _keyboardVisible ? SizeConfig.screenHeight * 0.5 : SizeConfig.screenHeight - 100,
                              width: SizeConfig.screenWidth,

                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))
                              ),
                              child: ListView(
                                controller: listViewController,
                                scrollDirection: Axis.vertical,

                                children: [

                                  GestureDetector(

                                    onTap: () {
                                      node.unfocus();
                                      setState(() {
                                        _keyboardVisible=false;
                                        machineCategoryOpen = true;
                                      });

                                    },
                                    child: SidePopUpParent(
                                      text: qn.selectMachineName == null ? "Select Machine " : qn.selectMachineName,
                                      textColor: qn.selectMachineName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5)
                                          : AppTheme.addNewTextFieldText,
                                      iconColor: qn.selectMachineName == null ? AppTheme.addNewTextFieldText
                                          : AppTheme.yellowColor,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      node.unfocus();
                                      setState(() {
                                        _keyboardVisible=false;
                                        inputMaterialOpen = true;
                                      });
                                    },
                                    child: SidePopUpParent(
                                      text: qn.selectInputTypeName == null ? "Select Input Material"
                                          : qn.selectInputTypeName,
                                      textColor: qn.selectInputTypeName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5)
                                          : AppTheme.addNewTextFieldText,
                                      iconColor: qn.selectInputTypeName == null ? AppTheme.addNewTextFieldText
                                          : AppTheme.yellowColor,
                                    ),
                                  ),
                                  AddNewLabelTextField(
                                    labelText: 'Input Material Quantity',
                                    textEditingController: qn.materialQuantity,
                                    textInputType: TextInputType.number,
                                    ontap: () {
                                      setState(() {
                                        _keyboardVisible=true;
                                      });
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                    onChange: (v){
                                      qn.wastageCalc();
                                    },
                                    onEditComplete: () {
                                      node.unfocus();
                                      Timer(Duration(milliseconds: 100), (){
                                        setState(() {
                                          _keyboardVisible=false;
                                        });
                                      });
                                    },
                                    suffixIcon:qn.selectInputUnitName==null? Container(
                                      height: 10,width: 10,
                                    ): Container(
                                      margin: EdgeInsets.all(10),
                                      height:15,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: AppTheme.yellowColor
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${qn.selectInputUnitName??""}", style: AppTheme.TSWhiteML,
                                        ),
                                      ),
                                    ),
                                  ),

                                  ///////////// Material Name/////////////////
                                  Container(
                                    //  duration: Duration(milliseconds: 300),
                                    // curve: Curves.easeIn,
                                    height: qn.productionMaterialMappingList.length == 0 ? 0 :
                                       qn.productionMaterialMappingList.length * 50.0,
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),

                                    width: SizeConfig.screenWidth,
                                    margin: EdgeInsets.only(
                                      left: SizeConfig.width20,
                                      right: SizeConfig.width20,
                                      top: SizeConfig.height20,),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          qn.productionMaterialMappingList.length == 0 ? BoxShadow() :
                                          BoxShadow(
                                            color: AppTheme.addNewTextFieldText
                                                .withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 15,
                                            offset: Offset(0, 0), // changes position of shadow
                                          )
                                        ]
                                    ),
                                    child: ListView.builder(
                                      itemCount: qn.productionMaterialMappingList.length,
                                      itemBuilder: (context, index) {
                                        return SlideTransition(
                                          position: Tween<Offset>(begin: Offset(qn.productionMaterialMappingList[index].isEdit ? 0.0 :
                                          qn.productionMaterialMappingList[index].isDelete ?1.0:0.0,
                                              qn.productionMaterialMappingList[index].isEdit ? 0.0 :qn.productionMaterialMappingList[index].isDelete ?0.0: 1.0),
                                              end:qn.productionMaterialMappingList[index].isEdit ?Offset(1, 0): Offset.zero)
                                              .animate(qn.productionMaterialMappingList[index].scaleController),
                                          // scale: Tween(begin:qn.isSupplierEdit?1.0: 0.0, end:qn.isSupplierEdit?0.0: 1.0)
                                          //     .animate(qn.supplierMaterialMappingList[index].scaleController),
                                          child: FadeTransition(
                                            opacity: Tween(begin: qn.productionMaterialMappingList[index].isEdit ? 1.0 : 0.0,
                                                end: qn.productionMaterialMappingList[index].isEdit ? 0.0 : 1.0)
                                                .animate(qn.productionMaterialMappingList[index].scaleController),
                                            child: Container(
                                              padding: EdgeInsets.only(top: 5, bottom: 5),
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
                                                      qn.productionMaterialMappingList[index].MaterialName!='Dust'?
                                                      Container(
                                                        width: SizeConfig.width100,
                                                        child: Text("${qn.productionMaterialMappingList[index].MaterialName}",
                                                          style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                        ),
                                                      ):
                                                      Container(
                                                        width: SizeConfig.width100,
                                                        child: Row(
                                                          children: [
                                                            Text("${qn.productionMaterialMappingList[index].MaterialName}",
                                                              style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                            ),
                                                            SizedBox(width: 10,),
                                                            GestureDetector(
                                                              onTap: (){
                                                                setState(() {
                                                                  qn.isWastage=!qn.isWastage;
                                                                });
                                                                qn.wastageCalc();
                                                              },
                                                              child: AnimatedContainer(
                                                                duration: Duration(milliseconds: 300),
                                                                curve: Curves.easeIn,
                                                                height: 20,
                                                                width: 20,
                                                                decoration: BoxDecoration(
                                                                    color:qn.isWastage?AppTheme.yellowColor: AppTheme.uploadColor.withOpacity(0.2),
                                                                    borderRadius: BorderRadius.circular(3),
                                                                    border: Border.all(color:qn.isWastage?AppTheme.yellowColor: AppTheme.addNewTextFieldBorder)
                                                                ),
                                                                child: Center(
                                                                  child: Icon(Icons.done,color:qn.isWastage?AppTheme.bgColor: AppTheme.addNewTextFieldBorder.withOpacity(0.5),size: 15,),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(left: 5),
                                                        alignment: Alignment.centerLeft,
                                                        width: SizeConfig.width60,
                                                        child: Text("${qn.productionMaterialMappingList[index].OutputMaterialQuantity}",
                                                          style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment: Alignment.centerRight,
                                                        width: SizeConfig.width70 +
                                                            SizeConfig.width5,
                                                        child: Text("${qn.productionMaterialMappingList[index].MaterialUnit}",
                                                          style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      GestureDetector(
                                                        onTap: () {

                                                          print(qn.isProductionEdit);

                                                          if (qn.productionMaterialMappingList[index].isEdit) {
                                                            qn.productionMaterialMappingList[index].scaleController.forward().whenComplete(() {
                                                              print("EIT");
                                                              if (this.mounted) {
                                                                if(qn.productionMaterialMappingList[index].MaterialName=='Dust'){
                                                                  setState(() {
                                                                    qn.dustQty=0.0;
                                                                    qn.isWastage=false;
                                                                  });
                                                                }
                                                                setState(() {
                                                                  qn.productionMaterialMappingList.removeAt(index);
                                                                });
                                                                qn.wastageCalc();
                                                              }
                                                            });

                                                          }
                                                          else {
                                                            setState(() {
                                                              qn.productionMaterialMappingList[index].isDelete=true;
                                                            });
                                                            qn.productionMaterialMappingList[index].scaleController.reverse().whenComplete(() {
                                                              if (this.mounted) {
                                                                if(qn.productionMaterialMappingList[index].MaterialName=='Dust'){
                                                                  setState(() {
                                                                    qn.dustQty=0.0;
                                                                    qn.isWastage=false;
                                                                  });
                                                                }
                                                                setState(() {
                                                                  qn.productionMaterialMappingList.removeAt(index);
                                                                });
                                                                qn.wastageCalc();
                                                              }
                                                              // setState(() {
                                                              //     qn.productionMaterialMappingList.removeAt(index);
                                                              //   });
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
                                                  qn.productionMaterialMappingList[index].MaterialName!='Dust'?Container():
                                                  Text("Do you want to add this product to Wastage?",
                                                    style: TextStyle(fontSize: 12,fontFamily: 'RR',color: AppTheme.hintColor),
                                                  )
                                                ],
                                              ),

                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),



                                  ///////////// Material Name Ver-2/////////////////

                                 /* Container(
                                    //  duration: Duration(milliseconds: 300),
                                    // curve: Curves.easeIn,
                                    height: qn.productionMaterialMappingList.length == 0 ? 0 :
                                    ( qn.productionMaterialMappingList.length * 50.0)+40,
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
                                      *//*  boxShadow: [
                                          qn.productionMaterialMappingList.length == 0 ? BoxShadow() :
                                          BoxShadow(
                                            color: AppTheme.addNewTextFieldText
                                                .withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 15,
                                            offset: Offset(0, 0), // changes position of shadow
                                          )
                                        ]*//*
                                    ),
                                    child: Column(
                                      children: [

                                        Container(
                                          height: 40,
                                          width: SizeConfig.screenWidth,

                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5),),

                                            *//* border: Border(
                                                  bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5))
                                              )*//*
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Material name"),
                                              Text("Material Price"),
                                              Text("Material Unit"),

                                            ],

                                          ),
                                        ),

                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: qn.productionMaterialMappingList.length,
                                            itemBuilder: (context, index) {
                                              return SlideTransition(
                                                position: Tween<Offset>(begin: Offset(qn.productionMaterialMappingList[index].isEdit ? 0.0 :
                                                qn.productionMaterialMappingList[index].isDelete ?1.0:0.0,
                                                    qn.productionMaterialMappingList[index].isEdit ? 0.0 :qn.productionMaterialMappingList[index].isDelete ?0.0: 1.0),
                                                    end:qn.productionMaterialMappingList[index].isEdit ?Offset(1, 0): Offset.zero)
                                                    .animate(qn.productionMaterialMappingList[index].scaleController),

                                                child: FadeTransition(
                                                  opacity: Tween(begin: qn.productionMaterialMappingList[index].isEdit ? 1.0 : 0.0,
                                                      end: qn.productionMaterialMappingList[index].isEdit ? 0.0 : 1.0)
                                                      .animate(qn.productionMaterialMappingList[index].scaleController),
                                                  child: Container(
                                                    padding: EdgeInsets.only(top: 5, bottom: 5),
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
                                                            qn.productionMaterialMappingList[index].MaterialName!='Dust'?
                                                            Container(
                                                              width: SizeConfig.width100,
                                                              child: Text("${qn.productionMaterialMappingList[index].MaterialName}",
                                                                style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                              ),
                                                            ):
                                                            Container(
                                                              width: SizeConfig.width100,
                                                              child: Row(
                                                                children: [
                                                                  Text("${qn.productionMaterialMappingList[index].MaterialName}",
                                                                    style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                                  ),
                                                                  SizedBox(width: 10,),
                                                                  GestureDetector(
                                                                    onTap: (){
                                                                      setState(() {
                                                                        qn.isWastage=!qn.isWastage;
                                                                      });
                                                                      qn.wastageCalc();
                                                                    },
                                                                    child: AnimatedContainer(
                                                                      duration: Duration(milliseconds: 300),
                                                                      curve: Curves.easeIn,
                                                                      height: 20,
                                                                      width: 20,
                                                                      decoration: BoxDecoration(
                                                                          color:qn.isWastage?AppTheme.yellowColor: AppTheme.uploadColor.withOpacity(0.2),
                                                                          borderRadius: BorderRadius.circular(3),
                                                                          border: Border.all(color:qn.isWastage?AppTheme.yellowColor: AppTheme.addNewTextFieldBorder)
                                                                      ),
                                                                      child: Center(
                                                                        child: Icon(Icons.done,color:qn.isWastage?AppTheme.bgColor: AppTheme.addNewTextFieldBorder.withOpacity(0.5),size: 15,),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.only(left: 5),
                                                              alignment: Alignment.centerLeft,
                                                              width: SizeConfig.width60,
                                                              child: Text("${qn.productionMaterialMappingList[index].OutputMaterialQuantity}",
                                                                style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment: Alignment.centerRight,
                                                              width: SizeConfig.width70 +
                                                                  SizeConfig.width5,
                                                              child: Text("${qn.productionMaterialMappingList[index].MaterialUnit}",
                                                                style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            GestureDetector(
                                                              onTap: () {

                                                                print(qn.isProductionEdit);

                                                                if (qn.productionMaterialMappingList[index].isEdit) {
                                                                  qn.productionMaterialMappingList[index].scaleController.forward().whenComplete(() {
                                                                    print("EIT");
                                                                    if (this.mounted) {
                                                                      if(qn.productionMaterialMappingList[index].MaterialName=='Dust'){
                                                                        setState(() {
                                                                          qn.dustQty=0.0;
                                                                          qn.isWastage=false;
                                                                        });
                                                                      }
                                                                      setState(() {
                                                                        qn.productionMaterialMappingList.removeAt(index);
                                                                      });
                                                                      qn.wastageCalc();
                                                                    }
                                                                  });

                                                                }
                                                                else {
                                                                  setState(() {
                                                                    qn.productionMaterialMappingList[index].isDelete=true;
                                                                  });



                                                                  qn.productionMaterialMappingList[index].scaleController.reverse().whenComplete(() {
                                                                    if (this.mounted) {
                                                                      if(qn.productionMaterialMappingList[index].MaterialName=='Dust'){
                                                                        setState(() {
                                                                          qn.dustQty=0.0;
                                                                          qn.isWastage=false;
                                                                        });
                                                                      }
                                                                      setState(() {
                                                                        qn.productionMaterialMappingList.removeAt(index);
                                                                      });
                                                                      qn.wastageCalc();
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
                                                        qn.productionMaterialMappingList[index].MaterialName!='Dust'?Container():
                                                        Text("Do you want to add this product to Wastage?",
                                                          style: TextStyle(fontSize: 12,fontFamily: 'RR',color: AppTheme.hintColor),
                                                        )
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
                                  ),*/


                                  Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          node.unfocus();
                                          setState(() {
                                            _keyboardVisible=false;
                                            productionMaterailOpen = true;
                                          });

                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.width20,
                                            right: SizeConfig.width10,
                                            top: SizeConfig.height20,),
                                          padding: EdgeInsets.only(
                                              left: SizeConfig.width5,
                                              right: SizeConfig.width5),
                                          height: 50,
                                          width: SizeConfig.width140,
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(qn.productionMaterialName == null ? "Material Name" : qn.productionMaterialName,
                                                style: TextStyle(fontFamily: 'RR', fontSize: 16,
                                                  color: qn.productionMaterialName == null ? AppTheme.addNewTextFieldText.withOpacity(0.5) : AppTheme.addNewTextFieldText,),
                                              ),
                                              Spacer(),
                                              Container(
                                                  height: SizeConfig.height25,
                                                  width: SizeConfig.height25,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: qn.productionMaterialName == null ? AppTheme.addNewTextFieldText : AppTheme.yellowColor,
                                                  ),

                                                  child: Center(child: Icon(
                                                    Icons.arrow_forward_ios_outlined, color: Colors.white, size: 14,)))
                                            ],
                                          ),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          width: SizeConfig.width130,
                                          height:50,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              top: SizeConfig.height20,
                                              right: SizeConfig.width20),
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
                                            controller: qn.materialWeight,
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              hintStyle: TextStyle(fontFamily: 'RL', fontSize: 15, color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
                                              border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)),
                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.addNewTextFieldFocusBorder)
                                              ),
                                              hintText: "Weight",
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

                                              if(qn.productionMaterialId==null){
                                                CustomAlert().commonErrorAlert(context, "Select Output Material", "");
                                              }
                                              else if(qn.materialWeight.text.isEmpty){
                                                CustomAlert().commonErrorAlert(context, "Enter Output Material Weight", "");
                                              }
                                              else{
                                                Timer(Duration(milliseconds: 300), () {
                                                  setState(() {
                                                    qn.productionMaterialMappingList.add(
                                                        ProductionMaterialMappingListModel(
                                                            OutputMaterialId: qn.productionMaterialId,
                                                            MaterialName: qn.productionMaterialName,
                                                            MaterialUnit: qn.selectInputUnitName,
                                                            UnitId: qn.selectInputUnitId,
                                                            OutputMaterialQuantity: qn.materialWeight.text.isEmpty?0.0:double.parse(qn.materialWeight.text),

                                                            IsActive: 1,
                                                            scaleController: AnimationController(duration: Duration(milliseconds: 300), vsync: this),
                                                            isEdit: false,
                                                          isDelete: false
                                                        )
                                                    );

                                                    if(qn.productionMaterialName=='Dust'){
                                                      qn.dustQty=double.parse(qn.materialWeight.text);
                                                    }

                                                  });

                                                  listViewController.animateTo(listViewController.position.maxScrollExtent,
                                                      duration: Duration(milliseconds: 200), curve: Curves.easeIn).then((value) {
                                                    qn.productionMaterialMappingList[qn.productionMaterialMappingList.length - 1].scaleController
                                                        .forward().then((value) {
                                                      listViewController.animateTo(listViewController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                      qn.clearMappingList();
                                                    });
                                                  });
                                                  qn.wastageCalc();
                                                });
                                              }
                                            });




                                          },
                                          child: Container(
                                            height: SizeConfig.height40,
                                            width: SizeConfig.height40,
                                            margin: EdgeInsets.only(top: SizeConfig.height25, right: SizeConfig.width25),
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
                                  SizedBox(height: SizeConfig.height20,),
                                  Align(
                                      alignment: Alignment.center,
                                      child:qn.wastageQty.toInt()==0?Container(): Container(

                                        width: SizeConfig.screenWidth,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(left: SizeConfig.screenWidth*0.4),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [
                                            Text("Wastage",style: TextStyle(fontFamily: 'RR',color: AppTheme.red,fontSize: 14),),
                                            SizedBox(height: 5,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text("${qn.wastageQty}",
                                                    style: TextStyle(fontFamily: 'RR',color: AppTheme.red,fontSize: 30),
                                                ),
                                                Padding(
                                                  padding:  EdgeInsets.only(bottom: 5,left: 2),
                                                  child: Text("${qn.selectInputUnitName}",
                                                      style: TextStyle(fontFamily: 'RR',color: AppTheme.red,fontSize: 15),
                                                  ),
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
                        qn.clearForm();
                        Navigator.pop(context);
                      }),
                      SizedBox(width: SizeConfig.width5,),
                      Text("Production Detail",
                        style: TextStyle(fontFamily: 'RR',
                            color: Colors.black,
                            fontSize: SizeConfig.width16),
                      ),
                      Text(qn.isProductionEdit ? " / Edit" : " / Add New",
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
                    height:_keyboardVisible?0: 60,

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
                        Container(
                          margin:EdgeInsets.only(top: 0),
                          child: CustomPaint(
                            size: Size( SizeConfig.screenWidth, 55),
                            painter: RPSCustomPainter(),
                          ),
                        ),
                        Center(
                          heightFactor: 0.5,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              if(qn.selectMachineId==null){
                                CustomAlert().commonErrorAlert(context, "Select Machine", "");
                              }
                              else if(qn.selectInputTypeId==null){
                                CustomAlert().commonErrorAlert(context, "Select Input Material", "");
                              }
                              else if(qn.materialQuantity.text.isEmpty){
                                CustomAlert().commonErrorAlert(context, "Enter Input Material Weight", "");
                              }
                              else if(qn.productionMaterialMappingList.isEmpty){
                                CustomAlert().commonErrorAlert(context, "Add Output Materials", "");
                              }
                              else{
                                qn.InsertProductionDbHit(context, this);
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
                  height: machineCategoryOpen || inputMaterialOpen || productionMaterailOpen? SizeConfig
                      .screenHeight : 0,
                  width: machineCategoryOpen || inputMaterialOpen || productionMaterailOpen? SizeConfig
                      .screenWidth : 0,
                  color: Colors.black.withOpacity(0.5),
                ),
                Container(
                  height: qn.ProductionLoader ? SizeConfig.screenHeight : 0,
                  width: qn.ProductionLoader ? SizeConfig.screenWidth : 0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.yellowColor),),
                    //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

                  ),
                ),


///////////////////////////////////////      Machine CATEGORY ////////////////////////////////
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
                      margin: EdgeInsets.only(
                          left: SizeConfig.width30, right: SizeConfig.width30),
                      transform: Matrix4.translationValues(
                          machineCategoryOpen ? 0 : SizeConfig.screenWidth, 0,
                          0),

                      child: Container(
                        height: SizeConfig.height430,
                        width: SizeConfig.screenWidth,
                        color: Colors.white,
                        //  padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: SizeConfig.height50,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                          icon: Icon(Icons.cancel),
                                          onPressed: () {
                                            setState(() {
                                              machineCategoryOpen = false;
                                            });
                                          }),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text('Select Machine Category',
                                          style: TextStyle(color: Colors.black,
                                              fontFamily: 'RR',
                                              fontSize: 16),)),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.height10,),
                              Container(
                                height: SizeConfig.screenHeight * (300 / 720),
                                color: Colors.white,
                                margin: EdgeInsets.only(left: SizeConfig
                                    .width30, right: SizeConfig.width30),
                                child: ListView.builder(
                                   itemCount: qn.machineCategoryList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          qn.selectMachineId=qn.machineCategoryList[index].machineId;
                                          qn.selectMachineName=qn.machineCategoryList[index].machineName;
                                          machineCategoryOpen = false;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                8),
                                            border: Border.all(
                                                color: qn.selectMachineId ==
                                                    null ? AppTheme
                                                    .addNewTextFieldBorder : qn
                                                    .selectMachineId ==
                                                    qn.machineCategoryList[index]
                                                        .machineId
                                                    ? Colors.transparent
                                                    : AppTheme
                                                    .addNewTextFieldBorder),
                                            color: qn.selectMachineId == null
                                                ? Colors.white
                                                : qn.selectMachineId ==
                                                qn.machineCategoryList[index]
                                                    .machineId ? AppTheme
                                                .popUpSelectedColor : Colors
                                                .white
                                        ),
                                        width: 300,
                                        height: 50,
                                        child: Text("${qn.machineCategoryList[index]
                                            .machineName}",
                                          style: TextStyle(
                                              color: qn.selectMachineId == null
                                                  ? AppTheme.grey
                                                  : qn.selectMachineId ==
                                                  qn.machineCategoryList[index]
                                                      .machineId ? Colors
                                                  .white : AppTheme.grey,
                                              fontSize: 18, fontFamily: 'RR'),
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

///////////////////////////////////////      Input MATERIAL ////////////////////////////////
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
                      margin: EdgeInsets.only(
                          left: SizeConfig.width30, right: SizeConfig.width30),
                       transform: Matrix4.translationValues(inputMaterialOpen?0:SizeConfig.screenWidth, 0, 0),

                      child: Container(
                        height: SizeConfig.height430,
                        width: SizeConfig.screenWidth,
                        color: Colors.white,
                        //  padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: SizeConfig.height50,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                          icon: Icon(Icons.cancel),
                                          onPressed: () {
                                            setState(() {
                                              inputMaterialOpen=false;
                                            });
                                          }),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text('Select Input Material',
                                          style: TextStyle(color: Colors.black,
                                              fontFamily: 'RR',
                                              fontSize: 16),)),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.height10,),
                              Container(
                                height: SizeConfig.screenHeight * (300 / 720),
                                color: Colors.white,
                                margin: EdgeInsets.only(left: SizeConfig
                                    .width30, right: SizeConfig.width30),
                                child: ListView.builder(
                                  itemCount: qn.inputMaterialList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          qn.selectInputTypeId=qn.inputMaterialList[index].materialId;
                                          qn.selectInputTypeName=qn.inputMaterialList[index].materialName;
                                          qn.selectInputUnitId=qn.inputMaterialList[index].MaterialUnitId;
                                          qn.selectInputUnitName=qn.inputMaterialList[index].UnitName;
                                          inputMaterialOpen=false;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            borderRadius:BorderRadius.circular(8),
                                            border: Border.all(color: qn.selectInputTypeId==null? AppTheme.addNewTextFieldBorder:qn.selectInputTypeId==qn.inputMaterialList[index].materialId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                            color: qn.selectInputTypeId==null? Colors.white: qn.selectInputTypeId==qn.inputMaterialList[index].materialId?AppTheme.popUpSelectedColor:Colors.white
                                        ),
                                        width: 300,
                                        height: 50,
                                        child: Text("${qn.inputMaterialList[index].materialName}",
                                          style: TextStyle(color:qn.selectInputTypeId==null? AppTheme.grey:qn.selectInputTypeId==qn.inputMaterialList[index].materialId?Colors.white:AppTheme.grey,
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
                /////////////////////////////////// material Name/////////////////////////////////////////////////////
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
                      transform: Matrix4.translationValues(productionMaterailOpen?0:SizeConfig.screenWidth, 0, 0),

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
                                          productionMaterailOpen=false;
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
                                  itemCount: qn.MaterialList.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                        if(qn.MaterialList[index].materialName!='Dust'){
                                          setState(() {
                                            qn.productionMaterialId=qn.MaterialList[index].materialId;
                                            qn.productionMaterialName=qn.MaterialList[index].materialName;
                                            productionMaterailOpen=false;
                                          });
                                        }
                                        else{
                                          if(qn.productionMaterialMappingList.any((element) => element.MaterialName=='Dust')){
                                            CustomAlert().commonErrorAlert(context, "Dust Already Added", "You cant add Extra Dust");
                                          }
                                          else{
                                            setState(() {
                                              qn.productionMaterialId=qn.MaterialList[index].materialId;
                                              qn.productionMaterialName=qn.MaterialList[index].materialName;
                                              productionMaterailOpen=false;
                                            });
                                          }
                                        }


                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            borderRadius:BorderRadius.circular(8),
                                            border: Border.all(color: qn.productionMaterialId==null? AppTheme.addNewTextFieldBorder:qn.productionMaterialId==qn.MaterialList[index].materialId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                            color: qn.productionMaterialId==null? Colors.white: qn.productionMaterialId==qn.MaterialList[index].materialId?AppTheme.popUpSelectedColor:Colors.white
                                        ),
                                        width:300,
                                        height:50,
                                        child: Text("${qn.MaterialList[index].materialName}",
                                          style: TextStyle(color:qn.productionMaterialId==null? AppTheme.grey:qn.productionMaterialId==qn.MaterialList[index].materialId?Colors.white:AppTheme.grey,
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