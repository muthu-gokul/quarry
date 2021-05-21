import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/productionDetailsModel/productionMaterialMappingListModel.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/calculation.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';
import 'package:quarry/widgets/validationErrorText.dart';


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
  bool isPlantOpen=false;
  bool productionMaterailOpen=false;

  bool machine=false;
  bool inputMaterial=false;
  bool qty=false;
  bool plant=false;


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
      resizeToAvoidBottomInset: false,
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
                        height: 180,

                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/svg/gridHeader/productionHeader.jpg",),
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
                                      text: qn.plantName==null? "Select Plant":qn.plantName,
                                      textColor: qn.plantName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: qn.plantName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                      bgColor: qn.plantName==null? AppTheme.disableColor:Colors.white,

                                    ),
                                  ),
                                  plant?ValidationErrorText(title: "* Select Plant",):Container(),
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
                                  !machine?Container():ValidationErrorText(title: "* Select Machine ",),
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
                                  !inputMaterial?Container():ValidationErrorText(title: "* Select Input Material ",),
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
                                  !qty?Container():ValidationErrorText(title: "* Enter Input Material Qty",),


                                  ///////////// Material Name/////////////////
                                  Container(
                                    //  duration: Duration(milliseconds: 300),
                                    // curve: Curves.easeIn,
                                    height: qn.productionMaterialMappingList.length == 0 ? 0 :
                                    ( qn.productionMaterialMappingList.length * 50.0)+40,
                                    constraints: BoxConstraints(
                                        maxHeight: 300
                                    ),
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
                                    ),
                                    child: Column(
                                      children: [

                                        Container(
                                          height: 40,
                                          width: SizeConfig.screenWidth,
                                          padding: EdgeInsets.only(left: 10,right: 10,),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5),),
                                          ),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(width: SizeConfig.screenWidthM40*0.35,child: Text("Material Name")),
                                              Container(padding: EdgeInsets.only(left: 10),alignment: Alignment.centerLeft, width: SizeConfig.screenWidthM40*0.3,child: Text("Quantity")),
                                              Container(padding: EdgeInsets.only(left: 10), width: SizeConfig.screenWidthM40*0.2,child: Text("Unit")),

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
                                                    height: 50,
                                                    padding: EdgeInsets.only(left: 10,right: 10),
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5))
                                                        )
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            qn.productionMaterialMappingList[index].MaterialName.toLowerCase()!='dust'?
                                                            Container(
                                                              width: SizeConfig.screenWidthM40*0.35,
                                                              alignment:Alignment.centerLeft,

                                                              child: Text("${qn.productionMaterialMappingList[index].MaterialName}",
                                                                style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                              ),
                                                            ):
                                                            Container(
                                                              width: SizeConfig.screenWidthM40*0.35,
                                                              alignment:Alignment.centerLeft,
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
                                                              padding: EdgeInsets.only(left: 10),
                                                              alignment: Alignment.centerLeft,

                                                              width: SizeConfig.screenWidthM40*0.3,
                                                              child: FittedBox(
                                                                child: Text("${qn.productionMaterialMappingList[index].OutputMaterialQuantity}",
                                                                  style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment: Alignment.centerLeft,
                                                              width:SizeConfig.screenWidthM40*0.2,
                                                              padding: EdgeInsets.only(left: 10),


                                                              child: Text("${qn.productionMaterialMappingList[index].MaterialUnit}",
                                                                style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            GestureDetector(
                                                              onTap: () {

                                                                CustomAlert(
                                                                  Cancelcallback: (){
                                                                    Navigator.pop(context);
                                                                  },
                                                                  callback: (){
                                                                    Navigator.pop(context);
                                                                    Timer(Duration(milliseconds: 200), (){
                                                                      if (qn.productionMaterialMappingList[index].isEdit) {
                                                                        qn.productionMaterialMappingList[index].scaleController.forward().whenComplete(() {
                                                                          if (this.mounted) {
                                                                            if(qn.productionMaterialMappingList[index].MaterialName.toLowerCase()=='dust'){
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
                                                                            if(qn.productionMaterialMappingList[index].MaterialName.toLowerCase()=='dust'){
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
                                                                    });
                                                                  }
                                                                ).yesOrNoDialog(context, "", "Are you sure want to delete this material ?");







                                                              },
                                                              child: Container(
                                                                  height: 20,
                                                                  width: 20,
                                                                  child: SvgPicture.asset("assets/svg/delete.svg",color: AppTheme.red)
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                        qn.productionMaterialMappingList[index].MaterialName.toLowerCase()!='dust'?Container():
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
                                  ),





                                  Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          node.unfocus();
                                          if(qn.selectInputTypeName==null){
                                            CustomAlert().commonErrorAlert(context, "Select Input Material", "");
                                          }
                                          else if(qn.materialQuantity.text.isEmpty){
                                            CustomAlert().commonErrorAlert(context, "Enter Input Material Qty", "");
                                          }
                                          else{
                                            setState(() {
                                              _keyboardVisible=false;
                                              productionMaterailOpen = true;
                                            });

                                          }

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
                                                qn.totalOutputQty=0.0;
                                                qn.productionMaterialMappingList.forEach((element) {
                                                  qn.totalOutputQty=Calculation().add(qn.totalOutputQty, element.OutputMaterialQuantity);
                                                });
                                                qn.totalOutputQty=Calculation().add(qn.totalOutputQty, qn.materialWeight.text);
                                                if(qn.totalOutputQty<double.parse(qn.materialQuantity.text)){
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

                                                      if(qn.productionMaterialName.toString().toLowerCase()=='dust'){
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
                                                else{
                                                  CustomAlert().commonErrorAlert(context, "Excess Weight", "Total Output Material Weight should be less than input Material Weight");
                                                }

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
                      CancelButton(
                        ontap: (){
                          qn.clearForm();
                          Navigator.pop(context);
                        },
                      ),

                      Text("Production Detail",
                        style: TextStyle(fontFamily: 'RR',
                            color: AppTheme.bgColor,
                            fontSize: 16),
                      ),
                      Text(qn.isProductionEdit ? " / Edit" : " / Add New",
                        style: TextStyle(fontFamily: 'RR',
                            color: AppTheme.bgColor,fontSize: 16),
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
                      if( qn.plantId==null) {setState(() {plant = true;});}
                      else{setState(() {plant=false;});}

                      if(qn.selectMachineId==null){setState(() {machine=true;});}
                      else{setState(() {machine=false;});}

                      if(qn.selectInputTypeId==null){setState(() {inputMaterial=true;});}
                      else{setState(() {inputMaterial=false;});}

                      if(qn.materialQuantity.text.isEmpty){setState(() {qty=true;});}
                      else{setState(() {qty=false;});}



                       if(qn.productionMaterialMappingList.isEmpty){
                        CustomAlert().commonErrorAlert(context, "Add Output Materials", "");
                      }
                      if(!plant && !machine && !inputMaterial && !qty && qn.productionMaterialMappingList.isNotEmpty){
                        qn.InsertProductionDbHit(context, this);
                      }


                    },
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



                ///////////////////////////////////////   Plant List    ////////////////////////////////
                PopUpStatic(
                  title: "Select Plant",
                  isOpen: isPlantOpen,
                  dataList: qn.plantList,
                  propertyKeyName:"PlantName",
                  propertyKeyId: "PlantId",
                  selectedId: qn.plantId,
                  itemOnTap: (index){
                    setState(() {
                      qn.plantId=qn.plantList[index].plantId;
                      qn.plantName=qn.plantList[index].plantName;
                      isPlantOpen=false;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      isPlantOpen=false;
                    });
                  },
                ),
///////////////////////////////////////      Machine CATEGORY ////////////////////////////////

                PopUpStatic(
                  title: "Select Machine",
                  isOpen: machineCategoryOpen,
                  dataList: qn.machineCategoryList,
                  propertyKeyName:"MachineName",
                  propertyKeyId: "MachineId",
                  selectedId: qn.selectMachineId,
                  itemOnTap: (index){
                    setState(() {
                      qn.selectMachineId=qn.machineCategoryList[index].machineId;
                      qn.selectMachineName=qn.machineCategoryList[index].machineName;
                      machineCategoryOpen = false;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      machineCategoryOpen=false;
                    });
                  },
                ),



///////////////////////////////////////      Input MATERIAL ////////////////////////////////
                PopUpStatic(
                  title: "Select Input Material",
                  isAlwaysShown: true,
                  isOpen: inputMaterialOpen,
                  dataList: qn.inputMaterialList,
                  propertyKeyName:"MaterialName",
                  propertyKeyId: "MaterialId",
                  selectedId: qn.inputMaterialList,
                  itemOnTap: (index){
                    setState(() {
                      qn.selectInputTypeId=qn.inputMaterialList[index].materialId;
                      qn.selectInputTypeName=qn.inputMaterialList[index].materialName;
                      qn.selectInputUnitId=qn.inputMaterialList[index].MaterialUnitId;
                      qn.selectInputUnitName=qn.inputMaterialList[index].UnitName;
                      inputMaterialOpen=false;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      inputMaterialOpen=false;
                    });
                  },
                ),

                /////////////////////////////////// material Name/////////////////////////////////////////////////////
                PopUpStatic(
                  title: "Select Material",
                  isAlwaysShown: true,
                  isOpen: productionMaterailOpen,
                  dataList: qn.MaterialList,
                  propertyKeyName:"MaterialName",
                  propertyKeyId: "MaterialId",
                  selectedId: qn.productionMaterialId,
                  itemOnTap: (index){
                    if(qn.productionMaterialMappingList.any((element) => element.MaterialName.toLowerCase()==qn.MaterialList[index].materialName.toLowerCase())){
                      CustomAlert().commonErrorAlert(context, "Material Already Added","");
                    }
                    else{
                      if(qn.MaterialList[index].materialName.toLowerCase()!='dust'){
                        setState(() {
                          qn.productionMaterialId=qn.MaterialList[index].materialId;
                          qn.productionMaterialName=qn.MaterialList[index].materialName;
                          productionMaterailOpen=false;
                        });
                      }
                      else{
                        if(qn.productionMaterialMappingList.any((element) => element.MaterialName.toLowerCase()=='dust')){
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
                    }


                  },
                  closeOnTap: (){
                    setState(() {
                      productionMaterailOpen=false;
                    });
                  },
                ),



              ],
            ),
    ),
    );

  }

}