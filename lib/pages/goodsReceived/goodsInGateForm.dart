
import 'dart:async';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';


import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/references/bottomNavi.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/bottomBarAddButton.dart';
import 'package:quarry/widgets/customTextField.dart';
import 'package:quarry/widgets/sidePopUp/noModel/sidePopUpSearchNoModel.dart';

import 'goodsReceivedGrid.dart';





class GoodsInGateForm extends StatefulWidget {

  @override
  GoodsInGateFormState createState() => GoodsInGateFormState();
}

class GoodsInGateFormState extends State<GoodsInGateForm> with TickerProviderStateMixin{

  bool isEdit=false;


  ScrollController scrollController;
  ScrollController listViewController;

  bool _keyboardVisible=false;
  bool isVehicleTypeOpen=false;
  bool isListScroll=false;

  TextEditingController searchController = new TextEditingController();
  PickedFile _image;

  @override
  void initState() {
    isEdit=false;
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
                  physics: NeverScrollableScrollPhysics(),
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
                            padding: EdgeInsets.only(top: 20,bottom: 60),
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
                                children: [
                                     SvgPicture.asset("assets/goodsIcons/goods-in.svg",height: 40,width: 100,),
                                      SizedBox(height: 10,),
                                      gr.IGF_Materials.isEmpty?Container(): Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("${gr.IGF_Materials[gr.IGF_Materials.length-1].materialName} - ${gr.IGF_Materials[gr.IGF_Materials.length-1].quantity}",
                                            style: TextStyle(fontFamily: 'RM',color: AppTheme.bgColor,fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                          Padding(
                                            padding:  EdgeInsets.only(bottom: 2),
                                            child: Text(" ${gr.IGF_Materials[gr.IGF_Materials.length-1].unitName}",
                                              style: TextStyle(fontFamily: 'RR',color: AppTheme.hintColor,fontSize: 14),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                      AddNewLabelTextField(
                                        textEditingController: gr.vehicleNo,
                                        labelText: "Vehicle Number",
                                        ontap: (){
                                          setState(() {
                                            _keyboardVisible=true;
                                          });
                                        },
                                        onEditComplete: (){
                                          node.unfocus();
                                          Timer(Duration(milliseconds: 50), (){
                                            setState(() {
                                              _keyboardVisible=false;
                                            });
                                          });
                                        },
                                      ),
                                  GestureDetector(
                                    onTap: (){
                                      node.unfocus();

                                      Timer(Duration(milliseconds: 50), (){
                                        setState(() {
                                          _keyboardVisible=false;
                                        });
                                      });
                                      setState(() {
                                        isVehicleTypeOpen=true;
                                      });
                                    },
                                    child: SidePopUpParent(
                                      text: gr.selectedVehicleTypeName==null? "Select Vehicle Type":gr.selectedVehicleTypeName,
                                      textColor: gr.selectedVehicleTypeName==null? AppTheme.addNewTextFieldText.withOpacity(0.5):AppTheme.addNewTextFieldText,
                                      iconColor: gr.selectedVehicleTypeName==null? AppTheme.addNewTextFieldText:AppTheme.yellowColor,
                                      bgColor: gr.selectedVehicleTypeName==null? AppTheme.disableColor:Colors.white,

                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async{


                                        setState(() {
                                          gr.scanWeight="";
                                        });

                                        final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
                                        gr.updateGoodsLoader(true);
                                        setState(() async {
                                          if (pickedFile != null) {
                                            _image = pickedFile;
                                            final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(File(_image.path));
                                            final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
                                            final VisionText visionText = await textRecognizer.processImage(visionImage);

                                            for (TextBlock block in visionText.blocks) {
                                              for (TextLine line in block.lines) {

                                                if( RegExp(r'^\d+\.?\d').hasMatch(line.text)){
                                                  print(line.text);
                                                  gr.scanWeight += line.text;

                                                }

                                              }
                                            }
                                            if(gr.scanWeight.isEmpty){
                                              gr.scanWeight="ReCapture Clearly";
                                              gr.loadedWeight.clear();
                                              gr.updateGoodsLoader(false);

                                            }else{
                                              gr.loadedWeight.text=gr.scanWeight;
                                              gr.updateGoodsLoader(false);

                                            }

                                          } else {
                                            gr.updateGoodsLoader(false);
                                            print('No image selected');
                                          }
                                        });



                                    },
                                    child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(left:SizeConfig.width20,right:SizeConfig.width20,top:15,),
                                      width:SizeConfig.screenWidth,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color: Colors.white,
                                          border: Border.all(color: AppTheme.addNewTextFieldBorder)
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          SizedBox(width:10),
                                          Text("${gr.scanWeight.isEmpty?"Scan Weight of Vehicle":gr.scanWeight}",style: TextStyle(fontFamily: 'RR',fontSize: 15,color: AppTheme.addNewTextFieldText,),),
                                          Spacer(),
                                          Icon(Icons.camera_alt_outlined,size: 30,color: AppTheme.addNewTextFieldText,),
                                          SizedBox(width:10)
                                        ],
                                      ),
                                    ),
                                  ),
                                  AddNewLabelTextField(
                                    textEditingController: gr.loadedWeight,
                                    labelText: "Loaded Weight",
                                    ontap: (){
                                      scrollController.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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
                                    textInputType: TextInputType.number,
                                  ),
                                ],
                              ),
                            )
                        ),
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
                    if(gr.vehicleNo.text.isEmpty){
                      CustomAlert().commonErrorAlert(context, "Enter Vehicle Number", "");
                    }
                    else if(gr.loadedWeight.text.isEmpty){
                      CustomAlert().commonErrorAlert(context, "Enter Loaded Weight", "");
                    }
                    else{
                      if(gr.ML_GoodsorderId==0){
                        gr.InsertGoodsDbHit(context,GoodsReceivedGridState());
                      }
                      else{
                        List js=[];
                        js=gr.IGF_Materials.map((e) => e.toJsonInWard(gr.selectedVehicleTypeId,
                            gr.vehicleNo.text,
                            double.parse(gr.loadedWeight.text))
                        ).toList();
                        print("Update-$js");
                        gr.UpdateGoodsDbHit(context,js,GoodsReceivedGridState());
                      }
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
                        gr.IGF_clear();

                      },
                    ),
                    SizedBox(width: SizeConfig.width5,),
                    Text("InGate Form",
                      style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 16),
                    ),

                    Spacer(),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text("${gr.ML_PorderNo}",
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


              Container(
                height: isVehicleTypeOpen ? SizeConfig.screenHeight:0,
                width: isVehicleTypeOpen ? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),
              ),


  ///////////////////////////////////////    VEHICLE TYPE    ////////////////////////////////
              PopUpSearchOnly2(
                isOpen: isVehicleTypeOpen,
                searchController: searchController,

                searchHintText:"Search Vehicle Type",

                dataList:gr.filterVehicleTypeList,
                propertyKeyId:"VehicleTypeId",
                propertyKeyName: "VehicleTypeName",
                selectedId: gr.selectedVehicleTypeId,

                searchOnchange: (v){
                  gr.searchVehicleType(v.toLowerCase());
                },
                itemOnTap: (index){
                  node.unfocus();
                  setState(() {


                    gr.selectedVehicleTypeId=gr.filterVehicleTypeList[index]['VehicleTypeId'];
                    gr.selectedVehicleTypeName=gr.filterVehicleTypeList[index]['VehicleTypeName'];
                    isVehicleTypeOpen=false;
                    gr.filterVehicleTypeList=gr.vehicleTypeList;

                  });
                  searchController.clear();
                },
                closeOnTap: (){
                  node.unfocus();
                  setState(() {
                    isVehicleTypeOpen=false;
                  });
                  gr.filterVehicleTypeList=gr.vehicleTypeList;
                  searchController.clear();
                },
              ),


            ],
          )
      ),
    );
  }

}

