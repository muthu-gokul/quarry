import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/supplierDetailModel/SupplierMaterialMappingListModel.dart';
import 'package:quarry/notifier/machineNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/pages/quarryMaster/quarryLocationAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/constants.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/sidePopUp/sidePopUpWithoutSearch.dart';
import 'package:quarry/widgets/validationErrorText.dart';


class SupplierDetailAddNew extends StatefulWidget {
  @override
  SupplierDetailAddNewState createState() => SupplierDetailAddNewState();
}

class SupplierDetailAddNewState extends State<SupplierDetailAddNew> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();
  bool _keyboardVisible = false;

  ScrollController scrollController;
  ScrollController listViewController;
  bool supplierCategoryOpen=false;
  bool supplierMaterialOpen=false;

  bool isListScroll=false;

  bool supplierName=false;
  bool supplierCategory=false;
  bool supplierAddress=false;
  bool supplierPhoneNum=false;
  bool supplierGst=false;
  bool emailValid=true;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){


      scrollController=new ScrollController();
      listViewController=new ScrollController();
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //_keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final node=FocusScope.of(context);
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
        key: scaffoldkey,
        body: Consumer<SupplierNotifier>(
            builder: (context,qn,child)=> Stack(
              children: [



                //IMAGE
                Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  child: Column(
                    children: [
                      Container(
                        width: SizeConfig.screenWidth,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppTheme.yellowColor,
                           image: DecorationImage(
                                     image: AssetImage("assets/svg/gridHeader/supplierHeader.jpg",),
                                   fit: BoxFit.cover
                                 )

                        ),
                       // child: SvgPicture.asset("assets/svg/gridHeader/supplierHeader.svg"),

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
                        GestureDetector(
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
                            height: SizeConfig.screenHeight-60,
                            width: SizeConfig.screenWidth,

                            decoration: BoxDecoration(
                                color: AppTheme.gridbodyBgColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                            ),
                            alignment: Alignment.topCenter,
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

                                  AddNewLabelTextField(
                                    labelText: 'Supplier Name',
                                    regExp: '[A-Za-z  ]',
                                    textEditingController: qn.supplierName,
                                    onEditComplete: (){
                                      node.unfocus();
                                      setState(() {
                                        _keyboardVisible=false;
                                      });
                                    },
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      setState(() {
                                        _keyboardVisible=true;
                                      });
                                    },
                                  ),
                                  !supplierName?Container():ValidationErrorText(title: "* Enter Supplier Name",),
                                  GestureDetector(
                                    onTap: (){
                                      node.unfocus();
                                      setState(() {
                                        supplierCategoryOpen=true;
                                        setState(() {
                                          _keyboardVisible=false;
                                        });
                                      });
                                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                                    },
                                    child: SidePopUpParent(
                                      text: qn.supplierCategoryName==null? "Select Category":qn.supplierCategoryName,
                                      textColor: qn.supplierCategoryName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: qn.supplierCategoryName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                      bgColor:  qn.supplierCategoryName==null? AppTheme.disableColor:Colors.white,
                                    ),
                                  ),
                                  !supplierCategory?Container():ValidationErrorText(title: "* Select Category"),
                                  AddNewLabelTextField(
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                        setState(() {
                                          _keyboardVisible=true;
                                         // isListScroll=true;
                                        });
                                    },
                                    labelText: 'Address',
                                    textEditingController: qn.supplierAddress,
                                    onEditComplete: (){
                                      node.unfocus();
                                      setState(() {
                                        _keyboardVisible=false;
                                      });
                                    },
                                  ),
                                  !supplierAddress?Container():ValidationErrorText(title: "* Enter Address",),
                                  AddNewLabelTextField(
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      setState(() {
                                        _keyboardVisible=true;
                                       // isListScroll=true;
                                      });
                                    },
                                    labelText: 'City',
                                    regExp: '[A-Za-z  ]',
                                    textEditingController: qn.supplierCity,
                                    onEditComplete: (){
                                      node.unfocus();
                                      setState(() {
                                        _keyboardVisible=false;
                                      });
                                    },
                                  ),

                                  AddNewLabelTextField(
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      setState(() {
                                        _keyboardVisible=true;
                                        isListScroll=true;
                                      });
                                    },
                                    labelText: 'State',
                                    regExp: '[A-Za-z  ]',
                                    textEditingController: qn.supplierState,
                                    scrollPadding: 400,
                                    onEditComplete: (){
                                      node.unfocus();
                                      setState(() {
                                        _keyboardVisible=false;
                                      });
                                    },
                                  ),
                                  AddNewLabelTextField(
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      setState(() {
                                        isListScroll=true;
                                        _keyboardVisible=true;
                                      });
                                    },
                                    labelText: 'Country',
                                    regExp: '[A-Za-z  ]',
                                    textEditingController: qn.supplierCountry,
                                    scrollPadding: 400,
                                    onEditComplete: (){
                                      node.unfocus();
                                      setState(() {
                                        _keyboardVisible=false;
                                      });
                                    },
                                  ),
                                  AddNewLabelTextField(
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      setState(() {
                                        isListScroll=true;
                                        _keyboardVisible=true;
                                      });
                                    },
                                    labelText: 'Zipcode',
                                    regExp: '[0-9]',
                                    textLength: zipcodeLength,
                                    textEditingController: qn.supplierZipcode,
                                    scrollPadding: 400,
                                    textInputType: TextInputType.number,
                                    onEditComplete: (){
                                      node.unfocus();
                                      setState(() {
                                        _keyboardVisible=false;
                                      });
                                    },
                                  ),
                                  AddNewLabelTextField(
                                    labelText: 'Contact Number',
                                    textEditingController: qn.supplierContactNumber,
                                    textLength: phoneNoLength,
                                    regExp: '[0-9]',
                                    scrollPadding: 400,
                                    textInputType: TextInputType.number,
                                    onEditComplete: (){
                                      node.unfocus();
                                      setState(() {
                                        _keyboardVisible=false;
                                      });
                                    },
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      setState(() {
                                        isListScroll=true;
                                        _keyboardVisible=true;
                                      });
                                    },
                                  ),
                                  !supplierPhoneNum?Container():ValidationErrorText(title: "* Enter Contact Number",),
                                  AddNewLabelTextField(
                                    labelText: 'Email',
                                    textEditingController: qn.supplierEmail,
                                    textInputType: TextInputType.emailAddress,
                                    scrollPadding: 400,
                                    onEditComplete: (){
                                      node.unfocus();
                                      setState(() {
                                        _keyboardVisible=false;
                                      });
                                    },
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      setState(() {
                                        isListScroll=true;
                                        _keyboardVisible=true;
                                      });
                                    },
                                  ),
                                  emailValid?Container():ValidationErrorText(title: "* Invalid Email Address",),
                                  AddNewLabelTextField(
                                    labelText: 'GST Number',
                                    textEditingController: qn.supplierGstNo,
                                    scrollPadding: 400,
                                    regExp: '[A-Za-z0-9  ]',
                                    onEditComplete: (){
                                      node.unfocus();
                                      setState(() {
                                        _keyboardVisible=false;
                                      });
                                    },
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      setState(() {
                                        isListScroll=true;
                                        _keyboardVisible=true;
                                      });
                                    },
                                  ),
                                  !supplierGst?Container():ValidationErrorText(title: "* Enter GST Number",),



                                  ////////////////////////////////////  MATERIALS LIST ///////////////////////

                                  Container(
                                    //  duration: Duration(milliseconds: 300),
                                    // curve: Curves.easeIn,
                                    height: qn.supplierMaterialMappingList.length == 0 ? 0 :
                                    ( qn.supplierMaterialMappingList.length * 40.0)+40,
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
                                          padding: EdgeInsets.only(left: 10,right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5),),
                                          ),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(width: SizeConfig.screenWidthM40*0.35,child: Text("Material Name")),
                                              Container(padding: EdgeInsets.only(left: 10),alignment: Alignment.centerLeft, width: SizeConfig.screenWidthM40*0.25,child: Text("Price")),
                                              Container(padding: EdgeInsets.only(left: 10), width: SizeConfig.screenWidthM40*0.25,child: Text("Unit")),

                                            ],

                                          ),
                                        ),

                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: qn.supplierMaterialMappingList.length,
                                            itemBuilder: (context, index) {
                                              return SlideTransition(
                                                position: Tween<Offset>(begin: Offset(qn.supplierMaterialMappingList[index].isEdit ? 0.0 :
                                                qn.supplierMaterialMappingList[index].isDelete ?1.0:0.0,
                                                    qn.supplierMaterialMappingList[index].isEdit ? 0.0 :qn.supplierMaterialMappingList[index].isDelete ?0.0: 1.0),
                                                    end:qn.supplierMaterialMappingList[index].isEdit ?Offset(1, 0): Offset.zero)
                                                    .animate(qn.supplierMaterialMappingList[index].scaleController),

                                                child: FadeTransition(
                                                  opacity: Tween(begin: qn.supplierMaterialMappingList[index].isEdit ? 1.0 : 0.0,
                                                      end: qn.supplierMaterialMappingList[index].isEdit ? 0.0 : 1.0)
                                                      .animate(qn.supplierMaterialMappingList[index].scaleController),
                                                  child: Container(
                                                    height: 40,
                                                    padding: EdgeInsets.only(top: 10, bottom: 0,left: 10,right: 10),
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
                                                              width: SizeConfig.screenWidthM40*0.35,
                                                              alignment:Alignment.centerLeft,

                                                              child: Text("${qn.supplierMaterialMappingList[index].MaterialName}",
                                                                style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.only(left: 10),
                                                              alignment: Alignment.centerLeft,

                                                              width: SizeConfig.screenWidthM40*0.25,
                                                              child: Text("${qn.supplierMaterialMappingList[index].MaterialPrice}",
                                                                style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor, letterSpacing: 0.2),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment: Alignment.centerLeft,
                                                              width:SizeConfig.screenWidthM40*0.25,
                                                              padding: EdgeInsets.only(left: 10),


                                                              child: Text("${qn.supplierMaterialMappingList[index].UnitName}",
                                                                style: TextStyle(fontSize: 14, fontFamily: 'RR', color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            GestureDetector(
                                                              onTap: () {


                                                                  if (qn.supplierMaterialMappingList[index].isEdit) {
                                                                    qn.supplierMaterialMappingList[index].scaleController.forward().whenComplete(() {

                                                                      if (this.mounted) {
                                                                        setState(() {
                                                                          qn.supplierMaterialMappingList.removeAt(index);
                                                                        });
                                                                      }
                                                                    });

                                                                  }
                                                                  else {
                                                                    setState(() {
                                                                      qn.supplierMaterialMappingList[index].isDelete=true;
                                                                    });
                                                                    qn.supplierMaterialMappingList[index].scaleController.reverse().whenComplete(() {
                                                                      if (this.mounted) {

                                                                        setState(() {
                                                                          qn.supplierMaterialMappingList.removeAt(index);
                                                                        });
                                                                      }
                                                                    });
                                                                  }





                                                              },
                                                              child: Container(
                                                                  height: 20,
                                                                  width: 20,
                                                                  child: SvgPicture.asset("assets/svg/delete.svg",color: AppTheme.red)
                                                              ),
                                                            ),

                                                          ],
                                                        ),


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

                                  qn.supplierCategoryName!='Fuel'? Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          node.unfocus();
                                          setState(() {
                                            supplierMaterialOpen=true;
                                          });
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                        },
                                        child:Container(
                                          margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width10,top:SizeConfig.height20,),
                                          padding: EdgeInsets.only(left:SizeConfig.width5,right:SizeConfig.width5),
                                          height: 50,
                                          width: SizeConfig.screenWidthM40*0.48,
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                            color: qn.supplierMaterialName==null?AppTheme.disableColor:Colors.white
                                          ),
                                          child: Row(
                                            children: [
                                              Text(qn.supplierMaterialName==null? "Select Material":qn.supplierMaterialName,
                                                style: TextStyle(fontFamily: 'RR',fontSize: 16,
                                                    color: qn.supplierMaterialName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,),
                                              ),
                                              Spacer(),
                                              Container(
                                                  height: 25,
                                                  width:25,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: qn.supplierMaterialName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                                  ),

                                                  child: Center(child: Icon(Icons.arrow_forward_ios_outlined,color:Colors.white ,size: 14,)))
                                            ],
                                          ),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          width: SizeConfig.screenWidthM40*0.48,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(top:SizeConfig.height20,right: SizeConfig.width20),
                                          child: TextFormField(
                                            onTap: (){
                                              scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                              setState(() {
                                                isListScroll=true;
                                                _keyboardVisible=true;
                                              });
                                            },
                                            scrollPadding: EdgeInsets.only(bottom: 400),
                                            style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:AppTheme.addNewTextFieldText,letterSpacing: 0.2),
                                            controller: qn.materialPrice,
                                            decoration: InputDecoration(
                                              fillColor:Colors.white,
                                              filled: true,
                                              hintStyle: TextStyle(fontFamily: 'RL',fontSize: 15,color: AppTheme.addNewTextFieldText.withOpacity(0.9)),
                                              border:  OutlineInputBorder(
                                                  borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: AppTheme.addNewTextFieldBorder)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color:AppTheme.addNewTextFieldFocusBorder)
                                              ),
                                              hintText: "Price",
                                              contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),

                                            ),
                                            maxLines: null,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                            ],
                                            textInputAction: TextInputAction.done,
                                            onEditingComplete: (){
                                              node.unfocus();
                                              setState(() {
                                                _keyboardVisible=false;
                                              });
                                            },
                                            onChanged: (v){

                                            },
                                          ),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () async {
                                            node.unfocus();

                                              setState(() {
                                                _keyboardVisible=false;
                                                qn.supplierMaterialMappingList.add(
                                                    SupplierMaterialMappingListModel(
                                                        MaterialId: qn.supplierMaterialId,
                                                        MaterialName: qn.supplierMaterialName,
                                                        MaterialPrice: double.parse(qn.materialPrice.text??"0.0") ,
                                                        UnitName: qn.supplierMaterialUnitName,
                                                        SupplierId: null,
                                                        SupplierMaterialMappingId: null,
                                                        IsActive: 1,
                                                        scaleController: AnimationController(duration: Duration(milliseconds: 300), vsync: this),
                                                        isEdit: false,
                                                        isDelete: false
                                                    )
                                                );
                                              });
                                              qn.clearMappingList();
                                            qn.supplierMaterialMappingList[qn.supplierMaterialMappingList.length-1].scaleController.forward().then((value){

                                            });
                                             /* listViewController.animateTo(listViewController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeIn).then((value) {

                                              });*/

                                          },
                                          child: Container(
                                            height:40,
                                            width: 40,
                                            margin: EdgeInsets.only(top:SizeConfig.height25,right: SizeConfig.width25),

                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:AppTheme.yellowColor,
                                            ),
                                            child: Center(
                                              child: Icon(Icons.add,color: AppTheme.bgColor,size: 30,),
                                            ),
                                          ),
                                        ),
                                      )


                                    ],
                                  ):Container(),

                                  //Logo
                                  SizedBox(height: 50,),
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
                                  SizedBox(height: 20,),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text("Upload Supplier Logo",
                                      style: TextStyle(fontFamily: 'RR',fontSize: 14,color: AppTheme.gridTextColor),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(

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
                                        child: Text("Choose File",style: TextStyle(color:AppTheme.bgColor,fontSize:16,fontFamily: 'RM'),
                                        )
                                    ),


                                  ),


                                  SizedBox(height: _keyboardVisible? SizeConfig.screenHeight*0.5:200,)
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
                      Text("Supplier Detail",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize:16),
                      ),
                      Text(qn.isSupplierEdit?" / Edit":" / Add New",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: 16),
                      ),
                    ],
                  ),
                ),


                //bottomNav
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    // height:_keyboardVisible?0:  70,
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
                        Container(
                          decoration: BoxDecoration(

                          ),
                          margin:EdgeInsets.only(top: 0),
                          child: CustomPaint(
                            size: Size( SizeConfig.screenWidth, 65),
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
                //addButton
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AddButton(
                    ontap: (){
                      node.unfocus();

                      if(qn.supplierEmail.text.isNotEmpty){
                        setState(() {
                          emailValid=EmailValidation().validateEmail(qn.supplierEmail.text);
                        });
                      }



                      if(qn.supplierName.text.isEmpty) {setState(() {supplierName=true;});}
                      else{setState(() {supplierName=false;});}

                      if(qn.supplierCategoryId==null) {setState(() {supplierCategory=true;});}
                      else{setState(() {supplierCategory=false;});}

                      if(qn.supplierAddress.text.isEmpty) {setState(() {supplierAddress=true;});}
                      else{setState(() {supplierAddress=false;});}

                      if(qn.supplierContactNumber.text.isEmpty) {setState(() {supplierPhoneNum=true;});}
                      else{setState(() {supplierPhoneNum=false;});}

                      if(qn.supplierGstNo.text.isEmpty) {setState(() {supplierGst=true;});}
                      else{setState(() {supplierGst=false;});}


                      if(qn.supplierCategoryName!='Fuel'){
                        if(qn.supplierMaterialMappingList.isEmpty){
                          CustomAlert().commonErrorAlert(context, "Select Materials", "");
                        }
                        else{
                          if(emailValid && !supplierName && !supplierCategory && !supplierAddress && !supplierPhoneNum && !supplierGst) {
                            qn.InsertSupplierDbHit(context,this);
                          }
                        }
                      }
                      else{
                        if(emailValid && !supplierName && !supplierCategory && !supplierAddress && !supplierPhoneNum && !supplierGst) {
                          qn.InsertSupplierDbHit(context,this);
                        }
                      }



                    },
                  ),
                ),











                Container(
                  height: supplierCategoryOpen || supplierMaterialOpen? SizeConfig.screenHeight:0,
                  width: supplierCategoryOpen || supplierMaterialOpen? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                ),
                Container(
                  height: qn.SupplierLoader? SizeConfig.screenHeight:0,
                  width: qn.SupplierLoader? SizeConfig.screenWidth:0,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellowColor),),
                    //Image.asset("assets/images/Loader.gif",filterQuality: FilterQuality.high,gaplessPlayback: true,isAntiAlias: true,)

                  ),
                ),






