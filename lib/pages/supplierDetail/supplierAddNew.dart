import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/supplierDetailModel/SupplierMaterialMappingListModel.dart';
import 'package:quarry/notifier/machineNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/pages/quarryMaster/quarryLocationAddNew.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/customTextField.dart';


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
        body: Consumer<SupplierNotifier>(
            builder: (context,qn,child)=> Stack(
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

                                  print("Scroll Start");
                                  // if(scrollController.offset==100){
                                  //   scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  // }
                                }
                              },
                              child: ListView(
                                controller: listViewController,
                                scrollDirection: Axis.vertical,

                                children: [
                                  AddNewLabelTextField(
                                    labelText: 'Supplier Name',
                                    textEditingController: qn.supplierName,
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      node.unfocus();
                                      setState(() {
                                        supplierCategoryOpen=true;
                                      });
                                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                                    },
                                    child: SidePopUpParent(
                                      text: qn.supplierCategoryName==null? "Select Unit":qn.supplierCategoryName,
                                      textColor: qn.supplierCategoryName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: qn.supplierCategoryName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                    ),
                                  ),
                                  AddNewLabelTextField(
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                    labelText: 'Address',
                                    textEditingController: qn.supplierAddress,
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                  ),
                                  AddNewLabelTextField(
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                    labelText: 'City',
                                    textEditingController: qn.supplierCity,
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                  ),

                                  AddNewLabelTextField(
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                    labelText: 'State',
                                    textEditingController: qn.supplierState,
                                    scrollPadding: 50,
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                  ),
                                  AddNewLabelTextField(
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                    labelText: 'Country',
                                    textEditingController: qn.supplierCountry,
                                    scrollPadding: 50,
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                  ),
                                  AddNewLabelTextField(
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                    labelText: 'Zipcode',
                                    textEditingController: qn.supplierZipcode,
                                    scrollPadding: 50,
                                    textInputType: TextInputType.number,
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                  ),
                                  AddNewLabelTextField(
                                    labelText: 'Contact Number',
                                    textEditingController: qn.supplierContactNumber,
                                    scrollPadding: 50,
                                    textInputType: TextInputType.number,
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                  ),
                                  AddNewLabelTextField(
                                    labelText: 'Email',
                                    textEditingController: qn.supplierEmail,
                                    scrollPadding: 50,
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                  ),
                                  AddNewLabelTextField(
                                    labelText: 'GST Number',
                                    textEditingController: qn.supplierGstNo,
                                    scrollPadding: 50,
                                    onEditComplete: (){
                                      node.unfocus();
                                    },
                                  ),



                                  ////////////////////////////////////  MATERIALS LIST ///////////////////////

                                  Container(
                                   /* duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn,*/
                                    height: qn.supplierMaterialMappingList.length==0?0:qn.supplierMaterialMappingList.length*50.0,
                                    padding: EdgeInsets.fromLTRB(10,5,10,5),

                                    width: SizeConfig.screenWidth,
                                    margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:SizeConfig.height20,),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          qn.supplierMaterialMappingList.length==0?BoxShadow():
                                          BoxShadow(
                                            color: AppTheme.addNewTextFieldText.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 15,
                                            offset: Offset(0, 0), // changes position of shadow
                                          )
                                        ]
                                    ),
                                    child: ListView.builder(
                                      itemCount: qn.supplierMaterialMappingList.length,
                                      itemBuilder: (context,index){
                                        return SlideTransition(
                                          position: Tween<Offset>(begin: Offset(qn.isSupplierEdit?0.0: 0.0, qn.isSupplierEdit?0.0: 1.0), end: Offset.zero)
                                              .animate(qn.supplierMaterialMappingList[index].scaleController),
                                          // scale: Tween(begin:qn.isSupplierEdit?1.0: 0.0, end:qn.isSupplierEdit?0.0: 1.0)
                                          //     .animate(qn.supplierMaterialMappingList[index].scaleController),
                                          child: FadeTransition(
                                            opacity: Tween(begin: qn.isSupplierEdit?1.0: 0.0, end: qn.isSupplierEdit?0.0: 1.0)
                                                .animate(qn.supplierMaterialMappingList[index].scaleController),
                                            child: Container(
                                              padding: EdgeInsets.only(top: 5,bottom: 5),
                                              decoration: BoxDecoration(
                                                  border: Border(bottom: BorderSide(color: AppTheme.addNewTextFieldBorder.withOpacity(0.5)))
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: SizeConfig.width80,
                                                    child: Text("${qn.supplierMaterialMappingList[index].MaterialName}",
                                                      style: TextStyle(fontSize: 14,fontFamily: 'RR',color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 5),
                                                    alignment: Alignment.centerLeft,
                                                    width: SizeConfig.width80,
                                                    child: Text("${qn.supplierMaterialMappingList[index].MaterialPrice}",
                                                      style: TextStyle(fontSize: 14,fontFamily: 'RR',color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                                    ),
                                                  ),
                                                  Container(

                                                    alignment: Alignment.centerRight,
                                                    width: SizeConfig.width70+SizeConfig.width5,
                                                    child: Text("${qn.supplierMaterialMappingList[index].UnitName}",
                                                      style: TextStyle(fontSize: 14,fontFamily: 'RR',color: AppTheme.gridTextColor,letterSpacing: 0.2),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){

                                                        if(qn.isSupplierEdit){
                                                          qn.supplierMaterialMappingList[index].scaleController.forward().whenComplete(() {
                                                            setState(() {
                                                              qn.supplierMaterialMappingList.removeAt(index);
                                                            });
                                                          });
                                                        }
                                                        else{
                                                          qn.supplierMaterialMappingList[index].scaleController.reverse().whenComplete(() {
                                                            setState(() {
                                                              qn.supplierMaterialMappingList.removeAt(index);
                                                            });
                                                          });
                                                        }




                                                    },
                                                    child: Container(
                                                        height: 25,
                                                        width: 25,
                                                        child: Icon(Icons.delete,color:Colors.red)
                                                    ),
                                                  ),

                                                ],
                                              ),

                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),




                                  Stack(
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
                                          height: SizeConfig.height50,
                                          width: SizeConfig.width140,
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              border: Border.all(color: AppTheme.addNewTextFieldBorder),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(qn.supplierMaterialName==null? "Select Material":qn.supplierMaterialName,
                                                style: TextStyle(fontFamily: 'RR',fontSize: 16,
                                                    color: qn.supplierMaterialName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,),
                                              ),
                                              Spacer(),
                                              Container(
                                                  height: SizeConfig.height25,
                                                  width: SizeConfig.height25,
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
                                          width: SizeConfig.width130,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(top:SizeConfig.height20,right: SizeConfig.width20),
                                          child: TextFormField(

                                            scrollPadding: EdgeInsets.only(bottom: 100),
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
                                            Timer(Duration(milliseconds: 300), (){
                                              setState(() {
                                                qn.supplierMaterialMappingList.add(
                                                    SupplierMaterialMappingListModel(
                                                        MaterialId: qn.supplierMaterialId,
                                                        MaterialName: qn.supplierMaterialName,
                                                        MaterialPrice: double.parse(qn.materialPrice.text??"0.0") ,
                                                        UnitName: qn.supplierMaterialUnitName,
                                                        SupplierId: null,
                                                        SupplierMaterialMappingId: null,
                                                        IsActive: 1,
                                                        scaleController: AnimationController(duration: Duration(milliseconds: 300), vsync: this)
                                                    )
                                                );
                                              });

                                              if(qn.isSupplierEdit){
                                                qn.supplierMaterialMappingList[qn.supplierMaterialMappingList.length-1].scaleController.reverse().then((value){
                                                  listViewController.animateTo(listViewController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                  qn.clearMappingList();
                                                });
                                              }
                                              else{
                                                qn.supplierMaterialMappingList[qn.supplierMaterialMappingList.length-1].scaleController.forward().then((value){
                                                  listViewController.animateTo(listViewController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                                  qn.clearMappingList();
                                                });
                                              }




                                            });

                                          },
                                          child: Container(
                                            height: SizeConfig.height40,
                                            width: SizeConfig.height40,
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
                      IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                         qn.clearForm();
                        Navigator.pop(context);
                      }),
                      SizedBox(width: SizeConfig.width5,),
                      Text("Supplier Detail",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                      ),
                      Text(qn.isSupplierEdit?" / Edit":" / Add New",
                        style: TextStyle(fontFamily: 'RR',color: Colors.black,fontSize: SizeConfig.width16),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height:_keyboardVisible?0: SizeConfig.height70,
                    width: SizeConfig.screenWidth,
                    color: AppTheme.grey,
                    child: Center(
                      child: GestureDetector(
                        onTap: (){
                          node.unfocus();
                          qn.InsertSupplierDbHit(context,this);

                        },
                        child: Container(
                          height: SizeConfig.height50,
                          width: SizeConfig.width120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(SizeConfig.height25),
                              color: AppTheme.bgColor
                          ),
                          child: Center(
                            child: Text(qn.isSupplierEdit?"Update":"Save",style: AppTheme.TSWhite20,),
                          ),
                        ),
                      ),
                    ),
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
                      transform: Matrix4.translationValues(supplierCategoryOpen?0:SizeConfig.screenWidth, 0, 0),

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
                                          supplierCategoryOpen=false;
                                        });
                                      }),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text('Select Supplier Category',style:TextStyle(color:Colors.black,fontFamily: 'RR',fontSize:16),)),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.height10,),
                              Container(
                                height: SizeConfig.screenHeight*(300/720),
                                /*color: Colors.red,*/
                                margin: EdgeInsets.only(left: SizeConfig.width30,right: SizeConfig.width30),
                                child: ListView.builder(
                                  itemCount: qn.supplierCategoryList.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          qn.supplierCategoryId=qn.supplierCategoryList[index].supplierCategoryId;
                                          qn.supplierCategoryName=qn.supplierCategoryList[index].supplierCategoryName;
                                          supplierCategoryOpen=false;
                                        });

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            borderRadius:BorderRadius.circular(8),
                                            border: Border.all(color: qn.supplierCategoryId==null? AppTheme.addNewTextFieldBorder:qn.supplierCategoryId==qn.supplierCategoryList[index].supplierCategoryId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                            color: qn.supplierCategoryId==null? Colors.white: qn.supplierCategoryId==qn.supplierCategoryList[index].supplierCategoryId?AppTheme.popUpSelectedColor:Colors.white
                                        ),
                                        width:300,
                                        height:50,
                                        child: Text("${qn.supplierCategoryList[index].supplierCategoryName}",
                                          style: TextStyle(color:qn.supplierCategoryId==null? AppTheme.grey:qn.supplierCategoryId==qn.supplierCategoryList[index].supplierCategoryId?Colors.white:AppTheme.grey,
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

///////////////////////////////////////      SUPPLIER MATERIAL ////////////////////////////////
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
                      transform: Matrix4.translationValues(supplierMaterialOpen?0:SizeConfig.screenWidth, 0, 0),

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
                                          supplierMaterialOpen=false;
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
                                  itemCount: qn.supplierCategoryList.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          qn.supplierMaterialId=qn.supplierMaterialList[index].materialId;
                                          qn.supplierMaterialName=qn.supplierMaterialList[index].materialName;
                                          qn.supplierMaterialUnitName=qn.supplierMaterialList[index].UnitName;
                                          supplierMaterialOpen=false;
                                        });

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            borderRadius:BorderRadius.circular(8),
                                            border: Border.all(color: qn.supplierMaterialId==null? AppTheme.addNewTextFieldBorder:qn.supplierMaterialId==qn.supplierMaterialList[index].materialId?Colors.transparent: AppTheme.addNewTextFieldBorder),
                                            color: qn.supplierMaterialId==null? Colors.white: qn.supplierMaterialId==qn.supplierMaterialList[index].materialId?AppTheme.popUpSelectedColor:Colors.white
                                        ),
                                        width:300,
                                        height:50,
                                        child: Text("${qn.supplierMaterialList[index].materialName}",
                                          style: TextStyle(color:qn.supplierMaterialId==null? AppTheme.grey:qn.supplierMaterialId==qn.supplierMaterialList[index].materialId?Colors.white:AppTheme.grey,
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
            )
        )

    );
  }
}