///////////////////////////////////////      SUPPLIER CATEGORY ////////////////////////////////
                PopUpStatic(
                  title: "Select Supplier Category",

                  isOpen: supplierCategoryOpen,
                  dataList: qn.supplierCategoryList,
                  propertyKeyName:"SupplierCategoryName",
                  propertyKeyId: "SupplierCategoryId",
                  selectedId: qn.supplierCategoryId,
                  itemOnTap: (index){
                    setState(() {
                      supplierCategoryOpen=false;
                      qn.supplierCategoryId=qn.supplierCategoryList[index].supplierCategoryId;
                      qn.supplierCategoryName=qn.supplierCategoryList[index].supplierCategoryName;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      supplierCategoryOpen=false;
                    });
                  },
                ),


///////////////////////////////////////      SUPPLIER MATERIAL ////////////////////////////////
                PopUpStatic(
                  title: "Select Material",
                  isAlwaysShown: true,
                  isOpen: supplierMaterialOpen,
                  dataList: qn.supplierMaterialList,
                  propertyKeyName:"MaterialName",
                  propertyKeyId: "MaterialId",
                  selectedId: qn.supplierMaterialId,
                  itemOnTap: (index){
                    setState(() {
                      supplierMaterialOpen=false;
                      qn.supplierMaterialId=qn.supplierMaterialList[index].materialId;
                      qn.supplierMaterialName=qn.supplierMaterialList[index].materialName;
                      qn.supplierMaterialUnitName=qn.supplierMaterialList[index].UnitName;
                    });
                  },
                  closeOnTap: (){
                    setState(() {
                      supplierMaterialOpen=false;
                    });
                  },


                ),



              ],
            )
        )

    );
  }
}






